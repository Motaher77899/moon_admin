

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/tournament_provider.dart';
import '../../models/tournament_model.dart';

class TournamentTableTab extends StatelessWidget {
  final TournamentModel tournament;

  const TournamentTableTab({Key? key, required this.tournament})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<TournamentProvider>(
      builder: (context, tournamentProvider, child) {
        final groups = tournamentProvider.groups;

        if (tournamentProvider.teamStats.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.table_chart, size: 80, color: Colors.grey.shade300),
                const SizedBox(height: 16),
                Text(
                  'এখনো পয়েন্ট টেবিল তৈরি হয়নি',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey.shade600,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'ম্যাচ শুরু হলে পয়েন্ট টেবিল দেখা যাবে',
                  style: TextStyle(color: Colors.grey.shade500),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          );
        }

        // If tournament has groups, show grouped tables
        if (tournament.format == 'groups' && groups.isNotEmpty) {
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: groups.length,
            itemBuilder: (context, index) {
              final group = groups[index];
              final groupStats =
              tournamentProvider.getTeamStatsByGroup(group.groupName);
              return _buildGroupTable(group.groupName, groupStats);
            },
          );
        }

        // Otherwise show single table
        return ListView(
          padding: const EdgeInsets.all(16),
          children: [
            _buildPointsTable('সামগ্রিক পয়েন্ট টেবিল',
                tournamentProvider.teamStats),
          ],
        );
      },
    );
  }

  Widget _buildGroupTable(
      String groupName, List<TournamentTeamStats> stats) {
    return Card(
      margin: const EdgeInsets.only(bottom: 20),
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Column(
        children: [
          // Group Header
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.blue.shade600, Colors.blue.shade800],
              ),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white24,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(Icons.table_chart,
                      color: Colors.white, size: 20),
                ),
                const SizedBox(width: 10),
                Text(
                  groupName,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),

          // Table
          _buildStatsTable(stats),
        ],
      ),
    );
  }

  Widget _buildPointsTable(String title, List<TournamentTeamStats> stats) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Column(
        children: [
          // Header
          Container(
            padding: const EdgeInsets.all(14),
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
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white24,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(Icons.table_chart,
                      color: Colors.white, size: 20),
                ),
                const SizedBox(width: 10),
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),

          // Table
          _buildStatsTable(stats),
        ],
      ),
    );
  }

  Widget _buildStatsTable(List<TournamentTeamStats> stats) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: DataTable(
        headingRowColor: MaterialStateProperty.all(Colors.grey.shade100),
        dataRowHeight: 56,
        headingRowHeight: 48,
        columnSpacing: 16,
        horizontalMargin: 12,
        columns: const [
          DataColumn(
              label: Text('#',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12))),
          DataColumn(
              label: Text('টিম',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12))),
          DataColumn(
              label: Text('খ',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
              numeric: true),
          DataColumn(
              label: Text('জ',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
              numeric: true),
          DataColumn(
              label: Text('ড্র',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
              numeric: true),
          DataColumn(
              label: Text('প',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
              numeric: true),
          DataColumn(
              label: Text('GF',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
              numeric: true),
          DataColumn(
              label: Text('GA',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
              numeric: true),
          DataColumn(
              label: Text('GD',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
              numeric: true),
          DataColumn(
              label: Text('পয়েন্ট',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
              numeric: true),
        ],
        rows: stats.asMap().entries.map((entry) {
          int index = entry.key;
          TournamentTeamStats stat = entry.value;

          Color? rowColor;
          if (index == 0) {
            rowColor = Colors.green.shade50;
          } else if (index == 1) {
            rowColor = Colors.blue.shade50;
          }

          return DataRow(
            color: MaterialStateProperty.all(rowColor),
            cells: [
              DataCell(
                Container(
                  width: 30,
                  height: 30,
                  decoration: BoxDecoration(
                    color: index < 2
                        ? (index == 0 ? Colors.green : Colors.blue)
                        : Colors.grey.shade300,
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      '${index + 1}',
                      style: TextStyle(
                        color: index < 2 ? Colors.white : Colors.black87,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ),
              ),
              DataCell(
                Row(
                  children: [
                    if (stat.teamLogo != null && stat.teamLogo!.isNotEmpty)
                      ClipRRect(
                        borderRadius: BorderRadius.circular(4),
                        child: Image.network(
                          stat.teamLogo!,
                          width: 24,
                          height: 24,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => Icon(
                            Icons.shield,
                            size: 24,
                            color: Colors.grey.shade400,
                          ),
                        ),
                      )
                    else
                      Icon(Icons.shield,
                          size: 24, color: Colors.grey.shade400),
                    const SizedBox(width: 8),
                    ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 120),
                      child: Text(
                        stat.teamName,
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 13,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
              DataCell(Text('${stat.matchesPlayed}',
                  style: const TextStyle(fontSize: 13))),
              DataCell(Text('${stat.wins}',
                  style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: Colors.green))),
              DataCell(Text('${stat.draws}',
                  style: const TextStyle(fontSize: 13))),
              DataCell(Text('${stat.losses}',
                  style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: Colors.red))),
              DataCell(Text('${stat.goalsFor}',
                  style: const TextStyle(fontSize: 13))),
              DataCell(Text('${stat.goalsAgainst}',
                  style: const TextStyle(fontSize: 13))),
              DataCell(
                Text(
                  '${stat.goalDifference > 0 ? '+' : ''}${stat.goalDifference}',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: stat.goalDifference > 0
                        ? Colors.green
                        : stat.goalDifference < 0
                        ? Colors.red
                        : Colors.grey,
                  ),
                ),
              ),
              DataCell(
                Container(
                  padding:
                  const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.orange.shade700,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    '${stat.points}',
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          );
        }).toList(),
      ),
    );
  }
}