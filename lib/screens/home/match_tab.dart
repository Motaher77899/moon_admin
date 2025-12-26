// // import 'package:flutter/material.dart';
// // import 'package:provider/provider.dart';
// // import 'package:intl/intl.dart';
// //
// // import '../../providers/auth_provider.dart';
// // import '../../providers/match_provider.dart';
// // import '../../models/match_model.dart';
// //
// // import '../match/match_detail_screen.dart';
// // import '../match/create_single_match_screen.dart';
// //
// // class MatchTab extends StatefulWidget {
// //   const MatchTab({Key? key}) : super(key: key);
// //
// //   @override
// //   State<MatchTab> createState() => _MatchTabState();
// // }
// //
// // class _MatchTabState extends State<MatchTab> with AutomaticKeepAliveClientMixin {
// //   final DateFormat _dateFormat = DateFormat('dd MMM yyyy');
// //
// //   @override
// //   bool get wantKeepAlive => true;
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
// //
// //     String adminFullName = authProvider.currentAdmin?.fullName ?? '';
// //     if (adminFullName.isEmpty) return;
// //
// //     await Future.wait([
// //       matchProvider.loadMatchesByAdmin(adminFullName),
// //       matchProvider.loadTeams(),
// //     ]);
// //   }
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     super.build(context);
// //     return Scaffold(
// //       backgroundColor: Colors.grey[50],
// //       appBar: _buildAppBar(),
// //       body: _buildBody(),
// //       floatingActionButton: _buildFAB(),
// //     );
// //   }
// //
// //   AppBar _buildAppBar() {
// //     return AppBar(
// //       title: const Text(
// //         'ম্যাচসমূহ',
// //         style: TextStyle(fontWeight: FontWeight.w600),
// //       ),
// //       backgroundColor: Colors.white,
// //       foregroundColor: Colors.grey[900],
// //       elevation: 0,
// //       bottom: PreferredSize(
// //         preferredSize: const Size.fromHeight(1),
// //         child: Container(
// //           color: Colors.grey[200],
// //           height: 1,
// //         ),
// //       ),
// //       actions: [
// //         IconButton(
// //           icon: const Icon(Icons.refresh_rounded),
// //           onPressed: _loadData,
// //           tooltip: 'রিফ্রেশ',
// //         ),
// //         const SizedBox(width: 8),
// //       ],
// //     );
// //   }
// //
// //   Widget _buildBody() {
// //     return Consumer<MatchProvider>(
// //       builder: (context, matchProvider, child) {
// //         if (matchProvider.isLoading) {
// //           return Center(
// //             child: CircularProgressIndicator(
// //               valueColor: AlwaysStoppedAnimation<Color>(Colors.orange.shade700),
// //             ),
// //           );
// //         }
// //         if (matchProvider.matches.isEmpty) {
// //           return _buildEmptyState();
// //         }
// //         return RefreshIndicator(
// //           color: Colors.orange.shade700,
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
// //   Widget _buildFAB() {
// //     return Container(
// //       decoration: BoxDecoration(
// //         borderRadius: BorderRadius.circular(16),
// //         boxShadow: [
// //           BoxShadow(
// //             color: Colors.orange.shade700.withOpacity(0.4),
// //             blurRadius: 15,
// //             offset: const Offset(0, 5),
// //           ),
// //         ],
// //       ),
// //       child: FloatingActionButton.extended(
// //         onPressed: () {
// //           Navigator.push(
// //             context,
// //             MaterialPageRoute(builder: (_) => const CreateSingleMatchScreen()),
// //           ).then((_) => _loadData());
// //         },
// //         backgroundColor: Colors.orange.shade700,
// //         elevation: 0,
// //         icon: const Icon(Icons.add_rounded, color: Colors.white),
// //         label: const Text(
// //           'নতুন ম্যাচ',
// //           style: TextStyle(
// //             color: Colors.white,
// //             fontWeight: FontWeight.w600,
// //             fontSize: 15,
// //           ),
// //         ),
// //       ),
// //     );
// //   }
// //
// //   Widget _buildMatchCard(MatchModel match) {
// //     final statusColor = match.status == 'live'
// //         ? Colors.green
// //         : match.status == 'completed'
// //         ? Colors.grey
// //         : Colors.orange;
// //
// //     return Container(
// //       margin: const EdgeInsets.only(bottom: 12),
// //       decoration: BoxDecoration(
// //         color: Colors.white,
// //         borderRadius: BorderRadius.circular(16),
// //         border: Border.all(color: Colors.grey.shade200),
// //         boxShadow: [
// //           BoxShadow(
// //             color: Colors.black.withOpacity(0.03),
// //             blurRadius: 10,
// //             offset: const Offset(0, 2),
// //           ),
// //         ],
// //       ),
// //       child: Material(
// //         color: Colors.transparent,
// //         child: InkWell(
// //           onTap: () => Navigator.push(
// //             context,
// //             MaterialPageRoute(builder: (_) => MatchDetailScreen(match: match)),
// //           ).then((_) => _loadData()),
// //           borderRadius: BorderRadius.circular(16),
// //           child: Padding(
// //             padding: const EdgeInsets.all(20),
// //             child: Column(
// //               children: [
// //                 Row(
// //                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
// //                   children: [
// //                     Container(
// //                       padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
// //                       decoration: BoxDecoration(
// //                         color: statusColor.withOpacity(0.1),
// //                         borderRadius: BorderRadius.circular(20),
// //                       ),
// //                       child: Row(
// //                         mainAxisSize: MainAxisSize.min,
// //                         children: [
// //                           Container(
// //                             width: 6,
// //                             height: 6,
// //                             decoration: BoxDecoration(
// //                               color: statusColor,
// //                               shape: BoxShape.circle,
// //                             ),
// //                           ),
// //                           const SizedBox(width: 6),
// //                           Text(
// //                             match.status == 'live'
// //                                 ? 'লাইভ'
// //                                 : match.status == 'finished'
// //                                 ? 'সম্পন্ন'
// //                                 : 'আসন্ন',
// //                             style: TextStyle(
// //                               color: statusColor,
// //                               fontWeight: FontWeight.w600,
// //                               fontSize: 12,
// //                             ),
// //                           ),
// //                         ],
// //                       ),
// //                     ),
// //                     if (match.tournament != null)
// //                       Container(
// //                         padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
// //                         decoration: BoxDecoration(
// //                           color: Colors.orange.shade50,
// //                           borderRadius: BorderRadius.circular(20),
// //                         ),
// //                         child: Text(
// //                           match.tournament!,
// //                           style: TextStyle(
// //                             fontSize: 11,
// //                             color: Colors.orange.shade700,
// //                             fontWeight: FontWeight.w600,
// //                           ),
// //                         ),
// //                       ),
// //                   ],
// //                 ),
// //                 const SizedBox(height: 20),
// //                 Row(
// //                   children: [
// //                     Expanded(
// //                       child: Text(
// //                         match.teamAId,
// //                         textAlign: TextAlign.center,
// //                         maxLines: 2,
// //                         overflow: TextOverflow.ellipsis,
// //                         style: const TextStyle(
// //                           fontWeight: FontWeight.w600,
// //                           fontSize: 15,
// //                         ),
// //                       ),
// //                     ),
// //                     Padding(
// //                       padding: const EdgeInsets.symmetric(horizontal: 20),
// //                       child: Text(
// //                         '${match.scoreA} - ${match.scoreB}',
// //                         style: const TextStyle(
// //                           fontSize: 28,
// //                           fontWeight: FontWeight.bold,
// //                           color: Colors.black87,
// //                         ),
// //                       ),
// //                     ),
// //                     Expanded(
// //                       child: Text(
// //                         match.teamBId,
// //                         textAlign: TextAlign.center,
// //                         maxLines: 2,
// //                         overflow: TextOverflow.ellipsis,
// //                         style: const TextStyle(
// //                           fontWeight: FontWeight.w600,
// //                           fontSize: 15,
// //                         ),
// //                       ),
// //                     ),
// //                   ],
// //                 ),
// //                 const SizedBox(height: 16),
// //                 Container(
// //                   padding: const EdgeInsets.symmetric(vertical: 12),
// //                   decoration: BoxDecoration(
// //                     color: Colors.grey.shade50,
// //                     borderRadius: BorderRadius.circular(8),
// //                   ),
// //                   child: Row(
// //                     mainAxisAlignment: MainAxisAlignment.center,
// //                     children: [
// //                       Icon(Icons.calendar_today_rounded, size: 14, color: Colors.grey[600]),
// //                       const SizedBox(width: 6),
// //                       Text(
// //                         _dateFormat.format(match.date),
// //                         style: TextStyle(
// //                           fontSize: 13,
// //                           color: Colors.grey[700],
// //                           fontWeight: FontWeight.w500,
// //                         ),
// //                       ),
// //                       const SizedBox(width: 16),
// //                       Icon(Icons.location_on_rounded, size: 14, color: Colors.grey[600]),
// //                       const SizedBox(width: 6),
// //                       Text(
// //                         match.venue ?? "No Venue",
// //                         style: TextStyle(
// //                           fontSize: 13,
// //                           color: Colors.grey[700],
// //                           fontWeight: FontWeight.w500,
// //                         ),
// //                       ),
// //                     ],
// //                   ),
// //                 ),
// //               ],
// //             ),
// //           ),
// //         ),
// //       ),
// //     );
// //   }
// //
// //   Widget _buildEmptyState() {
// //     return Center(
// //       child: Column(
// //         mainAxisAlignment: MainAxisAlignment.center,
// //         children: [
// //           Container(
// //             padding: const EdgeInsets.all(30),
// //             decoration: BoxDecoration(
// //               color: Colors.grey.shade100,
// //               shape: BoxShape.circle,
// //             ),
// //             child: Icon(Icons.sports_soccer_rounded, size: 60, color: Colors.grey.shade400),
// //           ),
// //           const SizedBox(height: 24),
// //           const Text(
// //             'কোন ম্যাচ নেই',
// //             style: TextStyle(
// //               fontSize: 20,
// //               fontWeight: FontWeight.bold,
// //               color: Colors.black87,
// //             ),
// //           ),
// //           const SizedBox(height: 8),
// //           Text(
// //             'নতুন ম্যাচ তৈরি করতে + বাটনে ক্লিক করুন',
// //             textAlign: TextAlign.center,
// //             style: TextStyle(
// //               fontSize: 14,
// //               color: Colors.grey.shade600,
// //             ),
// //           ),
// //         ],
// //       ),
// //     );
// //   }
// // }
//
//
//
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:intl/intl.dart';
//
// import '../../providers/auth_provider.dart';
// import '../../providers/match_provider.dart';
// import '../../models/match_model.dart';
//
//
// import '../match/create_single_match_screen.dart';
// import '../match/match_detail_screen.dart';
//
// class MatchTab extends StatefulWidget {
//   const MatchTab({Key? key}) : super(key: key);
//
//   @override
//   State<MatchTab> createState() => _MatchTabState();
// }
//
// class _MatchTabState extends State<MatchTab> with AutomaticKeepAliveClientMixin {
//   final DateFormat _dateFormat = DateFormat('dd MMM yyyy');
//
//   @override
//   bool get wantKeepAlive => true;
//
//   @override
//   void initState() {
//     super.initState();
//     // ফ্রেম রেন্ডার হওয়ার পর ডাটা লোড করা
//     WidgetsBinding.instance.addPostFrameCallback((_) => _loadData());
//   }
//
//   Future<void> _loadData() async {
//     final authProvider = Provider.of<AuthProvider>(context, listen: false);
//     final matchProvider = Provider.of<MatchProvider>(context, listen: false);
//
//     // অ্যাডমিনের নাম অনুযায়ী ম্যাচ ফিল্টার করার জন্য
//     String adminFullName = authProvider.currentAdmin?.fullName ?? '';
//     if (adminFullName.isEmpty) return;
//
//     await Future.wait([
//       matchProvider.loadMatchesByAdmin(adminFullName),
//       matchProvider.loadTeams(),
//     ]);
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     super.build(context);
//     return Scaffold(
//       backgroundColor: Colors.grey[50],
//       appBar: _buildAppBar(),
//       body: _buildBody(),
//       floatingActionButton: _buildFAB(),
//     );
//   }
//
//   AppBar _buildAppBar() {
//     return AppBar(
//       title: const Text(
//         'ম্যাচসমূহ',
//         style: TextStyle(fontWeight: FontWeight.w600),
//       ),
//       backgroundColor: Colors.white,
//       foregroundColor: Colors.grey[900],
//       elevation: 0,
//       bottom: PreferredSize(
//         preferredSize: const Size.fromHeight(1),
//         child: Container(color: Colors.grey[200], height: 1),
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
//   Widget _buildBody() {
//     return Consumer<MatchProvider>(
//       builder: (context, matchProvider, child) {
//         // নতুন মডেলে isLoading না থাকলে matchProvider.matches.isEmpty ব্যবহার হবে
//         if (matchProvider.matches.isEmpty) {
//           return _buildEmptyState();
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
//   Widget _buildFAB() {
//     return FloatingActionButton.extended(
//       onPressed: () {
//         Navigator.push(
//           context,
//           MaterialPageRoute(builder: (_) => const CreateSingleMatchScreen()),
//         ).then((_) => _loadData());
//       },
//       backgroundColor: Colors.orange.shade700,
//       icon: const Icon(Icons.add_rounded, color: Colors.white),
//       label: const Text(
//         'নতুন ম্যাচ',
//         style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
//       ),
//     );
//   }
//
//   Widget _buildMatchCard(MatchModel match) {
//     // স্ট্যাটাস অনুযায়ী কালার সেট
//     final statusColor = match.status == 'live'
//         ? Colors.green
//         : match.status == 'finished'
//         ? Colors.grey
//         : Colors.orange;
//
//     return Container(
//       margin: const EdgeInsets.only(bottom: 12),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(16),
//         border: Border.all(color: Colors.grey.shade200),
//       ),
//       child: InkWell(
//         onTap: () => Navigator.push(
//           context,
//           MaterialPageRoute(builder: (_) => MatchDetailScreen(match: match)),
//         ).then((_) => _loadData()),
//         borderRadius: BorderRadius.circular(16),
//         child: Padding(
//           padding: const EdgeInsets.all(20),
//           child: Column(
//             children: [
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   // স্ট্যাটাস ব্যাজ
//                   Container(
//                     padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
//                     decoration: BoxDecoration(
//                       color: statusColor.withOpacity(0.1),
//                       borderRadius: BorderRadius.circular(20),
//                     ),
//                     child: Row(
//                       mainAxisSize: MainAxisSize.min,
//                       children: [
//                         CircleAvatar(radius: 3, backgroundColor: statusColor),
//                         const SizedBox(width: 6),
//                         Text(
//                           match.status == 'live'
//                               ? 'লাইভ'
//                               : match.status == 'finished'
//                               ? 'সম্পন্ন'
//                               : 'আসন্ন',
//                           style: TextStyle(color: statusColor, fontWeight: FontWeight.bold, fontSize: 12),
//                         ),
//                       ],
//                     ),
//                   ),
//                   if (match.tournament != null)
//                     Text(
//                       match.tournament!,
//                       style: TextStyle(fontSize: 12, color: Colors.orange.shade800, fontWeight: FontWeight.w600),
//                     ),
//                 ],
//               ),
//               const SizedBox(height: 20),
//               // স্কোর এবং টিমের নাম
//               Row(
//                 children: [
//                   Expanded(
//                     child: Text(
//                       match.teamA, // ✅ teamAId এর পরিবর্তে teamA
//                       textAlign: TextAlign.center,
//                       style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
//                     ),
//                   ),
//                   Padding(
//                     padding: const EdgeInsets.symmetric(horizontal: 15),
//                     child: Text(
//                       '${match.scoreA} - ${match.scoreB}',
//                       style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
//                     ),
//                   ),
//                   Expanded(
//                     child: Text(
//                       match.teamB, // ✅ teamBId এর পরিবর্তে teamB
//                       textAlign: TextAlign.center,
//                       style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
//                     ),
//                   ),
//                 ],
//               ),
//               const SizedBox(height: 20),
//               // ভেন্যু এবং তারিখ
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   const Icon(Icons.calendar_month, size: 14, color: Colors.grey),
//                   const SizedBox(width: 4),
//                   Text(_dateFormat.format(match.date), style: const TextStyle(fontSize: 12, color: Colors.grey)),
//                   const SizedBox(width: 12),
//                   const Icon(Icons.location_on, size: 14, color: Colors.grey),
//                   const SizedBox(width: 4),
//                   Flexible(
//                     child: Text(
//                       match.venue ?? "ভেন্যু নেই",
//                       overflow: TextOverflow.ellipsis,
//                       style: const TextStyle(fontSize: 12, color: Colors.grey),
//                     ),
//                   ),
//                 ],
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget _buildEmptyState() {
//     return Center(
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Icon(Icons.sports_soccer_rounded, size: 80, color: Colors.grey[300]),
//           const SizedBox(height: 16),
//           const Text('কোন ম্যাচ পাওয়া যায়নি', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
//           const SizedBox(height: 8),
//           const Text('নতুন ম্যাচ তৈরি করতে নিচের + বাটনে ক্লিক করুন'),
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
import '../../models/match_model.dart';

import '../match/create_single_match_screen.dart';
import '../match/match_detail_screen.dart';

class MatchTab extends StatefulWidget {
  const MatchTab({Key? key}) : super(key: key);

  @override
  State<MatchTab> createState() => _MatchTabState();
}

class _MatchTabState extends State<MatchTab> with AutomaticKeepAliveClientMixin {
  final DateFormat _dateFormat = DateFormat('dd MMM yyyy');

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _loadData();
      }
    });
  }

  Future<void> _loadData() async {
    if (!mounted) return;

    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final matchProvider = Provider.of<MatchProvider>(context, listen: false);

    String adminFullName = authProvider.currentAdmin?.fullName ?? '';
    if (adminFullName.isEmpty) return;

    try {
      await Future.wait([
        matchProvider.loadMatchesByAdmin(adminFullName),
        matchProvider.loadTeams(),
      ]);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('ডাটা লোড করতে সমস্যা: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: _buildAppBar(),
      body: _buildBody(),
      floatingActionButton: _buildFAB(),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      title: const Text(
        'ম্যাচসমূহ',
        style: TextStyle(fontWeight: FontWeight.w600),
      ),
      backgroundColor: Colors.white,
      foregroundColor: Colors.grey[900],
      elevation: 0,
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(1),
        child: Container(color: Colors.grey[200], height: 1),
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.refresh_rounded),
          onPressed: _loadData,
          tooltip: 'রিফ্রেশ',
        ),
        const SizedBox(width: 8),
      ],
    );
  }

  Widget _buildBody() {
    return Consumer<MatchProvider>(
      builder: (context, matchProvider, child) {
        // Loading state
        if (matchProvider.isLoading) {
          return Center(
            child: CircularProgressIndicator(
              color: Colors.orange.shade700,
            ),
          );
        }

        // Empty state
        if (matchProvider.matches.isEmpty) {
          return _buildEmptyState();
        }

        // Matches list
        return RefreshIndicator(
          color: Colors.orange.shade700,
          onRefresh: _loadData,
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: matchProvider.matches.length,
            itemBuilder: (context, index) {
              return _buildMatchCard(matchProvider.matches[index]);
            },
          ),
        );
      },
    );
  }

  Widget _buildFAB() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.orange.shade700.withOpacity(0.3),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: FloatingActionButton.extended(
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const CreateSingleMatchScreen()),
          );
          if (mounted) {
            _loadData();
          }
        },
        backgroundColor: Colors.orange.shade700,
        elevation: 0,
        icon: const Icon(Icons.add_rounded, color: Colors.white),
        label: const Text(
          'নতুন ম্যাচ',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
            fontSize: 15,
          ),
        ),
      ),
    );
  }

  Widget _buildMatchCard(MatchModel match) {
    final statusColor = match.status == 'live'
        ? Colors.green
        : match.status == 'completed' || match.status == 'finished'
        ? Colors.grey
        : Colors.orange;

    final statusText = match.status == 'live'
        ? 'লাইভ'
        : match.status == 'completed' || match.status == 'finished'
        ? 'সম্পন্ন'
        : 'আসন্ন';

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () async {
            await Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => MatchDetailScreen(match: match)),
            );
            if (mounted) {
              _loadData();
            }
          },
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                // Status and Tournament Row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Status Badge
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: statusColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 6,
                            height: 6,
                            decoration: BoxDecoration(
                              color: statusColor,
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 6),
                          Text(
                            statusText,
                            style: TextStyle(
                              color: statusColor,
                              fontWeight: FontWeight.w600,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Tournament Badge
                    if (match.tournament != null && match.tournament!.isNotEmpty)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: Colors.orange.shade50,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          match.tournament!,
                          style: TextStyle(
                            fontSize: 11,
                            color: Colors.orange.shade700,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 20),
                // Teams and Score Row
                Row(
                  children: [
                    // Team A Name
                    Expanded(
                      child: Text(
                        match.teamAName, // ✅ Use teamAName instead of teamA
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 15,
                        ),
                      ),
                    ),
                    // Score
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Text(
                        '${match.scoreA} - ${match.scoreB}',
                        style: const TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                    // Team B Name
                    Expanded(
                      child: Text(
                        match.teamBName, // ✅ Use teamBName instead of teamB
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 15,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                // Date and Venue Row
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade50,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.calendar_today_rounded, size: 14, color: Colors.grey[600]),
                      const SizedBox(width: 6),
                      Text(
                        _dateFormat.format(match.date),
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.grey[700],
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Icon(Icons.location_on_rounded, size: 14, color: Colors.grey[600]),
                      const SizedBox(width: 6),
                      Flexible(
                        child: Text(
                          match.venue ?? "স্টেডিয়াম নির্ধারিত হয়নি",
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.grey[700],
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(30),
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.sports_soccer_rounded,
              size: 60,
              color: Colors.grey.shade400,
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            'কোন ম্যাচ নেই',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'নতুন ম্যাচ তৈরি করতে + বাটনে ক্লিক করুন',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade600,
            ),
          ),
        ],
      ),
    );
  }
}