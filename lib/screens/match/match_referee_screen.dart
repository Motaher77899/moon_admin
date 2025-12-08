// // import 'package:flutter/material.dart';
// // import 'package:provider/provider.dart';
// // import '../../providers/match_provider.dart';
// // import '../../models/match_model.dart';
// //
// // class MatchRefereeScreen extends StatefulWidget {
// //   final MatchModel match;
// //   final VoidCallback onUpdate;
// //
// //   const MatchRefereeScreen({
// //     Key? key,
// //     required this.match,
// //     required this.onUpdate,
// //   }) : super(key: key);
// //
// //   @override
// //   State<MatchRefereeScreen> createState() => _MatchRefereeScreenState();
// // }
// //
// // class _MatchRefereeScreenState extends State<MatchRefereeScreen> {
// //   int _matchMinute = 0;
// //
// //   @override
// //   void initState() {
// //     super.initState();
// //     // Calculate match minute from start time if live
// //     if (widget.match.status == 'live') {
// //       int calculatedMinute = DateTime.now().difference(widget.match.matchDate).inMinutes;
// //       // Ensure positive value
// //       _matchMinute = calculatedMinute > 0 ? calculatedMinute : 0;
// //     } else {
// //       _matchMinute = 0;
// //     }
// //   }
// //
// //   Future<void> _addGoal(String team) async {
// //     LineUp? lineup = team == 'teamA' ? widget.match.lineUpA : widget.match.lineUpB;
// //
// //     if (lineup == null || lineup.players.isEmpty) {
// //       ScaffoldMessenger.of(context).showSnackBar(
// //         SnackBar(
// //           content: Text(
// //               '${team == 'teamA' ? widget.match.teamAName : widget.match.teamBName} এর লাইনআপ সেট করা নেই'),
// //           backgroundColor: Colors.red,
// //         ),
// //       );
// //       return;
// //     }
// //
// //     // Show player selection dialog
// //     PlayerLineUp? scorer = await _showPlayerSelectionDialog(
// //       lineup.players,
// //       'Goal!! Who scored it?',
// //       team == 'teamA' ? widget.match.teamAName : widget.match.teamBName,
// //     );
// //
// //     if (scorer != null) {
// //       // Show assist dialog
// //       bool hasAssist = await _showAssistTypeDialog();
// //
// //       PlayerLineUp? assist;
// //       if (hasAssist) {
// //         // Show player selection for assist
// //         assist = await _showPlayerSelectionDialog(
// //           lineup.players.where((p) => p.playerId != scorer.playerId).toList(),
// //           'Select Assist Player',
// //           team == 'teamA' ? widget.match.teamAName : widget.match.teamBName,
// //         );
// //       }
// //
// //       // Create event
// //       final event = MatchEvent(
// //         type: 'goal',
// //         team: team,
// //         playerName: scorer.playerName,
// //         playerId: scorer.playerId,
// //         minute: _matchMinute,
// //         assistPlayerId: assist?.playerId,
// //         assistPlayerName: assist?.playerName,
// //       );
// //
// //       // Update match
// //       final matchProvider = Provider.of<MatchProvider>(context, listen: false);
// //       final error = await matchProvider.addTimelineEvent(
// //         widget.match.matchId!,
// //         event,
// //       );
// //
// //       if (error != null) {
// //         ScaffoldMessenger.of(context).showSnackBar(
// //           SnackBar(content: Text(error), backgroundColor: Colors.red),
// //         );
// //       } else {
// //         // Update score
// //         int newScoreA = widget.match.teamAScore + (team == 'teamA' ? 1 : 0);
// //         int newScoreB = widget.match.teamBScore + (team == 'teamB' ? 1 : 0);
// //
// //         await matchProvider.updateMatchScore(
// //           widget.match.matchId!,
// //           newScoreA,
// //           newScoreB,
// //         );
// //
// //         ScaffoldMessenger.of(context).showSnackBar(
// //           const SnackBar(
// //             content: Text('Goal recorded successfully'),
// //             backgroundColor: Colors.green,
// //           ),
// //         );
// //         widget.onUpdate();
// //       }
// //     }
// //   }
// //
// //   Future<void> _addCard(String team, String cardType) async {
// //     LineUp? lineup = team == 'teamA' ? widget.match.lineUpA : widget.match.lineUpB;
// //
// //     if (lineup == null || lineup.players.isEmpty) {
// //       ScaffoldMessenger.of(context).showSnackBar(
// //         const SnackBar(
// //           content: Text('লাইনআপ সেট করা নেই'),
// //           backgroundColor: Colors.red,
// //         ),
// //       );
// //       return;
// //     }
// //
// //     String title = cardType == 'yellow_card' ? 'Yellow Card' : 'Red Card';
// //     PlayerLineUp? player = await _showPlayerSelectionDialog(
// //       lineup.players,
// //       title,
// //       team == 'teamA' ? widget.match.teamAName : widget.match.teamBName,
// //     );
// //
// //     if (player != null) {
// //       final event = MatchEvent(
// //         type: 'card',
// //         team: team,
// //         playerName: player.playerName,
// //         playerId: player.playerId,
// //         minute: _matchMinute,
// //         details: cardType,
// //       );
// //
// //       final matchProvider = Provider.of<MatchProvider>(context, listen: false);
// //       final error = await matchProvider.addTimelineEvent(
// //         widget.match.matchId!,
// //         event,
// //       );
// //
// //       if (error == null) {
// //         ScaffoldMessenger.of(context).showSnackBar(
// //           const SnackBar(
// //             content: Text('Card recorded'),
// //             backgroundColor: Colors.green,
// //           ),
// //         );
// //         widget.onUpdate();
// //       }
// //     }
// //   }
// //
// //   Future<void> _addSubstitution(String team) async {
// //     LineUp? lineup = team == 'teamA' ? widget.match.lineUpA : widget.match.lineUpB;
// //
// //     if (lineup == null || lineup.players.isEmpty) {
// //       ScaffoldMessenger.of(context).showSnackBar(
// //         const SnackBar(
// //           content: Text('লাইনআপ সেট করা নেই'),
// //           backgroundColor: Colors.red,
// //         ),
// //       );
// //       return;
// //     }
// //
// //     // Get player going out
// //     PlayerLineUp? playerOut = await _showPlayerSelectionDialog(
// //       lineup.players.where((p) => !p.isSubstitute).toList(),
// //       'Player Out',
// //       team == 'teamA' ? widget.match.teamAName : widget.match.teamBName,
// //     );
// //
// //     if (playerOut != null) {
// //       // Get player coming in
// //       PlayerLineUp? playerIn = await _showPlayerSelectionDialog(
// //         lineup.players.where((p) => p.isSubstitute).toList(),
// //         'Player In',
// //         team == 'teamA' ? widget.match.teamAName : widget.match.teamBName,
// //       );
// //
// //       if (playerIn != null) {
// //         // Create two events
// //         final eventOut = MatchEvent(
// //           type: 'substitution',
// //           team: team,
// //           playerName: playerOut.playerName,
// //           playerId: playerOut.playerId,
// //           minute: _matchMinute,
// //           details: 'player_out',
// //         );
// //
// //         final eventIn = MatchEvent(
// //           type: 'substitution',
// //           team: team,
// //           playerName: playerIn.playerName,
// //           playerId: playerIn.playerId,
// //           minute: _matchMinute,
// //           details: 'player_in',
// //         );
// //
// //         final matchProvider = Provider.of<MatchProvider>(context, listen: false);
// //         await matchProvider.addTimelineEvent(widget.match.matchId!, eventOut);
// //         await matchProvider.addTimelineEvent(widget.match.matchId!, eventIn);
// //
// //         ScaffoldMessenger.of(context).showSnackBar(
// //           const SnackBar(
// //             content: Text('Substitution recorded'),
// //             backgroundColor: Colors.green,
// //           ),
// //         );
// //         widget.onUpdate();
// //       }
// //     }
// //   }
// //
// //   Future<PlayerLineUp?> _showPlayerSelectionDialog(
// //       List<PlayerLineUp> players,
// //       String title,
// //       String teamName,
// //       ) async {
// //     if (players.isEmpty) {
// //       ScaffoldMessenger.of(context).showSnackBar(
// //         const SnackBar(
// //           content: Text('No players available'),
// //           backgroundColor: Colors.red,
// //         ),
// //       );
// //       return null;
// //     }
// //
// //     return showDialog<PlayerLineUp>(
// //       context: context,
// //       builder: (context) => Dialog(
// //         backgroundColor: const Color(0xFF16213E),
// //         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
// //         child: Container(
// //           padding: const EdgeInsets.all(20),
// //           constraints: BoxConstraints(
// //             maxHeight: MediaQuery.of(context).size.height * 0.7,
// //           ),
// //           child: Column(
// //             mainAxisSize: MainAxisSize.min,
// //             children: [
// //               Text(
// //                 teamName,
// //                 style: const TextStyle(
// //                   color: Colors.white54,
// //                   fontSize: 14,
// //                 ),
// //               ),
// //               const SizedBox(height: 8),
// //               Text(
// //                 title,
// //                 style: const TextStyle(
// //                   color: Colors.white,
// //                   fontSize: 24,
// //                   fontWeight: FontWeight.bold,
// //                 ),
// //               ),
// //               const SizedBox(height: 20),
// //               Flexible(
// //                 child: ListView.builder(
// //                   shrinkWrap: true,
// //                   itemCount: players.length,
// //                   itemBuilder: (context, index) {
// //                     return _buildPlayerOption(players[index], context);
// //                   },
// //                 ),
// //               ),
// //             ],
// //           ),
// //         ),
// //       ),
// //     );
// //   }
// //
// //   Widget _buildPlayerOption(PlayerLineUp player, BuildContext context) {
// //     return GestureDetector(
// //       onTap: () => Navigator.pop(context, player),
// //       child: Container(
// //         margin: const EdgeInsets.only(bottom: 12),
// //         padding: const EdgeInsets.all(12),
// //         decoration: BoxDecoration(
// //           color: const Color(0xFF1A1A2E),
// //           borderRadius: BorderRadius.circular(8),
// //         ),
// //         child: Row(
// //           children: [
// //             Container(
// //               width: 50,
// //               height: 60,
// //               decoration: BoxDecoration(
// //                 color: const Color(0xFFE94560),
// //                 borderRadius: BorderRadius.circular(8),
// //               ),
// //               child: Center(
// //                 child: Column(
// //                   mainAxisAlignment: MainAxisAlignment.center,
// //                   children: [
// //                     Text(
// //                       player.playerName.isNotEmpty
// //                           ? player.playerName.substring(0, 1).toUpperCase()
// //                           : '?',
// //                       style: const TextStyle(
// //                         color: Colors.white,
// //                         fontWeight: FontWeight.bold,
// //                         fontSize: 18,
// //                       ),
// //                     ),
// //                     const SizedBox(height: 4),
// //                     Text(
// //                       '${player.jerseyNumber}',
// //                       style: const TextStyle(
// //                         color: Colors.white,
// //                         fontWeight: FontWeight.bold,
// //                         fontSize: 14,
// //                       ),
// //                     ),
// //                   ],
// //                 ),
// //               ),
// //             ),
// //             const SizedBox(width: 12),
// //             Expanded(
// //               child: Column(
// //                 crossAxisAlignment: CrossAxisAlignment.start,
// //                 children: [
// //                   Text(
// //                     player.playerName,
// //                     style: const TextStyle(
// //                       color: Colors.white,
// //                       fontWeight: FontWeight.bold,
// //                       fontSize: 16,
// //                     ),
// //                   ),
// //                   const SizedBox(height: 4),
// //                   Text(
// //                     player.position,
// //                     style: const TextStyle(
// //                       color: Colors.white54,
// //                       fontSize: 12,
// //                     ),
// //                   ),
// //                 ],
// //               ),
// //             ),
// //           ],
// //         ),
// //       ),
// //     );
// //   }
// //
// //   Future<bool> _showAssistTypeDialog() async {
// //     final result = await showDialog<bool>(
// //       context: context,
// //       builder: (context) => Dialog(
// //         backgroundColor: const Color(0xFF16213E),
// //         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
// //         child: Container(
// //           padding: const EdgeInsets.all(20),
// //           child: Column(
// //             mainAxisSize: MainAxisSize.min,
// //             children: [
// //               const Text(
// //                 'Was there an assist?',
// //                 style: TextStyle(
// //                   color: Colors.white,
// //                   fontSize: 20,
// //                   fontWeight: FontWeight.bold,
// //                 ),
// //               ),
// //               const SizedBox(height: 20),
// //               Row(
// //                 mainAxisAlignment: MainAxisAlignment.spaceEvenly,
// //                 children: [
// //                   // Solo
// //                   Expanded(
// //                     child: GestureDetector(
// //                       onTap: () => Navigator.pop(context, false),
// //                       child: Container(
// //                         padding: const EdgeInsets.all(16),
// //                         decoration: BoxDecoration(
// //                           color: const Color(0xFF1A1A2E),
// //                           borderRadius: BorderRadius.circular(12),
// //                           border: Border.all(
// //                             color: Colors.white24,
// //                             width: 1,
// //                           ),
// //                         ),
// //                         child: Column(
// //                           children: [
// //                             Icon(Icons.sports_soccer,
// //                                 color: Colors.white54, size: 40),
// //                             const SizedBox(height: 8),
// //                             const Text(
// //                               'Solo Goal',
// //                               style: TextStyle(
// //                                 color: Colors.white,
// //                                 fontWeight: FontWeight.bold,
// //                               ),
// //                             ),
// //                             const SizedBox(height: 4),
// //                             const Text(
// //                               'No Assist',
// //                               style: TextStyle(
// //                                 color: Colors.white54,
// //                                 fontSize: 12,
// //                               ),
// //                             ),
// //                           ],
// //                         ),
// //                       ),
// //                     ),
// //                   ),
// //                   const SizedBox(width: 16),
// //                   // With Assist
// //                   Expanded(
// //                     child: GestureDetector(
// //                       onTap: () => Navigator.pop(context, true),
// //                       child: Container(
// //                         padding: const EdgeInsets.all(16),
// //                         decoration: BoxDecoration(
// //                           color: const Color(0xFF1A1A2E),
// //                           borderRadius: BorderRadius.circular(12),
// //                           border: Border.all(
// //                             color: Colors.green,
// //                             width: 2,
// //                           ),
// //                         ),
// //                         child: Column(
// //                           children: [
// //                             Icon(Icons.people, color: Colors.green, size: 40),
// //                             const SizedBox(height: 8),
// //                             const Text(
// //                               'With Assist',
// //                               style: TextStyle(
// //                                 color: Colors.white,
// //                                 fontWeight: FontWeight.bold,
// //                               ),
// //                             ),
// //                             const SizedBox(height: 4),
// //                             const Text(
// //                               'Team Play',
// //                               style: TextStyle(
// //                                 color: Colors.white54,
// //                                 fontSize: 12,
// //                               ),
// //                             ),
// //                           ],
// //                         ),
// //                       ),
// //                     ),
// //                   ),
// //                 ],
// //               ),
// //             ],
// //           ),
// //         ),
// //       ),
// //     );
// //
// //     return result ?? false;
// //   }
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     if (widget.match.status != 'live') {
// //       return Container(
// //         color: const Color(0xFF1A1A2E),
// //         child: Center(
// //           child: Column(
// //             mainAxisAlignment: MainAxisAlignment.center,
// //             children: [
// //               Icon(Icons.sports_soccer, size: 60, color: Colors.white24),
// //               const SizedBox(height: 16),
// //               Text(
// //                 'ম্যাচ শুরু করুন রেফারি কন্ট্রোল এর জন্য',
// //                 style: TextStyle(color: Colors.white54),
// //               ),
// //             ],
// //           ),
// //         ),
// //       );
// //     }
// //
// //     return Container(
// //       color: const Color(0xFF1A1A2E),
// //       padding: const EdgeInsets.all(16),
// //       child: Column(
// //         children: [
// //           // Match Timer
// //           Container(
// //             padding: const EdgeInsets.all(16),
// //             decoration: BoxDecoration(
// //               color: const Color(0xFF16213E),
// //               borderRadius: BorderRadius.circular(12),
// //             ),
// //             child: Row(
// //               mainAxisAlignment: MainAxisAlignment.center,
// //               children: [
// //                 const Icon(Icons.timer, color: Color(0xFF00D9FF)),
// //                 const SizedBox(width: 8),
// //                 Text(
// //                   "$_matchMinute'",
// //                   style: const TextStyle(
// //                     color: Colors.white,
// //                     fontSize: 32,
// //                     fontWeight: FontWeight.bold,
// //                   ),
// //                 ),
// //                 const SizedBox(width: 16),
// //                 IconButton(
// //                   icon: const Icon(Icons.edit, color: Colors.white54),
// //                   onPressed: () async {
// //                     final minute = await showDialog<int>(
// //                       context: context,
// //                       builder: (context) => _buildMinuteEditDialog(),
// //                     );
// //                     if (minute != null) {
// //                       setState(() => _matchMinute = minute);
// //                     }
// //                   },
// //                 ),
// //               ],
// //             ),
// //           ),
// //           const SizedBox(height: 24),
// //
// //           // Referee Controls
// //           Expanded(
// //             child: Row(
// //               children: [
// //                 // Team A Controls
// //                 Expanded(child: _buildTeamControls('teamA', widget.match.teamAName)),
// //                 const SizedBox(width: 16),
// //                 // Team B Controls
// //                 Expanded(child: _buildTeamControls('teamB', widget.match.teamBName)),
// //               ],
// //             ),
// //           ),
// //         ],
// //       ),
// //     );
// //   }
// //
// //   Widget _buildTeamControls(String team, String teamName) {
// //     return SingleChildScrollView(
// //       child: Column(
// //         children: [
// //           // Team Name
// //           Text(
// //             teamName,
// //             style: const TextStyle(
// //               color: Colors.white,
// //               fontWeight: FontWeight.bold,
// //               fontSize: 14,
// //             ),
// //             textAlign: TextAlign.center,
// //             maxLines: 2,
// //             overflow: TextOverflow.ellipsis,
// //           ),
// //           const SizedBox(height: 12),
// //
// //           // Goal Button
// //           _buildControlButton(
// //             icon: Icons.sports_soccer,
// //             color: const Color(0xFFE94560),
// //             label: 'Goal',
// //             onTap: () => _addGoal(team),
// //           ),
// //           const SizedBox(height: 8),
// //
// //           // Yellow Card Button
// //           _buildControlButton(
// //             icon: Icons.credit_card,
// //             color: Colors.yellow,
// //             label: 'Yellow',
// //             onTap: () => _addCard(team, 'yellow_card'),
// //           ),
// //           const SizedBox(height: 8),
// //
// //           // Red Card Button
// //           _buildControlButton(
// //             icon: Icons.credit_card,
// //             color: Colors.red,
// //             label: 'Red',
// //             onTap: () => _addCard(team, 'red_card'),
// //           ),
// //           const SizedBox(height: 8),
// //
// //           // Substitution Button
// //           _buildControlButton(
// //             icon: Icons.swap_horiz,
// //             color: Colors.green,
// //             label: 'Sub',
// //             onTap: () => _addSubstitution(team),
// //           ),
// //           const SizedBox(height: 8),
// //
// //           // Own Goal Button
// //           _buildControlButton(
// //             icon: Icons.sports_soccer,
// //             color: Colors.blue,
// //             label: 'Own Goal',
// //             onTap: () => _addGoal(team == 'teamA' ? 'teamB' : 'teamA'),
// //           ),
// //         ],
// //       ),
// //     );
// //   }
// //
// //   Widget _buildControlButton({
// //     required IconData icon,
// //     required Color color,
// //     required String label,
// //     required VoidCallback onTap,
// //   }) {
// //     return GestureDetector(
// //       onTap: onTap,
// //       child: Container(
// //         width: double.infinity,
// //         height: 60,
// //         decoration: BoxDecoration(
// //           color: const Color(0xFF16213E),
// //           borderRadius: BorderRadius.circular(12),
// //           border: Border.all(
// //             color: color.withOpacity(0.3),
// //             width: 1,
// //           ),
// //         ),
// //         child: Column(
// //           mainAxisAlignment: MainAxisAlignment.center,
// //           children: [
// //             Icon(icon, color: color, size: 28),
// //             const SizedBox(height: 4),
// //             Text(
// //               label,
// //               style: TextStyle(
// //                 color: color,
// //                 fontSize: 10,
// //                 fontWeight: FontWeight.bold,
// //               ),
// //             ),
// //           ],
// //         ),
// //       ),
// //     );
// //   }
// //
// //   Widget _buildMinuteEditDialog() {
// //     int tempMinute = _matchMinute;
// //     return StatefulBuilder(
// //       builder: (context, setState) => AlertDialog(
// //         backgroundColor: const Color(0xFF16213E),
// //         title: const Text('Match Minute', style: TextStyle(color: Colors.white)),
// //         content: Row(
// //           mainAxisAlignment: MainAxisAlignment.center,
// //           children: [
// //             IconButton(
// //               icon: const Icon(Icons.remove, color: Colors.white),
// //               onPressed: () {
// //                 if (tempMinute > 0) setState(() => tempMinute--);
// //               },
// //             ),
// //             Text(
// //               "$tempMinute'",
// //               style: const TextStyle(
// //                 color: Colors.white,
// //                 fontSize: 32,
// //                 fontWeight: FontWeight.bold,
// //               ),
// //             ),
// //             IconButton(
// //               icon: const Icon(Icons.add, color: Colors.white),
// //               onPressed: () => setState(() => tempMinute++),
// //             ),
// //           ],
// //         ),
// //         actions: [
// //           TextButton(
// //             onPressed: () => Navigator.pop(context),
// //             child: const Text('Cancel'),
// //           ),
// //           ElevatedButton(
// //             onPressed: () => Navigator.pop(context, tempMinute),
// //             style: ElevatedButton.styleFrom(
// //               backgroundColor: const Color(0xFF00D9FF),
// //             ),
// //             child: const Text('OK'),
// //           ),
// //         ],
// //       ),
// //     );
// //   }
// // }
//
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import '../../providers/match_provider.dart';
// import '../../models/match_model.dart';
//
// class MatchRefereeScreen extends StatefulWidget {
//   final MatchModel match;
//   final VoidCallback onUpdate;
//
//   const MatchRefereeScreen({
//     Key? key,
//     required this.match,
//     required this.onUpdate,
//   }) : super(key: key);
//
//   @override
//   State<MatchRefereeScreen> createState() => _MatchRefereeScreenState();
// }
//
// class _MatchRefereeScreenState extends State<MatchRefereeScreen> {
//   int _matchMinute = 0;
//   bool _isFirstHalf = true;
//
//   @override
//   void initState() {
//     super.initState();
//     if (widget.match.status == 'live') {
//       int calculatedMinute =
//           DateTime.now().difference(widget.match.time).inMinutes;
//       _matchMinute = calculatedMinute > 0 ? calculatedMinute : 0;
//     } else {
//       _matchMinute = 0;
//     }
//   }
//
//   Future<void> _addGoal(String team) async {
//     LineUp? lineup =
//     team == 'teamA' ? widget.match.lineUpA : widget.match.lineUpB;
//     String teamName =
//     team == 'teamA' ? widget.match.teamAName : widget.match.teamBName;
//
//     if (lineup == null || lineup.players.isEmpty) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text('$teamName এর লাইনআপ সেট করা নেই'),
//           backgroundColor: Colors.red,
//         ),
//       );
//       return;
//     }
//
//     // Show player selection dialog
//     PlayerLineUp? scorer = await _showPlayerSelectionDialog(
//       lineup.players,
//       'Goal!! Who scored it?',
//       teamName,
//     );
//
//     if (scorer != null) {
//       // Show assist dialog
//       String? assistType = await _showAssistTypeDialog();
//
//       PlayerLineUp? assist;
//       if (assistType == 'assist') {
//         // Show player selection for assist
//         assist = await _showPlayerSelectionDialog(
//           lineup.players.where((p) => p.playerId != scorer.playerId).toList(),
//           'whose assistance?',
//           teamName,
//         );
//       }
//
//       // Create event
//       final event = MatchEvent(
//         type: 'goal',
//         team: team,
//         playerName: scorer.playerName,
//         playerId: scorer.playerId,
//         minute: _matchMinute,
//         assistPlayerId: assist?.playerId,
//         assistPlayerName: assist?.playerName,
//         assistType: assistType,
//       );
//
//       // Update match
//       final matchProvider = Provider.of<MatchProvider>(context, listen: false);
//       final error = await matchProvider.addTimelineEvent(
//         widget.match.id,
//         event,
//       );
//
//       if (error != null) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text(error), backgroundColor: Colors.red),
//         );
//       } else {
//         // Update score
//         int newScoreA = widget.match.scoreA + (team == 'teamA' ? 1 : 0);
//         int newScoreB = widget.match.scoreB + (team == 'teamB' ? 1 : 0);
//
//         await matchProvider.updateMatchScore(
//           widget.match.id,
//           newScoreA,
//           newScoreB,
//         );
//
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(
//             content: Text('Match event sent successfully'),
//             backgroundColor: Colors.green,
//           ),
//         );
//         widget.onUpdate();
//       }
//     }
//   }
//
//   Future<void> _addCard(String team, String cardType) async {
//     LineUp? lineup =
//     team == 'teamA' ? widget.match.lineUpA : widget.match.lineUpB;
//     String teamName =
//     team == 'teamA' ? widget.match.teamAName : widget.match.teamBName;
//
//     if (lineup == null || lineup.players.isEmpty) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text('$teamName এর লাইনআপ সেট করা নেই'),
//           backgroundColor: Colors.red,
//         ),
//       );
//       return;
//     }
//
//     String title = cardType == 'yellow' ? 'Yellow Card' : 'Red Card';
//     PlayerLineUp? player = await _showPlayerSelectionDialog(
//       lineup.players,
//       title,
//       teamName,
//     );
//
//     if (player != null) {
//       final event = MatchEvent(
//         type: 'card',
//         team: team,
//         playerName: player.playerName,
//         playerId: player.playerId,
//         minute: _matchMinute,
//         details: cardType,
//       );
//
//       final matchProvider = Provider.of<MatchProvider>(context, listen: false);
//       final error = await matchProvider.addTimelineEvent(
//         widget.match.id,
//         event,
//       );
//
//       if (error == null) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(
//             content: Text('Match event sent successfully'),
//             backgroundColor: Colors.green,
//           ),
//         );
//         widget.onUpdate();
//       }
//     }
//   }
//
//   Future<void> _addSubstitution(String team) async {
//     LineUp? lineup =
//     team == 'teamA' ? widget.match.lineUpA : widget.match.lineUpB;
//     String teamName =
//     team == 'teamA' ? widget.match.teamAName : widget.match.teamBName;
//
//     if (lineup == null || lineup.players.isEmpty) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text('$teamName এর লাইনআপ সেট করা নেই'),
//           backgroundColor: Colors.red,
//         ),
//       );
//       return;
//     }
//
//     // Get player going out
//     PlayerLineUp? playerOut = await _showPlayerSelectionDialog(
//       lineup.players.where((p) => !p.isSubstitute).toList(),
//       'Player Out',
//       teamName,
//     );
//
//     if (playerOut != null) {
//       // Get player coming in
//       PlayerLineUp? playerIn = await _showPlayerSelectionDialog(
//         lineup.players.where((p) => p.isSubstitute).toList(),
//         'Player In',
//         teamName,
//       );
//
//       if (playerIn != null) {
//         // Create events
//         final eventOut = MatchEvent(
//           type: 'substitution',
//           team: team,
//           playerName: playerOut.playerName,
//           playerId: playerOut.playerId,
//           minute: _matchMinute,
//           details: 'out',
//         );
//
//         final eventIn = MatchEvent(
//           type: 'substitution',
//           team: team,
//           playerName: playerIn.playerName,
//           playerId: playerIn.playerId,
//           minute: _matchMinute,
//           details: 'in',
//         );
//
//         final matchProvider =
//         Provider.of<MatchProvider>(context, listen: false);
//         await matchProvider.addTimelineEvent(widget.match.id, eventOut);
//         await matchProvider.addTimelineEvent(widget.match.id, eventIn);
//
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(
//             content: Text('Match event sent successfully'),
//             backgroundColor: Colors.green,
//           ),
//         );
//         widget.onUpdate();
//       }
//     }
//   }
//
//   Future<PlayerLineUp?> _showPlayerSelectionDialog(
//       List<PlayerLineUp> players,
//       String title,
//       String teamName,
//       ) async {
//     if (players.isEmpty) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(
//           content: Text('No players available'),
//           backgroundColor: Colors.red,
//         ),
//       );
//       return null;
//     }
//
//     return showDialog<PlayerLineUp>(
//       context: context,
//       builder: (context) => Dialog(
//         backgroundColor: Colors.white,
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
//         child: Container(
//           padding: const EdgeInsets.all(20),
//           constraints: BoxConstraints(
//             maxHeight: MediaQuery.of(context).size.height * 0.7,
//           ),
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               Text(
//                 teamName,
//                 style: TextStyle(
//                   color: Colors.grey.shade600,
//                   fontSize: 14,
//                 ),
//               ),
//               const SizedBox(height: 8),
//               Text(
//                 title,
//                 style: const TextStyle(
//                   color: Colors.black,
//                   fontSize: 24,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//               const SizedBox(height: 20),
//               Flexible(
//                 child: GridView.builder(
//                   shrinkWrap: true,
//                   gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//                     crossAxisCount: 4,
//                     childAspectRatio: 0.8,
//                     crossAxisSpacing: 12,
//                     mainAxisSpacing: 12,
//                   ),
//                   itemCount: players.length,
//                   itemBuilder: (context, index) {
//                     return _buildPlayerJersey(players[index], context);
//                   },
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget _buildPlayerJersey(PlayerLineUp player, BuildContext context) {
//     return GestureDetector(
//       onTap: () => Navigator.pop(context, player),
//       child: Column(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           // Jersey
//           Container(
//             width: 70,
//             height: 70,
//             decoration: BoxDecoration(
//               color: Colors.red,
//               borderRadius: BorderRadius.circular(8),
//             ),
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 Text(
//                   player.playerName.isNotEmpty
//                       ? player.playerName.substring(0, 1).toUpperCase()
//                       : '?',
//                   style: const TextStyle(
//                     color: Colors.white,
//                     fontWeight: FontWeight.bold,
//                     fontSize: 18,
//                   ),
//                 ),
//                 const SizedBox(height: 4),
//                 Text(
//                   '${player.jerseyNumber}',
//                   style: const TextStyle(
//                     color: Colors.white,
//                     fontWeight: FontWeight.bold,
//                     fontSize: 16,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           const SizedBox(height: 4),
//           // Player Name
//           Text(
//             player.playerName,
//             style: const TextStyle(
//               color: Colors.black87,
//               fontSize: 10,
//               fontWeight: FontWeight.w500,
//             ),
//             maxLines: 1,
//             overflow: TextOverflow.ellipsis,
//             textAlign: TextAlign.center,
//           ),
//         ],
//       ),
//     );
//   }
//
//   Future<String?> _showAssistTypeDialog() async {
//     final result = await showDialog<String>(
//       context: context,
//       builder: (context) => Dialog(
//         backgroundColor: Colors.white,
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
//         child: Container(
//           padding: const EdgeInsets.all(20),
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               const Text(
//                 'whose assistance?',
//                 style: TextStyle(
//                   color: Colors.black,
//                   fontSize: 20,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//               const SizedBox(height: 24),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                 children: [
//                   // Penalty Kick
//                   Expanded(
//                     child: GestureDetector(
//                       onTap: () => Navigator.pop(context, 'penalty'),
//                       child: Container(
//                         padding: const EdgeInsets.all(16),
//                         decoration: BoxDecoration(
//                           color: Colors.white,
//                           borderRadius: BorderRadius.circular(12),
//                           border: Border.all(
//                             color: Colors.grey.shade300,
//                             width: 2,
//                           ),
//                         ),
//                         child: Column(
//                           children: [
//                             Container(
//                               width: 60,
//                               height: 60,
//                               decoration: BoxDecoration(
//                                 color: Colors.grey.shade100,
//                                 shape: BoxShape.circle,
//                               ),
//                               child: Icon(
//                                 Icons.sports_soccer,
//                                 color: Colors.grey.shade600,
//                                 size: 32,
//                               ),
//                             ),
//                             const SizedBox(height: 12),
//                             const Text(
//                               'Penalty kick',
//                               style: TextStyle(
//                                 color: Colors.black87,
//                                 fontWeight: FontWeight.bold,
//                                 fontSize: 14,
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ),
//                   ),
//                   const SizedBox(width: 16),
//                   // Alone
//                   Expanded(
//                     child: GestureDetector(
//                       onTap: () => Navigator.pop(context, 'alone'),
//                       child: Container(
//                         padding: const EdgeInsets.all(16),
//                         decoration: BoxDecoration(
//                           color: Colors.white,
//                           borderRadius: BorderRadius.circular(12),
//                           border: Border.all(
//                             color: Colors.grey.shade300,
//                             width: 2,
//                           ),
//                         ),
//                         child: Column(
//                           children: [
//                             Container(
//                               width: 60,
//                               height: 60,
//                               decoration: BoxDecoration(
//                                 color: Colors.grey.shade100,
//                                 shape: BoxShape.circle,
//                               ),
//                               child: Icon(
//                                 Icons.person,
//                                 color: Colors.grey.shade600,
//                                 size: 32,
//                               ),
//                             ),
//                             const SizedBox(height: 12),
//                             const Text(
//                               'Alone',
//                               style: TextStyle(
//                                 color: Colors.black87,
//                                 fontWeight: FontWeight.bold,
//                                 fontSize: 14,
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//               const SizedBox(height: 24),
//               // Player Jerseys for assist
//               Text(
//                 'Or select a player for assist:',
//                 style: TextStyle(
//                   color: Colors.grey.shade600,
//                   fontSize: 14,
//                 ),
//               ),
//               const SizedBox(height: 12),
//               TextButton(
//                 onPressed: () => Navigator.pop(context, 'assist'),
//                 child: const Text(
//                   'Select Player',
//                   style: TextStyle(
//                     color: Colors.orange,
//                     fontWeight: FontWeight.bold,
//                     fontSize: 16,
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//
//     return result;
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     if (widget.match.status != 'live') {
//       return Container(
//         color: Colors.white,
//         child: Center(
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               Icon(Icons.sports_soccer, size: 80, color: Colors.grey.shade300),
//               const SizedBox(height: 16),
//               Text(
//                 'Start match to use referee controls',
//                 style: TextStyle(
//                   color: Colors.grey.shade600,
//                   fontSize: 16,
//                 ),
//               ),
//             ],
//           ),
//         ),
//       );
//     }
//
//     return Container(
//       color: Colors.white,
//       child: Column(
//         children: [
//           // Timer & Half Selector
//           Container(
//             padding: const EdgeInsets.all(16),
//             color: Colors.white,
//             child: Column(
//               children: [
//                 // Timer with Edit
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     Text(
//                       '${_matchMinute.toString().padLeft(2, '0')}:${(_matchMinute % 60).toString().padLeft(2, '0')}',
//                       style: const TextStyle(
//                         color: Colors.orange,
//                         fontSize: 42,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                     IconButton(
//                       icon: Icon(Icons.edit, color: Colors.grey.shade600),
//                       onPressed: () async {
//                         final minute = await _showMinuteEditDialog();
//                         if (minute != null) {
//                           setState(() => _matchMinute = minute);
//                         }
//                       },
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           ),
//
//           const Divider(height: 1),
//
//           // Control Buttons Grid
//           Expanded(
//             child: Padding(
//               padding: const EdgeInsets.all(16),
//               child: Row(
//                 children: [
//                   // Team A Controls
//                   Expanded(child: _buildTeamControls('teamA')),
//                   const SizedBox(width: 24),
//                   // Team B Controls
//                   Expanded(child: _buildTeamControls('teamB')),
//                 ],
//               ),
//             ),
//           ),
//
//           // Finish Half Button
//           Container(
//             padding: const EdgeInsets.all(16),
//             child: SizedBox(
//               width: double.infinity,
//               height: 50,
//               child: ElevatedButton(
//                 onPressed: () {
//                   setState(() => _isFirstHalf = !_isFirstHalf);
//                   ScaffoldMessenger.of(context).showSnackBar(
//                     SnackBar(
//                       content: Text(
//                         _isFirstHalf ? 'Second half started' : 'First half finished',
//                       ),
//                       backgroundColor: Colors.green,
//                     ),
//                   );
//                 },
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: Colors.orange,
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(12),
//                   ),
//                 ),
//                 child: Text(
//                   _isFirstHalf ? 'Finish first half' : 'Finish second half',
//                   style: const TextStyle(
//                     fontSize: 16,
//                     fontWeight: FontWeight.bold,
//                     color: Colors.white,
//                   ),
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildTeamControls(String team) {
//     return Column(
//       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//       children: [
//         // Goal
//         _buildControlButton(
//           icon: Icons.sports_soccer,
//           color: Colors.red,
//           onTap: () => _addGoal(team),
//         ),
//         // Red Card
//         _buildControlButton(
//           icon: Icons.square,
//           color: Colors.red.shade700,
//           onTap: () => _addCard(team, 'red'),
//         ),
//         // Yellow Card
//         _buildControlButton(
//           icon: Icons.square,
//           color: Colors.yellow.shade700,
//           onTap: () => _addCard(team, 'yellow'),
//         ),
//         // Substitution
//         _buildControlButton(
//           icon: Icons.swap_horiz,
//           color: Colors.green,
//           onTap: () => _addSubstitution(team),
//         ),
//         // Own Goal
//         _buildControlButton(
//           icon: Icons.sports_soccer,
//           color: Colors.blue,
//           onTap: () => _addGoal(team == 'teamA' ? 'teamB' : 'teamA'),
//         ),
//       ],
//     );
//   }
//
//   Widget _buildControlButton({
//     required IconData icon,
//     required Color color,
//     required VoidCallback onTap,
//   }) {
//     return GestureDetector(
//       onTap: onTap,
//       child: Container(
//         width: double.infinity,
//         height: 60,
//         decoration: BoxDecoration(
//           color: Colors.white,
//           borderRadius: BorderRadius.circular(50),
//           border: Border.all(color: Colors.grey.shade300, width: 2),
//         ),
//         child: Icon(icon, color: color, size: 32),
//       ),
//     );
//   }
//
//   // ✅ FIXED: Changed Widget to Future<int?>
//   Future<int?> _showMinuteEditDialog() async {
//     int tempMinute = _matchMinute;
//
//     return showDialog<int>(
//       context: context,
//       builder: (context) => StatefulBuilder(
//         builder: (context, setState) => AlertDialog(
//           backgroundColor: Colors.white,
//           shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
//           title: const Text(
//             'Edit Match Time',
//             style: TextStyle(color: Colors.black87),
//           ),
//           content: Row(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               IconButton(
//                 icon: const Icon(Icons.remove_circle, color: Colors.orange),
//                 onPressed: () {
//                   if (tempMinute > 0) setState(() => tempMinute--);
//                 },
//               ),
//               Text(
//                 "$tempMinute'",
//                 style: const TextStyle(
//                   color: Colors.black87,
//                   fontSize: 32,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//               IconButton(
//                 icon: const Icon(Icons.add_circle, color: Colors.orange),
//                 onPressed: () => setState(() => tempMinute++),
//               ),
//             ],
//           ),
//           actions: [
//             TextButton(
//               onPressed: () => Navigator.pop(context),
//               child: const Text('Cancel', style: TextStyle(color: Colors.grey)),
//             ),
//             ElevatedButton(
//               onPressed: () => Navigator.pop(context, tempMinute),
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: Colors.orange,
//               ),
//               child: const Text('OK', style: TextStyle(color: Colors.white)),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

//
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import '../../providers/match_provider.dart';
// import '../../models/match_model.dart';
//
// class MatchRefereeScreen extends StatefulWidget {
//   final MatchModel match;
//   final VoidCallback onUpdate;
//
//   const MatchRefereeScreen({
//     Key? key,
//     required this.match,
//     required this.onUpdate,
//   }) : super(key: key);
//
//   @override
//   State<MatchRefereeScreen> createState() => _MatchRefereeScreenState();
// }
//
// class _MatchRefereeScreenState extends State<MatchRefereeScreen> {
//   int _matchMinute = 0;
//   bool _isFirstHalf = true;
//
//   @override
//   void initState() {
//     super.initState();
//     if (widget.match.status == 'live') {
//       int calculatedMinute = DateTime.now().difference(widget.match.time).inMinutes;
//       _matchMinute = calculatedMinute > 0 ? calculatedMinute : 0;
//     } else {
//       _matchMinute = 0;
//     }
//   }
//
//   Future<void> _addGoal(String team) async {
//     LineUp? lineup = team == 'teamA' ? widget.match.lineUpA : widget.match.lineUpB;
//     String teamName = team == 'teamA' ? widget.match.teamAName : widget.match.teamBName;
//
//     if (lineup == null || lineup.players.isEmpty) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text('$teamName এর লাইনআপ সেট করা নেই'),
//           backgroundColor: Colors.red,
//         ),
//       );
//       return;
//     }
//
//     PlayerLineUp? scorer = await _showPlayerSelectionDialog(
//       lineup.players,
//       'Goal!! Who scored it?',
//       teamName,
//     );
//
//     if (scorer != null) {
//       String? assistType = await _showAssistTypeDialog();
//
//       PlayerLineUp? assist;
//       if (assistType == 'assist') {
//         assist = await _showPlayerSelectionDialog(
//           lineup.players.where((p) => p.playerId != scorer.playerId).toList(),
//           'whose assistance?',
//           teamName,
//         );
//       }
//
//       final event = MatchEvent(
//         type: 'goal',
//         team: team,
//         playerName: scorer.playerName,
//         playerId: scorer.playerId,
//         minute: _matchMinute,
//         assistPlayerId: assist?.playerId,
//         assistPlayerName: assist?.playerName,
//         assistType: assistType,
//       );
//
//       final matchProvider = Provider.of<MatchProvider>(context, listen: false);
//       final error = await matchProvider.addTimelineEvent(
//         widget.match.id,
//         event,
//       );
//
//       if (error != null) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text(error), backgroundColor: Colors.red),
//         );
//       } else {
//         int newScoreA = widget.match.scoreA + (team == 'teamA' ? 1 : 0);
//         int newScoreB = widget.match.scoreB + (team == 'teamB' ? 1 : 0);
//
//         await matchProvider.updateMatchScore(
//           widget.match.id,
//           newScoreA,
//           newScoreB,
//         );
//
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(
//             content: Text('Match event sent successfully'),
//             backgroundColor: Colors.green,
//           ),
//         );
//         widget.onUpdate();
//       }
//     }
//   }
//
//   Future<void> _addCard(String team, String cardType) async {
//     LineUp? lineup = team == 'teamA' ? widget.match.lineUpA : widget.match.lineUpB;
//     String teamName = team == 'teamA' ? widget.match.teamAName : widget.match.teamBName;
//
//     if (lineup == null || lineup.players.isEmpty) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text('$teamName এর লাইনআপ সেট করা নেই'),
//           backgroundColor: Colors.red,
//         ),
//       );
//       return;
//     }
//
//     String title = cardType == 'yellow' ? 'Yellow Card' : 'Red Card';
//     PlayerLineUp? player = await _showPlayerSelectionDialog(
//       lineup.players,
//       title,
//       teamName,
//     );
//
//     if (player != null) {
//       final event = MatchEvent(
//         type: 'card',
//         team: team,
//         playerName: player.playerName,
//         playerId: player.playerId,
//         minute: _matchMinute,
//         details: cardType,
//       );
//
//       final matchProvider = Provider.of<MatchProvider>(context, listen: false);
//       final error = await matchProvider.addTimelineEvent(
//         widget.match.id,
//         event,
//       );
//
//       if (error == null) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(
//             content: Text('Match event sent successfully'),
//             backgroundColor: Colors.green,
//           ),
//         );
//         widget.onUpdate();
//       }
//     }
//   }
//
//   Future<void> _addSubstitution(String team) async {
//     LineUp? lineup = team == 'teamA' ? widget.match.lineUpA : widget.match.lineUpB;
//     String teamName = team == 'teamA' ? widget.match.teamAName : widget.match.teamBName;
//
//     if (lineup == null || lineup.players.isEmpty) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text('$teamName এর লাইনআপ সেট করা নেই'),
//           backgroundColor: Colors.red,
//         ),
//       );
//       return;
//     }
//
//     PlayerLineUp? playerOut = await _showPlayerSelectionDialog(
//       lineup.players.where((p) => !p.isSubstitute).toList(),
//       'Player Out',
//       teamName,
//     );
//
//     if (playerOut != null) {
//       PlayerLineUp? playerIn = await _showPlayerSelectionDialog(
//         lineup.players.where((p) => p.isSubstitute).toList(),
//         'Player In',
//         teamName,
//       );
//
//       if (playerIn != null) {
//         final eventOut = MatchEvent(
//           type: 'substitution',
//           team: team,
//           playerName: playerOut.playerName,
//           playerId: playerOut.playerId,
//           minute: _matchMinute,
//           details: 'out',
//         );
//
//         final eventIn = MatchEvent(
//           type: 'substitution',
//           team: team,
//           playerName: playerIn.playerName,
//           playerId: playerIn.playerId,
//           minute: _matchMinute,
//           details: 'in',
//         );
//
//         final matchProvider = Provider.of<MatchProvider>(context, listen: false);
//         await matchProvider.addTimelineEvent(widget.match.id, eventOut);
//         await matchProvider.addTimelineEvent(widget.match.id, eventIn);
//
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(
//             content: Text('Match event sent successfully'),
//             backgroundColor: Colors.green,
//           ),
//         );
//         widget.onUpdate();
//       }
//     }
//   }
//
//   Future<PlayerLineUp?> _showPlayerSelectionDialog(
//       List<PlayerLineUp> players,
//       String title,
//       String teamName,
//       ) async {
//     if (players.isEmpty) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(
//           content: Text('No players available'),
//           backgroundColor: Colors.red,
//         ),
//       );
//       return null;
//     }
//
//     return showDialog<PlayerLineUp>(
//       context: context,
//       builder: (context) => Dialog(
//         backgroundColor: Colors.white,
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
//         child: Container(
//           padding: const EdgeInsets.all(20),
//           constraints: BoxConstraints(
//             maxHeight: MediaQuery.of(context).size.height * 0.7,
//           ),
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               Text(
//                 teamName,
//                 style: TextStyle(
//                   color: Colors.grey.shade600,
//                   fontSize: 14,
//                 ),
//               ),
//               const SizedBox(height: 8),
//               Text(
//                 title,
//                 style: const TextStyle(
//                   color: Colors.black,
//                   fontSize: 24,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//               const SizedBox(height: 20),
//               Flexible(
//                 child: GridView.builder(
//                   shrinkWrap: true,
//                   gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//                     crossAxisCount: 4,
//                     childAspectRatio: 0.8,
//                     crossAxisSpacing: 12,
//                     mainAxisSpacing: 12,
//                   ),
//                   itemCount: players.length,
//                   itemBuilder: (context, index) {
//                     return _buildPlayerJersey(players[index], context);
//                   },
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget _buildPlayerJersey(PlayerLineUp player, BuildContext context) {
//     return GestureDetector(
//       onTap: () => Navigator.pop(context, player),
//       child: Column(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           Container(
//             width: 70,
//             height: 70,
//             decoration: BoxDecoration(
//               color: Colors.red,
//               borderRadius: BorderRadius.circular(8),
//             ),
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 Text(
//                   player.playerName.isNotEmpty
//                       ? player.playerName.substring(0, 1).toUpperCase()
//                       : '?',
//                   style: const TextStyle(
//                     color: Colors.white,
//                     fontWeight: FontWeight.bold,
//                     fontSize: 18,
//                   ),
//                 ),
//                 const SizedBox(height: 4),
//                 Text(
//                   '${player.jerseyNumber}',
//                   style: const TextStyle(
//                     color: Colors.white,
//                     fontWeight: FontWeight.bold,
//                     fontSize: 16,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           const SizedBox(height: 4),
//           Text(
//             player.playerName,
//             style: const TextStyle(
//               color: Colors.black87,
//               fontSize: 10,
//               fontWeight: FontWeight.w500,
//             ),
//             maxLines: 1,
//             overflow: TextOverflow.ellipsis,
//             textAlign: TextAlign.center,
//           ),
//         ],
//       ),
//     );
//   }
//
//   Future<String?> _showAssistTypeDialog() async {
//     final result = await showDialog<String>(
//       context: context,
//       builder: (context) => Dialog(
//         backgroundColor: Colors.white,
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
//         child: Container(
//           padding: const EdgeInsets.all(20),
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               const Text(
//                 'whose assistance?',
//                 style: TextStyle(
//                   color: Colors.black,
//                   fontSize: 20,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//               const SizedBox(height: 24),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                 children: [
//                   Expanded(
//                     child: GestureDetector(
//                       onTap: () => Navigator.pop(context, 'penalty'),
//                       child: Container(
//                         padding: const EdgeInsets.all(16),
//                         decoration: BoxDecoration(
//                           color: Colors.white,
//                           borderRadius: BorderRadius.circular(12),
//                           border: Border.all(
//                             color: Colors.grey.shade300,
//                             width: 2,
//                           ),
//                         ),
//                         child: Column(
//                           children: [
//                             Container(
//                               width: 60,
//                               height: 60,
//                               decoration: BoxDecoration(
//                                 color: Colors.grey.shade100,
//                                 shape: BoxShape.circle,
//                               ),
//                               child: Icon(
//                                 Icons.sports_soccer,
//                                 color: Colors.grey.shade600,
//                                 size: 32,
//                               ),
//                             ),
//                             const SizedBox(height: 12),
//                             const Text(
//                               'Penalty kick',
//                               style: TextStyle(
//                                 color: Colors.black87,
//                                 fontWeight: FontWeight.bold,
//                                 fontSize: 14,
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ),
//                   ),
//                   const SizedBox(width: 16),
//                   Expanded(
//                     child: GestureDetector(
//                       onTap: () => Navigator.pop(context, 'alone'),
//                       child: Container(
//                         padding: const EdgeInsets.all(16),
//                         decoration: BoxDecoration(
//                           color: Colors.white,
//                           borderRadius: BorderRadius.circular(12),
//                           border: Border.all(
//                             color: Colors.grey.shade300,
//                             width: 2,
//                           ),
//                         ),
//                         child: Column(
//                           children: [
//                             Container(
//                               width: 60,
//                               height: 60,
//                               decoration: BoxDecoration(
//                                 color: Colors.grey.shade100,
//                                 shape: BoxShape.circle,
//                               ),
//                               child: Icon(
//                                 Icons.person,
//                                 color: Colors.grey.shade600,
//                                 size: 32,
//                               ),
//                             ),
//                             const SizedBox(height: 12),
//                             const Text(
//                               'Alone',
//                               style: TextStyle(
//                                 color: Colors.black87,
//                                 fontWeight: FontWeight.bold,
//                                 fontSize: 14,
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//               const SizedBox(height: 24),
//               Text(
//                 'Or select a player for assist:',
//                 style: TextStyle(
//                   color: Colors.grey.shade600,
//                   fontSize: 14,
//                 ),
//               ),
//               const SizedBox(height: 12),
//               TextButton(
//                 onPressed: () => Navigator.pop(context, 'assist'),
//                 child: const Text(
//                   'Select Player',
//                   style: TextStyle(
//                     color: Colors.orange,
//                     fontWeight: FontWeight.bold,
//                     fontSize: 16,
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//
//     return result;
//   }
//
//   // ✅ FIXED: Proper async method that returns Future<int?>
//   Future<int?> _showMinuteEditDialog() async {
//     int tempMinute = _matchMinute;
//     return showDialog<int>(
//       context: context,
//       builder: (context) => StatefulBuilder(
//         builder: (context, setState) => AlertDialog(
//           backgroundColor: Colors.white,
//           shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
//           title: const Text(
//             'Edit Match Time',
//             style: TextStyle(color: Colors.black87),
//           ),
//           content: Row(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               IconButton(
//                 icon: const Icon(Icons.remove_circle, color: Colors.orange),
//                 onPressed: () {
//                   if (tempMinute > 0) setState(() => tempMinute--);
//                 },
//               ),
//               Text(
//                 "$tempMinute'",
//                 style: const TextStyle(
//                   color: Colors.black87,
//                   fontSize: 32,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//               IconButton(
//                 icon: const Icon(Icons.add_circle, color: Colors.orange),
//                 onPressed: () => setState(() => tempMinute++),
//               ),
//             ],
//           ),
//           actions: [
//             TextButton(
//               onPressed: () => Navigator.pop(context),
//               child: const Text('Cancel', style: TextStyle(color: Colors.grey)),
//             ),
//             ElevatedButton(
//               onPressed: () => Navigator.pop(context, tempMinute),
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: Colors.orange,
//               ),
//               child: const Text('OK', style: TextStyle(color: Colors.white)),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     if (widget.match.status != 'live') {
//       return Container(
//         color: Colors.white,
//         child: Center(
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               Icon(Icons.sports_soccer, size: 80, color: Colors.grey.shade300),
//               const SizedBox(height: 16),
//               Text(
//                 'Start match to use referee controls',
//                 style: TextStyle(
//                   color: Colors.grey.shade600,
//                   fontSize: 16,
//                 ),
//               ),
//             ],
//           ),
//         ),
//       );
//     }
//
//     return Container(
//       color: Colors.white,
//       child: Column(
//         children: [
//           Container(
//             padding: const EdgeInsets.all(16),
//             color: Colors.white,
//             child: Column(
//               children: [
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     Text(
//                       '${_matchMinute.toString().padLeft(2, '0')}:${(_matchMinute % 60).toString().padLeft(2, '0')}',
//                       style: const TextStyle(
//                         color: Colors.orange,
//                         fontSize: 42,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                     IconButton(
//                       icon: Icon(Icons.edit, color: Colors.grey.shade600),
//                       onPressed: () async {
//                         final minute = await _showMinuteEditDialog();
//                         if (minute != null) {
//                           setState(() => _matchMinute = minute);
//                         }
//                       },
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           ),
//
//           const Divider(height: 1),
//
//           Expanded(
//             child: Padding(
//               padding: const EdgeInsets.all(16),
//               child: Row(
//                 children: [
//                   Expanded(child: _buildTeamControls('teamA')),
//                   const SizedBox(width: 24),
//                   Expanded(child: _buildTeamControls('teamB')),
//                 ],
//               ),
//             ),
//           ),
//
//           Container(
//             padding: const EdgeInsets.all(16),
//             child: SizedBox(
//               width: double.infinity,
//               height: 50,
//               child: ElevatedButton(
//                 onPressed: () {
//                   setState(() => _isFirstHalf = !_isFirstHalf);
//                   ScaffoldMessenger.of(context).showSnackBar(
//                     SnackBar(
//                       content: Text(
//                         _isFirstHalf ? 'Second half started' : 'First half finished',
//                       ),
//                       backgroundColor: Colors.green,
//                     ),
//                   );
//                 },
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: Colors.orange,
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(12),
//                   ),
//                 ),
//                 child: Text(
//                   _isFirstHalf ? 'Finish first half' : 'Finish second half',
//                   style: const TextStyle(
//                     fontSize: 16,
//                     fontWeight: FontWeight.bold,
//                     color: Colors.white,
//                   ),
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildTeamControls(String team) {
//     return Column(
//       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//       children: [
//         _buildControlButton(
//           icon: Icons.sports_soccer,
//           color: Colors.red,
//           onTap: () => _addGoal(team),
//         ),
//         _buildControlButton(
//           icon: Icons.square,
//           color: Colors.red.shade700,
//           onTap: () => _addCard(team, 'red'),
//         ),
//         _buildControlButton(
//           icon: Icons.square,
//           color: Colors.yellow.shade700,
//           onTap: () => _addCard(team, 'yellow'),
//         ),
//         _buildControlButton(
//           icon: Icons.swap_horiz,
//           color: Colors.green,
//           onTap: () => _addSubstitution(team),
//         ),
//         _buildControlButton(
//           icon: Icons.sports_soccer,
//           color: Colors.blue,
//           onTap: () => _addGoal(team == 'teamA' ? 'teamB' : 'teamA'),
//         ),
//       ],
//     );
//   }
//
//   Widget _buildControlButton({
//     required IconData icon,
//     required Color color,
//     required VoidCallback onTap,
//   }) {
//     return GestureDetector(
//       onTap: onTap,
//       child: Container(
//         width: double.infinity,
//         height: 60,
//         decoration: BoxDecoration(
//           color: Colors.white,
//           borderRadius: BorderRadius.circular(50),
//           border: Border.all(color: Colors.grey.shade300, width: 2),
//         ),
//         child: Icon(icon, color: color, size: 32),
//       ),
//     );
//   }
// }

// lib/screens/match/match_referee_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/match_provider.dart';
import '../../models/match_model.dart';

class MatchRefereeScreen extends StatefulWidget {
  final MatchModel match;
  final VoidCallback onUpdate;

  const MatchRefereeScreen({
    Key? key,
    required this.match,
    required this.onUpdate,
  }) : super(key: key);

  @override
  State<MatchRefereeScreen> createState() => _MatchRefereeScreenState();
}

class _MatchRefereeScreenState extends State<MatchRefereeScreen> {
  int _matchMinute = 0;
  bool _isFirstHalf = true;

  @override
  void initState() {
    super.initState();
    if (widget.match.status == 'live') {
      final elapsed = DateTime.now().difference(widget.match.time).inMinutes;
      _matchMinute = elapsed > 0 ? elapsed : 0;
    }
  }

  // ──────────────────────────────────────
  // Goal
  // ──────────────────────────────────────
  Future<void> _addGoal(String team) async {
    final lineup = team == 'teamA' ? widget.match.lineUpA : widget.match.lineUpB;
    final teamName = team == 'teamA' ? widget.match.teamAName : widget.match.teamBName;

    if (lineup == null || lineup.players.isEmpty) {
      _showSnack('$teamName এর লাইনআপ সেট করা নেই');
      return;
    }

    final scorer = await _selectPlayer(lineup.players, 'গোল করলেন কে?', teamName);
    if (scorer == null) return;

    final assistType = await _showAssistDialog();
    PlayerLineUp? assist;

    if (assistType == 'assist') {
      final filtered = lineup.players.where((p) => p.playerId != scorer.playerId).toList();
      assist = await _selectPlayer(filtered, 'অ্যাসিস্ট কার?', teamName);
    }

    final event = MatchEvent(
      type: 'goal',
      team: team,
      playerId: scorer.playerId,
      playerName: scorer.playerName,
      minute: _matchMinute,
      assistPlayerId: assist?.playerId,
      assistPlayerName: assist?.playerName,
      assistType: assistType,
    );

    await _saveEventAndUpdateScore(event, team);
  }

  // ──────────────────────────────────────
  // Card
  // ──────────────────────────────────────
  Future<void> _addCard(String team, String cardType) async {
    final lineup = team == 'teamA' ? widget.match.lineUpA : widget.match.lineUpB;
    final teamName = team == 'teamA' ? widget.match.teamAName : widget.match.teamBName;

    if (lineup == null || lineup.players.isEmpty) {
      _showSnack('$teamName এর লাইনআপ সেট করা নেই');
      return;
    }

    final player = await _selectPlayer(
      lineup.players,
      cardType == 'yellow' ? 'হলুদ কার্ড' : 'লাল কার্ড',
      teamName,
    );

    if (player == null) return;

    final event = MatchEvent(
      type: 'card',
      team: team,
      playerId: player.playerId,
      playerName: player.playerName,
      minute: _matchMinute,
      details: cardType,
    );

    await _saveEvent(event);
  }

  // ──────────────────────────────────────
  // Substitution
  // ──────────────────────────────────────
  Future<void> _addSubstitution(String team) async {
    final lineup = team == 'teamA' ? widget.match.lineUpA : widget.match.lineUpB;
    final teamName = team == 'teamA' ? widget.match.teamAName : widget.match.teamBName;

    if (lineup == null || lineup.players.isEmpty) {
      _showSnack('$teamName এর লাইনআপ সেট করা নেই');
      return;
    }

    final mainPlayers = lineup.players.where((p) => !p.isSubstitute).toList();
    final benchPlayers = lineup.players.where((p) => p.isSubstitute).toList();

    final playerOut = await _selectPlayer(mainPlayers, 'খেলোয়াড় বের হবে', teamName);
    if (playerOut == null) return;

    final playerIn = await _selectPlayer(benchPlayers, 'খেলোয়াড় ঢুকবে', teamName);
    if (playerIn == null) return;

    final outEvent = MatchEvent(
      type: 'substitution',
      team: team,
      playerId: playerOut.playerId,
      playerName: playerOut.playerName,
      minute: _matchMinute,
      details: 'out',
    );

    final inEvent = MatchEvent(
      type: 'substitution',
      team: team,
      playerId: playerIn.playerId,
      playerName: playerIn.playerName,
      minute: _matchMinute,
      details: 'in',
    );

    final mp = Provider.of<MatchProvider>(context, listen: false);
    await mp.addTimelineEvent(widget.match.id, outEvent);
    await mp.addTimelineEvent(widget.match.id, inEvent);

    _showSnack('সাবস্টিটিউশন সফলভাবে যোগ হয়েছে', Colors.green);
    widget.onUpdate();
  }

  // ──────────────────────────────────────
  // Common Helpers
  // ──────────────────────────────────────
  Future<PlayerLineUp?> _selectPlayer(List<PlayerLineUp> players, String title, String teamName) async {
    if (players.isEmpty) {
      _showSnack('কোনো খেলোয়াড় পাওয়া যায়নি');
      return null;
    }

    return showDialog<PlayerLineUp>(
      context: context,
      builder: (_) => _PlayerSelectionDialog(players: players, title: title, teamName: teamName),
    );
  }

  Future<String?> _showAssistDialog() async {
    return showDialog<String>(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('অ্যাসিস্ট কীভাবে?', textAlign: TextAlign.center),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _assistOption('penalty', 'পেনাল্টি কিক', Icons.sports_soccer),
            const SizedBox(height: 12),
            _assistOption('alone', 'একা গোল', Icons.person),
            const SizedBox(height: 20),
            TextButton(
              onPressed: () => Navigator.pop(context, 'assist'),
              child: const Text('খেলোয়াড়ের অ্যাসিস্ট', style: TextStyle(color: Colors.orange, fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _assistOption(String value, String label, IconData icon) {
    return InkWell(
      onTap: () => Navigator.pop(context, value),
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(border: Border.all(color: Colors.grey.shade300), borderRadius: BorderRadius.circular(12)),
        child: Row(
          children: [
            Icon(icon, color: Colors.orange),
            const SizedBox(width: 12),
            Text(label, style: const TextStyle(fontSize: 16)),
          ],
        ),
      ),
    );
  }

  Future<void> _saveEvent(MatchEvent event) async {
    final mp = Provider.of<MatchProvider>(context, listen: false);
    final error = await mp.addTimelineEvent(widget.match.id, event);
    if (error == null) {
      _showSnack('ইভেন্ট সফলভাবে যোগ হয়েছে', Colors.green);
      widget.onUpdate();
    } else {
      _showSnack(error);
    }
  }

  Future<void> _saveEventAndUpdateScore(MatchEvent event, String team) async {
    final mp = Provider.of<MatchProvider>(context, listen: false);
    final error = await mp.addTimelineEvent(widget.match.id, event);
    if (error == null) {
      final newA = widget.match.scoreA + (team == 'teamA' ? 1 : 0);
      final newB = widget.match.scoreB + (team == 'teamB' ? 1 : 0);
      await mp.updateMatchScore(widget.match.id, newA, newB);
      _showSnack('গোল যোগ হয়েছে!', Colors.green);
      widget.onUpdate();
    } else {
      _showSnack(error);
    }
  }

  void _showSnack(String msg, [Color? color]) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg), backgroundColor: color ?? Colors.red),
    );
  }

  // ──────────────────────────────────────
  // UI
  // ──────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    if (widget.match.status != 'live') {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.sports_soccer, size: 80, color: Colors.grey),
            SizedBox(height: 16),
            Text('ম্যাচ শুরু করুন রেফারি কন্ট্রোল ব্যবহার করতে', style: TextStyle(color: Colors.grey)),
          ],
        ),
      );
    }

    return Column(
      children: [
        // Timer
        Container(
          padding: const EdgeInsets.all(20),
          color: Colors.white,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '${_matchMinute.toString().padLeft(2, '0')}:00',
                style: const TextStyle(fontSize: 48, fontWeight: FontWeight.bold, color: Colors.orange),
              ),
              const SizedBox(width: 10),
              IconButton(
                icon: const Icon(Icons.edit, color: Colors.grey),
                onPressed: () async {
                  final m = await _showMinutePicker();
                  if (m != null) setState(() => _matchMinute = m);
                },
              ),
            ],
          ),
        ),
        const Divider(height: 1),

        // Team Controls
        Expanded(
          child: Row(
            children: [
              Expanded(child: _teamControls('teamA')),
              const VerticalDivider(),
              Expanded(child: _teamControls('teamB')),
            ],
          ),
        ),

        // Half Switch
        Padding(
          padding: const EdgeInsets.all(16),
          child: SizedBox(
            height: 56,
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.orange, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
              onPressed: () {
                setState(() => _isFirstHalf = !_isFirstHalf);
                _showSnack(_isFirstHalf ? 'দ্বিতীয় হাফ শুরু' : 'প্রথম হাফ শেষ', Colors.green);
              },
              child: Text(_isFirstHalf ? 'প্রথম হাফ শেষ করুন' : 'ম্যাচ শেষ করুন', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            ),
          ),
        ),
      ],
    );
  }

  Widget _teamControls(String team) {
    final isLeft = team == 'teamA';
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _ctrlBtn(Icons.sports_soccer, Colors.green, () => _addGoal(team)),           // Goal
        _ctrlBtn(Icons.square, Colors.yellow.shade700, () => _addCard(team, 'yellow')), // Yellow
        _ctrlBtn(Icons.square, Colors.red.shade700, () => _addCard(team, 'red')),       // Red
        _ctrlBtn(Icons.swap_horiz, Colors.blue, () => _addSubstitution(team)),         // Sub
        _ctrlBtn(Icons.sports_soccer, Colors.purple, () => _addGoal(team == 'teamA' ? 'teamB' : 'teamA')), // Own Goal
      ],
    );
  }

  Widget _ctrlBtn(IconData icon, Color color, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(50),
      child: Container(
        width: 70,
        height: 70,
        decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.white, border: Border.all(color: Colors.grey.shade300, width: 3)),
        child: Icon(icon, color: color, size: 36),
      ),
    );
  }

  Future<int?> _showMinutePicker() async {
    int temp = _matchMinute;
    return showDialog<int>(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('মিনিট সেট করুন'),
        content: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(onPressed: () => setState(() => temp = (temp - 1).clamp(0, 120)), icon: const Icon(Icons.remove)),
            Text('$temp\'', style: const TextStyle(fontSize: 36, fontWeight: FontWeight.bold)),
            IconButton(onPressed: () => setState(() => temp = (temp + 1).clamp(0, 120)), icon: const Icon(Icons.add)),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('বাতিল')),
          ElevatedButton(onPressed: () => Navigator.pop(context, temp), child: const Text('ঠিক আছে')),
        ],
      ),
    );
  }
}

// ──────────────────────────────────────
// Player Selection Dialog (Separate Widget)
// ──────────────────────────────────────
class _PlayerSelectionDialog extends StatelessWidget {
  final List<PlayerLineUp> players;
  final String title;
  final String teamName;

  const _PlayerSelectionDialog({required this.players, required this.title, required this.teamName});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(teamName, style: TextStyle(color: Colors.grey.shade600)),
            const SizedBox(height: 8),
            Text(title, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),
            SizedBox(
              height: 400,
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4,
                  childAspectRatio: 0.9,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                ),
                itemCount: players.length,
                itemBuilder: (_, i) {
                  final p = players[i];
                  return GestureDetector(
                    onTap: () => Navigator.pop(context, p),
                    child: Column(
                      children: [
                        Container(
                          width: 64,
                          height: 64,
                          decoration: BoxDecoration(color: Colors.red.shade600, borderRadius: BorderRadius.circular(12)),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(p.playerName.isNotEmpty ? p.playerName[0].toUpperCase() : '?',
                                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20)),
                              Text('${p.jerseyNumber}', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
                            ],
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(p.playerName, style: const TextStyle(fontSize: 11), textAlign: TextAlign.center, maxLines: 1, overflow: TextOverflow.ellipsis),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}