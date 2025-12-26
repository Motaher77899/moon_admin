
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../providers/auth_provider.dart';
import '../../providers/match_provider.dart';
import '../../models/match_model.dart';
import '../../models/team_model.dart';

class CreateSingleMatchScreen extends StatefulWidget {
  const CreateSingleMatchScreen({Key? key}) : super(key: key);

  @override
  State<CreateSingleMatchScreen> createState() => _CreateSingleMatchScreenState();
}

class _CreateSingleMatchScreenState extends State<CreateSingleMatchScreen> {
  final _formKey = GlobalKey<FormState>();
  final _venueController = TextEditingController();

  TeamModel? _selectedTeamA;
  TeamModel? _selectedTeamB;
  DateTime _selectedDate = DateTime.now();
  TimeOfDay _selectedTime = TimeOfDay.now();
  bool _isLoading = false;

  @override
  void dispose() {
    _venueController.dispose();
    super.dispose();
  }

  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      builder: (context, child) => Theme(
        data: ThemeData.light().copyWith(
          primaryColor: Colors.orange.shade700,
          colorScheme: const ColorScheme.light(primary: Colors.orange),
        ),
        child: child!,
      ),
    );
    if (picked != null && mounted) {
      setState(() => _selectedDate = picked);
    }
  }

  Future<void> _selectTime() async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime,
      builder: (context, child) => Theme(
        data: ThemeData.light().copyWith(
          primaryColor: Colors.orange.shade700,
          colorScheme: const ColorScheme.light(primary: Colors.orange),
        ),
        child: child!,
      ),
    );
    if (picked != null && mounted) {
      setState(() => _selectedTime = picked);
    }
  }

  Future<void> _createMatch() async {
    if (!_formKey.currentState!.validate()) return;

    if (_selectedTeamA == null || _selectedTeamB == null) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('দুটি টিম সিলেক্ট করুন'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    if (_selectedTeamA!.id == _selectedTeamB!.id) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('একই টিম দুইবার সিলেক্ট করা যাবে না'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final matchProvider = Provider.of<MatchProvider>(context, listen: false);

      final String adminFullName = authProvider.currentAdmin?.fullName ?? 'Unknown Admin';

      final DateTime matchDateTime = DateTime(
        _selectedDate.year,
        _selectedDate.month,
        _selectedDate.day,
        _selectedTime.hour,
        _selectedTime.minute,
      );

      final MatchModel newMatch = MatchModel(
        id: '',
        teamA: _selectedTeamA!.id,
        teamB: _selectedTeamB!.id,
        teamAName: _selectedTeamA!.name,
        teamBName: _selectedTeamB!.name,
        teamALogo: _selectedTeamA!.logoUrl,
        teamBLogo: _selectedTeamB!.logoUrl,
        scoreA: 0,
        scoreB: 0,
        date: matchDateTime,
        time: matchDateTime,
        status: 'upcoming',
        venue: _venueController.text.trim().isEmpty
            ? 'স্টেডিয়াম নির্ধারিত হয়নি'
            : _venueController.text.trim(),
        adminFullName: adminFullName,
        createdBy: adminFullName,
        createdAt: DateTime.now(),
        timeline: [],
      );

      final error = await matchProvider.createMatch(newMatch, adminFullName);

      if (!mounted) return;

      if (error == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('ম্যাচ সফলভাবে তৈরি হয়েছে!'),
            backgroundColor: Colors.green,
            behavior: SnackBarBehavior.floating,
          ),
        );
        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('ত্রুটি: $error'),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('অজানা ত্রুটি: $e'),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
        ),
      );
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('সিঙ্গেল ম্যাচ তৈরি করুন'),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.orange.shade700, Colors.orange.shade900],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        foregroundColor: Colors.white,
        elevation: 4,
      ),
      body: Consumer<MatchProvider>(
        builder: (context, matchProvider, child) {
          if (matchProvider.isLoading && matchProvider.teams.isEmpty) {
            return const Center(
              child: CircularProgressIndicator(color: Colors.orange),
            );
          }

          if (matchProvider.teams.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.sports_soccer, size: 80, color: Colors.grey.shade400),
                  const SizedBox(height: 20),
                  const Text(
                    'কোনো টিম পাওয়া যায়নি',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.grey),
                  ),
                  const SizedBox(height: 8),
                  const Text('প্রথমে টিম তৈরি করুন', style: TextStyle(color: Colors.grey)),
                ],
              ),
            );
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Team A
                  const Text('টিম A', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  _buildTeamDropdown(
                    value: _selectedTeamA,
                    teams: matchProvider.teams,
                    onChanged: (team) {
                      if (mounted) {
                        setState(() => _selectedTeamA = team);
                      }
                    },
                    hint: 'টিম A সিলেক্ট করুন',
                  ),
                  const SizedBox(height: 24),

                  // Team B
                  const Text('টিম B', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  _buildTeamDropdown(
                    value: _selectedTeamB,
                    teams: matchProvider.teams,
                    onChanged: (team) {
                      if (mounted) {
                        setState(() => _selectedTeamB = team);
                      }
                    },
                    hint: 'টিম B সিলেক্ট করুন',
                  ),
                  const SizedBox(height: 24),

                  // Venue
                  const Text('স্থান (ঐচ্ছিক)', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _venueController,
                    decoration: InputDecoration(
                      hintText: 'যেমন: ঢাকা স্টেডিয়াম',
                      prefixIcon: const Icon(Icons.location_on, color: Colors.orange),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                      filled: true,
                      fillColor: Colors.grey.shade50,
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Date
                  const Text('তারিখ', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  InkWell(
                    onTap: _selectDate,
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade50,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.grey.shade300),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.calendar_today, color: Colors.orange.shade700),
                          const SizedBox(width: 12),
                          Text(
                            DateFormat('dd MMMM yyyy').format(_selectedDate),
                            style: const TextStyle(fontSize: 16),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Time
                  const Text('সময়', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  InkWell(
                    onTap: _selectTime,
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade50,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.grey.shade300),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.access_time, color: Colors.orange.shade700),
                          const SizedBox(width: 12),
                          Text(_selectedTime.format(context), style: const TextStyle(fontSize: 16)),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 40),

                  // Create Button
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : _createMatch,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange.shade700,
                        foregroundColor: Colors.white,
                        elevation: 3,
                        disabledBackgroundColor: Colors.orange.shade300,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      child: _isLoading
                          ? const SizedBox(
                        height: 24,
                        width: 24,
                        child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                      )
                          : const Text(
                        'ম্যাচ তৈরি করুন',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildTeamDropdown({
    required TeamModel? value,
    required List<TeamModel> teams,
    required Function(TeamModel?) onChanged,
    required String hint,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<TeamModel>(
          value: value,
          hint: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                const Icon(Icons.shield, color: Colors.orange),
                const SizedBox(width: 12),
                Text(hint, style: TextStyle(color: Colors.grey.shade600)),
              ],
            ),
          ),
          isExpanded: true,
          items: teams.map((team) {
            return DropdownMenuItem(
              value: team,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    // Team Logo
                    if (team.logoUrl != null && team.logoUrl!.isNotEmpty)
                      ClipRRect(
                        borderRadius: BorderRadius.circular(4),
                        child: Image.network(
                          team.logoUrl!,
                          width: 30,
                          height: 30,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => const Icon(Icons.shield, size: 30, color: Colors.grey),
                        ),
                      )
                    else
                      const Icon(Icons.shield, size: 30, color: Colors.grey),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        team.name,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }
}