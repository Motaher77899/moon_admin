
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../providers/tournament_provider.dart';
import '../../providers/match_provider.dart';
import '../../providers/auth_provider.dart';
import '../../models/tournament_model.dart';
import '../../models/team_model.dart';

class CreateTournamentScreen extends StatefulWidget {
  const CreateTournamentScreen({Key? key}) : super(key: key);

  @override
  State<CreateTournamentScreen> createState() => _CreateTournamentScreenState();
}

class _CreateTournamentScreenState extends State<CreateTournamentScreen> {
  final _formKey = GlobalKey<FormState>();
  final DateFormat _dateFormat = DateFormat('dd MMM yyyy');

  // Form fields
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  DateTime _startDate = DateTime.now();
  DateTime _endDate = DateTime.now().add(const Duration(days: 30));

  // Tournament settings
  String _format = 'groups'; // 'groups', 'knockout', 'league'
  int _numberOfGroups = 2;
  int _teamsPerGroup = 4;
  int _qualifiedTeamsPerGroup = 2;
  bool _hasKnockoutStage = true;
  int _matchDuration = 90;

  // Selected teams with group assignment
  List<String> _selectedTeamIds = [];
  Map<String, String?> _teamToGroupMap = {}; // teamId -> groupName
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<MatchProvider>(context, listen: false).loadTeams();
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  List<String> get _availableGroups {
    return List.generate(_numberOfGroups, (i) => 'Group ${String.fromCharCode(65 + i)}');
  }

