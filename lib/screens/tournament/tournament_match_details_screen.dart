// // import 'package:flutter/material.dart';
// // import 'package:intl/intl.dart';
// // import 'package:cloud_firestore/cloud_firestore.dart';
// // import '../../models/tournament_model.dart'; // আপনার মডেলের পাথ অনুযায়ী পরিবর্তন করুন
// //
// // class TournamentMatchDetailsScreen extends StatefulWidget {
// //   final String matchId;
// //
// //   const TournamentMatchDetailsScreen({Key? key, required this.matchId}) : super(key: key);
// //
// //   @override
// //   State<TournamentMatchDetailsScreen> createState() => _TournamentMatchDetailsScreenState();
// // }
// //
// // class _TournamentMatchDetailsScreenState extends State<TournamentMatchDetailsScreen> {
// //   final FirebaseFirestore _firestore = FirebaseFirestore.instance;
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     return StreamBuilder<DocumentSnapshot>(
// //       stream: _firestore.collection('tournament_matches').doc(widget.matchId).snapshots(),
// //       builder: (context, snapshot) {
// //         if (snapshot.hasError) return const Scaffold(body: Center(child: Text("Error loading match")));
// //         if (!snapshot.hasData || !snapshot.data!.exists) {
// //           return const Scaffold(body: Center(child: CircularProgressIndicator()));
// //         }
// //
// //         final match = TournamentMatch.fromFirestore(snapshot.data!);
// //
// //         return Scaffold(
// //           appBar: AppBar(
// //             title: Text(match.round),
// //             backgroundColor: Colors.orange.shade700,
// //             actions: [
// //               if (match.status != 'finished')
// //                 IconButton(
// //                   icon: const Icon(Icons.edit),
// //                   onPressed: () => _showEditScoreDialog(match),
// //                 ),
// //             ],
// //           ),
// //           body: SingleChildScrollView(
// //             child: Column(
// //               children: [
// //                 _buildScoreHeader(match),
// //                 const SizedBox(height: 20),
// //                 _buildMatchInfo(match),
// //                 const Divider(),
// //                 _buildStatusSection(match),
// //               ],
// //             ),
// //           ),
// //           bottomNavigationBar: match.status != 'finished'
// //               ? _buildAdminActions(match)
// //               : null,
// //         );
// //       },
// //     );
// //   }
// //
// //   Widget _buildScoreHeader(TournamentMatch match) {
// //     return Container(
// //       padding: const EdgeInsets.all(24),
// //       decoration: BoxDecoration(
// //         color: Colors.orange.shade700,
// //         borderRadius: const BorderRadius.only(
// //           bottomLeft: Radius.circular(30),
// //           bottomRight: Radius.circular(30),
// //         ),
// //       ),
// //       child: Row(
// //         mainAxisAlignment: MainAxisAlignment.spaceAround,
// //         children: [
// //           _buildTeamInfo(match.teamAName, match.teamALogo, match.scoreA),
// //           const Text("VS", style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
// //           _buildTeamInfo(match.teamBName, match.teamBLogo, match.scoreB),
// //         ],
// //       ),
// //     );
// //   }
// //
// //   Widget _buildTeamInfo(String name, String? logo, int score) {
// //     return Column(
// //       children: [
// //         CircleAvatar(
// //           radius: 35,
// //           backgroundColor: Colors.white,
// //           backgroundImage: logo != null && logo.isNotEmpty ? NetworkImage(logo) : null,
// //           child: logo == null || logo.isEmpty ? const Icon(Icons.shield, size: 40) : null,
// //         ),
// //         const SizedBox(height: 10),
// //         Text(name, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
// //         const SizedBox(height: 5),
// //         Text("$score", style: const TextStyle(color: Colors.white, fontSize: 36, fontWeight: FontWeight.bold)),
// //       ],
// //     );
// //   }
// //
// //   Widget _buildMatchInfo(TournamentMatch match) {
// //     return Padding(
// //       padding: const EdgeInsets.symmetric(horizontal: 16),
// //       child: Card(
// //         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
// //         child: Padding(
// //           padding: const EdgeInsets.all(16),
// //           child: Column(
// //             children: [
// //               _infoRow(Icons.calendar_month, "তারিখ", DateFormat('dd MMM yyyy').format(match.matchDate)),
// //               _infoRow(Icons.access_time, "সময়", DateFormat('hh:mm a').format(match.matchDate)),
// //               _infoRow(Icons.location_on, "ভেন্যু", match.venue),
// //               if (match.groupName != null) _infoRow(Icons.groups, "গ্রুপ", match.groupName!),
// //             ],
// //           ),
// //         ),
// //       ),
// //     );
// //   }
// //
// //   Widget _infoRow(IconData icon, String label, String value) {
// //     return Padding(
// //       padding: const EdgeInsets.symmetric(vertical: 8),
// //       child: Row(
// //         children: [
// //           Icon(icon, size: 20, color: Colors.orange),
// //           const SizedBox(width: 10),
// //           Text("$label: ", style: const TextStyle(fontWeight: FontWeight.bold)),
// //           Text(value),
// //         ],
// //       ),
// //     );
// //   }
// //
// //   Widget _buildStatusSection(TournamentMatch match) {
// //     Color statusColor = match.status == 'live' ? Colors.green : Colors.orange;
// //     return Container(
// //       margin: const EdgeInsets.all(16),
// //       padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
// //       decoration: BoxDecoration(
// //         color: statusColor.withOpacity(0.1),
// //         borderRadius: BorderRadius.circular(20),
// //         border: Border.all(color: statusColor),
// //       ),
// //       child: Text(
// //         "ম্যাচ স্ট্যাটাস: ${match.status.toUpperCase()}",
// //         style: TextStyle(color: statusColor, fontWeight: FontWeight.bold),
// //       ),
// //     );
// //   }
// //
// //   Widget _buildAdminActions(TournamentMatch match) {
// //     return SafeArea(
// //       child: Padding(
// //         padding: const EdgeInsets.all(8.0),
// //         child: Row(
// //           children: [
// //             Expanded(
// //               child: ElevatedButton(
// //                 style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
// //                 onPressed: () => _updateMatchStatus(match, 'live'),
// //                 child: const Text("লাইভ করুন", style: TextStyle(color: Colors.white)),
// //               ),
// //             ),
// //             const SizedBox(width: 8),
// //             Expanded(
// //               child: ElevatedButton(
// //                 style: ElevatedButton.styleFrom(backgroundColor: Colors.grey),
// //                 onPressed: () => _confirmFinishMatch(match),
// //                 child: const Text("ম্যাচ শেষ", style: TextStyle(color: Colors.white)),
// //               ),
// //             ),
// //           ],
// //         ),
// //       ),
// //     );
// //   }
// //
// //   void _showEditScoreDialog(TournamentMatch match) {
// //     int sA = match.scoreA;
// //     int sB = match.scoreB;
// //     showDialog(
// //       context: context,
// //       builder: (context) => AlertDialog(
// //         title: const Text("স্কোর আপডেট করুন"),
// //         content: Column(
// //           mainAxisSize: MainAxisSize.min,
// //           children: [
// //             ListTile(
// //               title: Text(match.teamAName),
// //               trailing: Row(mainAxisSize: MainAxisSize.min, children: [
// //                 IconButton(icon: const Icon(Icons.remove), onPressed: () => sA--),
// //                 Text("$sA"),
// //                 IconButton(icon: const Icon(Icons.add), onPressed: () => sA++),
// //               ]),
// //             ),
// //             ListTile(
// //               title: Text(match.teamBName),
// //               trailing: Row(mainAxisSize: MainAxisSize.min, children: [
// //                 IconButton(icon: const Icon(Icons.remove), onPressed: () => sB--),
// //                 Text("$sB"),
// //                 IconButton(icon: const Icon(Icons.add), onPressed: () => sB++),
// //               ]),
// //             ),
// //           ],
// //         ),
// //         actions: [
// //           TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancel")),
// //           ElevatedButton(
// //             onPressed: () {
// //               _firestore.collection('tournament_matches').doc(match.matchId).update({
// //                 'scoreA': sA,
// //                 'scoreB': sB,
// //               });
// //               Navigator.pop(context);
// //             },
// //             child: const Text("Update"),
// //           ),
// //         ],
// //       ),
// //     );
// //   }
// //
// //   void _updateMatchStatus(TournamentMatch match, String newStatus) {
// //     _firestore.collection('tournament_matches').doc(match.matchId).update({'status': newStatus});
// //   }
// //
// //   void _confirmFinishMatch(TournamentMatch match) {
// //     showDialog(
// //       context: context,
// //       builder: (context) => AlertDialog(
// //         title: const Text("ম্যাচ কি শেষ?"),
// //         content: const Text("ম্যাচ শেষ করলে পয়েন্ট টেবিল আপডেট হবে।"),
// //         actions: [
// //           TextButton(onPressed: () => Navigator.pop(context), child: const Text("না")),
// //           ElevatedButton(
// //             onPressed: () {
// //               _updateMatchStatus(match, 'finished');
// //               Navigator.pop(context);
// //             },
// //             child: const Text("হ্যাঁ, শেষ"),
// //           ),
// //         ],
// //       ),
// //     );
// //   }
// // }
//
// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import '../../models/tournament_model.dart';
//
// class TournamentMatchDetailsScreen extends StatefulWidget {
//   final String matchId;
//
//   const TournamentMatchDetailsScreen({Key? key, required this.matchId}) : super(key: key);
//
//   @override
//   State<TournamentMatchDetailsScreen> createState() => _TournamentMatchDetailsScreenState();
// }
//
// class _TournamentMatchDetailsScreenState extends State<TournamentMatchDetailsScreen> {
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;
//   final TextEditingController _scoreAController = TextEditingController();
//   final TextEditingController _scoreBController = TextEditingController();
//
//   @override
//   void dispose() {
//     _scoreAController.dispose();
//     _scoreBController.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return StreamBuilder<DocumentSnapshot>(
//       stream: _firestore.collection('tournament_matches').doc(widget.matchId).snapshots(),
//       builder: (context, snapshot) {
//         if (snapshot.hasError) {
//           return Scaffold(
//             backgroundColor: const Color(0xFF0F1419),
//             appBar: AppBar(
//               backgroundColor: const Color(0xFF1C2128),
//               title: const Text('Error'),
//             ),
//             body: _buildErrorState(snapshot.error.toString()),
//           );
//         }
//
//         if (!snapshot.hasData || !snapshot.data!.exists) {
//           return Scaffold(
//             backgroundColor: const Color(0xFF0F1419),
//             body: _buildLoadingState(),
//           );
//         }
//
//         final match = TournamentMatch.fromFirestore(snapshot.data!);
//
//         return Scaffold(
//           backgroundColor: const Color(0xFF0F1419),
//           body: CustomScrollView(
//             slivers: [
//               _buildAppBar(match),
//               SliverToBoxAdapter(
//                 child: Column(
//                   children: [
//                     _buildScoreHeader(match),
//                     const SizedBox(height: 20),
//                     _buildMatchInfo(match),
//                     const SizedBox(height: 16),
//                     _buildStatusSection(match),
//                     const SizedBox(height: 100), // Space for bottom actions
//                   ],
//                 ),
//               ),
//             ],
//           ),
//           bottomNavigationBar: match.status != 'finished' ? _buildAdminActions(match) : null,
//         );
//       },
//     );
//   }
//
//   Widget _buildAppBar(TournamentMatch match) {
//     return SliverAppBar(
//       expandedHeight: 80,
//       floating: false,
//       pinned: true,
//       backgroundColor: const Color(0xFF1C2128),
//       leading: IconButton(
//         icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
//         onPressed: () => Navigator.pop(context),
//       ),
//       flexibleSpace: FlexibleSpaceBar(
//         title: Text(
//           match.round,
//           style: const TextStyle(
//             color: Colors.white,
//             fontSize: 16,
//             fontWeight: FontWeight.bold,
//           ),
//         ),
//         centerTitle: true,
//       ),
//       actions: [
//         if (match.status != 'finished')
//           IconButton(
//             icon: const Icon(Icons.edit_rounded, color: Colors.white),
//             onPressed: () => _showEditScoreDialog(match),
//             tooltip: 'স্কোর আপডেট করুন',
//           ),
//       ],
//     );
//   }
//
//   Widget _buildScoreHeader(TournamentMatch match) {
//     return Container(
//       margin: const EdgeInsets.all(16),
//       padding: const EdgeInsets.all(24),
//       decoration: BoxDecoration(
//         gradient: LinearGradient(
//           begin: Alignment.topLeft,
//           end: Alignment.bottomRight,
//           colors: [
//             Colors.orange.shade800,
//             Colors.orange.shade600,
//           ],
//         ),
//         borderRadius: BorderRadius.circular(24),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.orange.shade900.withOpacity(0.3),
//             blurRadius: 20,
//             offset: const Offset(0, 8),
//           ),
//         ],
//       ),
//       child: Column(
//         children: [
//           // Match Status Badge
//           Container(
//             padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
//             decoration: BoxDecoration(
//               color: Colors.white.withOpacity(0.2),
//               borderRadius: BorderRadius.circular(20),
//               border: Border.all(color: Colors.white.withOpacity(0.3), width: 1),
//             ),
//             child: Row(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 Container(
//                   width: 8,
//                   height: 8,
//                   decoration: BoxDecoration(
//                     color: _getStatusColor(match.status),
//                     shape: BoxShape.circle,
//                   ),
//                 ),
//                 const SizedBox(width: 8),
//                 Text(
//                   _getStatusBengali(match.status).toUpperCase(),
//                   style: const TextStyle(
//                     color: Colors.white,
//                     fontSize: 12,
//                     fontWeight: FontWeight.bold,
//                     letterSpacing: 1,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           const SizedBox(height: 24),
//
//           // Teams and Score
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceAround,
//             crossAxisAlignment: CrossAxisAlignment.center,
//             children: [
//               _buildTeamInfo(match.teamAName, match.teamALogo, match.scoreA, true),
//               Column(
//                 children: [
//                   const Text(
//                     'VS',
//                     style: TextStyle(
//                       color: Colors.white70,
//                       fontSize: 16,
//                       fontWeight: FontWeight.bold,
//                       letterSpacing: 2,
//                     ),
//                   ),
//                   const SizedBox(height: 8),
//                   Text(
//                     '${match.scoreA} - ${match.scoreB}',
//                     style: const TextStyle(
//                       color: Colors.white,
//                       fontSize: 32,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                 ],
//               ),
//               _buildTeamInfo(match.teamBName, match.teamBLogo, match.scoreB, false),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildTeamInfo(String name, String? logo, int score, bool isTeamA) {
//     return Column(
//       children: [
//         Stack(
//           children: [
//             Container(
//               decoration: BoxDecoration(
//                 shape: BoxShape.circle,
//                 border: Border.all(
//                   color: Colors.white.withOpacity(0.3),
//                   width: 3,
//                 ),
//                 boxShadow: [
//                   BoxShadow(
//                     color: Colors.black.withOpacity(0.2),
//                     blurRadius: 12,
//                     offset: const Offset(0, 4),
//                   ),
//                 ],
//               ),
//               child: CircleAvatar(
//                 radius: 42,
//                 backgroundColor: Colors.white.withOpacity(0.1),
//                 backgroundImage: logo != null && logo.isNotEmpty ? NetworkImage(logo) : null,
//                 child: logo == null || logo.isEmpty
//                     ? const Icon(Icons.shield, size: 48, color: Colors.white70)
//                     : null,
//               ),
//             ),
//           ],
//         ),
//         const SizedBox(height: 12),
//         SizedBox(
//           width: 100,
//           child: Text(
//             name,
//             style: const TextStyle(
//               color: Colors.white,
//               fontWeight: FontWeight.bold,
//               fontSize: 15,
//             ),
//             textAlign: TextAlign.center,
//             maxLines: 2,
//             overflow: TextOverflow.ellipsis,
//           ),
//         ),
//       ],
//     );
//   }
//
//   Widget _buildMatchInfo(TournamentMatch match) {
//     return Container(
//       margin: const EdgeInsets.symmetric(horizontal: 16),
//       padding: const EdgeInsets.all(20),
//       decoration: BoxDecoration(
//         color: const Color(0xFF1C2128),
//         borderRadius: BorderRadius.circular(20),
//         border: Border.all(color: Colors.white.withOpacity(0.05), width: 1),
//       ),
//       child: Column(
//         children: [
//           _buildInfoRow(
//             Icons.calendar_month_rounded,
//             'তারিখ',
//             DateFormat('dd MMMM yyyy').format(match.matchDate),
//             Colors.blue,
//           ),
//           const SizedBox(height: 16),
//           _buildInfoRow(
//             Icons.access_time_rounded,
//             'সময়',
//             DateFormat('hh:mm a').format(match.matchDate),
//             Colors.green,
//           ),
//           const SizedBox(height: 16),
//           _buildInfoRow(
//             Icons.location_on_rounded,
//             'ভেন্যু',
//             match.venue,
//             Colors.red,
//           ),
//           if (match.groupName != null) ...[
//             const SizedBox(height: 16),
//             _buildInfoRow(
//               Icons.workspaces_rounded,
//               'গ্রুপ',
//               match.groupName!,
//               Colors.purple,
//             ),
//           ],
//         ],
//       ),
//     );
//   }
//
//   Widget _buildInfoRow(IconData icon, String label, String value, Color color) {
//     return Row(
//       children: [
//         Container(
//           padding: const EdgeInsets.all(10),
//           decoration: BoxDecoration(
//             color: color.withOpacity(0.1),
//             borderRadius: BorderRadius.circular(12),
//           ),
//           child: Icon(icon, size: 22, color: color),
//         ),
//         const SizedBox(width: 16),
//         Expanded(
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text(
//                 label,
//                 style: TextStyle(
//                   color: Colors.grey.shade500,
//                   fontSize: 12,
//                   fontWeight: FontWeight.w600,
//                 ),
//               ),
//               const SizedBox(height: 4),
//               Text(
//                 value,
//                 style: const TextStyle(
//                   color: Colors.white,
//                   fontSize: 15,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ],
//     );
//   }
//
//   Widget _buildStatusSection(TournamentMatch match) {
//     Color statusColor = _getStatusColor(match.status);
//     String statusText = _getStatusBengali(match.status);
//     IconData statusIcon = _getStatusIcon(match.status);
//
//     return Container(
//       margin: const EdgeInsets.symmetric(horizontal: 16),
//       padding: const EdgeInsets.all(20),
//       decoration: BoxDecoration(
//         gradient: LinearGradient(
//           begin: Alignment.topLeft,
//           end: Alignment.bottomRight,
//           colors: [
//             statusColor.withOpacity(0.1),
//             statusColor.withOpacity(0.05),
//           ],
//         ),
//         borderRadius: BorderRadius.circular(20),
//         border: Border.all(color: statusColor.withOpacity(0.3), width: 2),
//       ),
//       child: Row(
//         children: [
//           Container(
//             padding: const EdgeInsets.all(12),
//             decoration: BoxDecoration(
//               color: statusColor.withOpacity(0.2),
//               borderRadius: BorderRadius.circular(12),
//             ),
//             child: Icon(statusIcon, color: statusColor, size: 28),
//           ),
//           const SizedBox(width: 16),
//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   'ম্যাচ স্ট্যাটাস',
//                   style: TextStyle(
//                     color: Colors.grey.shade500,
//                     fontSize: 12,
//                     fontWeight: FontWeight.w600,
//                   ),
//                 ),
//                 const SizedBox(height: 4),
//                 Text(
//                   statusText.toUpperCase(),
//                   style: TextStyle(
//                     color: statusColor,
//                     fontWeight: FontWeight.bold,
//                     fontSize: 18,
//                     letterSpacing: 1,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildAdminActions(TournamentMatch match) {
//     return Container(
//       padding: const EdgeInsets.all(20),
//       decoration: BoxDecoration(
//         color: const Color(0xFF1C2128),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.3),
//             blurRadius: 20,
//             offset: const Offset(0, -5),
//           ),
//         ],
//       ),
//       child: SafeArea(
//         child: Row(
//           children: [
//             if (match.status == 'upcoming') ...[
//               Expanded(
//                 child: _buildActionButton(
//                   'লাইভ করুন',
//                   Icons.play_circle_filled_rounded,
//                   Colors.green,
//                       () => _updateMatchStatus(match, 'live'),
//                 ),
//               ),
//               const SizedBox(width: 12),
//               Expanded(
//                 child: _buildActionButton(
//                   'স্কোর আপডেট',
//                   Icons.edit_rounded,
//                   Colors.orange,
//                       () => _showEditScoreDialog(match),
//                 ),
//               ),
//             ] else if (match.status == 'live') ...[
//               Expanded(
//                 child: _buildActionButton(
//                   'স্কোর আপডেট',
//                   Icons.edit_rounded,
//                   Colors.orange,
//                       () => _showEditScoreDialog(match),
//                 ),
//               ),
//               const SizedBox(width: 12),
//               Expanded(
//                 child: _buildActionButton(
//                   'ম্যাচ শেষ',
//                   Icons.check_circle_rounded,
//                   Colors.blue,
//                       () => _confirmFinishMatch(match),
//                 ),
//               ),
//             ],
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _buildActionButton(String label, IconData icon, Color color, VoidCallback onPressed) {
//     return Container(
//       height: 56,
//       decoration: BoxDecoration(
//         gradient: LinearGradient(
//           colors: [color, color.withOpacity(0.8)],
//         ),
//         borderRadius: BorderRadius.circular(16),
//         boxShadow: [
//           BoxShadow(
//             color: color.withOpacity(0.3),
//             blurRadius: 12,
//             offset: const Offset(0, 4),
//           ),
//         ],
//       ),
//       child: Material(
//         color: Colors.transparent,
//         child: InkWell(
//           onTap: onPressed,
//           borderRadius: BorderRadius.circular(16),
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               Icon(icon, color: Colors.white, size: 22),
//               const SizedBox(width: 10),
//               Text(
//                 label,
//                 style: const TextStyle(
//                   color: Colors.white,
//                   fontSize: 15,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
//   void _showEditScoreDialog(TournamentMatch match) {
//     _scoreAController.text = match.scoreA.toString();
//     _scoreBController.text = match.scoreB.toString();
//
//     showDialog(
//       context: context,
//       builder: (context) => AlertDialog(
//         backgroundColor: const Color(0xFF1C2128),
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
//         title: Row(
//           children: [
//             Container(
//               padding: const EdgeInsets.all(8),
//               decoration: BoxDecoration(
//                 color: Colors.orange.shade700.withOpacity(0.2),
//                 borderRadius: BorderRadius.circular(8),
//               ),
//               child: Icon(Icons.edit_rounded, color: Colors.orange.shade700),
//             ),
//             const SizedBox(width: 12),
//             const Text(
//               'স্কোর আপডেট করুন',
//               style: TextStyle(color: Colors.white, fontSize: 18),
//             ),
//           ],
//         ),
//         content: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             _buildScoreInput(match.teamAName, match.teamALogo, _scoreAController),
//             const SizedBox(height: 20),
//             _buildScoreInput(match.teamBName, match.teamBLogo, _scoreBController),
//           ],
//         ),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.pop(context),
//             child: Text(
//               'বাতিল',
//               style: TextStyle(color: Colors.grey.shade400),
//             ),
//           ),
//           ElevatedButton(
//             onPressed: () {
//               int scoreA = int.tryParse(_scoreAController.text) ?? 0;
//               int scoreB = int.tryParse(_scoreBController.text) ?? 0;
//
//               _firestore.collection('tournament_matches').doc(match.matchId).update({
//                 'scoreA': scoreA,
//                 'scoreB': scoreB,
//               });
//
//               Navigator.pop(context);
//
//               ScaffoldMessenger.of(context).showSnackBar(
//                 SnackBar(
//                   content: const Row(
//                     children: [
//                       Icon(Icons.check_circle, color: Colors.white),
//                       SizedBox(width: 12),
//                       Text('স্কোর আপডেট করা হয়েছে'),
//                     ],
//                   ),
//                   backgroundColor: Colors.green,
//                   behavior: SnackBarBehavior.floating,
//                   shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//                 ),
//               );
//             },
//             style: ElevatedButton.styleFrom(
//               backgroundColor: Colors.orange.shade700,
//               shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//             ),
//             child: const Text('আপডেট করুন', style: TextStyle(color: Colors.white)),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildScoreInput(String teamName, String? logo, TextEditingController controller) {
//     return Container(
//       padding: const EdgeInsets.all(16),
//       decoration: BoxDecoration(
//         color: const Color(0xFF0F1419),
//         borderRadius: BorderRadius.circular(16),
//         border: Border.all(color: Colors.white.withOpacity(0.1), width: 1),
//       ),
//       child: Row(
//         children: [
//           if (logo != null && logo.isNotEmpty)
//             ClipRRect(
//               borderRadius: BorderRadius.circular(8),
//               child: Image.network(
//                 logo,
//                 width: 40,
//                 height: 40,
//                 fit: BoxFit.cover,
//                 errorBuilder: (_, __, ___) => _buildDefaultLogo(),
//               ),
//             )
//           else
//             _buildDefaultLogo(),
//           const SizedBox(width: 12),
//           Expanded(
//             child: Text(
//               teamName,
//               style: const TextStyle(
//                 color: Colors.white,
//                 fontWeight: FontWeight.bold,
//                 fontSize: 14,
//               ),
//             ),
//           ),
//           const SizedBox(width: 12),
//           SizedBox(
//             width: 80,
//             child: TextField(
//               controller: controller,
//               keyboardType: TextInputType.number,
//               textAlign: TextAlign.center,
//               style: const TextStyle(
//                 color: Colors.white,
//                 fontSize: 24,
//                 fontWeight: FontWeight.bold,
//               ),
//               decoration: InputDecoration(
//                 filled: true,
//                 fillColor: Colors.orange.shade700.withOpacity(0.2),
//                 border: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(12),
//                   borderSide: BorderSide(color: Colors.orange.shade700),
//                 ),
//                 enabledBorder: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(12),
//                   borderSide: BorderSide(color: Colors.orange.shade700),
//                 ),
//                 focusedBorder: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(12),
//                   borderSide: BorderSide(color: Colors.orange.shade700, width: 2),
//                 ),
//                 contentPadding: const EdgeInsets.symmetric(vertical: 16),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildDefaultLogo() {
//     return Container(
//       width: 40,
//       height: 40,
//       decoration: BoxDecoration(
//         color: Colors.grey.shade800,
//         borderRadius: BorderRadius.circular(8),
//       ),
//       child: const Icon(Icons.shield, color: Colors.white70, size: 24),
//     );
//   }
//
//   void _updateMatchStatus(TournamentMatch match, String newStatus) {
//     _firestore.collection('tournament_matches').doc(match.matchId).update({
//       'status': newStatus,
//     });
//
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(
//         content: Row(
//           children: [
//             const Icon(Icons.check_circle, color: Colors.white),
//             const SizedBox(width: 12),
//             Text('ম্যাচ ${_getStatusBengali(newStatus)} করা হয়েছে'),
//           ],
//         ),
//         backgroundColor: Colors.green,
//         behavior: SnackBarBehavior.floating,
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//       ),
//     );
//   }
//
//   void _confirmFinishMatch(TournamentMatch match) {
//     showDialog(
//       context: context,
//       builder: (context) => AlertDialog(
//         backgroundColor: const Color(0xFF1C2128),
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
//         title: const Row(
//           children: [
//             Icon(Icons.warning_amber_rounded, color: Colors.orange, size: 28),
//             SizedBox(width: 12),
//             Text('ম্যাচ শেষ করুন', style: TextStyle(color: Colors.white)),
//           ],
//         ),
//         content: const Text(
//           'ম্যাচ শেষ করলে পয়েন্ট টেবিল আপডেট হবে। আপনি কি নিশ্চিত?',
//           style: TextStyle(color: Colors.white70),
//         ),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.pop(context),
//             child: Text('না', style: TextStyle(color: Colors.grey.shade400)),
//           ),
//           ElevatedButton(
//             onPressed: () {
//               _updateMatchStatus(match, 'finished');
//               Navigator.pop(context);
//             },
//             style: ElevatedButton.styleFrom(
//               backgroundColor: Colors.blue,
//               shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//             ),
//             child: const Text('হ্যাঁ, শেষ করুন', style: TextStyle(color: Colors.white)),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildLoadingState() {
//     return Center(
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           CircularProgressIndicator(color: Colors.orange.shade700, strokeWidth: 3),
//           const SizedBox(height: 24),
//           Text(
//             'ম্যাচ ডেটা লোড হচ্ছে...',
//             style: TextStyle(color: Colors.grey.shade400, fontSize: 16),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildErrorState(String error) {
//     return Center(
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Icon(Icons.error_outline_rounded, size: 80, color: Colors.red.shade400),
//           const SizedBox(height: 16),
//           Text(
//             'Error: $error',
//             style: TextStyle(color: Colors.red.shade300, fontSize: 14),
//             textAlign: TextAlign.center,
//           ),
//         ],
//       ),
//     );
//   }
//
//   Color _getStatusColor(String status) {
//     switch (status) {
//       case 'live':
//         return Colors.green;
//       case 'finished':
//         return Colors.blue;
//       default:
//         return Colors.orange;
//     }
//   }
//
//   String _getStatusBengali(String status) {
//     switch (status) {
//       case 'live':
//         return 'লাইভ';
//       case 'finished':
//         return 'সম্পন্ন';
//       default:
//         return 'আসন্ন';
//     }
//   }
//
//   IconData _getStatusIcon(String status) {
//     switch (status) {
//       case 'live':
//         return Icons.play_circle_filled_rounded;
//       case 'finished':
//         return Icons.check_circle_rounded;
//       default:
//         return Icons.schedule_rounded;
//     }
//   }
// }

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../models/tournament_model.dart';
import '../../models/match_model.dart';
import '../match/match_lineup_screen.dart';
import '../match/match_referee_screen.dart';
import '../match/match_stats_screen.dart';

class TournamentMatchDetailsScreen extends StatefulWidget {
  final String matchId;

  const TournamentMatchDetailsScreen({Key? key, required this.matchId}) : super(key: key);

  @override
  State<TournamentMatchDetailsScreen> createState() => _TournamentMatchDetailsScreenState();
}

class _TournamentMatchDetailsScreenState extends State<TournamentMatchDetailsScreen>
    with SingleTickerProviderStateMixin {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  late TabController _tabController;
  final DateFormat _dateFormat = DateFormat('dd MMMM yyyy • hh:mm a');

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  MatchModel _convertToMatchModel(TournamentMatch tournamentMatch) {
    return MatchModel(
      id: tournamentMatch.matchId ?? widget.matchId,
      teamAId: tournamentMatch.teamAId,
      teamBId: tournamentMatch.teamBId,
      teamA: tournamentMatch.teamAId,
      teamB: tournamentMatch.teamBId,
      teamAName: tournamentMatch.teamAName,
      teamBName: tournamentMatch.teamBName,
      teamALogo: tournamentMatch.teamALogo,
      teamBLogo: tournamentMatch.teamBLogo,
      scoreA: tournamentMatch.scoreA,
      scoreB: tournamentMatch.scoreB,
      date: tournamentMatch.matchDate,
      time: tournamentMatch.matchDate,
      status: tournamentMatch.status,
      venue: tournamentMatch.venue.isNotEmpty ? tournamentMatch.venue : 'Venue not specified',
      round: tournamentMatch.round,
      tournament: tournamentMatch.tournamentName,
      tournamentId: tournamentMatch.tournamentId,
      timeline: const [],
      stats: null,
      lineUpA: null,
      lineUpB: null,
      h2h: null,
      adminFullName: null,
      createdAt: tournamentMatch.createdAt,
      createdBy: 'tournament_admin',
    );
  }

  void _refreshMatch() => setState(() {});

  Color _getStatusColor(String status) {
    switch (status) {
      case 'live': return Colors.green;
      case 'finished': return Colors.blueGrey;
      default: return Colors.orange;
    }
  }

  String _getStatusText(String status) {
    switch (status) {
      case 'live': return 'LIVE';
      case 'finished': return 'FINISHED';
      default: return 'UPCOMING';
    }
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot>(
      stream: _firestore.collection('tournament_matches').doc(widget.matchId).snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return _buildErrorScaffold('Error loading match');
        }

        if (!snapshot.hasData || !snapshot.data!.exists) {
          return _buildLoadingScaffold();
        }

        final tournamentMatch = TournamentMatch.fromFirestore(snapshot.data!);
        final matchModel = _convertToMatchModel(tournamentMatch);

        return Scaffold(
          backgroundColor: const Color(0xFF0F1621),
          body: Column(
            children: [
              _buildHeader(tournamentMatch),
              _buildTabBar(),
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    _buildOverviewTab(tournamentMatch),
                    MatchLineupScreen(match: matchModel, onUpdate: _refreshMatch),
                    MatchRefereeScreen(match: matchModel, onUpdate: _refreshMatch),
                    MatchStatsScreen(match: matchModel, onUpdate: _refreshMatch),
                  ],
                ),
              ),
            ],
          ),
          bottomNavigationBar: tournamentMatch.status != 'finished'
              ? _buildBottomActions(tournamentMatch)
              : null,
        );
      },
    );
  }

  Widget _buildErrorScaffold(String title) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F1621),
      appBar: AppBar(backgroundColor: const Color(0xFF1A2332), title: Text(title)),
      body: const Center(child: Icon(Icons.error_outline, size: 80, color: Colors.red)),
    );
  }

  Widget _buildLoadingScaffold() {
    return Scaffold(
      backgroundColor: const Color(0xFF0F1621),
      appBar: AppBar(backgroundColor: const Color(0xFF1A2332), title: const Text('Loading...')),
      body: const Center(child: CircularProgressIndicator(color: Colors.orange)),
    );
  }

  Widget _buildHeader(TournamentMatch match) {
    final statusColor = _getStatusColor(match.status);
    final minutesPlayed = match.status == 'live'
        ? DateTime.now().difference(match.matchDate).inMinutes + 1
        : null;

    return Container(
      padding: const EdgeInsets.fromLTRB(20, 50, 20, 30),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF1A2332), Color(0xFF0F1621)],
        ),
      ),
      child: SafeArea(
        child: Column(
          children: [
            // Round Title
            Text(
              match.round.toUpperCase(),
              style: const TextStyle(
                color: Colors.orange,
                fontSize: 14,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.5,
              ),
            ),
            const SizedBox(height: 20),

            // Score
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  '${match.scoreA}',
                  style: TextStyle(fontSize: 64, fontWeight: FontWeight.bold, color: statusColor),
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24),
                  child: Text(':', style: TextStyle(fontSize: 48, color: Colors.white70)),
                ),
                Text(
                  '${match.scoreB}',
                  style: TextStyle(fontSize: 64, fontWeight: FontWeight.bold, color: statusColor),
                ),
              ],
            ),

            // Live Timer or Status
            const SizedBox(height: 12),
            if (minutesPlayed != null)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.green.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.green, width: 1),
                ),
                child: Text(
                  "$minutesPlayed'",
                  style: const TextStyle(color: Colors.green, fontSize: 20, fontWeight: FontWeight.bold),
                ),
              )
            else
              Text(
                _getStatusText(match.status),
                style: TextStyle(color: statusColor, fontSize: 18, fontWeight: FontWeight.bold),
              ),

            const SizedBox(height: 30),

            // Teams
            Row(
              children: [
                Expanded(child: _buildTeamCard(match.teamAName, match.teamALogo)),
                const SizedBox(width: 40),
                const Text('VS', style: TextStyle(fontSize: 20, color: Colors.white54, fontWeight: FontWeight.bold)),
                const SizedBox(width: 40),
                Expanded(child: _buildTeamCard(match.teamBName, match.teamBLogo)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTeamCard(String name, String? logoUrl) {
    return Column(
      children: [
        Container(
          width: 90,
          height: 90,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: Colors.white24, width: 3),
            boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 10, offset: const Offset(0, 5))],
          ),
          child: ClipOval(
            child: logoUrl != null && logoUrl.isNotEmpty
                ? Image.network(logoUrl, fit: BoxFit.cover, errorBuilder: (_, __, ___) => _defaultLogo())
                : _defaultLogo(),
          ),
        ),
        const SizedBox(height: 12),
        Text(
          name,
          style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }

  Widget _defaultLogo() {
    return Container(
      color: Colors.white10,
      child: const Icon(Icons.shield, size: 50, color: Colors.white38),
    );
  }

  Widget _buildTabBar() {
    return Container(
      color: const Color(0xFF1A2332),
      child: TabBar(
        controller: _tabController,
        indicatorColor: Colors.orange,
        indicatorWeight: 3,
        labelColor: Colors.orange,
        unselectedLabelColor: Colors.white54,
        labelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
        tabs: const [
          Tab(text: 'OVERVIEW'),
          Tab(text: 'LINE-UP'),
          Tab(text: 'REFEREE'),
          Tab(text: 'STATS'),
        ],
      ),
    );
  }

  Widget _buildOverviewTab(TournamentMatch match) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          _buildInfoTile(Icons.location_on, 'Venue', match.venue),
          const SizedBox(height: 16),
          _buildInfoTile(Icons.calendar_today, 'Date & Time', _dateFormat.format(match.matchDate)),
          if (match.groupName != null) ...[
            const SizedBox(height: 16),
            _buildInfoTile(Icons.group, 'Group', match.groupName!),
          ],
        ],
      ),
    );
  }

  Widget _buildInfoTile(IconData icon, String title, String value) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xFF1A2332),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white10),
      ),
      child: Row(
        children: [
          Icon(icon, color: Colors.orange, size: 28),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(color: Colors.white54, fontSize: 13)),
                const SizedBox(height: 4),
                Text(value, style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomActions(TournamentMatch match) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: const BoxDecoration(
        color: Color(0xFF1A2332),
        border: Border(top: BorderSide(color: Colors.white10)),
      ),
      child: SafeArea(
        child: match.status == 'upcoming'
            ? _actionButton('Start Match', Icons.play_arrow, Colors.green, () => _updateStatus(match, 'live'))
            : match.status == 'live'
            ? _actionButton('End Match', Icons.stop, Colors.red, () => _updateStatus(match, 'finished'))
            : Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(color: Colors.green.withOpacity(0.2), borderRadius: BorderRadius.circular(16)),
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.check_circle, color: Colors.green),
              SizedBox(width: 12),
              Text('Match Completed', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _actionButton(String text, IconData icon, Color color, VoidCallback onPressed) {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton.icon(
        onPressed: onPressed,
        icon: Icon(icon, size: 24),
        label: Text(text, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          elevation: 8,
        ),
      ),
    );
  }

  void _updateStatus(TournamentMatch match, String newStatus) async {
    try {
      await _firestore.collection('tournament_matches').doc(match.matchId).update({'status': newStatus});
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Match status updated to $newStatus'), backgroundColor: Colors.green),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red),
      );
    }
  }
}