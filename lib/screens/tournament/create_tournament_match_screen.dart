// // // import 'package:flutter/material.dart';
// // // import 'package:provider/provider.dart';
// // // import 'package:intl/intl.dart';
// // // import '../../providers/tournament_provider.dart';
// // // import '../../providers/match_provider.dart';
// // // import '../../models/tournament_model.dart';
// // // import '../../models/team_model.dart';
// // //
// // // class CreateTournamentMatchScreen extends StatefulWidget {
// // //   final TournamentModel tournament;
// // //
// // //   const CreateTournamentMatchScreen({Key? key, required this.tournament})
// // //       : super(key: key);
// // //
// // //   @override
// // //   State<CreateTournamentMatchScreen> createState() =>
// // //       _CreateTournamentMatchScreenState();
// // // }
// // //
// // // class _CreateTournamentMatchScreenState
// // //     extends State<CreateTournamentMatchScreen> {
// // //   final _formKey = GlobalKey<FormState>();
// // //   final TextEditingController _venueController = TextEditingController();
// // //   final TextEditingController _roundController = TextEditingController();
// // //
// // //   String? _selectedTeamAId;
// // //   String? _selectedTeamBId;
// // //   String? _selectedGroup;
// // //   late DateTime _matchDate;
// // //   late TimeOfDay _matchTime;
// // //   bool _isLoading = false;
// // //
// // //   @override
// // //   void initState() {
// // //     super.initState();
// // //
// // //     // Initialize date with tournament start date or today (whichever is later)
// // //     final now = DateTime.now();
// // //     final tournamentStart = widget.tournament.startDate;
// // //
// // //     if (now.isAfter(tournamentStart)) {
// // //       _matchDate = now;
// // //     } else {
// // //       _matchDate = tournamentStart;
// // //     }
// // //
// // //     _matchTime = TimeOfDay.now();
// // //   }
// // //
// // //   @override
// // //   void dispose() {
// // //     _venueController.dispose();
// // //     _roundController.dispose();
// // //     super.dispose();
// // //   }
// // //
// // //   Future<void> _selectDate() async {
// // //     // Set proper date range
// // //     final DateTime now = DateTime.now();
// // //     final DateTime firstDate = widget.tournament.startDate.isBefore(now)
// // //         ? now
// // //         : widget.tournament.startDate;
// // //     final DateTime lastDate = widget.tournament.endDate;
// // //
// // //     // Make sure initial date is within range
// // //     DateTime initialDate = _matchDate;
// // //     if (initialDate.isBefore(firstDate)) {
// // //       initialDate = firstDate;
// // //     } else if (initialDate.isAfter(lastDate)) {
// // //       initialDate = lastDate;
// // //     }
// // //
// // //     final DateTime? picked = await showDatePicker(
// // //       context: context,
// // //       initialDate: initialDate,
// // //       firstDate: firstDate,
// // //       lastDate: lastDate,
// // //       builder: (context, child) {
// // //         return Theme(
// // //           data: Theme.of(context).copyWith(
// // //             colorScheme: ColorScheme.light(
// // //               primary: Colors.orange.shade700,
// // //               onPrimary: Colors.white,
// // //               surface: Colors.white,
// // //               onSurface: Colors.black,
// // //             ),
// // //           ),
// // //           child: child!,
// // //         );
// // //       },
// // //     );
// // //
// // //     if (picked != null) {
// // //       setState(() {
// // //         _matchDate = DateTime(
// // //           picked.year,
// // //           picked.month,
// // //           picked.day,
// // //           _matchTime.hour,
// // //           _matchTime.minute,
// // //         );
// // //       });
// // //     }
// // //   }
// // //
// // //   Future<void> _selectTime() async {
// // //     final TimeOfDay? picked = await showTimePicker(
// // //       context: context,
// // //       initialTime: _matchTime,
// // //       builder: (context, child) {
// // //         return Theme(
// // //           data: Theme.of(context).copyWith(
// // //             colorScheme: ColorScheme.light(
// // //               primary: Colors.orange.shade700,
// // //               onPrimary: Colors.white,
// // //               surface: Colors.white,
// // //               onSurface: Colors.black,
// // //             ),
// // //           ),
// // //           child: child!,
// // //         );
// // //       },
// // //     );
// // //
// // //     if (picked != null) {
// // //       setState(() {
// // //         _matchTime = picked;
// // //         _matchDate = DateTime(
// // //           _matchDate.year,
// // //           _matchDate.month,
// // //           _matchDate.day,
// // //           picked.hour,
// // //           picked.minute,
// // //         );
// // //       });
// // //     }
// // //   }
// // //
// // //   Future<void> _createMatch() async {
// // //     if (!_formKey.currentState!.validate()) return;
// // //
// // //     if (_selectedTeamAId == null || _selectedTeamBId == null) {
// // //       ScaffoldMessenger.of(context).showSnackBar(
// // //         const SnackBar(
// // //           content: Text('দুটি টিম নির্বাচন করুন'),
// // //           backgroundColor: Colors.red,
// // //         ),
// // //       );
// // //       return;
// // //     }
// // //
// // //     if (_selectedTeamAId == _selectedTeamBId) {
// // //       ScaffoldMessenger.of(context).showSnackBar(
// // //         const SnackBar(
// // //           content: Text('দুটি ভিন্ন টিম নির্বাচন করুন'),
// // //           backgroundColor: Colors.red,
// // //         ),
// // //       );
// // //       return;
// // //     }
// // //
// // //     setState(() => _isLoading = true);
// // //
// // //     final matchProvider = Provider.of<MatchProvider>(context, listen: false);
// // //     final tournamentProvider =
// // //     Provider.of<TournamentProvider>(context, listen: false);
// // //
// // //     // Get team details
// // //     TeamModel? teamA = matchProvider.teams
// // //         .firstWhere((t) => t.teamId == _selectedTeamAId);
// // //     TeamModel? teamB = matchProvider.teams
// // //         .firstWhere((t) => t.teamId == _selectedTeamBId);
// // //
// // //     // Combine date and time
// // //     DateTime matchDateTime = DateTime(
// // //       _matchDate.year,
// // //       _matchDate.month,
// // //       _matchDate.day,
// // //       _matchTime.hour,
// // //       _matchTime.minute,
// // //     );
// // //
// // //     TournamentMatch match = TournamentMatch(
// // //       tournamentId: widget.tournament.tournamentId!,
// // //       teamAId: _selectedTeamAId!,
// // //       teamBId: _selectedTeamBId!,
// // //       teamAName: teamA.name,
// // //       teamBName: teamB.name,
// // //       teamALogo: teamA.logoUrl,
// // //       teamBLogo: teamB.logoUrl,
// // //       matchDate: matchDateTime,
// // //       venue: _venueController.text.trim(),
// // //       round: _roundController.text.trim(),
// // //       groupName: _selectedGroup,
// // //       createdAt: DateTime.now(),
// // //     );
// // //
// // //     final error = await tournamentProvider.createTournamentMatch(
// // //       match,
// // //       'admin',
// // //     );
// // //
// // //     setState(() => _isLoading = false);
// // //
// // //     if (error != null) {
// // //       ScaffoldMessenger.of(context).showSnackBar(
// // //         SnackBar(content: Text(error), backgroundColor: Colors.red),
// // //       );
// // //     } else {
// // //       ScaffoldMessenger.of(context).showSnackBar(
// // //         const SnackBar(
// // //           content: Text('ম্যাচ সফলভাবে তৈরি হয়েছে'),
// // //           backgroundColor: Colors.green,
// // //         ),
// // //       );
// // //       Navigator.pop(context);
// // //     }
// // //   }
// // //
// // //   @override
// // //   Widget build(BuildContext context) {
// // //     final DateFormat dateFormat = DateFormat('dd MMM yyyy');
// // //
// // //     return Scaffold(
// // //       appBar: AppBar(
// // //         title: const Text('নতুন ম্যাচ যোগ করুন'),
// // //         flexibleSpace: Container(
// // //           decoration: BoxDecoration(
// // //             gradient: LinearGradient(
// // //               colors: [Colors.orange.shade600, Colors.orange.shade800],
// // //             ),
// // //           ),
// // //         ),
// // //         foregroundColor: Colors.white,
// // //       ),
// // //       body: _isLoading
// // //           ? const Center(child: CircularProgressIndicator())
// // //           : Consumer2<TournamentProvider, MatchProvider>(
// // //         builder: (context, tournamentProvider, matchProvider, child) {
// // //           List<TeamModel> tournamentTeams = matchProvider.teams
// // //               .where((t) => widget.tournament.teamIds.contains(t.teamId))
// // //               .toList();
// // //
// // //           return Form(
// // //             key: _formKey,
// // //             child: ListView(
// // //               padding: const EdgeInsets.all(16),
// // //               children: [
// // //                 if (tournamentProvider.groups.isNotEmpty) ...[
// // //                   _buildSectionHeader('গ্রুপ নির্বাচন করুন (ঐচ্ছিক)'),
// // //                   DropdownButtonFormField<String>(
// // //                     value: _selectedGroup,
// // //                     decoration: InputDecoration(
// // //                       hintText: 'গ্রুপ বা নকআউট রাউন্ড',
// // //                       prefixIcon: const Icon(Icons.workspaces),
// // //                       border: OutlineInputBorder(
// // //                         borderRadius: BorderRadius.circular(12),
// // //                       ),
// // //                     ),
// // //                     items: [
// // //                       const DropdownMenuItem(
// // //                         value: null,
// // //                         child: Text('নকআউট/ফাইনাল'),
// // //                       ),
// // //                       ...tournamentProvider.groups.map((group) {
// // //                         return DropdownMenuItem(
// // //                           value: group.groupName,
// // //                           child: Text(group.groupName),
// // //                         );
// // //                       }).toList(),
// // //                     ],
// // //                     onChanged: (value) {
// // //                       setState(() => _selectedGroup = value);
// // //                     },
// // //                   ),
// // //                   const SizedBox(height: 20),
// // //                 ],
// // //
// // //                 _buildSectionHeader('রাউন্ড/পর্ব'),
// // //                 TextFormField(
// // //                   controller: _roundController,
// // //                   decoration: InputDecoration(
// // //                     hintText: 'যেমন: Group A,Match Day 1, Semi Final',
// // //                     prefixIcon: const Icon(Icons.sports),
// // //                     border: OutlineInputBorder(
// // //                       borderRadius: BorderRadius.circular(12),
// // //                     ),
// // //                   ),
// // //                   validator: (value) {
// // //                     if (value == null || value.trim().isEmpty) {
// // //                       return 'রাউন্ড/পর্ব দিন';
// // //                     }
// // //                     return null;
// // //                   },
// // //                 ),
// // //                 const SizedBox(height: 20),
// // //
// // //                 // Team A
// // //                 _buildSectionHeader('টিম A'),
// // //                 DropdownButtonFormField<String>(
// // //                   value: _selectedTeamAId,
// // //                   decoration: InputDecoration(
// // //                     hintText: 'টিম নির্বাচন করুন',
// // //                     prefixIcon: const Icon(Icons.shield),
// // //                     border: OutlineInputBorder(
// // //                       borderRadius: BorderRadius.circular(12),
// // //                     ),
// // //                   ),
// // //                   items: tournamentTeams.map((team) {
// // //                     return DropdownMenuItem(
// // //                       value: team.teamId,
// // //                       child: Row(
// // //                         children: [
// // //                           // Team Logo or Default Icon
// // //                           Container(
// // //                             width: 28,
// // //                             height: 28,
// // //                             margin: const EdgeInsets.only(right: 10),
// // //                             decoration: BoxDecoration(
// // //                               color: Colors.grey.shade200,
// // //                               borderRadius: BorderRadius.circular(6),
// // //                             ),
// // //                             child: (team.logoUrl != null && team.logoUrl!.isNotEmpty)
// // //                                 ? ClipRRect(
// // //                               borderRadius: BorderRadius.circular(6),
// // //                               child: Image.network(
// // //                                 team.logoUrl!,
// // //                                 width: 28,
// // //                                 height: 28,
// // //                                 fit: BoxFit.cover,
// // //                                 errorBuilder: (context, error, stackTrace) {
// // //                                   return Icon(
// // //                                     Icons.shield,
// // //                                     size: 18,
// // //                                     color: Colors.grey.shade500,
// // //                                   );
// // //                                 },
// // //                                 loadingBuilder: (context, child, loadingProgress) {
// // //                                   if (loadingProgress == null) return child;
// // //                                   return Center(
// // //                                     child: SizedBox(
// // //                                       width: 16,
// // //                                       height: 16,
// // //                                       child: CircularProgressIndicator(
// // //                                         strokeWidth: 2,
// // //                                         valueColor: AlwaysStoppedAnimation<Color>(
// // //                                           Colors.orange.shade300,
// // //                                         ),
// // //                                       ),
// // //                                     ),
// // //                                   );
// // //                                 },
// // //                               ),
// // //                             )
// // //                                 : Icon(
// // //                               Icons.shield,
// // //                               size: 18,
// // //                               color: Colors.grey.shade500,
// // //                             ),
// // //                           ),
// // //                           // Team Name
// // //                           Expanded(
// // //                             child: Text(
// // //                               team.name,
// // //                               overflow: TextOverflow.ellipsis,
// // //                               style: const TextStyle(fontSize: 15),
// // //                             ),
// // //                           ),
// // //                         ],
// // //                       ),
// // //                     );
// // //                   }).toList(),
// // //                   onChanged: (value) {
// // //                     setState(() => _selectedTeamAId = value);
// // //                   },
// // //                   validator: (value) {
// // //                     if (value == null) return 'টিম নির্বাচন করুন';
// // //                     return null;
// // //                   },
// // //                 ),
// // //                 const SizedBox(height: 20),
// // //
// // // // Team B
// // //                 _buildSectionHeader('টিম B'),
// // //                 DropdownButtonFormField<String>(
// // //                   value: _selectedTeamBId,
// // //                   decoration: InputDecoration(
// // //                     hintText: 'টিম নির্বাচন করুন',
// // //                     prefixIcon: const Icon(Icons.shield),
// // //                     border: OutlineInputBorder(
// // //                       borderRadius: BorderRadius.circular(12),
// // //                     ),
// // //                   ),
// // //                   items: tournamentTeams.map((team) {
// // //                     return DropdownMenuItem(
// // //                       value: team.teamId,
// // //                       child: Row(
// // //                         children: [
// // //                           // Team Logo or Default Icon
// // //                           Container(
// // //                             width: 28,
// // //                             height: 28,
// // //                             margin: const EdgeInsets.only(right: 10),
// // //                             decoration: BoxDecoration(
// // //                               color: Colors.grey.shade200,
// // //                               borderRadius: BorderRadius.circular(6),
// // //                             ),
// // //                             child: (team.logoUrl != null && team.logoUrl!.isNotEmpty)
// // //                                 ? ClipRRect(
// // //                               borderRadius: BorderRadius.circular(6),
// // //                               child: Image.network(
// // //                                 team.logoUrl!,
// // //                                 width: 28,
// // //                                 height: 28,
// // //                                 fit: BoxFit.cover,
// // //                                 errorBuilder: (context, error, stackTrace) {
// // //                                   return Icon(
// // //                                     Icons.shield,
// // //                                     size: 18,
// // //                                     color: Colors.grey.shade500,
// // //                                   );
// // //                                 },
// // //                                 loadingBuilder: (context, child, loadingProgress) {
// // //                                   if (loadingProgress == null) return child;
// // //                                   return Center(
// // //                                     child: SizedBox(
// // //                                       width: 16,
// // //                                       height: 16,
// // //                                       child: CircularProgressIndicator(
// // //                                         strokeWidth: 2,
// // //                                         valueColor: AlwaysStoppedAnimation<Color>(
// // //                                           Colors.orange.shade300,
// // //                                         ),
// // //                                       ),
// // //                                     ),
// // //                                   );
// // //                                 },
// // //                               ),
// // //                             )
// // //                                 : Icon(
// // //                               Icons.shield,
// // //                               size: 18,
// // //                               color: Colors.grey.shade500,
// // //                             ),
// // //                           ),
// // //                           // Team Name
// // //                           Expanded(
// // //                             child: Text(
// // //                               team.name,
// // //                               overflow: TextOverflow.ellipsis,
// // //                               style: const TextStyle(fontSize: 15),
// // //                             ),
// // //                           ),
// // //                         ],
// // //                       ),
// // //                     );
// // //                   }).toList(),
// // //                   onChanged: (value) {
// // //                     setState(() => _selectedTeamBId = value);
// // //                   },
// // //                   validator: (value) {
// // //                     if (value == null) return 'টিম নির্বাচন করুন';
// // //                     return null;
// // //                   },
// // //                 ),
// // //                 const SizedBox(height: 20),
// // //
// // //                 _buildSectionHeader('তারিখ এবং সময়'),
// // //                 Row(
// // //                   children: [
// // //                     Expanded(
// // //                       child: InkWell(
// // //                         onTap: _selectDate,
// // //                         child: Container(
// // //                           padding: const EdgeInsets.all(16),
// // //                           decoration: BoxDecoration(
// // //                             border:
// // //                             Border.all(color: Colors.grey.shade300),
// // //                             borderRadius: BorderRadius.circular(12),
// // //                           ),
// // //                           child: Row(
// // //                             children: [
// // //                               Icon(Icons.calendar_today,
// // //                                   color: Colors.orange.shade700),
// // //                               const SizedBox(width: 12),
// // //                               Expanded(
// // //                                 child: Text(
// // //                                   dateFormat.format(_matchDate),
// // //                                   style: const TextStyle(
// // //                                     fontSize: 15,
// // //                                     fontWeight: FontWeight.w600,
// // //                                   ),
// // //                                 ),
// // //                               ),
// // //                             ],
// // //                           ),
// // //                         ),
// // //                       ),
// // //                     ),
// // //                     const SizedBox(width: 12),
// // //                     Expanded(
// // //                       child: InkWell(
// // //                         onTap: _selectTime,
// // //                         child: Container(
// // //                           padding: const EdgeInsets.all(16),
// // //                           decoration: BoxDecoration(
// // //                             border:
// // //                             Border.all(color: Colors.grey.shade300),
// // //                             borderRadius: BorderRadius.circular(12),
// // //                           ),
// // //                           child: Row(
// // //                             children: [
// // //                               Icon(Icons.access_time,
// // //                                   color: Colors.orange.shade700),
// // //                               const SizedBox(width: 12),
// // //                               Expanded(
// // //                                 child: Text(
// // //                                   _matchTime.format(context),
// // //                                   style: const TextStyle(
// // //                                     fontSize: 15,
// // //                                     fontWeight: FontWeight.w600,
// // //                                   ),
// // //                                 ),
// // //                               ),
// // //                             ],
// // //                           ),
// // //                         ),
// // //                       ),
// // //                     ),
// // //                   ],
// // //                 ),
// // //                 const SizedBox(height: 20),
// // //
// // //                 _buildSectionHeader('স্থান'),
// // //                 TextFormField(
// // //                   controller: _venueController,
// // //                   decoration: InputDecoration(
// // //                     hintText: 'যেমন: ঢাকা স্টেডিয়াম',
// // //                     prefixIcon: const Icon(Icons.location_on),
// // //                     border: OutlineInputBorder(
// // //                       borderRadius: BorderRadius.circular(12),
// // //                     ),
// // //                   ),
// // //                   validator: (value) {
// // //                     if (value == null || value.trim().isEmpty) {
// // //                       return 'স্থান দিন';
// // //                     }
// // //                     return null;
// // //                   },
// // //                 ),
// // //                 const SizedBox(height: 30),
// // //
// // //                 ElevatedButton(
// // //                   onPressed: _createMatch,
// // //                   style: ElevatedButton.styleFrom(
// // //                     backgroundColor: Colors.orange.shade700,
// // //                     minimumSize: const Size(double.infinity, 55),
// // //                     shape: RoundedRectangleBorder(
// // //                       borderRadius: BorderRadius.circular(12),
// // //                     ),
// // //                   ),
// // //                   child: const Text(
// // //                     'ম্যাচ তৈরি করুন',
// // //                     style: TextStyle(
// // //                       fontSize: 18,
// // //                       fontWeight: FontWeight.bold,
// // //                       color: Colors.white,
// // //                     ),
// // //                   ),
// // //                 ),
// // //                 const SizedBox(height: 20),
// // //               ],
// // //             ),
// // //           );
// // //         },
// // //       ),
// // //     );
// // //   }
// // //
// // //   Widget _buildSectionHeader(String title) {
// // //     return Padding(
// // //       padding: const EdgeInsets.only(bottom: 12),
// // //       child: Text(
// // //         title,
// // //         style: TextStyle(
// // //           fontSize: 16,
// // //           fontWeight: FontWeight.bold,
// // //           color: Colors.grey.shade800,
// // //         ),
// // //       ),
// // //     );
// // //   }
// // // }
// //
// // import 'package:flutter/material.dart';
// // import 'package:provider/provider.dart';
// // import 'package:intl/intl.dart';
// // import '../../providers/tournament_provider.dart';
// // import '../../providers/match_provider.dart';
// // import '../../models/tournament_model.dart';
// // import '../../models/team_model.dart';
// //
// // class CreateTournamentMatchScreen extends StatefulWidget {
// //   final TournamentModel tournament;
// //
// //   const CreateTournamentMatchScreen({Key? key, required this.tournament})
// //       : super(key: key);
// //
// //   @override
// //   State<CreateTournamentMatchScreen> createState() =>
// //       _CreateTournamentMatchScreenState();
// // }
// //
// // class _CreateTournamentMatchScreenState
// //     extends State<CreateTournamentMatchScreen> {
// //   final _formKey = GlobalKey<FormState>();
// //   final TextEditingController _venueController = TextEditingController();
// //   final TextEditingController _roundController = TextEditingController();
// //
// //   String? _selectedTeamAId;
// //   String? _selectedTeamBId;
// //   String? _selectedGroup;
// //   late DateTime _matchDate;
// //   late TimeOfDay _matchTime;
// //   bool _isLoading = false;
// //
// //   @override
// //   void initState() {
// //     super.initState();
// //
// //     // Initialize date with tournament start date or today (whichever is later)
// //     final now = DateTime.now();
// //     final tournamentStart = widget.tournament.startDate;
// //
// //     if (now.isAfter(tournamentStart)) {
// //       _matchDate = now;
// //     } else {
// //       _matchDate = tournamentStart;
// //     }
// //
// //     _matchTime = TimeOfDay.now();
// //   }
// //
// //   @override
// //   void dispose() {
// //     _venueController.dispose();
// //     _roundController.dispose();
// //     super.dispose();
// //   }
// //
// //   Future<void> _selectDate() async {
// //     final DateTime now = DateTime.now();
// //     final DateTime firstDate = widget.tournament.startDate.isBefore(now)
// //         ? now
// //         : widget.tournament.startDate;
// //     final DateTime lastDate = widget.tournament.endDate;
// //
// //     DateTime initialDate = _matchDate;
// //     if (initialDate.isBefore(firstDate)) {
// //       initialDate = firstDate;
// //     } else if (initialDate.isAfter(lastDate)) {
// //       initialDate = lastDate;
// //     }
// //
// //     final DateTime? picked = await showDatePicker(
// //       context: context,
// //       initialDate: initialDate,
// //       firstDate: firstDate,
// //       lastDate: lastDate,
// //       builder: (context, child) {
// //         return Theme(
// //           data: Theme.of(context).copyWith(
// //             colorScheme: ColorScheme.light(
// //               primary: Colors.orange.shade700,
// //               onPrimary: Colors.white,
// //               surface: Colors.white,
// //               onSurface: Colors.black,
// //             ),
// //           ),
// //           child: child!,
// //         );
// //       },
// //     );
// //
// //     if (picked != null) {
// //       setState(() {
// //         _matchDate = DateTime(
// //           picked.year,
// //           picked.month,
// //           picked.day,
// //           _matchTime.hour,
// //           _matchTime.minute,
// //         );
// //       });
// //     }
// //   }
// //
// //   Future<void> _selectTime() async {
// //     final TimeOfDay? picked = await showTimePicker(
// //       context: context,
// //       initialTime: _matchTime,
// //       builder: (context, child) {
// //         return Theme(
// //           data: Theme.of(context).copyWith(
// //             colorScheme: ColorScheme.light(
// //               primary: Colors.orange.shade700,
// //               onPrimary: Colors.white,
// //               surface: Colors.white,
// //               onSurface: Colors.black,
// //             ),
// //           ),
// //           child: child!,
// //         );
// //       },
// //     );
// //
// //     if (picked != null) {
// //       setState(() {
// //         _matchTime = picked;
// //         _matchDate = DateTime(
// //           _matchDate.year,
// //           _matchDate.month,
// //           _matchDate.day,
// //           picked.hour,
// //           picked.minute,
// //         );
// //       });
// //     }
// //   }
// //
// //   Future<void> _createMatch() async {
// //     if (!_formKey.currentState!.validate()) return;
// //
// //     if (_selectedTeamAId == null || _selectedTeamBId == null) {
// //       ScaffoldMessenger.of(context).showSnackBar(
// //         const SnackBar(
// //           content: Text('দুটি টিম নির্বাচন করুন'),
// //           backgroundColor: Colors.red,
// //         ),
// //       );
// //       return;
// //     }
// //
// //     if (_selectedTeamAId == _selectedTeamBId) {
// //       ScaffoldMessenger.of(context).showSnackBar(
// //         const SnackBar(
// //           content: Text('দুটি ভিন্ন টিম নির্বাচন করুন'),
// //           backgroundColor: Colors.red,
// //         ),
// //       );
// //       return;
// //     }
// //
// //     setState(() => _isLoading = true);
// //
// //     final matchProvider = Provider.of<MatchProvider>(context, listen: false);
// //     final tournamentProvider =
// //     Provider.of<TournamentProvider>(context, listen: false);
// //
// //     TeamModel? teamA = matchProvider.teams
// //         .firstWhere((t) => t.teamId == _selectedTeamAId);
// //     TeamModel? teamB = matchProvider.teams
// //         .firstWhere((t) => t.teamId == _selectedTeamBId);
// //
// //     DateTime matchDateTime = DateTime(
// //       _matchDate.year,
// //       _matchDate.month,
// //       _matchDate.day,
// //       _matchTime.hour,
// //       _matchTime.minute,
// //     );
// //
// //     TournamentMatch match = TournamentMatch(
// //       tournamentId: widget.tournament.tournamentId!,
// //       teamAId: _selectedTeamAId!,
// //       teamBId: _selectedTeamBId!,
// //       teamAName: teamA.name,
// //       teamBName: teamB.name,
// //       teamALogo: teamA.logoUrl,
// //       teamBLogo: teamB.logoUrl,
// //       matchDate: matchDateTime,
// //       venue: _venueController.text.trim(),
// //       round: _roundController.text.trim(),
// //       groupName: _selectedGroup,
// //       createdAt: DateTime.now(),
// //     );
// //
// //     final error = await tournamentProvider.createTournamentMatch(
// //       match,
// //       'admin',
// //     );
// //
// //     setState(() => _isLoading = false);
// //
// //     if (error != null) {
// //       ScaffoldMessenger.of(context).showSnackBar(
// //         SnackBar(content: Text(error), backgroundColor: Colors.red),
// //       );
// //     } else {
// //       ScaffoldMessenger.of(context).showSnackBar(
// //         const SnackBar(
// //           content: Text('ম্যাচ সফলভাবে তৈরি হয়েছে'),
// //           backgroundColor: Colors.green,
// //         ),
// //       );
// //       Navigator.pop(context);
// //     }
// //   }
// //
// //   Widget _buildTeamLogo(String? logoUrl) {
// //     return Container(
// //       width: 28,
// //       height: 28,
// //       margin: const EdgeInsets.only(right: 10),
// //       decoration: BoxDecoration(
// //         color: Colors.grey.shade200,
// //         borderRadius: BorderRadius.circular(6),
// //       ),
// //       child: (logoUrl != null && logoUrl.isNotEmpty)
// //           ? ClipRRect(
// //         borderRadius: BorderRadius.circular(6),
// //         child: Image.network(
// //           logoUrl,
// //           width: 28,
// //           height: 28,
// //           fit: BoxFit.cover,
// //           errorBuilder: (context, error, stackTrace) {
// //             return Icon(
// //               Icons.shield,
// //               size: 18,
// //               color: Colors.grey.shade500,
// //             );
// //           },
// //         ),
// //       )
// //           : Icon(
// //         Icons.shield,
// //         size: 18,
// //         color: Colors.grey.shade500,
// //       ),
// //     );
// //   }
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     final DateFormat dateFormat = DateFormat('dd MMM yyyy');
// //
// //     return Scaffold(
// //       appBar: AppBar(
// //         title: const Text('নতুন ম্যাচ যোগ করুন'),
// //         flexibleSpace: Container(
// //           decoration: BoxDecoration(
// //             gradient: LinearGradient(
// //               colors: [Colors.orange.shade600, Colors.orange.shade800],
// //             ),
// //           ),
// //         ),
// //         foregroundColor: Colors.white,
// //       ),
// //       body: _isLoading
// //           ? const Center(child: CircularProgressIndicator())
// //           : Consumer2<TournamentProvider, MatchProvider>(
// //         builder: (context, tournamentProvider, matchProvider, child) {
// //           List<TeamModel> tournamentTeams = matchProvider.teams
// //               .where((t) => widget.tournament.teamIds.contains(t.teamId))
// //               .toList();
// //
// //           if (tournamentTeams.isEmpty) {
// //             return Center(
// //               child: Column(
// //                 mainAxisAlignment: MainAxisAlignment.center,
// //                 children: [
// //                   Icon(Icons.info_outline,
// //                       size: 80, color: Colors.grey.shade300),
// //                   const SizedBox(height: 16),
// //                   Text(
// //                     'কোন টিম পাওয়া যায়নি',
// //                     style: TextStyle(
// //                       fontSize: 18,
// //                       color: Colors.grey.shade600,
// //                     ),
// //                   ),
// //                   const SizedBox(height: 8),
// //                   Text(
// //                     'প্রথমে টুর্নামেন্টে টিম যোগ করুন',
// //                     style: TextStyle(
// //                       fontSize: 14,
// //                       color: Colors.grey.shade500,
// //                     ),
// //                   ),
// //                 ],
// //               ),
// //             );
// //           }
// //
// //           return Form(
// //             key: _formKey,
// //             child: ListView(
// //               padding: const EdgeInsets.all(16),
// //               children: [
// //                 if (tournamentProvider.groups.isNotEmpty) ...[
// //                   _buildSectionHeader('গ্রুপ নির্বাচন করুন (ঐচ্ছিক)'),
// //                   DropdownButtonFormField<String>(
// //                     value: _selectedGroup,
// //                     decoration: InputDecoration(
// //                       hintText: 'গ্রুপ বা নকআউট রাউন্ড',
// //                       prefixIcon: const Icon(Icons.workspaces),
// //                       border: OutlineInputBorder(
// //                         borderRadius: BorderRadius.circular(12),
// //                       ),
// //                     ),
// //                     items: [
// //                       const DropdownMenuItem(
// //                         value: null,
// //                         child: Text('নকআউট/ফাইনাল'),
// //                       ),
// //                       ...tournamentProvider.groups.map((group) {
// //                         return DropdownMenuItem(
// //                           value: group.groupName,
// //                           child: Text(group.groupName),
// //                         );
// //                       }).toList(),
// //                     ],
// //                     onChanged: (value) {
// //                       setState(() => _selectedGroup = value);
// //                     },
// //                   ),
// //                   const SizedBox(height: 20),
// //                 ],
// //
// //                 _buildSectionHeader('রাউন্ড/পর্ব'),
// //                 TextFormField(
// //                   controller: _roundController,
// //                   decoration: InputDecoration(
// //                     hintText: 'যেমন: Group A,Match Day 1, Semi Final',
// //                     prefixIcon: const Icon(Icons.sports),
// //                     border: OutlineInputBorder(
// //                       borderRadius: BorderRadius.circular(12),
// //                     ),
// //                   ),
// //                   validator: (value) {
// //                     if (value == null || value.trim().isEmpty) {
// //                       return 'রাউন্ড/পর্ব দিন';
// //                     }
// //                     return null;
// //                   },
// //                 ),
// //                 const SizedBox(height: 20),
// //
// //                 _buildSectionHeader('টিম A'),
// //                 DropdownButtonFormField<String>(
// //                   value: _selectedTeamAId,
// //                   decoration: InputDecoration(
// //                     hintText: 'টিম নির্বাচন করুন',
// //                     prefixIcon: const Icon(Icons.shield),
// //                     border: OutlineInputBorder(
// //                       borderRadius: BorderRadius.circular(12),
// //                     ),
// //                   ),
// //                   items: tournamentTeams.map((team) {
// //                     return DropdownMenuItem(
// //                       value: team.teamId,
// //                       child: Row(
// //                         children: [
// //                           _buildTeamLogo(team.logoUrl),
// //                           Expanded(
// //                             child: Text(
// //                               team.name,
// //                               overflow: TextOverflow.ellipsis,
// //                               style: const TextStyle(fontSize: 15),
// //                             ),
// //                           ),
// //                         ],
// //                       ),
// //                     );
// //                   }).toList(),
// //                   onChanged: (value) {
// //                     setState(() => _selectedTeamAId = value);
// //                   },
// //                   validator: (value) {
// //                     if (value == null) return 'টিম নির্বাচন করুন';
// //                     return null;
// //                   },
// //                 ),
// //                 const SizedBox(height: 20),
// //
// //                 _buildSectionHeader('টিম B'),
// //                 DropdownButtonFormField<String>(
// //                   value: _selectedTeamBId,
// //                   decoration: InputDecoration(
// //                     hintText: 'টিম নির্বাচন করুন',
// //                     prefixIcon: const Icon(Icons.shield),
// //                     border: OutlineInputBorder(
// //                       borderRadius: BorderRadius.circular(12),
// //                     ),
// //                   ),
// //                   items: tournamentTeams.map((team) {
// //                     return DropdownMenuItem(
// //                       value: team.teamId,
// //                       child: Row(
// //                         children: [
// //                           _buildTeamLogo(team.logoUrl),
// //                           Expanded(
// //                             child: Text(
// //                               team.name,
// //                               overflow: TextOverflow.ellipsis,
// //                               style: const TextStyle(fontSize: 15),
// //                             ),
// //                           ),
// //                         ],
// //                       ),
// //                     );
// //                   }).toList(),
// //                   onChanged: (value) {
// //                     setState(() => _selectedTeamBId = value);
// //                   },
// //                   validator: (value) {
// //                     if (value == null) return 'টিম নির্বাচন করুন';
// //                     return null;
// //                   },
// //                 ),
// //                 const SizedBox(height: 20),
// //
// //                 _buildSectionHeader('তারিখ এবং সময়'),
// //                 Row(
// //                   children: [
// //                     Expanded(
// //                       child: InkWell(
// //                         onTap: _selectDate,
// //                         child: Container(
// //                           padding: const EdgeInsets.all(16),
// //                           decoration: BoxDecoration(
// //                             border:
// //                             Border.all(color: Colors.grey.shade300),
// //                             borderRadius: BorderRadius.circular(12),
// //                           ),
// //                           child: Row(
// //                             children: [
// //                               Icon(Icons.calendar_today,
// //                                   color: Colors.orange.shade700),
// //                               const SizedBox(width: 12),
// //                               Expanded(
// //                                 child: Text(
// //                                   dateFormat.format(_matchDate),
// //                                   style: const TextStyle(
// //                                     fontSize: 15,
// //                                     fontWeight: FontWeight.w600,
// //                                   ),
// //                                 ),
// //                               ),
// //                             ],
// //                           ),
// //                         ),
// //                       ),
// //                     ),
// //                     const SizedBox(width: 12),
// //                     Expanded(
// //                       child: InkWell(
// //                         onTap: _selectTime,
// //                         child: Container(
// //                           padding: const EdgeInsets.all(16),
// //                           decoration: BoxDecoration(
// //                             border:
// //                             Border.all(color: Colors.grey.shade300),
// //                             borderRadius: BorderRadius.circular(12),
// //                           ),
// //                           child: Row(
// //                             children: [
// //                               Icon(Icons.access_time,
// //                                   color: Colors.orange.shade700),
// //                               const SizedBox(width: 12),
// //                               Expanded(
// //                                 child: Text(
// //                                   _matchTime.format(context),
// //                                   style: const TextStyle(
// //                                     fontSize: 15,
// //                                     fontWeight: FontWeight.w600,
// //                                   ),
// //                                 ),
// //                               ),
// //                             ],
// //                           ),
// //                         ),
// //                       ),
// //                     ),
// //                   ],
// //                 ),
// //                 const SizedBox(height: 20),
// //
// //                 _buildSectionHeader('স্থান'),
// //                 TextFormField(
// //                   controller: _venueController,
// //                   decoration: InputDecoration(
// //                     hintText: 'যেমন: ঢাকা স্টেডিয়াম',
// //                     prefixIcon: const Icon(Icons.location_on),
// //                     border: OutlineInputBorder(
// //                       borderRadius: BorderRadius.circular(12),
// //                     ),
// //                   ),
// //                   validator: (value) {
// //                     if (value == null || value.trim().isEmpty) {
// //                       return 'স্থান দিন';
// //                     }
// //                     return null;
// //                   },
// //                 ),
// //                 const SizedBox(height: 30),
// //
// //                 ElevatedButton(
// //                   onPressed: _createMatch,
// //                   style: ElevatedButton.styleFrom(
// //                     backgroundColor: Colors.orange.shade700,
// //                     minimumSize: const Size(double.infinity, 55),
// //                     shape: RoundedRectangleBorder(
// //                       borderRadius: BorderRadius.circular(12),
// //                     ),
// //                   ),
// //                   child: const Text(
// //                     'ম্যাচ তৈরি করুন',
// //                     style: TextStyle(
// //                       fontSize: 18,
// //                       fontWeight: FontWeight.bold,
// //                       color: Colors.white,
// //                     ),
// //                   ),
// //                 ),
// //                 const SizedBox(height: 20),
// //               ],
// //             ),
// //           );
// //         },
// //       ),
// //     );
// //   }
// //
// //   Widget _buildSectionHeader(String title) {
// //     return Padding(
// //       padding: const EdgeInsets.only(bottom: 12),
// //       child: Text(
// //         title,
// //         style: TextStyle(
// //           fontSize: 16,
// //           fontWeight: FontWeight.bold,
// //           color: Colors.grey.shade800,
// //         ),
// //       ),
// //     );
// //   }
// // }
//
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:intl/intl.dart';
// import '../../providers/tournament_provider.dart';
// import '../../providers/match_provider.dart';
// import '../../models/tournament_model.dart';
// import '../../models/team_model.dart';
//
// class CreateTournamentMatchScreen extends StatefulWidget {
//   final TournamentModel tournament;
//
//   const CreateTournamentMatchScreen({Key? key, required this.tournament})
//       : super(key: key);
//
//   @override
//   State<CreateTournamentMatchScreen> createState() =>
//       _CreateTournamentMatchScreenState();
// }
//
// class _CreateTournamentMatchScreenState
//     extends State<CreateTournamentMatchScreen> {
//   final _formKey = GlobalKey<FormState>();
//   final TextEditingController _venueController = TextEditingController();
//   final TextEditingController _roundController = TextEditingController();
//
//   String? _selectedTeamAId;
//   String? _selectedTeamBId;
//   String? _selectedGroup;
//   late DateTime _matchDate;
//   late TimeOfDay _matchTime;
//   bool _isLoading = false;
//   bool _isInitializing = true;
//
//   @override
//   void initState() {
//     super.initState();
//
//     final now = DateTime.now();
//     final tournamentStart = widget.tournament.startDate;
//
//     if (now.isAfter(tournamentStart)) {
//       _matchDate = now;
//     } else {
//       _matchDate = tournamentStart;
//     }
//
//     _matchTime = TimeOfDay.now();
//
//     // Load data
//     WidgetsBinding.instance.addPostFrameCallback((_) async {
//       try {
//         final tournamentProvider =
//         Provider.of<TournamentProvider>(context, listen: false);
//         final matchProvider =
//         Provider.of<MatchProvider>(context, listen: false);
//
//         await Future.wait([
//           tournamentProvider
//               .loadTournamentGroups(widget.tournament.tournamentId!),
//           matchProvider.loadTeams(),
//         ]);
//
//         if (mounted) {
//           setState(() {
//             _isInitializing = false;
//           });
//         }
//       } catch (e) {
//         print('Error loading data: $e');
//         if (mounted) {
//           setState(() {
//             _isInitializing = false;
//           });
//         }
//       }
//     });
//   }
//
//   @override
//   void dispose() {
//     _venueController.dispose();
//     _roundController.dispose();
//     super.dispose();
//   }
//
//   Future<void> _selectDate() async {
//     final DateTime now = DateTime.now();
//     final DateTime firstDate = widget.tournament.startDate.isBefore(now)
//         ? now
//         : widget.tournament.startDate;
//     final DateTime lastDate = widget.tournament.endDate;
//
//     DateTime initialDate = _matchDate;
//     if (initialDate.isBefore(firstDate)) {
//       initialDate = firstDate;
//     } else if (initialDate.isAfter(lastDate)) {
//       initialDate = lastDate;
//     }
//
//     final DateTime? picked = await showDatePicker(
//       context: context,
//       initialDate: initialDate,
//       firstDate: firstDate,
//       lastDate: lastDate,
//       builder: (context, child) {
//         return Theme(
//           data: Theme.of(context).copyWith(
//             colorScheme: ColorScheme.light(
//               primary: Colors.orange.shade700,
//               onPrimary: Colors.white,
//               surface: Colors.white,
//               onSurface: Colors.black,
//             ),
//           ),
//           child: child!,
//         );
//       },
//     );
//
//     if (picked != null) {
//       setState(() {
//         _matchDate = DateTime(
//           picked.year,
//           picked.month,
//           picked.day,
//           _matchTime.hour,
//           _matchTime.minute,
//         );
//       });
//     }
//   }
//
//   Future<void> _selectTime() async {
//     final TimeOfDay? picked = await showTimePicker(
//       context: context,
//       initialTime: _matchTime,
//       builder: (context, child) {
//         return Theme(
//           data: Theme.of(context).copyWith(
//             colorScheme: ColorScheme.light(
//               primary: Colors.orange.shade700,
//               onPrimary: Colors.white,
//               surface: Colors.white,
//               onSurface: Colors.black,
//             ),
//           ),
//           child: child!,
//         );
//       },
//     );
//
//     if (picked != null) {
//       setState(() {
//         _matchTime = picked;
//         _matchDate = DateTime(
//           _matchDate.year,
//           _matchDate.month,
//           _matchDate.day,
//           picked.hour,
//           picked.minute,
//         );
//       });
//     }
//   }
//
//   Future<void> _createMatch() async {
//     if (!_formKey.currentState!.validate()) return;
//
//     if (_selectedTeamAId == null || _selectedTeamBId == null) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(
//           content: Text('দুটি টিম নির্বাচন করুন'),
//           backgroundColor: Colors.red,
//         ),
//       );
//       return;
//     }
//
//     if (_selectedTeamAId == _selectedTeamBId) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(
//           content: Text('দুটি ভিন্ন টিম নির্বাচন করুন'),
//           backgroundColor: Colors.red,
//         ),
//       );
//       return;
//     }
//
//     setState(() => _isLoading = true);
//
//     try {
//       final matchProvider = Provider.of<MatchProvider>(context, listen: false);
//       final tournamentProvider =
//       Provider.of<TournamentProvider>(context, listen: false);
//
//       TeamModel? teamA =
//       matchProvider.teams.firstWhere((t) => t.teamId == _selectedTeamAId);
//       TeamModel? teamB =
//       matchProvider.teams.firstWhere((t) => t.teamId == _selectedTeamBId);
//
//       DateTime matchDateTime = DateTime(
//         _matchDate.year,
//         _matchDate.month,
//         _matchDate.day,
//         _matchTime.hour,
//         _matchTime.minute,
//       );
//
//       TournamentMatch match = TournamentMatch(
//         tournamentId: widget.tournament.tournamentId!,
//         teamAId: _selectedTeamAId!,
//         teamBId: _selectedTeamBId!,
//         teamAName: teamA.name,
//         teamBName: teamB.name,
//         teamALogo: teamA.logoUrl,
//         teamBLogo: teamB.logoUrl,
//         matchDate: matchDateTime,
//         venue: _venueController.text.trim(),
//         round: _roundController.text.trim(),
//         groupName: _selectedGroup,
//         createdAt: DateTime.now(),
//       );
//
//       final error = await tournamentProvider.createTournamentMatch(
//         match,
//         'admin',
//       );
//
//       setState(() => _isLoading = false);
//
//       if (error != null) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text(error), backgroundColor: Colors.red),
//         );
//       } else {
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(
//             content: Text('ম্যাচ সফলভাবে তৈরি হয়েছে'),
//             backgroundColor: Colors.green,
//           ),
//         );
//         Navigator.pop(context);
//       }
//     } catch (e) {
//       setState(() => _isLoading = false);
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text('Error: $e'),
//           backgroundColor: Colors.red,
//         ),
//       );
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final DateFormat dateFormat = DateFormat('dd MMM yyyy');
//
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('নতুন ম্যাচ যোগ করুন'),
//         flexibleSpace: Container(
//           decoration: BoxDecoration(
//             gradient: LinearGradient(
//               colors: [Colors.orange.shade600, Colors.orange.shade800],
//             ),
//           ),
//         ),
//         foregroundColor: Colors.white,
//       ),
//       body: _isInitializing
//           ? const Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             CircularProgressIndicator(),
//             SizedBox(height: 16),
//             Text('ডেটা লোড হচ্ছে...'),
//           ],
//         ),
//       )
//           : _isLoading
//           ? const Center(child: CircularProgressIndicator())
//           : Consumer2<TournamentProvider, MatchProvider>(
//         builder: (context, tournamentProvider, matchProvider, child) {
//           // Filter valid teams only
//           List<TeamModel> tournamentTeams = matchProvider.teams
//               .where((t) =>
//           t.teamId != null &&
//               widget.tournament.teamIds.contains(t.teamId))
//               .toList();
//
//           if (tournamentTeams.isEmpty) {
//             return Center(
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   Icon(Icons.info_outline,
//                       size: 80, color: Colors.grey.shade300),
//                   const SizedBox(height: 16),
//                   Text(
//                     'কোন টিম পাওয়া যায়নি',
//                     style: TextStyle(
//                       fontSize: 18,
//                       color: Colors.grey.shade600,
//                     ),
//                   ),
//                   const SizedBox(height: 8),
//                   Text(
//                     'প্রথমে টুর্নামেন্টে টিম যোগ করুন',
//                     style: TextStyle(
//                       fontSize: 14,
//                       color: Colors.grey.shade500,
//                     ),
//                   ),
//                 ],
//               ),
//             );
//           }
//
//           return Form(
//             key: _formKey,
//             child: ListView(
//               padding: const EdgeInsets.all(16),
//               children: [
//                 if (tournamentProvider.groups.isNotEmpty) ...[
//                   _buildSectionHeader('গ্রুপ নির্বাচন করুন (ঐচ্ছিক)'),
//                   DropdownButtonFormField<String>(
//                     value: _selectedGroup,
//                     decoration: InputDecoration(
//                       hintText: 'গ্রুপ বা নকআউট রাউন্ড',
//                       prefixIcon: const Icon(Icons.workspaces),
//                       border: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(12),
//                       ),
//                     ),
//                     items: [
//                       const DropdownMenuItem(
//                         value: null,
//                         child: Text('নকআউট/ফাইনাল'),
//                       ),
//                       ...tournamentProvider.groups.map((group) {
//                         return DropdownMenuItem(
//                           value: group.groupName,
//                           child: Text(group.groupName),
//                         );
//                       }).toList(),
//                     ],
//                     onChanged: (value) {
//                       setState(() => _selectedGroup = value);
//                     },
//                   ),
//                   const SizedBox(height: 20),
//                 ],
//
//                 _buildSectionHeader('রাউন্ড/পর্ব'),
//                 TextFormField(
//                   controller: _roundController,
//                   decoration: InputDecoration(
//                     hintText:
//                     'যেমন: Group A,Match Day 1, Semi Final',
//                     prefixIcon: const Icon(Icons.sports),
//                     border: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(12),
//                     ),
//                   ),
//                   validator: (value) {
//                     if (value == null || value.trim().isEmpty) {
//                       return 'রাউন্ড/পর্ব দিন';
//                     }
//                     return null;
//                   },
//                 ),
//                 const SizedBox(height: 20),
//
//                 // Team A - Simple version without logo
//                 _buildSectionHeader('টিম A'),
//                 DropdownButtonFormField<String>(
//                   value: _selectedTeamAId,
//                   decoration: InputDecoration(
//                     hintText: 'টিম নির্বাচন করুন',
//                     prefixIcon: const Icon(Icons.shield),
//                     border: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(12),
//                     ),
//                   ),
//                   items: tournamentTeams.map((team) {
//                     return DropdownMenuItem(
//                       value: team.teamId,
//                       child: Text(
//                         team.name,
//                         overflow: TextOverflow.ellipsis,
//                       ),
//                     );
//                   }).toList(),
//                   onChanged: (value) {
//                     setState(() => _selectedTeamAId = value);
//                   },
//                   validator: (value) {
//                     if (value == null) return 'টিম নির্বাচন করুন';
//                     return null;
//                   },
//                 ),
//                 const SizedBox(height: 20),
//
//                 // Team B - Simple version without logo
//                 _buildSectionHeader('টিম B'),
//                 DropdownButtonFormField<String>(
//                   value: _selectedTeamBId,
//                   decoration: InputDecoration(
//                     hintText: 'টিম নির্বাচন করুন',
//                     prefixIcon: const Icon(Icons.shield),
//                     border: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(12),
//                     ),
//                   ),
//                   items: tournamentTeams.map((team) {
//                     return DropdownMenuItem(
//                       value: team.teamId,
//                       child: Text(
//                         team.name,
//                         overflow: TextOverflow.ellipsis,
//                       ),
//                     );
//                   }).toList(),
//                   onChanged: (value) {
//                     setState(() => _selectedTeamBId = value);
//                   },
//                   validator: (value) {
//                     if (value == null) return 'টিম নির্বাচন করুন';
//                     return null;
//                   },
//                 ),
//                 const SizedBox(height: 20),
//
//                 _buildSectionHeader('তারিখ এবং সময়'),
//                 Row(
//                   children: [
//                     Expanded(
//                       child: InkWell(
//                         onTap: _selectDate,
//                         child: Container(
//                           padding: const EdgeInsets.all(16),
//                           decoration: BoxDecoration(
//                             border: Border.all(
//                                 color: Colors.grey.shade300),
//                             borderRadius: BorderRadius.circular(12),
//                           ),
//                           child: Row(
//                             children: [
//                               Icon(Icons.calendar_today,
//                                   color: Colors.orange.shade700),
//                               const SizedBox(width: 12),
//                               Expanded(
//                                 child: Text(
//                                   dateFormat.format(_matchDate),
//                                   style: const TextStyle(
//                                     fontSize: 15,
//                                     fontWeight: FontWeight.w600,
//                                   ),
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                       ),
//                     ),
//                     const SizedBox(width: 12),
//                     Expanded(
//                       child: InkWell(
//                         onTap: _selectTime,
//                         child: Container(
//                           padding: const EdgeInsets.all(16),
//                           decoration: BoxDecoration(
//                             border: Border.all(
//                                 color: Colors.grey.shade300),
//                             borderRadius: BorderRadius.circular(12),
//                           ),
//                           child: Row(
//                             children: [
//                               Icon(Icons.access_time,
//                                   color: Colors.orange.shade700),
//                               const SizedBox(width: 12),
//                               Expanded(
//                                 child: Text(
//                                   _matchTime.format(context),
//                                   style: const TextStyle(
//                                     fontSize: 15,
//                                     fontWeight: FontWeight.w600,
//                                   ),
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//                 const SizedBox(height: 20),
//
//                 _buildSectionHeader('স্থান'),
//                 TextFormField(
//                   controller: _venueController,
//                   decoration: InputDecoration(
//                     hintText: 'যেমন: ঢাকা স্টেডিয়াম',
//                     prefixIcon: const Icon(Icons.location_on),
//                     border: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(12),
//                     ),
//                   ),
//                   validator: (value) {
//                     if (value == null || value.trim().isEmpty) {
//                       return 'স্থান দিন';
//                     }
//                     return null;
//                   },
//                 ),
//                 const SizedBox(height: 30),
//
//                 ElevatedButton(
//                   onPressed: _createMatch,
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: Colors.orange.shade700,
//                     minimumSize: const Size(double.infinity, 55),
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(12),
//                     ),
//                   ),
//                   child: const Text(
//                     'ম্যাচ তৈরি করুন',
//                     style: TextStyle(
//                       fontSize: 18,
//                       fontWeight: FontWeight.bold,
//                       color: Colors.white,
//                     ),
//                   ),
//                 ),
//                 const SizedBox(height: 20),
//               ],
//             ),
//           );
//         },
//       ),
//     );
//   }
//
//   Widget _buildSectionHeader(String title) {
//     return Padding(
//       padding: const EdgeInsets.only(bottom: 12),
//       child: Text(
//         title,
//         style: TextStyle(
//           fontSize: 16,
//           fontWeight: FontWeight.bold,
//           color: Colors.grey.shade800,
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../providers/tournament_provider.dart';
import '../../providers/match_provider.dart';
import '../../models/tournament_model.dart';
import '../../models/team_model.dart';

class CreateTournamentMatchScreen extends StatefulWidget {
  final TournamentModel tournament;

  const CreateTournamentMatchScreen({Key? key, required this.tournament})
      : super(key: key);

  @override
  State<CreateTournamentMatchScreen> createState() =>
      _CreateTournamentMatchScreenState();
}

class _CreateTournamentMatchScreenState
    extends State<CreateTournamentMatchScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _venueController = TextEditingController();
  final TextEditingController _roundController = TextEditingController();

  String? _selectedTeamAId;
  String? _selectedTeamBId;
  String? _selectedGroup;
  late DateTime _matchDate;
  late TimeOfDay _matchTime;
  bool _isLoading = false;
  bool _isInitializing = true;

  @override
  void initState() {
    super.initState();

    final now = DateTime.now();
    final tournamentStart = widget.tournament.startDate;

    if (now.isAfter(tournamentStart)) {
      _matchDate = now;
    } else {
      _matchDate = tournamentStart;
    }

    _matchTime = TimeOfDay.now();

    // Load data
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      try {
        final tournamentProvider =
        Provider.of<TournamentProvider>(context, listen: false);
        final matchProvider =
        Provider.of<MatchProvider>(context, listen: false);

        await Future.wait([
          tournamentProvider
              .loadTournamentGroups(widget.tournament.tournamentId!),
          matchProvider.loadTeams(),
        ]);

        if (mounted) {
          setState(() {
            _isInitializing = false;
          });
        }
      } catch (e) {
        debugPrint('Error loading data: $e');
        if (mounted) {
          setState(() {
            _isInitializing = false;
          });
        }
      }
    });
  }

  @override
  void dispose() {
    _venueController.dispose();
    _roundController.dispose();
    super.dispose();
  }

  // ✅ Get teams based on selected group
  List<TeamModel> _getFilteredTeams(
      TournamentProvider tournamentProvider, List<TeamModel> allTeams) {
    // If no group selected, return all tournament teams
    if (_selectedGroup == null) {
      return allTeams
          .where((t) => widget.tournament.teamIds.contains(t.id))  // ✅ Changed from teamId
          .toList();
    }

    // Find the selected group
    TournamentGroup? selectedGroupData = tournamentProvider.groups
        .firstWhere((g) => g.groupName == _selectedGroup,
        orElse: () => TournamentGroup(
          tournamentId: widget.tournament.tournamentId!,
          groupName: '',
          teamIds: [],
          groupOrder: 0,
        ));

    // Return only teams in the selected group
    return allTeams
        .where((t) => selectedGroupData.teamIds.contains(t.id))  // ✅ Changed from teamId
        .toList();
  }

  Future<void> _selectDate() async {
    final DateTime now = DateTime.now();
    final DateTime firstDate = widget.tournament.startDate.isBefore(now)
        ? now
        : widget.tournament.startDate;
    final DateTime lastDate = widget.tournament.endDate;

    DateTime initialDate = _matchDate;
    if (initialDate.isBefore(firstDate)) {
      initialDate = firstDate;
    } else if (initialDate.isAfter(lastDate)) {
      initialDate = lastDate;
    }

    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: firstDate,
      lastDate: lastDate,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: Colors.orange.shade700,
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: Colors.black,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        _matchDate = DateTime(
          picked.year,
          picked.month,
          picked.day,
          _matchTime.hour,
          _matchTime.minute,
        );
      });
    }
  }

  Future<void> _selectTime() async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _matchTime,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: Colors.orange.shade700,
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: Colors.black,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        _matchTime = picked;
        _matchDate = DateTime(
          _matchDate.year,
          _matchDate.month,
          _matchDate.day,
          picked.hour,
          picked.minute,
        );
      });
    }
  }

  Future<void> _createMatch() async {
    if (!_formKey.currentState!.validate()) return;

    if (_selectedTeamAId == null || _selectedTeamBId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('দুটি টিম নির্বাচন করুন'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    if (_selectedTeamAId == _selectedTeamBId) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('দুটি ভিন্ন টিম নির্বাচন করুন'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final matchProvider = Provider.of<MatchProvider>(context, listen: false);
      final tournamentProvider =
      Provider.of<TournamentProvider>(context, listen: false);

      TeamModel? teamA =
      matchProvider.teams.firstWhere((t) => t.id == _selectedTeamAId);  // ✅ Changed from teamId
      TeamModel? teamB =
      matchProvider.teams.firstWhere((t) => t.id == _selectedTeamBId);  // ✅ Changed from teamId

      DateTime matchDateTime = DateTime(
        _matchDate.year,
        _matchDate.month,
        _matchDate.day,
        _matchTime.hour,
        _matchTime.minute,
      );

      TournamentMatch match = TournamentMatch(
        tournamentId: widget.tournament.tournamentId!,
        teamAId: _selectedTeamAId!,
        teamBId: _selectedTeamBId!,
        teamAName: teamA.name,
        teamBName: teamB.name,
        teamALogo: teamA.logoUrl,
        teamBLogo: teamB.logoUrl,
        matchDate: matchDateTime,
        venue: _venueController.text.trim(),
        round: _roundController.text.trim(),
        groupName: _selectedGroup,
        createdAt: DateTime.now(),
      );

      final error = await tournamentProvider.createTournamentMatch(
        match,
        'admin',
      );

      setState(() => _isLoading = false);

      if (error != null) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(error), backgroundColor: Colors.red),
        );
      } else {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('ম্যাচ সফলভাবে তৈরি হয়েছে'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      setState(() => _isLoading = false);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final DateFormat dateFormat = DateFormat('dd MMM yyyy');

    return Scaffold(
      appBar: AppBar(
        title: const Text('নতুন ম্যাচ যোগ করুন'),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.orange.shade600, Colors.orange.shade800],
            ),
          ),
        ),
        foregroundColor: Colors.white,
      ),
      body: _isInitializing
          ? const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text('ডেটা লোড হচ্ছে...'),
          ],
        ),
      )
          : _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Consumer2<TournamentProvider, MatchProvider>(
        builder: (context, tournamentProvider, matchProvider, child) {
          // Get filtered teams based on selected group
          List<TeamModel> filteredTeams = _getFilteredTeams(
              tournamentProvider, matchProvider.teams);

          return Form(
            key: _formKey,
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                if (tournamentProvider.groups.isNotEmpty) ...[
                  _buildSectionHeader('গ্রুপ নির্বাচন করুন (ঐচ্ছিক)'),
                  DropdownButtonFormField<String>(
                    value: _selectedGroup,
                    decoration: InputDecoration(
                      hintText: 'গ্রুপ বা নকআউট রাউন্ড',
                      prefixIcon: const Icon(Icons.workspaces),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    items: [
                      const DropdownMenuItem(
                        value: null,
                        child: Text('সব টিম (নকআউট/ফাইনাল)'),
                      ),
                      ...tournamentProvider.groups.map((group) {
                        return DropdownMenuItem(
                          value: group.groupName,
                          child: Text(
                              '${group.groupName} (${group.teamIds.length} টিম)'),
                        );
                      }).toList(),
                    ],
                    onChanged: (value) {
                      setState(() {
                        _selectedGroup = value;
                        // ✅ Reset team selection when group changes
                        _selectedTeamAId = null;
                        _selectedTeamBId = null;
                      });
                    },
                  ),
                  const SizedBox(height: 20),
                ],

                _buildSectionHeader('রাউন্ড/পর্ব'),
                TextFormField(
                  controller: _roundController,
                  decoration: InputDecoration(
                    hintText:
                    'যেমন: Group A,Match Day 1, Semi Final',
                    prefixIcon: const Icon(Icons.sports),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'রাউন্ড/পর্ব দিন';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),

                // Show team count info
                if (_selectedGroup != null)
                  Container(
                    padding: const EdgeInsets.all(12),
                    margin: const EdgeInsets.only(bottom: 20),
                    decoration: BoxDecoration(
                      color: Colors.orange.shade50,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                          color: Colors.orange.shade200),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.info_outline,
                            color: Colors.orange.shade700,
                            size: 20),
                        const SizedBox(width: 8),
                        Text(
                          '$_selectedGroup এ ${filteredTeams.length} টি টিম আছে',
                          style: TextStyle(
                            color: Colors.orange.shade900,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),

                // Team A
                _buildSectionHeader('টিম A'),
                DropdownButtonFormField<String>(
                  value: _selectedTeamAId,
                  decoration: InputDecoration(
                    hintText: filteredTeams.isEmpty
                        ? 'কোন টিম নেই'
                        : 'টিম নির্বাচন করুন',
                    prefixIcon: const Icon(Icons.shield),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  items: filteredTeams.map((team) {
                    return DropdownMenuItem(
                      value: team.id,  // ✅ Changed from teamId
                      child: Text(
                        team.name,
                        overflow: TextOverflow.ellipsis,
                      ),
                    );
                  }).toList(),
                  onChanged: filteredTeams.isEmpty
                      ? null
                      : (value) {
                    setState(() => _selectedTeamAId = value);
                  },
                  validator: (value) {
                    if (value == null) return 'টিম নির্বাচন করুন';
                    return null;
                  },
                ),
                const SizedBox(height: 20),

                // Team B
                _buildSectionHeader('টিম B'),
                DropdownButtonFormField<String>(
                  value: _selectedTeamBId,
                  decoration: InputDecoration(
                    hintText: filteredTeams.isEmpty
                        ? 'কোন টিম নেই'
                        : 'টিম নির্বাচন করুন',
                    prefixIcon: const Icon(Icons.shield),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  items: filteredTeams.map((team) {
                    return DropdownMenuItem(
                      value: team.id,  // ✅ Changed from teamId
                      child: Text(
                        team.name,
                        overflow: TextOverflow.ellipsis,
                      ),
                    );
                  }).toList(),
                  onChanged: filteredTeams.isEmpty
                      ? null
                      : (value) {
                    setState(() => _selectedTeamBId = value);
                  },
                  validator: (value) {
                    if (value == null) return 'টিম নির্বাচন করুন';
                    return null;
                  },
                ),
                const SizedBox(height: 20),

                _buildSectionHeader('তারিখ এবং সময়'),
                Row(
                  children: [
                    Expanded(
                      child: InkWell(
                        onTap: _selectDate,
                        child: Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            border: Border.all(
                                color: Colors.grey.shade300),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            children: [
                              Icon(Icons.calendar_today,
                                  color: Colors.orange.shade700),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  dateFormat.format(_matchDate),
                                  style: const TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: InkWell(
                        onTap: _selectTime,
                        child: Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            border: Border.all(
                                color: Colors.grey.shade300),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            children: [
                              Icon(Icons.access_time,
                                  color: Colors.orange.shade700),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  _matchTime.format(context),
                                  style: const TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                _buildSectionHeader('স্থান'),
                TextFormField(
                  controller: _venueController,
                  decoration: InputDecoration(
                    hintText: 'যেমন: ঢাকা স্টেডিয়াম',
                    prefixIcon: const Icon(Icons.location_on),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'স্থান দিন';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 30),

                ElevatedButton(
                  onPressed: filteredTeams.length < 2
                      ? null
                      : _createMatch,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange.shade700,
                    disabledBackgroundColor: Colors.grey.shade300,
                    minimumSize: const Size(double.infinity, 55),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    filteredTeams.length < 2
                        ? 'অন্তত ২টি টিম দরকার'
                        : 'ম্যাচ তৈরি করুন',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: filteredTeams.length < 2
                          ? Colors.grey.shade600
                          : Colors.white,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Colors.grey.shade800,
        ),
      ),
    );
  }
}