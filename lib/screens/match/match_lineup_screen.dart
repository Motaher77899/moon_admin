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
//   String _selectedTeam = 'teamA';
//   List<PlayerLineUp> _selectedPlayers = [];
//   bool _isLoading = false;
//
//   @override
//   void initState() {
//     super.initState();
//     _loadLineup();
//   }
//
//   @override
//   void didUpdateWidget(MatchLineupScreen oldWidget) {
//     super.didUpdateWidget(oldWidget);
//     if (oldWidget.match != widget.match) {
//       _loadLineup();
//     }
//   }
//
//   void _loadLineup() {
//     _selectedPlayers.clear();
//
//     if (_selectedTeam == 'teamA' && widget.match.lineUpA != null) {
//       _selectedPlayers = List.from(widget.match.lineUpA!.players);
//     } else if (_selectedTeam == 'teamB' && widget.match.lineUpB != null) {
//       _selectedPlayers = List.from(widget.match.lineUpB!.players);
//     }
//
//     setState(() {});
//   }
//
//   Future<void> _openPlayerSelection() async {
//     final teamProvider = Provider.of<TeamProvider>(context, listen: false);
//     String currentTeamId = _selectedTeam == 'teamA' ? widget.match.teamA : widget.match.teamB;
//     String currentTeamName = _selectedTeam == 'teamA' ? widget.match.teamAName : widget.match.teamBName;
//
//     // ✅ Fetch করো শুধু এই team এর players
//     await teamProvider.fetchTeamPlayers(currentTeamId);
//     List<PlayerModel> allPlayers = teamProvider.teamPlayers[currentTeamId] ?? [];
//
//     debugPrint('🎯 Selected Team: $currentTeamName (ID: $currentTeamId)');
//     debugPrint('📊 Team Players: ${allPlayers.length}');
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
//     final result = await Navigator.push<List<PlayerLineUp>>(
//       context,
//       MaterialPageRoute(
//         builder: (context) => PlayerSelectionScreen(
//           allPlayers: allPlayers,
//           selectedPlayers: _selectedPlayers,
//           teamName: currentTeamName,
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
//     final lineup = LineUp(
//       formation: '4-4-2',
//       players: _selectedPlayers,
//     );
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
//                       if (_selectedTeam != 'teamA') {
//                         setState(() {
//                           _selectedTeam = 'teamA';
//                         });
//                         _loadLineup();
//                       }
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
//                       if (_selectedTeam != 'teamB') {
//                         setState(() {
//                           _selectedTeam = 'teamB';
//                         });
//                         _loadLineup();
//                       }
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
//                         color: player.isSubstitute ? Colors.grey : Colors.red,
//                         size: 30,
//                       ),
//                     ],
//                   ),
//                 );
//               },
//             ),
//           ),
//
//           // Save Button
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
// // ============ Player Selection Screen ============
// class PlayerSelectionScreen extends StatefulWidget {
//   final List<PlayerModel> allPlayers; // ✅ এখন শুধু এই team এর players আসবে
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
//   late List<PlayerLineUp> _tempSelected;
//   int _mainCount = 0;
//
//   @override
//   void initState() {
//     super.initState();
//     _tempSelected = widget.selectedPlayers.map((e) => e.copyWith()).toList();
//     _updateCount();
//
//     // ✅ Debug করার জন্য
//     debugPrint('👥 Available players for ${widget.teamName}: ${widget.allPlayers.length}');
//   }
//
//   void _updateCount() => _mainCount = _tempSelected.where((p) => !p.isSubstitute).length;
//
//   void _togglePlayer(PlayerModel player) {
//     setState(() {
//       final i = _tempSelected.indexWhere((p) => p.playerId == player.id);
//       if (i != -1) {
//         _tempSelected.removeAt(i);
//       } else {
//         _tempSelected.add(PlayerLineUp(
//           playerId: player.id,
//           playerName: player.name,
//           position: player.position,
//           jerseyNumber: player.jerseyNumber ?? 0,
//           isSubstitute: false,
//           isCaptain: false,
//         ));
//       }
//       _updateCount();
//     });
//   }
//
//   void _toggleSubstitute(PlayerModel player) {
//     setState(() {
//       final i = _tempSelected.indexWhere((p) => p.playerId == player.id);
//       if (i != -1) {
//         _tempSelected[i] = _tempSelected[i].copyWith(isSubstitute: !_tempSelected[i].isSubstitute);
//         _updateCount();
//       }
//     });
//   }
//
//   void _toggleCaptain(PlayerModel player) {
//     setState(() {
//       _tempSelected = _tempSelected.map((p) => p.copyWith(isCaptain: p.playerId == player.id)).toList();
//     });
//   }
//
//   Map<String, List<PlayerModel>> _groupPlayers() {
//     final map = <String, List<PlayerModel>>{
//       'গোলকিপার': [], 'ডিফেন্ডার': [], 'মিডফিল্ডার': [], 'ফরওয়ার্ড': [],
//     };
//     for (var p in widget.allPlayers) {
//       final pos = p.position.toUpperCase();
//       if (pos.contains('GK') || pos.contains('GOAL')) {
//         map['গোলকিপার']!.add(p);
//       } else if (pos.contains('DEF') || pos.contains('BACK')) {
//         map['ডিফেন্ডার']!.add(p);
//       } else if (pos.contains('MID')) {
//         map['মিডফিল্ডার']!.add(p);
//       } else {
//         map['ফরওয়ার্ড']!.add(p);
//       }
//     }
//     return map;
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final groups = _groupPlayers();
//
//     return Scaffold(
//       backgroundColor: Colors.grey.shade50,
//       appBar: AppBar(
//         title: Text('লাইনআপ — ${widget.teamName}'),
//         backgroundColor: Colors.white,
//       ),
//       body: Column(
//         children: [
//           Container(
//             color: Colors.white,
//             padding: const EdgeInsets.all(16),
//             child: Text(
//               'মূল একাদশ: $_mainCount / 11',
//               style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.orange),
//             ),
//           ),
//           Expanded(
//             child: widget.allPlayers.isEmpty
//                 ? Center(
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   Icon(Icons.group_off, size: 80, color: Colors.grey.shade400),
//                   const SizedBox(height: 16),
//                   Text(
//                     'এই টিমে কোন খেলোয়াড় নেই',
//                     style: TextStyle(fontSize: 18, color: Colors.grey.shade600),
//                   ),
//                   const SizedBox(height: 8),
//                   Text(
//                     'প্রথমে টিমে খেলোয়াড় যোগ করুন',
//                     style: TextStyle(fontSize: 14, color: Colors.grey.shade500),
//                   ),
//                 ],
//               ),
//             )
//                 : ListView(
//               padding: const EdgeInsets.all(16),
//               children: groups.entries.where((e) => e.value.isNotEmpty).expand((e) => [
//                 Padding(
//                   padding: const EdgeInsets.only(top: 20, bottom: 8),
//                   child: Text(e.key, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
//                 ),
//                 ...e.value.map(_buildCard),
//                 const SizedBox(height: 10),
//               ]).toList(),
//             ),
//           ),
//           Container(
//             color: Colors.white,
//             padding: const EdgeInsets.all(20),
//             child: ElevatedButton(
//               onPressed: () => Navigator.pop(context, _tempSelected),
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: Colors.orange,
//                 minimumSize: const Size(double.infinity, 56),
//                 shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//               ),
//               child: const Text('সম্পন্ন করুন', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildCard(PlayerModel player) {
//     // ✅ Standard Dart firstWhere with orElse
//     final lineUpPlayer = _tempSelected.cast<PlayerLineUp?>().firstWhere(
//           (p) => p?.playerId == player.id,
//       orElse: () => null,
//     );
//     final selected = lineUpPlayer != null;
//     final isSub = lineUpPlayer?.isSubstitute ?? false;
//     final isCaptain = lineUpPlayer?.isCaptain ?? false;
//
//     return Card(
//       elevation: 4,
//       child: ListTile(
//         leading: CircleAvatar(child: Text(player.jerseyNumber?.toString() ?? '?')),
//         title: Text(player.name, style: const TextStyle(fontWeight: FontWeight.bold)),
//         subtitle: Text(player.position),
//         trailing: Row(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             if (selected && !isSub)
//               IconButton(
//                 icon: Icon(Icons.star, color: isCaptain ? Colors.amber : Colors.grey),
//                 onPressed: () => _toggleCaptain(player),
//               ),
//             if (selected)
//               IconButton(
//                 icon: Icon(Icons.event_seat, color: isSub ? Colors.orange : Colors.grey),
//                 onPressed: () => _toggleSubstitute(player),
//               ),
//             IconButton(
//               icon: Icon(selected ? Icons.check_circle : Icons.add_circle_outline, color: selected ? Colors.green : Colors.grey),
//               onPressed: () => _togglePlayer(player),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }


