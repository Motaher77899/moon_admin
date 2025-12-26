// // // //
// // // //
// // // //
// // // // import 'package:flutter/material.dart';
// // // // import 'package:provider/provider.dart';
// // // // import 'package:intl/intl.dart';
// // // //
// // // // import '../../providers/auth_provider.dart';
// // // // import '../../providers/match_provider.dart';
// // // // import '../../providers/tournament_provider.dart';
// // // // import '../../models/match_model.dart';
// // // // import '../../models/tournament_model.dart';
// // // //
// // // // import '../match/match_detail_screen.dart';
// // // // import '../match/create_single_match_screen.dart';
// // // // import '../tournament/create_tournament_screen.dart';
// // // // import '../tournament/tournament_detail_screen.dart';
// // // //
// // // // class AdminHomeScreen extends StatefulWidget {
// // // //   const AdminHomeScreen({Key? key}) : super(key: key);
// // // //
// // // //   @override
// // // //   State<AdminHomeScreen> createState() => _AdminHomeScreenState();
// // // // }
// // // //
// // // // class _AdminHomeScreenState extends State<AdminHomeScreen> {
// // // //   int _selectedIndex = 0;
// // // //   final DateFormat _dateFormat = DateFormat('dd MMM yyyy');
// // // //
// // // //   @override
// // // //   void initState() {
// // // //     super.initState();
// // // //     WidgetsBinding.instance.addPostFrameCallback((_) => _loadData());
// // // //   }
// // // //
// // // //   Future<void> _loadData() async {
// // // //     final authProvider = Provider.of<AuthProvider>(context, listen: false);
// // // //     final matchProvider = Provider.of<MatchProvider>(context, listen: false);
// // // //     final tournamentProvider = Provider.of<TournamentProvider>(context, listen: false);
// // // //
// // // //     String adminFullName = authProvider.currentAdmin?.fullName ?? '';
// // // //
// // // //     if (adminFullName.isEmpty) return;
// // // //
// // // //     await Future.wait([
// // // //       matchProvider.loadMatchesByAdmin(adminFullName),
// // // //       matchProvider.loadTeams(),
// // // //       tournamentProvider.loadTournamentsByAdmin(adminFullName),
// // // //     ]);
// // // //   }
// // // //
// // // //   @override
// // // //   Widget build(BuildContext context) {
// // // //     return Scaffold(
// // // //       appBar: _selectedIndex == 2 ? null : _buildAppBar(),
// // // //       body: IndexedStack(
// // // //         index: _selectedIndex,
// // // //         children: [
// // // //           _buildMatchesTab(),
// // // //           _buildTournamentsTab(),
// // // //           _buildMoreTab(),
// // // //         ],
// // // //       ),
// // // //       bottomNavigationBar: _buildBottomNavBar(),
// // // //       floatingActionButton: _selectedIndex < 2 ? _buildFAB() : null,
// // // //     );
// // // //   }
// // // //
// // // //   AppBar _buildAppBar() {
// // // //     return AppBar(
// // // //       title: Text(_selectedIndex == 0 ? 'ম্যাচসমূহ' : 'টুর্নামেন্ট'),
// // // //       flexibleSpace: Container(
// // // //         decoration: BoxDecoration(
// // // //           gradient: LinearGradient(
// // // //             colors: [Colors.orange.shade700, Colors.orange.shade900],
// // // //           ),
// // // //         ),
// // // //       ),
// // // //       foregroundColor: Colors.white,
// // // //       elevation: 0,
// // // //       actions: [
// // // //         IconButton(
// // // //           icon: const Icon(Icons.refresh),
// // // //           onPressed: _loadData,
// // // //           tooltip: 'রিফ্রেশ',
// // // //         ),
// // // //       ],
// // // //     );
// // // //   }
// // // //
// // // //   Widget _buildBottomNavBar() {
// // // //     return Container(
// // // //       decoration: BoxDecoration(
// // // //         boxShadow: [
// // // //           BoxShadow(
// // // //             color: Colors.black.withOpacity(0.1),
// // // //             blurRadius: 10,
// // // //             offset: const Offset(0, -2),
// // // //           ),
// // // //         ],
// // // //       ),
// // // //       child: BottomNavigationBar(
// // // //         currentIndex: _selectedIndex,
// // // //         onTap: (index) => setState(() => _selectedIndex = index),
// // // //         selectedItemColor: Colors.orange.shade700,
// // // //         unselectedItemColor: Colors.grey,
// // // //         selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold),
// // // //         type: BottomNavigationBarType.fixed,
// // // //         elevation: 0,
// // // //         items: const [
// // // //           BottomNavigationBarItem(
// // // //             icon: Icon(Icons.sports_soccer),
// // // //             label: 'ম্যাচ',
// // // //           ),
// // // //           BottomNavigationBarItem(
// // // //             icon: Icon(Icons.emoji_events),
// // // //             label: 'টুর্নামেন্ট',
// // // //           ),
// // // //           BottomNavigationBarItem(
// // // //             icon: Icon(Icons.more_horiz),
// // // //             label: 'আরও',
// // // //           ),
// // // //         ],
// // // //       ),
// // // //     );
// // // //   }
// // // //
// // // //   Widget _buildFAB() {
// // // //     return FloatingActionButton.extended(
// // // //       onPressed: () {
// // // //         if (_selectedIndex == 0) {
// // // //           Navigator.push(
// // // //             context,
// // // //             MaterialPageRoute(
// // // //                 builder: (_) => const CreateSingleMatchScreen()),
// // // //           ).then((_) => _loadData());
// // // //         } else {
// // // //           Navigator.push(
// // // //             context,
// // // //             MaterialPageRoute(builder: (_) => const CreateTournamentScreen()),
// // // //           ).then((_) => _loadData());
// // // //         }
// // // //       },
// // // //       backgroundColor: Colors.orange.shade700,
// // // //       icon: const Icon(Icons.add, color: Colors.white),
// // // //       label: Text(
// // // //         _selectedIndex == 0 ? 'নতুন ম্যাচ' : 'নতুন টুর্নামেন্ট',
// // // //         style: const TextStyle(
// // // //           color: Colors.white,
// // // //           fontWeight: FontWeight.bold,
// // // //         ),
// // // //       ),
// // // //     );
// // // //   }
// // // //
// // // //   // ==================== TAB 1: MATCHES ====================
// // // //   Widget _buildMatchesTab() {
// // // //     return Consumer<MatchProvider>(
// // // //       builder: (context, matchProvider, child) {
// // // //         if (matchProvider.isLoading) {
// // // //           return const Center(child: CircularProgressIndicator());
// // // //         }
// // // //
// // // //         if (matchProvider.matches.isEmpty) {
// // // //           return _buildEmptyState(
// // // //             icon: Icons.sports_soccer,
// // // //             title: 'কোন ম্যাচ নেই',
// // // //             subtitle: 'নতুন ম্যাচ তৈরি করতে + বাটনে ক্লিক করুন',
// // // //           );
// // // //         }
// // // //
// // // //         return RefreshIndicator(
// // // //           onRefresh: _loadData,
// // // //           child: ListView.builder(
// // // //             padding: const EdgeInsets.all(16),
// // // //             itemCount: matchProvider.matches.length,
// // // //             itemBuilder: (context, index) =>
// // // //                 _buildMatchCard(matchProvider.matches[index]),
// // // //           ),
// // // //         );
// // // //       },
// // // //     );
// // // //   }
// // // //
// // // //   // ==================== TAB 2: TOURNAMENTS ====================
// // // //   Widget _buildTournamentsTab() {
// // // //     return Consumer<TournamentProvider>(
// // // //       builder: (context, tournamentProvider, child) {
// // // //         if (tournamentProvider.isLoading) {
// // // //           return const Center(child: CircularProgressIndicator());
// // // //         }
// // // //
// // // //         if (tournamentProvider.tournaments.isEmpty) {
// // // //           return _buildEmptyState(
// // // //             icon: Icons.emoji_events,
// // // //             title: 'কোন টুর্নামেন্ট নেই',
// // // //             subtitle: 'নতুন টুর্নামেন্ট তৈরি করতে + বাটনে ক্লিক করুন',
// // // //           );
// // // //         }
// // // //
// // // //         return RefreshIndicator(
// // // //           onRefresh: _loadData,
// // // //           child: ListView.builder(
// // // //             padding: const EdgeInsets.all(16),
// // // //             itemCount: tournamentProvider.tournaments.length,
// // // //             itemBuilder: (context, index) =>
// // // //                 _buildTournamentCard(tournamentProvider.tournaments[index]),
// // // //           ),
// // // //         );
// // // //       },
// // // //     );
// // // //   }
// // // //
// // // //   // ==================== TAB 3: MORE (PROFILE) ====================
// // // //   Widget _buildMoreTab() {
// // // //     return Consumer<AuthProvider>(
// // // //       builder: (context, authProvider, child) {
// // // //         final admin = authProvider.currentAdmin;
// // // //
// // // //         return Container(
// // // //           decoration: BoxDecoration(
// // // //             gradient: LinearGradient(
// // // //               begin: Alignment.topCenter,
// // // //               end: Alignment.bottomCenter,
// // // //               colors: [
// // // //                 Colors.orange.shade700,
// // // //                 Colors.orange.shade900,
// // // //               ],
// // // //             ),
// // // //           ),
// // // //           child: SafeArea(
// // // //             child: SingleChildScrollView(
// // // //               child: Column(
// // // //                 children: [
// // // //                   const SizedBox(height: 40),
// // // //                   // Profile Header
// // // //                   Container(
// // // //                     padding: const EdgeInsets.all(24),
// // // //                     child: Column(
// // // //                       children: [
// // // //                         Container(
// // // //                           padding: const EdgeInsets.all(4),
// // // //                           decoration: BoxDecoration(
// // // //                             shape: BoxShape.circle,
// // // //                             border: Border.all(color: Colors.white, width: 3),
// // // //                             boxShadow: [
// // // //                               BoxShadow(
// // // //                                 color: Colors.black.withOpacity(0.2),
// // // //                                 blurRadius: 20,
// // // //                                 spreadRadius: 5,
// // // //                               ),
// // // //                             ],
// // // //                           ),
// // // //                           child: CircleAvatar(
// // // //                             radius: 60,
// // // //                             backgroundColor: Colors.white,
// // // //                             child: Icon(
// // // //                               Icons.person,
// // // //                               size: 60,
// // // //                               color: Colors.orange.shade700,
// // // //                             ),
// // // //                           ),
// // // //                         ),
// // // //                         const SizedBox(height: 20),
// // // //                         Text(
// // // //                           admin?.fullName ?? 'Admin',
// // // //                           style: const TextStyle(
// // // //                             color: Colors.white,
// // // //                             fontSize: 28,
// // // //                             fontWeight: FontWeight.bold,
// // // //                           ),
// // // //                         ),
// // // //                         const SizedBox(height: 8),
// // // //                         Container(
// // // //                           padding: const EdgeInsets.symmetric(
// // // //                             horizontal: 16,
// // // //                             vertical: 8,
// // // //                           ),
// // // //                           decoration: BoxDecoration(
// // // //                             color: Colors.white.withOpacity(0.2),
// // // //                             borderRadius: BorderRadius.circular(20),
// // // //                           ),
// // // //                           child: const Text(
// // // //                             'টুর্নামেন্ট অ্যাডমিন',
// // // //                             style: TextStyle(
// // // //                               color: Colors.white,
// // // //                               fontSize: 14,
// // // //                               fontWeight: FontWeight.w600,
// // // //                             ),
// // // //                           ),
// // // //                         ),
// // // //                       ],
// // // //                     ),
// // // //                   ),
// // // //                   const SizedBox(height: 20),
// // // //                   // Menu Cards
// // // //                   Container(
// // // //                     decoration: const BoxDecoration(
// // // //                       color: Colors.white,
// // // //                       borderRadius: BorderRadius.only(
// // // //                         topLeft: Radius.circular(30),
// // // //                         topRight: Radius.circular(30),
// // // //                       ),
// // // //                     ),
// // // //                     child: Column(
// // // //                       children: [
// // // //                         const SizedBox(height: 30),
// // // //                         _buildMenuCard(
// // // //                           icon: Icons.person_outline,
// // // //                           title: 'প্রোফাইল তথ্য',
// // // //                           subtitle: 'আপনার প্রোফাইল দেখুন',
// // // //                           color: Colors.blue,
// // // //                           onTap: () {
// // // //                             // Navigate to profile details
// // // //                           },
// // // //                         ),
// // // //                         _buildMenuCard(
// // // //                           icon: Icons.sports_soccer,
// // // //                           title: 'মোট ম্যাচ',
// // // //                           subtitle:
// // // //                           '${context.read<MatchProvider>().matches.length} টি',
// // // //                           color: Colors.green,
// // // //                           onTap: () {
// // // //                             setState(() => _selectedIndex = 0);
// // // //                           },
// // // //                         ),
// // // //                         _buildMenuCard(
// // // //                           icon: Icons.emoji_events,
// // // //                           title: 'মোট টুর্নামেন্ট',
// // // //                           subtitle:
// // // //                           '${context.read<TournamentProvider>().tournaments.length} টি',
// // // //                           color: Colors.orange,
// // // //                           onTap: () {
// // // //                             setState(() => _selectedIndex = 1);
// // // //                           },
// // // //                         ),
// // // //                         _buildMenuCard(
// // // //                           icon: Icons.shield,
// // // //                           title: 'টিম ম্যানেজমেন্ট',
// // // //                           subtitle: 'টিম যোগ ও পরিচালনা করুন',
// // // //                           color: Colors.purple,
// // // //                           onTap: () {
// // // //                             // Navigate to team management
// // // //                           },
// // // //                         ),
// // // //                         _buildMenuCard(
// // // //                           icon: Icons.settings,
// // // //                           title: 'সেটিংস',
// // // //                           subtitle: 'অ্যাপ সেটিংস',
// // // //                           color: Colors.grey,
// // // //                           onTap: () {
// // // //                             // Navigate to settings
// // // //                           },
// // // //                         ),
// // // //                         const SizedBox(height: 20),
// // // //                         // Logout Button
// // // //                         Container(
// // // //                           margin: const EdgeInsets.symmetric(horizontal: 20),
// // // //                           width: double.infinity,
// // // //                           child: ElevatedButton.icon(
// // // //                             onPressed: () async {
// // // //                               final confirmed = await showDialog<bool>(
// // // //                                 context: context,
// // // //                                 builder: (context) => AlertDialog(
// // // //                                   title: const Text('লগআউট নিশ্চিত করুন'),
// // // //                                   content: const Text(
// // // //                                       'আপনি কি লগআউট করতে চান?'),
// // // //                                   actions: [
// // // //                                     TextButton(
// // // //                                       onPressed: () =>
// // // //                                           Navigator.pop(context, false),
// // // //                                       child: const Text('না'),
// // // //                                     ),
// // // //                                     ElevatedButton(
// // // //                                       onPressed: () =>
// // // //                                           Navigator.pop(context, true),
// // // //                                       style: ElevatedButton.styleFrom(
// // // //                                         backgroundColor: Colors.red,
// // // //                                       ),
// // // //                                       child: const Text('হ্যাঁ, লগআউট'),
// // // //                                     ),
// // // //                                   ],
// // // //                                 ),
// // // //                               );
// // // //
// // // //                               if (confirmed == true && mounted) {
// // // //                                 await authProvider.logout();
// // // //                                 if (!mounted) return;
// // // //                                 Navigator.of(context).pushNamedAndRemoveUntil(
// // // //                                     '/login', (route) => false);
// // // //                               }
// // // //                             },
// // // //                             icon: const Icon(Icons.logout),
// // // //                             label: const Text(
// // // //                               'লগআউট',
// // // //                               style: TextStyle(
// // // //                                 fontSize: 16,
// // // //                                 fontWeight: FontWeight.bold,
// // // //                               ),
// // // //                             ),
// // // //                             style: ElevatedButton.styleFrom(
// // // //                               backgroundColor: Colors.red,
// // // //                               foregroundColor: Colors.white,
// // // //                               padding: const EdgeInsets.symmetric(vertical: 16),
// // // //                               shape: RoundedRectangleBorder(
// // // //                                 borderRadius: BorderRadius.circular(12),
// // // //                               ),
// // // //                               elevation: 0,
// // // //                             ),
// // // //                           ),
// // // //                         ),
// // // //                         const SizedBox(height: 40),
// // // //                       ],
// // // //                     ),
// // // //                   ),
// // // //                 ],
// // // //               ),
// // // //             ),
// // // //           ),
// // // //         );
// // // //       },
// // // //     );
// // // //   }
// // // //
// // // //   Widget _buildMenuCard({
// // // //     required IconData icon,
// // // //     required String title,
// // // //     required String subtitle,
// // // //     required Color color,
// // // //     required VoidCallback onTap,
// // // //   }) {
// // // //     return Container(
// // // //       margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
// // // //       child: Material(
// // // //         color: Colors.transparent,
// // // //         child: InkWell(
// // // //           onTap: onTap,
// // // //           borderRadius: BorderRadius.circular(16),
// // // //           child: Container(
// // // //             padding: const EdgeInsets.all(16),
// // // //             decoration: BoxDecoration(
// // // //               color: Colors.white,
// // // //               borderRadius: BorderRadius.circular(16),
// // // //               border: Border.all(color: Colors.grey.shade200),
// // // //               boxShadow: [
// // // //                 BoxShadow(
// // // //                   color: Colors.black.withOpacity(0.05),
// // // //                   blurRadius: 10,
// // // //                   offset: const Offset(0, 4),
// // // //                 ),
// // // //               ],
// // // //             ),
// // // //             child: Row(
// // // //               children: [
// // // //                 Container(
// // // //                   padding: const EdgeInsets.all(12),
// // // //                   decoration: BoxDecoration(
// // // //                     color: color.withOpacity(0.1),
// // // //                     borderRadius: BorderRadius.circular(12),
// // // //                   ),
// // // //                   child: Icon(icon, color: color, size: 28),
// // // //                 ),
// // // //                 const SizedBox(width: 16),
// // // //                 Expanded(
// // // //                   child: Column(
// // // //                     crossAxisAlignment: CrossAxisAlignment.start,
// // // //                     children: [
// // // //                       Text(
// // // //                         title,
// // // //                         style: const TextStyle(
// // // //                           fontSize: 16,
// // // //                           fontWeight: FontWeight.bold,
// // // //                           color: Colors.black87,
// // // //                         ),
// // // //                       ),
// // // //                       const SizedBox(height: 4),
// // // //                       Text(
// // // //                         subtitle,
// // // //                         style: TextStyle(
// // // //                           fontSize: 13,
// // // //                           color: Colors.grey.shade600,
// // // //                         ),
// // // //                       ),
// // // //                     ],
// // // //                   ),
// // // //                 ),
// // // //                 Icon(
// // // //                   Icons.arrow_forward_ios,
// // // //                   color: Colors.grey.shade400,
// // // //                   size: 16,
// // // //                 ),
// // // //               ],
// // // //             ),
// // // //           ),
// // // //         ),
// // // //       ),
// // // //     );
// // // //   }
// // // //
// // // //   // ==================== Match Card ====================
// // // //   Widget _buildMatchCard(MatchModel match) {
// // // //     final statusColor = match.status == 'live'
// // // //         ? Colors.green
// // // //         : match.status == 'completed'
// // // //         ? Colors.grey
// // // //         : Colors.orange;
// // // //
// // // //     return Card(
// // // //       margin: const EdgeInsets.only(bottom: 12),
// // // //       elevation: 2,
// // // //       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
// // // //       child: InkWell(
// // // //         borderRadius: BorderRadius.circular(16),
// // // //         onTap: () {
// // // //           Navigator.push(
// // // //             context,
// // // //             MaterialPageRoute(
// // // //                 builder: (_) => MatchDetailScreen(match: match)),
// // // //           ).then((_) => _loadData());
// // // //         },
// // // //         child: Padding(
// // // //           padding: const EdgeInsets.all(16),
// // // //           child: Column(
// // // //             children: [
// // // //               // Status Badge
// // // //               Row(
// // // //                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
// // // //                 children: [
// // // //                   Container(
// // // //                     padding:
// // // //                     const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
// // // //                     decoration: BoxDecoration(
// // // //                       color: statusColor.withOpacity(0.1),
// // // //                       borderRadius: BorderRadius.circular(20),
// // // //                       border: Border.all(color: statusColor),
// // // //                     ),
// // // //                     child: Row(
// // // //                       mainAxisSize: MainAxisSize.min,
// // // //                       children: [
// // // //                         if (match.status == 'live')
// // // //                           Container(
// // // //                             width: 8,
// // // //                             height: 8,
// // // //                             margin: const EdgeInsets.only(right: 6),
// // // //                             decoration: BoxDecoration(
// // // //                               color: statusColor,
// // // //                               shape: BoxShape.circle,
// // // //                             ),
// // // //                           ),
// // // //                         Text(
// // // //                           match.status == 'live'
// // // //                               ? 'লাইভ'
// // // //                               : match.status == 'completed'
// // // //                               ? 'সম্পন্ন'
// // // //                               : 'আসন্ন',
// // // //                           style: TextStyle(
// // // //                             color: statusColor,
// // // //                             fontWeight: FontWeight.bold,
// // // //                             fontSize: 12,
// // // //                           ),
// // // //                         ),
// // // //                       ],
// // // //                     ),
// // // //                   ),
// // // //                   if (match.tournament != null)
// // // //                     Container(
// // // //                       padding: const EdgeInsets.symmetric(
// // // //                           horizontal: 8, vertical: 4),
// // // //                       decoration: BoxDecoration(
// // // //                         color: Colors.orange.shade50,
// // // //                         borderRadius: BorderRadius.circular(8),
// // // //                       ),
// // // //                       child: Row(
// // // //                         mainAxisSize: MainAxisSize.min,
// // // //                         children: [
// // // //                           Icon(Icons.emoji_events,
// // // //                               size: 14, color: Colors.orange.shade700),
// // // //                           const SizedBox(width: 4),
// // // //                           Text(
// // // //                             match.tournament!,
// // // //                             style: TextStyle(
// // // //                               fontSize: 11,
// // // //                               color: Colors.orange.shade700,
// // // //                               fontWeight: FontWeight.bold,
// // // //                             ),
// // // //                           ),
// // // //                         ],
// // // //                       ),
// // // //                     ),
// // // //                 ],
// // // //               ),
// // // //               const SizedBox(height: 16),
// // // //
// // // //               // Teams & Score
// // // //               Row(
// // // //                 children: [
// // // //                   _buildTeamColumn(match.teamAName, match.scoreA),
// // // //                   Padding(
// // // //                     padding: const EdgeInsets.symmetric(horizontal: 16),
// // // //                     child: Text(
// // // //                       'VS',
// // // //                       style: TextStyle(
// // // //                         fontSize: 18,
// // // //                         fontWeight: FontWeight.bold,
// // // //                         color: Colors.grey.shade400,
// // // //                       ),
// // // //                     ),
// // // //                   ),
// // // //                   _buildTeamColumn(match.teamBName, match.scoreB),
// // // //                 ],
// // // //               ),
// // // //               const SizedBox(height: 16),
// // // //
// // // //               // Venue & Date
// // // //               Container(
// // // //                 padding: const EdgeInsets.all(12),
// // // //                 decoration: BoxDecoration(
// // // //                   color: Colors.grey.shade50,
// // // //                   borderRadius: BorderRadius.circular(12),
// // // //                 ),
// // // //                 child: Row(
// // // //                   mainAxisAlignment: MainAxisAlignment.spaceAround,
// // // //                   children: [
// // // //                     if (match.venue != null)
// // // //                       _infoRow(Icons.location_on, match.venue!),
// // // //                     if (match.venue != null)
// // // //                       Container(
// // // //                           width: 1, height: 20, color: Colors.grey.shade300),
// // // //                     _infoRow(Icons.calendar_today,
// // // //                         _dateFormat.format(match.date)),
// // // //                   ],
// // // //                 ),
// // // //               ),
// // // //             ],
// // // //           ),
// // // //         ),
// // // //       ),
// // // //     );
// // // //   }
// // // //
// // // //   Widget _buildTeamColumn(String teamName, int score) {
// // // //     return Expanded(
// // // //       child: Column(
// // // //         children: [
// // // //           _placeholderLogo(),
// // // //           const SizedBox(height: 8),
// // // //           Text(
// // // //             teamName,
// // // //             style: const TextStyle(
// // // //               fontWeight: FontWeight.bold,
// // // //               fontSize: 13,
// // // //             ),
// // // //             textAlign: TextAlign.center,
// // // //             maxLines: 2,
// // // //             overflow: TextOverflow.ellipsis,
// // // //           ),
// // // //           const SizedBox(height: 8),
// // // //           Text(
// // // //             '$score',
// // // //             style: TextStyle(
// // // //               fontSize: 28,
// // // //               fontWeight: FontWeight.bold,
// // // //               color: Colors.orange.shade700,
// // // //             ),
// // // //           ),
// // // //         ],
// // // //       ),
// // // //     );
// // // //   }
// // // //
// // // //   Widget _placeholderLogo() {
// // // //     return Container(
// // // //       width: 56,
// // // //       height: 56,
// // // //       decoration: BoxDecoration(
// // // //         color: Colors.grey.shade200,
// // // //         borderRadius: BorderRadius.circular(8),
// // // //       ),
// // // //       child: Icon(Icons.shield, color: Colors.grey.shade400, size: 32),
// // // //     );
// // // //   }
// // // //
// // // //   Widget _infoRow(IconData icon, String text) {
// // // //     return Row(
// // // //       mainAxisSize: MainAxisSize.min,
// // // //       children: [
// // // //         Icon(icon, size: 16, color: Colors.grey.shade600),
// // // //         const SizedBox(width: 6),
// // // //         Flexible(
// // // //           child: Text(
// // // //             text,
// // // //             style: TextStyle(
// // // //               fontSize: 12,
// // // //               color: Colors.grey.shade700,
// // // //               fontWeight: FontWeight.w500,
// // // //             ),
// // // //             overflow: TextOverflow.ellipsis,
// // // //           ),
// // // //         ),
// // // //       ],
// // // //     );
// // // //   }
// // // //
// // // //   // ==================== Tournament Card ====================
// // // //   Widget _buildTournamentCard(TournamentModel tournament) {
// // // //     // ✅ FIXED: completed → finished
// // // //     final statusColor = tournament.status == 'ongoing'
// // // //         ? Colors.green
// // // //         : tournament.status == 'finished'
// // // //         ? Colors.grey
// // // //         : Colors.orange;
// // // //
// // // //     final statusText = tournament.status == 'ongoing'
// // // //         ? 'চলমান'
// // // //         : tournament.status == 'finished'
// // // //         ? 'সম্পন্ন'
// // // //         : 'আসন্ন';
// // // //
// // // //     return Card(
// // // //       margin: const EdgeInsets.only(bottom: 12),
// // // //       elevation: 2,
// // // //       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
// // // //       child: InkWell(
// // // //         borderRadius: BorderRadius.circular(16),
// // // //         onTap: () {
// // // //           // ✅ FIXED: Navigation enabled
// // // //           Navigator.push(
// // // //             context,
// // // //             MaterialPageRoute(
// // // //                 builder: (_) =>
// // // //                     TournamentDetailScreen(tournament: tournament)),
// // // //           ).then((_) => _loadData());
// // // //         },
// // // //         child: Padding(
// // // //           padding: const EdgeInsets.all(16),
// // // //           child: Row(
// // // //             children: [
// // // //               Container(
// // // //                 padding: const EdgeInsets.all(12),
// // // //                 decoration: BoxDecoration(
// // // //                   color: statusColor.withOpacity(0.1),
// // // //                   borderRadius: BorderRadius.circular(12),
// // // //                 ),
// // // //                 child: Icon(Icons.emoji_events, color: statusColor, size: 32),
// // // //               ),
// // // //               const SizedBox(width: 16),
// // // //               Expanded(
// // // //                 child: Column(
// // // //                   crossAxisAlignment: CrossAxisAlignment.start,
// // // //                   children: [
// // // //                     Text(
// // // //                       tournament.name,
// // // //                       style: const TextStyle(
// // // //                         fontSize: 16,
// // // //                         fontWeight: FontWeight.bold,
// // // //                       ),
// // // //                     ),
// // // //                     const SizedBox(height: 4),
// // // //                     Text(
// // // //                       '${tournament.teamIds.length} টি টিম',
// // // //                       style: TextStyle(
// // // //                         fontSize: 13,
// // // //                         color: Colors.grey.shade600,
// // // //                       ),
// // // //                     ),
// // // //                     const SizedBox(height: 4),
// // // //                     Text(
// // // //                       '${_dateFormat.format(tournament.startDate)} - ${_dateFormat.format(tournament.endDate)}',
// // // //                       style: TextStyle(
// // // //                         fontSize: 11,
// // // //                         color: Colors.grey.shade500,
// // // //                       ),
// // // //                     ),
// // // //                   ],
// // // //                 ),
// // // //               ),
// // // //               Container(
// // // //                 padding:
// // // //                 const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
// // // //                 decoration: BoxDecoration(
// // // //                   color: statusColor.withOpacity(0.1),
// // // //                   borderRadius: BorderRadius.circular(20),
// // // //                   border: Border.all(color: statusColor),
// // // //                 ),
// // // //                 child: Text(
// // // //                   statusText,
// // // //                   style: TextStyle(
// // // //                     color: statusColor,
// // // //                     fontWeight: FontWeight.bold,
// // // //                     fontSize: 12,
// // // //                   ),
// // // //                 ),
// // // //               ),
// // // //             ],
// // // //           ),
// // // //         ),
// // // //       ),
// // // //     );
// // // //   }
// // // //
// // // //   Widget _buildEmptyState({
// // // //     required IconData icon,
// // // //     required String title,
// // // //     required String subtitle,
// // // //   }) {
// // // //     return Center(
// // // //       child: Column(
// // // //         mainAxisAlignment: MainAxisAlignment.center,
// // // //         children: [
// // // //           Icon(icon, size: 80, color: Colors.grey.shade300),
// // // //           const SizedBox(height: 16),
// // // //           Text(
// // // //             title,
// // // //             style: const TextStyle(
// // // //               fontSize: 20,
// // // //               fontWeight: FontWeight.bold,
// // // //               color: Colors.grey,
// // // //             ),
// // // //           ),
// // // //           const SizedBox(height: 8),
// // // //           Text(
// // // //             subtitle,
// // // //             style: TextStyle(color: Colors.grey.shade500),
// // // //             textAlign: TextAlign.center,
// // // //           ),
// // // //         ],
// // // //       ),
// // // //     );
// // // //   }
// // // // }
// // //
// // //
// // //
// // //
// // //
// // // import 'package:flutter/material.dart';
// // // import 'package:provider/provider.dart';
// // // import 'package:intl/intl.dart';
// // //
// // // import '../../providers/auth_provider.dart';
// // // import '../../providers/match_provider.dart';
// // // import '../../providers/tournament_provider.dart';
// // // import '../../models/match_model.dart';
// // // import '../../models/tournament_model.dart';
// // //
// // // import '../auth/admin_login_screen.dart';
// // // import '../match/match_detail_screen.dart';
// // // import '../match/create_single_match_screen.dart';
// // // import '../tournament/create_tournament_screen.dart';
// // // import '../tournament/tournament_detail_screen.dart';
// // //
// // // class AdminHomeScreen extends StatefulWidget {
// // //   const AdminHomeScreen({Key? key}) : super(key: key);
// // //
// // //   @override
// // //   State<AdminHomeScreen> createState() => _AdminHomeScreenState();
// // // }
// // //
// // // class _AdminHomeScreenState extends State<AdminHomeScreen> {
// // //   int _selectedIndex = 0;
// // //   final DateFormat _dateFormat = DateFormat('dd MMM yyyy');
// // //
// // //   @override
// // //   void initState() {
// // //     super.initState();
// // //     // স্ক্রিন লোড হওয়ার পর ডেটা রিফ্রেশ করা
// // //     WidgetsBinding.instance.addPostFrameCallback((_) => _loadData());
// // //   }
// // //
// // //   Future<void> _loadData() async {
// // //     final authProvider = Provider.of<AuthProvider>(context, listen: false);
// // //     final matchProvider = Provider.of<MatchProvider>(context, listen: false);
// // //     final tournamentProvider = Provider.of<TournamentProvider>(context, listen: false);
// // //
// // //     // অ্যাডমিন নাম চেক করা (ফিল্টার করার জন্য ব্যবহৃত হচ্ছে)
// // //     String adminFullName = authProvider.currentAdmin?.fullName ?? '';
// // //
// // //     if (adminFullName.isEmpty) return;
// // //
// // //     await Future.wait([
// // //       matchProvider.loadMatchesByAdmin(adminFullName),
// // //       matchProvider.loadTeams(),
// // //       tournamentProvider.loadTournamentsByAdmin(adminFullName),
// // //     ]);
// // //   }
// // //
// // //   @override
// // //   Widget build(BuildContext context) {
// // //     // Role-Based Security: যদি অ্যাডমিন লগইন না থাকে তবে এই স্ক্রিন দেখাবে না
// // //     return Consumer<AuthProvider>(
// // //       builder: (context, authProvider, child) {
// // //         if (authProvider.currentAdmin == null) {
// // //           return const AdminLoginScreen();
// // //         }
// // //
// // //         return Scaffold(
// // //           appBar: _selectedIndex == 2 ? null : _buildAppBar(),
// // //           body: IndexedStack(
// // //             index: _selectedIndex,
// // //             children: [
// // //               _buildMatchesTab(),
// // //               _buildTournamentsTab(),
// // //               _buildMoreTab(authProvider),
// // //             ],
// // //           ),
// // //           bottomNavigationBar: _buildBottomNavBar(),
// // //           floatingActionButton: _selectedIndex < 2 ? _buildFAB() : null,
// // //         );
// // //       },
// // //     );
// // //   }
// // //   AppBar _buildAppBar() {
// // //     return AppBar(
// // //       title: Text(_selectedIndex == 0 ? 'ম্যাচসমূহ' : 'টুর্নামেন্ট'),
// // //       flexibleSpace: Container(
// // //         decoration: BoxDecoration(
// // //           gradient: LinearGradient(
// // //             colors: [Colors.orange.shade700, Colors.orange.shade900],
// // //           ),
// // //         ),
// // //       ),
// // //       foregroundColor: Colors.white,
// // //       elevation: 0,
// // //       actions: [
// // //         IconButton(
// // //           icon: const Icon(Icons.refresh),
// // //           onPressed: _loadData,
// // //           tooltip: 'রিফ্রেশ',
// // //         ),
// // //       ],
// // //     );
// // //   }
// // //
// // //   Widget _buildBottomNavBar() {
// // //     return Container(
// // //       decoration: BoxDecoration(
// // //         boxShadow: [
// // //           BoxShadow(
// // //             color: Colors.black.withOpacity(0.1),
// // //             blurRadius: 10,
// // //             offset: const Offset(0, -2),
// // //           ),
// // //         ],
// // //       ),
// // //       child: BottomNavigationBar(
// // //         currentIndex: _selectedIndex,
// // //         onTap: (index) => setState(() => _selectedIndex = index),
// // //         selectedItemColor: Colors.orange.shade700,
// // //         unselectedItemColor: Colors.grey,
// // //         selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold),
// // //         type: BottomNavigationBarType.fixed,
// // //         elevation: 0,
// // //         items: const [
// // //           BottomNavigationBarItem(
// // //             icon: Icon(Icons.sports_soccer),
// // //             label: 'ম্যাচ',
// // //           ),
// // //           BottomNavigationBarItem(
// // //             icon: Icon(Icons.emoji_events),
// // //             label: 'টুর্নামেন্ট',
// // //           ),
// // //           BottomNavigationBarItem(
// // //             icon: Icon(Icons.more_horiz),
// // //             label: 'আরও',
// // //           ),
// // //         ],
// // //       ),
// // //     );
// // //   }
// // //
// // //   Widget _buildFAB() {
// // //     return FloatingActionButton.extended(
// // //       onPressed: () {
// // //         if (_selectedIndex == 0) {
// // //           Navigator.push(
// // //             context,
// // //             MaterialPageRoute(
// // //                 builder: (_) => const CreateSingleMatchScreen()),
// // //           ).then((_) => _loadData());
// // //         } else {
// // //           Navigator.push(
// // //             context,
// // //             MaterialPageRoute(builder: (_) => const CreateTournamentScreen()),
// // //           ).then((_) => _loadData());
// // //         }
// // //       },
// // //       backgroundColor: Colors.orange.shade700,
// // //       icon: const Icon(Icons.add, color: Colors.white),
// // //       label: Text(
// // //         _selectedIndex == 0 ? 'নতুন ম্যাচ' : 'নতুন টুর্নামেন্ট',
// // //         style: const TextStyle(
// // //           color: Colors.white,
// // //           fontWeight: FontWeight.bold,
// // //         ),
// // //       ),
// // //     );
// // //   }
// // //
// // //   // ==================== TAB 1: MATCHES ====================
// // //   Widget _buildMatchesTab() {
// // //     return Consumer<MatchProvider>(
// // //       builder: (context, matchProvider, child) {
// // //         if (matchProvider.isLoading) {
// // //           return const Center(child: CircularProgressIndicator());
// // //         }
// // //
// // //         if (matchProvider.matches.isEmpty) {
// // //           return _buildEmptyState(
// // //             icon: Icons.sports_soccer,
// // //             title: 'কোন ম্যাচ নেই',
// // //             subtitle: 'নতুন ম্যাচ তৈরি করতে + বাটনে ক্লিক করুন',
// // //           );
// // //         }
// // //
// // //         return RefreshIndicator(
// // //           onRefresh: _loadData,
// // //           child: ListView.builder(
// // //             padding: const EdgeInsets.all(16),
// // //             itemCount: matchProvider.matches.length,
// // //             itemBuilder: (context, index) =>
// // //                 _buildMatchCard(matchProvider.matches[index]),
// // //           ),
// // //         );
// // //       },
// // //     );
// // //   }
// // //
// // //   // ==================== TAB 2: TOURNAMENTS ====================
// // //   Widget _buildTournamentsTab() {
// // //     return Consumer<TournamentProvider>(
// // //       builder: (context, tournamentProvider, child) {
// // //         if (tournamentProvider.isLoading) {
// // //           return const Center(child: CircularProgressIndicator());
// // //         }
// // //
// // //         if (tournamentProvider.tournaments.isEmpty) {
// // //           return _buildEmptyState(
// // //             icon: Icons.emoji_events,
// // //             title: 'কোন টুর্নামেন্ট নেই',
// // //             subtitle: 'নতুন টুর্নামেন্ট তৈরি করতে + বাটনে ক্লিক করুন',
// // //           );
// // //         }
// // //
// // //         return RefreshIndicator(
// // //           onRefresh: _loadData,
// // //           child: ListView.builder(
// // //             padding: const EdgeInsets.all(16),
// // //             itemCount: tournamentProvider.tournaments.length,
// // //             itemBuilder: (context, index) =>
// // //                 _buildTournamentCard(tournamentProvider.tournaments[index]),
// // //           ),
// // //         );
// // //       },
// // //     );
// // //   }
// // //
// // //   // ==================== TAB 3: MORE (PROFILE) ====================
// // //   Widget _buildMoreTab(AuthProvider authProvider) {
// // //     final admin = authProvider.currentAdmin;
// // //
// // //     return Container(
// // //       decoration: BoxDecoration(
// // //         gradient: LinearGradient(
// // //           begin: Alignment.topCenter,
// // //           end: Alignment.bottomCenter,
// // //           colors: [Colors.orange.shade700, Colors.orange.shade900],
// // //         ),
// // //       ),
// // //       child: SafeArea(
// // //         child: SingleChildScrollView(
// // //           child: Column(
// // //             children: [
// // //               const SizedBox(height: 40),
// // //               // Profile Header
// // //               _buildProfileHeader(admin),
// // //               const SizedBox(height: 20),
// // //               // Menu Cards
// // //               _buildMenuSection(authProvider),
// // //             ],
// // //           ),
// // //         ),
// // //       ),
// // //     );
// // //   }
// // //   Widget _buildProfileHeader(dynamic admin) {
// // //     return Column(
// // //       children: [
// // //         CircleAvatar(
// // //           radius: 60,
// // //           backgroundColor: Colors.white,
// // //           child: Icon(Icons.person, size: 60, color: Colors.orange.shade700),
// // //         ),
// // //         const SizedBox(height: 20),
// // //         Text(
// // //           admin?.fullName ?? 'Admin',
// // //           style: const TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold),
// // //         ),
// // //         const SizedBox(height: 8),
// // //         Chip(
// // //           label: Text(admin?.role?.toUpperCase() ?? 'ADMIN'),
// // //           backgroundColor: Colors.white24,
// // //           labelStyle: const TextStyle(color: Colors.white),
// // //         ),
// // //       ],
// // //     );
// // //   }
// // //
// // //   Widget _buildMenuSection(AuthProvider authProvider) {
// // //     return Container(
// // //       decoration: const BoxDecoration(
// // //         color: Colors.white,
// // //         borderRadius: BorderRadius.only(topLeft: Radius.circular(30), topRight: Radius.circular(30)),
// // //       ),
// // //       child: Column(
// // //         children: [
// // //           const SizedBox(height: 30),
// // //           _buildMenuCard(icon: Icons.person_outline, title: 'প্রোফাইল তথ্য', subtitle: 'আপনার প্রোফাইল দেখুন', color: Colors.blue, onTap: () {}),
// // //           _buildMenuCard(icon: Icons.shield, title: 'টিম ম্যানেজমেন্ট', subtitle: 'টিম পরিচালনা করুন', color: Colors.purple, onTap: () {}),
// // //           const SizedBox(height: 20),
// // //           // Logout Button - Role Based Logout
// // //           Padding(
// // //             padding: const EdgeInsets.symmetric(horizontal: 20),
// // //             child: SizedBox(
// // //               width: double.infinity,
// // //               child: ElevatedButton.icon(
// // //                 onPressed: () => _handleLogout(authProvider),
// // //                 icon: const Icon(Icons.logout),
// // //                 label: const Text('লগআউট', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
// // //                 style: ElevatedButton.styleFrom(
// // //                   backgroundColor: Colors.red,
// // //                   foregroundColor: Colors.white,
// // //                   padding: const EdgeInsets.symmetric(vertical: 16),
// // //                   shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
// // //                 ),
// // //               ),
// // //             ),
// // //           ),
// // //           const SizedBox(height: 40),
// // //         ],
// // //       ),
// // //     );
// // //   }
// // //   Future<void> _handleLogout(AuthProvider authProvider) async {
// // //     final confirmed = await showDialog<bool>(
// // //       context: context,
// // //       builder: (context) => AlertDialog(
// // //         title: const Text('লগআউট নিশ্চিত করুন'),
// // //         content: const Text('আপনি কি লগআউট করতে চান?'),
// // //         actions: [
// // //           TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('না')),
// // //           ElevatedButton(
// // //             onPressed: () => Navigator.pop(context, true),
// // //             style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
// // //             child: const Text('হ্যাঁ'),
// // //           ),
// // //         ],
// // //       ),
// // //     );
// // //
// // //     if (confirmed == true && mounted) {
// // //       await authProvider.logout();
// // //       // এখানে Navigator.push এর প্রয়োজন নেই, AuthWrapper অটোমেটিক AdminLoginScreen-এ নিয়ে যাবে
// // //     }
// // //   }
// // //
// // //   Widget _buildMenuCard({
// // //     required IconData icon,
// // //     required String title,
// // //     required String subtitle,
// // //     required Color color,
// // //     required VoidCallback onTap,
// // //   }) {
// // //     return Container(
// // //       margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
// // //       child: Material(
// // //         color: Colors.transparent,
// // //         child: InkWell(
// // //           onTap: onTap,
// // //           borderRadius: BorderRadius.circular(16),
// // //           child: Container(
// // //             padding: const EdgeInsets.all(16),
// // //             decoration: BoxDecoration(
// // //               color: Colors.white,
// // //               borderRadius: BorderRadius.circular(16),
// // //               border: Border.all(color: Colors.grey.shade200),
// // //               boxShadow: [
// // //                 BoxShadow(
// // //                   color: Colors.black.withOpacity(0.05),
// // //                   blurRadius: 10,
// // //                   offset: const Offset(0, 4),
// // //                 ),
// // //               ],
// // //             ),
// // //             child: Row(
// // //               children: [
// // //                 Container(
// // //                   padding: const EdgeInsets.all(12),
// // //                   decoration: BoxDecoration(
// // //                     color: color.withOpacity(0.1),
// // //                     borderRadius: BorderRadius.circular(12),
// // //                   ),
// // //                   child: Icon(icon, color: color, size: 28),
// // //                 ),
// // //                 const SizedBox(width: 16),
// // //                 Expanded(
// // //                   child: Column(
// // //                     crossAxisAlignment: CrossAxisAlignment.start,
// // //                     children: [
// // //                       Text(
// // //                         title,
// // //                         style: const TextStyle(
// // //                           fontSize: 16,
// // //                           fontWeight: FontWeight.bold,
// // //                           color: Colors.black87,
// // //                         ),
// // //                       ),
// // //                       const SizedBox(height: 4),
// // //                       Text(
// // //                         subtitle,
// // //                         style: TextStyle(
// // //                           fontSize: 13,
// // //                           color: Colors.grey.shade600,
// // //                         ),
// // //                       ),
// // //                     ],
// // //                   ),
// // //                 ),
// // //                 Icon(
// // //                   Icons.arrow_forward_ios,
// // //                   color: Colors.grey.shade400,
// // //                   size: 16,
// // //                 ),
// // //               ],
// // //             ),
// // //           ),
// // //         ),
// // //       ),
// // //     );
// // //   }
// // //
// // //   // ==================== Match Card ====================
// // //   Widget _buildMatchCard(MatchModel match) {
// // //     final statusColor = match.status == 'live'
// // //         ? Colors.green
// // //         : match.status == 'completed'
// // //         ? Colors.grey
// // //         : Colors.orange;
// // //
// // //     return Card(
// // //       margin: const EdgeInsets.only(bottom: 12),
// // //       elevation: 2,
// // //       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
// // //       child: InkWell(
// // //         borderRadius: BorderRadius.circular(16),
// // //         onTap: () {
// // //           Navigator.push(
// // //             context,
// // //             MaterialPageRoute(
// // //                 builder: (_) => MatchDetailScreen(match: match)),
// // //           ).then((_) => _loadData());
// // //         },
// // //         child: Padding(
// // //           padding: const EdgeInsets.all(16),
// // //           child: Column(
// // //             children: [
// // //               // Status Badge
// // //               Row(
// // //                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
// // //                 children: [
// // //                   Container(
// // //                     padding:
// // //                     const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
// // //                     decoration: BoxDecoration(
// // //                       color: statusColor.withOpacity(0.1),
// // //                       borderRadius: BorderRadius.circular(20),
// // //                       border: Border.all(color: statusColor),
// // //                     ),
// // //                     child: Row(
// // //                       mainAxisSize: MainAxisSize.min,
// // //                       children: [
// // //                         if (match.status == 'live')
// // //                           Container(
// // //                             width: 8,
// // //                             height: 8,
// // //                             margin: const EdgeInsets.only(right: 6),
// // //                             decoration: BoxDecoration(
// // //                               color: statusColor,
// // //                               shape: BoxShape.circle,
// // //                             ),
// // //                           ),
// // //                         Text(
// // //                           match.status == 'live'
// // //                               ? 'লাইভ'
// // //                               : match.status == 'completed'
// // //                               ? 'সম্পন্ন'
// // //                               : 'আসন্ন',
// // //                           style: TextStyle(
// // //                             color: statusColor,
// // //                             fontWeight: FontWeight.bold,
// // //                             fontSize: 12,
// // //                           ),
// // //                         ),
// // //                       ],
// // //                     ),
// // //                   ),
// // //                   if (match.tournament != null)
// // //                     Container(
// // //                       padding: const EdgeInsets.symmetric(
// // //                           horizontal: 8, vertical: 4),
// // //                       decoration: BoxDecoration(
// // //                         color: Colors.orange.shade50,
// // //                         borderRadius: BorderRadius.circular(8),
// // //                       ),
// // //                       child: Row(
// // //                         mainAxisSize: MainAxisSize.min,
// // //                         children: [
// // //                           Icon(Icons.emoji_events,
// // //                               size: 14, color: Colors.orange.shade700),
// // //                           const SizedBox(width: 4),
// // //                           Text(
// // //                             match.tournament!,
// // //                             style: TextStyle(
// // //                               fontSize: 11,
// // //                               color: Colors.orange.shade700,
// // //                               fontWeight: FontWeight.bold,
// // //                             ),
// // //                           ),
// // //                         ],
// // //                       ),
// // //                     ),
// // //                 ],
// // //               ),
// // //               const SizedBox(height: 16),
// // //
// // //               // Teams & Score
// // //               Row(
// // //                 children: [
// // //                   _buildTeamColumn(match.teamAName, match.scoreA),
// // //                   Padding(
// // //                     padding: const EdgeInsets.symmetric(horizontal: 16),
// // //                     child: Text(
// // //                       'VS',
// // //                       style: TextStyle(
// // //                         fontSize: 18,
// // //                         fontWeight: FontWeight.bold,
// // //                         color: Colors.grey.shade400,
// // //                       ),
// // //                     ),
// // //                   ),
// // //                   _buildTeamColumn(match.teamBName, match.scoreB),
// // //                 ],
// // //               ),
// // //               const SizedBox(height: 16),
// // //
// // //               // Venue & Date
// // //               Container(
// // //                 padding: const EdgeInsets.all(12),
// // //                 decoration: BoxDecoration(
// // //                   color: Colors.grey.shade50,
// // //                   borderRadius: BorderRadius.circular(12),
// // //                 ),
// // //                 child: Row(
// // //                   mainAxisAlignment: MainAxisAlignment.spaceAround,
// // //                   children: [
// // //                     if (match.venue != null)
// // //                       _infoRow(Icons.location_on, match.venue!),
// // //                     if (match.venue != null)
// // //                       Container(
// // //                           width: 1, height: 20, color: Colors.grey.shade300),
// // //                     _infoRow(Icons.calendar_today,
// // //                         _dateFormat.format(match.date)),
// // //                   ],
// // //                 ),
// // //               ),
// // //             ],
// // //           ),
// // //         ),
// // //       ),
// // //     );
// // //   }
// // //
// // //   Widget _buildTeamColumn(String teamName, int score) {
// // //     return Expanded(
// // //       child: Column(
// // //         children: [
// // //           _placeholderLogo(),
// // //           const SizedBox(height: 8),
// // //           Text(
// // //             teamName,
// // //             style: const TextStyle(
// // //               fontWeight: FontWeight.bold,
// // //               fontSize: 13,
// // //             ),
// // //             textAlign: TextAlign.center,
// // //             maxLines: 2,
// // //             overflow: TextOverflow.ellipsis,
// // //           ),
// // //           const SizedBox(height: 8),
// // //           Text(
// // //             '$score',
// // //             style: TextStyle(
// // //               fontSize: 28,
// // //               fontWeight: FontWeight.bold,
// // //               color: Colors.orange.shade700,
// // //             ),
// // //           ),
// // //         ],
// // //       ),
// // //     );
// // //   }
// // //
// // //   Widget _placeholderLogo() {
// // //     return Container(
// // //       width: 56,
// // //       height: 56,
// // //       decoration: BoxDecoration(
// // //         color: Colors.grey.shade200,
// // //         borderRadius: BorderRadius.circular(8),
// // //       ),
// // //       child: Icon(Icons.shield, color: Colors.grey.shade400, size: 32),
// // //     );
// // //   }
// // //
// // //   Widget _infoRow(IconData icon, String text) {
// // //     return Row(
// // //       mainAxisSize: MainAxisSize.min,
// // //       children: [
// // //         Icon(icon, size: 16, color: Colors.grey.shade600),
// // //         const SizedBox(width: 6),
// // //         Flexible(
// // //           child: Text(
// // //             text,
// // //             style: TextStyle(
// // //               fontSize: 12,
// // //               color: Colors.grey.shade700,
// // //               fontWeight: FontWeight.w500,
// // //             ),
// // //             overflow: TextOverflow.ellipsis,
// // //           ),
// // //         ),
// // //       ],
// // //     );
// // //   }
// // //
// // //   // ==================== Tournament Card ====================
// // //   Widget _buildTournamentCard(TournamentModel tournament) {
// // //     // ✅ FIXED: completed → finished
// // //     final statusColor = tournament.status == 'ongoing'
// // //         ? Colors.green
// // //         : tournament.status == 'finished'
// // //         ? Colors.grey
// // //         : Colors.orange;
// // //
// // //     final statusText = tournament.status == 'ongoing'
// // //         ? 'চলমান'
// // //         : tournament.status == 'finished'
// // //         ? 'সম্পন্ন'
// // //         : 'আসন্ন';
// // //
// // //     return Card(
// // //       margin: const EdgeInsets.only(bottom: 12),
// // //       elevation: 2,
// // //       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
// // //       child: InkWell(
// // //         borderRadius: BorderRadius.circular(16),
// // //         onTap: () {
// // //           // ✅ FIXED: Navigation enabled
// // //           Navigator.push(
// // //             context,
// // //             MaterialPageRoute(
// // //                 builder: (_) =>
// // //                     TournamentDetailScreen(tournament: tournament)),
// // //           ).then((_) => _loadData());
// // //         },
// // //         child: Padding(
// // //           padding: const EdgeInsets.all(16),
// // //           child: Row(
// // //             children: [
// // //               Container(
// // //                 padding: const EdgeInsets.all(12),
// // //                 decoration: BoxDecoration(
// // //                   color: statusColor.withOpacity(0.1),
// // //                   borderRadius: BorderRadius.circular(12),
// // //                 ),
// // //                 child: Icon(Icons.emoji_events, color: statusColor, size: 32),
// // //               ),
// // //               const SizedBox(width: 16),
// // //               Expanded(
// // //                 child: Column(
// // //                   crossAxisAlignment: CrossAxisAlignment.start,
// // //                   children: [
// // //                     Text(
// // //                       tournament.name,
// // //                       style: const TextStyle(
// // //                         fontSize: 16,
// // //                         fontWeight: FontWeight.bold,
// // //                       ),
// // //                     ),
// // //                     const SizedBox(height: 4),
// // //                     Text(
// // //                       '${tournament.teamIds.length} টি টিম',
// // //                       style: TextStyle(
// // //                         fontSize: 13,
// // //                         color: Colors.grey.shade600,
// // //                       ),
// // //                     ),
// // //                     const SizedBox(height: 4),
// // //                     Text(
// // //                       '${_dateFormat.format(tournament.startDate)} - ${_dateFormat.format(tournament.endDate)}',
// // //                       style: TextStyle(
// // //                         fontSize: 11,
// // //                         color: Colors.grey.shade500,
// // //                       ),
// // //                     ),
// // //                   ],
// // //                 ),
// // //               ),
// // //               Container(
// // //                 padding:
// // //                 const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
// // //                 decoration: BoxDecoration(
// // //                   color: statusColor.withOpacity(0.1),
// // //                   borderRadius: BorderRadius.circular(20),
// // //                   border: Border.all(color: statusColor),
// // //                 ),
// // //                 child: Text(
// // //                   statusText,
// // //                   style: TextStyle(
// // //                     color: statusColor,
// // //                     fontWeight: FontWeight.bold,
// // //                     fontSize: 12,
// // //                   ),
// // //                 ),
// // //               ),
// // //             ],
// // //           ),
// // //         ),
// // //       ),
// // //     );
// // //   }
// // //
// // //   Widget _buildEmptyState({
// // //     required IconData icon,
// // //     required String title,
// // //     required String subtitle,
// // //   }) {
// // //     return Center(
// // //       child: Column(
// // //         mainAxisAlignment: MainAxisAlignment.center,
// // //         children: [
// // //           Icon(icon, size: 80, color: Colors.grey.shade300),
// // //           const SizedBox(height: 16),
// // //           Text(
// // //             title,
// // //             style: const TextStyle(
// // //               fontSize: 20,
// // //               fontWeight: FontWeight.bold,
// // //               color: Colors.grey,
// // //             ),
// // //           ),
// // //           const SizedBox(height: 8),
// // //           Text(
// // //             subtitle,
// // //             style: TextStyle(color: Colors.grey.shade500),
// // //             textAlign: TextAlign.center,
// // //           ),
// // //         ],
// // //       ),
// // //     );
// // //   }
// // // }
// // import 'package:flutter/material.dart';
// // import 'package:provider/provider.dart';
// // import 'package:intl/intl.dart';
// //
// // import '../../providers/auth_provider.dart';
// // import '../../providers/match_provider.dart';
// // import '../../providers/tournament_provider.dart';
// // import '../../models/match_model.dart';
// // import '../../models/tournament_model.dart';
// //
// // import '../match/match_detail_screen.dart';
// // import '../match/create_single_match_screen.dart';
// // import '../tournament/create_tournament_screen.dart';
// // import '../tournament/tournament_detail_screen.dart';
// //
// // class AdminHomeScreen extends StatefulWidget {
// //   const AdminHomeScreen({Key? key}) : super(key: key);
// //
// //   @override
// //   State<AdminHomeScreen> createState() => _AdminHomeScreenState();
// // }
// //
// // class _AdminHomeScreenState extends State<AdminHomeScreen> {
// //   int _selectedIndex = 0;
// //   final DateFormat _dateFormat = DateFormat('dd MMM yyyy');
// //
// //   @override
// //   void initState() {
// //     super.initState();
// //     // স্ক্রিন লোড হওয়ার পর ডেটা রিফ্রেশ করা
// //     WidgetsBinding.instance.addPostFrameCallback((_) => _loadData());
// //   }
// //
// //   Future<void> _loadData() async {
// //     final authProvider = Provider.of<AuthProvider>(context, listen: false);
// //     final matchProvider = Provider.of<MatchProvider>(context, listen: false);
// //     final tournamentProvider = Provider.of<TournamentProvider>(context, listen: false);
// //
// //     // অ্যাডমিন নাম চেক করা (ফিল্টার করার জন্য ব্যবহৃত হচ্ছে)
// //     String adminFullName = authProvider.currentAdmin?.fullName ?? '';
// //
// //     if (adminFullName.isEmpty) return;
// //
// //     await Future.wait([
// //       matchProvider.loadMatchesByAdmin(adminFullName),
// //       matchProvider.loadTeams(),
// //       tournamentProvider.loadTournamentsByAdmin(adminFullName),
// //     ]);
// //   }
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       appBar: _selectedIndex == 2 ? null : _buildAppBar(),
// //       body: IndexedStack(
// //         index: _selectedIndex,
// //         children: [
// //           _buildMatchesTab(),
// //           _buildTournamentsTab(),
// //           _buildMoreTab(),
// //         ],
// //       ),
// //       bottomNavigationBar: _buildBottomNavBar(),
// //       floatingActionButton: _selectedIndex < 2 ? _buildFAB() : null,
// //     );
// //   }
// //
// //   AppBar _buildAppBar() {
// //     return AppBar(
// //       title: Text(_selectedIndex == 0 ? 'ম্যাচসমূহ' : 'টুর্নামেন্ট'),
// //       flexibleSpace: Container(
// //         decoration: BoxDecoration(
// //           gradient: LinearGradient(
// //             colors: [Colors.orange.shade700, Colors.orange.shade900],
// //           ),
// //         ),
// //       ),
// //       foregroundColor: Colors.white,
// //       elevation: 0,
// //       actions: [
// //         IconButton(
// //           icon: const Icon(Icons.refresh),
// //           onPressed: _loadData,
// //           tooltip: 'রিফ্রেশ',
// //         ),
// //       ],
// //     );
// //   }
// //
// //   Widget _buildBottomNavBar() {
// //     return Container(
// //       decoration: BoxDecoration(
// //         boxShadow: [
// //           BoxShadow(
// //             color: Colors.black.withOpacity(0.1),
// //             blurRadius: 10,
// //             offset: const Offset(0, -2),
// //           ),
// //         ],
// //       ),
// //       child: BottomNavigationBar(
// //         currentIndex: _selectedIndex,
// //         onTap: (index) => setState(() => _selectedIndex = index),
// //         selectedItemColor: Colors.orange.shade700,
// //         unselectedItemColor: Colors.grey,
// //         selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold),
// //         type: BottomNavigationBarType.fixed,
// //         elevation: 0,
// //         items: const [
// //           BottomNavigationBarItem(icon: Icon(Icons.sports_soccer), label: 'ম্যাচ'),
// //           BottomNavigationBarItem(icon: Icon(Icons.emoji_events), label: 'টুর্নামেন্ট'),
// //           BottomNavigationBarItem(icon: Icon(Icons.more_horiz), label: 'আরও'),
// //         ],
// //       ),
// //     );
// //   }
// //
// //   Widget _buildFAB() {
// //     return FloatingActionButton.extended(
// //       onPressed: () {
// //         if (_selectedIndex == 0) {
// //           Navigator.push(
// //             context,
// //             MaterialPageRoute(builder: (_) => const CreateSingleMatchScreen()),
// //           ).then((_) => _loadData());
// //         } else {
// //           Navigator.push(
// //             context,
// //             MaterialPageRoute(builder: (_) => const CreateTournamentScreen()),
// //           ).then((_) => _loadData());
// //         }
// //       },
// //       backgroundColor: Colors.orange.shade700,
// //       icon: const Icon(Icons.add, color: Colors.white),
// //       label: Text(
// //         _selectedIndex == 0 ? 'নতুন ম্যাচ' : 'নতুন টুর্নামেন্ট',
// //         style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
// //       ),
// //     );
// //   }
// //
// //   // ==================== TAB 1: MATCHES ====================
// //   Widget _buildMatchesTab() {
// //     return Consumer<MatchProvider>(
// //       builder: (context, matchProvider, child) {
// //         if (matchProvider.isLoading) {
// //           return const Center(child: CircularProgressIndicator());
// //         }
// //         if (matchProvider.matches.isEmpty) {
// //           return _buildEmptyState(icon: Icons.sports_soccer, title: 'কোন ম্যাচ নেই', subtitle: 'নতুন ম্যাচ তৈরি করতে + বাটনে ক্লিক করুন');
// //         }
// //         return RefreshIndicator(
// //           onRefresh: _loadData,
// //           child: ListView.builder(
// //             padding: const EdgeInsets.all(16),
// //             itemCount: matchProvider.matches.length,
// //             itemBuilder: (context, index) => _buildMatchCard(matchProvider.matches[index]),
// //           ),
// //         );
// //       },
// //     );
// //   }
// //
// //   // ==================== TAB 2: TOURNAMENTS ====================
// //   Widget _buildTournamentsTab() {
// //     return Consumer<TournamentProvider>(
// //       builder: (context, tournamentProvider, child) {
// //         if (tournamentProvider.isLoading) {
// //           return const Center(child: CircularProgressIndicator());
// //         }
// //         if (tournamentProvider.tournaments.isEmpty) {
// //           return _buildEmptyState(icon: Icons.emoji_events, title: 'কোন টুর্নামেন্ট নেই', subtitle: 'নতুন টুর্নামেন্ট তৈরি করতে + বাটনে ক্লিক করুন');
// //         }
// //         return RefreshIndicator(
// //           onRefresh: _loadData,
// //           child: ListView.builder(
// //             padding: const EdgeInsets.all(16),
// //             itemCount: tournamentProvider.tournaments.length,
// //             itemBuilder: (context, index) => _buildTournamentCard(tournamentProvider.tournaments[index]),
// //           ),
// //         );
// //       },
// //     );
// //   }
// //
// //   // ==================== TAB 3: MORE (PROFILE) ====================
// //   Widget _buildMoreTab() {
// //     return Consumer<AuthProvider>(
// //       builder: (context, authProvider, child) {
// //         final admin = authProvider.currentAdmin;
// //
// //         return Container(
// //           decoration: BoxDecoration(
// //             gradient: LinearGradient(
// //               begin: Alignment.topCenter,
// //               end: Alignment.bottomCenter,
// //               colors: [Colors.orange.shade700, Colors.orange.shade900],
// //             ),
// //           ),
// //           child: SafeArea(
// //             child: SingleChildScrollView(
// //               child: Column(
// //                 children: [
// //                   const SizedBox(height: 40),
// //                   // Profile Header
// //                   Column(
// //                     children: [
// //                       Container(
// //                         padding: const EdgeInsets.all(4),
// //                         decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: Colors.white, width: 3)),
// //                         child: CircleAvatar(
// //                           radius: 60,
// //                           backgroundColor: Colors.white,
// //                           child: Icon(Icons.person, size: 60, color: Colors.orange.shade700),
// //                         ),
// //                       ),
// //                       const SizedBox(height: 20),
// //                       Text(admin?.fullName ?? 'Admin', style: const TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold)),
// //                       const SizedBox(height: 8),
// //                       Container(
// //                         padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
// //                         decoration: BoxDecoration(color: Colors.white.withOpacity(0.2), borderRadius: BorderRadius.circular(20)),
// //                         child: Text(
// //                           admin?.role == 'admin' ? 'সুপার অ্যাডমিন' : 'টুর্নামেন্ট অ্যাডমিন',
// //                           style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w600),
// //                         ),
// //                       ),
// //                     ],
// //                   ),
// //                   const SizedBox(height: 20),
// //                   // Menu Section
// //                   Container(
// //                     decoration: const BoxDecoration(
// //                       color: Colors.white,
// //                       borderRadius: BorderRadius.only(topLeft: Radius.circular(30), topRight: Radius.circular(30)),
// //                     ),
// //                     child: Column(
// //                       children: [
// //                         const SizedBox(height: 30),
// //                         _buildMenuCard(icon: Icons.person_outline, title: 'প্রোফাইল তথ্য', subtitle: 'আপনার প্রোফাইল দেখুন', color: Colors.blue, onTap: () {}),
// //                         _buildMenuCard(
// //                           icon: Icons.sports_soccer,
// //                           title: 'মোট ম্যাচ',
// //                           subtitle: '${context.read<MatchProvider>().matches.length} টি',
// //                           color: Colors.green,
// //                           onTap: () => setState(() => _selectedIndex = 0),
// //                         ),
// //                         _buildMenuCard(
// //                           icon: Icons.emoji_events,
// //                           title: 'মোট টুর্নামেন্ট',
// //                           subtitle: '${context.read<TournamentProvider>().tournaments.length} টি',
// //                           color: Colors.orange,
// //                           onTap: () => setState(() => _selectedIndex = 1),
// //                         ),
// //                         _buildMenuCard(icon: Icons.shield, title: 'টিম ম্যানেজমেন্ট', subtitle: 'টিম যোগ ও পরিচালনা করুন', color: Colors.purple, onTap: () {}),
// //                         const SizedBox(height: 20),
// //                         // Logout Button
// //                         Padding(
// //                           padding: const EdgeInsets.symmetric(horizontal: 20),
// //                           child: SizedBox(
// //                             width: double.infinity,
// //                             child: ElevatedButton.icon(
// //                               onPressed: () async {
// //                                 bool? confirmed = await _showLogoutDialog();
// //                                 if (confirmed == true && mounted) {
// //                                   await authProvider.logout();
// //                                   // AuthWrapper handles navigation
// //                                 }
// //                               },
// //                               icon: const Icon(Icons.logout),
// //                               label: const Text('লগআউট', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
// //                               style: ElevatedButton.styleFrom(
// //                                 backgroundColor: Colors.red,
// //                                 foregroundColor: Colors.white,
// //                                 padding: const EdgeInsets.symmetric(vertical: 16),
// //                                 shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
// //                               ),
// //                             ),
// //                           ),
// //                         ),
// //                         const SizedBox(height: 40),
// //                       ],
// //                     ),
// //                   ),
// //                 ],
// //               ),
// //             ),
// //           ),
// //         );
// //       },
// //     );
// //   }
// //
// //   // ==================== UI HELPERS ====================
// //
// //   Future<bool?> _showLogoutDialog() {
// //     return showDialog<bool>(
// //       context: context,
// //       builder: (context) => AlertDialog(
// //         title: const Text('লগআউট'),
// //         content: const Text('আপনি কি বের হয়ে যেতে চান?'),
// //         actions: [
// //           TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('না')),
// //           ElevatedButton(
// //             onPressed: () => Navigator.pop(context, true),
// //             style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
// //             child: const Text('হ্যাঁ'),
// //           ),
// //         ],
// //       ),
// //     );
// //   }
// //
// //   Widget _buildMenuCard({required IconData icon, required String title, required String subtitle, required Color color, required VoidCallback onTap}) {
// //     return Container(
// //       margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
// //       child: InkWell(
// //         onTap: onTap,
// //         borderRadius: BorderRadius.circular(16),
// //         child: Container(
// //           padding: const EdgeInsets.all(16),
// //           decoration: BoxDecoration(
// //             color: Colors.white,
// //             borderRadius: BorderRadius.circular(16),
// //             border: Border.all(color: Colors.grey.shade200),
// //           ),
// //           child: Row(
// //             children: [
// //               Container(
// //                 padding: const EdgeInsets.all(12),
// //                 decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(12)),
// //                 child: Icon(icon, color: color, size: 28),
// //               ),
// //               const SizedBox(width: 16),
// //               Expanded(
// //                 child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
// //                   Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
// //                   Text(subtitle, style: TextStyle(fontSize: 13, color: Colors.grey.shade600)),
// //                 ]),
// //               ),
// //               const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
// //             ],
// //           ),
// //         ),
// //       ),
// //     );
// //   }
// //
// //   Widget _buildMatchCard(MatchModel match) {
// //     final statusColor = match.status == 'live' ? Colors.green : match.status == 'completed' ? Colors.grey : Colors.orange;
// //     return Card(
// //       margin: const EdgeInsets.only(bottom: 12),
// //       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
// //       child: InkWell(
// //         onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => MatchDetailScreen(match: match))).then((_) => _loadData()),
// //         child: Padding(
// //           padding: const EdgeInsets.all(16),
// //           child: Column(
// //             children: [
// //               Row(
// //                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
// //                 children: [
// //                   Text(match.status == 'live' ? '• লাইভ' : match.status == 'finished' ? 'সম্পন্ন' : 'আসন্ন', style: TextStyle(color: statusColor, fontWeight: FontWeight.bold)),
// //                   if (match.tournament != null) Chip(label: Text(match.tournament!, style: const TextStyle(fontSize: 10)), backgroundColor: Colors.orange.shade50),
// //                 ],
// //               ),
// //               const SizedBox(height: 10),
// //               Row(
// //                 children: [
// //                   Expanded(child: Text(match.teamAName, textAlign: TextAlign.center, style: const TextStyle(fontWeight: FontWeight.bold))),
// //                   Text('${match.scoreA} - ${match.scoreB}', style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
// //                   Expanded(child: Text(match.teamBName, textAlign: TextAlign.center, style: const TextStyle(fontWeight: FontWeight.bold))),
// //                 ],
// //               ),
// //               const Divider(),
// //               Text('${_dateFormat.format(match.date)} | ${match.venue ?? "No Venue"}', style: const TextStyle(fontSize: 12, color: Colors.grey)),
// //             ],
// //           ),
// //         ),
// //       ),
// //     );
// //   }
// //
// //   Widget _buildTournamentCard(TournamentModel tournament) {
// //     return Card(
// //       margin: const EdgeInsets.only(bottom: 12),
// //       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
// //       child: ListTile(
// //         leading: const Icon(Icons.emoji_events, color: Colors.orange, size: 40),
// //         title: Text(tournament.name, style: const TextStyle(fontWeight: FontWeight.bold)),
// //         subtitle: Text('${tournament.teamIds.length} টি টিম | ${tournament.status}'),
// //         trailing: const Icon(Icons.arrow_forward_ios, size: 16),
// //         onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => TournamentDetailScreen(tournament: tournament))).then((_) => _loadData()),
// //       ),
// //     );
// //   }
// //
// //   Widget _buildEmptyState({required IconData icon, required String title, required String subtitle}) {
// //     return Center(
// //       child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
// //         Icon(icon, size: 80, color: Colors.grey.shade300),
// //         Text(title, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.grey)),
// //         Text(subtitle, style: TextStyle(color: Colors.grey.shade500)),
// //       ]),
// //     );
// //   }
// // }
//
//
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:intl/intl.dart';
//
// import '../../providers/auth_provider.dart';
// import '../../providers/match_provider.dart';
// import '../../providers/tournament_provider.dart';
// import '../../models/match_model.dart';
// import '../../models/tournament_model.dart';
//
// import '../match/match_detail_screen.dart';
// import '../match/create_single_match_screen.dart';
// import '../tournament/create_tournament_screen.dart';
// import '../tournament/tournament_detail_screen.dart';
//
// class AdminHomeScreen extends StatefulWidget {
//   const AdminHomeScreen({Key? key}) : super(key: key);
//
//   @override
//   State<AdminHomeScreen> createState() => _AdminHomeScreenState();
// }
//
// class _AdminHomeScreenState extends State<AdminHomeScreen> {
//   int _selectedIndex = 0;
//   final DateFormat _dateFormat = DateFormat('dd MMM yyyy');
//   final DateFormat _timeFormat = DateFormat('hh:mm a');
//
//   @override
//   void initState() {
//     super.initState();
//     WidgetsBinding.instance.addPostFrameCallback((_) => _loadData());
//   }
//
//   Future<void> _loadData() async {
//     final authProvider = Provider.of<AuthProvider>(context, listen: false);
//     final matchProvider = Provider.of<MatchProvider>(context, listen: false);
//     final tournamentProvider = Provider.of<TournamentProvider>(context, listen: false);
//
//     String adminFullName = authProvider.currentAdmin?.fullName ?? '';
//
//     if (adminFullName.isEmpty) return;
//
//     await Future.wait([
//       matchProvider.loadMatchesByAdmin(adminFullName),
//       matchProvider.loadTeams(),
//       tournamentProvider.loadTournamentsByAdmin(adminFullName),
//     ]);
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.grey[50],
//       appBar: _selectedIndex == 2 ? null : _buildAppBar(),
//       body: IndexedStack(
//         index: _selectedIndex,
//         children: [
//           _buildMatchesTab(),
//           _buildTournamentsTab(),
//           _buildMoreTab(),
//         ],
//       ),
//       bottomNavigationBar: _buildBottomNavBar(),
//       floatingActionButton: _selectedIndex < 2 ? _buildFAB() : null,
//     );
//   }
//
//   AppBar _buildAppBar() {
//     return AppBar(
//       title: Text(
//         _selectedIndex == 0 ? 'ম্যাচসমূহ' : 'টুর্নামেন্ট',
//         style: const TextStyle(fontWeight: FontWeight.w600),
//       ),
//       backgroundColor: Colors.white,
//       foregroundColor: Colors.grey[900],
//       elevation: 0,
//       bottom: PreferredSize(
//         preferredSize: const Size.fromHeight(1),
//         child: Container(
//           color: Colors.grey[200],
//           height: 1,
//         ),
//       ),
//       actions: [
//         IconButton(
//           icon: const Icon(Icons.refresh_rounded),
//           onPressed: _loadData,
//           tooltip: 'রিফ্রেশ',
//         ),
//         const SizedBox(width: 8),
//       ],
//     );
//   }
//
//   Widget _buildBottomNavBar() {
//     return Container(
//       decoration: BoxDecoration(
//         color: Colors.white,
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.05),
//             blurRadius: 20,
//             offset: const Offset(0, -5),
//           ),
//         ],
//       ),
//       child: SafeArea(
//         child: Padding(
//           padding: const EdgeInsets.symmetric(vertical: 8),
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.spaceAround,
//             children: [
//               _buildNavItem(0, Icons.sports_soccer_rounded, 'ম্যাচ'),
//               _buildNavItem(1, Icons.emoji_events_rounded, 'টুর্নামেন্ট'),
//               _buildNavItem(2, Icons.person_rounded, 'প্রোফাইল'),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget _buildNavItem(int index, IconData icon, String label) {
//     final isSelected = _selectedIndex == index;
//     return InkWell(
//       onTap: () => setState(() => _selectedIndex = index),
//       borderRadius: BorderRadius.circular(12),
//       child: Container(
//         padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
//         decoration: BoxDecoration(
//           color: isSelected ? Colors.orange.shade50 : Colors.transparent,
//           borderRadius: BorderRadius.circular(12),
//         ),
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             Icon(
//               icon,
//               color: isSelected ? Colors.orange.shade700 : Colors.grey[400],
//               size: 26,
//             ),
//             const SizedBox(height: 4),
//             Text(
//               label,
//               style: TextStyle(
//                 fontSize: 12,
//                 fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
//                 color: isSelected ? Colors.orange.shade700 : Colors.grey[600],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _buildFAB() {
//     return Container(
//       decoration: BoxDecoration(
//         borderRadius: BorderRadius.circular(16),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.orange.shade700.withOpacity(0.4),
//             blurRadius: 15,
//             offset: const Offset(0, 5),
//           ),
//         ],
//       ),
//       child: FloatingActionButton.extended(
//         onPressed: () {
//           if (_selectedIndex == 0) {
//             Navigator.push(
//               context,
//               MaterialPageRoute(builder: (_) => const CreateSingleMatchScreen()),
//             ).then((_) => _loadData());
//           } else {
//             Navigator.push(
//               context,
//               MaterialPageRoute(builder: (_) => const CreateTournamentScreen()),
//             ).then((_) => _loadData());
//           }
//         },
//         backgroundColor: Colors.orange.shade700,
//         elevation: 0,
//         icon: const Icon(Icons.add_rounded, color: Colors.white),
//         label: Text(
//           _selectedIndex == 0 ? 'নতুন ম্যাচ' : 'নতুন টুর্নামেন্ট',
//           style: const TextStyle(
//             color: Colors.white,
//             fontWeight: FontWeight.w600,
//             fontSize: 15,
//           ),
//         ),
//       ),
//     );
//   }
//
//   // ==================== TAB 1: MATCHES ====================
//   Widget _buildMatchesTab() {
//     return Consumer<MatchProvider>(
//       builder: (context, matchProvider, child) {
//         if (matchProvider.isLoading) {
//           return Center(
//             child: CircularProgressIndicator(
//               valueColor: AlwaysStoppedAnimation<Color>(Colors.orange.shade700),
//             ),
//           );
//         }
//         if (matchProvider.matches.isEmpty) {
//           return _buildEmptyState(
//             icon: Icons.sports_soccer_rounded,
//             title: 'কোন ম্যাচ নেই',
//             subtitle: 'নতুন ম্যাচ তৈরি করতে + বাটনে ক্লিক করুন',
//           );
//         }
//         return RefreshIndicator(
//           color: Colors.orange.shade700,
//           onRefresh: _loadData,
//           child: ListView.builder(
//             padding: const EdgeInsets.all(16),
//             itemCount: matchProvider.matches.length,
//             itemBuilder: (context, index) => _buildMatchCard(matchProvider.matches[index]),
//           ),
//         );
//       },
//     );
//   }
//
//   // ==================== TAB 2: TOURNAMENTS ====================
//   Widget _buildTournamentsTab() {
//     return Consumer<TournamentProvider>(
//       builder: (context, tournamentProvider, child) {
//         if (tournamentProvider.isLoading) {
//           return Center(
//             child: CircularProgressIndicator(
//               valueColor: AlwaysStoppedAnimation<Color>(Colors.orange.shade700),
//             ),
//           );
//         }
//         if (tournamentProvider.tournaments.isEmpty) {
//           return _buildEmptyState(
//             icon: Icons.emoji_events_rounded,
//             title: 'কোন টুর্নামেন্ট নেই',
//             subtitle: 'নতুন টুর্নামেন্ট তৈরি করতে + বাটনে ক্লিক করুন',
//           );
//         }
//         return RefreshIndicator(
//           color: Colors.orange.shade700,
//           onRefresh: _loadData,
//           child: ListView.builder(
//             padding: const EdgeInsets.all(16),
//             itemCount: tournamentProvider.tournaments.length,
//             itemBuilder: (context, index) => _buildTournamentCard(tournamentProvider.tournaments[index]),
//           ),
//         );
//       },
//     );
//   }
//
//   // ==================== TAB 3: MORE (PROFILE) ====================
//   Widget _buildMoreTab() {
//     return Consumer<AuthProvider>(
//       builder: (context, authProvider, child) {
//         final admin = authProvider.currentAdmin;
//
//         return Container(
//           color: Colors.white,
//           child: SafeArea(
//             child: SingleChildScrollView(
//               child: Column(
//                 children: [
//                   // Profile Header
//                   Container(
//                     width: double.infinity,
//                     padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 20),
//                     decoration: BoxDecoration(
//                       gradient: LinearGradient(
//                         begin: Alignment.topLeft,
//                         end: Alignment.bottomRight,
//                         colors: [Colors.orange.shade600, Colors.orange.shade800],
//                       ),
//                     ),
//                     child: Column(
//                       children: [
//                         Container(
//                           padding: const EdgeInsets.all(4),
//                           decoration: BoxDecoration(
//                             shape: BoxShape.circle,
//                             border: Border.all(color: Colors.white, width: 4),
//                             boxShadow: [
//                               BoxShadow(
//                                 color: Colors.black.withOpacity(0.1),
//                                 blurRadius: 20,
//                                 offset: const Offset(0, 5),
//                               ),
//                             ],
//                           ),
//                           child: CircleAvatar(
//                             radius: 50,
//                             backgroundColor: Colors.white,
//                             child: Text(
//                               (admin?.fullName ?? 'A').substring(0, 1).toUpperCase(),
//                               style: TextStyle(
//                                 fontSize: 36,
//                                 fontWeight: FontWeight.bold,
//                                 color: Colors.orange.shade700,
//                               ),
//                             ),
//                           ),
//                         ),
//                         const SizedBox(height: 16),
//                         Text(
//                           admin?.fullName ?? 'Admin',
//                           style: const TextStyle(
//                             color: Colors.white,
//                             fontSize: 24,
//                             fontWeight: FontWeight.bold,
//                           ),
//                         ),
//                         const SizedBox(height: 8),
//                         Container(
//                           padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
//                           decoration: BoxDecoration(
//                             color: Colors.white.withOpacity(0.25),
//                             borderRadius: BorderRadius.circular(20),
//                           ),
//                           child: Text(
//                             admin?.role == 'admin' ? 'সুপার অ্যাডমিন' : 'টুর্নামেন্ট অ্যাডমিন',
//                             style: const TextStyle(
//                               color: Colors.white,
//                               fontSize: 13,
//                               fontWeight: FontWeight.w600,
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//
//                   // Stats Cards
//                   Padding(
//                     padding: const EdgeInsets.all(20),
//                     child: Row(
//                       children: [
//                         Expanded(
//                           child: _buildStatCard(
//                             icon: Icons.sports_soccer_rounded,
//                             count: context.read<MatchProvider>().matches.length.toString(),
//                             label: 'মোট ম্যাচ',
//                             color: Colors.blue,
//                             onTap: () => setState(() => _selectedIndex = 0),
//                           ),
//                         ),
//                         const SizedBox(width: 12),
//                         Expanded(
//                           child: _buildStatCard(
//                             icon: Icons.emoji_events_rounded,
//                             count: context.read<TournamentProvider>().tournaments.length.toString(),
//                             label: 'টুর্নামেন্ট',
//                             color: Colors.orange,
//                             onTap: () => setState(() => _selectedIndex = 1),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//
//                   // Menu Section
//                   Padding(
//                     padding: const EdgeInsets.symmetric(horizontal: 20),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         const Text(
//                           'মেনু',
//                           style: TextStyle(
//                             fontSize: 18,
//                             fontWeight: FontWeight.bold,
//                             color: Colors.black87,
//                           ),
//                         ),
//                         const SizedBox(height: 16),
//                         _buildModernMenuCard(
//                           icon: Icons.person_outline_rounded,
//                           title: 'প্রোফাইল তথ্য',
//                           subtitle: 'আপনার প্রোফাইল দেখুন',
//                           color: Colors.blue,
//                           onTap: () {},
//                         ),
//                         _buildModernMenuCard(
//                           icon: Icons.shield_rounded,
//                           title: 'টিম ম্যানেজমেন্ট',
//                           subtitle: 'টিম যোগ ও পরিচালনা করুন',
//                           color: Colors.purple,
//                           onTap: () {},
//                         ),
//                         _buildModernMenuCard(
//                           icon: Icons.settings_rounded,
//                           title: 'সেটিংস',
//                           subtitle: 'অ্যাপ কনফিগারেশন',
//                           color: Colors.grey,
//                           onTap: () {},
//                         ),
//                         const SizedBox(height: 20),
//                         // Logout Button
//                         SizedBox(
//                           width: double.infinity,
//                           child: ElevatedButton(
//                             onPressed: () async {
//                               bool? confirmed = await _showLogoutDialog();
//                               if (confirmed == true && mounted) {
//                                 await authProvider.logout();
//                               }
//                             },
//                             style: ElevatedButton.styleFrom(
//                               backgroundColor: Colors.red.shade50,
//                               foregroundColor: Colors.red.shade700,
//                               elevation: 0,
//                               padding: const EdgeInsets.symmetric(vertical: 16),
//                               shape: RoundedRectangleBorder(
//                                 borderRadius: BorderRadius.circular(12),
//                                 side: BorderSide(color: Colors.red.shade200),
//                               ),
//                             ),
//                             child: Row(
//                               mainAxisAlignment: MainAxisAlignment.center,
//                               children: const [
//                                 Icon(Icons.logout_rounded),
//                                 SizedBox(width: 8),
//                                 Text(
//                                   'লগআউট',
//                                   style: TextStyle(
//                                     fontSize: 16,
//                                     fontWeight: FontWeight.w600,
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ),
//                         const SizedBox(height: 40),
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         );
//       },
//     );
//   }
//
//   // ==================== UI HELPERS ====================
//
//   Widget _buildStatCard({
//     required IconData icon,
//     required String count,
//     required String label,
//     required Color color,
//     required VoidCallback onTap,
//   }) {
//     return InkWell(
//       onTap: onTap,
//       borderRadius: BorderRadius.circular(16),
//       child: Container(
//         padding: const EdgeInsets.all(20),
//         decoration: BoxDecoration(
//           color: Colors.white,
//           borderRadius: BorderRadius.circular(16),
//           border: Border.all(color: Colors.grey.shade200),
//           boxShadow: [
//             BoxShadow(
//               color: Colors.black.withOpacity(0.03),
//               blurRadius: 10,
//               offset: const Offset(0, 2),
//             ),
//           ],
//         ),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Container(
//               padding: const EdgeInsets.all(10),
//               decoration: BoxDecoration(
//                 color: color.withOpacity(0.1),
//                 borderRadius: BorderRadius.circular(10),
//               ),
//               child: Icon(icon, color: color, size: 24),
//             ),
//             const SizedBox(height: 12),
//             Text(
//               count,
//               style: const TextStyle(
//                 fontSize: 28,
//                 fontWeight: FontWeight.bold,
//                 color: Colors.black87,
//               ),
//             ),
//             const SizedBox(height: 4),
//             Text(
//               label,
//               style: TextStyle(
//                 fontSize: 13,
//                 color: Colors.grey[600],
//                 fontWeight: FontWeight.w500,
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _buildModernMenuCard({
//     required IconData icon,
//     required String title,
//     required String subtitle,
//     required Color color,
//     required VoidCallback onTap,
//   }) {
//     return Container(
//       margin: const EdgeInsets.only(bottom: 12),
//       child: Material(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(12),
//         child: InkWell(
//           onTap: onTap,
//           borderRadius: BorderRadius.circular(12),
//           child: Container(
//             padding: const EdgeInsets.all(16),
//             decoration: BoxDecoration(
//               border: Border.all(color: Colors.grey.shade200),
//               borderRadius: BorderRadius.circular(12),
//             ),
//             child: Row(
//               children: [
//                 Container(
//                   padding: const EdgeInsets.all(10),
//                   decoration: BoxDecoration(
//                     color: color.withOpacity(0.1),
//                     borderRadius: BorderRadius.circular(10),
//                   ),
//                   child: Icon(icon, color: color, size: 24),
//                 ),
//                 const SizedBox(width: 16),
//                 Expanded(
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(
//                         title,
//                         style: const TextStyle(
//                           fontSize: 15,
//                           fontWeight: FontWeight.w600,
//                           color: Colors.black87,
//                         ),
//                       ),
//                       const SizedBox(height: 2),
//                       Text(
//                         subtitle,
//                         style: TextStyle(
//                           fontSize: 13,
//                           color: Colors.grey[600],
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//                 Icon(Icons.arrow_forward_ios_rounded, size: 16, color: Colors.grey[400]),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget _buildMatchCard(MatchModel match) {
//     final statusColor = match.status == 'live'
//         ? Colors.green
//         : match.status == 'completed'
//         ? Colors.grey
//         : Colors.orange;
//
//     return Container(
//       margin: const EdgeInsets.only(bottom: 12),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(16),
//         border: Border.all(color: Colors.grey.shade200),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.03),
//             blurRadius: 10,
//             offset: const Offset(0, 2),
//           ),
//         ],
//       ),
//       child: Material(
//         color: Colors.transparent,
//         child: InkWell(
//           onTap: () => Navigator.push(
//             context,
//             MaterialPageRoute(builder: (_) => MatchDetailScreen(match: match)),
//           ).then((_) => _loadData()),
//           borderRadius: BorderRadius.circular(16),
//           child: Padding(
//             padding: const EdgeInsets.all(20),
//             child: Column(
//               children: [
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     Container(
//                       padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
//                       decoration: BoxDecoration(
//                         color: statusColor.withOpacity(0.1),
//                         borderRadius: BorderRadius.circular(20),
//                       ),
//                       child: Row(
//                         mainAxisSize: MainAxisSize.min,
//                         children: [
//                           Container(
//                             width: 6,
//                             height: 6,
//                             decoration: BoxDecoration(
//                               color: statusColor,
//                               shape: BoxShape.circle,
//                             ),
//                           ),
//                           const SizedBox(width: 6),
//                           Text(
//                             match.status == 'live'
//                                 ? 'লাইভ'
//                                 : match.status == 'finished'
//                                 ? 'সম্পন্ন'
//                                 : 'আসন্ন',
//                             style: TextStyle(
//                               color: statusColor,
//                               fontWeight: FontWeight.w600,
//                               fontSize: 12,
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                     if (match.tournament != null)
//                       Container(
//                         padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
//                         decoration: BoxDecoration(
//                           color: Colors.orange.shade50,
//                           borderRadius: BorderRadius.circular(20),
//                         ),
//                         child: Text(
//                           match.tournament!,
//                           style: TextStyle(
//                             fontSize: 11,
//                             color: Colors.orange.shade700,
//                             fontWeight: FontWeight.w600,
//                           ),
//                         ),
//                       ),
//                   ],
//                 ),
//                 const SizedBox(height: 20),
//                 Row(
//                   children: [
//                     Expanded(
//                       child: Column(
//                         children: [
//                           Text(
//                             match.teamAName,
//                             textAlign: TextAlign.center,
//                             maxLines: 2,
//                             overflow: TextOverflow.ellipsis,
//                             style: const TextStyle(
//                               fontWeight: FontWeight.w600,
//                               fontSize: 15,
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                     Padding(
//                       padding: const EdgeInsets.symmetric(horizontal: 20),
//                       child: Column(
//                         children: [
//                           Text(
//                             '${match.scoreA} - ${match.scoreB}',
//                             style: const TextStyle(
//                               fontSize: 28,
//                               fontWeight: FontWeight.bold,
//                               color: Colors.black87,
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                     Expanded(
//                       child: Column(
//                         children: [
//                           Text(
//                             match.teamBName,
//                             textAlign: TextAlign.center,
//                             maxLines: 2,
//                             overflow: TextOverflow.ellipsis,
//                             style: const TextStyle(
//                               fontWeight: FontWeight.w600,
//                               fontSize: 15,
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ],
//                 ),
//                 const SizedBox(height: 16),
//                 Container(
//                   padding: const EdgeInsets.symmetric(vertical: 12),
//                   decoration: BoxDecoration(
//                     color: Colors.grey.shade50,
//                     borderRadius: BorderRadius.circular(8),
//                   ),
//                   child: Row(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       Icon(Icons.calendar_today_rounded, size: 14, color: Colors.grey[600]),
//                       const SizedBox(width: 6),
//                       Text(
//                         _dateFormat.format(match.date),
//                         style: TextStyle(
//                           fontSize: 13,
//                           color: Colors.grey[700],
//                           fontWeight: FontWeight.w500,
//                         ),
//                       ),
//                       const SizedBox(width: 16),
//                       Icon(Icons.location_on_rounded, size: 14, color: Colors.grey[600]),
//                       const SizedBox(width: 6),
//                       Text(
//                         match.venue ?? "No Venue",
//                         style: TextStyle(
//                           fontSize: 13,
//                           color: Colors.grey[700],
//                           fontWeight: FontWeight.w500,
//                         ),
//                       ),
//                     ],
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
//   Widget _buildTournamentCard(TournamentModel tournament) {
//     return Container(
//       margin: const EdgeInsets.only(bottom: 12),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(16),
//         border: Border.all(color: Colors.grey.shade200),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.03),
//             blurRadius: 10,
//             offset: const Offset(0, 2),
//           ),
//         ],
//       ),
//       child: Material(
//         color: Colors.transparent,
//         child: InkWell(
//           onTap: () => Navigator.push(
//             context,
//             MaterialPageRoute(builder: (_) => TournamentDetailScreen(tournament: tournament)),
//           ).then((_) => _loadData()),
//           borderRadius: BorderRadius.circular(16),
//           child: Padding(
//             padding: const EdgeInsets.all(20),
//             child: Row(
//               children: [
//                 Container(
//                   padding: const EdgeInsets.all(14),
//                   decoration: BoxDecoration(
//                     color: Colors.orange.shade50,
//                     borderRadius: BorderRadius.circular(12),
//                   ),
//                   child: Icon(
//                     Icons.emoji_events_rounded,
//                     color: Colors.orange.shade700,
//                     size: 28,
//                   ),
//                 ),
//                 const SizedBox(width: 16),
//                 Expanded(
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(
//                         tournament.name,
//                         style: const TextStyle(
//                           fontWeight: FontWeight.w600,
//                           fontSize: 16,
//                           color: Colors.black87,
//                         ),
//                       ),
//                       const SizedBox(height: 6),
//                       Row(
//                         children: [
//                           Icon(Icons.groups_rounded, size: 14, color: Colors.grey[600]),
//                           const SizedBox(width: 4),
//                           Text(
//                             '${tournament.teamIds.length} টি টিম',
//                             style: TextStyle(
//                               fontSize: 13,
//                               color: Colors.grey[600],
//                             ),
//                           ),
//                           const SizedBox(width: 12),
//                           Container(
//                             padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
//                             decoration: BoxDecoration(
//                               color: Colors.blue.shade50,
//                               borderRadius: BorderRadius.circular(8),
//                             ),
//                             child: Text(
//                               tournament.status,
//                               style: TextStyle(
//                                 fontSize: 11,
//                                 color: Colors.blue.shade700,
//                                 fontWeight: FontWeight.w600,
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ],
//                   ),
//                 ),
//                 Icon(Icons.arrow_forward_ios_rounded, size: 16, color: Colors.grey[400]),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget _buildEmptyState({
//     required IconData icon,
//     required String title,
//     required String subtitle,
//   }) {
//     return Center(
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Container(
//             padding: const EdgeInsets.all(30),
//             decoration: BoxDecoration(
//               color: Colors.grey.shade100,
//               shape: BoxShape.circle,
//             ),
//             child: Icon(icon, size: 60, color: Colors.grey.shade400),
//           ),
//           const SizedBox(height: 24),
//           Text(
//             title,
//             style: const TextStyle(
//               fontSize: 20,
//               fontWeight: FontWeight.bold,
//               color: Colors.black87,
//             ),
//           ),
//           const SizedBox(height: 8),
//           Text(
//             subtitle,
//             textAlign: TextAlign.center,
//             style: TextStyle(
//               fontSize: 14,
//               color: Colors.grey.shade600,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Future<bool?> _showLogoutDialog() {
//     return showDialog<bool>(
//       context: context,
//       builder: (context) => AlertDialog(
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
//         title: const Text('লগআউট'),
//         content: const Text('আপনি কি নিশ্চিত যে আপনি বের হয়ে যেতে চান?'),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.pop(context, false),
//             child: Text(
//               'না',
//               style: TextStyle(color: Colors.grey[600]),
//             ),
//           ),
//           ElevatedButton(
//             onPressed: () => Navigator.pop(context, true),
//             style: ElevatedButton.styleFrom(
//               backgroundColor: Colors.red,
//               shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
//             ),
//             child: const Text('হ্যাঁ'),
//           ),
//         ],
//       ),
//     );
//   }
// }