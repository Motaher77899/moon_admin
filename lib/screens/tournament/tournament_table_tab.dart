// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import '../../providers/tournament_provider.dart';
// import '../../models/tournament_model.dart';
//
// class TournamentTableTab extends StatelessWidget {
//   final TournamentModel tournament;
//
//   const TournamentTableTab({Key? key, required this.tournament})
//       : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return Consumer<TournamentProvider>(
//       builder: (context, provider, child) {
//         if (provider.groups.isEmpty) {
//           return Center(
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 Icon(Icons.table_chart, size: 80, color: Colors.grey.shade300),
//                 const SizedBox(height: 16),
//                 Text(
//                   'পয়েন্ট টেবিল তৈরি হয়নি',
//                   style: TextStyle(
//                     fontSize: 20,
//                     fontWeight: FontWeight.bold,
//                     color: Colors.grey.shade600,
//                   ),
//                 ),
//               ],
//             ),
//           );
//         }
//
//         return ListView.builder(
//           padding: const EdgeInsets.all(16),
//           itemCount: provider.groups.length,
//           itemBuilder: (context, index) {
//             TournamentGroup group = provider.groups[index];
//             return _buildGroupTable(context, provider, group);
//           },
//         );
//       },
//     );
//   }
//
//   Widget _buildGroupTable(
//       BuildContext context,
//       TournamentProvider provider,
//       TournamentGroup group,
//       ) {
//     List<TournamentTeamStats> groupStats =
//     provider.getTeamStatsByGroup(group.groupName);
//
//     return Card(
//       margin: const EdgeInsets.only(bottom: 24),
//       elevation: 2,
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//       child: Column(
//         children: [
//           // Group Header
//           Container(
//             padding: const EdgeInsets.all(16),
//             decoration: BoxDecoration(
//               gradient: LinearGradient(
//                 colors: [Colors.orange.shade600, Colors.orange.shade800],
//               ),
//               borderRadius: const BorderRadius.only(
//                 topLeft: Radius.circular(12),
//                 topRight: Radius.circular(12),
//               ),
//             ),
//             child: Row(
//               children: [
//                 Icon(Icons.emoji_events, color: Colors.white, size: 24),
//                 const SizedBox(width: 12),
//                 Text(
//                   group.groupName,
//                   style: const TextStyle(
//                     color: Colors.white,
//                     fontSize: 18,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//
//           // Table Header
//           Container(
//             color: Colors.grey.shade100,
//             padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
//             child: Row(
//               children: [
//                 const SizedBox(width: 35, child: Text('#', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12))),
//                 const Expanded(flex: 3, child: Text('টিম', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12))),
//                 _buildHeaderCell('MP'),
//                 _buildHeaderCell('W'),
//                 _buildHeaderCell('D'),
//                 _buildHeaderCell('L'),
//                 _buildHeaderCell('GD'),
//                 _buildHeaderCell('Pts'),
//               ],
//             ),
//           ),
//
//           // Table Rows
//           if (groupStats.isEmpty)
//             Padding(
//               padding: const EdgeInsets.all(32),
//               child: Text(
//                 'কোন ডেটা নেই',
//                 style: TextStyle(color: Colors.grey.shade600),
//               ),
//             )
//           else
//             ListView.builder(
//               shrinkWrap: true,
//               physics: const NeverScrollableScrollPhysics(),
//               itemCount: groupStats.length,
//               itemBuilder: (context, index) {
//                 return _buildTableRow(groupStats[index], index + 1);
//               },
//             ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildHeaderCell(String text) {
//     return SizedBox(
//       width: 40,
//       child: Text(
//         text,
//         style: const TextStyle(
//           fontWeight: FontWeight.bold,
//           fontSize: 11,
//         ),
//         textAlign: TextAlign.center,
//       ),
//     );
//   }
//
//   Widget _buildTableRow(TournamentTeamStats stats, int position) {
//     Color positionColor = position <= 2
//         ? Colors.green.shade100
//         : position <= 4
//         ? Colors.orange.shade50
//         : Colors.transparent;
//
//     return Container(
//       decoration: BoxDecoration(
//         color: positionColor,
//         border: Border(
//           bottom: BorderSide(color: Colors.grey.shade200),
//         ),
//       ),
//       padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
//       child: Row(
//         children: [
//           // Position
//           SizedBox(
//             width: 35,
//             child: Container(
//               width: 24,
//               height: 24,
//               decoration: BoxDecoration(
//                 color: position <= 2
//                     ? Colors.green.shade700
//                     : Colors.grey.shade400,
//                 shape: BoxShape.circle,
//               ),
//               child: Center(
//                 child: Text(
//                   '$position',
//                   style: const TextStyle(
//                     color: Colors.white,
//                     fontSize: 11,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//               ),
//             ),
//           ),
//
//           // Team
//           Expanded(
//             flex: 3,
//             child: Row(
//               children: [
//                 if (stats.teamLogo != null && stats.teamLogo!.isNotEmpty)
//                   ClipRRect(
//                     borderRadius: BorderRadius.circular(4),
//                     child: Image.network(
//                       stats.teamLogo!,
//                       width: 24,
//                       height: 24,
//                       fit: BoxFit.cover,
//                       errorBuilder: (context, error, stackTrace) {
//                         return Container(
//                           width: 24,
//                           height: 24,
//                           color: Colors.grey.shade200,
//                           child: Icon(Icons.shield,
//                               size: 14, color: Colors.grey.shade400),
//                         );
//                       },
//                     ),
//                   )
//                 else
//                   Container(
//                     width: 24,
//                     height: 24,
//                     decoration: BoxDecoration(
//                       color: Colors.grey.shade200,
//                       borderRadius: BorderRadius.circular(4),
//                     ),
//                     child: Icon(Icons.shield,
//                         size: 14, color: Colors.grey.shade400),
//                   ),
//                 const SizedBox(width: 8),
//                 Expanded(
//                   child: Text(
//                     stats.teamName,
//                     style: const TextStyle(
//                       fontSize: 13,
//                       fontWeight: FontWeight.w600,
//                     ),
//                     maxLines: 1,
//                     overflow: TextOverflow.ellipsis,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//
//           // Stats
//           _buildStatCell('${stats.matchesPlayed}'),
//           _buildStatCell('${stats.wins}'),
//           _buildStatCell('${stats.draws}'),
//           _buildStatCell('${stats.losses}'),
//           _buildStatCell(
//             stats.goalDifference >= 0
//                 ? '+${stats.goalDifference}'
//                 : '${stats.goalDifference}',
//             color: stats.goalDifference >= 0 ? Colors.green : Colors.red,
//           ),
//           _buildStatCell(
//             '${stats.points}',
//             fontWeight: FontWeight.bold,
//             color: Colors.orange.shade700,
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildStatCell(String text,
//       {FontWeight? fontWeight, Color? color}) {
//     return SizedBox(
//       width: 40,
//       child: Text(
//         text,
//         style: TextStyle(
//           fontSize: 12,
//           fontWeight: fontWeight ?? FontWeight.normal,
//           color: color,
//         ),
//         textAlign: TextAlign.center,
//       ),
//     );
//   }
// }

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