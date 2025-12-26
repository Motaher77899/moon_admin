// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:intl/intl.dart';
// import '../../providers/tournament_provider.dart';
// import '../../models/tournament_model.dart';
// import '../match/match_detail_screen.dart';
// import 'create_tournament_match_screen.dart';
//
// class TournamentMatchesTab extends StatelessWidget {
//   final TournamentModel tournament;
//
//   const TournamentMatchesTab({Key? key, required this.tournament})
//       : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return Consumer<TournamentProvider>(
//       builder: (context, tournamentProvider, child) {
//         final matches = tournamentProvider.tournamentMatches;
//         final DateFormat dateFormat = DateFormat('dd MMM yyyy, hh:mm a');
//
//         return Column(
//           children: [
//             // Add Match Button
//             if (tournament.status != 'completed')
//               Container(
//                 padding: const EdgeInsets.all(16),
//                 child: SizedBox(
//                   width: double.infinity,
//                   child: ElevatedButton.icon(
//                     onPressed: () {
//                       Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                           builder: (context) =>
//                               CreateTournamentMatchScreen(tournament: tournament),
//                         ),
//                       );
//                     },
//                     icon: const Icon(Icons.add),
//                     label: const Text('নতুন ম্যাচ যোগ করুন'),
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: Colors.orange.shade700,
//                       foregroundColor: Colors.white,
//                       padding: const EdgeInsets.symmetric(vertical: 14),
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(12),
//                       ),
//                     ),
//                   ),
//                 ),
//               ),
//
//             // Matches List
//             Expanded(
//               child: matches.isEmpty
//                   ? Center(
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     Icon(Icons.sports_soccer,
//                         size: 80, color: Colors.grey.shade300),
//                     const SizedBox(height: 16),
//                     Text(
//                       'এখনো কোন ম্যাচ তৈরি হয়নি',
//                       style: TextStyle(
//                         fontSize: 18,
//                         fontWeight: FontWeight.bold,
//                         color: Colors.grey.shade600,
//                       ),
//                     ),
//                     const SizedBox(height: 8),
//                     Text(
//                       'নতুন ম্যাচ যোগ করতে উপরের বাটনে ক্লিক করুন',
//                       style: TextStyle(color: Colors.grey.shade500),
//                       textAlign: TextAlign.center,
//                     ),
//                   ],
//                 ),
//               )
//                   : ListView.builder(
//                 padding: const EdgeInsets.all(16),
//                 itemCount: matches.length,
//                 itemBuilder: (context, index) {
//                   final match = matches[index];
//                   return _buildMatchCard(context, match, dateFormat);
//                 },
//               ),
//             ),
//           ],
//         );
//       },
//     );
//   }
//
//   Widget _buildMatchCard(
//       BuildContext context, TournamentMatch match, DateFormat dateFormat) {
//     Color statusColor = match.status == 'live'
//         ? Colors.green
//         : match.status == 'completed'
//         ? Colors.grey
//         : Colors.orange;
//
//     return Card(
//       margin: const EdgeInsets.only(bottom: 12),
//       elevation: 2,
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//       child: InkWell(
//         onTap: () {
//           // Navigate to match detail if needed
//         },
//         borderRadius: BorderRadius.circular(12),
//         child: Padding(
//           padding: const EdgeInsets.all(16),
//           child: Column(
//             children: [
//               // Status + Round
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   Container(
//                     padding:
//                     const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
//                     decoration: BoxDecoration(
//                       color: statusColor.withOpacity(0.1),
//                       borderRadius: BorderRadius.circular(12),
//                       border: Border.all(color: statusColor),
//                     ),
//                     child: Text(
//                       match.status == 'live'
//                           ? 'লাইভ'
//                           : match.status == 'completed'
//                           ? 'সম্পন্ন'
//                           : 'আসন্ন',
//                       style: TextStyle(
//                         color: statusColor,
//                         fontWeight: FontWeight.bold,
//                         fontSize: 11,
//                       ),
//                     ),
//                   ),
//                   if (match.groupName != null)
//                     Container(
//                       padding: const EdgeInsets.symmetric(
//                           horizontal: 8, vertical: 4),
//                       decoration: BoxDecoration(
//                         color: Colors.blue.shade50,
//                         borderRadius: BorderRadius.circular(8),
//                       ),
//                       child: Text(
//                         match.groupName!,
//                         style: TextStyle(
//                           fontSize: 11,
//                           color: Colors.blue.shade700,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                     ),
//                 ],
//               ),
//               const SizedBox(height: 4),
//               Text(
//                 match.round,
//                 style: TextStyle(
//                   fontSize: 12,
//                   color: Colors.grey.shade600,
//                   fontWeight: FontWeight.w600,
//                 ),
//               ),
//               const SizedBox(height: 12),
//
//               // Teams
//               Row(
//                 children: [
//                   Expanded(
//                     child: Column(
//                       children: [
//                         if (match.teamALogo != null &&
//                             match.teamALogo!.isNotEmpty)
//                           ClipRRect(
//                             borderRadius: BorderRadius.circular(8),
//                             child: Image.network(
//                               match.teamALogo!,
//                               width: 40,
//                               height: 40,
//                               fit: BoxFit.cover,
//                               errorBuilder: (_, __, ___) =>
//                                   _placeholderLogo(),
//                             ),
//                           )
//                         else
//                           _placeholderLogo(),
//                         const SizedBox(height: 8),
//                         Text(
//                           match.teamAName,
//                           style: const TextStyle(
//                             fontWeight: FontWeight.bold,
//                             fontSize: 13,
//                           ),
//                           textAlign: TextAlign.center,
//                           maxLines: 2,
//                           overflow: TextOverflow.ellipsis,
//                         ),
//                         const SizedBox(height: 4),
//                         Text(
//                           '${match.scoreA}',
//                           style: TextStyle(
//                             fontSize: 22,
//                             fontWeight: FontWeight.bold,
//                             color: Colors.orange.shade700,
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                   Padding(
//                     padding: const EdgeInsets.symmetric(horizontal: 12),
//                     child: Text(
//                       'VS',
//                       style: TextStyle(
//                         fontSize: 16,
//                         fontWeight: FontWeight.bold,
//                         color: Colors.grey.shade400,
//                       ),
//                     ),
//                   ),
//                   Expanded(
//                     child: Column(
//                       children: [
//                         if (match.teamBLogo != null &&
//                             match.teamBLogo!.isNotEmpty)
//                           ClipRRect(
//                             borderRadius: BorderRadius.circular(8),
//                             child: Image.network(
//                               match.teamBLogo!,
//                               width: 40,
//                               height: 40,
//                               fit: BoxFit.cover,
//                               errorBuilder: (_, __, ___) =>
//                                   _placeholderLogo(),
//                             ),
//                           )
//                         else
//                           _placeholderLogo(),
//                         const SizedBox(height: 8),
//                         Text(
//                           match.teamBName,
//                           style: const TextStyle(
//                             fontWeight: FontWeight.bold,
//                             fontSize: 13,
//                           ),
//                           textAlign: TextAlign.center,
//                           maxLines: 2,
//                           overflow: TextOverflow.ellipsis,
//                         ),
//                         const SizedBox(height: 4),
//                         Text(
//                           '${match.scoreB}',
//                           style: TextStyle(
//                             fontSize: 22,
//                             fontWeight: FontWeight.bold,
//                             color: Colors.orange.shade700,
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//               const SizedBox(height: 12),
//
//               // Match Info
//               Container(
//                 padding: const EdgeInsets.all(10),
//                 decoration: BoxDecoration(
//                   color: Colors.grey.shade50,
//                   borderRadius: BorderRadius.circular(8),
//                 ),
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceAround,
//                   children: [
//                     Row(
//                       children: [
//                         Icon(Icons.location_on,
//                             size: 14, color: Colors.grey.shade600),
//                         const SizedBox(width: 4),
//                         Text(
//                           match.venue,
//                           style: TextStyle(
//                             fontSize: 11,
//                             color: Colors.grey.shade700,
//                           ),
//                         ),
//                       ],
//                     ),
//                     Container(
//                         width: 1, height: 16, color: Colors.grey.shade300),
//                     Row(
//                       children: [
//                         Icon(Icons.calendar_today,
//                             size: 14, color: Colors.grey.shade600),
//                         const SizedBox(width: 4),
//                         Text(
//                           dateFormat.format(match.matchDate),
//                           style: TextStyle(
//                             fontSize: 11,
//                             color: Colors.grey.shade700,
//                           ),
//                         ),
//                       ],
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget _placeholderLogo() {
//     return Container(
//       width: 40,
//       height: 40,
//       decoration: BoxDecoration(
//         color: Colors.grey.shade200,
//         borderRadius: BorderRadius.circular(8),
//       ),
//       child: Icon(Icons.shield, color: Colors.grey.shade400, size: 24),
//     );
//   }
// }


import 'package:admin_football_app/screens/tournament/tournament_match_details_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../providers/tournament_provider.dart';
import '../../models/tournament_model.dart';
import '../match/match_detail_screen.dart';
import 'create_tournament_match_screen.dart';

class TournamentMatchesTab extends StatelessWidget {
  final TournamentModel tournament;

  const TournamentMatchesTab({Key? key, required this.tournament})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<TournamentProvider>(
      builder: (context, tournamentProvider, child) {
        final matches = tournamentProvider.tournamentMatches;
        final DateFormat dateFormat = DateFormat('dd MMM yyyy, hh:mm a');

        return Column(
          children: [
            // Add Match Button
            if (tournament.status != 'finished')
              Container(
                padding: const EdgeInsets.all(16),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              CreateTournamentMatchScreen(tournament: tournament),
                        ),
                      );
                    },
                    icon: const Icon(Icons.add),
                    label: const Text('নতুন ম্যাচ যোগ করুন'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange.shade700,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
              ),

            // Matches List
            Expanded(
              child: matches.isEmpty
                  ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.sports_soccer,
                        size: 80, color: Colors.grey.shade300),
                    const SizedBox(height: 16),
                    Text(
                      'এখনো কোন ম্যাচ তৈরি হয়নি',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey.shade600,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'নতুন ম্যাচ যোগ করতে উপরের বাটনে ক্লিক করুন',
                      style: TextStyle(color: Colors.grey.shade500),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              )
                  : ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: matches.length,
                itemBuilder: (context, index) {
                  final match = matches[index];
                  return _buildMatchCard(context, match, dateFormat);
                },
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildMatchCard(
      BuildContext context, TournamentMatch match, DateFormat dateFormat) {
    Color statusColor = match.status == 'live'
        ? Colors.green
        : match.status == 'finished'
        ? Colors.grey
        : Colors.orange;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => TournamentMatchDetailsScreen(matchId: match.matchId!),
            ),
          );
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              // Status + Round
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: statusColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: statusColor),
                    ),
                    child: Text(
                      match.status == 'live'
                          ? 'লাইভ'
                          : match.status == 'finished'
                          ? 'সম্পন্ন'
                          : 'আসন্ন',
                      style: TextStyle(
                        color: statusColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 11,
                      ),
                    ),
                  ),
                  if (match.groupName != null)
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.blue.shade50,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        match.groupName!,
                        style: TextStyle(
                          fontSize: 11,
                          color: Colors.blue.shade700,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                match.round,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey.shade600,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 12),

              // Teams
              Row(
                children: [
                  Expanded(
                    child: Column(
                      children: [
                        if (match.teamALogo != null &&
                            match.teamALogo!.isNotEmpty)
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.network(
                              match.teamALogo!,
                              width: 40,
                              height: 40,
                              fit: BoxFit.cover,
                              errorBuilder: (_, __, ___) =>
                                  _placeholderLogo(),
                            ),
                          )
                        else
                          _placeholderLogo(),
                        const SizedBox(height: 8),
                        Text(
                          match.teamAName,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                          ),
                          textAlign: TextAlign.center,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${match.scoreA}',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.orange.shade700,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: Text(
                      'VS',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey.shade400,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Column(
                      children: [
                        if (match.teamBLogo != null &&
                            match.teamBLogo!.isNotEmpty)
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.network(
                              match.teamBLogo!,
                              width: 40,
                              height: 40,
                              fit: BoxFit.cover,
                              errorBuilder: (_, __, ___) =>
                                  _placeholderLogo(),
                            ),
                          )
                        else
                          _placeholderLogo(),
                        const SizedBox(height: 8),
                        Text(
                          match.teamBName,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                          ),
                          textAlign: TextAlign.center,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${match.scoreB}',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.orange.shade700,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // Match Info
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.grey.shade50,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.location_on,
                            size: 14, color: Colors.grey.shade600),
                        const SizedBox(width: 4),
                        Text(
                          match.venue,
                          style: TextStyle(
                            fontSize: 11,
                            color: Colors.grey.shade700,
                          ),
                        ),
                      ],
                    ),
                    Container(
                        width: 1, height: 16, color: Colors.grey.shade300),
                    Row(
                      children: [
                        Icon(Icons.calendar_today,
                            size: 14, color: Colors.grey.shade600),
                        const SizedBox(width: 4),
                        Text(
                          dateFormat.format(match.matchDate),
                          style: TextStyle(
                            fontSize: 11,
                            color: Colors.grey.shade700,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _placeholderLogo() {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Icon(Icons.shield, color: Colors.grey.shade400, size: 24),
    );
  }
}

