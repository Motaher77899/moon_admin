//
// import 'package:flutter/material.dart';
// import '../../models/player_model.dart';
// import '../../models/match_model.dart';
//
// // List এর জন্য হেল্পার এক্সটেনশন
// extension ListHelper<T> on List<T> {
//   T? firstWhereOrNull(bool Function(T) test) {
//     for (var element in this) {
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
//   String _searchQuery = ""; // সার্চের জন্য ভ্যারিয়েবল
//
//   @override
//   void initState() {
//     super.initState();
//     // কপি তৈরি করা যাতে মেইন লিস্টে সরাসরি এফেক্ট না পড়ে
//     _tempSelected = widget.selectedPlayers.map((e) => e.copyWith()).toList();
//     _updateCount();
//   }
//
//   void _updateCount() {
//     setState(() {
//       _mainCount = _tempSelected.where((p) => !p.isSubstitute).length;
//     });
//   }
//
//   void _togglePlayer(PlayerModel player) {
//     setState(() {
//       final i = _tempSelected.indexWhere((p) => p.playerId == player.id);
//       if (i != -1) {
//         _tempSelected.removeAt(i);
//       } else {
//         // ১১ জনের বেশি হলে অটো সাবস্টিটিউট হিসেবে অ্যাড হবে
//         bool shouldBeSub = _mainCount >= 11;
//         _tempSelected.add(PlayerLineUp(
//           playerId: player.id,
//           playerName: player.name,
//           position: player.position,
//           jerseyNumber: player.jerseyNumber ?? 0,
//           isSubstitute: shouldBeSub,
//           isCaptain: false,
//         ));
//
//         if (shouldBeSub) {
//           ScaffoldMessenger.of(context).showSnackBar(
//               const SnackBar(content: Text('১১ জন পূর্ণ, তাই সাবস্টিটিউট হিসেবে যোগ করা হলো।'), duration: Duration(seconds: 1))
//           );
//         }
//       }
//       _updateCount();
//     });
//   }
//
//   void _toggleSubstitute(PlayerModel player) {
//     setState(() {
//       final i = _tempSelected.indexWhere((p) => p.playerId == player.id);
//       if (i != -1) {
//         bool currentSubStatus = _tempSelected[i].isSubstitute;
//
//         // যদি সাবস্টিটিউট থেকে মেইন টিমে আনতে চায় কিন্তু ১১ জন অলরেডি থাকে
//         if (currentSubStatus && _mainCount >= 11) {
//           ScaffoldMessenger.of(context).showSnackBar(
//               const SnackBar(content: Text('মূল একাদশে ১১ জনের বেশি সম্ভব নয়।'))
//           );
//           return;
//         }
//
//         _tempSelected[i] = _tempSelected[i].copyWith(
//           isSubstitute: !currentSubStatus,
//           // সাবস্টিটিউট হলে ক্যাপ্টেনসি চলে যাবে
//           isCaptain: !currentSubStatus ? false : _tempSelected[i].isCaptain,
//         );
//         _updateCount();
//       }
//     });
//   }
//
//   void _toggleCaptain(PlayerModel player) {
//     setState(() {
//       // আগের ক্যাপ্টেন থাকলে তাকে রিমুভ করা
//       _tempSelected = _tempSelected.map((p) => p.copyWith(isCaptain: false)).toList();
//
//       final i = _tempSelected.indexWhere((p) => p.playerId == player.id);
//       if (i != -1) {
//         _tempSelected[i] = _tempSelected[i].copyWith(
//             isCaptain: true,
//             isSubstitute: false // ক্যাপ্টেন সবসময় মেইন একাদশে থাকে
//         );
//       }
//       _updateCount();
//     });
//   }
//
//   Map<String, List<PlayerModel>> _groupPlayers(List<PlayerModel> players) {
//     final map = <String, List<PlayerModel>>{
//       'গোলকিপার': [], 'ডিফেন্ডার': [], 'মিডফিল্ডার': [], 'ফরওয়ার্ড': [],
//     };
//     for (var p in players) {
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
//     // সার্চ ফিল্টারিং
//     final filteredPlayers = widget.allPlayers.where((p) =>
//         p.name.toLowerCase().contains(_searchQuery.toLowerCase())).toList();
//
//     final groups = _groupPlayers(filteredPlayers);
//
//     return Scaffold(
//       backgroundColor: Colors.grey.shade50,
//       appBar: AppBar(
//         title: Text('লাইনআপ — ${widget.teamName}'),
//         backgroundColor: Colors.white,
//         elevation: 0,
//         foregroundColor: Colors.black,
//       ),
//       body: Column(
//         children: [
//           // সার্চ বার অ্যাড করা হয়েছে
//           Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//             child: TextField(
//               decoration: InputDecoration(
//                 hintText: 'খেলোয়াড় খুঁজুন...',
//                 prefixIcon: const Icon(Icons.search),
//                 filled: true,
//                 fillColor: Colors.white,
//                 border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
//               ),
//               onChanged: (val) => setState(() => _searchQuery = val),
//             ),
//           ),
//
//           Container(
//             color: Colors.white,
//             padding: const EdgeInsets.all(16),
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 const Text('মূল একাদশ নির্বাচন', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
//                 Text('$_mainCount / 11',
//                     style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold,
//                         color: _mainCount == 11 ? Colors.green : Colors.orange)),
//               ],
//             ),
//           ),
//
//           Expanded(
//             child: ListView(
//               padding: const EdgeInsets.all(16),
//               children: groups.entries.where((e) => e.value.isNotEmpty).expand((e) => [
//                 Padding(padding: const EdgeInsets.only(top: 15, bottom: 8), child: Text(e.key, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.blueGrey))),
//                 ...e.value.map(_buildCard),
//                 const SizedBox(height: 5),
//               ]).toList(),
//             ),
//           ),
//
//           Container(
//             color: Colors.white,
//             padding: const EdgeInsets.all(20),
//             child: ElevatedButton(
//               onPressed: () => Navigator.pop(context, _tempSelected),
//               style: ElevatedButton.styleFrom(
//                   backgroundColor: Colors.orange,
//                   minimumSize: const Size(double.infinity, 56),
//                   shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))
//               ),
//               child: const Text('সম্পন্ন করুন', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildCard(PlayerModel player) {
//     final lineUpPlayer = _tempSelected.firstWhereOrNull((p) => p.playerId == player.id);
//     final selected = lineUpPlayer != null;
//     final isSub = lineUpPlayer?.isSubstitute ?? false;
//     final isCaptain = lineUpPlayer?.isCaptain ?? false;
//
//     return Card(
//       elevation: 2,
//       margin: const EdgeInsets.only(bottom: 8),
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
//       child: ListTile(
//         leading: CircleAvatar(
//           backgroundColor: selected ? Colors.orange.shade100 : Colors.grey.shade200,
//           child: Text(player.jerseyNumber?.toString() ?? '?', style: TextStyle(color: selected ? Colors.orange : Colors.black54)),
//         ),
//         title: Text(player.name, style: const TextStyle(fontWeight: FontWeight.bold)),
//         subtitle: Text(player.position),
//         trailing: Row(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             if (selected && !isSub)
//               IconButton(
//                 icon: Icon(Icons.star, color: isCaptain ? Colors.amber : Colors.grey.shade300),
//                 onPressed: () => _toggleCaptain(player),
//                 tooltip: 'ক্যাপ্টেন',
//               ),
//             if (selected)
//               IconButton(
//                 icon: Icon(Icons.event_seat, color: isSub ? Colors.orange : Colors.grey.shade300),
//                 onPressed: () => _toggleSubstitute(player),
//                 tooltip: 'সাবস্টিটিউট',
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


import 'package:flutter/material.dart';
import '../../models/player_model.dart';
import '../../models/match_model.dart';

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
  final List<PlayerLineUp> selectedPlayers; // এটা সবসময় সঠিক হবে (MatchLineupScreen থেকে পাস করা)
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
  String _searchQuery = "";

  @override
  void initState() {
    super.initState();
    // সবসময় widget.selectedPlayers থেকে কপি করুন — এটা MatchLineupScreen থেকে সঠিকভাবে পাস করা হবে
    _tempSelected = widget.selectedPlayers.map((e) => e.copyWith()).toList();
    _calculateMainCount();
  }

  void _calculateMainCount() {
    _mainCount = _tempSelected.where((p) => !p.isSubstitute).length;
  }

  void _togglePlayer(PlayerModel player) {
    setState(() {
      final index = _tempSelected.indexWhere((p) => p.playerId == player.id);

      if (index != -1) {
        _tempSelected.removeAt(index);
      } else {
        final bool shouldBeSub = _mainCount >= 11;
        _tempSelected.add(PlayerLineUp(
          playerId: player.id,
          playerName: player.name,
          position: player.position,
          jerseyNumber: player.jerseyNumber ?? 0,
          isSubstitute: shouldBeSub,
          isCaptain: false,
        ));

        if (shouldBeSub) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('১১ জন পূর্ণ, তাই সাবস্টিটিউট হিসেবে যোগ করা হলো।'),
              duration: Duration(seconds: 2),
            ),
          );
        }
      }
      _calculateMainCount();
    });
  }

  void _toggleSubstitute(PlayerModel player) {
    setState(() {
      final index = _tempSelected.indexWhere((p) => p.playerId == player.id);
      if (index == -1) return;

      final currentSub = _tempSelected[index].isSubstitute;

      if (currentSub && _mainCount >= 11) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('মূল একাদশে ১১ জনের বেশি সম্ভব নয়।')),
        );
        return;
      }

      _tempSelected[index] = _tempSelected[index].copyWith(
        isSubstitute: !currentSub,
        isCaptain: currentSub ? _tempSelected[index].isCaptain : false,
      );
      _calculateMainCount();
    });
  }

  void _toggleCaptain(PlayerModel player) {
    setState(() {
      _tempSelected = _tempSelected.map((p) => p.copyWith(isCaptain: false)).toList();

      final index = _tempSelected.indexWhere((p) => p.playerId == player.id);
      if (index != -1) {
        _tempSelected[index] = _tempSelected[index].copyWith(
          isCaptain: true,
          isSubstitute: false,
        );
      }
      _calculateMainCount();
    });
  }

  void _editJersey(PlayerModel player) async {
    final index = _tempSelected.indexWhere((p) => p.playerId == player.id);
    if (index == -1) return;

    final controller = TextEditingController(text: _tempSelected[index].jerseyNumber.toString());

    final newNum = await showDialog<int>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: Colors.grey.shade50,
        title: const Text('জার্সি নাম্বার এডিট করুন'),
        content: TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            hintText: '1-99',
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            filled: true,
            fillColor: Colors.white,
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('বাতিল')),
          ElevatedButton(
            onPressed: () {
              final num = int.tryParse(controller.text) ?? 0;
              Navigator.pop(ctx, num.clamp(1, 99));
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
            child: const Text('সেভ'),
          ),
        ],
      ),
    );

    if (newNum != null) {
      setState(() {
        _tempSelected[index] = _tempSelected[index].copyWith(jerseyNumber: newNum);
      });
    }
  }

  Map<String, List<PlayerModel>> _groupPlayers(List<PlayerModel> players) {
    final map = <String, List<PlayerModel>>{
      'গোলকিপার': [],
      'ডিফেন্ডার': [],
      'মিডফিল্ডার': [],
      'ফরওয়ার্ড': [],
    };
    for (var p in players) {
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
    final filtered = widget.allPlayers
        .where((p) => p.name.toLowerCase().contains(_searchQuery.toLowerCase()))
        .toList();
    final groups = _groupPlayers(filtered);

    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        title: Text('লাইনআপ — ${widget.teamName}'),
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: Colors.black,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'খেলোয়াড় খুঁজুন...',
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
              onChanged: (v) => setState(() => _searchQuery = v),
            ),
          ),
          Container(
            color: Colors.white,
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('মূল একাদশ নির্বাচন', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
                Text(
                  '$_mainCount / 11',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: _mainCount == 11
                        ? Colors.green
                        : (_mainCount > 11 ? Colors.red : Colors.orange),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: groups.entries.where((e) => e.value.isNotEmpty).isEmpty
                ? const Center(child: Text('কোনো খেলোয়াড় পাওয়া যায়নি'))
                : ListView(
              padding: const EdgeInsets.all(16),
              children: groups.entries
                  .where((e) => e.value.isNotEmpty)
                  .expand((e) => [
                Padding(
                  padding: const EdgeInsets.only(top: 15, bottom: 8),
                  child: Text(
                    e.key,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.blueGrey,
                    ),
                  ),
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
              child: const Text(
                'সম্পন্ন করুন',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
              ),
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
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: ListTile(
        onTap: selected ? () => _editJersey(player) : null,
        leading: CircleAvatar(
          backgroundColor: selected ? Colors.orange.shade100 : Colors.grey.shade200,
          child: Text(
            '#${lineUpPlayer?.jerseyNumber ?? player.jerseyNumber ?? '?'}',
            style: TextStyle(
              color: selected ? Colors.orange.shade800 : Colors.black54,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        title: Text(player.name, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(player.position),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (selected && !isSub)
              IconButton(
                icon: Icon(Icons.star, color: isCaptain ? Colors.amber : Colors.grey.shade400),
                onPressed: () => _toggleCaptain(player),
                tooltip: 'ক্যাপ্টেন',
              ),
            if (selected)
              IconButton(
                icon: Icon(Icons.event_seat, color: isSub ? Colors.orange : Colors.grey.shade400),
                onPressed: () => _toggleSubstitute(player),
                tooltip: 'সাবস্টিটিউট',
              ),
            IconButton(
              icon: Icon(
                selected ? Icons.check_circle : Icons.add_circle_outline,
                color: selected ? Colors.green : Colors.grey.shade600,
                size: 28,
              ),
              onPressed: () => _togglePlayer(player),
            ),
          ],
        ),
      ),
    );
  }
}