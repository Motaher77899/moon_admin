import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../providers/tournament_provider.dart';
import '../../providers/match_provider.dart';
import '../../models/tournament_model.dart';
import '../../models/team_model.dart';

// Import player selection screen
import 'tournament_team_players_screen.dart';

class TournamentTeamsTab extends StatelessWidget {
  final TournamentModel tournament;

  const TournamentTeamsTab({Key? key, required this.tournament})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer2<TournamentProvider, MatchProvider>(
      builder: (context, tournamentProvider, matchProvider, child) {
        // Check if tournament has groups
        if (tournament.format == 'groups' && tournamentProvider.groups.isNotEmpty) {
          return _buildGroupedTeamsView(context, matchProvider, tournamentProvider);
        } else {
          return _buildAllTeamsList(context, matchProvider);
        }
      },
    );
  }

  // Build view with groups (Group A, Group B, etc.)
  Widget _buildGroupedTeamsView(
      BuildContext context,
      MatchProvider matchProvider,
      TournamentProvider tournamentProvider,
      ) {
    // Sort groups alphabetically
    List<TournamentGroup> sortedGroups = List.from(tournamentProvider.groups);
    sortedGroups.sort((a, b) => a.groupName.compareTo(b.groupName));

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: sortedGroups.length,
      itemBuilder: (context, index) {
        TournamentGroup group = sortedGroups[index];
        return _buildGroupCard(context, matchProvider, tournamentProvider, group);
      },
    );
  }

  Widget _buildGroupCard(
      BuildContext context,
      MatchProvider matchProvider,
      TournamentProvider tournamentProvider,
      TournamentGroup group,
      ) {
    List<TeamModel> groupTeams = matchProvider.teams
        .where((team) => group.teamIds.contains(team.id))
        .toList();

    return Card(
      margin: const EdgeInsets.only(bottom: 20),
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Column(
        children: [
          // Group Header
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.orange.shade600, Colors.orange.shade800],
              ),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.white24,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(Icons.workspaces, color: Colors.white, size: 24),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        group.groupName,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${groupTeams.length} টি টিম',
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Teams List
          if (groupTeams.isEmpty)
            Padding(
              padding: const EdgeInsets.all(40),
              child: Column(
                children: [
                  Icon(Icons.groups_outlined, size: 50, color: Colors.grey.shade300),
                  const SizedBox(height: 8),
                  Text(
                    'কোন টিম নেই',
                    style: TextStyle(color: Colors.grey.shade600, fontSize: 15),
                  ),
                ],
              ),
            )
          else
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: groupTeams.length,
              separatorBuilder: (context, index) => Divider(
                height: 1,
                color: Colors.grey.shade200,
              ),
              itemBuilder: (context, index) {
                return _buildTeamTile(
                  context,
                  groupTeams[index],
                  group,
                  tournamentProvider,
                  matchProvider, // ✅ Pass matchProvider
                  index,
                );
              },
            ),
        ],
      ),
    );
  }

  Widget _buildTeamTile(
      BuildContext context,
      TeamModel team,
      TournamentGroup group,
      TournamentProvider tournamentProvider,
      MatchProvider matchProvider, // ✅ Added parameter
      int index,
      ) {
    return Material(
      color: index % 2 == 0 ? Colors.white : Colors.grey.shade50,
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => TournamentTeamPlayersScreen(
                tournamentId: tournament.tournamentId!,
                tournamentName: tournament.name,
                team: team,
                teamProvider: matchProvider, // ✅ Pass matchProvider
              ),
            ),
          );
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            children: [
              // Team Logo
              _buildTeamLogo(team),
              const SizedBox(width: 16),

              // Team Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      team.name,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    if (team.description != null) ...[
                      const SizedBox(height: 4),
                      Text(
                        team.description!,
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                    // Player selection indicator
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        Icon(
                          Icons.people,
                          size: 14,
                          color: Colors.orange.shade700,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          'খেলোয়াড় নির্বাচন করুন',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.orange.shade700,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // Actions
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Change Group Button
                  IconButton(
                    icon: Icon(
                      Icons.swap_horiz,
                      color: Colors.orange.shade700,
                      size: 22,
                    ),
                    onPressed: () {
                      _showChangeGroupDialog(
                        context,
                        team,
                        group,
                        tournamentProvider,
                      );
                    },
                    tooltip: 'গ্রুপ পরিবর্তন করুন',
                  ),

                  // Navigate to Players Icon
                  Icon(
                    Icons.arrow_forward_ios,
                    size: 16,
                    color: Colors.grey.shade400,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTeamLogo(TeamModel team) {
    if (team.logoUrl != null && team.logoUrl!.isNotEmpty) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Image.network(
          team.logoUrl!,
          width: 50,
          height: 50,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            return _buildDefaultLogo();
          },
        ),
      );
    }
    return _buildDefaultLogo();
  }

  Widget _buildDefaultLogo() {
    return Container(
      width: 50,
      height: 50,
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Icon(Icons.shield, color: Colors.grey.shade400, size: 30),
    );
  }

  // Build simple list (for non-group tournaments)
  Widget _buildAllTeamsList(BuildContext context, MatchProvider matchProvider) {
    List<TeamModel> tournamentTeams = matchProvider.teams
        .where((team) => tournament.teamIds.contains(team.id))
        .toList();

    if (tournamentTeams.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.groups_outlined, size: 80, color: Colors.grey.shade300),
            const SizedBox(height: 16),
            Text(
              'কোন টিম নেই',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.grey.shade600,
              ),
            ),
          ],
        ),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: tournamentTeams.length,
      separatorBuilder: (context, index) => Divider(
        height: 1,
        color: Colors.grey.shade200,
      ),
      itemBuilder: (context, index) {
        TeamModel team = tournamentTeams[index];
        return _buildSimpleTeamTile(context, team, matchProvider, index); // ✅ Pass matchProvider
      },
    );
  }

  // Simple team tile with player selection (no groups)
  Widget _buildSimpleTeamTile(
      BuildContext context,
      TeamModel team,
      MatchProvider matchProvider, // ✅ Added parameter
      int index,
      ) {
    return Material(
      color: index % 2 == 0 ? Colors.white : Colors.grey.shade50,
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => TournamentTeamPlayersScreen(
                tournamentId: tournament.tournamentId!,
                tournamentName: tournament.name,
                team: team,
                teamProvider: matchProvider, // ✅ Pass matchProvider instead of null
              ),
            ),
          );
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            children: [
              // Team Logo
              _buildTeamLogo(team),
              const SizedBox(width: 16),

              // Team Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      team.name,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    if (team.description != null) ...[
                      const SizedBox(height: 4),
                      Text(
                        team.description!,
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                    // Player selection indicator
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        Icon(
                          Icons.people,
                          size: 14,
                          color: Colors.orange.shade700,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          'খেলোয়াড় নির্বাচন করুন',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.orange.shade700,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // Navigate Icon
              Icon(
                Icons.arrow_forward_ios,
                size: 16,
                color: Colors.grey.shade400,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _showChangeGroupDialog(
      BuildContext context,
      TeamModel team,
      TournamentGroup currentGroup,
      TournamentProvider tournamentProvider,
      ) async {
    List<TournamentGroup> allGroups = List.from(tournamentProvider.groups);
    allGroups.sort((a, b) => a.groupName.compareTo(b.groupName));

    String? selectedGroup = currentGroup.groupName;

    final result = await showDialog<String>(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              title: Row(
                children: [
                  Icon(Icons.swap_horiz, color: Colors.orange.shade700),
                  const SizedBox(width: 8),
                  const Expanded(child: Text('গ্রুপ পরিবর্তন করুন')),
                ],
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Team info
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        _buildTeamLogo(team),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                team.name,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'বর্তমান: ${currentGroup.groupName}',
                                style: TextStyle(
                                  color: Colors.grey.shade600,
                                  fontSize: 13,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Group selector
                  const Text(
                    'নতুন গ্রুপ নির্বাচন করুন:',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 12),
                  DropdownButtonFormField<String>(
                    value: selectedGroup,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      filled: true,
                      fillColor: Colors.orange.shade50,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                    ),
                    items: allGroups.map((group) {
                      bool isCurrent = group.groupName == currentGroup.groupName;
                      return DropdownMenuItem(
                        value: group.groupName,
                        child: Row(
                          children: [
                            Icon(
                              Icons.workspaces,
                              size: 20,
                              color: isCurrent
                                  ? Colors.grey
                                  : Colors.orange.shade700,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              group.groupName,
                              style: TextStyle(
                                color: isCurrent ? Colors.grey : Colors.black,
                              ),
                            ),
                            if (isCurrent) ...[
                              const SizedBox(width: 8),
                              Text(
                                '(বর্তমান)',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey.shade600,
                                ),
                              ),
                            ],
                          ],
                        ),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() => selectedGroup = value);
                    },
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text(
                    'বাতিল',
                    style: TextStyle(color: Colors.grey.shade700),
                  ),
                ),
                ElevatedButton(
                  onPressed: selectedGroup != null &&
                      selectedGroup != currentGroup.groupName
                      ? () => Navigator.pop(context, selectedGroup)
                      : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange.shade700,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    'পরিবর্তন করুন',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            );
          },
        );
      },
    );

    if (result != null && result != currentGroup.groupName) {
      await _changeTeamGroup(
        context,
        team,
        currentGroup,
        result,
        tournamentProvider,
      );
    }
  }

  Future<void> _changeTeamGroup(
      BuildContext context,
      TeamModel team,
      TournamentGroup oldGroup,
      String newGroupName,
      TournamentProvider tournamentProvider,
      ) async {
    // Show loading
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(
        child: CircularProgressIndicator(),
      ),
    );

    try {
      // Find new group
      TournamentGroup? newGroup = tournamentProvider.groups
          .firstWhere((g) => g.groupName == newGroupName);

      // Remove from old group
      List<String> oldTeamIds = List.from(oldGroup.teamIds);
      oldTeamIds.remove(team.id);

      await FirebaseFirestore.instance
          .collection('tournament_groups')
          .doc(oldGroup.groupId)
          .update({'teamIds': oldTeamIds});

      // Add to new group
      List<String> newTeamIds = List.from(newGroup.teamIds);
      newTeamIds.add(team.id);

      await FirebaseFirestore.instance
          .collection('tournament_groups')
          .doc(newGroup.groupId)
          .update({'teamIds': newTeamIds});

      // Update team stats
      QuerySnapshot statsSnapshot = await FirebaseFirestore.instance
          .collection('tournament_team_stats')
          .where('tournamentId', isEqualTo: tournament.tournamentId)
          .where('teamId', isEqualTo: team.id)
          .limit(1)
          .get();

      if (statsSnapshot.docs.isNotEmpty) {
        await statsSnapshot.docs.first.reference
            .update({'groupName': newGroupName});
      }

      // Reload data
      await tournamentProvider.loadTournamentGroups(tournament.tournamentId!);
      await tournamentProvider.loadTeamStats(tournament.tournamentId!);

      // Close loading dialog
      if (!context.mounted) return;
      Navigator.pop(context);

      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(Icons.check_circle, color: Colors.white),
              const SizedBox(width: 8),
              Expanded(
                child: Text('${team.name} কে $newGroupName এ স্থানান্তরিত করা হয়েছে'),
              ),
            ],
          ),
          backgroundColor: Colors.green,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      );
    } catch (e) {
      // Close loading dialog
      if (!context.mounted) return;
      Navigator.pop(context);

      debugPrint('❌ Error changing group: $e');

      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(Icons.error, color: Colors.white),
              const SizedBox(width: 8),
              Expanded(child: Text('গ্রুপ পরিবর্তন করতে সমস্যা: $e')),
            ],
          ),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      );
    }
  }
}