import 'dart:async';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import '../../providers/match_provider.dart';
import '../../providers/team_provider.dart';
import '../../models/match_model.dart';
import '../../models/player_model.dart';
import '../player_selection_screen.dart';

extension ListHelper<T> on List<T> {
  T? firstWhereOrNull(bool Function(T) test) {
    for (var element in this) {
      if (test(element)) return element;
    }
    return null;
  }
}

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
  String _selectedFormation = '4-4-2';
  bool _isLoading = false;

  final List<String> _formations = [
    '4-4-2', '4-3-3', '4-2-3-1', '3-5-2', '3-4-3', '5-3-2'
  ];

  // রিয়েল-টাইম লিসেনার
  StreamSubscription<DocumentSnapshot>? _matchSubscription;

  @override
  void initState() {
    super.initState();
    _subscribeToMatchUpdates();
  }

  @override
  void dispose() {
    _matchSubscription?.cancel();
    super.dispose();
  }

  // 🔥 Firestore থেকে রিয়েল-টাইম লোড
  void _subscribeToMatchUpdates() {
    _matchSubscription = FirebaseFirestore.instance
        .collection('matches')
        .doc(widget.match.id)
        .snapshots()
        .listen((snapshot) {
      if (!snapshot.exists) {
        setState(() {
          _selectedPlayers = [];
          _selectedFormation = '4-4-2';
        });
        return;
      }

      final data = snapshot.data() as Map<String, dynamic>;

      LineUp? currentLineUp;
      if (_selectedTeam == 'teamA' && data['lineUpA'] != null) {
        currentLineUp = LineUp.fromMap(data['lineUpA']);
      } else if (_selectedTeam == 'teamB' && data['lineUpB'] != null) {
        currentLineUp = LineUp.fromMap(data['lineUpB']);
      }

      if (mounted) {
        setState(() {
          _selectedPlayers = currentLineUp?.players.map((p) => p.copyWith()).toList() ?? [];
          _selectedFormation = currentLineUp?.formation ?? '4-4-2';
        });
      }
    }, onError: (error) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('লাইনআপ লোড করতে সমস্যা: $error')),
        );
      }
    });
  }

  // টিম চেঞ্জ করলে আবার লোড করবে (রিয়েল-টাইমই হ্যান্ডেল করবে)
  void _switchTeam(String team) {
    if (_selectedTeam != team) {
      setState(() => _selectedTeam = team);
      // রিয়েল-টাইম লিসেনারই আপডেট করবে
    }
  }

  Future<void> _openPlayerSelection() async {
    final teamProvider = Provider.of<TeamProvider>(context, listen: false);

    // 🔥 teamAId/teamBId প্রেফার, না থাকলে legacy teamA/teamB ব্যবহার করুন
    final String teamId = _selectedTeam == 'teamA'
        ? (widget.match.teamAId.isNotEmpty ? widget.match.teamAId : widget.match.teamA)
        : (widget.match.teamBId.isNotEmpty ? widget.match.teamBId : widget.match.teamB);
    final String teamName = _selectedTeam == 'teamA' ? widget.match.teamAName : widget.match.teamBName;

    if (teamId.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('টিম আইডি পাওয়া যায়নি!')),
      );
      return;
    }

    setState(() => _isLoading = true);

    // ক্যাশ ক্লিয়ার
    teamProvider.teamPlayers.remove(teamId);

    try {
      await teamProvider.fetchTeamPlayers(teamId);
      final allPlayers = teamProvider.teamPlayers[teamId] ?? [];

      setState(() => _isLoading = false);

      if (allPlayers.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('$teamName এ কোনো খেলোয়াড় পাওয়া যায়নি'),
            backgroundColor: Colors.orange,
            action: SnackBarAction(
              label: 'রিফ্রেশ',
              onPressed: _openPlayerSelection,
            ),
          ),
        );
        return;
      }

      // সেভ করা লাইনআপ
      List<PlayerLineUp> initialSelected = [];
      final savedLineup = _selectedTeam == 'teamA' ? widget.match.lineUpA : widget.match.lineUpB;
      if (savedLineup != null && savedLineup.players.isNotEmpty) {
        initialSelected = savedLineup.players.map((e) => e.copyWith()).toList();
      }

      final result = await Navigator.push<List<PlayerLineUp>>(
        context,
        MaterialPageRoute(
          builder: (_) => PlayerSelectionScreen(
            allPlayers: allPlayers,
            selectedPlayers: initialSelected,
            teamName: teamName,
          ),
        ),
      );

      if (result != null) {
        setState(() => _selectedPlayers = result);
      }
    } catch (e) {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('এরর: $e')),
      );
    }
  }

  Future<void> _saveLineup() async {
    if (_selectedPlayers.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('কমপক্ষে একজন খেলোয়াড় নির্বাচন করুন')),
      );
      return;
    }

    setState(() => _isLoading = true);
    final matchProvider = Provider.of<MatchProvider>(context, listen: false);
    final lineup = LineUp(formation: _selectedFormation, players: _selectedPlayers);

    String? error;
    if (_selectedTeam == 'teamA') {
      error = await matchProvider.updateLineUp(widget.match.id, lineup, null);
    } else {
      error = await matchProvider.updateLineUp(widget.match.id, null, lineup);
    }

    setState(() => _isLoading = false);
    if (!mounted) return;

    if (error == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('লাইনআপ সফলভাবে সংরক্ষিত হয়েছে'), backgroundColor: Colors.green),
      );
      widget.onUpdate();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(error)));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        title: const Text('ম্যাচ লাইনআপ'),
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: Colors.black,
      ),
      body: Column(
        children: [
          // টিম সিলেক্টর
          Container(
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 8)],
            ),
            child: Row(
              children: [
                Expanded(child: _teamButton(widget.match.teamAName, widget.match.teamALogo, 'teamA')),
                Expanded(child: _teamButton(widget.match.teamBName, widget.match.teamBLogo, 'teamB')),
              ],
            ),
          ),

          // হেডার: ফর্মেশন + এডিট বাটন
          Container(
            color: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Text('ফর্মেশন: ', style: TextStyle(fontWeight: FontWeight.bold)),
                    DropdownButton<String>(
                      value: _selectedFormation,
                      items: _formations.map((f) => DropdownMenuItem(value: f, child: Text(f))).toList(),
                      onChanged: (v) => setState(() => _selectedFormation = v!),
                      underline: Container(),
                    ),
                  ],
                ),
                ElevatedButton.icon(
                  onPressed: _isLoading ? null : _openPlayerSelection,
                  icon: const Icon(Icons.edit),
                  label: const Text('এডিট করুন'),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
                ),
              ],
            ),
          ),

          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _selectedPlayers.isEmpty
                ? const Center(
              child: Text(
                'কোনো খেলোয়াড় নির্বাচিত হয়নি\n"এডিট করুন" বাটনে ক্লিক করুন',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            )
                : _buildLineupList(),
          ),

          if (_selectedPlayers.isNotEmpty)
            Container(
              color: Colors.white,
              padding: const EdgeInsets.all(20),
              child: ElevatedButton(
                onPressed: _isLoading ? null : _saveLineup,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  minimumSize: const Size(double.infinity, 56),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: _isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text('লাইনআপ সংরক্ষণ করুন', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ),
            ),
        ],
      ),
    );
  }

  Widget _teamButton(String name, String? logo, String team) {
    final selected = _selectedTeam == team;
    return GestureDetector(
      onTap: () => _switchTeam(team),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: selected ? Colors.orange : Colors.transparent,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (logo != null && logo.isNotEmpty)
              ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Image.network(logo, width: 28, height: 28, fit: BoxFit.cover),
              )
            else
              const Icon(Icons.shield, size: 28),
            const SizedBox(width: 8),
            Text(
              name,
              style: TextStyle(
                color: selected ? Colors.white : Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLineupList() {
    final main = _selectedPlayers.where((p) => !p.isSubstitute).toList();
    final subs = _selectedPlayers.where((p) => p.isSubstitute).toList();

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        if (main.isNotEmpty) ...[
          const Text('মূল একাদশ', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          ...main.map((p) => _playerCard(p, true)),
        ],
        if (subs.isNotEmpty) ...[
          const SizedBox(height: 20),
          const Text('সাবস্টিটিউট', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          ...subs.map((p) => _playerCard(p, false)),
        ],
      ],
    );
  }

  Widget _playerCard(PlayerLineUp p, bool isMain) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: isMain ? Colors.orange.shade100 : Colors.grey.shade200,
          child: Text('#${p.jerseyNumber}', style: const TextStyle(fontWeight: FontWeight.bold)),
        ),
        title: Text(p.playerName, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(p.position),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (p.isCaptain) const Icon(Icons.star, color: Colors.amber),
            if (p.isSubstitute)
              const Padding(
                padding: EdgeInsets.only(left: 8),
                child: Text('SUB', style: TextStyle(color: Colors.orange, fontWeight: FontWeight.bold)),
              ),
          ],
        ),
      ),
    );
  }
}