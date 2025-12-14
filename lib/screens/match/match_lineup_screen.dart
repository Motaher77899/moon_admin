// // import 'package:flutter/material.dart';
// // import 'package:provider/provider.dart';
// // import '../../providers/match_provider.dart';
// // import '../../models/match_model.dart';
// // import '../../models/player_model.dart';
// //
// // class MatchLineupScreen extends StatefulWidget {
// //   final MatchModel match;
// //   final VoidCallback onUpdate;
// //
// //   const MatchLineupScreen({
// //     Key? key,
// //     required this.match,
// //     required this.onUpdate,
// //   }) : super(key: key);
// //
// //   @override
// //   State<MatchLineupScreen> createState() => _MatchLineupScreenState();
// // }
// //
// // class _MatchLineupScreenState extends State<MatchLineupScreen> {
// //   String _selectedTeam = 'teamA';
// //   List<PlayerModel> _teamPlayers = [];
// //   List<PlayerLineUp> _selectedPlayers = [];
// //   bool _isLoading = false;
// //   bool _isEditMode = false;
// //
// //   @override
// //   void initState() {
// //     super.initState();
// //     _loadPlayers();
// //   }
// //
// //   Future<void> _loadPlayers() async {
// //     setState(() => _isLoading = true);
// //     final matchProvider = Provider.of<MatchProvider>(context, listen: false);
// //
// //     String teamId = _selectedTeam == 'teamA'
// //         ? widget.match.teamAId
// //         : widget.match.teamBId;
// //
// //     _teamPlayers = await matchProvider.loadPlayersByTeam(teamId);
// //
// //     // Load existing lineup
// //     LineUp? lineup = _selectedTeam == 'teamA'
// //         ? widget.match.lineUpA
// //         : widget.match.lineUpB;
// //
// //     // ✅ Fixed: সঠিকভাবে lineup players load করা হচ্ছে
// //     if (lineup != null && lineup.players.isNotEmpty) {
// //       _selectedPlayers = List<PlayerLineUp>.from(lineup.players);
// //     } else {
// //       _selectedPlayers = [];
// //     }
// //
// //     setState(() => _isLoading = false);
// //   }
// //
// //   Future<void> _saveLineup() async {
// //     if (_selectedPlayers.isEmpty) {
// //       ScaffoldMessenger.of(context).showSnackBar(
// //         const SnackBar(
// //           content: Text('অন্তত একজন খেলোয়াড় যোগ করুন'),
// //           backgroundColor: Colors.red,
// //         ),
// //       );
// //       return;
// //     }
// //
// //     final matchProvider = Provider.of<MatchProvider>(context, listen: false);
// //     final lineup = LineUp(
// //       formation: '4-4-2', // Default formation
// //       players: _selectedPlayers,
// //     );
// //
// //     final error = await matchProvider.updateLineup(
// //       widget.match.matchId!,
// //       _selectedTeam,
// //       lineup,
// //     );
// //
// //     if (error != null) {
// //       ScaffoldMessenger.of(context).showSnackBar(
// //         SnackBar(content: Text(error), backgroundColor: Colors.red),
// //       );
// //     } else {
// //       ScaffoldMessenger.of(context).showSnackBar(
// //         const SnackBar(
// //           content: Text('লাইনআপ সংরক্ষিত হয়েছে'),
// //           backgroundColor: Colors.green,
// //         ),
// //       );
// //       setState(() => _isEditMode = false);
// //       widget.onUpdate();
// //     }
// //   }
// //
// //   void _togglePlayerSelection(PlayerModel player) {
// //     setState(() {
// //       int index = _selectedPlayers.indexWhere((p) => p.playerId == player.id);
// //
// //       if (index != -1) {
// //         // Remove player
// //         _selectedPlayers.removeAt(index);
// //       } else {
// //         // Add player
// //         if (_selectedPlayers.length >= 11) {
// //           ScaffoldMessenger.of(context).showSnackBar(
// //             const SnackBar(
// //               content: Text('সর্বোচ্চ ১১ জন খেলোয়াড় নির্বাচন করা যাবে'),
// //               backgroundColor: Colors.red,
// //             ),
// //           );
// //           return;
// //         }
// //
// //         // ✅ Fixed: player.id ব্যবহার করা হচ্ছে এবং সব fields সঠিকভাবে set করা হচ্ছে
// //         _selectedPlayers.add(PlayerLineUp(
// //           playerName: player.name,
// //           playerId: player.id,
// //           jerseyNumber: player.jerseyNumber ?? 0,
// //           position: player.position,
// //           isCaptain: false,
// //           isSubstitute: false,
// //         ));
// //       }
// //     });
// //   }
// //
// //   bool _isPlayerSelected(String playerId) {
// //     return _selectedPlayers.any((p) => p.playerId == playerId);
// //   }
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     return Container(
// //       color: const Color(0xFF1A1A2E),
// //       child: Column(
// //         children: [
// //           // Team Selector
// //           Container(
// //             margin: const EdgeInsets.all(16),
// //             decoration: BoxDecoration(
// //               color: const Color(0xFF16213E),
// //               borderRadius: BorderRadius.circular(12),
// //             ),
// //             child: Row(
// //               children: [
// //                 Expanded(
// //                   child: GestureDetector(
// //                     onTap: () {
// //                       setState(() => _selectedTeam = 'teamA');
// //                       _loadPlayers();
// //                     },
// //                     child: Container(
// //                       padding: const EdgeInsets.symmetric(vertical: 16),
// //                       decoration: BoxDecoration(
// //                         color: _selectedTeam == 'teamA'
// //                             ? const Color(0xFFE94560)
// //                             : Colors.transparent,
// //                         borderRadius: const BorderRadius.only(
// //                           topLeft: Radius.circular(12),
// //                           bottomLeft: Radius.circular(12),
// //                         ),
// //                       ),
// //                       child: Text(
// //                         widget.match.teamAName,
// //                         style: const TextStyle(
// //                           color: Colors.white,
// //                           fontWeight: FontWeight.bold,
// //                         ),
// //                         textAlign: TextAlign.center,
// //                       ),
// //                     ),
// //                   ),
// //                 ),
// //                 Expanded(
// //                   child: GestureDetector(
// //                     onTap: () {
// //                       setState(() => _selectedTeam = 'teamB');
// //                       _loadPlayers();
// //                     },
// //                     child: Container(
// //                       padding: const EdgeInsets.symmetric(vertical: 16),
// //                       decoration: BoxDecoration(
// //                         color: _selectedTeam == 'teamB'
// //                             ? const Color(0xFFE94560)
// //                             : Colors.transparent,
// //                         borderRadius: const BorderRadius.only(
// //                           topRight: Radius.circular(12),
// //                           bottomRight: Radius.circular(12),
// //                         ),
// //                       ),
// //                       child: Text(
// //                         widget.match.teamBName,
// //                         style: const TextStyle(
// //                           color: Colors.white,
// //                           fontWeight: FontWeight.bold,
// //                         ),
// //                         textAlign: TextAlign.center,
// //                       ),
// //                     ),
// //                   ),
// //                 ),
// //               ],
// //             ),
// //           ),
// //
// //           // Header with count and edit button
// //           Padding(
// //             padding: const EdgeInsets.symmetric(horizontal: 16),
// //             child: Row(
// //               mainAxisAlignment: MainAxisAlignment.spaceBetween,
// //               children: [
// //                 Text(
// //                   'Line-UP',
// //                   style: const TextStyle(
// //                     color: Colors.white,
// //                     fontSize: 20,
// //                     fontWeight: FontWeight.bold,
// //                   ),
// //                 ),
// //                 Row(
// //                   children: [
// //                     Text(
// //                       '${_selectedPlayers.length}/11',
// //                       style: const TextStyle(
// //                         color: Color(0xFF00D9FF),
// //                         fontWeight: FontWeight.bold,
// //                       ),
// //                     ),
// //                     const SizedBox(width: 16),
// //                     ElevatedButton(
// //                       onPressed: () {
// //                         if (_isEditMode) {
// //                           _saveLineup();
// //                         } else {
// //                           setState(() => _isEditMode = true);
// //                         }
// //                       },
// //                       style: ElevatedButton.styleFrom(
// //                         backgroundColor: _isEditMode
// //                             ? Colors.green
// //                             : const Color(0xFF8B5CF6),
// //                         shape: RoundedRectangleBorder(
// //                           borderRadius: BorderRadius.circular(20),
// //                         ),
// //                       ),
// //                       child: Row(
// //                         children: [
// //                           Text(_isEditMode ? 'সংরক্ষণ' : 'Edit'),
// //                           const SizedBox(width: 4),
// //                           Icon(_isEditMode ? Icons.check : Icons.edit, size: 16),
// //                         ],
// //                       ),
// //                     ),
// //                   ],
// //                 ),
// //               ],
// //             ),
// //           ),
// //
// //           const SizedBox(height: 16),
// //
// //           // Players List
// //           Expanded(
// //             child: _isLoading
// //                 ? const Center(
// //               child: CircularProgressIndicator(
// //                 color: Color(0xFF00D9FF),
// //               ),
// //             )
// //                 : _teamPlayers.isEmpty
// //                 ? Center(
// //               child: Column(
// //                 mainAxisAlignment: MainAxisAlignment.center,
// //                 children: [
// //                   Icon(Icons.groups, size: 60, color: Colors.white24),
// //                   const SizedBox(height: 16),
// //                   Text(
// //                     'কোনো খেলোয়াড় নেই',
// //                     style: TextStyle(color: Colors.white54),
// //                   ),
// //                 ],
// //               ),
// //             )
// //                 : ListView(
// //               padding: const EdgeInsets.symmetric(horizontal: 16),
// //               children: _buildPlayersList(),
// //             ),
// //           ),
// //         ],
// //       ),
// //     );
// //   }
// //
// //   List<Widget> _buildPlayersList() {
// //     // Group players by position
// //     Map<String, List<PlayerModel>> groupedPlayers = {
// //       'Goalkeepers': [],
// //       'Defenses': [],
// //       'Midfielders': [],
// //       'Forwards': [],
// //     };
// //
// //     for (var player in _teamPlayers) {
// //       switch (player.position.toUpperCase()) {
// //         case 'GK':
// //         case 'GOALKEEPER':
// //           groupedPlayers['Goalkeepers']!.add(player);
// //           break;
// //         case 'DEF':
// //         case 'DEFENDER':
// //         case 'DEFENSE':
// //           groupedPlayers['Defenses']!.add(player);
// //           break;
// //         case 'MID':
// //         case 'MIDFIELDER':
// //           groupedPlayers['Midfielders']!.add(player);
// //           break;
// //         case 'FWD':
// //         case 'FORWARD':
// //         case 'ATTACKER':
// //           groupedPlayers['Forwards']!.add(player);
// //           break;
// //         default:
// //           groupedPlayers['Midfielders']!.add(player); // Default
// //       }
// //     }
// //
// //     List<Widget> widgets = [];
// //
// //     groupedPlayers.forEach((position, players) {
// //       if (players.isNotEmpty) {
// //         // Position Header
// //         widgets.add(
// //           Padding(
// //             padding: const EdgeInsets.symmetric(vertical: 8),
// //             child: Text(
// //               position,
// //               style: const TextStyle(
// //                 color: Colors.white70,
// //                 fontSize: 16,
// //                 fontWeight: FontWeight.bold,
// //               ),
// //             ),
// //           ),
// //         );
// //
// //         // Players
// //         for (var player in players) {
// //           widgets.add(_buildPlayerCard(player));
// //         }
// //       }
// //     });
// //
// //     return widgets;
// //   }
// //
// //   Widget _buildPlayerCard(PlayerModel player) {
// //     bool isSelected = _isPlayerSelected(player.id);
// //     Color jerseyColor = isSelected
// //         ? const Color(0xFFE94560)
// //         : const Color(0xFF16213E);
// //
// //     return GestureDetector(
// //       onTap: _isEditMode ? () => _togglePlayerSelection(player) : null,
// //       child: Container(
// //         margin: const EdgeInsets.only(bottom: 12),
// //         padding: const EdgeInsets.all(12),
// //         decoration: BoxDecoration(
// //           color: const Color(0xFF16213E),
// //           borderRadius: BorderRadius.circular(12),
// //           border: Border.all(
// //             color: isSelected ? const Color(0xFF00D9FF) : Colors.transparent,
// //             width: 2,
// //           ),
// //         ),
// //         child: Row(
// //           children: [
// //             // Player Avatar
// //             Container(
// //               width: 50,
// //               height: 50,
// //               decoration: BoxDecoration(
// //                 color: Colors.white12,
// //                 shape: BoxShape.circle,
// //                 image: player.profilePhotoUrl != null
// //                     ? DecorationImage(
// //                   image: NetworkImage(player.profilePhotoUrl!),
// //                   fit: BoxFit.cover,
// //                 )
// //                     : null,
// //               ),
// //               child: player.profilePhotoUrl == null
// //                   ? Icon(Icons.person, color: Colors.white54)
// //                   : null,
// //             ),
// //             const SizedBox(width: 12),
// //
// //             // Player Info
// //             Expanded(
// //               child: Column(
// //                 crossAxisAlignment: CrossAxisAlignment.start,
// //                 children: [
// //                   Text(
// //                     player.name,
// //                     style: const TextStyle(
// //                       color: Colors.white,
// //                       fontWeight: FontWeight.bold,
// //                       fontSize: 16,
// //                     ),
// //                   ),
// //                   Text(
// //                     player.teamName ?? 'No Team',
// //                     style: const TextStyle(
// //                       color: Colors.white38,
// //                       fontSize: 12,
// //                     ),
// //                   ),
// //                 ],
// //               ),
// //             ),
// //
// //             // Jersey Number
// //             Container(
// //               width: 40,
// //               height: 50,
// //               decoration: BoxDecoration(
// //                 color: jerseyColor,
// //                 borderRadius: BorderRadius.circular(8),
// //               ),
// //               child: Center(
// //                 child: Text(
// //                   '${player.jerseyNumber ?? 0}',
// //                   style: const TextStyle(
// //                     color: Colors.white,
// //                     fontWeight: FontWeight.bold,
// //                     fontSize: 18,
// //                   ),
// //                 ),
// //               ),
// //             ),
// //
// //             if (_isEditMode) ...[
// //               const SizedBox(width: 12),
// //               Checkbox(
// //                 value: isSelected,
// //                 onChanged: (value) => _togglePlayerSelection(player),
// //                 activeColor: const Color(0xFF00D9FF),
// //               ),
// //             ],
// //           ],
// //         ),
// //       ),
// //     );
// //   }
// // }
//
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import '../../providers/match_provider.dart';
// import '../../models/match_model.dart';
// import '../../models/player_model.dart';
// import '../../models/team_model.dart';
//
// class LineupTab extends StatefulWidget {
//   final MatchModel match;
//
//   const LineupTab({
//     Key? key,
//     required this.match,
//   }) : super(key: key);
//
//   @override
//   State<LineupTab> createState() => _LineupTabState();
// }
//
// class _LineupTabState extends State<LineupTab> {
//   String _selectedTeam = 'teamA';
//   List<PlayerModel> _teamPlayers = [];
//   List<PlayerLineUp> _selectedPlayers = [];
//   bool _isLoading = false;
//   bool _isEditMode = false;
//
//   @override
//   void initState() {
//     super.initState();
//     _loadPlayers();
//   }
//
//   Future<void> _loadPlayers() async {
//     setState(() => _isLoading = true);
//
//     try {
//       final matchProvider = Provider.of<MatchProvider>(context, listen: false);
//       String teamId = _selectedTeam == 'teamA' ? widget.match.teamA : widget.match.teamB;
//
//       debugPrint('🔍 Loading players for team: $teamId');
//
//       final teamModel = matchProvider.getTeamById(teamId);
//
//       debugPrint('📋 Team: ${teamModel?.name}');
//       debugPrint('👥 PlayerIds: ${teamModel?.playerIds}');
//
//       if (teamModel != null && teamModel.playerIds != null && teamModel.playerIds!.isNotEmpty) {
//         List<PlayerModel> loadedPlayers = [];
//
//         for (int i = 0; i < teamModel.playerIds!.length; i += 10) {
//           int end = (i + 10 < teamModel.playerIds!.length)
//               ? i + 10
//               : teamModel.playerIds!.length;
//           List<String> batch = teamModel.playerIds!.sublist(i, end);
//
//           try {
//             final querySnapshot = await FirebaseFirestore.instance
//                 .collection('players')
//                 .where('playerId', whereIn: batch)
//                 .get();
//
//             for (var doc in querySnapshot.docs) {
//               final player = PlayerModel.fromFirestore(doc);
//               loadedPlayers.add(player);
//               debugPrint('✅ ${player.name}');
//             }
//           } catch (e) {
//             debugPrint('❌ Query error: $e');
//           }
//         }
//
//         _teamPlayers = loadedPlayers;
//         debugPrint('✅ Total: ${_teamPlayers.length}');
//       } else {
//         _teamPlayers = [];
//       }
//
//       LineUp? lineup = _selectedTeam == 'teamA' ? widget.match.lineUpA : widget.match.lineUpB;
//
//       if (lineup != null && lineup.players.isNotEmpty) {
//         _selectedPlayers = List<PlayerLineUp>.from(lineup.players);
//       } else {
//         _selectedPlayers = [];
//       }
//     } catch (e) {
//       debugPrint('❌ Error: $e');
//       _teamPlayers = [];
//       _selectedPlayers = [];
//     }
//
//     setState(() => _isLoading = false);
//   }
//
//   Future<void> _saveLineup() async {
//     if (_selectedPlayers.isEmpty) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(
//           content: Text('অন্তত একজন খেলোয়াড় যোগ করুন'),
//           backgroundColor: Colors.red,
//         ),
//       );
//       return;
//     }
//
//     final matchProvider = Provider.of<MatchProvider>(context, listen: false);
//     final lineup = LineUp(
//       formation: '4-4-2',
//       players: _selectedPlayers,
//     );
//
//     try {
//       if (_selectedTeam == 'teamA') {
//         await matchProvider.updateLineupA(widget.match.id, lineup);
//       } else {
//         await matchProvider.updateLineupB(widget.match.id, lineup);
//       }
//
//       if (!mounted) return;
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(
//           content: Text('লাইনআপ সংরক্ষিত হয়েছে'),
//           backgroundColor: Colors.green,
//         ),
//       );
//       setState(() => _isEditMode = false);
//     } catch (e) {
//       if (!mounted) return;
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text('সমস্যা: $e'),
//           backgroundColor: Colors.red,
//         ),
//       );
//     }
//   }
//
//   void _togglePlayerSelection(PlayerModel player) {
//     if (player.playerId == null) return;
//
//     int index = _selectedPlayers.indexWhere((p) => p.playerId == player.playerId);
//
//     debugPrint('🔄 ${player.name}: index=$index, total=${_selectedPlayers.length}');
//
//     if (index != -1) {
//       _selectedPlayers.removeAt(index);
//       debugPrint('   ❌ Removed');
//     } else {
//       if (_selectedPlayers.length >= 11) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(
//             content: Text('সর্বোচ্চ ১১ জন'),
//             backgroundColor: Colors.red,
//             duration: Duration(seconds: 1),
//           ),
//         );
//         return;
//       }
//
//       _selectedPlayers.add(PlayerLineUp(
//         playerName: player.name,
//         playerId: player.playerId!,
//         jerseyNumber: player.jerseyNumber ?? 0,
//         position: player.position,
//         isCaptain: false,
//         isSubstitute: false,
//       ));
//       debugPrint('   ✅ Added');
//     }
//   }
//
//   bool _isPlayerSelected(String playerId) {
//     return _selectedPlayers.any((p) => p.playerId == playerId);
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Stack(
//       children: [
//         Container(
//           decoration: BoxDecoration(
//             gradient: LinearGradient(
//               begin: Alignment.topCenter,
//               end: Alignment.bottomCenter,
//               colors: [
//                 const Color(0xFF1A1A2E),
//                 const Color(0xFF16213E),
//               ],
//             ),
//           ),
//           child: Column(
//             children: [
//               const SizedBox(height: 16),
//               _buildTeamSelector(),
//               const SizedBox(height: 20),
//               _buildHeader(),
//               const SizedBox(height: 16),
//               Expanded(
//                 child: _isLoading
//                     ? const Center(child: CircularProgressIndicator(color: Colors.orange))
//                     : _selectedPlayers.isEmpty
//                     ? _buildEmptyState()
//                     : _buildPlayersList(),
//               ),
//             ],
//           ),
//         ),
//         if (_isEditMode)
//           Positioned(
//             right: 16,
//             bottom: 80,
//             child: FloatingActionButton.extended(
//               onPressed: () => _showPlayerSelectionDialog(),
//               backgroundColor: Colors.orange.shade700,
//               icon: const Icon(Icons.add, size: 24),
//               label: const Text('খেলোয়াড়', style: TextStyle(fontWeight: FontWeight.bold)),
//             ),
//           ),
//       ],
//     );
//   }
//
//   Widget _buildTeamSelector() {
//     return Container(
//       margin: const EdgeInsets.symmetric(horizontal: 16),
//       decoration: BoxDecoration(
//         color: const Color(0xFF16213E),
//         borderRadius: BorderRadius.circular(12),
//       ),
//       child: Row(
//         children: [
//           Expanded(child: _buildTeamButton('teamA')),
//           Container(width: 1, height: 50, color: Colors.white10),
//           Expanded(child: _buildTeamButton('teamB')),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildTeamButton(String team) {
//     final isSelected = _selectedTeam == team;
//     final matchProvider = Provider.of<MatchProvider>(context, listen: false);
//     final teamId = team == 'teamA' ? widget.match.teamA : widget.match.teamB;
//     final teamModel = matchProvider.getTeamById(teamId);
//
//     return GestureDetector(
//       onTap: () {
//         setState(() => _selectedTeam = team);
//         _loadPlayers();
//       },
//       child: Container(
//         padding: const EdgeInsets.symmetric(vertical: 16),
//         decoration: BoxDecoration(
//           gradient: isSelected
//               ? LinearGradient(colors: [Colors.orange.shade700, Colors.orange.shade900])
//               : null,
//           borderRadius: BorderRadius.horizontal(
//             left: team == 'teamA' ? const Radius.circular(12) : Radius.zero,
//             right: team == 'teamB' ? const Radius.circular(12) : Radius.zero,
//           ),
//         ),
//         child: Text(
//           teamModel?.name ?? 'Unknown',
//           style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
//           textAlign: TextAlign.center,
//         ),
//       ),
//     );
//   }
//
//   Widget _buildHeader() {
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 16),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           const Text('Line-UP', style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold)),
//           Row(
//             children: [
//               Container(
//                 padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
//                 decoration: BoxDecoration(color: Colors.orange.shade700, borderRadius: BorderRadius.circular(20)),
//                 child: Text('${_selectedPlayers.length}/11', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
//               ),
//               const SizedBox(width: 12),
//               ElevatedButton.icon(
//                 onPressed: () {
//                   if (_isEditMode) {
//                     _saveLineup();
//                   } else {
//                     setState(() => _isEditMode = true);
//                   }
//                 },
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: _isEditMode ? Colors.green.shade600 : Colors.orange.shade700,
//                   shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
//                 ),
//                 icon: Icon(_isEditMode ? Icons.check : Icons.edit),
//                 label: Text(_isEditMode ? 'সংরক্ষণ' : 'Edit'),
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildEmptyState() {
//     return Center(
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Icon(Icons.groups, size: 80, color: Colors.white24),
//           const SizedBox(height: 24),
//           const Text('লাইনআপ উপলব্ধ নেই', style: TextStyle(color: Colors.white70, fontSize: 20, fontWeight: FontWeight.bold)),
//           const SizedBox(height: 8),
//           Text(
//             _isEditMode ? 'খেলোয়াড় যোগ করতে + বাটনে ক্লিক করুন' : 'ম্যাচ শুরুর আগে লাইনআপ যোগ করা হবে',
//             style: const TextStyle(color: Colors.white38),
//             textAlign: TextAlign.center,
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildPlayersList() {
//     // Define position groups in order
//     Map<String, List<PlayerLineUp>> grouped = {
//       'Goalkeepers': [],
//       'Defenders': [],
//       'Midfielders': [],
//       'Forwards': [],
//     };
//
//     // Group players by position
//     for (var player in _selectedPlayers) {
//       String pos = player.position.trim();
//
//       debugPrint('Player: ${player.playerName}, Position: "$pos"');
//
//       // Goalkeeper check
//       if (pos == 'GK' ||
//           pos.toUpperCase() == 'GOALKEEPER' ||
//           pos == 'গোলরক্ষক') {
//         grouped['Goalkeepers']!.add(player);
//         debugPrint('   → Goalkeeper');
//       }
//       // Defender check
//       else if (pos == 'DEF' ||
//           pos.toUpperCase() == 'DEFENDER' ||
//           pos.toUpperCase() == 'DEFENSE' ||
//           pos == 'ডিফেন্ডার' ||
//           pos == 'রক্ষক') {
//         grouped['Defenders']!.add(player);
//         debugPrint('   → Defender');
//       }
//       // Midfielder check
//       else if (pos == 'MID' ||
//           pos.toUpperCase() == 'MIDFIELDER' ||
//           pos.toUpperCase() == 'MIDFIELD' ||
//           pos == 'মিডফিল্ডার' ||
//           pos == 'মধ্যমাঠ') {
//         grouped['Midfielders']!.add(player);
//         debugPrint('   → Midfielder');
//       }
//       // Forward check
//       else if (pos == 'FWD' ||
//           pos.toUpperCase() == 'FORWARD' ||
//           pos.toUpperCase() == 'ATTACKER' ||
//           pos.toUpperCase() == 'STRIKER' ||
//           pos == 'ফরওয়ার্ড' ||
//           pos == 'আক্রমণভাগ') {
//         grouped['Forwards']!.add(player);
//         debugPrint('   → Forward');
//       }
//       else {
//         // Default to Midfielders if position unclear
//         debugPrint('   ⚠️ Unknown position "$pos", adding to Midfielders');
//         grouped['Midfielders']!.add(player);
//       }
//     }
//
//     // Build list in order: GK → DEF → MID → FWD
//     List<Widget> widgets = [];
//
//     final orderedPositions = ['Goalkeepers', 'Defenders', 'Midfielders', 'Forwards'];
//     final positionBangla = {
//       'Goalkeepers': 'গোলরক্ষক',
//       'Defenders': 'ডিফেন্ডার',
//       'Midfielders': 'মিডফিল্ডার',
//       'Forwards': 'ফরওয়ার্ড',
//     };
//
//     for (String position in orderedPositions) {
//       List<PlayerLineUp> players = grouped[position]!;
//
//       if (players.isNotEmpty) {
//         // Position Header
//         widgets.add(
//           Padding(
//             padding: const EdgeInsets.only(top: 16, bottom: 8),
//             child: Row(
//               children: [
//                 Container(
//                   width: 4,
//                   height: 20,
//                   decoration: BoxDecoration(
//                     color: Colors.orange.shade700,
//                     borderRadius: BorderRadius.circular(2),
//                   ),
//                 ),
//                 const SizedBox(width: 8),
//                 Text(
//                   positionBangla[position]!,
//                   style: const TextStyle(
//                     color: Colors.white,
//                     fontSize: 16,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//                 const SizedBox(width: 8),
//                 Text(
//                   '(${players.length})',
//                   style: const TextStyle(
//                     color: Colors.white54,
//                     fontSize: 14,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         );
//
//         // Players in this position
//         for (var player in players) {
//           widgets.add(_buildPlayerCard(player));
//         }
//       }
//     }
//
//     return ListView(
//       padding: const EdgeInsets.symmetric(horizontal: 16),
//       children: widgets,
//     );
//   }
//
//   Widget _buildPlayerCard(PlayerLineUp player) {
//     return Container(
//       margin: const EdgeInsets.only(bottom: 12),
//       padding: const EdgeInsets.all(12),
//       decoration: BoxDecoration(
//         color: const Color(0xFF16213E),
//         borderRadius: BorderRadius.circular(12),
//         border: Border.all(color: Colors.orange.withOpacity(0.3)),
//       ),
//       child: Row(
//         children: [
//           Container(
//             width: 50,
//             height: 50,
//             decoration: BoxDecoration(
//               gradient: LinearGradient(colors: [Colors.orange.shade700, Colors.orange.shade900]),
//               shape: BoxShape.circle,
//             ),
//             child: Center(child: Text('${player.jerseyNumber}', style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold))),
//           ),
//           const SizedBox(width: 12),
//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(player.playerName, style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
//                 const SizedBox(height: 4),
//                 Text(player.position.toUpperCase(), style: const TextStyle(color: Colors.white70, fontSize: 12)),
//               ],
//             ),
//           ),
//           if (_isEditMode)
//             IconButton(
//               icon: const Icon(Icons.remove_circle, color: Colors.red),
//               onPressed: () {
//                 setState(() {
//                   _selectedPlayers.removeWhere((p) => p.playerId == player.playerId);
//                 });
//               },
//             ),
//         ],
//       ),
//     );
//   }
//
//   void _showPlayerSelectionDialog() {
//     showModalBottomSheet(
//       context: context,
//       backgroundColor: const Color(0xFF1A1A2E),
//       isScrollControlled: true,
//       builder: (context) => StatefulBuilder(
//         builder: (context, setDialogState) => DraggableScrollableSheet(
//           initialChildSize: 0.7,
//           builder: (context, scrollController) => Column(
//             children: [
//               Container(
//                 padding: const EdgeInsets.all(16),
//                 decoration: const BoxDecoration(
//                   color: Color(0xFF16213E),
//                   borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
//                 ),
//                 child: Column(
//                   children: [
//                     Container(width: 40, height: 4, decoration: BoxDecoration(color: Colors.white30, borderRadius: BorderRadius.circular(2))),
//                     const SizedBox(height: 16),
//                     const Text('খেলোয়াড় নির্বাচন', style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
//                     const SizedBox(height: 8),
//                     Text('${_selectedPlayers.length}/11', style: TextStyle(color: Colors.orange.shade400, fontSize: 14)),
//                   ],
//                 ),
//               ),
//               Expanded(
//                 child: ListView.builder(
//                   controller: scrollController,
//                   padding: const EdgeInsets.all(16),
//                   itemCount: _teamPlayers.length,
//                   itemBuilder: (context, index) {
//                     final player = _teamPlayers[index];
//                     final isSelected = _isPlayerSelected(player.playerId!);
//
//                     return GestureDetector(
//                       onTap: () {
//                         setState(() {
//                           _togglePlayerSelection(player);
//                         });
//                         setDialogState(() {}); // Update dialog
//                       },
//                       child: Container(
//                         margin: const EdgeInsets.only(bottom: 12),
//                         padding: const EdgeInsets.all(12),
//                         decoration: BoxDecoration(
//                           color: isSelected ? Colors.orange.shade700.withOpacity(0.2) : const Color(0xFF16213E),
//                           borderRadius: BorderRadius.circular(12),
//                           border: Border.all(color: isSelected ? Colors.orange.shade700 : Colors.white10, width: 2),
//                         ),
//                         child: Row(
//                           children: [
//                             Container(
//                               width: 50,
//                               height: 50,
//                               decoration: BoxDecoration(
//                                 gradient: LinearGradient(colors: [Colors.orange.shade700, Colors.orange.shade900]),
//                                 borderRadius: BorderRadius.circular(8),
//                               ),
//                               child: Center(child: Text(player.name[0], style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold))),
//                             ),
//                             const SizedBox(width: 12),
//                             Expanded(
//                               child: Column(
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 children: [
//                                   Text(player.name, style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
//                                   Text('#${player.jerseyNumber ?? 0} • ${player.position.toUpperCase()}', style: const TextStyle(color: Colors.white70, fontSize: 12)),
//                                 ],
//                               ),
//                             ),
//                             Checkbox(
//                               value: isSelected,
//                               onChanged: (_) {
//                                 setState(() {
//                                   _togglePlayerSelection(player);
//                                 });
//                                 setDialogState(() {});
//                               },
//                               activeColor: Colors.orange.shade700,
//                             ),
//                           ],
//                         ),
//                       ),
//                     );
//                   },
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
//
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import '../../providers/match_provider.dart';
// import '../../providers/team_provider.dart';
// import '../../models/match_model.dart';
// import '../../models/player_model.dart';
//
// class MatchLineupScreen extends StatefulWidget {
//   final MatchModel match;
//   final VoidCallback onUpdate;
//
//   const MatchLineupScreen({
//     Key? key,
//     required this.match,
//     required this.onUpdate,
//   }) : super(key: key);
//
//   @override
//   State<MatchLineupScreen> createState() => _MatchLineupScreenState();
// }
//
// class _MatchLineupScreenState extends State<MatchLineupScreen> {
//   String _selectedTeam = 'teamA'; // 'teamA' or 'teamB'
//   List<PlayerLineUp> _selectedPlayers = [];
//   bool _isLoading = false;
//
//   @override
//   void initState() {
//     super.initState();
//     _loadLineup();
//   }
//
//   void _loadLineup() {
//     // Load saved lineup if exists
//     if (_selectedTeam == 'teamA' && widget.match.lineUpA != null) {
//       setState(() {
//         _selectedPlayers = List.from(widget.match.lineUpA!.players);
//       });
//     } else if (_selectedTeam == 'teamB' && widget.match.lineUpB != null) {
//       setState(() {
//         _selectedPlayers = List.from(widget.match.lineUpB!.players);
//       });
//     }
//   }
//
//   Future<void> _openPlayerSelection() async {
//     final teamProvider = Provider.of<TeamProvider>(context, listen: false);
//     String currentTeamId = _selectedTeam == 'teamA' ? widget.match.teamA : widget.match.teamB;
//
//     // Fetch team players
//     await teamProvider.fetchTeamPlayers(currentTeamId);
//     List<PlayerModel> allPlayers = teamProvider.teamPlayers[currentTeamId] ?? [];
//
//     if (allPlayers.isEmpty) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(
//           content: Text('এই টিমে কোন প্লেয়ার নেই'),
//           backgroundColor: Colors.red,
//         ),
//       );
//       return;
//     }
//
//     // Navigate to player selection screen
//     final result = await Navigator.push<List<PlayerLineUp>>(
//       context,
//       MaterialPageRoute(
//         builder: (context) => PlayerSelectionScreen(
//           allPlayers: allPlayers,
//           selectedPlayers: _selectedPlayers,
//           teamName: _selectedTeam == 'teamA' ? widget.match.teamAName : widget.match.teamBName,
//         ),
//       ),
//     );
//
//     if (result != null) {
//       setState(() => _selectedPlayers = result);
//     }
//   }
//
//   Future<void> _saveLineup() async {
//     if (_selectedPlayers.isEmpty) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(
//           content: Text('প্লেয়ার সিলেক্ট করুন'),
//           backgroundColor: Colors.red,
//         ),
//       );
//       return;
//     }
//
//     setState(() => _isLoading = true);
//
//     final matchProvider = Provider.of<MatchProvider>(context, listen: false);
//
//     // Create LineUp
//     final lineup = LineUp(players: _selectedPlayers);
//
//     String? error;
//     if (_selectedTeam == 'teamA') {
//       error = await matchProvider.updateLineUp(widget.match.id, lineup, null);
//     } else {
//       error = await matchProvider.updateLineUp(widget.match.id, null, lineup);
//     }
//
//     setState(() => _isLoading = false);
//
//     if (error != null) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text(error), backgroundColor: Colors.red),
//       );
//     } else {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(
//           content: Text('লাইনআপ সংরক্ষিত হয়েছে'),
//           backgroundColor: Colors.green,
//         ),
//       );
//       widget.onUpdate();
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     String teamAName = widget.match.teamAName;
//     String teamBName = widget.match.teamBName;
//
//     return Container(
//       color: Colors.white,
//       child: Column(
//         children: [
//           // Team Selection Tabs
//           Container(
//             margin: const EdgeInsets.all(16),
//             decoration: BoxDecoration(
//               border: Border.all(color: Colors.orange, width: 2),
//               borderRadius: BorderRadius.circular(12),
//             ),
//             child: Row(
//               children: [
//                 Expanded(
//                   child: GestureDetector(
//                     onTap: () {
//                       setState(() {
//                         _selectedTeam = 'teamA';
//                         _loadLineup();
//                       });
//                     },
//                     child: Container(
//                       padding: const EdgeInsets.symmetric(vertical: 12),
//                       decoration: BoxDecoration(
//                         color: _selectedTeam == 'teamA' ? Colors.orange : Colors.white,
//                         borderRadius: const BorderRadius.only(
//                           topLeft: Radius.circular(10),
//                           bottomLeft: Radius.circular(10),
//                         ),
//                       ),
//                       child: Text(
//                         teamAName,
//                         textAlign: TextAlign.center,
//                         style: TextStyle(
//                           color: _selectedTeam == 'teamA' ? Colors.white : Colors.orange,
//                           fontWeight: FontWeight.bold,
//                           fontSize: 16,
//                         ),
//                       ),
//                     ),
//                   ),
//                 ),
//                 Expanded(
//                   child: GestureDetector(
//                     onTap: () {
//                       setState(() {
//                         _selectedTeam = 'teamB';
//                         _loadLineup();
//                       });
//                     },
//                     child: Container(
//                       padding: const EdgeInsets.symmetric(vertical: 12),
//                       decoration: BoxDecoration(
//                         color: _selectedTeam == 'teamB' ? Colors.orange : Colors.white,
//                         borderRadius: const BorderRadius.only(
//                           topRight: Radius.circular(10),
//                           bottomRight: Radius.circular(10),
//                         ),
//                       ),
//                       child: Text(
//                         teamBName,
//                         textAlign: TextAlign.center,
//                         style: TextStyle(
//                           color: _selectedTeam == 'teamB' ? Colors.white : Colors.orange,
//                           fontWeight: FontWeight.bold,
//                           fontSize: 16,
//                         ),
//                       ),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//
//           // Line-UP Header with Button
//           Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 16),
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 const Text(
//                   'Line-UP',
//                   style: TextStyle(
//                     fontSize: 18,
//                     fontWeight: FontWeight.bold,
//                     color: Colors.black87,
//                   ),
//                 ),
//                 _selectedPlayers.isEmpty
//                     ? ElevatedButton.icon(
//                   onPressed: _openPlayerSelection,
//                   icon: const Icon(Icons.add, size: 20),
//                   label: const Text('Add'),
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: Colors.purple,
//                     foregroundColor: Colors.white,
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(20),
//                     ),
//                     padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
//                   ),
//                 )
//                     : ElevatedButton.icon(
//                   onPressed: _openPlayerSelection,
//                   icon: const Icon(Icons.edit, size: 20),
//                   label: const Text('Edit'),
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: Colors.purple,
//                     foregroundColor: Colors.white,
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(20),
//                     ),
//                     padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//
//           const SizedBox(height: 16),
//
//           // Player List
//           Expanded(
//             child: _selectedPlayers.isEmpty
//                 ? Center(
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   Icon(Icons.groups, size: 80, color: Colors.grey.shade300),
//                   const SizedBox(height: 16),
//                   Text(
//                     'There are no players registered for the\nmatch',
//                     textAlign: TextAlign.center,
//                     style: TextStyle(
//                       color: Colors.grey.shade400,
//                       fontSize: 14,
//                     ),
//                   ),
//                 ],
//               ),
//             )
//                 : ListView.builder(
//               padding: const EdgeInsets.symmetric(horizontal: 16),
//               itemCount: _selectedPlayers.length,
//               itemBuilder: (context, index) {
//                 final player = _selectedPlayers[index];
//                 return Container(
//                   margin: const EdgeInsets.only(bottom: 12),
//                   padding: const EdgeInsets.all(12),
//                   decoration: BoxDecoration(
//                     color: Colors.white,
//                     borderRadius: BorderRadius.circular(12),
//                     border: Border.all(color: Colors.grey.shade300),
//                   ),
//                   child: Row(
//                     children: [
//                       // Player Avatar
//                       Container(
//                         width: 50,
//                         height: 50,
//                         decoration: BoxDecoration(
//                           color: Colors.grey.shade200,
//                           shape: BoxShape.circle,
//                         ),
//                         child: Icon(
//                           Icons.person,
//                           color: Colors.grey.shade400,
//                           size: 30,
//                         ),
//                       ),
//                       const SizedBox(width: 12),
//                       // Player Info
//                       Expanded(
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Text(
//                               player.playerName,
//                               style: const TextStyle(
//                                 fontWeight: FontWeight.bold,
//                                 fontSize: 16,
//                                 color: Colors.black87,
//                               ),
//                             ),
//                             const SizedBox(height: 4),
//                             Text(
//                               '${player.position} • #${player.jerseyNumber}',
//                               style: TextStyle(
//                                 color: Colors.grey.shade600,
//                                 fontSize: 12,
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                       // Jersey Icon
//                       Icon(
//                         Icons.checkroom,
//                         color: Colors.red,
//                         size: 30,
//                       ),
//                     ],
//                   ),
//                 );
//               },
//             ),
//           ),
//
//           // Save Button (show only if players selected)
//           if (_selectedPlayers.isNotEmpty)
//             Container(
//               padding: const EdgeInsets.all(16),
//               child: SizedBox(
//                 width: double.infinity,
//                 height: 50,
//                 child: ElevatedButton(
//                   onPressed: _isLoading ? null : _saveLineup,
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: Colors.orange,
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(12),
//                     ),
//                   ),
//                   child: _isLoading
//                       ? const SizedBox(
//                     height: 24,
//                     width: 24,
//                     child: CircularProgressIndicator(
//                       color: Colors.white,
//                       strokeWidth: 2,
//                     ),
//                   )
//                       : const Text(
//                     'সংরক্ষণ করুন',
//                     style: TextStyle(
//                       fontSize: 16,
//                       fontWeight: FontWeight.bold,
//                       color: Colors.white,
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//         ],
//       ),
//     );
//   }
// }
//
// // Player Selection Screen
// class PlayerSelectionScreen extends StatefulWidget {
//   final List<PlayerModel> allPlayers;
//   final List<PlayerLineUp> selectedPlayers;
//   final String teamName;
//
//   const PlayerSelectionScreen({
//     Key? key,
//     required this.allPlayers,
//     required this.selectedPlayers,
//     required this.teamName,
//   }) : super(key: key);
//
//   @override
//   State<PlayerSelectionScreen> createState() => _PlayerSelectionScreenState();
// }
//
// class _PlayerSelectionScreenState extends State<PlayerSelectionScreen> {
//   List<PlayerLineUp> _tempSelected = [];
//   int _mainPlayersCount = 0;
//
//   @override
//   void initState() {
//     super.initState();
//     _tempSelected = List.from(widget.selectedPlayers);
//     _calculateCounts();
//   }
//
//   void _calculateCounts() {
//     _mainPlayersCount = _tempSelected.where((p) => !p.isSubstitute).length;
//   }
//
//   void _togglePlayer(PlayerModel player) {
//     setState(() {
//       final index = _tempSelected.indexWhere((p) => p.playerId == player.id);
//       if (index != -1) {
//         _tempSelected.removeAt(index);
//       } else {
//         // Convert PlayerModel to PlayerLineUp
//         _tempSelected.add(PlayerLineUp(
//           playerId: player.id,
//           playerName: player.name,
//           position: player.position,
//           jerseyNumber: player.jerseyNumber ?? 0,
//           isSubstitute: false,
//         ));
//       }
//       _calculateCounts();
//     });
//   }
//
//   void _toggleSubstitute(PlayerModel player) {
//     setState(() {
//       final index = _tempSelected.indexWhere((p) => p.playerId == player.id);
//       if (index != -1) {
//         _tempSelected[index] = PlayerLineUp(
//           playerId: player.id,
//           playerName: player.name,
//           position: player.position,
//           jerseyNumber: player.jerseyNumber ?? 0,
//           isSubstitute: !_tempSelected[index].isSubstitute,
//         );
//         _calculateCounts();
//       }
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     // Group players by position
//     Map<String, List<PlayerModel>> groupedPlayers = {
//       'Goalkeepers': [],
//       'Defenses': [],
//       'Midfielders': [],
//       'Forwards': [],
//     };
//
//     for (var player in widget.allPlayers) {
//       String pos = player.position.trim();
//
//       // Check for goalkeeper
//       if (pos == 'GK' ||
//           pos.toUpperCase() == 'GOALKEEPER' ||
//           pos == 'গোলরক্ষক' ||
//           pos == 'গোলকিপার') {
//         groupedPlayers['Goalkeepers']!.add(player);
//       }
//       // Check for defender
//       else if (pos == 'DEF' ||
//           pos.toUpperCase() == 'DEFENDER' ||
//           pos.toUpperCase() == 'DEFENCE' ||
//           pos == 'ডিফেন্ডার' ||
//           pos == 'রক্ষক') {
//         groupedPlayers['Defenses']!.add(player);
//       }
//       // Check for midfielder
//       else if (pos == 'MID' ||
//           pos.toUpperCase() == 'MIDFIELDER' ||
//           pos.toUpperCase() == 'MIDFIELD' ||
//           pos == 'মিডফিল্ডার' ||
//           pos == 'মধ্যমাঠ') {
//         groupedPlayers['Midfielders']!.add(player);
//       }
//       // Check for forward
//       else if (pos == 'FWD' ||
//           pos.toUpperCase() == 'FORWARD' ||
//           pos.toUpperCase() == 'STRIKER' ||
//           pos.toUpperCase() == 'ATTACKER' ||
//           pos == 'ফরওয়ার্ড' ||
//           pos == 'আক্রমণভাগ' ||
//           pos == 'স্ট্রাইকার') {
//         groupedPlayers['Forwards']!.add(player);
//       }
//       // Default to Forwards if unknown
//       else {
//         debugPrint('⚠️ Unknown position: "$pos" for ${player.name}, adding to Forwards');
//         groupedPlayers['Forwards']!.add(player);
//       }
//     }
//
//     return Scaffold(
//       backgroundColor: Colors.grey.shade100,
//       appBar: AppBar(
//         backgroundColor: Colors.white,
//         elevation: 1,
//         leading: IconButton(
//           icon: const Icon(Icons.arrow_back, color: Colors.black),
//           onPressed: () => Navigator.pop(context),
//         ),
//         title: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             const Text(
//               'Line-UP',
//               style: TextStyle(
//                 color: Colors.black87,
//                 fontSize: 18,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//             Text(
//               widget.teamName,
//               style: TextStyle(
//                 color: Colors.grey.shade600,
//                 fontSize: 12,
//               ),
//             ),
//           ],
//         ),
//       ),
//       body: Column(
//         children: [
//           // Counter
//           Container(
//             padding: const EdgeInsets.all(16),
//             color: Colors.white,
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 const Text(
//                   'Players selection',
//                   style: TextStyle(
//                     fontSize: 16,
//                     fontWeight: FontWeight.bold,
//                     color: Colors.black87,
//                   ),
//                 ),
//                 Text(
//                   '$_mainPlayersCount / 11',
//                   style: const TextStyle(
//                     fontSize: 16,
//                     fontWeight: FontWeight.bold,
//                     color: Colors.orange,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//
//           // Player List by Position
//           Expanded(
//             child: ListView(
//               padding: const EdgeInsets.all(16),
//               children: groupedPlayers.entries.where((e) => e.value.isNotEmpty).expand((entry) {
//                 return [
//                   Padding(
//                     padding: const EdgeInsets.only(top: 16, bottom: 8),
//                     child: Text(
//                       entry.key,
//                       style: const TextStyle(
//                         fontSize: 16,
//                         fontWeight: FontWeight.bold,
//                         color: Colors.black87,
//                       ),
//                     ),
//                   ),
//                   ...entry.value.map((player) => _buildPlayerCard(player)),
//                 ];
//               }).toList(),
//             ),
//           ),
//
//           // Done Button
//           Container(
//             padding: const EdgeInsets.all(16),
//             color: Colors.white,
//             child: SizedBox(
//               width: double.infinity,
//               height: 50,
//               child: ElevatedButton(
//                 onPressed: () => Navigator.pop(context, _tempSelected),
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: Colors.orange,
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(12),
//                   ),
//                 ),
//                 child: const Text(
//                   'Done',
//                   style: TextStyle(
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
//   Widget _buildPlayerCard(PlayerModel player) {
//     bool isSelected = _tempSelected.any((p) => p.playerId == player.id);
//     bool isSubstitute = isSelected
//         ? _tempSelected.firstWhere((p) => p.playerId == player.id).isSubstitute
//         : false;
//
//     return Container(
//       margin: const EdgeInsets.only(bottom: 12),
//       padding: const EdgeInsets.all(12),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(12),
//         border: Border.all(
//           color: isSelected ? Colors.green : Colors.grey.shade300,
//           width: isSelected ? 2 : 1,
//         ),
//       ),
//       child: Row(
//         children: [
//           // Avatar
//           Container(
//             width: 50,
//             height: 50,
//             decoration: BoxDecoration(
//               color: Colors.grey.shade200,
//               shape: BoxShape.circle,
//             ),
//             child: Icon(Icons.person, color: Colors.grey.shade400, size: 30),
//           ),
//           const SizedBox(width: 12),
//           // Player Info
//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   player.name,
//                   style: const TextStyle(
//                     fontWeight: FontWeight.bold,
//                     fontSize: 16,
//                     color: Colors.black87,
//                   ),
//                 ),
//                 const SizedBox(height: 4),
//                 Text(
//                   '${player.position} • #${player.jerseyNumber ?? 0}',
//                   style: TextStyle(
//                     color: Colors.grey.shade600,
//                     fontSize: 12,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           // Substitute Toggle
//           if (isSelected)
//             GestureDetector(
//               onTap: () => _toggleSubstitute(player),
//               child: Icon(
//                 Icons.checkroom,
//                 color: isSubstitute ? Colors.grey : Colors.green,
//                 size: 30,
//               ),
//             ),
//           const SizedBox(width: 8),
//           // Selection Checkbox
//           GestureDetector(
//             onTap: () => _togglePlayer(player),
//             child: Container(
//               width: 24,
//               height: 24,
//               decoration: BoxDecoration(
//                 color: isSelected ? Colors.green : Colors.white,
//                 border: Border.all(
//                   color: isSelected ? Colors.green : Colors.grey.shade400,
//                   width: 2,
//                 ),
//                 borderRadius: BorderRadius.circular(4),
//               ),
//               child: isSelected
//                   ? const Icon(Icons.check, color: Colors.white, size: 16)
//                   : null,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }


import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/match_provider.dart';
import '../../providers/team_provider.dart';
import '../../models/match_model.dart';
import '../../models/player_model.dart';

class MatchLineupScreen extends StatefulWidget {
  final MatchModel match;
  final VoidCallback onUpdate;

  const MatchLineupScreen({
    Key? key,
    required this.match,
    required this.onUpdate,
  }) : super(key: key);

  @override
  State<MatchLineupScreen> createState() => _MatchLineupScreenState();
}

class _MatchLineupScreenState extends State<MatchLineupScreen> {
  String _selectedTeam = 'teamA';
  List<PlayerLineUp> _selectedPlayers = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadLineup();
  }

  @override
  void didUpdateWidget(MatchLineupScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.match != widget.match) {
      _loadLineup();
    }
  }

  void _loadLineup() {
    _selectedPlayers.clear();

    if (_selectedTeam == 'teamA' && widget.match.lineUpA != null) {
      _selectedPlayers = List.from(widget.match.lineUpA!.players);
    } else if (_selectedTeam == 'teamB' && widget.match.lineUpB != null) {
      _selectedPlayers = List.from(widget.match.lineUpB!.players);
    }

    setState(() {});
  }

  Future<void> _openPlayerSelection() async {
    final teamProvider = Provider.of<TeamProvider>(context, listen: false);
    String currentTeamId = _selectedTeam == 'teamA' ? widget.match.teamA : widget.match.teamB;
    String currentTeamName = _selectedTeam == 'teamA' ? widget.match.teamAName : widget.match.teamBName;

    // ✅ Fetch করো শুধু এই team এর players
    await teamProvider.fetchTeamPlayers(currentTeamId);
    List<PlayerModel> allPlayers = teamProvider.teamPlayers[currentTeamId] ?? [];

    debugPrint('🎯 Selected Team: $currentTeamName (ID: $currentTeamId)');
    debugPrint('📊 Team Players: ${allPlayers.length}');

    if (allPlayers.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('এই টিমে কোন প্লেয়ার নেই'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final result = await Navigator.push<List<PlayerLineUp>>(
      context,
      MaterialPageRoute(
        builder: (context) => PlayerSelectionScreen(
          allPlayers: allPlayers,
          selectedPlayers: _selectedPlayers,
          teamName: currentTeamName,
        ),
      ),
    );

    if (result != null) {
      setState(() => _selectedPlayers = result);
    }
  }

  Future<void> _saveLineup() async {
    if (_selectedPlayers.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('প্লেয়ার সিলেক্ট করুন'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() => _isLoading = true);

    final matchProvider = Provider.of<MatchProvider>(context, listen: false);

    final lineup = LineUp(
      formation: '4-4-2',
      players: _selectedPlayers,
    );

    String? error;
    if (_selectedTeam == 'teamA') {
      error = await matchProvider.updateLineUp(widget.match.id, lineup, null);
    } else {
      error = await matchProvider.updateLineUp(widget.match.id, null, lineup);
    }

    setState(() => _isLoading = false);

    if (error != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(error), backgroundColor: Colors.red),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('লাইনআপ সংরক্ষিত হয়েছে'),
          backgroundColor: Colors.green,
        ),
      );
      widget.onUpdate();
    }
  }

  @override
  Widget build(BuildContext context) {
    String teamAName = widget.match.teamAName;
    String teamBName = widget.match.teamBName;

    return Container(
      color: Colors.white,
      child: Column(
        children: [
          // Team Selection Tabs
          Container(
            margin: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.orange, width: 2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      if (_selectedTeam != 'teamA') {
                        setState(() {
                          _selectedTeam = 'teamA';
                        });
                        _loadLineup();
                      }
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      decoration: BoxDecoration(
                        color: _selectedTeam == 'teamA' ? Colors.orange : Colors.white,
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(10),
                          bottomLeft: Radius.circular(10),
                        ),
                      ),
                      child: Text(
                        teamAName,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: _selectedTeam == 'teamA' ? Colors.white : Colors.orange,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      if (_selectedTeam != 'teamB') {
                        setState(() {
                          _selectedTeam = 'teamB';
                        });
                        _loadLineup();
                      }
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      decoration: BoxDecoration(
                        color: _selectedTeam == 'teamB' ? Colors.orange : Colors.white,
                        borderRadius: const BorderRadius.only(
                          topRight: Radius.circular(10),
                          bottomRight: Radius.circular(10),
                        ),
                      ),
                      child: Text(
                        teamBName,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: _selectedTeam == 'teamB' ? Colors.white : Colors.orange,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Line-UP Header with Button
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Line-UP',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                _selectedPlayers.isEmpty
                    ? ElevatedButton.icon(
                  onPressed: _openPlayerSelection,
                  icon: const Icon(Icons.add, size: 20),
                  label: const Text('Add'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.purple,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  ),
                )
                    : ElevatedButton.icon(
                  onPressed: _openPlayerSelection,
                  icon: const Icon(Icons.edit, size: 20),
                  label: const Text('Edit'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.purple,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Player List
          Expanded(
            child: _selectedPlayers.isEmpty
                ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.groups, size: 80, color: Colors.grey.shade300),
                  const SizedBox(height: 16),
                  Text(
                    'There are no players registered for the\nmatch',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.grey.shade400,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            )
                : ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: _selectedPlayers.length,
              itemBuilder: (context, index) {
                final player = _selectedPlayers[index];
                return Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey.shade300),
                  ),
                  child: Row(
                    children: [
                      // Player Avatar
                      Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade200,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.person,
                          color: Colors.grey.shade400,
                          size: 30,
                        ),
                      ),
                      const SizedBox(width: 12),
                      // Player Info
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              player.playerName,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: Colors.black87,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '${player.position} • #${player.jerseyNumber}',
                              style: TextStyle(
                                color: Colors.grey.shade600,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                      // Jersey Icon
                      Icon(
                        Icons.checkroom,
                        color: player.isSubstitute ? Colors.grey : Colors.red,
                        size: 30,
                      ),
                    ],
                  ),
                );
              },
            ),
          ),

          // Save Button
          if (_selectedPlayers.isNotEmpty)
            Container(
              padding: const EdgeInsets.all(16),
              child: SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _saveLineup,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: _isLoading
                      ? const SizedBox(
                    height: 24,
                    width: 24,
                    child: CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 2,
                    ),
                  )
                      : const Text(
                    'সংরক্ষণ করুন',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

// ============ Player Selection Screen ============
class PlayerSelectionScreen extends StatefulWidget {
  final List<PlayerModel> allPlayers; // ✅ এখন শুধু এই team এর players আসবে
  final List<PlayerLineUp> selectedPlayers;
  final String teamName;

  const PlayerSelectionScreen({
    Key? key,
    required this.allPlayers,
    required this.selectedPlayers,
    required this.teamName,
  }) : super(key: key);

  @override
  State<PlayerSelectionScreen> createState() => _PlayerSelectionScreenState();
}

class _PlayerSelectionScreenState extends State<PlayerSelectionScreen> {
  late List<PlayerLineUp> _tempSelected;
  int _mainCount = 0;

  @override
  void initState() {
    super.initState();
    _tempSelected = widget.selectedPlayers.map((e) => e.copyWith()).toList();
    _updateCount();

    // ✅ Debug করার জন্য
    debugPrint('👥 Available players for ${widget.teamName}: ${widget.allPlayers.length}');
  }

  void _updateCount() => _mainCount = _tempSelected.where((p) => !p.isSubstitute).length;

  void _togglePlayer(PlayerModel player) {
    setState(() {
      final i = _tempSelected.indexWhere((p) => p.playerId == player.id);
      if (i != -1) {
        _tempSelected.removeAt(i);
      } else {
        _tempSelected.add(PlayerLineUp(
          playerId: player.id,
          playerName: player.name,
          position: player.position,
          jerseyNumber: player.jerseyNumber ?? 0,
          isSubstitute: false,
          isCaptain: false,
        ));
      }
      _updateCount();
    });
  }

  void _toggleSubstitute(PlayerModel player) {
    setState(() {
      final i = _tempSelected.indexWhere((p) => p.playerId == player.id);
      if (i != -1) {
        _tempSelected[i] = _tempSelected[i].copyWith(isSubstitute: !_tempSelected[i].isSubstitute);
        _updateCount();
      }
    });
  }

  void _toggleCaptain(PlayerModel player) {
    setState(() {
      _tempSelected = _tempSelected.map((p) => p.copyWith(isCaptain: p.playerId == player.id)).toList();
    });
  }

  Map<String, List<PlayerModel>> _groupPlayers() {
    final map = <String, List<PlayerModel>>{
      'গোলকিপার': [], 'ডিফেন্ডার': [], 'মিডফিল্ডার': [], 'ফরওয়ার্ড': [],
    };
    for (var p in widget.allPlayers) {
      final pos = p.position.toUpperCase();
      if (pos.contains('GK') || pos.contains('GOAL')) {
        map['গোলকিপার']!.add(p);
      } else if (pos.contains('DEF') || pos.contains('BACK')) {
        map['ডিফেন্ডার']!.add(p);
      } else if (pos.contains('MID')) {
        map['মিডফিল্ডার']!.add(p);
      } else {
        map['ফরওয়ার্ড']!.add(p);
      }
    }
    return map;
  }

  @override
  Widget build(BuildContext context) {
    final groups = _groupPlayers();

    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        title: Text('লাইনআপ — ${widget.teamName}'),
        backgroundColor: Colors.white,
      ),
      body: Column(
        children: [
          Container(
            color: Colors.white,
            padding: const EdgeInsets.all(16),
            child: Text(
              'মূল একাদশ: $_mainCount / 11',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.orange),
            ),
          ),
          Expanded(
            child: widget.allPlayers.isEmpty
                ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.group_off, size: 80, color: Colors.grey.shade400),
                  const SizedBox(height: 16),
                  Text(
                    'এই টিমে কোন খেলোয়াড় নেই',
                    style: TextStyle(fontSize: 18, color: Colors.grey.shade600),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'প্রথমে টিমে খেলোয়াড় যোগ করুন',
                    style: TextStyle(fontSize: 14, color: Colors.grey.shade500),
                  ),
                ],
              ),
            )
                : ListView(
              padding: const EdgeInsets.all(16),
              children: groups.entries.where((e) => e.value.isNotEmpty).expand((e) => [
                Padding(
                  padding: const EdgeInsets.only(top: 20, bottom: 8),
                  child: Text(e.key, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                ),
                ...e.value.map(_buildCard),
                const SizedBox(height: 10),
              ]).toList(),
            ),
          ),
          Container(
            color: Colors.white,
            padding: const EdgeInsets.all(20),
            child: ElevatedButton(
              onPressed: () => Navigator.pop(context, _tempSelected),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
                minimumSize: const Size(double.infinity, 56),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: const Text('সম্পন্ন করুন', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCard(PlayerModel player) {
    // ✅ Standard Dart firstWhere with orElse
    final lineUpPlayer = _tempSelected.cast<PlayerLineUp?>().firstWhere(
          (p) => p?.playerId == player.id,
      orElse: () => null,
    );
    final selected = lineUpPlayer != null;
    final isSub = lineUpPlayer?.isSubstitute ?? false;
    final isCaptain = lineUpPlayer?.isCaptain ?? false;

    return Card(
      elevation: 4,
      child: ListTile(
        leading: CircleAvatar(child: Text(player.jerseyNumber?.toString() ?? '?')),
        title: Text(player.name, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(player.position),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (selected && !isSub)
              IconButton(
                icon: Icon(Icons.star, color: isCaptain ? Colors.amber : Colors.grey),
                onPressed: () => _toggleCaptain(player),
              ),
            if (selected)
              IconButton(
                icon: Icon(Icons.event_seat, color: isSub ? Colors.orange : Colors.grey),
                onPressed: () => _toggleSubstitute(player),
              ),
            IconButton(
              icon: Icon(selected ? Icons.check_circle : Icons.add_circle_outline, color: selected ? Colors.green : Colors.grey),
              onPressed: () => _togglePlayer(player),
            ),
          ],
        ),
      ),
    );
  }
}