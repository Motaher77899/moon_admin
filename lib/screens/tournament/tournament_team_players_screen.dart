// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
//
// // Models
// import '../../models/team_model.dart';
// import '../../models/player_model.dart';
//
// // Providers
// import '../../providers/team_provider.dart';
//
// /// Admin screen to select players for a team in a tournament
// class TournamentTeamPlayersScreen extends StatefulWidget {
//   final String tournamentId;
//   final String tournamentName;
//   final TeamModel team;
//   final TeamProvider teamProvider; // ✅ Added TeamProvider parameter
//
//   const TournamentTeamPlayersScreen({
//     Key? key,
//     required this.tournamentId,
//     required this.tournamentName,
//     required this.team,
//     required this.teamProvider, // ✅ Required parameter
//   }) : super(key: key);
//
//   @override
//   State<TournamentTeamPlayersScreen> createState() =>
//       _TournamentTeamPlayersScreenState();
// }
//
// class _TournamentTeamPlayersScreenState
//     extends State<TournamentTeamPlayersScreen> {
//   final Set<String> _selectedPlayerIds = {};
//   bool _isLoading = true;
//   bool _isSaving = false;
//
//   @override
//   void initState() {
//     super.initState();
//     _loadSelectedPlayers();
//   }
//
//   // Load previously selected players for this tournament + team
//   Future<void> _loadSelectedPlayers() async {
//     try {
//       final doc = await FirebaseFirestore.instance
//           .collection('tournament_team_players')
//           .doc('${widget.tournamentId}_${widget.team.id}')
//           .get();
//
//       if (doc.exists) {
//         final data = doc.data() as Map<String, dynamic>;
//         final playerIds = List<String>.from(data['playerIds'] ?? []);
//
//         setState(() {
//           _selectedPlayerIds.addAll(playerIds);
//           _isLoading = false;
//         });
//       } else {
//         setState(() {
//           _isLoading = false;
//         });
//       }
//     } catch (e) {
//       debugPrint('Error loading selected players: $e');
//       setState(() {
//         _isLoading = false;
//       });
//     }
//   }
//
//   // Save selected players to Firestore
//   Future<void> _saveSelectedPlayers() async {
//     setState(() {
//       _isSaving = true;
//     });
//
//     try {
//       await FirebaseFirestore.instance
//           .collection('tournament_team_players')
//           .doc('${widget.tournamentId}_${widget.team.id}')
//           .set({
//         'tournamentId': widget.tournamentId,
//         'tournamentName': widget.tournamentName,
//         'teamId': widget.team.id,
//         'teamName': widget.team.name,
//         'playerIds': _selectedPlayerIds.toList(),
//         'updatedAt': FieldValue.serverTimestamp(),
//       });
//
//       if (mounted) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(
//             content: Text(
//               '${_selectedPlayerIds.length}টি খেলোয়াড় সংরক্ষিত হয়েছে',
//               style: const TextStyle(fontSize: 16),
//             ),
//             backgroundColor: Colors.green,
//             duration: const Duration(seconds: 2),
//           ),
//         );
//         Navigator.pop(context);
//       }
//     } catch (e) {
//       debugPrint('Error saving players: $e');
//       if (mounted) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(
//             content: Text('Error: $e'),
//             backgroundColor: Colors.red,
//           ),
//         );
//       }
//     } finally {
//       if (mounted) {
//         setState(() {
//           _isSaving = false;
//         });
//       }
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xFF1A1A2E),
//       appBar: AppBar(
//         backgroundColor: const Color(0xFF16213E),
//         title: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(
//               widget.team.name,
//               style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//             ),
//             Text(
//               widget.tournamentName,
//               style: const TextStyle(fontSize: 12, color: Colors.white70),
//             ),
//           ],
//         ),
//         actions: [
//           if (_selectedPlayerIds.isNotEmpty)
//             Container(
//               margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
//               padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
//               decoration: BoxDecoration(
//                 color: Colors.orange.shade700,
//                 borderRadius: BorderRadius.circular(20),
//               ),
//               child: Text(
//                 '${_selectedPlayerIds.length} নির্বাচিত',
//                 style: const TextStyle(
//                   color: Colors.white,
//                   fontSize: 14,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//             ),
//         ],
//       ),
//       body: _isLoading
//           ? const Center(
//         child: CircularProgressIndicator(color: Colors.orange),
//       )
//           : StreamBuilder<QuerySnapshot>(
//         stream: FirebaseFirestore.instance
//             .collection('players')
//             .where('teamId', isEqualTo: widget.team.id)
//             .snapshots(),
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return const Center(
//               child: CircularProgressIndicator(color: Colors.orange),
//             );
//           }
//
//           if (snapshot.hasError) {
//             return Center(
//               child: Text(
//                 'Error: ${snapshot.error}',
//                 style: const TextStyle(color: Colors.red),
//               ),
//             );
//           }
//
//           if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
//             return Center(
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   Icon(
//                     Icons.people_outline,
//                     size: 80,
//                     color: Colors.grey.shade700,
//                   ),
//                   const SizedBox(height: 16),
//                   Text(
//                     'এই টিমে কোন খেলোয়াড় নেই',
//                     style: TextStyle(
//                       color: Colors.grey.shade600,
//                       fontSize: 18,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                 ],
//               ),
//             );
//           }
//
//           final players = snapshot.data!.docs
//               .map((doc) {
//             try {
//               return PlayerModel.fromFirestore(doc);
//             } catch (e) {
//               debugPrint('Error parsing player: $e');
//               return null;
//             }
//           })
//               .whereType<PlayerModel>()
//               .toList();
//
//           // Sort: Selected first, then by name
//           players.sort((a, b) {
//             final aSelected = _selectedPlayerIds.contains(a.playerId);
//             final bSelected = _selectedPlayerIds.contains(b.playerId);
//
//             if (aSelected && !bSelected) return -1;
//             if (!aSelected && bSelected) return 1;
//             return a.name.compareTo(b.name);
//           });
//
//           return Column(
//             children: [
//               // Info Banner
//               Container(
//                 width: double.infinity,
//                 padding: const EdgeInsets.all(16),
//                 decoration: BoxDecoration(
//                   gradient: LinearGradient(
//                     colors: [
//                       Colors.orange.shade900,
//                       Colors.orange.shade700,
//                     ],
//                   ),
//                 ),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     const Text(
//                       'টুর্নামেন্টের জন্য খেলোয়াড় নির্বাচন করুন',
//                       style: TextStyle(
//                         color: Colors.white,
//                         fontSize: 16,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                     const SizedBox(height: 4),
//                     Text(
//                       'মোট ${players.length}টি খেলোয়াড় পাওয়া গেছে',
//                       style: const TextStyle(
//                         color: Colors.white70,
//                         fontSize: 14,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//
//               // Players List
//               Expanded(
//                 child: ListView.builder(
//                   padding: const EdgeInsets.all(16),
//                   itemCount: players.length,
//                   itemBuilder: (context, index) {
//                     final player = players[index];
//                     final isSelected =
//                     _selectedPlayerIds.contains(player.playerId);
//
//                     return _buildPlayerCard(player, isSelected);
//                   },
//                 ),
//               ),
//             ],
//           );
//         },
//       ),
//       bottomNavigationBar: _selectedPlayerIds.isEmpty
//           ? null
//           : Container(
//         padding: const EdgeInsets.all(16),
//         decoration: BoxDecoration(
//           color: const Color(0xFF16213E),
//           boxShadow: [
//             BoxShadow(
//               color: Colors.black.withOpacity(0.2),
//               blurRadius: 10,
//               offset: const Offset(0, -3),
//             ),
//           ],
//         ),
//         child: SafeArea(
//           child: SizedBox(
//             width: double.infinity,
//             child: ElevatedButton(
//               onPressed: _isSaving ? null : _saveSelectedPlayers,
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: Colors.orange.shade700,
//                 foregroundColor: Colors.white,
//                 padding: const EdgeInsets.symmetric(vertical: 16),
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(12),
//                 ),
//               ),
//               child: _isSaving
//                   ? const SizedBox(
//                 height: 20,
//                 width: 20,
//                 child: CircularProgressIndicator(
//                   color: Colors.white,
//                   strokeWidth: 2,
//                 ),
//               )
//                   : Text(
//                 '${_selectedPlayerIds.length}টি খেলোয়াড় সংরক্ষণ করুন',
//                 style: const TextStyle(
//                   fontSize: 16,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget _buildPlayerCard(PlayerModel player, bool isSelected) {
//     return Container(
//       margin: const EdgeInsets.only(bottom: 12),
//       decoration: BoxDecoration(
//         color: const Color(0xFF16213E),
//         borderRadius: BorderRadius.circular(12),
//         border: Border.all(
//           color: isSelected
//               ? Colors.orange.shade700
//               : Colors.white.withOpacity(0.1),
//           width: isSelected ? 2 : 1,
//         ),
//         boxShadow: isSelected
//             ? [
//           BoxShadow(
//             color: Colors.orange.shade700.withOpacity(0.3),
//             blurRadius: 8,
//             offset: const Offset(0, 2),
//           ),
//         ]
//             : null,
//       ),
//       child: Material(
//         color: Colors.transparent,
//         child: InkWell(
//           onTap: () {
//             setState(() {
//               if (isSelected) {
//                 _selectedPlayerIds.remove(player.playerId);
//               } else {
//                 _selectedPlayerIds.add(player.playerId);
//               }
//             });
//           },
//           borderRadius: BorderRadius.circular(12),
//           child: Padding(
//             padding: const EdgeInsets.all(16),
//             child: Row(
//               children: [
//                 // Selection Checkbox
//                 Container(
//                   width: 24,
//                   height: 24,
//                   decoration: BoxDecoration(
//                     color: isSelected
//                         ? Colors.orange.shade700
//                         : Colors.transparent,
//                     border: Border.all(
//                       color: isSelected
//                           ? Colors.orange.shade700
//                           : Colors.grey.shade600,
//                       width: 2,
//                     ),
//                     borderRadius: BorderRadius.circular(6),
//                   ),
//                   child: isSelected
//                       ? const Icon(
//                     Icons.check,
//                     color: Colors.white,
//                     size: 18,
//                   )
//                       : null,
//                 ),
//
//                 const SizedBox(width: 16),
//
//                 // Player Photo
//                 CircleAvatar(
//                   radius: 30,
//                   backgroundColor: Colors.orange.shade700.withOpacity(0.2),
//                   backgroundImage: player.profilePhotoUrl != null &&
//                       player.profilePhotoUrl!.isNotEmpty
//                       ? NetworkImage(player.profilePhotoUrl!)
//                       : null,
//                   child: player.profilePhotoUrl == null || player.profilePhotoUrl!.isEmpty
//                       ? Text(
//                     player.name.isNotEmpty
//                         ? player.name[0].toUpperCase()
//                         : '?',
//                     style: TextStyle(
//                       color: Colors.orange.shade700,
//                       fontSize: 24,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   )
//                       : null,
//                 ),
//
//                 const SizedBox(width: 16),
//
//                 // Player Info
//                 Expanded(
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(
//                         player.name,
//                         style: const TextStyle(
//                           color: Colors.white,
//                           fontSize: 16,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                       const SizedBox(height: 4),
//                       Row(
//                         children: [
//                           // Jersey Number
//                           if (player.jerseyNumber != null)
//                             Container(
//                               padding: const EdgeInsets.symmetric(
//                                 horizontal: 8,
//                                 vertical: 2,
//                               ),
//                               decoration: BoxDecoration(
//                                 color: Colors.grey.shade800,
//                                 borderRadius: BorderRadius.circular(4),
//                               ),
//                               child: Text(
//                                 '#${player.jerseyNumber}',
//                                 style: const TextStyle(
//                                   color: Colors.white70,
//                                   fontSize: 12,
//                                   fontWeight: FontWeight.bold,
//                                 ),
//                               ),
//                             ),
//                           const SizedBox(width: 8),
//                           // Position
//                           if (player.position != null &&
//                               player.position!.isNotEmpty)
//                             Container(
//                               padding: const EdgeInsets.symmetric(
//                                 horizontal: 8,
//                                 vertical: 2,
//                               ),
//                               decoration: BoxDecoration(
//                                 color: Colors.orange.shade900.withOpacity(0.3),
//                                 borderRadius: BorderRadius.circular(4),
//                               ),
//                               child: Text(
//                                 player.position!,
//                                 style: TextStyle(
//                                   color: Colors.orange.shade300,
//                                   fontSize: 12,
//                                   fontWeight: FontWeight.bold,
//                                 ),
//                               ),
//                             ),
//                         ],
//                       ),
//                     ],
//                   ),
//                 ),
//
//                 // Selected Badge
//                 if (isSelected)
//                   Container(
//                     padding: const EdgeInsets.symmetric(
//                       horizontal: 12,
//                       vertical: 6,
//                     ),
//                     decoration: BoxDecoration(
//                       color: Colors.orange.shade700,
//                       borderRadius: BorderRadius.circular(20),
//                     ),
//                     child: const Text(
//                       'নির্বাচিত',
//                       style: TextStyle(
//                         color: Colors.white,
//                         fontSize: 12,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                   ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }


import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// Models
import '../../models/team_model.dart';
import '../../models/player_model.dart';

// Providers
import '../../providers/team_provider.dart';

/// Admin screen to select players for a team in a tournament - Professional Design
class TournamentTeamPlayersScreen extends StatefulWidget {
  final String tournamentId;
  final String tournamentName;
  final TeamModel team;
  final TeamProvider teamProvider;

  const TournamentTeamPlayersScreen({
    Key? key,
    required this.tournamentId,
    required this.tournamentName,
    required this.team,
    required this.teamProvider,
  }) : super(key: key);

  @override
  State<TournamentTeamPlayersScreen> createState() =>
      _TournamentTeamPlayersScreenState();
}

class _TournamentTeamPlayersScreenState
    extends State<TournamentTeamPlayersScreen> {
  final Set<String> _selectedPlayerIds = {};
  bool _isLoading = true;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _loadSelectedPlayers();
  }

  Future<void> _loadSelectedPlayers() async {
    try {
      final doc = await FirebaseFirestore.instance
          .collection('tournament_team_players')
          .doc('${widget.tournamentId}_${widget.team.id}')
          .get();

      if (doc.exists) {
        final data = doc.data() as Map<String, dynamic>;
        final playerIds = List<String>.from(data['playerIds'] ?? []);

        setState(() {
          _selectedPlayerIds.addAll(playerIds);
          _isLoading = false;
        });
      } else {
        setState(() {
          _isLoading = false;
        });
      }
    } catch (e) {
      debugPrint('Error loading selected players: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _saveSelectedPlayers() async {
    setState(() {
      _isSaving = true;
    });

    try {
      await FirebaseFirestore.instance
          .collection('tournament_team_players')
          .doc('${widget.tournamentId}_${widget.team.id}')
          .set({
        'tournamentId': widget.tournamentId,
        'tournamentName': widget.tournamentName,
        'teamId': widget.team.id,
        'teamName': widget.team.name,
        'playerIds': _selectedPlayerIds.toList(),
        'updatedAt': FieldValue.serverTimestamp(),
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                const Icon(Icons.check_circle, color: Colors.white),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    '${_selectedPlayerIds.length}টি খেলোয়াড় সফলভাবে সংরক্ষিত হয়েছে',
                    style: const TextStyle(fontSize: 15),
                  ),
                ),
              ],
            ),
            backgroundColor: const Color(0xFF4CAF50),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            margin: const EdgeInsets.all(16),
            duration: const Duration(seconds: 3),
          ),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      debugPrint('Error saving players: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                const Icon(Icons.error_outline, color: Colors.white),
                const SizedBox(width: 12),
                Expanded(child: Text('সংরক্ষণ করতে সমস্যা: $e')),
              ],
            ),
            backgroundColor: Colors.red.shade600,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            margin: const EdgeInsets.all(16),
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isSaving = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F1419),
      appBar: _buildAppBar(),
      body: _isLoading ? _buildLoadingState() : _buildBody(),
      bottomNavigationBar: _selectedPlayerIds.isEmpty ? null : _buildSaveButton(),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      elevation: 0,
      backgroundColor: const Color(0xFF1C2128),
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
        onPressed: () => Navigator.pop(context),
      ),
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.team.name,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 2),
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.orange.shade700.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(4),
                  border: Border.all(color: Colors.orange.shade700, width: 1),
                ),
                child: Text(
                  widget.tournamentName,
                  style: TextStyle(
                    fontSize: 11,
                    color: Colors.orange.shade300,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
      actions: [
        if (_selectedPlayerIds.isNotEmpty)
          Center(
            child: Container(
              margin: const EdgeInsets.only(right: 16),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.orange.shade600, Colors.orange.shade800],
                ),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.orange.shade700.withOpacity(0.4),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.check_circle, color: Colors.white, size: 18),
                  const SizedBox(width: 6),
                  Text(
                    '${_selectedPlayerIds.length}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildLoadingState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(
            color: Colors.orange.shade700,
            strokeWidth: 3,
          ),
          const SizedBox(height: 24),
          Text(
            'খেলোয়াড় তালিকা লোড হচ্ছে...',
            style: TextStyle(
              color: Colors.grey.shade400,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBody() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('players')
          .where('teamId', isEqualTo: widget.team.id)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return _buildLoadingState();
        }

        if (snapshot.hasError) {
          return _buildErrorState(snapshot.error.toString());
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return _buildEmptyState();
        }

        final players = snapshot.data!.docs
            .map((doc) {
          try {
            return PlayerModel.fromFirestore(doc);
          } catch (e) {
            debugPrint('Error parsing player: $e');
            return null;
          }
        })
            .whereType<PlayerModel>()
            .toList();

        // Sort: Selected first, then by name
        players.sort((a, b) {
          final aSelected = _selectedPlayerIds.contains(a.playerId);
          final bSelected = _selectedPlayerIds.contains(b.playerId);

          if (aSelected && !bSelected) return -1;
          if (!aSelected && bSelected) return 1;
          return a.name.compareTo(b.name);
        });

        return Column(
          children: [
            _buildStatsHeader(players.length),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: players.length,
                itemBuilder: (context, index) {
                  final player = players[index];
                  final isSelected = _selectedPlayerIds.contains(player.playerId);
                  return _buildPlayerCard(player, isSelected, index);
                },
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildStatsHeader(int totalPlayers) {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.orange.shade800,
            Colors.orange.shade600,
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.orange.shade900.withOpacity(0.3),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.people,
              color: Colors.white,
              size: 28,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'টুর্নামেন্ট স্কোয়াড নির্বাচন',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Text(
                      'মোট $totalPlayers জন',
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 13,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Container(
                      width: 4,
                      height: 4,
                      decoration: const BoxDecoration(
                        color: Colors.white70,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      '${_selectedPlayerIds.length} নির্বাচিত',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPlayerCard(PlayerModel player, bool isSelected, int index) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: const Color(0xFF1C2128),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isSelected
              ? Colors.orange.shade600
              : Colors.white.withOpacity(0.05),
          width: isSelected ? 2 : 1,
        ),
        boxShadow: isSelected
            ? [
          BoxShadow(
            color: Colors.orange.shade600.withOpacity(0.2),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ]
            : null,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            setState(() {
              if (isSelected) {
                _selectedPlayerIds.remove(player.playerId);
              } else {
                _selectedPlayerIds.add(player.playerId);
              }
            });
          },
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                // Animated Checkbox
                AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  width: 28,
                  height: 28,
                  decoration: BoxDecoration(
                    gradient: isSelected
                        ? LinearGradient(
                      colors: [Colors.orange.shade600, Colors.orange.shade800],
                    )
                        : null,
                    color: isSelected ? null : Colors.transparent,
                    border: Border.all(
                      color: isSelected
                          ? Colors.transparent
                          : Colors.grey.shade600,
                      width: 2,
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: isSelected
                      ? const Icon(
                    Icons.check_rounded,
                    color: Colors.white,
                    size: 20,
                  )
                      : null,
                ),

                const SizedBox(width: 16),

                // Player Photo with Badge
                Stack(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: isSelected
                              ? Colors.orange.shade600
                              : Colors.white.withOpacity(0.1),
                          width: 2,
                        ),
                      ),
                      child: CircleAvatar(
                        radius: 32,
                        backgroundColor: Colors.orange.shade700.withOpacity(0.15),
                        backgroundImage: player.profilePhotoUrl != null &&
                            player.profilePhotoUrl!.isNotEmpty
                            ? NetworkImage(player.profilePhotoUrl!)
                            : null,
                        child: player.profilePhotoUrl == null ||
                            player.profilePhotoUrl!.isEmpty
                            ? Text(
                          player.name.isNotEmpty
                              ? player.name[0].toUpperCase()
                              : '?',
                          style: TextStyle(
                            color: Colors.orange.shade600,
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                          ),
                        )
                            : null,
                      ),
                    ),
                    if (isSelected)
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [Colors.orange.shade600, Colors.orange.shade800],
                            ),
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: const Color(0xFF1C2128),
                              width: 2,
                            ),
                          ),
                          child: const Icon(
                            Icons.check,
                            color: Colors.white,
                            size: 12,
                          ),
                        ),
                      ),
                  ],
                ),

                const SizedBox(width: 16),

                // Player Info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        player.name,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          // Jersey Number
                          if (player.jerseyNumber != null)
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.grey.shade800.withOpacity(0.5),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(
                                    Icons.tag,
                                    size: 14,
                                    color: Colors.white70,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    '${player.jerseyNumber}',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 13,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          if (player.jerseyNumber != null &&
                              player.position != null &&
                              player.position!.isNotEmpty)
                            const SizedBox(width: 8),
                          // Position
                          if (player.position != null && player.position!.isNotEmpty)
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.orange.shade800.withOpacity(0.3),
                                borderRadius: BorderRadius.circular(6),
                                border: Border.all(
                                  color: Colors.orange.shade700.withOpacity(0.3),
                                  width: 1,
                                ),
                              ),
                              child: Text(
                                player.position!,
                                style: TextStyle(
                                  color: Colors.orange.shade300,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ],
                  ),
                ),

                // Selection Indicator
                if (isSelected)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Colors.orange.shade600, Colors.orange.shade800],
                      ),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Text(
                      '✓',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  )
                else
                  Icon(
                    Icons.arrow_forward_ios,
                    color: Colors.grey.shade600,
                    size: 16,
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSaveButton() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF1C2128),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          children: [
            Expanded(
              child: Container(
                height: 56,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.orange.shade600, Colors.orange.shade800],
                  ),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.orange.shade600.withOpacity(0.4),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: _isSaving ? null : _saveSelectedPlayers,
                    borderRadius: BorderRadius.circular(16),
                    child: Center(
                      child: _isSaving
                          ? const SizedBox(
                        height: 24,
                        width: 24,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 3,
                        ),
                      )
                          : Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.save_rounded,
                            color: Colors.white,
                            size: 24,
                          ),
                          const SizedBox(width: 12),
                          Text(
                            '${_selectedPlayerIds.length}টি খেলোয়াড় সংরক্ষণ করুন',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
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
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.grey.shade800.withOpacity(0.3),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.people_outline,
              size: 80,
              color: Colors.grey.shade600,
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'এই টিমে কোন খেলোয়াড় নেই',
            style: TextStyle(
              color: Colors.grey.shade400,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'প্রথমে খেলোয়াড় যোগ করুন',
            style: TextStyle(
              color: Colors.grey.shade600,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(String error) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline, size: 80, color: Colors.red.shade400),
          const SizedBox(height: 16),
          Text(
            'Error: $error',
            style: TextStyle(color: Colors.red.shade300, fontSize: 14),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}