  Future<void> _selectDate(BuildContext context, bool isStartDate) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: isStartDate ? _startDate : _endDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: Colors.orange.shade700,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        if (isStartDate) {
          _startDate = picked;
          if (_endDate.isBefore(_startDate)) {
            _endDate = _startDate.add(const Duration(days: 30));
          }
        } else {
          _endDate = picked;
        }
      });
    }
  }

  Future<void> _createTournament() async {
    if (!_formKey.currentState!.validate()) return;

    if (_selectedTeamIds.length < 2) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('অন্তত ২টি টিম নির্বাচন করুন'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // Validate group configuration
    if (_format == 'groups') {
      int totalTeamsNeeded = _numberOfGroups * _teamsPerGroup;
      if (_selectedTeamIds.length < totalTeamsNeeded) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              '$_numberOfGroups টি গ্রুপে $_teamsPerGroup টি করে টিম দরকার (মোট: $totalTeamsNeeded)',
            ),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      // Check if all teams have groups assigned
      for (String teamId in _selectedTeamIds) {
        if (_teamToGroupMap[teamId] == null) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('সব টিমের জন্য গ্রুপ নির্বাচন করুন'),
              backgroundColor: Colors.red,
            ),
          );
          return;
        }
      }
    }

    setState(() => _isLoading = true);

    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final tournamentProvider = Provider.of<TournamentProvider>(context, listen: false);

    TournamentModel tournament = TournamentModel(
      name: _nameController.text.trim(),
      description: _descriptionController.text.trim(),
      startDate: _startDate,
      endDate: _endDate,
      status: 'upcoming',
      teamIds: _selectedTeamIds,
      createdBy: authProvider.currentAdmin?.fullName ?? 'Unknown',
      createdAt: DateTime.now(),
      format: _format,
      numberOfGroups: _numberOfGroups,
      teamsPerGroup: _teamsPerGroup,
      qualifiedTeamsPerGroup: _qualifiedTeamsPerGroup,
      hasKnockoutStage: _hasKnockoutStage,
      matchDuration: _matchDuration,
    );

    final error = await _createTournamentWithGroups(
      tournament,
      authProvider.currentAdmin?.fullName ?? 'Unknown',
      tournamentProvider,
    );

    setState(() => _isLoading = false);

    if (error != null) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(error), backgroundColor: Colors.red),
      );
    } else {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('টুর্নামেন্ট সফলভাবে তৈরি হয়েছে'),
          backgroundColor: Colors.green,
        ),
      );
      Navigator.pop(context);
    }
  }

  Future<String?> _createTournamentWithGroups(
      TournamentModel tournament,
      String adminFullName,
      TournamentProvider tournamentProvider,
      ) async {
    try {
      Map<String, dynamic> tournamentData = tournament.toFirestore();
      tournamentData['createdBy'] = adminFullName;

      DocumentReference docRef = await FirebaseFirestore.instance
          .collection('tournaments')
          .add(tournamentData);

      String tournamentId = docRef.id;
      debugPrint('✅ Tournament created: $tournamentId');

      if (tournament.format == 'groups') {
        await _createGroupsWithAssignment(tournamentId);
      }

      await _initializeTeamStatsLocal(tournamentId, tournament.teamIds);
      await tournamentProvider.loadTournamentsByAdmin(adminFullName);
      return null;
    } catch (e) {
      debugPrint('❌ Error creating tournament: $e');
      return 'টুর্নামেন্ট তৈরি করতে সমস্যা: $e';
    }
  }

  Future<void> _createGroupsWithAssignment(String tournamentId) async {
    try {
      Map<String, List<String>> groupTeams = {};

      for (String teamId in _selectedTeamIds) {
        String? groupName = _teamToGroupMap[teamId];
        if (groupName != null) {
          if (!groupTeams.containsKey(groupName)) {
            groupTeams[groupName] = [];
          }
          groupTeams[groupName]!.add(teamId);
        }
      }

      int order = 0;
      for (String groupName in groupTeams.keys.toList()..sort()) {
        TournamentGroup group = TournamentGroup(
          tournamentId: tournamentId,
          groupName: groupName,
          teamIds: groupTeams[groupName]!,
          groupOrder: order,
        );

        await FirebaseFirestore.instance
            .collection('tournament_groups')
            .add(group.toFirestore());

        debugPrint('✅ Created $groupName with ${groupTeams[groupName]!.length} teams');
        order++;
      }
    } catch (e) {
      debugPrint('❌ Error creating groups: $e');
    }
  }

  Future<void> _initializeTeamStatsLocal(
      String tournamentId,
      List<String> teamIds,
      ) async {
    try {
      for (String teamId in teamIds) {
        DocumentSnapshot teamDoc = await FirebaseFirestore.instance
            .collection('teams')
            .doc(teamId)
            .get();

        if (teamDoc.exists) {
          Map<String, dynamic> teamData =
          teamDoc.data() as Map<String, dynamic>;

          TournamentTeamStats stats = TournamentTeamStats(
            tournamentId: tournamentId,
            teamId: teamId,
            teamName: teamData['name'] ?? '',
            teamLogo: teamData['logoUrl'],
            groupName: _teamToGroupMap[teamId],
          );

          await FirebaseFirestore.instance
              .collection('tournament_team_stats')
              .add(stats.toFirestore());

          debugPrint('✅ Initialized stats for team: ${stats.teamName} in ${stats.groupName}');
        }
      }
    } catch (e) {
      debugPrint('❌ Error initializing team stats: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('নতুন টুর্নামেন্ট তৈরি করুন'),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.orange.shade600, Colors.orange.shade800],
            ),
          ),
        ),
        foregroundColor: Colors.white,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            _buildSectionHeader('টুর্নামেন্টের নাম'),
            TextFormField(
              controller: _nameController,
              decoration: InputDecoration(
                hintText: 'যেমন: গ্রীষ্মকালীন চ্যাম্পিয়নশিপ ২০২৫',
                prefixIcon: const Icon(Icons.emoji_events),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'টুর্নামেন্টের নাম দিন';
                }
                return null;
              },
            ),
            const SizedBox(height: 20),

            _buildSectionHeader('বিবরণ'),
            TextFormField(
              controller: _descriptionController,
              decoration: InputDecoration(
                hintText: 'টুর্নামেন্ট সম্পর্কে কিছু লিখুন...',
                prefixIcon: const Icon(Icons.description),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              maxLines: 3,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'বিবরণ দিন';
                }
                return null;
              },
            ),
            const SizedBox(height: 20),

            _buildSectionHeader('সময়কাল'),
            Row(
              children: [
                Expanded(
                  child: _buildDateSelector(
                    label: 'শুরুর তারিখ',
                    date: _startDate,
                    onTap: () => _selectDate(context, true),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildDateSelector(
                    label: 'শেষের তারিখ',
                    date: _endDate,
                    onTap: () => _selectDate(context, false),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            _buildSectionHeader('ফরম্যাট'),
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  RadioListTile<String>(
                    title: const Text('গ্রুপ পর্ব + নকআউট'),
                    subtitle: const Text('গ্রুপে ভাগ করে তারপর নকআউট'),
                    value: 'groups',
                    groupValue: _format,
                    onChanged: (value) {
                      setState(() => _format = value!);
                    },
                    activeColor: Colors.orange.shade700,
                  ),
                  const Divider(height: 1),
                  RadioListTile<String>(
                    title: const Text('সরাসরি নকআউট'),
                    subtitle: const Text('কোন গ্রুপ পর্ব নেই'),
                    value: 'knockout',
                    groupValue: _format,
                    onChanged: (value) {
                      setState(() => _format = value!);
                    },
                    activeColor: Colors.orange.shade700,
                  ),
                  const Divider(height: 1),
                  RadioListTile<String>(
                    title: const Text('লিগ (রাউন্ড রবিন)'),
                    subtitle: const Text('সবাই সবার সাথে খেলবে'),
                    value: 'league',
                    groupValue: _format,
                    onChanged: (value) {
                      setState(() => _format = value!);
                    },
                    activeColor: Colors.orange.shade700,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            if (_format == 'groups') ...[
              _buildSectionHeader('গ্রুপ সেটিংস'),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.orange.shade50,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.orange.shade200),
                ),
                child: Column(
                  children: [
                    _buildNumberSelector(
                      label: 'গ্রুপ সংখ্যা',
                      value: _numberOfGroups,
                      min: 1,
                      max: 8,
                      onChanged: (value) {
                        setState(() => _numberOfGroups = value);
                      },
                    ),
                    const SizedBox(height: 16),
                    _buildNumberSelector(
                      label: 'প্রতি গ্রুপে টিম',
                      value: _teamsPerGroup,
                      min: 2,
                      max: 8,
                      onChanged: (value) {
                        setState(() => _teamsPerGroup = value);
                      },
                    ),
                    const SizedBox(height: 16),
                    _buildNumberSelector(
                      label: 'যোগ্যতা অর্জনকারী টিম',
                      value: _qualifiedTeamsPerGroup,
                      min: 1,
                      max: _teamsPerGroup,
                      onChanged: (value) {
                        setState(() => _qualifiedTeamsPerGroup = value);
                      },
                    ),
                    const SizedBox(height: 16),
                    SwitchListTile(
                      title: const Text('নকআউট পর্ব থাকবে?'),
                      value: _hasKnockoutStage,
                      onChanged: (value) {
                        setState(() => _hasKnockoutStage = value);
                      },
                      activeColor: Colors.orange.shade700,
                      contentPadding: EdgeInsets.zero,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
            ],

            _buildSectionHeader('ম্যাচের সময় (মিনিট)'),
            _buildNumberSelector(
              label: 'মিনিট',
              value: _matchDuration,
              min: 30,
              max: 120,
              step: 15,
              onChanged: (value) {
                setState(() => _matchDuration = value);
              },
            ),
            const SizedBox(height: 20),

            _buildSectionHeader(
                'টিম নির্বাচন করুন (${_selectedTeamIds.length} টি নির্বাচিত)'),
            _buildTeamSelectionWithGroups(),
            const SizedBox(height: 30),

            ElevatedButton(
              onPressed: _createTournament,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange.shade700,
                minimumSize: const Size(double.infinity, 55),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                'টুর্নামেন্ট তৈরি করুন',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Colors.grey.shade800,
        ),
      ),
    );
  }

  Widget _buildDateSelector({
    required String label,
    required DateTime date,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade300),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey.shade600,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(Icons.calendar_today,
                    size: 20, color: Colors.orange.shade700),
                const SizedBox(width: 8),
                Text(
                  _dateFormat.format(date),
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNumberSelector({
    required String label,
    required int value,
    required int min,
    required int max,
    int step = 1,
    required ValueChanged<int> onChanged,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w600,
          ),
        ),
        Row(
          children: [
            IconButton(
              icon: const Icon(Icons.remove_circle_outline),
              onPressed: value > min
                  ? () => onChanged((value - step).clamp(min, max))
                  : null,
              color: Colors.orange.shade700,
            ),
            Container(
              width: 50,
              height: 40,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.orange.shade300),
              ),
              child: Center(
                child: Text(
                  '$value',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.orange.shade700,
                  ),
                ),
              ),
            ),
            IconButton(
              icon: const Icon(Icons.add_circle_outline),
              onPressed: value < max
                  ? () => onChanged((value + step).clamp(min, max))
                  : null,
              color: Colors.orange.shade700,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildTeamSelectionWithGroups() {
    return Consumer<MatchProvider>(
      builder: (context, matchProvider, child) {
        if (matchProvider.teams.isEmpty) {
          return Container(
            padding: const EdgeInsets.all(32),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade300),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(
              child: Text(
                'কোন টিম পাওয়া যায়নি',
                style: TextStyle(color: Colors.grey.shade600),
              ),
            ),
          );
        }

        return Container(
          constraints: const BoxConstraints(maxHeight: 500),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade300),
            borderRadius: BorderRadius.circular(12),
          ),
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: matchProvider.teams.length,
            itemBuilder: (context, index) {
              TeamModel team = matchProvider.teams[index];
              bool isSelected = _selectedTeamIds.contains(team.id);  // ✅ Changed from teamId

              return Column(
                children: [
                  CheckboxListTile(
                    value: isSelected,
                    onChanged: (value) {
                      setState(() {
                        if (value == true) {
                          _selectedTeamIds.add(team.id);  // ✅ Changed from teamId
                          if (_format == 'groups') {
                            _teamToGroupMap[team.id] = _availableGroups.first;  // ✅ Changed from teamId
                          }
                        } else {
                          _selectedTeamIds.remove(team.id);  // ✅ Changed from teamId
                          _teamToGroupMap.remove(team.id);  // ✅ Changed from teamId
                        }
                      });
                    },
                    activeColor: Colors.orange.shade700,
                    title: Text(
                      team.name,
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                    subtitle: team.description != null
                        ? Text(
                      team.description!,
                      style: TextStyle(fontSize: 11, color: Colors.grey.shade600),
                    )
                        : null,
                    secondary: team.logoUrl != null && team.logoUrl!.isNotEmpty
                        ? ClipRRect(
                      borderRadius: BorderRadius.circular(6),
                      child: Image.network(
                        team.logoUrl!,
                        width: 40,
                        height: 40,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            width: 40,
                            height: 40,
                            color: Colors.grey.shade200,
                            child: Icon(Icons.shield,
                                size: 20, color: Colors.grey.shade400),
                          );
                        },
                      ),
                    )
                        : Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade200,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Icon(Icons.shield,
                          size: 20, color: Colors.grey.shade400),
                    ),
                  ),

                  if (isSelected && _format == 'groups')
                    Padding(
                      padding: const EdgeInsets.only(left: 72, right: 16, bottom: 12),
                      child: DropdownButtonFormField<String>(
                        value: _teamToGroupMap[team.id],  // ✅ Changed from teamId
                        decoration: InputDecoration(
                          labelText: 'গ্রুপ নির্বাচন করুন',
                          labelStyle: const TextStyle(fontSize: 12),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 8,
                          ),
                          filled: true,
                          fillColor: Colors.orange.shade50,
                        ),
                        items: _availableGroups.map((group) {
                          return DropdownMenuItem(
                            value: group,
                            child: Text(group),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            _teamToGroupMap[team.id] = value;  // ✅ Changed from teamId
                          });
                        },
                      ),
                    ),

                  Divider(height: 1, color: Colors.grey.shade200),
                ],
              );
            },
          ),
        );
      },
    );
  }
}