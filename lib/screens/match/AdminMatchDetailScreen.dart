//
// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:intl/intl.dart';
// import '../../models/match_model.dart';
// import '../../models/team_model.dart';
//
// import 'package:provider/provider.dart';
//
// import '../../providers/match_provider.dart';
// import 'match_lineup_screen.dart';
//
// class AdminMatchDetailScreen extends StatefulWidget {
//   final MatchModel match;
//
//   const AdminMatchDetailScreen({Key? key, required this.match})
//       : super(key: key);
//
//   @override
//   State<AdminMatchDetailScreen> createState() => _AdminMatchDetailScreenState();
// }
//
// class _AdminMatchDetailScreenState extends State<AdminMatchDetailScreen>
//     with SingleTickerProviderStateMixin {
//   late TabController _tabController;
//   TeamModel? _teamA;
//   TeamModel? _teamB;
//   bool _isLoading = true;
//
//   @override
//   void initState() {
//     super.initState();
//     _tabController = TabController(length: 5, vsync: this);
//     _loadTeams();
//   }
//
//   @override
//   void dispose() {
//     _tabController.dispose();
//     super.dispose();
//   }
//
//   Future<void> _loadTeams() async {
//     try {
//       final teamADoc = await FirebaseFirestore.instance
//           .collection('teams')
//           .doc(widget.match.teamA)
//           .get();
//
//       final teamBDoc = await FirebaseFirestore.instance
//           .collection('teams')
//           .doc(widget.match.teamB)
//           .get();
//
//       if (teamADoc.exists && teamBDoc.exists && mounted) {
//         setState(() {
//           _teamA = TeamModel.fromFirestore(teamADoc);
//           _teamB = TeamModel.fromFirestore(teamBDoc);
//           _isLoading = false;
//         });
//       }
//     } catch (e) {
//       debugPrint('Error loading teams: $e');
//       setState(() => _isLoading = false);
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     if (_isLoading) {
//       return _buildLoadingScreen();
//     }
//
//     return Scaffold(
//       backgroundColor: const Color(0xFF0F172A),
//       body: NestedScrollView(
//         headerSliverBuilder: (context, innerBoxIsScrolled) {
//           return [
//             _buildSliverAppBar(),
//             _buildSliverTabBar(),
//           ];
//         },
//         body: TabBarView(
//           controller: _tabController,
//           children: [
//             _MatchOverviewTab(
//               match: widget.match,
//               teamA: _teamA,
//               teamB: _teamB,
//             ),
//             _LiveScoreTab(match: widget.match),
//             _TimelineTab(match: widget.match),
//             LineupTab(match: widget.match),
//             _StatsTab(match: widget.match),
//           ],
//         ),
//       ),
//       // floatingActionButton: _buildFloatingActionButton(),
//     );
//   }
//
//   Widget _buildLoadingScreen() {
//     return Scaffold(
//       backgroundColor: const Color(0xFF0F172A),
//       body: Center(
//         child: CircularProgressIndicator(color: Colors.orange.shade700),
//       ),
//     );
//   }
//
//   Widget _buildSliverAppBar() {
//     final dateFormat = DateFormat('dd MMM yyyy, hh:mm a');
//
//     return SliverAppBar(
//       expandedHeight: 280,
//       pinned: true,
//       backgroundColor: const Color(0xFF1E293B),
//       iconTheme: const IconThemeData(color: Colors.white),
//       leading: Container(
//         margin: const EdgeInsets.all(8),
//         decoration: BoxDecoration(
//           color: Colors.black.withOpacity(0.5),
//           shape: BoxShape.circle,
//         ),
//         child: IconButton(
//           icon: const Icon(Icons.arrow_back),
//           onPressed: () => Navigator.pop(context),
//         ),
//       ),
//       actions: [
//         if (widget.match.status == 'live')
//           Container(
//             margin: const EdgeInsets.all(8),
//             padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//             decoration: BoxDecoration(
//               color: Colors.red,
//               borderRadius: BorderRadius.circular(20),
//               boxShadow: [
//                 BoxShadow(
//                   color: Colors.red.withOpacity(0.4),
//                   blurRadius: 10,
//                   spreadRadius: 2,
//                 ),
//               ],
//             ),
//             child: Row(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 Container(
//                   width: 8,
//                   height: 8,
//                   decoration: const BoxDecoration(
//                     color: Colors.white,
//                     shape: BoxShape.circle,
//                   ),
//                 ),
//                 const SizedBox(width: 8),
//                 const Text(
//                   'LIVE',
//                   style: TextStyle(
//                     color: Colors.white,
//                     fontWeight: FontWeight.bold,
//                     fontSize: 14,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         IconButton(
//           icon: const Icon(Icons.more_vert),
//           onPressed: () => _showMoreOptions(context),
//         ),
//       ],
//       flexibleSpace: FlexibleSpaceBar(
//         background: Container(
//           decoration: BoxDecoration(
//             gradient: LinearGradient(
//               begin: Alignment.topCenter,
//               end: Alignment.bottomCenter,
//               colors: [
//                 Colors.orange.shade800,
//                 const Color(0xFF1E293B),
//               ],
//             ),
//           ),
//           child: SafeArea(
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 const SizedBox(height: 60),
//                 // Match Status Badge
//                 Container(
//                   padding:
//                   const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//                   decoration: BoxDecoration(
//                     color: _getStatusColor(widget.match.status),
//                     borderRadius: BorderRadius.circular(20),
//                   ),
//                   child: Text(
//                     _getStatusText(widget.match.status),
//                     style: const TextStyle(
//                       color: Colors.white,
//                       fontWeight: FontWeight.bold,
//                       fontSize: 12,
//                     ),
//                   ),
//                 ),
//                 const SizedBox(height: 24),
//                 // Teams and Score
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                   children: [
//                     // Team A
//                     Expanded(
//                       child: _buildTeamColumn(_teamA, isTeamA: true),
//                     ),
//                     // Score
//                     Container(
//                       padding: const EdgeInsets.symmetric(
//                         horizontal: 32,
//                         vertical: 16,
//                       ),
//                       decoration: BoxDecoration(
//                         color: Colors.black.withOpacity(0.3),
//                         borderRadius: BorderRadius.circular(16),
//                       ),
//                       child: Text(
//                         '${widget.match.scoreA} : ${widget.match.scoreB}',
//                         style: const TextStyle(
//                           color: Colors.white,
//                           fontSize: 36,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                     ),
//                     // Team B
//                     Expanded(
//                       child: _buildTeamColumn(_teamB, isTeamA: false),
//                     ),
//                   ],
//                 ),
//                 const SizedBox(height: 16),
//                 // Venue and Time
//                 if (widget.match.venue != null) ...[
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       const Icon(Icons.location_on,
//                           color: Colors.white70, size: 16),
//                       const SizedBox(width: 4),
//                       Text(
//                         widget.match.venue!,
//                         style: const TextStyle(
//                           color: Colors.white70,
//                           fontSize: 14,
//                         ),
//                       ),
//                     ],
//                   ),
//                   const SizedBox(height: 4),
//                 ],
//                 Text(
//                   dateFormat.format(widget.match.date),
//                   style: const TextStyle(
//                     color: Colors.white54,
//                     fontSize: 12,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget _buildTeamColumn(TeamModel? team, {required bool isTeamA}) {
//     return Column(
//       children: [
//         // Team Logo with proper null checking
//         if (team?.logoUrl != null && team!.logoUrl!.isNotEmpty)
//           Container(
//             decoration: BoxDecoration(
//               shape: BoxShape.circle,
//               boxShadow: [
//                 BoxShadow(
//                   color: Colors.black.withOpacity(0.3),
//                   blurRadius: 10,
//                   spreadRadius: 2,
//                 ),
//               ],
//             ),
//             child: ClipRRect(
//               borderRadius: BorderRadius.circular(40),
//               child: Image.network(
//                 team.logoUrl!,  // ✅ Safe now
//                 width: 70,
//                 height: 70,
//                 fit: BoxFit.cover,
//                 errorBuilder: (context, error, stackTrace) {
//                   return _buildTeamPlaceholder();
//                 },
//               ),
//             ),
//           )
//         else
//           _buildTeamPlaceholder(),
//         const SizedBox(height: 12),
//         Text(
//           team?.name ?? 'Unknown',
//           textAlign: TextAlign.center,
//           style: const TextStyle(
//             color: Colors.white,
//             fontSize: 16,
//             fontWeight: FontWeight.bold,
//           ),
//         ),
//       ],
//     );
//   }
//
//   Widget _buildTeamPlaceholder() {
//     return Container(
//       width: 70,
//       height: 70,
//       decoration: BoxDecoration(
//         color: Colors.white.withOpacity(0.1),
//         shape: BoxShape.circle,
//       ),
//       child: const Icon(Icons.shield, color: Colors.white54, size: 35),
//     );
//   }
//
//   Widget _buildSliverTabBar() {
//     return SliverPersistentHeader(
//       pinned: true,
//       delegate: _SliverAppBarDelegate(
//         TabBar(
//           controller: _tabController,
//           indicatorColor: Colors.orange.shade700,
//           indicatorWeight: 3,
//           labelColor: Colors.orange.shade700,
//           unselectedLabelColor: Colors.white60,
//           isScrollable: true,
//           labelStyle: const TextStyle(
//             fontSize: 14,
//             fontWeight: FontWeight.bold,
//           ),
//           tabs: const [
//             Tab(text: 'ওভারভিউ'),
//             Tab(text: 'লাইভ স্কোর'),
//             Tab(text: 'টাইমলাইন'),
//             Tab(text: 'লাইনআপ'),
//             Tab(text: 'স্ট্যাটিস্টিক্স'),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _buildFloatingActionButton() {
//     if (widget.match.status == 'finished') return const SizedBox.shrink();
//
//     return FloatingActionButton.extended(
//       onPressed: () => _showQuickActions(context),
//       backgroundColor: Colors.orange.shade700,
//       icon: const Icon(Icons.bolt),
//       label: const Text(
//         'দ্রুত অ্যাকশন',
//         style: TextStyle(fontWeight: FontWeight.bold),
//       ),
//     );
//   }
//
//   void _showQuickActions(BuildContext context) {
//     showModalBottomSheet(
//       context: context,
//       backgroundColor: const Color(0xFF1E293B),
//       shape: const RoundedRectangleBorder(
//         borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
//       ),
//       builder: (context) => Container(
//         padding: const EdgeInsets.all(20),
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             Container(
//               width: 40,
//               height: 4,
//               decoration: BoxDecoration(
//                 color: Colors.white30,
//                 borderRadius: BorderRadius.circular(2),
//               ),
//             ),
//             const SizedBox(height: 20),
//             const Text(
//               'দ্রুত অ্যাকশন',
//               style: TextStyle(
//                 color: Colors.white,
//                 fontSize: 20,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//             const SizedBox(height: 20),
//             _buildQuickActionButton(
//               icon: Icons.sports_soccer,
//               label: 'গোল যোগ করুন',
//               color: Colors.green,
//               onTap: () {
//                 Navigator.pop(context);
//                 // Navigate to add goal screen
//               },
//             ),
//             _buildQuickActionButton(
//               icon: Icons.style,
//               label: 'কার্ড দিন',
//               color: Colors.yellow.shade700,
//               onTap: () {
//                 Navigator.pop(context);
//                 // Navigate to add card screen
//               },
//             ),
//             _buildQuickActionButton(
//               icon: Icons.swap_horiz,
//               label: 'সাবস্টিটিউশন',
//               color: Colors.blue,
//               onTap: () {
//                 Navigator.pop(context);
//                 // Navigate to substitution screen
//               },
//             ),
//             if (widget.match.status == 'upcoming')
//               _buildQuickActionButton(
//                 icon: Icons.play_circle,
//                 label: 'ম্যাচ শুরু করুন',
//                 color: Colors.orange.shade700,
//                 onTap: () async {
//                   Navigator.pop(context);
//                   await _startMatch();
//                 },
//               ),
//             if (widget.match.status == 'live')
//               _buildQuickActionButton(
//                 icon: Icons.stop_circle,
//                 label: 'ম্যাচ শেষ করুন',
//                 color: Colors.red,
//                 onTap: () async {
//                   Navigator.pop(context);
//                   await _finishMatch();
//                 },
//               ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _buildQuickActionButton({
//     required IconData icon,
//     required String label,
//     required Color color,
//     required VoidCallback onTap,
//   }) {
//     return Container(
//       margin: const EdgeInsets.only(bottom: 12),
//       child: Material(
//         color: Colors.transparent,
//         child: InkWell(
//           onTap: onTap,
//           borderRadius: BorderRadius.circular(12),
//           child: Container(
//             padding: const EdgeInsets.all(16),
//             decoration: BoxDecoration(
//               color: color.withOpacity(0.1),
//               borderRadius: BorderRadius.circular(12),
//               border: Border.all(color: color.withOpacity(0.3)),
//             ),
//             child: Row(
//               children: [
//                 Container(
//                   padding: const EdgeInsets.all(8),
//                   decoration: BoxDecoration(
//                     color: color.withOpacity(0.2),
//                     borderRadius: BorderRadius.circular(8),
//                   ),
//                   child: Icon(icon, color: color, size: 24),
//                 ),
//                 const SizedBox(width: 16),
//                 Text(
//                   label,
//                   style: TextStyle(
//                     color: color,
//                     fontSize: 16,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//                 const Spacer(),
//                 Icon(Icons.arrow_forward_ios, color: color, size: 16),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
//
//   Future<void> _startMatch() async {
//     final matchProvider = Provider.of<MatchProvider>(context, listen: false);
//     await matchProvider.updateMatchStatus(widget.match.id, 'live');
//
//     if (mounted) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(
//           content: Text('ম্যাচ শুরু হয়েছে'),
//           backgroundColor: Colors.green,
//         ),
//       );
//     }
//   }
//
//   Future<void> _finishMatch() async {
//     final matchProvider = Provider.of<MatchProvider>(context, listen: false);
//     await matchProvider.finishMatch(widget.match.id);
//
//     if (mounted) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(
//           content: Text('ম্যাচ শেষ হয়েছে'),
//           backgroundColor: Colors.orange,
//         ),
//       );
//       Navigator.pop(context);
//     }
//   }
//
//   void _showMoreOptions(BuildContext context) {
//     showModalBottomSheet(
//       context: context,
//       backgroundColor: const Color(0xFF1E293B),
//       shape: const RoundedRectangleBorder(
//         borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
//       ),
//       builder: (context) => Container(
//         padding: const EdgeInsets.all(20),
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             ListTile(
//               leading: const Icon(Icons.edit, color: Colors.blue),
//               title: const Text('ম্যাচ এডিট করুন',
//                   style: TextStyle(color: Colors.white)),
//               onTap: () {
//                 Navigator.pop(context);
//                 // Navigate to edit screen
//               },
//             ),
//             ListTile(
//               leading: const Icon(Icons.delete, color: Colors.red),
//               title: const Text('ম্যাচ মুছুন',
//                   style: TextStyle(color: Colors.white)),
//               onTap: () {
//                 Navigator.pop(context);
//                 _confirmDelete();
//               },
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Future<void> _confirmDelete() async {
//     final confirmed = await showDialog<bool>(
//       context: context,
//       builder: (context) => AlertDialog(
//         backgroundColor: const Color(0xFF1E293B),
//         title: const Text('নিশ্চিত করুন',
//             style: TextStyle(color: Colors.white)),
//         content: const Text('আপনি কি এই ম্যাচ মুছতে চান?',
//             style: TextStyle(color: Colors.white70)),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.pop(context, false),
//             child: const Text('না'),
//           ),
//           ElevatedButton(
//             onPressed: () => Navigator.pop(context, true),
//             style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
//             child: const Text('হ্যাঁ, মুছুন'),
//           ),
//         ],
//       ),
//     );
//
//     if (confirmed == true && mounted) {
//       await FirebaseFirestore.instance
//           .collection('matches')
//           .doc(widget.match.id)
//           .delete();
//
//       Navigator.pop(context);
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(
//           content: Text('ম্যাচ মুছে ফেলা হয়েছে'),
//           backgroundColor: Colors.red,
//         ),
//       );
//     }
//   }
//
//   Color _getStatusColor(String status) {
//     switch (status) {
//       case 'live':
//         return Colors.red;
//       case 'upcoming':
//         return Colors.blue;
//       case 'finished':
//         return Colors.grey;
//       default:
//         return Colors.grey;
//     }
//   }
//
//   String _getStatusText(String status) {
//     switch (status) {
//       case 'live':
//         return 'চলছে';
//       case 'upcoming':
//         return 'আসছে';
//       case 'finished':
//         return 'শেষ';
//       default:
//         return status;
//     }
//   }
// }
//
// // Tab Delegate
// class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
//   final TabBar _tabBar;
//
//   _SliverAppBarDelegate(this._tabBar);
//
//   @override
//   double get minExtent => _tabBar.preferredSize.height;
//
//   @override
//   double get maxExtent => _tabBar.preferredSize.height;
//
//   @override
//   Widget build(
//       BuildContext context, double shrinkOffset, bool overlapsContent) {
//     return Container(
//       color: const Color(0xFF1E293B),
//       child: _tabBar,
//     );
//   }
//
//   @override
//   bool shouldRebuild(_SliverAppBarDelegate oldDelegate) => false;
// }
// // ============================================================================
// // TAB 1: MATCH OVERVIEW
// // ============================================================================
// class _MatchOverviewTab extends StatelessWidget {
//   final MatchModel match;
//   final TeamModel? teamA;
//   final TeamModel? teamB;
//
//   const _MatchOverviewTab({
//     required this.match,
//     required this.teamA,
//     required this.teamB,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return SingleChildScrollView(
//       padding: const EdgeInsets.all(16),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           // Match Info Card
//           _buildMatchInfoCard(),
//           const SizedBox(height: 16),
//
//           // Tournament Info (if exists)
//           if (match.tournament != null) ...[
//             _buildTournamentCard(),
//             const SizedBox(height: 16),
//           ],
//
//           // Recent Events Preview
//           if (match.timeline.isNotEmpty) ...[
//             _buildSectionHeader('সাম্প্রতিক ইভেন্ট', Icons.timeline),
//             const SizedBox(height: 12),
//             _buildRecentEvents(),
//             const SizedBox(height: 16),
//           ],
//
//           // Head to Head (if exists)
//           if (match.h2h != null) ...[
//             _buildSectionHeader('হেড টু হেড', Icons.sports),
//             const SizedBox(height: 12),
//             _buildHeadToHead(),
//           ],
//         ],
//       ),
//     );
//   }
//
//   Widget _buildMatchInfoCard() {
//     return Container(
//       padding: const EdgeInsets.all(20),
//       decoration: BoxDecoration(
//         gradient: LinearGradient(
//           colors: [
//             const Color(0xFF1E293B),
//             const Color(0xFF1E293B).withOpacity(0.8),
//           ],
//         ),
//         borderRadius: BorderRadius.circular(16),
//         border: Border.all(color: Colors.white.withOpacity(0.1)),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.2),
//             blurRadius: 10,
//             offset: const Offset(0, 4),
//           ),
//         ],
//       ),
//       child: Column(
//         children: [
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               _buildInfoItem(
//                 icon: Icons.calendar_today,
//                 label: 'তারিখ',
//                 value: DateFormat('dd MMM yyyy').format(match.date),
//                 color: Colors.blue.shade400,
//               ),
//               Container(
//                 width: 1,
//                 height: 40,
//                 color: Colors.white.withOpacity(0.1),
//               ),
//               _buildInfoItem(
//                 icon: Icons.access_time,
//                 label: 'সময়',
//                 value: DateFormat('hh:mm a').format(match.time),
//                 color: Colors.orange.shade400,
//               ),
//             ],
//           ),
//           if (match.venue != null) ...[
//             const SizedBox(height: 16),
//             Divider(color: Colors.white.withOpacity(0.1)),
//             const SizedBox(height: 16),
//             Row(
//               children: [
//                 Container(
//                   padding: const EdgeInsets.all(8),
//                   decoration: BoxDecoration(
//                     color: Colors.green.shade400.withOpacity(0.2),
//                     borderRadius: BorderRadius.circular(8),
//                   ),
//                   child: Icon(
//                     Icons.location_on,
//                     color: Colors.green.shade400,
//                     size: 20,
//                   ),
//                 ),
//                 const SizedBox(width: 12),
//                 Expanded(
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(
//                         'স্থান',
//                         style: TextStyle(
//                           color: Colors.white.withOpacity(0.6),
//                           fontSize: 12,
//                         ),
//                       ),
//                       const SizedBox(height: 2),
//                       Text(
//                         match.venue!,
//                         style: const TextStyle(
//                           color: Colors.white,
//                           fontSize: 16,
//                           fontWeight: FontWeight.w600,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//           ],
//         ],
//       ),
//     );
//   }
//
//   Widget _buildInfoItem({
//     required IconData icon,
//     required String label,
//     required String value,
//     required Color color,
//   }) {
//     return Expanded(
//       child: Column(
//         children: [
//           Container(
//             padding: const EdgeInsets.all(8),
//             decoration: BoxDecoration(
//               color: color.withOpacity(0.2),
//               borderRadius: BorderRadius.circular(8),
//             ),
//             child: Icon(icon, color: color, size: 20),
//           ),
//           const SizedBox(height: 8),
//           Text(
//             label,
//             style: TextStyle(
//               color: Colors.white.withOpacity(0.6),
//               fontSize: 12,
//             ),
//           ),
//           const SizedBox(height: 4),
//           Text(
//             value,
//             style: const TextStyle(
//               color: Colors.white,
//               fontSize: 14,
//               fontWeight: FontWeight.bold,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildTournamentCard() {
//     return Container(
//       padding: const EdgeInsets.all(16),
//       decoration: BoxDecoration(
//         gradient: LinearGradient(
//           colors: [
//             Colors.orange.shade700.withOpacity(0.2),
//             Colors.orange.shade900.withOpacity(0.1),
//           ],
//         ),
//         borderRadius: BorderRadius.circular(16),
//         border: Border.all(color: Colors.orange.shade700.withOpacity(0.3)),
//       ),
//       child: Row(
//         children: [
//           Container(
//             padding: const EdgeInsets.all(12),
//             decoration: BoxDecoration(
//               color: Colors.orange.shade700.withOpacity(0.2),
//               borderRadius: BorderRadius.circular(12),
//             ),
//             child: Icon(
//               Icons.emoji_events,
//               color: Colors.orange.shade400,
//               size: 32,
//             ),
//           ),
//           const SizedBox(width: 16),
//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   'টুর্নামেন্ট',
//                   style: TextStyle(
//                     color: Colors.white.withOpacity(0.6),
//                     fontSize: 12,
//                   ),
//                 ),
//                 const SizedBox(height: 4),
//                 Text(
//                   match.tournament!,
//                   style: const TextStyle(
//                     color: Colors.white,
//                     fontSize: 18,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           Icon(
//             Icons.arrow_forward_ios,
//             color: Colors.orange.shade400,
//             size: 16,
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildRecentEvents() {
//     final recentEvents = match.timeline.take(5).toList();
//
//     return Container(
//       decoration: BoxDecoration(
//         color: const Color(0xFF1E293B),
//         borderRadius: BorderRadius.circular(16),
//         border: Border.all(color: Colors.white.withOpacity(0.1)),
//       ),
//       child: ListView.separated(
//         shrinkWrap: true,
//         physics: const NeverScrollableScrollPhysics(),
//         itemCount: recentEvents.length,
//         separatorBuilder: (context, index) => Divider(
//           color: Colors.white.withOpacity(0.1),
//           height: 1,
//         ),
//         itemBuilder: (context, index) {
//           final event = recentEvents[index];
//           return _buildEventTile(event);
//         },
//       ),
//     );
//   }
//
//   Widget _buildEventTile(MatchEvent event) {
//     IconData icon;
//     Color color;
//
//     switch (event.type) {
//       case 'goal':
//         icon = Icons.sports_soccer;
//         color = Colors.green.shade400;
//         break;
//       case 'card':
//         icon = Icons.style;
//         color = event.details == 'red_card'
//             ? Colors.red.shade400
//             : Colors.yellow.shade700;
//         break;
//       case 'substitution':
//         icon = Icons.swap_horiz;
//         color = Colors.blue.shade400;
//         break;
//       default:
//         icon = Icons.info;
//         color = Colors.grey;
//     }
//
//     return Padding(
//       padding: const EdgeInsets.all(16),
//       child: Row(
//         children: [
//           Container(
//             padding: const EdgeInsets.all(8),
//             decoration: BoxDecoration(
//               color: color.withOpacity(0.2),
//               borderRadius: BorderRadius.circular(8),
//             ),
//             child: Icon(icon, color: color, size: 20),
//           ),
//           const SizedBox(width: 12),
//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   event.playerName,
//                   style: const TextStyle(
//                     color: Colors.white,
//                     fontSize: 15,
//                     fontWeight: FontWeight.w600,
//                   ),
//                 ),
//                 const SizedBox(height: 2),
//                 Text(
//                   _getEventDescription(event),
//                   style: TextStyle(
//                     color: Colors.white.withOpacity(0.6),
//                     fontSize: 13,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           Container(
//             padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
//             decoration: BoxDecoration(
//               color: Colors.white.withOpacity(0.1),
//               borderRadius: BorderRadius.circular(12),
//             ),
//             child: Text(
//               "${event.minute}'",
//               style: TextStyle(
//                 color: color,
//                 fontSize: 14,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   String _getEventDescription(MatchEvent event) {
//     switch (event.type) {
//       case 'goal':
//         return 'গোল করেছেন';
//       case 'card':
//         return event.details == 'red_card' ? 'লাল কার্ড' : 'হলুদ কার্ড';
//       case 'substitution':
//         return event.details == 'player_out' ? 'বাহির' : 'প্রবেশ';
//       default:
//         return '';
//     }
//   }
//
//   Widget _buildHeadToHead() {
//     final h2h = match.h2h!;
//
//     return Container(
//       padding: const EdgeInsets.all(20),
//       decoration: BoxDecoration(
//         gradient: LinearGradient(
//           colors: [
//             const Color(0xFF1E293B),
//             const Color(0xFF1E293B).withOpacity(0.8),
//           ],
//         ),
//         borderRadius: BorderRadius.circular(16),
//         border: Border.all(color: Colors.white.withOpacity(0.1)),
//       ),
//       child: Column(
//         children: [
//           // Total Matches
//           Row(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               const Icon(Icons.sports, color: Colors.white54, size: 20),
//               const SizedBox(width: 8),
//               Text(
//                 'মোট ${h2h.totalMatches} টি ম্যাচ',
//                 style: const TextStyle(
//                   color: Colors.white,
//                   fontSize: 16,
//                   fontWeight: FontWeight.w600,
//                 ),
//               ),
//             ],
//           ),
//           const SizedBox(height: 20),
//           // Wins Distribution
//           Row(
//             children: [
//               _buildH2HStat(
//                 label: teamA?.name ?? 'Team A',
//                 value: h2h.teamAWins.toString(),
//                 color: Colors.green.shade400,
//                 flex: h2h.teamAWins,
//               ),
//               _buildH2HStat(
//                 label: 'ড্র',
//                 value: h2h.draws.toString(),
//                 color: Colors.grey.shade400,
//                 flex: h2h.draws,
//               ),
//               _buildH2HStat(
//                 label: teamB?.name ?? 'Team B',
//                 value: h2h.teamBWins.toString(),
//                 color: Colors.blue.shade400,
//                 flex: h2h.teamBWins,
//               ),
//             ],
//           ),
//           const SizedBox(height: 20),
//           Divider(color: Colors.white.withOpacity(0.1)),
//           const SizedBox(height: 20),
//           // Goals
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceAround,
//             children: [
//               _buildGoalStat(
//                 label: 'গোল',
//                 teamAGoals: h2h.teamAGoals,
//                 teamBGoals: h2h.teamBGoals,
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildH2HStat({
//     required String label,
//     required String value,
//     required Color color,
//     required int flex,
//   }) {
//     return Expanded(
//       flex: flex == 0 ? 1 : flex,
//       child: Column(
//         children: [
//           Container(
//             padding: const EdgeInsets.symmetric(vertical: 8),
//             decoration: BoxDecoration(
//               color: color.withOpacity(0.2),
//               borderRadius: BorderRadius.circular(8),
//             ),
//             child: Center(
//               child: Text(
//                 value,
//                 style: TextStyle(
//                   color: color,
//                   fontSize: 24,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//             ),
//           ),
//           const SizedBox(height: 8),
//           Text(
//             label,
//             textAlign: TextAlign.center,
//             maxLines: 1,
//             overflow: TextOverflow.ellipsis,
//             style: TextStyle(
//               color: Colors.white.withOpacity(0.6),
//               fontSize: 12,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildGoalStat({
//     required String label,
//     required int teamAGoals,
//     required int teamBGoals,
//   }) {
//     return Column(
//       children: [
//         Text(
//           label,
//           style: TextStyle(
//             color: Colors.white.withOpacity(0.6),
//             fontSize: 13,
//           ),
//         ),
//         const SizedBox(height: 8),
//         Row(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             Text(
//               '$teamAGoals',
//               style: TextStyle(
//                 color: Colors.green.shade400,
//                 fontSize: 28,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//             const SizedBox(width: 16),
//             Text(
//               '-',
//               style: TextStyle(
//                 color: Colors.white.withOpacity(0.4),
//                 fontSize: 24,
//               ),
//             ),
//             const SizedBox(width: 16),
//             Text(
//               '$teamBGoals',
//               style: TextStyle(
//                 color: Colors.blue.shade400,
//                 fontSize: 28,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//           ],
//         ),
//       ],
//     );
//   }
//
//   Widget _buildSectionHeader(String title, IconData icon) {
//     return Row(
//       children: [
//         Container(
//           padding: const EdgeInsets.all(8),
//           decoration: BoxDecoration(
//             color: Colors.orange.shade700.withOpacity(0.2),
//             borderRadius: BorderRadius.circular(8),
//           ),
//           child: Icon(icon, color: Colors.orange.shade400, size: 20),
//         ),
//         const SizedBox(width: 12),
//         Text(
//           title,
//           style: const TextStyle(
//             color: Colors.white,
//             fontSize: 18,
//             fontWeight: FontWeight.bold,
//           ),
//         ),
//       ],
//     );
//   }
// }
//
// // ============================================================================
// // TAB 2: LIVE SCORE
// // ============================================================================
// class _LiveScoreTab extends StatefulWidget {
//   final MatchModel match;
//
//   const _LiveScoreTab({required this.match});
//
//   @override
//   State<_LiveScoreTab> createState() => _LiveScoreTabState();
// }
//
// class _LiveScoreTabState extends State<_LiveScoreTab> {
//   late int _scoreA;
//   late int _scoreB;
//
//   @override
//   void initState() {
//     super.initState();
//     _scoreA = widget.match.scoreA;
//     _scoreB = widget.match.scoreB;
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return SingleChildScrollView(
//       padding: const EdgeInsets.all(16),
//       child: Column(
//         children: [
//           // Score Controller Card
//           Container(
//             padding: const EdgeInsets.all(24),
//             decoration: BoxDecoration(
//               gradient: LinearGradient(
//                 colors: [
//                   const Color(0xFF1E293B),
//                   const Color(0xFF1E293B).withOpacity(0.8),
//                 ],
//               ),
//               borderRadius: BorderRadius.circular(20),
//               border: Border.all(color: Colors.white.withOpacity(0.1)),
//               boxShadow: [
//                 BoxShadow(
//                   color: Colors.black.withOpacity(0.3),
//                   blurRadius: 20,
//                   offset: const Offset(0, 10),
//                 ),
//               ],
//             ),
//             child: Column(
//               children: [
//                 Text(
//                   'স্কোর আপডেট করুন',
//                   style: TextStyle(
//                     color: Colors.white.withOpacity(0.8),
//                     fontSize: 16,
//                     fontWeight: FontWeight.w600,
//                   ),
//                 ),
//                 const SizedBox(height: 32),
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                   children: [
//                     // Team A Score
//                     _buildScoreController(
//                       teamName: 'টিম A',
//                       score: _scoreA,
//                       color: Colors.green.shade400,
//                       onIncrement: () {
//                         setState(() => _scoreA++);
//                       },
//                       onDecrement: () {
//                         if (_scoreA > 0) setState(() => _scoreA--);
//                       },
//                     ),
//                     // VS
//                     Container(
//                       padding: const EdgeInsets.all(16),
//                       decoration: BoxDecoration(
//                         color: Colors.white.withOpacity(0.05),
//                         shape: BoxShape.circle,
//                       ),
//                       child: Text(
//                         'VS',
//                         style: TextStyle(
//                           color: Colors.white.withOpacity(0.4),
//                           fontSize: 20,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                     ),
//                     // Team B Score
//                     _buildScoreController(
//                       teamName: 'টিম B',
//                       score: _scoreB,
//                       color: Colors.blue.shade400,
//                       onIncrement: () {
//                         setState(() => _scoreB++);
//                       },
//                       onDecrement: () {
//                         if (_scoreB > 0) setState(() => _scoreB--);
//                       },
//                     ),
//                   ],
//                 ),
//                 const SizedBox(height: 32),
//                 // Update Button
//                 SizedBox(
//                   width: double.infinity,
//                   child: ElevatedButton(
//                     onPressed: _updateScore,
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: Colors.orange.shade700,
//                       foregroundColor: Colors.white,
//                       padding: const EdgeInsets.symmetric(vertical: 16),
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(12),
//                       ),
//                       elevation: 0,
//                     ),
//                     child: const Text(
//                       'স্কোর আপডেট করুন',
//                       style: TextStyle(
//                         fontSize: 16,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           const SizedBox(height: 24),
//           // Quick Actions
//           _buildQuickActionsGrid(),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildScoreController({
//     required String teamName,
//     required int score,
//     required Color color,
//     required VoidCallback onIncrement,
//     required VoidCallback onDecrement,
//   }) {
//     return Column(
//       children: [
//         Text(
//           teamName,
//           style: TextStyle(
//             color: Colors.white.withOpacity(0.6),
//             fontSize: 14,
//             fontWeight: FontWeight.w600,
//           ),
//         ),
//         const SizedBox(height: 16),
//         Container(
//           decoration: BoxDecoration(
//             color: color.withOpacity(0.1),
//             borderRadius: BorderRadius.circular(16),
//             border: Border.all(color: color.withOpacity(0.3)),
//           ),
//           child: Column(
//             children: [
//               // Increment Button
//               Material(
//                 color: Colors.transparent,
//                 child: InkWell(
//                   onTap: onIncrement,
//                   borderRadius: const BorderRadius.vertical(
//                     top: Radius.circular(16),
//                   ),
//                   child: Container(
//                     padding: const EdgeInsets.all(12),
//                     child: Icon(Icons.add, color: color, size: 24),
//                   ),
//                 ),
//               ),
//               // Score Display
//               Container(
//                 padding: const EdgeInsets.symmetric(
//                   horizontal: 32,
//                   vertical: 16,
//                 ),
//                 decoration: BoxDecoration(
//                   color: color.withOpacity(0.2),
//                 ),
//                 child: Text(
//                   '$score',
//                   style: TextStyle(
//                     color: color,
//                     fontSize: 48,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//               ),
//               // Decrement Button
//               Material(
//                 color: Colors.transparent,
//                 child: InkWell(
//                   onTap: onDecrement,
//                   borderRadius: const BorderRadius.vertical(
//                     bottom: Radius.circular(16),
//                   ),
//                   child: Container(
//                     padding: const EdgeInsets.all(12),
//                     child: Icon(Icons.remove, color: color, size: 24),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ],
//     );
//   }
//
//   Widget _buildQuickActionsGrid() {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Row(
//           children: [
//             Container(
//               padding: const EdgeInsets.all(8),
//               decoration: BoxDecoration(
//                 color: Colors.orange.shade700.withOpacity(0.2),
//                 borderRadius: BorderRadius.circular(8),
//               ),
//               child: Icon(
//                 Icons.bolt,
//                 color: Colors.orange.shade400,
//                 size: 20,
//               ),
//             ),
//             const SizedBox(width: 12),
//             const Text(
//               'দ্রুত অ্যাকশন',
//               style: TextStyle(
//                 color: Colors.white,
//                 fontSize: 18,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//           ],
//         ),
//         const SizedBox(height: 16),
//         GridView.count(
//           shrinkWrap: true,
//           physics: const NeverScrollableScrollPhysics(),
//           crossAxisCount: 2,
//           mainAxisSpacing: 12,
//           crossAxisSpacing: 12,
//           childAspectRatio: 1.5,
//           children: [
//             _buildQuickActionCard(
//               icon: Icons.sports_soccer,
//               label: 'গোল',
//               color: Colors.green.shade400,
//               onTap: () {
//                 // Navigate to add goal
//               },
//             ),
//             _buildQuickActionCard(
//               icon: Icons.style,
//               label: 'কার্ড',
//               color: Colors.yellow.shade700,
//               onTap: () {
//                 // Navigate to add card
//               },
//             ),
//             _buildQuickActionCard(
//               icon: Icons.swap_horiz,
//               label: 'সাবস্টিটিউশন',
//               color: Colors.blue.shade400,
//               onTap: () {
//                 // Navigate to substitution
//               },
//             ),
//             _buildQuickActionCard(
//               icon: Icons.bar_chart,
//               label: 'স্ট্যাট',
//               color: Colors.purple.shade400,
//               onTap: () {
//                 // Navigate to stats
//               },
//             ),
//           ],
//         ),
//       ],
//     );
//   }
//
//   Widget _buildQuickActionCard({
//     required IconData icon,
//     required String label,
//     required Color color,
//     required VoidCallback onTap,
//   }) {
//     return Material(
//       color: Colors.transparent,
//       child: InkWell(
//         onTap: onTap,
//         borderRadius: BorderRadius.circular(16),
//         child: Container(
//           decoration: BoxDecoration(
//             gradient: LinearGradient(
//               colors: [
//                 color.withOpacity(0.2),
//                 color.withOpacity(0.05),
//               ],
//             ),
//             borderRadius: BorderRadius.circular(16),
//             border: Border.all(color: color.withOpacity(0.3)),
//           ),
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               Container(
//                 padding: const EdgeInsets.all(12),
//                 decoration: BoxDecoration(
//                   color: color.withOpacity(0.2),
//                   shape: BoxShape.circle,
//                 ),
//                 child: Icon(icon, color: color, size: 32),
//               ),
//               const SizedBox(height: 12),
//               Text(
//                 label,
//                 style: TextStyle(
//                   color: color,
//                   fontSize: 14,
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
//   Future<void> _updateScore() async {
//     try {
//       final matchProvider =
//       Provider.of<MatchProvider>(context, listen: false);
//       await matchProvider.updateMatchScore(
//         widget.match.id,
//         _scoreA,
//         _scoreB,
//       );
//
//       if (mounted) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(
//             content: const Text('স্কোর আপডেট সফল হয়েছে'),
//             backgroundColor: Colors.green.shade700,
//             behavior: SnackBarBehavior.floating,
//             shape: RoundedRectangleBorder(
//               borderRadius: BorderRadius.circular(10),
//             ),
//           ),
//         );
//       }
//     } catch (e) {
//       if (mounted) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(
//             content: Text('Error: $e'),
//             backgroundColor: Colors.red,
//             behavior: SnackBarBehavior.floating,
//           ),
//         );
//       }
//     }
//   }
// }
// // ============================================================================
// // TAB 3: TIMELINE
// // ============================================================================
// class _TimelineTab extends StatelessWidget {
//   final MatchModel match;
//
//   const _TimelineTab({required this.match});
//
//   @override
//   Widget build(BuildContext context) {
//     if (match.timeline.isEmpty) {
//       return _buildEmptyState();
//     }
//
//     // Sort timeline by minute
//     final sortedTimeline = List<MatchEvent>.from(match.timeline)
//       ..sort((a, b) => b.minute.compareTo(a.minute));
//
//     return ListView.builder(
//       padding: const EdgeInsets.all(16),
//       itemCount: sortedTimeline.length,
//       itemBuilder: (context, index) {
//         final event = sortedTimeline[index];
//         final isTeamA = event.team == 'teamA';
//
//         return _buildTimelineItem(event, isTeamA);
//       },
//     );
//   }
//
//   Widget _buildTimelineItem(MatchEvent event, bool isTeamA) {
//     IconData icon;
//     Color color;
//     String title;
//
//     switch (event.type) {
//       case 'goal':
//         icon = Icons.sports_soccer;
//         color = Colors.green.shade400;
//         title = 'গোল!';
//         break;
//       case 'card':
//         icon = Icons.style;
//         color = event.details == 'red_card'
//             ? Colors.red.shade400
//             : Colors.yellow.shade700;
//         title = event.details == 'red_card' ? 'লাল কার্ড' : 'হলুদ কার্ড';
//         break;
//       case 'substitution':
//         icon = Icons.swap_horiz;
//         color = Colors.blue.shade400;
//         title = 'সাবস্টিটিউশন';
//         break;
//       default:
//         icon = Icons.info;
//         color = Colors.grey;
//         title = 'ইভেন্ট';
//     }
//
//     return Container(
//       margin: const EdgeInsets.only(bottom: 16),
//       child: Row(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           if (!isTeamA) const Spacer(),
//           // Time Badge
//           Container(
//             width: 60,
//             padding: const EdgeInsets.symmetric(vertical: 8),
//             decoration: BoxDecoration(
//               color: color.withOpacity(0.2),
//               borderRadius: BorderRadius.circular(12),
//               border: Border.all(color: color.withOpacity(0.4)),
//             ),
//             child: Column(
//               children: [
//                 Text(
//                   "${event.minute}'",
//                   style: TextStyle(
//                     color: color,
//                     fontSize: 18,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           const SizedBox(width: 16),
//           // Event Card
//           Flexible(
//             flex: 2,
//             child: Container(
//               padding: const EdgeInsets.all(16),
//               decoration: BoxDecoration(
//                 gradient: LinearGradient(
//                   begin: isTeamA ? Alignment.centerLeft : Alignment.centerRight,
//                   end: isTeamA ? Alignment.centerRight : Alignment.centerLeft,
//                   colors: [
//                     color.withOpacity(0.2),
//                     color.withOpacity(0.05),
//                   ],
//                 ),
//                 borderRadius: BorderRadius.circular(16),
//                 border: Border.all(color: color.withOpacity(0.3)),
//               ),
//               child: Row(
//                 mainAxisSize: MainAxisSize.min,
//                 children: [
//                   if (isTeamA) ...[
//                     Expanded(child: _buildEventContent(event, title, isTeamA)),
//                     const SizedBox(width: 12),
//                     _buildEventIcon(icon, color),
//                   ] else ...[
//                     _buildEventIcon(icon, color),
//                     const SizedBox(width: 12),
//                     Expanded(child: _buildEventContent(event, title, isTeamA)),
//                   ],
//                 ],
//               ),
//             ),
//           ),
//           if (isTeamA) const Spacer(),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildEventIcon(IconData icon, Color color) {
//     return Container(
//       padding: const EdgeInsets.all(10),
//       decoration: BoxDecoration(
//         color: color.withOpacity(0.2),
//         shape: BoxShape.circle,
//       ),
//       child: Icon(icon, color: color, size: 24),
//     );
//   }
//
//   Widget _buildEventContent(MatchEvent event, String title, bool isTeamA) {
//     return Column(
//       crossAxisAlignment:
//       isTeamA ? CrossAxisAlignment.start : CrossAxisAlignment.end,
//       children: [
//         Text(
//           title,
//           style: const TextStyle(
//             color: Colors.white,
//             fontSize: 13,
//             fontWeight: FontWeight.bold,
//           ),
//         ),
//         const SizedBox(height: 4),
//         Text(
//           event.playerName,
//           style: const TextStyle(
//             color: Colors.white,
//             fontSize: 16,
//             fontWeight: FontWeight.w600,
//           ),
//           textAlign: isTeamA ? TextAlign.left : TextAlign.right,
//         ),
//         if (event.assistPlayerId != null) ...[
//           const SizedBox(height: 4),
//           Text(
//             'Assist: ${event.assistPlayerId}',
//             style: TextStyle(
//               color: Colors.white.withOpacity(0.6),
//               fontSize: 12,
//             ),
//             textAlign: isTeamA ? TextAlign.left : TextAlign.right,
//           ),
//         ],
//       ],
//     );
//   }
//
//   Widget _buildEmptyState() {
//     return Center(
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Container(
//             padding: const EdgeInsets.all(32),
//             decoration: BoxDecoration(
//               color: Colors.white.withOpacity(0.05),
//               shape: BoxShape.circle,
//             ),
//             child: Icon(
//               Icons.timeline,
//               size: 64,
//               color: Colors.white.withOpacity(0.3),
//             ),
//           ),
//           const SizedBox(height: 24),
//           Text(
//             'কোন ইভেন্ট নেই',
//             style: TextStyle(
//               color: Colors.white.withOpacity(0.6),
//               fontSize: 18,
//               fontWeight: FontWeight.w600,
//             ),
//           ),
//           const SizedBox(height: 8),
//           Text(
//             'ম্যাচ শুরু হলে এখানে ইভেন্ট দেখা যাবে',
//             style: TextStyle(
//               color: Colors.white.withOpacity(0.4),
//               fontSize: 14,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
//
// // ============================================================================
// // TAB 4: LINEUP
// // ============================================================================
//
//
// // ============================================================================
// // TAB 5: STATISTICS
// // ============================================================================
// class _StatsTab extends StatelessWidget {
//   final MatchModel match;
//
//   const _StatsTab({required this.match});
//
//   @override
//   Widget build(BuildContext context) {
//     if (match.stats == null) {
//       return _buildEmptyState();
//     }
//
//     final stats = match.stats!;
//
//     return SingleChildScrollView(
//       padding: const EdgeInsets.all(16),
//       child: Column(
//         children: [
//           // Possession
//           _buildStatCard(
//             icon: Icons.pie_chart,
//             title: 'পজেশন',
//             color: Colors.purple.shade400,
//             child: _buildPossessionBar(stats.possessionA, stats.possessionB),
//           ),
//           const SizedBox(height: 16),
//           // Shots
//           _buildStatCard(
//             icon: Icons.sports_soccer,
//             title: 'শট',
//             color: Colors.green.shade400,
//             child: Column(
//               children: [
//                 _buildStatBar(
//                   label: 'মোট শট',
//                   valueA: stats.shotsA,
//                   valueB: stats.shotsB,
//                   color: Colors.green.shade400,
//                 ),
//                 const SizedBox(height: 16),
//                 _buildStatBar(
//                   label: 'টার্গেটে শট',
//                   valueA: stats.shotsOnTargetA,
//                   valueB: stats.shotsOnTargetB,
//                   color: Colors.green.shade600,
//                 ),
//               ],
//             ),
//           ),
//           const SizedBox(height: 16),
//           // Other Stats
//           _buildStatCard(
//             icon: Icons.analytics,
//             title: 'অন্যান্য পরিসংখ্যান',
//             color: Colors.blue.shade400,
//             child: Column(
//               children: [
//                 _buildStatBar(
//                   label: 'কর্নার',
//                   valueA: stats.cornersA,
//                   valueB: stats.cornersB,
//                   color: Colors.blue.shade400,
//                 ),
//                 const SizedBox(height: 16),
//                 _buildStatBar(
//                   label: 'ফাউল',
//                   valueA: stats.foulsA,
//                   valueB: stats.foulsB,
//                   color: Colors.orange.shade400,
//                 ),
//               ],
//             ),
//           ),
//           const SizedBox(height: 16),
//           // Cards
//           _buildStatCard(
//             icon: Icons.style,
//             title: 'কার্ড',
//             color: Colors.yellow.shade700,
//             child: Column(
//               children: [
//                 _buildStatBar(
//                   label: 'হলুদ কার্ড',
//                   valueA: stats.yellowCardsA,
//                   valueB: stats.yellowCardsB,
//                   color: Colors.yellow.shade700,
//                 ),
//                 const SizedBox(height: 16),
//                 _buildStatBar(
//                   label: 'লাল কার্ড',
//                   valueA: stats.redCardsA,
//                   valueB: stats.redCardsB,
//                   color: Colors.red.shade400,
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildStatCard({
//     required IconData icon,
//     required String title,
//     required Color color,
//     required Widget child,
//   }) {
//     return Container(
//       padding: const EdgeInsets.all(20),
//       decoration: BoxDecoration(
//         gradient: LinearGradient(
//           colors: [
//             const Color(0xFF1E293B),
//             const Color(0xFF1E293B).withOpacity(0.8),
//           ],
//         ),
//         borderRadius: BorderRadius.circular(20),
//         border: Border.all(color: color.withOpacity(0.3)),
//       ),
//       child: Column(
//         children: [
//           Row(
//             children: [
//               Container(
//                 padding: const EdgeInsets.all(10),
//                 decoration: BoxDecoration(
//                   color: color.withOpacity(0.2),
//                   borderRadius: BorderRadius.circular(10),
//                 ),
//                 child: Icon(icon, color: color, size: 24),
//               ),
//               const SizedBox(width: 12),
//               Text(
//                 title,
//                 style: const TextStyle(
//                   color: Colors.white,
//                   fontSize: 18,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//             ],
//           ),
//           const SizedBox(height: 20),
//           child,
//         ],
//       ),
//     );
//   }
//
//   Widget _buildPossessionBar(int possessionA, int possessionB) {
//     return Column(
//       children: [
//         Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             Text(
//               '$possessionA%',
//               style: TextStyle(
//                 color: Colors.green.shade400,
//                 fontSize: 24,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//             Text(
//               'VS',
//               style: TextStyle(
//                 color: Colors.white.withOpacity(0.4),
//                 fontSize: 14,
//               ),
//             ),
//             Text(
//               '$possessionB%',
//               style: TextStyle(
//                 color: Colors.blue.shade400,
//                 fontSize: 24,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//           ],
//         ),
//         const SizedBox(height: 16),
//         ClipRRect(
//           borderRadius: BorderRadius.circular(10),
//           child: Row(
//             children: [
//               Expanded(
//                 flex: possessionA,
//                 child: Container(
//                   height: 12,
//                   decoration: BoxDecoration(
//                     gradient: LinearGradient(
//                       colors: [
//                         Colors.green.shade600,
//                         Colors.green.shade400,
//                       ],
//                     ),
//                   ),
//                 ),
//               ),
//               Expanded(
//                 flex: possessionB,
//                 child: Container(
//                   height: 12,
//                   decoration: BoxDecoration(
//                     gradient: LinearGradient(
//                       colors: [
//                         Colors.blue.shade400,
//                         Colors.blue.shade600,
//                       ],
//                     ),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ],
//     );
//   }
//
//   Widget _buildStatBar({
//     required String label,
//     required int valueA,
//     required int valueB,
//     required Color color,
//   }) {
//     final total = valueA + valueB;
//     final percentA = total > 0 ? (valueA / total * 100).round() : 50;
//     final percentB = total > 0 ? (valueB / total * 100).round() : 50;
//
//     return Column(
//       children: [
//         Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             Text(
//               '$valueA',
//               style: TextStyle(
//                 color: color,
//                 fontSize: 20,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//             Text(
//               label,
//               style: TextStyle(
//                 color: Colors.white.withOpacity(0.7),
//                 fontSize: 14,
//                 fontWeight: FontWeight.w600,
//               ),
//             ),
//             Text(
//               '$valueB',
//               style: TextStyle(
//                 color: color,
//                 fontSize: 20,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//           ],
//         ),
//         const SizedBox(height: 8),
//         ClipRRect(
//           borderRadius: BorderRadius.circular(6),
//           child: Row(
//             children: [
//               Expanded(
//                 flex: percentA,
//                 child: Container(
//                   height: 8,
//                   color: color.withOpacity(0.8),
//                 ),
//               ),
//               Expanded(
//                 flex: percentB,
//                 child: Container(
//                   height: 8,
//                   color: Colors.white.withOpacity(0.2),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ],
//     );
//   }
//
//   Widget _buildEmptyState() {
//     return Center(
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Container(
//             padding: const EdgeInsets.all(32),
//             decoration: BoxDecoration(
//               color: Colors.white.withOpacity(0.05),
//               shape: BoxShape.circle,
//             ),
//             child: Icon(
//               Icons.bar_chart,
//               size: 64,
//               color: Colors.white.withOpacity(0.3),
//             ),
//           ),
//           const SizedBox(height: 24),
//           Text(
//             'পরিসংখ্যান উপলব্ধ নেই',
//             style: TextStyle(
//               color: Colors.white.withOpacity(0.6),
//               fontSize: 18,
//               fontWeight: FontWeight.w600,
//             ),
//           ),
//           const SizedBox(height: 8),
//           Text(
//             'ম্যাচ চলাকালীন পরিসংখ্যান আপডেট হবে',
//             style: TextStyle(
//               color: Colors.white.withOpacity(0.4),
//               fontSize: 14,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }