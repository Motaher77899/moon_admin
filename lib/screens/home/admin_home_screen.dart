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
// // // import '../match/match_detail_screen.dart';
// // // import '../match/create_single_match_screen.dart';
// // // import '../tournament/create_tournament_screen.dart';
// // // import '../tournament/tournament_detail_screen.dart';
// // //
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
// // //     WidgetsBinding.instance.addPostFrameCallback((_) => _loadData());
// // //   }
// // //
// // //   Future<void> _loadData() async {
// // //     final authProvider = Provider.of<AuthProvider>(context, listen: false);
// // //     final matchProvider = Provider.of<MatchProvider>(context, listen: false);
// // //     final tournamentProvider = Provider.of<TournamentProvider>(context, listen: false);
// // //
// // //     String adminFullName = authProvider.currentAdmin?.fullName ?? '';
// // //
// // //     if (adminFullName.isEmpty) {
// // //       print('❌ Admin full name not found');
// // //       return;
// // //     }
// // //
// // //     print('🔍 Loading data for admin: $adminFullName');
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
// // //     final authProvider = Provider.of<AuthProvider>(context);
// // //
// // //     return Scaffold(
// // //       appBar: AppBar(
// // //         title: const Text('অ্যাডমিন প্যানেল'),
// // //         flexibleSpace: Container(
// // //           decoration: BoxDecoration(
// // //             gradient: LinearGradient(
// // //               colors: [Colors.blue.shade700, Colors.blue.shade900],
// // //             ),
// // //           ),
// // //         ),
// // //         foregroundColor: Colors.white,
// // //         actions: [
// // //           IconButton(
// // //             icon: const Icon(Icons.refresh),
// // //             onPressed: _loadData,
// // //             tooltip: 'রিফ্রেশ',
// // //           ),
// // //
// // //           // Fixed PopupMenuButton
// // //           PopupMenuButton(
// // //             itemBuilder: (BuildContext context) => <PopupMenuEntry>[
// // //               PopupMenuItem(
// // //                 enabled: false,
// // //                 child: Row(
// // //                   children: [
// // //                     const Icon(Icons.person, size: 20),
// // //                     const SizedBox(width: 8),
// // //                     Text(
// // //                       authProvider.currentAdmin?.fullName ?? 'Admin',
// // //                       style: const TextStyle(fontWeight: FontWeight.w600),
// // //                     ),
// // //                   ],
// // //                 ),
// // //               ),
// // //               const PopupMenuDivider(),
// // //               PopupMenuItem(
// // //                 child: const Row(
// // //                   children: [
// // //                     Icon(Icons.logout, color: Colors.red, size: 20),
// // //                     SizedBox(width: 8),
// // //                     Text('লগআউট', style: TextStyle(color: Colors.red)),
// // //                   ],
// // //                 ),
// // //                 onTap: () async {
// // //                   // UI thread ক্লিয়ার করি যাতে মেনু বন্ধ হয়ে যায়
// // //                   await Future.delayed(const Duration(milliseconds: 100));
// // //                   await authProvider.logout();
// // //                   if (!mounted) return;
// // //                   Navigator.of(context).pushNamedAndRemoveUntil('/login', (route) => false);
// // //                 },
// // //               ),
// // //             ],
// // //           ),
// // //         ],
// // //       ),
// // //
// // //       body: _selectedIndex == 0 ? _buildMatchesTab() : _buildTournamentsTab(),
// // //
// // //       bottomNavigationBar: BottomNavigationBar(
// // //         currentIndex: _selectedIndex,
// // //         onTap: (index) => setState(() => _selectedIndex = index),
// // //         selectedItemColor: Colors.blue.shade700,
// // //         items: const [
// // //           BottomNavigationBarItem(icon: Icon(Icons.sports_soccer), label: 'ম্যাচসমূহ'),
// // //           BottomNavigationBarItem(icon: Icon(Icons.emoji_events), label: 'টুর্নামেন্ট'),
// // //         ],
// // //       ),
// // //
// // //       floatingActionButton: FloatingActionButton.extended(
// // //         onPressed: () {
// // //           if (_selectedIndex == 0) {
// // //             Navigator.push(
// // //               context,
// // //               MaterialPageRoute(builder: (_) => const CreateSingleMatchScreen()),
// // //             ).then((_) => _loadData());
// // //           } else {
// // //             Navigator.push(
// // //               context,
// // //               MaterialPageRoute(builder: (_) => const CreateTournamentScreen()),
// // //             ).then((_) => _loadData());
// // //           }
// // //         },
// // //         backgroundColor: Colors.blue.shade700,
// // //         icon: const Icon(Icons.add, color: Colors.white),
// // //         label: Text(
// // //           _selectedIndex == 0 ? 'নতুন ম্যাচ' : 'নতুন টুর্নামেন্ট',
// // //           style: const TextStyle(color: Colors.white),
// // //         ),
// // //       ),
// // //     );
// // //   }
// // //
// // //   // ==================== Matches Tab ====================
// // //   Widget _buildMatchesTab() {
// // //     return Consumer<MatchProvider>(
// // //       builder: (context, matchProvider, child) {
// // //         if (matchProvider.isLoading) {
// // //           return const Center(child: CircularProgressIndicator());
// // //         }
// // //
// // //         if (matchProvider.matches.isEmpty) {
// // //           return Center(
// // //             child: Column(
// // //               mainAxisAlignment: MainAxisAlignment.center,
// // //               children: [
// // //                 Icon(Icons.sports_soccer, size: 80, color: Colors.grey.shade300),
// // //                 const SizedBox(height: 16),
// // //                 const Text('কোন ম্যাচ নেই', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.grey)),
// // //                 const SizedBox(height: 8),
// // //                 Text('নতুন ম্যাচ তৈরি করতে + বাটনে ক্লিক করুন', style: TextStyle(color: Colors.grey.shade500)),
// // //               ],
// // //             ),
// // //           );
// // //         }
// // //
// // //         return RefreshIndicator(
// // //           onRefresh: _loadData,
// // //           child: ListView.builder(
// // //             padding: const EdgeInsets.all(16),
// // //             itemCount: matchProvider.matches.length,
// // //             itemBuilder: (context, index) => _buildMatchCard(matchProvider.matches[index]),
// // //           ),
// // //         );
// // //       },
// // //     );
// // //   }
// // //
// // //   // ==================== Tournaments Tab ====================
// // //   Widget _buildTournamentsTab() {
// // //     return Consumer<TournamentProvider>(
// // //       builder: (context, tournamentProvider, child) {
// // //         if (tournamentProvider.isLoading) {
// // //           return const Center(child: CircularProgressIndicator());
// // //         }
// // //
// // //         if (tournamentProvider.tournaments.isEmpty) {
// // //           return Center(
// // //             child: Column(
// // //               mainAxisAlignment: MainAxisAlignment.center,
// // //               children: [
// // //                 Icon(Icons.emoji_events, size: 80, color: Colors.grey.shade300),
// // //                 const SizedBox(height: 16),
// // //                 const Text('কোন টুর্নামেন্ট নেই', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.grey)),
// // //                 const SizedBox(height: 8),
// // //                 Text('নতুন টুর্নামেন্ট তৈরি করতে + বাটনে ক্লিক করুন', style: TextStyle(color: Colors.grey.shade500)),
// // //               ],
// // //             ),
// // //           );
// // //         }
// // //
// // //         return RefreshIndicator(
// // //           onRefresh: _loadData,
// // //           child: ListView.builder(
// // //             padding: const EdgeInsets.all(16),
// // //             itemCount: tournamentProvider.tournaments.length,
// // //             itemBuilder: (context, index) => _buildTournamentCard(tournamentProvider.tournaments[index]),
// // //           ),
// // //         );
// // //       },
// // //     );
// // //   }
// // //
// // //   // ==================== Match Card ====================
// // //   Widget _buildMatchCard(MatchModel match) {
// // //     final statusColor = match.status == 'live'
// // //         ? Colors.green
// // //         : match.status == 'completed'
// // //         ? Colors.grey
// // //         : Colors.blue;
// // //
// // //     return Card(
// // //       margin: const EdgeInsets.only(bottom: 12),
// // //       elevation: 2,
// // //       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
// // //       child: InkWell(
// // //         borderRadius: BorderRadius.circular(12),
// // //         onTap: () {
// // //           Navigator.push(
// // //             context,
// // //             MaterialPageRoute(builder: (_) => MatchDetailScreen(match: match)),
// // //           ).then((_) => _loadData());
// // //         },
// // //         child: Padding(
// // //           padding: const EdgeInsets.all(16),
// // //           child: Column(
// // //             children: [
// // //               // Status + Tournament Badge
// // //               Row(
// // //                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
// // //                 children: [
// // //                   Container(
// // //                     padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
// // //                     decoration: BoxDecoration(
// // //                       color: statusColor.withOpacity(0.1),
// // //                       borderRadius: BorderRadius.circular(20),
// // //                       border: Border.all(color: statusColor),
// // //                     ),
// // //                     child: Text(
// // //                       match.status == 'live' ? 'লাইভ' : match.status == 'completed' ? 'সম্পন্ন' : 'আসন্ন',
// // //                       style: TextStyle(color: statusColor, fontWeight: FontWeight.bold, fontSize: 12),
// // //                     ),
// // //                   ),
// // //                   if (match.matchType == 'tournament' && match.tournamentName != null)
// // //                     Container(
// // //                       padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
// // //                       decoration: BoxDecoration(
// // //                         color: Colors.orange.shade50,
// // //                         borderRadius: BorderRadius.circular(8),
// // //                         border: Border.all(color: Colors.orange.shade300),
// // //                       ),
// // //                       child: Row(
// // //                         mainAxisSize: MainAxisSize.min,
// // //                         children: [
// // //                           Icon(Icons.emoji_events, size: 14, color: Colors.orange.shade700),
// // //                           const SizedBox(width: 4),
// // //                           Text(match.tournamentName!, style: TextStyle(fontSize: 11, color: Colors.orange.shade700, fontWeight: FontWeight.bold)),
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
// // //                   _buildTeamColumn(match.teamAName, match.teamALogo, match.teamAScore),
// // //                   const Padding(
// // //                     padding: EdgeInsets.symmetric(horizontal: 16),
// // //                     child: Text('VS', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.grey)),
// // //                   ),
// // //                   _buildTeamColumn(match.teamBName, match.teamBLogo, match.teamBScore),
// // //                 ],
// // //               ),
// // //               const SizedBox(height: 16),
// // //
// // //               // Venue & Date
// // //               Container(
// // //                 padding: const EdgeInsets.all(12),
// // //                 decoration: BoxDecoration(color: Colors.grey.shade50, borderRadius: BorderRadius.circular(8)),
// // //                 child: Row(
// // //                   mainAxisAlignment: MainAxisAlignment.spaceAround,
// // //                   children: [
// // //                     _infoRow(Icons.location_on, match.venue),
// // //                     Container(width: 1, height: 20, color: Colors.grey.shade300),
// // //                     _infoRow(Icons.calendar_today, _dateFormat.format(match.matchDate)),
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
// // //   Widget _buildTeamColumn(String name, String? logoUrl, int score) {
// // //     return Expanded(
// // //       child: Column(
// // //         children: [
// // //           logoUrl != null && logoUrl.isNotEmpty
// // //               ? ClipRRect(
// // //             borderRadius: BorderRadius.circular(8),
// // //             child: Image.network(logoUrl, width: 56, height: 56, fit: BoxFit.cover,
// // //                 errorBuilder: (_, __, ___) => _placeholderLogo()),
// // //           )
// // //               : _placeholderLogo(),
// // //           const SizedBox(height: 8),
// // //           Text(name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13), textAlign: TextAlign.center, maxLines: 2, overflow: TextOverflow.ellipsis),
// // //           const SizedBox(height: 8),
// // //           Text('$score', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.blue.shade700)),
// // //         ],
// // //       ),
// // //     );
// // //   }
// // //
// // //   Widget _placeholderLogo() {
// // //     return Container(
// // //       width: 56,
// // //       height: 56,
// // //       decoration: BoxDecoration(color: Colors.grey.shade200, borderRadius: BorderRadius.circular(8)),
// // //       child: Icon(Icons.shield, color: Colors.grey.shade400, size: 32),
// // //     );
// // //   }
// // //
// // //   Widget _infoRow(IconData icon, String text) {
// // //     return Row(
// // //       children: [
// // //         Icon(icon, size: 16, color: Colors.grey.shade600),
// // //         const SizedBox(width: 6),
// // //         Text(text, style: TextStyle(fontSize: 12, color: Colors.grey.shade700, fontWeight: FontWeight.w500)),
// // //       ],
// // //     );
// // //   }
// // //
// // //   // ==================== Tournament Card ====================
// // //   Widget _buildTournamentCard(TournamentModel tournament) {
// // //     final statusColor = tournament.status == 'ongoing'
// // //         ? Colors.green
// // //         : tournament.status == 'completed'
// // //         ? Colors.grey
// // //         : Colors.orange;
// // //
// // //     final statusText = tournament.status == 'ongoing'
// // //         ? 'চলমান'
// // //         : tournament.status == 'completed'
// // //         ? 'সম্পন্ন'
// // //         : 'আসন্ন';
// // //
// // //     return Card(
// // //       margin: const EdgeInsets.only(bottom: 12),
// // //       elevation: 2,
// // //       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
// // //       child: InkWell(
// // //         borderRadius: BorderRadius.circular(12),
// // //         onTap: () {
// // //           Navigator.push(
// // //             context,
// // //             MaterialPageRoute(builder: (_) => TournamentDetailScreen(tournament: tournament)),
// // //           ).then((_) => _loadData());
// // //         },
// // //         child: Padding(
// // //           padding: const EdgeInsets.all(16),
// // //           child: Row(
// // //             children: [
// // //               Container(
// // //                 padding: const EdgeInsets.all(12),
// // //                 decoration: BoxDecoration(color: statusColor.withOpacity(0.1), borderRadius: BorderRadius.circular(12)),
// // //                 child: Icon(Icons.emoji_events, color: statusColor, size: 32),
// // //               ),
// // //               const SizedBox(width: 16),
// // //               Expanded(
// // //                 child: Column(
// // //                   crossAxisAlignment: CrossAxisAlignment.start,
// // //                   children: [
// // //                     Text(tournament.name, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
// // //                     const SizedBox(height: 4),
// // //                     Text('${tournament.teamIds.length} টি টিম', style: TextStyle(fontSize: 13, color: Colors.grey.shade600)),
// // //                     const SizedBox(height: 4),
// // //                     Text(
// // //                       '${_dateFormat.format(tournament.startDate)} - ${_dateFormat.format(tournament.endDate)}',
// // //                       style: TextStyle(fontSize: 11, color: Colors.grey.shade500),
// // //                     ),
// // //                   ],
// // //                 ),
// // //               ),
// // //               Container(
// // //                 padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
// // //                 decoration: BoxDecoration(
// // //                   color: statusColor.withOpacity(0.1),
// // //                   borderRadius: BorderRadius.circular(20),
// // //                   border: Border.all(color: statusColor),
// // //                 ),
// // //                 child: Text(statusText, style: TextStyle(color: statusColor, fontWeight: FontWeight.bold, fontSize: 12)),
// // //               ),
// // //             ],
// // //           ),
// // //         ),
// // //       ),
// // //     );
// // //   }
// // // }
// //
// // import 'package:admin_football_app/screens/match/match_detail_screen.dart';
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
// // import '../match/AdminMatchDetailScreen.dart';
// //
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
// //     WidgetsBinding.instance.addPostFrameCallback((_) => _loadData());
// //   }
// //
// //   Future<void> _loadData() async {
// //     final authProvider = Provider.of<AuthProvider>(context, listen: false);
// //     final matchProvider = Provider.of<MatchProvider>(context, listen: false);
// //     final tournamentProvider =
// //     Provider.of<TournamentProvider>(context, listen: false);
// //
// //     String adminFullName = authProvider.currentAdmin?.fullName ?? '';
// //
// //     if (adminFullName.isEmpty) {
// //       print('❌ Admin full name not found');
// //       return;
// //     }
// //
// //     print('🔍 Loading data for admin: $adminFullName');
// //
// //     await Future.wait([
// //       matchProvider.fetchMatches(),
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
// //           BottomNavigationBarItem(
// //             icon: Icon(Icons.sports_soccer),
// //             label: 'ম্যাচ',
// //           ),
// //           BottomNavigationBarItem(
// //             icon: Icon(Icons.emoji_events),
// //             label: 'টুর্নামেন্ট',
// //           ),
// //           BottomNavigationBarItem(
// //             icon: Icon(Icons.more_horiz),
// //             label: 'আরও',
// //           ),
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
// //             MaterialPageRoute(
// //                 builder: (_) => const CreateSingleMatchScreen()),
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
// //         style: const TextStyle(
// //           color: Colors.white,
// //           fontWeight: FontWeight.bold,
// //         ),
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
// //
// //         if (matchProvider.matches.isEmpty) {
// //           return _buildEmptyState(
// //             icon: Icons.sports_soccer,
// //             title: 'কোন ম্যাচ নেই',
// //             subtitle: 'নতুন ম্যাচ তৈরি করতে + বাটনে ক্লিক করুন',
// //           );
// //         }
// //
// //         return RefreshIndicator(
// //           onRefresh: _loadData,
// //           child: ListView.builder(
// //             padding: const EdgeInsets.all(16),
// //             itemCount: matchProvider.matches.length,
// //             itemBuilder: (context, index) =>
// //                 _buildMatchCard(matchProvider.matches[index]),
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
// //
// //         if (tournamentProvider.tournaments.isEmpty) {
// //           return _buildEmptyState(
// //             icon: Icons.emoji_events,
// //             title: 'কোন টুর্নামেন্ট নেই',
// //             subtitle: 'নতুন টুর্নামেন্ট তৈরি করতে + বাটনে ক্লিক করুন',
// //           );
// //         }
// //
// //         return RefreshIndicator(
// //           onRefresh: _loadData,
// //           child: ListView.builder(
// //             padding: const EdgeInsets.all(16),
// //             itemCount: tournamentProvider.tournaments.length,
// //             itemBuilder: (context, index) =>
// //                 _buildTournamentCard(tournamentProvider.tournaments[index]),
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
// //               colors: [
// //                 Colors.orange.shade700,
// //                 Colors.orange.shade900,
// //               ],
// //             ),
// //           ),
// //           child: SafeArea(
// //             child: SingleChildScrollView(
// //               child: Column(
// //                 children: [
// //                   const SizedBox(height: 40),
// //                   // Profile Header
// //                   Container(
// //                     padding: const EdgeInsets.all(24),
// //                     child: Column(
// //                       children: [
// //                         Container(
// //                           padding: const EdgeInsets.all(4),
// //                           decoration: BoxDecoration(
// //                             shape: BoxShape.circle,
// //                             border: Border.all(color: Colors.white, width: 3),
// //                             boxShadow: [
// //                               BoxShadow(
// //                                 color: Colors.black.withOpacity(0.2),
// //                                 blurRadius: 20,
// //                                 spreadRadius: 5,
// //                               ),
// //                             ],
// //                           ),
// //                           child: CircleAvatar(
// //                             radius: 60,
// //                             backgroundColor: Colors.white,
// //                             child: Icon(
// //                               Icons.person,
// //                               size: 60,
// //                               color: Colors.orange.shade700,
// //                             ),
// //                           ),
// //                         ),
// //                         const SizedBox(height: 20),
// //                         Text(
// //                           admin?.fullName ?? 'Admin',
// //                           style: const TextStyle(
// //                             color: Colors.white,
// //                             fontSize: 28,
// //                             fontWeight: FontWeight.bold,
// //                           ),
// //                         ),
// //                         const SizedBox(height: 8),
// //                         Container(
// //                           padding: const EdgeInsets.symmetric(
// //                             horizontal: 16,
// //                             vertical: 8,
// //                           ),
// //                           decoration: BoxDecoration(
// //                             color: Colors.white.withOpacity(0.2),
// //                             borderRadius: BorderRadius.circular(20),
// //                           ),
// //                           child: const Text(
// //                             'টুর্নামেন্ট অ্যাডমিন',
// //                             style: TextStyle(
// //                               color: Colors.white,
// //                               fontSize: 14,
// //                               fontWeight: FontWeight.w600,
// //                             ),
// //                           ),
// //                         ),
// //                       ],
// //                     ),
// //                   ),
// //                   const SizedBox(height: 20),
// //                   // Menu Cards
// //                   Container(
// //                     decoration: const BoxDecoration(
// //                       color: Colors.white,
// //                       borderRadius: BorderRadius.only(
// //                         topLeft: Radius.circular(30),
// //                         topRight: Radius.circular(30),
// //                       ),
// //                     ),
// //                     child: Column(
// //                       children: [
// //                         const SizedBox(height: 30),
// //                         _buildMenuCard(
// //                           icon: Icons.person_outline,
// //                           title: 'প্রোফাইল তথ্য',
// //                           subtitle: 'আপনার প্রোফাইল দেখুন',
// //                           color: Colors.blue,
// //                           onTap: () {
// //                             // Navigate to profile details
// //                           },
// //                         ),
// //                         _buildMenuCard(
// //                           icon: Icons.sports_soccer,
// //                           title: 'মোট ম্যাচ',
// //                           subtitle:
// //                           '${context.read<MatchProvider>().matches.length} টি',
// //                           color: Colors.green,
// //                           onTap: () {
// //                             setState(() => _selectedIndex = 0);
// //                           },
// //                         ),
// //                         _buildMenuCard(
// //                           icon: Icons.emoji_events,
// //                           title: 'মোট টুর্নামেন্ট',
// //                           subtitle:
// //                           '${context.read<TournamentProvider>().tournaments.length} টি',
// //                           color: Colors.orange,
// //                           onTap: () {
// //                             setState(() => _selectedIndex = 1);
// //                           },
// //                         ),
// //                         _buildMenuCard(
// //                           icon: Icons.shield,
// //                           title: 'টিম ম্যানেজমেন্ট',
// //                           subtitle: 'টিম যোগ ও পরিচালনা করুন',
// //                           color: Colors.purple,
// //                           onTap: () {
// //                             // Navigate to team management
// //                           },
// //                         ),
// //                         _buildMenuCard(
// //                           icon: Icons.settings,
// //                           title: 'সেটিংস',
// //                           subtitle: 'অ্যাপ সেটিংস',
// //                           color: Colors.grey,
// //                           onTap: () {
// //                             // Navigate to settings
// //                           },
// //                         ),
// //                         const SizedBox(height: 20),
// //                         // Logout Button
// //                         Container(
// //                           margin: const EdgeInsets.symmetric(horizontal: 20),
// //                           width: double.infinity,
// //                           child: ElevatedButton.icon(
// //                             onPressed: () async {
// //                               final confirmed = await showDialog<bool>(
// //                                 context: context,
// //                                 builder: (context) => AlertDialog(
// //                                   title: const Text('লগআউট নিশ্চিত করুন'),
// //                                   content: const Text(
// //                                       'আপনি কি লগআউট করতে চান?'),
// //                                   actions: [
// //                                     TextButton(
// //                                       onPressed: () =>
// //                                           Navigator.pop(context, false),
// //                                       child: const Text('না'),
// //                                     ),
// //                                     ElevatedButton(
// //                                       onPressed: () =>
// //                                           Navigator.pop(context, true),
// //                                       style: ElevatedButton.styleFrom(
// //                                         backgroundColor: Colors.red,
// //                                       ),
// //                                       child: const Text('হ্যাঁ, লগআউট'),
// //                                     ),
// //                                   ],
// //                                 ),
// //                               );
// //
// //                               if (confirmed == true && mounted) {
// //                                 await authProvider.logout();
// //                                 if (!mounted) return;
// //                                 Navigator.of(context).pushNamedAndRemoveUntil(
// //                                     '/login', (route) => false);
// //                               }
// //                             },
// //                             icon: const Icon(Icons.logout),
// //                             label: const Text(
// //                               'লগআউট',
// //                               style: TextStyle(
// //                                 fontSize: 16,
// //                                 fontWeight: FontWeight.bold,
// //                               ),
// //                             ),
// //                             style: ElevatedButton.styleFrom(
// //                               backgroundColor: Colors.red,
// //                               foregroundColor: Colors.white,
// //                               padding: const EdgeInsets.symmetric(vertical: 16),
// //                               shape: RoundedRectangleBorder(
// //                                 borderRadius: BorderRadius.circular(12),
// //                               ),
// //                               elevation: 0,
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
// //   Widget _buildMenuCard({
// //     required IconData icon,
// //     required String title,
// //     required String subtitle,
// //     required Color color,
// //     required VoidCallback onTap,
// //   }) {
// //     return Container(
// //       margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
// //       child: Material(
// //         color: Colors.transparent,
// //         child: InkWell(
// //           onTap: onTap,
// //           borderRadius: BorderRadius.circular(16),
// //           child: Container(
// //             padding: const EdgeInsets.all(16),
// //             decoration: BoxDecoration(
// //               color: Colors.white,
// //               borderRadius: BorderRadius.circular(16),
// //               border: Border.all(color: Colors.grey.shade200),
// //               boxShadow: [
// //                 BoxShadow(
// //                   color: Colors.black.withOpacity(0.05),
// //                   blurRadius: 10,
// //                   offset: const Offset(0, 4),
// //                 ),
// //               ],
// //             ),
// //             child: Row(
// //               children: [
// //                 Container(
// //                   padding: const EdgeInsets.all(12),
// //                   decoration: BoxDecoration(
// //                     color: color.withOpacity(0.1),
// //                     borderRadius: BorderRadius.circular(12),
// //                   ),
// //                   child: Icon(icon, color: color, size: 28),
// //                 ),
// //                 const SizedBox(width: 16),
// //                 Expanded(
// //                   child: Column(
// //                     crossAxisAlignment: CrossAxisAlignment.start,
// //                     children: [
// //                       Text(
// //                         title,
// //                         style: const TextStyle(
// //                           fontSize: 16,
// //                           fontWeight: FontWeight.bold,
// //                           color: Colors.black87,
// //                         ),
// //                       ),
// //                       const SizedBox(height: 4),
// //                       Text(
// //                         subtitle,
// //                         style: TextStyle(
// //                           fontSize: 13,
// //                           color: Colors.grey.shade600,
// //                         ),
// //                       ),
// //                     ],
// //                   ),
// //                 ),
// //                 Icon(
// //                   Icons.arrow_forward_ios,
// //                   color: Colors.grey.shade400,
// //                   size: 16,
// //                 ),
// //               ],
// //             ),
// //           ),
// //         ),
// //       ),
// //     );
// //   }
// //
// //   // ==================== Match Card ====================
// //   Widget _buildMatchCard(MatchModel match) {
// //     final statusColor = match.status == 'live'
// //         ? Colors.green
// //         : match.status == 'finished'
// //         ? Colors.grey
// //         : Colors.blue;
// //
// //     return Card(
// //       margin: const EdgeInsets.only(bottom: 12),
// //       elevation: 2,
// //       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
// //       child: InkWell(
// //         borderRadius: BorderRadius.circular(16),
// //         onTap: () {
// //           Navigator.push(
// //             context,
// //             MaterialPageRoute(
// //                 builder: (_) => MatchDetailScreen(match: match)),
// //           ).then((_) => _loadData());
// //         },
// //         child: Padding(
// //           padding: const EdgeInsets.all(16),
// //           child: Column(
// //             children: [
// //               // Status Badge
// //               Row(
// //                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
// //                 children: [
// //                   Container(
// //                     padding:
// //                     const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
// //                     decoration: BoxDecoration(
// //                       color: statusColor.withOpacity(0.1),
// //                       borderRadius: BorderRadius.circular(20),
// //                       border: Border.all(color: statusColor),
// //                     ),
// //                     child: Row(
// //                       mainAxisSize: MainAxisSize.min,
// //                       children: [
// //                         if (match.status == 'live')
// //                           Container(
// //                             width: 8,
// //                             height: 8,
// //                             margin: const EdgeInsets.only(right: 6),
// //                             decoration: BoxDecoration(
// //                               color: statusColor,
// //                               shape: BoxShape.circle,
// //                             ),
// //                           ),
// //                         Text(
// //                           match.status == 'live'
// //                               ? 'লাইভ'
// //                               : match.status == 'finished'
// //                               ? 'সম্পন্ন'
// //                               : 'আসন্ন',
// //                           style: TextStyle(
// //                             color: statusColor,
// //                             fontWeight: FontWeight.bold,
// //                             fontSize: 12,
// //                           ),
// //                         ),
// //                       ],
// //                     ),
// //                   ),
// //                   if (match.tournament != null)
// //                     Container(
// //                       padding: const EdgeInsets.symmetric(
// //                           horizontal: 8, vertical: 4),
// //                       decoration: BoxDecoration(
// //                         color: Colors.orange.shade50,
// //                         borderRadius: BorderRadius.circular(8),
// //                       ),
// //                       child: Row(
// //                         mainAxisSize: MainAxisSize.min,
// //                         children: [
// //                           Icon(Icons.emoji_events,
// //                               size: 14, color: Colors.orange.shade700),
// //                           const SizedBox(width: 4),
// //                           Text(
// //                             match.tournament!,
// //                             style: TextStyle(
// //                               fontSize: 11,
// //                               color: Colors.orange.shade700,
// //                               fontWeight: FontWeight.bold,
// //                             ),
// //                           ),
// //                         ],
// //                       ),
// //                     ),
// //                 ],
// //               ),
// //               const SizedBox(height: 16),
// //
// //               // Teams & Score
// //               Row(
// //                 children: [
// //                   _buildTeamColumn(match.teamA, null, match.scoreA),
// //                   Padding(
// //                     padding: const EdgeInsets.symmetric(horizontal: 16),
// //                     child: Text(
// //                       'VS',
// //                       style: TextStyle(
// //                         fontSize: 18,
// //                         fontWeight: FontWeight.bold,
// //                         color: Colors.grey.shade400,
// //                       ),
// //                     ),
// //                   ),
// //                   _buildTeamColumn(match.teamB, null, match.scoreB),
// //                 ],
// //               ),
// //               const SizedBox(height: 16),
// //
// //               // Venue & Date
// //               Container(
// //                 padding: const EdgeInsets.all(12),
// //                 decoration: BoxDecoration(
// //                   color: Colors.grey.shade50,
// //                   borderRadius: BorderRadius.circular(12),
// //                 ),
// //                 child: Row(
// //                   mainAxisAlignment: MainAxisAlignment.spaceAround,
// //                   children: [
// //                     if (match.venue != null)
// //                       _infoRow(Icons.location_on, match.venue!),
// //                     if (match.venue != null)
// //                       Container(
// //                           width: 1, height: 20, color: Colors.grey.shade300),
// //                     _infoRow(Icons.calendar_today,
// //                         _dateFormat.format(match.date)),
// //                   ],
// //                 ),
// //               ),
// //             ],
// //           ),
// //         ),
// //       ),
// //     );
// //   }
// //
// //   Widget _buildTeamColumn(String teamId, String? logoUrl, int score) {
// //     final matchProvider = Provider.of<MatchProvider>(context, listen: false);
// //     final team = matchProvider.getTeamById(teamId);
// //
// //     return Expanded(
// //       child: Column(
// //         children: [
// //           // Team Logo with proper null checking
// //           (team?.logoUrl != null && team!.logoUrl!.isNotEmpty)
// //               ? ClipRRect(
// //             borderRadius: BorderRadius.circular(8),
// //             child: Image.network(
// //               team.logoUrl!,  // ✅ Safe now
// //               width: 56,
// //               height: 56,
// //               fit: BoxFit.cover,
// //               errorBuilder: (_, __, ___) => _placeholderLogo(),
// //             ),
// //           )
// //               : _placeholderLogo(),
// //           const SizedBox(height: 8),
// //           // Team Name
// //           Text(
// //             team?.name ?? 'Unknown',
// //             style: const TextStyle(
// //               fontWeight: FontWeight.bold,
// //               fontSize: 13,
// //             ),
// //             textAlign: TextAlign.center,
// //             maxLines: 2,
// //             overflow: TextOverflow.ellipsis,
// //           ),
// //           const SizedBox(height: 8),
// //           // Score
// //           Text(
// //             '$score',
// //             style: TextStyle(
// //               fontSize: 28,
// //               fontWeight: FontWeight.bold,
// //               color: Colors.orange.shade700,
// //             ),
// //           ),
// //         ],
// //       ),
// //     );
// //   }
// //
// //   Widget _placeholderLogo() {
// //     return Container(
// //       width: 56,
// //       height: 56,
// //       decoration: BoxDecoration(
// //         color: Colors.grey.shade200,
// //         borderRadius: BorderRadius.circular(8),
// //       ),
// //       child: Icon(Icons.shield, color: Colors.grey.shade400, size: 32),
// //     );
// //   }
// //
// //   Widget _infoRow(IconData icon, String text) {
// //     return Row(
// //       mainAxisSize: MainAxisSize.min,
// //       children: [
// //         Icon(icon, size: 16, color: Colors.grey.shade600),
// //         const SizedBox(width: 6),
// //         Flexible(
// //           child: Text(
// //             text,
// //             style: TextStyle(
// //               fontSize: 12,
// //               color: Colors.grey.shade700,
// //               fontWeight: FontWeight.w500,
// //             ),
// //             overflow: TextOverflow.ellipsis,
// //           ),
// //         ),
// //       ],
// //     );
// //   }
// //
// //   // ==================== Tournament Card ====================
// //   Widget _buildTournamentCard(TournamentModel tournament) {
// //     final statusColor = tournament.status == 'ongoing'
// //         ? Colors.green
// //         : tournament.status == 'completed'
// //         ? Colors.grey
// //         : Colors.orange;
// //
// //     final statusText = tournament.status == 'ongoing'
// //         ? 'চলমান'
// //         : tournament.status == 'completed'
// //         ? 'সম্পন্ন'
// //         : 'আসন্ন';
// //
// //     return Card(
// //       margin: const EdgeInsets.only(bottom: 12),
// //       elevation: 2,
// //       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
// //       child: InkWell(
// //         borderRadius: BorderRadius.circular(16),
// //         onTap: () {
// //           Navigator.push(
// //             context,
// //             MaterialPageRoute(
// //                 builder: (_) =>
// //                     TournamentDetailScreen(tournament: tournament)),
// //           ).then((_) => _loadData());
// //         },
// //         child: Padding(
// //           padding: const EdgeInsets.all(16),
// //           child: Row(
// //             children: [
// //               Container(
// //                 padding: const EdgeInsets.all(12),
// //                 decoration: BoxDecoration(
// //                   color: statusColor.withOpacity(0.1),
// //                   borderRadius: BorderRadius.circular(12),
// //                 ),
// //                 child: Icon(Icons.emoji_events, color: statusColor, size: 32),
// //               ),
// //               const SizedBox(width: 16),
// //               Expanded(
// //                 child: Column(
// //                   crossAxisAlignment: CrossAxisAlignment.start,
// //                   children: [
// //                     Text(
// //                       tournament.name,
// //                       style: const TextStyle(
// //                         fontSize: 16,
// //                         fontWeight: FontWeight.bold,
// //                       ),
// //                     ),
// //                     const SizedBox(height: 4),
// //                     Text(
// //                       '${tournament.teamIds.length} টি টিম',
// //                       style: TextStyle(
// //                         fontSize: 13,
// //                         color: Colors.grey.shade600,
// //                       ),
// //                     ),
// //                     const SizedBox(height: 4),
// //                     Text(
// //                       '${_dateFormat.format(tournament.startDate)} - ${_dateFormat.format(tournament.endDate)}',
// //                       style: TextStyle(
// //                         fontSize: 11,
// //                         color: Colors.grey.shade500,
// //                       ),
// //                     ),
// //                   ],
// //                 ),
// //               ),
// //               Container(
// //                 padding:
// //                 const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
// //                 decoration: BoxDecoration(
// //                   color: statusColor.withOpacity(0.1),
// //                   borderRadius: BorderRadius.circular(20),
// //                   border: Border.all(color: statusColor),
// //                 ),
// //                 child: Text(
// //                   statusText,
// //                   style: TextStyle(
// //                     color: statusColor,
// //                     fontWeight: FontWeight.bold,
// //                     fontSize: 12,
// //                   ),
// //                 ),
// //               ),
// //             ],
// //           ),
// //         ),
// //       ),
// //     );
// //   }
// //
// //   Widget _buildEmptyState({
// //     required IconData icon,
// //     required String title,
// //     required String subtitle,
// //   }) {
// //     return Center(
// //       child: Column(
// //         mainAxisAlignment: MainAxisAlignment.center,
// //         children: [
// //           Icon(icon, size: 80, color: Colors.grey.shade300),
// //           const SizedBox(height: 16),
// //           Text(
// //             title,
// //             style: const TextStyle(
// //               fontSize: 20,
// //               fontWeight: FontWeight.bold,
// //               color: Colors.grey,
// //             ),
// //           ),
// //           const SizedBox(height: 8),
// //           Text(
// //             subtitle,
// //             style: TextStyle(color: Colors.grey.shade500),
// //             textAlign: TextAlign.center,
// //           ),
// //         ],
// //       ),
// //     );
// //   }
// // }
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
//       matchProvider.loadMatchesByAdmin(adminFullName), // এটাই চাই!
//       matchProvider.loadTeams(),
//       tournamentProvider.loadTournamentsByAdmin(adminFullName),
//     ]);
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
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
//       title: Text(_selectedIndex == 0 ? 'ম্যাচসমূহ' : 'টুর্নামেন্ট'),
//       flexibleSpace: Container(
//         decoration: BoxDecoration(
//           gradient: LinearGradient(
//             colors: [Colors.orange.shade700, Colors.orange.shade900],
//           ),
//         ),
//       ),
//       foregroundColor: Colors.white,
//       elevation: 0,
//       actions: [
//         IconButton(
//           icon: const Icon(Icons.refresh),
//           onPressed: _loadData,
//           tooltip: 'রিফ্রেশ',
//         ),
//       ],
//     );
//   }
//
//   Widget _buildBottomNavBar() {
//     return Container(
//       decoration: BoxDecoration(
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.1),
//             blurRadius: 10,
//             offset: const Offset(0, -2),
//           ),
//         ],
//       ),
//       child: BottomNavigationBar(
//         currentIndex: _selectedIndex,
//         onTap: (index) => setState(() => _selectedIndex = index),
//         selectedItemColor: Colors.orange.shade700,
//         unselectedItemColor: Colors.grey,
//         selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold),
//         type: BottomNavigationBarType.fixed,
//         elevation: 0,
//         items: const [
//           BottomNavigationBarItem(
//             icon: Icon(Icons.sports_soccer),
//             label: 'ম্যাচ',
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.emoji_events),
//             label: 'টুর্নামেন্ট',
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.more_horiz),
//             label: 'আরও',
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildFAB() {
//     return FloatingActionButton.extended(
//       onPressed: () {
//         if (_selectedIndex == 0) {
//           Navigator.push(
//             context,
//             MaterialPageRoute(
//                 builder: (_) => const CreateSingleMatchScreen()),
//           ).then((_) => _loadData());
//         } else {
//           Navigator.push(
//             context,
//             MaterialPageRoute(builder: (_) => const CreateTournamentScreen()),
//           ).then((_) => _loadData());
//         }
//       },
//       backgroundColor: Colors.orange.shade700,
//       icon: const Icon(Icons.add, color: Colors.white),
//       label: Text(
//         _selectedIndex == 0 ? 'নতুন ম্যাচ' : 'নতুন টুর্নামেন্ট',
//         style: const TextStyle(
//           color: Colors.white,
//           fontWeight: FontWeight.bold,
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
//           return const Center(child: CircularProgressIndicator());
//         }
//
//         if (matchProvider.matches.isEmpty) {
//           return _buildEmptyState(
//             icon: Icons.sports_soccer,
//             title: 'কোন ম্যাচ নেই',
//             subtitle: 'নতুন ম্যাচ তৈরি করতে + বাটনে ক্লিক করুন',
//           );
//         }
//
//         return RefreshIndicator(
//           onRefresh: _loadData,
//           child: ListView.builder(
//             padding: const EdgeInsets.all(16),
//             itemCount: matchProvider.matches.length,
//             itemBuilder: (context, index) =>
//                 _buildMatchCard(matchProvider.matches[index]),
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
//           return const Center(child: CircularProgressIndicator());
//         }
//
//         if (tournamentProvider.tournaments.isEmpty) {
//           return _buildEmptyState(
//             icon: Icons.emoji_events,
//             title: 'কোন টুর্নামেন্ট নেই',
//             subtitle: 'নতুন টুর্নামেন্ট তৈরি করতে + বাটনে ক্লিক করুন',
//           );
//         }
//
//         return RefreshIndicator(
//           onRefresh: _loadData,
//           child: ListView.builder(
//             padding: const EdgeInsets.all(16),
//             itemCount: tournamentProvider.tournaments.length,
//             itemBuilder: (context, index) =>
//                 _buildTournamentCard(tournamentProvider.tournaments[index]),
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
//           decoration: BoxDecoration(
//             gradient: LinearGradient(
//               begin: Alignment.topCenter,
//               end: Alignment.bottomCenter,
//               colors: [
//                 Colors.orange.shade700,
//                 Colors.orange.shade900,
//               ],
//             ),
//           ),
//           child: SafeArea(
//             child: SingleChildScrollView(
//               child: Column(
//                 children: [
//                   const SizedBox(height: 40),
//                   // Profile Header
//                   Container(
//                     padding: const EdgeInsets.all(24),
//                     child: Column(
//                       children: [
//                         Container(
//                           padding: const EdgeInsets.all(4),
//                           decoration: BoxDecoration(
//                             shape: BoxShape.circle,
//                             border: Border.all(color: Colors.white, width: 3),
//                             boxShadow: [
//                               BoxShadow(
//                                 color: Colors.black.withOpacity(0.2),
//                                 blurRadius: 20,
//                                 spreadRadius: 5,
//                               ),
//                             ],
//                           ),
//                           child: CircleAvatar(
//                             radius: 60,
//                             backgroundColor: Colors.white,
//                             child: Icon(
//                               Icons.person,
//                               size: 60,
//                               color: Colors.orange.shade700,
//                             ),
//                           ),
//                         ),
//                         const SizedBox(height: 20),
//                         Text(
//                           admin?.fullName ?? 'Admin',
//                           style: const TextStyle(
//                             color: Colors.white,
//                             fontSize: 28,
//                             fontWeight: FontWeight.bold,
//                           ),
//                         ),
//                         const SizedBox(height: 8),
//                         Container(
//                           padding: const EdgeInsets.symmetric(
//                             horizontal: 16,
//                             vertical: 8,
//                           ),
//                           decoration: BoxDecoration(
//                             color: Colors.white.withOpacity(0.2),
//                             borderRadius: BorderRadius.circular(20),
//                           ),
//                           child: const Text(
//                             'টুর্নামেন্ট অ্যাডমিন',
//                             style: TextStyle(
//                               color: Colors.white,
//                               fontSize: 14,
//                               fontWeight: FontWeight.w600,
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                   const SizedBox(height: 20),
//                   // Menu Cards
//                   Container(
//                     decoration: const BoxDecoration(
//                       color: Colors.white,
//                       borderRadius: BorderRadius.only(
//                         topLeft: Radius.circular(30),
//                         topRight: Radius.circular(30),
//                       ),
//                     ),
//                     child: Column(
//                       children: [
//                         const SizedBox(height: 30),
//                         _buildMenuCard(
//                           icon: Icons.person_outline,
//                           title: 'প্রোফাইল তথ্য',
//                           subtitle: 'আপনার প্রোফাইল দেখুন',
//                           color: Colors.blue,
//                           onTap: () {
//                             // Navigate to profile details
//                           },
//                         ),
//                         _buildMenuCard(
//                           icon: Icons.sports_soccer,
//                           title: 'মোট ম্যাচ',
//                           subtitle:
//                           '${context.read<MatchProvider>().matches.length} টি',
//                           color: Colors.green,
//                           onTap: () {
//                             setState(() => _selectedIndex = 0);
//                           },
//                         ),
//                         _buildMenuCard(
//                           icon: Icons.emoji_events,
//                           title: 'মোট টুর্নামেন্ট',
//                           subtitle:
//                           '${context.read<TournamentProvider>().tournaments.length} টি',
//                           color: Colors.orange,
//                           onTap: () {
//                             setState(() => _selectedIndex = 1);
//                           },
//                         ),
//                         _buildMenuCard(
//                           icon: Icons.shield,
//                           title: 'টিম ম্যানেজমেন্ট',
//                           subtitle: 'টিম যোগ ও পরিচালনা করুন',
//                           color: Colors.purple,
//                           onTap: () {
//                             // Navigate to team management
//                           },
//                         ),
//                         _buildMenuCard(
//                           icon: Icons.settings,
//                           title: 'সেটিংস',
//                           subtitle: 'অ্যাপ সেটিংস',
//                           color: Colors.grey,
//                           onTap: () {
//                             // Navigate to settings
//                           },
//                         ),
//                         const SizedBox(height: 20),
//                         // Logout Button
//                         Container(
//                           margin: const EdgeInsets.symmetric(horizontal: 20),
//                           width: double.infinity,
//                           child: ElevatedButton.icon(
//                             onPressed: () async {
//                               final confirmed = await showDialog<bool>(
//                                 context: context,
//                                 builder: (context) => AlertDialog(
//                                   title: const Text('লগআউট নিশ্চিত করুন'),
//                                   content: const Text(
//                                       'আপনি কি লগআউট করতে চান?'),
//                                   actions: [
//                                     TextButton(
//                                       onPressed: () =>
//                                           Navigator.pop(context, false),
//                                       child: const Text('না'),
//                                     ),
//                                     ElevatedButton(
//                                       onPressed: () =>
//                                           Navigator.pop(context, true),
//                                       style: ElevatedButton.styleFrom(
//                                         backgroundColor: Colors.red,
//                                       ),
//                                       child: const Text('হ্যাঁ, লগআউট'),
//                                     ),
//                                   ],
//                                 ),
//                               );
//
//                               if (confirmed == true && mounted) {
//                                 await authProvider.logout();
//                                 if (!mounted) return;
//                                 Navigator.of(context).pushNamedAndRemoveUntil(
//                                     '/login', (route) => false);
//                               }
//                             },
//                             icon: const Icon(Icons.logout),
//                             label: const Text(
//                               'লগআউট',
//                               style: TextStyle(
//                                 fontSize: 16,
//                                 fontWeight: FontWeight.bold,
//                               ),
//                             ),
//                             style: ElevatedButton.styleFrom(
//                               backgroundColor: Colors.red,
//                               foregroundColor: Colors.white,
//                               padding: const EdgeInsets.symmetric(vertical: 16),
//                               shape: RoundedRectangleBorder(
//                                 borderRadius: BorderRadius.circular(12),
//                               ),
//                               elevation: 0,
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
//   Widget _buildMenuCard({
//     required IconData icon,
//     required String title,
//     required String subtitle,
//     required Color color,
//     required VoidCallback onTap,
//   }) {
//     return Container(
//       margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
//       child: Material(
//         color: Colors.transparent,
//         child: InkWell(
//           onTap: onTap,
//           borderRadius: BorderRadius.circular(16),
//           child: Container(
//             padding: const EdgeInsets.all(16),
//             decoration: BoxDecoration(
//               color: Colors.white,
//               borderRadius: BorderRadius.circular(16),
//               border: Border.all(color: Colors.grey.shade200),
//               boxShadow: [
//                 BoxShadow(
//                   color: Colors.black.withOpacity(0.05),
//                   blurRadius: 10,
//                   offset: const Offset(0, 4),
//                 ),
//               ],
//             ),
//             child: Row(
//               children: [
//                 Container(
//                   padding: const EdgeInsets.all(12),
//                   decoration: BoxDecoration(
//                     color: color.withOpacity(0.1),
//                     borderRadius: BorderRadius.circular(12),
//                   ),
//                   child: Icon(icon, color: color, size: 28),
//                 ),
//                 const SizedBox(width: 16),
//                 Expanded(
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(
//                         title,
//                         style: const TextStyle(
//                           fontSize: 16,
//                           fontWeight: FontWeight.bold,
//                           color: Colors.black87,
//                         ),
//                       ),
//                       const SizedBox(height: 4),
//                       Text(
//                         subtitle,
//                         style: TextStyle(
//                           fontSize: 13,
//                           color: Colors.grey.shade600,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//                 Icon(
//                   Icons.arrow_forward_ios,
//                   color: Colors.grey.shade400,
//                   size: 16,
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
//
//   // ==================== Match Card ====================
//   Widget _buildMatchCard(MatchModel match) {
//     final statusColor = match.status == 'live'
//         ? Colors.green
//         : match.status == 'completed'
//         ? Colors.grey
//         : Colors.orange;
//
//     return Card(
//       margin: const EdgeInsets.only(bottom: 12),
//       elevation: 2,
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
//       child: InkWell(
//         borderRadius: BorderRadius.circular(16),
//         onTap: () {
//           Navigator.push(
//             context,
//             MaterialPageRoute(
//                 builder: (_) => MatchDetailScreen(match: match)),
//           ).then((_) => _loadData());
//         },
//         child: Padding(
//           padding: const EdgeInsets.all(16),
//           child: Column(
//             children: [
//               // Status Badge
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   Container(
//                     padding:
//                     const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
//                     decoration: BoxDecoration(
//                       color: statusColor.withOpacity(0.1),
//                       borderRadius: BorderRadius.circular(20),
//                       border: Border.all(color: statusColor),
//                     ),
//                     child: Row(
//                       mainAxisSize: MainAxisSize.min,
//                       children: [
//                         if (match.status == 'live')
//                           Container(
//                             width: 8,
//                             height: 8,
//                             margin: const EdgeInsets.only(right: 6),
//                             decoration: BoxDecoration(
//                               color: statusColor,
//                               shape: BoxShape.circle,
//                             ),
//                           ),
//                         Text(
//                           match.status == 'live'
//                               ? 'লাইভ'
//                               : match.status == 'completed'
//                               ? 'সম্পন্ন'
//                               : 'আসন্ন',
//                           style: TextStyle(
//                             color: statusColor,
//                             fontWeight: FontWeight.bold,
//                             fontSize: 12,
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                   if (match.tournament != null)
//                     Container(
//                       padding: const EdgeInsets.symmetric(
//                           horizontal: 8, vertical: 4),
//                       decoration: BoxDecoration(
//                         color: Colors.orange.shade50,
//                         borderRadius: BorderRadius.circular(8),
//                       ),
//                       child: Row(
//                         mainAxisSize: MainAxisSize.min,
//                         children: [
//                           Icon(Icons.emoji_events,
//                               size: 14, color: Colors.orange.shade700),
//                           const SizedBox(width: 4),
//                           Text(
//                             match.tournament!,
//                             style: TextStyle(
//                               fontSize: 11,
//                               color: Colors.orange.shade700,
//                               fontWeight: FontWeight.bold,
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                 ],
//               ),
//               const SizedBox(height: 16),
//
//               // Teams & Score
//               Row(
//                 children: [
//                   _buildTeamColumn(match.teamAName, match.scoreA),
//                   Padding(
//                     padding: const EdgeInsets.symmetric(horizontal: 16),
//                     child: Text(
//                       'VS',
//                       style: TextStyle(
//                         fontSize: 18,
//                         fontWeight: FontWeight.bold,
//                         color: Colors.grey.shade400,
//                       ),
//                     ),
//                   ),
//                   _buildTeamColumn(match.teamBName, match.scoreB),
//                 ],
//               ),
//               const SizedBox(height: 16),
//
//               // Venue & Date
//               Container(
//                 padding: const EdgeInsets.all(12),
//                 decoration: BoxDecoration(
//                   color: Colors.grey.shade50,
//                   borderRadius: BorderRadius.circular(12),
//                 ),
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceAround,
//                   children: [
//                     if (match.venue != null)
//                       _infoRow(Icons.location_on, match.venue!),
//                     if (match.venue != null)
//                       Container(
//                           width: 1, height: 20, color: Colors.grey.shade300),
//                     _infoRow(Icons.calendar_today,
//                         _dateFormat.format(match.date)),
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
//   // ✅ FIXED: Simplified team column without loading team from provider
//   Widget _buildTeamColumn(String teamName, int score) {
//     return Expanded(
//       child: Column(
//         children: [
//           // Placeholder Logo (since we already have teamName in match)
//           _placeholderLogo(),
//           const SizedBox(height: 8),
//           // Team Name (directly from match)
//           Text(
//             teamName,
//             style: const TextStyle(
//               fontWeight: FontWeight.bold,
//               fontSize: 13,
//             ),
//             textAlign: TextAlign.center,
//             maxLines: 2,
//             overflow: TextOverflow.ellipsis,
//           ),
//           const SizedBox(height: 8),
//           // Score
//           Text(
//             '$score',
//             style: TextStyle(
//               fontSize: 28,
//               fontWeight: FontWeight.bold,
//               color: Colors.orange.shade700,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _placeholderLogo() {
//     return Container(
//       width: 56,
//       height: 56,
//       decoration: BoxDecoration(
//         color: Colors.grey.shade200,
//         borderRadius: BorderRadius.circular(8),
//       ),
//       child: Icon(Icons.shield, color: Colors.grey.shade400, size: 32),
//     );
//   }
//
//   Widget _infoRow(IconData icon, String text) {
//     return Row(
//       mainAxisSize: MainAxisSize.min,
//       children: [
//         Icon(icon, size: 16, color: Colors.grey.shade600),
//         const SizedBox(width: 6),
//         Flexible(
//           child: Text(
//             text,
//             style: TextStyle(
//               fontSize: 12,
//               color: Colors.grey.shade700,
//               fontWeight: FontWeight.w500,
//             ),
//             overflow: TextOverflow.ellipsis,
//           ),
//         ),
//       ],
//     );
//   }
//
//   // ==================== Tournament Card ====================
//   // ==================== Tournament Card ====================
//   Widget _buildTournamentCard(TournamentModel tournament) {
//     final statusColor = tournament.status == 'ongoing'
//         ? Colors.green
//         : tournament.status == 'finished'  // ✅ CHANGED
//         ? Colors.grey
//         : Colors.orange;
//
//     final statusText = tournament.status == 'ongoing'
//         ? 'চলমান'
//         : tournament.status == 'finished'  // ✅ CHANGED
//         ? 'সম্পন্ন'
//         : 'আসন্ন';
//
//     return Card(
//       margin: const EdgeInsets.only(bottom: 12),
//       elevation: 2,
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
//       child: InkWell(
//         borderRadius: BorderRadius.circular(16),
//         onTap: () {
//           Navigator.push(
//             context,
//             MaterialPageRoute(
//                 builder: (_) =>
//                     TournamentDetailScreen(tournament: tournament)),
//           ).then((_) => _loadData());
//         },
//         child: Padding(
//           padding: const EdgeInsets.all(16),
//           child: Row(
//             children: [
//               Container(
//                 padding: const EdgeInsets.all(12),
//                 decoration: BoxDecoration(
//                   color: statusColor.withOpacity(0.1),
//                   borderRadius: BorderRadius.circular(12),
//                 ),
//                 child: Icon(Icons.emoji_events, color: statusColor, size: 32),
//               ),
//               const SizedBox(width: 16),
//               Expanded(
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       tournament.name,
//                       style: const TextStyle(
//                         fontSize: 16,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                     const SizedBox(height: 4),
//                     Text(
//                       '${tournament.teamIds.length} টি টিম',
//                       style: TextStyle(
//                         fontSize: 13,
//                         color: Colors.grey.shade600,
//                       ),
//                     ),
//                     const SizedBox(height: 4),
//                     Text(
//                       '${_dateFormat.format(tournament.startDate)} - ${_dateFormat.format(tournament.endDate)}',
//                       style: TextStyle(
//                         fontSize: 11,
//                         color: Colors.grey.shade500,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//               Container(
//                 padding:
//                 const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
//                 decoration: BoxDecoration(
//                   color: statusColor.withOpacity(0.1),
//                   borderRadius: BorderRadius.circular(20),
//                   border: Border.all(color: statusColor),
//                 ),
//                 child: Text(
//                   statusText,
//                   style: TextStyle(
//                     color: statusColor,
//                     fontWeight: FontWeight.bold,
//                     fontSize: 12,
//                   ),
//                 ),
//               ),
//             ],
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
//           Icon(icon, size: 80, color: Colors.grey.shade300),
//           const SizedBox(height: 16),
//           Text(
//             title,
//             style: const TextStyle(
//               fontSize: 20,
//               fontWeight: FontWeight.bold,
//               color: Colors.grey,
//             ),
//           ),
//           const SizedBox(height: 8),
//           Text(
//             subtitle,
//             style: TextStyle(color: Colors.grey.shade500),
//             textAlign: TextAlign.center,
//           ),
//         ],
//       ),
//     );
//   }
// }



import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

import '../../providers/auth_provider.dart';
import '../../providers/match_provider.dart';
import '../../providers/tournament_provider.dart';
import '../../models/match_model.dart';
import '../../models/tournament_model.dart';

import '../match/match_detail_screen.dart';
import '../match/create_single_match_screen.dart';
import '../tournament/create_tournament_screen.dart';
import '../tournament/tournament_detail_screen.dart';

class AdminHomeScreen extends StatefulWidget {
  const AdminHomeScreen({Key? key}) : super(key: key);

  @override
  State<AdminHomeScreen> createState() => _AdminHomeScreenState();
}

class _AdminHomeScreenState extends State<AdminHomeScreen> {
  int _selectedIndex = 0;
  final DateFormat _dateFormat = DateFormat('dd MMM yyyy');

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _loadData());
  }

  Future<void> _loadData() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final matchProvider = Provider.of<MatchProvider>(context, listen: false);
    final tournamentProvider = Provider.of<TournamentProvider>(context, listen: false);

    String adminFullName = authProvider.currentAdmin?.fullName ?? '';

    if (adminFullName.isEmpty) return;

    await Future.wait([
      matchProvider.loadMatchesByAdmin(adminFullName),
      matchProvider.loadTeams(),
      tournamentProvider.loadTournamentsByAdmin(adminFullName),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _selectedIndex == 2 ? null : _buildAppBar(),
      body: IndexedStack(
        index: _selectedIndex,
        children: [
          _buildMatchesTab(),
          _buildTournamentsTab(),
          _buildMoreTab(),
        ],
      ),
      bottomNavigationBar: _buildBottomNavBar(),
      floatingActionButton: _selectedIndex < 2 ? _buildFAB() : null,
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      title: Text(_selectedIndex == 0 ? 'ম্যাচসমূহ' : 'টুর্নামেন্ট'),
      flexibleSpace: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.orange.shade700, Colors.orange.shade900],
          ),
        ),
      ),
      foregroundColor: Colors.white,
      elevation: 0,
      actions: [
        IconButton(
          icon: const Icon(Icons.refresh),
          onPressed: _loadData,
          tooltip: 'রিফ্রেশ',
        ),
      ],
    );
  }

  Widget _buildBottomNavBar() {
    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) => setState(() => _selectedIndex = index),
        selectedItemColor: Colors.orange.shade700,
        unselectedItemColor: Colors.grey,
        selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold),
        type: BottomNavigationBarType.fixed,
        elevation: 0,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.sports_soccer),
            label: 'ম্যাচ',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.emoji_events),
            label: 'টুর্নামেন্ট',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.more_horiz),
            label: 'আরও',
          ),
        ],
      ),
    );
  }

  Widget _buildFAB() {
    return FloatingActionButton.extended(
      onPressed: () {
        if (_selectedIndex == 0) {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (_) => const CreateSingleMatchScreen()),
          ).then((_) => _loadData());
        } else {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const CreateTournamentScreen()),
          ).then((_) => _loadData());
        }
      },
      backgroundColor: Colors.orange.shade700,
      icon: const Icon(Icons.add, color: Colors.white),
      label: Text(
        _selectedIndex == 0 ? 'নতুন ম্যাচ' : 'নতুন টুর্নামেন্ট',
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  // ==================== TAB 1: MATCHES ====================
  Widget _buildMatchesTab() {
    return Consumer<MatchProvider>(
      builder: (context, matchProvider, child) {
        if (matchProvider.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (matchProvider.matches.isEmpty) {
          return _buildEmptyState(
            icon: Icons.sports_soccer,
            title: 'কোন ম্যাচ নেই',
            subtitle: 'নতুন ম্যাচ তৈরি করতে + বাটনে ক্লিক করুন',
          );
        }

        return RefreshIndicator(
          onRefresh: _loadData,
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: matchProvider.matches.length,
            itemBuilder: (context, index) =>
                _buildMatchCard(matchProvider.matches[index]),
          ),
        );
      },
    );
  }

  // ==================== TAB 2: TOURNAMENTS ====================
  Widget _buildTournamentsTab() {
    return Consumer<TournamentProvider>(
      builder: (context, tournamentProvider, child) {
        if (tournamentProvider.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (tournamentProvider.tournaments.isEmpty) {
          return _buildEmptyState(
            icon: Icons.emoji_events,
            title: 'কোন টুর্নামেন্ট নেই',
            subtitle: 'নতুন টুর্নামেন্ট তৈরি করতে + বাটনে ক্লিক করুন',
          );
        }

        return RefreshIndicator(
          onRefresh: _loadData,
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: tournamentProvider.tournaments.length,
            itemBuilder: (context, index) =>
                _buildTournamentCard(tournamentProvider.tournaments[index]),
          ),
        );
      },
    );
  }

  // ==================== TAB 3: MORE (PROFILE) ====================
  Widget _buildMoreTab() {
    return Consumer<AuthProvider>(
      builder: (context, authProvider, child) {
        final admin = authProvider.currentAdmin;

        return Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.orange.shade700,
                Colors.orange.shade900,
              ],
            ),
          ),
          child: SafeArea(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: 40),
                  // Profile Header
                  Container(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white, width: 3),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.2),
                                blurRadius: 20,
                                spreadRadius: 5,
                              ),
                            ],
                          ),
                          child: CircleAvatar(
                            radius: 60,
                            backgroundColor: Colors.white,
                            child: Icon(
                              Icons.person,
                              size: 60,
                              color: Colors.orange.shade700,
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        Text(
                          admin?.fullName ?? 'Admin',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: const Text(
                            'টুর্নামেন্ট অ্যাডমিন',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  // Menu Cards
                  Container(
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(30),
                        topRight: Radius.circular(30),
                      ),
                    ),
                    child: Column(
                      children: [
                        const SizedBox(height: 30),
                        _buildMenuCard(
                          icon: Icons.person_outline,
                          title: 'প্রোফাইল তথ্য',
                          subtitle: 'আপনার প্রোফাইল দেখুন',
                          color: Colors.blue,
                          onTap: () {
                            // Navigate to profile details
                          },
                        ),
                        _buildMenuCard(
                          icon: Icons.sports_soccer,
                          title: 'মোট ম্যাচ',
                          subtitle:
                          '${context.read<MatchProvider>().matches.length} টি',
                          color: Colors.green,
                          onTap: () {
                            setState(() => _selectedIndex = 0);
                          },
                        ),
                        _buildMenuCard(
                          icon: Icons.emoji_events,
                          title: 'মোট টুর্নামেন্ট',
                          subtitle:
                          '${context.read<TournamentProvider>().tournaments.length} টি',
                          color: Colors.orange,
                          onTap: () {
                            setState(() => _selectedIndex = 1);
                          },
                        ),
                        _buildMenuCard(
                          icon: Icons.shield,
                          title: 'টিম ম্যানেজমেন্ট',
                          subtitle: 'টিম যোগ ও পরিচালনা করুন',
                          color: Colors.purple,
                          onTap: () {
                            // Navigate to team management
                          },
                        ),
                        _buildMenuCard(
                          icon: Icons.settings,
                          title: 'সেটিংস',
                          subtitle: 'অ্যাপ সেটিংস',
                          color: Colors.grey,
                          onTap: () {
                            // Navigate to settings
                          },
                        ),
                        const SizedBox(height: 20),
                        // Logout Button
                        Container(
                          margin: const EdgeInsets.symmetric(horizontal: 20),
                          width: double.infinity,
                          child: ElevatedButton.icon(
                            onPressed: () async {
                              final confirmed = await showDialog<bool>(
                                context: context,
                                builder: (context) => AlertDialog(
                                  title: const Text('লগআউট নিশ্চিত করুন'),
                                  content: const Text(
                                      'আপনি কি লগআউট করতে চান?'),
                                  actions: [
                                    TextButton(
                                      onPressed: () =>
                                          Navigator.pop(context, false),
                                      child: const Text('না'),
                                    ),
                                    ElevatedButton(
                                      onPressed: () =>
                                          Navigator.pop(context, true),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.red,
                                      ),
                                      child: const Text('হ্যাঁ, লগআউট'),
                                    ),
                                  ],
                                ),
                              );

                              if (confirmed == true && mounted) {
                                await authProvider.logout();
                                if (!mounted) return;
                                Navigator.of(context).pushNamedAndRemoveUntil(
                                    '/login', (route) => false);
                              }
                            },
                            icon: const Icon(Icons.logout),
                            label: const Text(
                              'লগআউট',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              elevation: 0,
                            ),
                          ),
                        ),
                        const SizedBox(height: 40),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildMenuCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.grey.shade200),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(icon, color: color, size: 28),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        subtitle,
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.arrow_forward_ios,
                  color: Colors.grey.shade400,
                  size: 16,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ==================== Match Card ====================
  Widget _buildMatchCard(MatchModel match) {
    final statusColor = match.status == 'live'
        ? Colors.green
        : match.status == 'completed'
        ? Colors.grey
        : Colors.orange;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (_) => MatchDetailScreen(match: match)),
          ).then((_) => _loadData());
        },
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              // Status Badge
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: statusColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: statusColor),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (match.status == 'live')
                          Container(
                            width: 8,
                            height: 8,
                            margin: const EdgeInsets.only(right: 6),
                            decoration: BoxDecoration(
                              color: statusColor,
                              shape: BoxShape.circle,
                            ),
                          ),
                        Text(
                          match.status == 'live'
                              ? 'লাইভ'
                              : match.status == 'completed'
                              ? 'সম্পন্ন'
                              : 'আসন্ন',
                          style: TextStyle(
                            color: statusColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (match.tournament != null)
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.orange.shade50,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.emoji_events,
                              size: 14, color: Colors.orange.shade700),
                          const SizedBox(width: 4),
                          Text(
                            match.tournament!,
                            style: TextStyle(
                              fontSize: 11,
                              color: Colors.orange.shade700,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 16),

              // Teams & Score
              Row(
                children: [
                  _buildTeamColumn(match.teamAName, match.scoreA),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      'VS',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey.shade400,
                      ),
                    ),
                  ),
                  _buildTeamColumn(match.teamBName, match.scoreB),
                ],
              ),
              const SizedBox(height: 16),

              // Venue & Date
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.grey.shade50,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    if (match.venue != null)
                      _infoRow(Icons.location_on, match.venue!),
                    if (match.venue != null)
                      Container(
                          width: 1, height: 20, color: Colors.grey.shade300),
                    _infoRow(Icons.calendar_today,
                        _dateFormat.format(match.date)),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTeamColumn(String teamName, int score) {
    return Expanded(
      child: Column(
        children: [
          _placeholderLogo(),
          const SizedBox(height: 8),
          Text(
            teamName,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 13,
            ),
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 8),
          Text(
            '$score',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Colors.orange.shade700,
            ),
          ),
        ],
      ),
    );
  }

  Widget _placeholderLogo() {
    return Container(
      width: 56,
      height: 56,
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Icon(Icons.shield, color: Colors.grey.shade400, size: 32),
    );
  }

  Widget _infoRow(IconData icon, String text) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 16, color: Colors.grey.shade600),
        const SizedBox(width: 6),
        Flexible(
          child: Text(
            text,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey.shade700,
              fontWeight: FontWeight.w500,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  // ==================== Tournament Card ====================
  Widget _buildTournamentCard(TournamentModel tournament) {
    // ✅ FIXED: completed → finished
    final statusColor = tournament.status == 'ongoing'
        ? Colors.green
        : tournament.status == 'finished'
        ? Colors.grey
        : Colors.orange;

    final statusText = tournament.status == 'ongoing'
        ? 'চলমান'
        : tournament.status == 'finished'
        ? 'সম্পন্ন'
        : 'আসন্ন';

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () {
          // ✅ FIXED: Navigation enabled
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (_) =>
                    TournamentDetailScreen(tournament: tournament)),
          ).then((_) => _loadData());
        },
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: statusColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(Icons.emoji_events, color: statusColor, size: 32),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      tournament.name,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${tournament.teamIds.length} টি টিম',
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey.shade600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${_dateFormat.format(tournament.startDate)} - ${_dateFormat.format(tournament.endDate)}',
                      style: TextStyle(
                        fontSize: 11,
                        color: Colors.grey.shade500,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding:
                const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: statusColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: statusColor),
                ),
                child: Text(
                  statusText,
                  style: TextStyle(
                    color: statusColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState({
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 80, color: Colors.grey.shade300),
          const SizedBox(height: 16),
          Text(
            title,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            subtitle,
            style: TextStyle(color: Colors.grey.shade500),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}