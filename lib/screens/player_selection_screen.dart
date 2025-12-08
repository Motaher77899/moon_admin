// // lib/screens/player_selection_screen.dart
//
// import 'package:flutter/material.dart';
// import '../../models/player_model.dart';
// import '../../models/match_model.dart';
//
// // এই extension টা ফাইলের একদম নিচে রাখো (বা আলাদা ফাইলে)
// extension ListExtension<T> on List<T> {
//   T? firstWhereOrNull(bool Function(T) test) {
//     for (T element in this) {
//       if (test(element)) return element;
//     }
//     return null;
//   }
// }
//
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
//   late List<PlayerLineUp> _tempSelected;
//   int _mainCount = 0;
//
//   @override
//   void initState() {
//     super.initState();
//     _tempSelected = widget.selectedPlayers.map((e) => e.copyWith()).toList();
//     _updateCount();
//   }
//
//   void _updateCount() {
//     _mainCount = _tempSelected.where((p) => !p.isSubstitute).length;
//   }
//
//   void _togglePlayer(PlayerModel player) {
//     setState(() {
//       final index = _tempSelected.indexWhere((p) => p.playerId == player.id);
//       if (index != -1) {
//         _tempSelected.removeAt(index);
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
//       final index = _tempSelected.indexWhere((p) => p.playerId == player.id);
//       if (index != -1) {
//         _tempSelected[index] = _tempSelected[index].copyWith(isSubstitute: !_tempSelected[index].isSubstitute);
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
//       if (pos.contains('GK') || pos.contains('GOAL')) map['গোলকিপার']!.add(p);
//       else if (pos.contains('DEF') || pos.contains('BACK')) map['ডিফেন্ডার']!.add(p);
//       else if (pos.contains('MID')) map['মিডফিল্ডার']!.add(p);
//       else map['ফরওয়ার্ড']!.add(p);
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
//         foregroundColor: Colors.black87,
//       ),
//       body: Column(
//         children: [
//           Container(
//             color: Colors.white,
//             padding: const EdgeInsets.all(16),
//             child: Text('মূল একাদশ: $_mainCount / 11', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.orange)),
//           ),
//           Expanded(
//             child: ListView(
//               padding: const EdgeInsets.all(16),
//               children: groups.entries.where((e) => e.value.isNotEmpty).expand((e) {
//                 return [
//                   Padding(padding: const EdgeInsets.only(top: 20, bottom: 8), child: Text(e.key, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold))),
//                   ...e.value.map((p) => _buildCard(p)),
//                   const SizedBox(height: 10),
//                 ];
//               }).toList(),
//             ),
//           ),
//           Container(
//             color: Colors.white,
//             padding: const EdgeInsets.all(20),
//             child: ElevatedButton(
//               onPressed: () => Navigator.pop(context, _tempSelected), // এটাই মূল কথা!
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
//     final lineUpPlayer = _tempSelected.firstWhereOrNull((p) => p.playerId == player.id);
//     final bool selected = lineUpPlayer != null;
//     final bool isSub = lineUpPlayer?.isSubstitute ?? false;
//     final bool isCaptain = lineUpPlayer?.isCaptain ?? false; // এখানে isCaptain লিখতে হবে
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


// lib/screens/player_selection_screen.dart

import 'package:flutter/material.dart';
import '../../models/player_model.dart';
import '../../models/match_model.dart';

// ← এই extension টা শুধু এখানেই থাকবে (পুরো প্রজেক্টে আর কোথাও না!)
extension ListHelper<T> on List<T> {
  T? firstWhereOrNull(bool Function(T) test) {
    for (var element in this) {
      if (test(element)) return element;
    }
    return null;
  }
}

class PlayerSelectionScreen extends StatefulWidget {
  final List<PlayerModel> allPlayers;
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
      if (pos.contains('GK') || pos.contains('GOAL')) map['গোলকিপার']!.add(p);
      else if (pos.contains('DEF') || pos.contains('BACK')) map['ডিফেন্ডার']!.add(p);
      else if (pos.contains('MID')) map['মিডফিল্ডার']!.add(p);
      else map['ফরওয়ার্ড']!.add(p);
    }
    return map;
  }

  @override
  Widget build(BuildContext context) {
    final groups = _groupPlayers();

    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(title: Text('লাইনআপ — ${widget.teamName}'), backgroundColor: Colors.white),
      body: Column(
        children: [
          Container(color: Colors.white, padding: const EdgeInsets.all(16), child: Text('মূল একাদশ: $_mainCount / 11', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.orange))),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: groups.entries.where((e) => e.value.isNotEmpty).expand((e) => [
                Padding(padding: const EdgeInsets.only(top: 20, bottom: 8), child: Text(e.key, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold))),
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
              style: ElevatedButton.styleFrom(backgroundColor: Colors.orange, minimumSize: const Size(double.infinity, 56), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
              child: const Text('সম্পন্ন করুন', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCard(PlayerModel player) {
    final lineUpPlayer = _tempSelected.firstWhereOrNull((p) => p.playerId == player.id);
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
              IconButton(icon: Icon(Icons.star, color: isCaptain ? Colors.amber : Colors.grey), onPressed: () => _toggleCaptain(player)),
            if (selected)
              IconButton(icon: Icon(Icons.event_seat, color: isSub ? Colors.orange : Colors.grey), onPressed: () => _toggleSubstitute(player)),
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