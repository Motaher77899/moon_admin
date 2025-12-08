// // //
// // // import 'package:flutter/material.dart';
// // // import 'package:cloud_firestore/cloud_firestore.dart';
// // // import 'package:firebase_auth/firebase_auth.dart';
// // // import '../models/match_model.dart';
// // // import '../models/team_model.dart';
// // // import '../models/player_model.dart';
// // //
// // // class MatchProvider extends ChangeNotifier {
// // //   final FirebaseFirestore _firestore = FirebaseFirestore.instance;
// // //
// // //   List<MatchModel> _matches = [];
// // //   List<TeamModel> _teams = [];
// // //   List<PlayerModel> _players = [];
// // //   bool _isLoading = false;
// // //
// // //   List<MatchModel> get matches => _matches;
// // //   List<TeamModel> get teams => _teams;
// // //   List<PlayerModel> get players => _players;
// // //   bool get isLoading => _isLoading;
// // //
// // //   // ✅ Load ALL teams (shared resource)
// // //   Future<void> loadTeams() async {
// // //     try {
// // //       _isLoading = true;
// // //       notifyListeners();
// // //
// // //       QuerySnapshot snapshot = await _firestore
// // //           .collection('teams')
// // //           .orderBy('name')
// // //           .get();
// // //
// // //       _teams = snapshot.docs
// // //           .map((doc) => TeamModel.fromFirestore(doc))
// // //           .toList();
// // //
// // //       print('✅ Loaded ${_teams.length} teams');
// // //
// // //       _isLoading = false;
// // //       notifyListeners();
// // //     } catch (e) {
// // //       print('❌ Error loading teams: $e');
// // //       _isLoading = false;
// // //       notifyListeners();
// // //     }
// // //   }
// // //
// // //   // Load players by team
// // //   Future<List<PlayerModel>> loadPlayersByTeam(String teamId) async {
// // //     try {
// // //       print('🔍 Loading players for team: $teamId');
// // //
// // //       DocumentSnapshot teamDoc = await _firestore
// // //           .collection('teams')
// // //           .doc(teamId)
// // //           .get();
// // //
// // //       if (!teamDoc.exists) {
// // //         print('❌ Team not found: $teamId');
// // //         return [];
// // //       }
// // //
// // //       Map<String, dynamic> teamData = teamDoc.data() as Map<String, dynamic>;
// // //       List<String> playerIds = List<String>.from(teamData['playerIds'] ?? []);
// // //       String teamName = teamData['name'] ?? '';
// // //
// // //       print('👥 Team "$teamName" has ${playerIds.length} player IDs');
// // //
// // //       if (playerIds.isEmpty) {
// // //         print('⚠️ No players in team');
// // //         return [];
// // //       }
// // //
// // //       List<PlayerModel> players = [];
// // //
// // //       for (int i = 0; i < playerIds.length; i += 10) {
// // //         int end = (i + 10 < playerIds.length) ? i + 10 : playerIds.length;
// // //         List<String> batch = playerIds.sublist(i, end);
// // //
// // //         QuerySnapshot querySnapshot = await _firestore
// // //             .collection('players')
// // //             .where('playerId', whereIn: batch)
// // //             .get();
// // //
// // //         for (var doc in querySnapshot.docs) {
// // //           try {
// // //             PlayerModel player = PlayerModel.fromFirestore(doc);
// // //             players.add(player);
// // //             print('✓ Loaded: ${player.name}');
// // //           } catch (e) {
// // //             print('✗ Error parsing player ${doc.id}: $e');
// // //           }
// // //         }
// // //       }
// // //
// // //       print('✅ Total loaded players: ${players.length}');
// // //       return players;
// // //     } catch (e) {
// // //       print('❌ Error in loadPlayersByTeam: $e');
// // //       return [];
// // //     }
// // //   }
// // //
// // //   // ✅ Load matches by specific admin (with admin full name)
// // //   Future<void> loadMatchesByAdmin(String adminFullName) async {
// // //     try {
// // //       _isLoading = true;
// // //       notifyListeners();
// // //
// // //       print('🔍 Loading matches for admin: $adminFullName');
// // //
// // //       QuerySnapshot snapshot = await _firestore
// // //           .collection('matches')
// // //           .where('createdBy', isEqualTo: adminFullName)
// // //           .orderBy('matchDate', descending: true)
// // //           .get();
// // //
// // //       _matches = snapshot.docs
// // //           .map((doc) => MatchModel.fromFirestore(doc))
// // //           .toList();
// // //
// // //       print('✅ Loaded ${_matches.length} matches for $adminFullName');
// // //
// // //       _isLoading = false;
// // //       notifyListeners();
// // //     } catch (e) {
// // //       print('❌ Error loading matches: $e');
// // //       _isLoading = false;
// // //       notifyListeners();
// // //     }
// // //   }
// // //
// // //   // Load all players
// // //   Future<void> loadAllPlayers() async {
// // //     try {
// // //       QuerySnapshot snapshot = await _firestore.collection('players').get();
// // //       _players = snapshot.docs
// // //           .map((doc) => PlayerModel.fromFirestore(doc))
// // //           .toList();
// // //       notifyListeners();
// // //     } catch (e) {
// // //       print('Error loading players: $e');
// // //     }
// // //   }
// // //
// // //   // ✅ Create match with admin full name
// // //   Future<String?> createMatch(MatchModel match, String adminFullName) async {
// // //     try {
// // //       // Add createdBy field with admin full name
// // //       Map<String, dynamic> matchData = match.toFirestore();
// // //       matchData['createdBy'] = adminFullName;
// // //       matchData['createdAt'] = FieldValue.serverTimestamp();
// // //
// // //       DocumentReference docRef = await _firestore
// // //           .collection('matches')
// // //           .add(matchData);
// // //
// // //       _matches.insert(0, match.copyWith(matchId: docRef.id));
// // //       notifyListeners();
// // //
// // //       print('✅ Match created by: $adminFullName');
// // //
// // //       return null;
// // //     } catch (e) {
// // //       return 'ম্যাচ তৈরি করতে সমস্যা হয়েছে: $e';
// // //     }
// // //   }
// // //
// // //   // Update match status
// // //   Future<String?> updateMatchStatus(String matchId, String status) async {
// // //     try {
// // //       await _firestore.collection('matches').doc(matchId).update({
// // //         'status': status,
// // //       });
// // //
// // //       int index = _matches.indexWhere((m) => m.matchId == matchId);
// // //       if (index != -1) {
// // //         _matches[index] = _matches[index].copyWith(status: status);
// // //         notifyListeners();
// // //       }
// // //
// // //       return null;
// // //     } catch (e) {
// // //       return 'ম্যাচ আপডেট করতে সমস্যা হয়েছে: $e';
// // //     }
// // //   }
// // //
// // //   // Update match score
// // //   Future<String?> updateMatchScore(String matchId, int teamAScore, int teamBScore) async {
// // //     try {
// // //       await _firestore.collection('matches').doc(matchId).update({
// // //         'teamAScore': teamAScore,
// // //         'teamBScore': teamBScore,
// // //         'scoreA': teamAScore,
// // //         'scoreB': teamBScore,
// // //       });
// // //
// // //       int index = _matches.indexWhere((m) => m.matchId == matchId);
// // //       if (index != -1) {
// // //         _matches[index] = _matches[index].copyWith(
// // //           teamAScore: teamAScore,
// // //           teamBScore: teamBScore,
// // //         );
// // //         notifyListeners();
// // //       }
// // //
// // //       return null;
// // //     } catch (e) {
// // //       return 'স্কোর আপডেট করতে সমস্যা হয়েছে: $e';
// // //     }
// // //   }
// // //
// // //   // Update lineup
// // //   Future<String?> updateLineup(String matchId, String team, LineUp lineup) async {
// // //     try {
// // //       String field = team == 'teamA' ? 'lineUpA' : 'lineUpB';
// // //       await _firestore.collection('matches').doc(matchId).update({
// // //         field: lineup.toMap(),
// // //       });
// // //
// // //       int index = _matches.indexWhere((m) => m.matchId == matchId);
// // //       if (index != -1) {
// // //         if (team == 'teamA') {
// // //           _matches[index] = _matches[index].copyWith(lineUpA: lineup);
// // //         } else {
// // //           _matches[index] = _matches[index].copyWith(lineUpB: lineup);
// // //         }
// // //         notifyListeners();
// // //       }
// // //
// // //       return null;
// // //     } catch (e) {
// // //       return 'লাইনআপ আপডেট করতে সমস্যা হয়েছে: $e';
// // //     }
// // //   }
// // //
// // //   // Add timeline event
// // //   Future<String?> addTimelineEvent(String matchId, MatchEvent event) async {
// // //     try {
// // //       int index = _matches.indexWhere((m) => m.matchId == matchId);
// // //       if (index == -1) return 'ম্যাচ খুঁজে পাওয়া যায়নি';
// // //
// // //       List<MatchEvent> updatedTimeline = [..._matches[index].timeline, event];
// // //
// // //       await _firestore.collection('matches').doc(matchId).update({
// // //         'timeline': updatedTimeline.map((e) => e.toMap()).toList(),
// // //       });
// // //
// // //       _matches[index] = _matches[index].copyWith(timeline: updatedTimeline);
// // //       notifyListeners();
// // //
// // //       return null;
// // //     } catch (e) {
// // //       return 'টাইমলাইন আপডেট করতে সমস্যা হয়েছে: $e';
// // //     }
// // //   }
// // //
// // //   // Update statistics
// // //   Future<String?> updateStats(String matchId, MatchStats stats) async {
// // //     try {
// // //       await _firestore.collection('matches').doc(matchId).update({
// // //         'stats': stats.toMap(),
// // //       });
// // //
// // //       int index = _matches.indexWhere((m) => m.matchId == matchId);
// // //       if (index != -1) {
// // //         _matches[index] = _matches[index].copyWith(stats: stats);
// // //         notifyListeners();
// // //       }
// // //
// // //       return null;
// // //     } catch (e) {
// // //       return 'পরিসংখ্যান আপডেট করতে সমস্যা হয়েছে: $e';
// // //     }
// // //   }
// // //
// // //   // Delete match
// // //   Future<String?> deleteMatch(String matchId) async {
// // //     try {
// // //       await _firestore.collection('matches').doc(matchId).delete();
// // //       _matches.removeWhere((m) => m.matchId == matchId);
// // //       notifyListeners();
// // //
// // //       return null;
// // //     } catch (e) {
// // //       return 'ম্যাচ মুছতে সমস্যা হয়েছে: $e';
// // //     }
// // //   }
// // //
// // //   // Get match by ID
// // //   MatchModel? getMatchById(String matchId) {
// // //     try {
// // //       return _matches.firstWhere((m) => m.matchId == matchId);
// // //     } catch (e) {
// // //       return null;
// // //     }
// // //   }
// // //
// // //   // Calculate stats from timeline
// // //   MatchStats calculateStatsFromTimeline(MatchModel match) {
// // //     int yellowCardsA = 0;
// // //     int yellowCardsB = 0;
// // //     int redCardsA = 0;
// // //     int redCardsB = 0;
// // //
// // //     for (var event in match.timeline) {
// // //       if (event.type == 'card') {
// // //         if (event.details == 'yellow_card') {
// // //           if (event.team == 'teamA') {
// // //             yellowCardsA++;
// // //           } else {
// // //             yellowCardsB++;
// // //           }
// // //         } else if (event.details == 'red_card') {
// // //           if (event.team == 'teamA') {
// // //             redCardsA++;
// // //           } else {
// // //             redCardsB++;
// // //           }
// // //         }
// // //       }
// // //     }
// // //
// // //     return (match.stats ?? MatchStats()).copyWith(
// // //       yellowCardsA: yellowCardsA,
// // //       yellowCardsB: yellowCardsB,
// // //       redCardsA: redCardsA,
// // //       redCardsB: redCardsB,
// // //     );
// // //   }
// // // }
// //
// // import 'package:flutter/material.dart';
// // import 'package:cloud_firestore/cloud_firestore.dart';
// // import '../models/match_model.dart';
// //
// // class MatchProvider extends ChangeNotifier {
// //   List<MatchModel> _matches = [];
// //   bool _isLoading = false;
// //   String? _error;
// //
// //   List<MatchModel> get matches => _matches;
// //   bool get isLoading => _isLoading;
// //   String? get error => _error;
// //
// //   // ✅ Get match by ID
// //   MatchModel? getMatchById(String matchId) {
// //     try {
// //       return _matches.firstWhere((m) => m.id == matchId);
// //     } catch (e) {
// //       debugPrint('❌ Match not found: $matchId');
// //       return null;
// //     }
// //   }
// //
// //   // ✅ Fetch all matches
// //   Future<void> fetchMatches() async {
// //     debugPrint('═══════════════════════════════════');
// //     debugPrint('🔄 Fetching matches...');
// //     debugPrint('═══════════════════════════════════');
// //
// //     _isLoading = true;
// //     _error = null;
// //     notifyListeners();
// //
// //     try {
// //       final snapshot = await FirebaseFirestore.instance
// //           .collection('matches')
// //           .orderBy('date', descending: true)
// //           .get();
// //
// //       debugPrint('📦 Found ${snapshot.docs.length} matches');
// //
// //       _matches = snapshot.docs
// //           .map((doc) => MatchModel.fromFirestore(doc))
// //           .toList();
// //
// //       debugPrint('✅ Matches loaded successfully');
// //       _isLoading = false;
// //       notifyListeners();
// //     } catch (e, stackTrace) {
// //       debugPrint('❌ Error fetching matches: $e');
// //       debugPrint('Stack: $stackTrace');
// //       _error = e.toString();
// //       _isLoading = false;
// //       notifyListeners();
// //     }
// //   }
// //
// //   // ✅ Create new match
// //   Future<String?> createMatch(MatchModel match) async {
// //     try {
// //       debugPrint('➕ Creating new match: ${match.teamAName} vs ${match.teamBName}');
// //
// //       await FirebaseFirestore.instance.collection('matches').add(match.toFirestore());
// //
// //       debugPrint('✅ Match created successfully');
// //       await fetchMatches();
// //       return null;
// //     } catch (e) {
// //       debugPrint('❌ Error creating match: $e');
// //       return e.toString();
// //     }
// //   }
// //
// //   // ✅ Update lineup
// //   Future<String?> updateLineUp(
// //       String matchId,
// //       LineUp? lineUpA,
// //       LineUp? lineUpB,
// //       ) async {
// //     try {
// //       debugPrint('📝 Updating lineup for match: $matchId');
// //
// //       Map<String, dynamic> updates = {};
// //
// //       if (lineUpA != null) {
// //         updates['lineUpA'] = lineUpA.toMap();
// //       }
// //
// //       if (lineUpB != null) {
// //         updates['lineUpB'] = lineUpB.toMap();
// //       }
// //
// //       await FirebaseFirestore.instance
// //           .collection('matches')
// //           .doc(matchId)
// //           .update(updates);
// //
// //       debugPrint('✅ Lineup updated successfully');
// //       await fetchMatches();
// //       return null;
// //     } catch (e) {
// //       debugPrint('❌ Error updating lineup: $e');
// //       return e.toString();
// //     }
// //   }
// //
// //   // ✅ Add timeline event
// //   Future<String?> addTimelineEvent(String matchId, MatchEvent event) async {
// //     try {
// //       debugPrint('📝 Adding timeline event: ${event.type}');
// //
// //       await FirebaseFirestore.instance
// //           .collection('matches')
// //           .doc(matchId)
// //           .update({
// //         'timeline': FieldValue.arrayUnion([event.toMap()])
// //       });
// //
// //       debugPrint('✅ Timeline event added');
// //       await fetchMatches();
// //       return null;
// //     } catch (e) {
// //       debugPrint('❌ Error adding timeline event: $e');
// //       return e.toString();
// //     }
// //   }
// //
// //   // ✅ Update match score
// //   Future<String?> updateMatchScore(
// //       String matchId,
// //       int scoreA,
// //       int scoreB,
// //       ) async {
// //     try {
// //       debugPrint('📝 Updating score: $scoreA - $scoreB');
// //
// //       await FirebaseFirestore.instance
// //           .collection('matches')
// //           .doc(matchId)
// //           .update({
// //         'scoreA': scoreA,
// //         'scoreB': scoreB,
// //       });
// //
// //       debugPrint('✅ Score updated');
// //       await fetchMatches();
// //       return null;
// //     } catch (e) {
// //       debugPrint('❌ Error updating score: $e');
// //       return e.toString();
// //     }
// //   }
// //
// //   // ✅ Update match status
// //   Future<String?> updateMatchStatus(String matchId, String status) async {
// //     try {
// //       debugPrint('📝 Updating status to: $status');
// //
// //       await FirebaseFirestore.instance
// //           .collection('matches')
// //           .doc(matchId)
// //           .update({'status': status});
// //
// //       debugPrint('✅ Status updated');
// //       await fetchMatches();
// //       return null;
// //     } catch (e) {
// //       debugPrint('❌ Error updating status: $e');
// //       return e.toString();
// //     }
// //   }
// //
// //   // ✅ Delete match
// //   Future<String?> deleteMatch(String matchId) async {
// //     try {
// //       debugPrint('🗑️ Deleting match: $matchId');
// //
// //       await FirebaseFirestore.instance
// //           .collection('matches')
// //           .doc(matchId)
// //           .delete();
// //
// //       debugPrint('✅ Match deleted');
// //       await fetchMatches();
// //       return null;
// //     } catch (e) {
// //       debugPrint('❌ Error deleting match: $e');
// //       return e.toString();
// //     }
// //   }
// //
// //   // Stream matches (real-time)
// //   Stream<List<MatchModel>> streamMatches() {
// //     return FirebaseFirestore.instance
// //         .collection('matches')
// //         .orderBy('date', descending: true)
// //         .snapshots()
// //         .map((snapshot) {
// //       final matches = snapshot.docs
// //           .map((doc) => MatchModel.fromFirestore(doc))
// //           .toList();
// //
// //       _matches = matches;
// //       return matches;
// //     });
// //   }
// //
// //   // Filter matches by status
// //   List<MatchModel> getMatchesByStatus(String status) {
// //     return _matches.where((m) => m.status == status).toList();
// //   }
// //
// //   // Clear cache
// //   void clearCache() {
// //     _matches.clear();
// //     _error = null;
// //     _isLoading = false;
// //     notifyListeners();
// //   }
// //
// //   // Clear error
// //   void clearError() {
// //     _error = null;
// //     notifyListeners();
// //   }
// // }
//
//
// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import '../models/match_model.dart';
// import '../models/team_model.dart';
// import '../models/player_model.dart';
//
// class MatchProvider extends ChangeNotifier {
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;
//
//   List<MatchModel> _matches = [];
//   List<TeamModel> _teams = [];
//   bool _isLoading = false;
//   String? _error;
//
//   List<MatchModel> get matches => _matches;
//   List<TeamModel> get teams => _teams;
//   bool get isLoading => _isLoading;
//   String? get error => _error;
//
//   // ✅ Get match by ID
//   MatchModel? getMatchById(String matchId) {
//     try {
//       return _matches.firstWhere((m) => m.id == matchId);
//     } catch (e) {
//       debugPrint('❌ Match not found: $matchId');
//       return null;
//     }
//   }
//
//   // ✅ Load ALL teams
//   Future<void> loadTeams() async {
//     try {
//       _isLoading = true;
//       notifyListeners();
//
//       QuerySnapshot snapshot = await _firestore
//           .collection('teams')
//           .orderBy('name')
//           .get();
//
//       _teams = snapshot.docs
//           .map((doc) => TeamModel.fromFirestore(doc))
//           .toList();
//
//       debugPrint('✅ Loaded ${_teams.length} teams');
//
//       _isLoading = false;
//       notifyListeners();
//     } catch (e) {
//       debugPrint('❌ Error loading teams: $e');
//       _isLoading = false;
//       notifyListeners();
//     }
//   }
//
//   // ✅ Load players by team
//   Future<List<PlayerModel>> loadPlayersByTeam(String teamId) async {
//     try {
//       debugPrint('🔍 Loading players for team: $teamId');
//
//       DocumentSnapshot teamDoc = await _firestore
//           .collection('teams')
//           .doc(teamId)
//           .get();
//
//       if (!teamDoc.exists) {
//         debugPrint('❌ Team not found: $teamId');
//         return [];
//       }
//
//       Map<String, dynamic> teamData = teamDoc.data() as Map<String, dynamic>;
//       List<String> playerIds = List<String>.from(teamData['playerIds'] ?? []);
//       String teamName = teamData['name'] ?? '';
//
//       debugPrint('👥 Team "$teamName" has ${playerIds.length} player IDs');
//
//       if (playerIds.isEmpty) {
//         debugPrint('⚠️ No players in team');
//         return [];
//       }
//
//       List<PlayerModel> players = [];
//
//       // Firebase 'whereIn' limit is 10, so batch the queries
//       for (int i = 0; i < playerIds.length; i += 10) {
//         int end = (i + 10 < playerIds.length) ? i + 10 : playerIds.length;
//         List<String> batch = playerIds.sublist(i, end);
//
//         QuerySnapshot querySnapshot = await _firestore
//             .collection('players')
//             .where('playerId', whereIn: batch)
//             .get();
//
//         for (var doc in querySnapshot.docs) {
//           try {
//             PlayerModel player = PlayerModel.fromFirestore(doc);
//             players.add(player);
//             debugPrint('✓ Loaded: ${player.name}');
//           } catch (e) {
//             debugPrint('✗ Error parsing player ${doc.id}: $e');
//           }
//         }
//       }
//
//       debugPrint('✅ Total loaded players: ${players.length}');
//       return players;
//     } catch (e) {
//       debugPrint('❌ Error in loadPlayersByTeam: $e');
//       return [];
//     }
//   }
//
//   // ✅ Fetch all matches
//   Future<void> fetchMatches() async {
//     debugPrint('═══════════════════════════════════');
//     debugPrint('🔄 Fetching matches...');
//     debugPrint('═══════════════════════════════════');
//
//     _isLoading = true;
//     _error = null;
//     notifyListeners();
//
//     try {
//       final snapshot = await _firestore
//           .collection('matches')
//           .orderBy('date', descending: true)
//           .get();
//
//       debugPrint('📦 Found ${snapshot.docs.length} matches');
//
//       _matches = snapshot.docs
//           .map((doc) => MatchModel.fromFirestore(doc))
//           .toList();
//
//       debugPrint('✅ Matches loaded successfully');
//       _isLoading = false;
//       notifyListeners();
//     } catch (e, stackTrace) {
//       debugPrint('❌ Error fetching matches: $e');
//       debugPrint('Stack: $stackTrace');
//       _error = e.toString();
//       _isLoading = false;
//       notifyListeners();
//     }
//   }
//
//   // ✅ Load matches by admin
//   Future<void> loadMatchesByAdmin(String adminFullName) async {
//     try {
//       _isLoading = true;
//       notifyListeners();
//
//       debugPrint('🔍 Loading matches for admin: $adminFullName');
//
//       QuerySnapshot snapshot = await _firestore
//           .collection('matches')
//           .where('adminFullName', isEqualTo: adminFullName)
//           .orderBy('date', descending: true)
//           .get();
//
//       _matches = snapshot.docs
//           .map((doc) => MatchModel.fromFirestore(doc))
//           .toList();
//
//       debugPrint('✅ Loaded ${_matches.length} matches for $adminFullName');
//
//       _isLoading = false;
//       notifyListeners();
//     } catch (e) {
//       debugPrint('❌ Error loading matches: $e');
//       _isLoading = false;
//       notifyListeners();
//     }
//   }
//
//   // ✅ Create new match
//   // ✅ এই ফাংশনটা পুরোটা রিপ্লেস করো
//   Future<String?> createMatch(MatchModel match, String adminFullName) async {
//     try {
//       final data = match.toFirestore();
//       data['adminFullName'] = adminFullName;
//       data['createdAt'] = FieldValue.serverTimestamp();
//
//       await _firestore.collection('matches').add(data);
//
//       await loadMatchesByAdmin(adminFullName); // এটাই ম্যাজিক
//       return null;
//     } catch (e) {
//       return e.toString();
//     }
//   }
//
//   // ✅ Update lineup
//   Future<String?> updateLineUp(
//       String matchId,
//       LineUp? lineUpA,
//       LineUp? lineUpB,
//       ) async {
//     try {
//       debugPrint('📝 Updating lineup for match: $matchId');
//
//       Map<String, dynamic> updates = {};
//
//       if (lineUpA != null) {
//         updates['lineUpA'] = lineUpA.toMap();
//       }
//
//       if (lineUpB != null) {
//         updates['lineUpB'] = lineUpB.toMap();
//       }
//
//       await _firestore.collection('matches').doc(matchId).update(updates);
//
//       debugPrint('✅ Lineup updated successfully');
//       await fetchMatches();
//       return null;
//     } catch (e) {
//       debugPrint('❌ Error updating lineup: $e');
//       return e.toString();
//     }
//   }
//
//   // ✅ Add timeline event
//   Future<String?> addTimelineEvent(String matchId, MatchEvent event) async {
//     try {
//       debugPrint('📝 Adding timeline event: ${event.type}');
//
//       await _firestore.collection('matches').doc(matchId).update({
//         'timeline': FieldValue.arrayUnion([event.toMap()])
//       });
//
//       debugPrint('✅ Timeline event added');
//       await fetchMatches();
//       return null;
//     } catch (e) {
//       debugPrint('❌ Error adding timeline event: $e');
//       return e.toString();
//     }
//   }
//
//   // ✅ Update match score
//   Future<String?> updateMatchScore(
//       String matchId,
//       int scoreA,
//       int scoreB,
//       ) async {
//     try {
//       debugPrint('📝 Updating score: $scoreA - $scoreB');
//
//       await _firestore.collection('matches').doc(matchId).update({
//         'scoreA': scoreA,
//         'scoreB': scoreB,
//       });
//
//       debugPrint('✅ Score updated');
//       await fetchMatches();
//       return null;
//     } catch (e) {
//       debugPrint('❌ Error updating score: $e');
//       return e.toString();
//     }
//   }
//
//   // ✅ Update match status
//   Future<String?> updateMatchStatus(String matchId, String status) async {
//     try {
//       debugPrint('📝 Updating status to: $status');
//
//       await _firestore.collection('matches').doc(matchId).update({
//         'status': status,
//       });
//
//       debugPrint('✅ Status updated');
//       await fetchMatches();
//       return null;
//     } catch (e) {
//       debugPrint('❌ Error updating status: $e');
//       return e.toString();
//     }
//   }
//
//   // ✅ Update statistics (ADDED - This was missing!)
//   Future<String?> updateStats(String matchId, MatchStats stats) async {
//     try {
//       debugPrint('📝 Updating match statistics');
//
//       await _firestore.collection('matches').doc(matchId).update({
//         'stats': stats.toMap(),
//       });
//
//       int index = _matches.indexWhere((m) => m.id == matchId);
//       if (index != -1) {
//         _matches[index] = _matches[index].copyWith(stats: stats);
//         notifyListeners();
//       }
//
//       debugPrint('✅ Statistics updated');
//       return null;
//     } catch (e) {
//       debugPrint('❌ Error updating statistics: $e');
//       return e.toString();
//     }
//   }
//
//   // ✅ Delete match
//   Future<String?> deleteMatch(String matchId) async {
//     try {
//       debugPrint('🗑️ Deleting match: $matchId');
//
//       await _firestore.collection('matches').doc(matchId).delete();
//
//       debugPrint('✅ Match deleted');
//       await fetchMatches();
//       return null;
//     } catch (e) {
//       debugPrint('❌ Error deleting match: $e');
//       return e.toString();
//     }
//   }
//
//   // ✅ Stream matches (real-time)
//   Stream<List<MatchModel>> streamMatches() {
//     return _firestore
//         .collection('matches')
//         .orderBy('date', descending: true)
//         .snapshots()
//         .map((snapshot) {
//       final matches = snapshot.docs
//           .map((doc) => MatchModel.fromFirestore(doc))
//           .toList();
//
//       _matches = matches;
//       return matches;
//     });
//   }
//
//   // ✅ Filter matches by status
//   List<MatchModel> getMatchesByStatus(String status) {
//     return _matches.where((m) => m.status == status).toList();
//   }
//
//   // ✅ Calculate stats from timeline
//   MatchStats calculateStatsFromTimeline(MatchModel match) {
//     int yellowCardsA = 0;
//     int yellowCardsB = 0;
//     int redCardsA = 0;
//     int redCardsB = 0;
//
//     for (var event in match.timeline) {
//       if (event.type == 'card') {
//         if (event.details == 'yellow') {
//           if (event.team == 'teamA') {
//             yellowCardsA++;
//           } else {
//             yellowCardsB++;
//           }
//         } else if (event.details == 'red') {
//           if (event.team == 'teamA') {
//             redCardsA++;
//           } else {
//             redCardsB++;
//           }
//         }
//       }
//     }
//
//     return (match.stats ?? MatchStats()).copyWith(
//       yellowCardsA: yellowCardsA,
//       yellowCardsB: yellowCardsB,
//       redCardsA: redCardsA,
//       redCardsB: redCardsB,
//     );
//   }
//
//   // ✅ Get team by ID
//   TeamModel? getTeamById(String teamId) {
//     try {
//       return _teams.firstWhere((t) => t.id == teamId);
//     } catch (e) {
//       debugPrint('❌ Team not found: $teamId');
//       return null;
//     }
//   }
//
//   // ✅ Clear cache
//   void clearCache() {
//     _matches.clear();
//     _teams.clear();
//     _error = null;
//     _isLoading = false;
//     notifyListeners();
//   }
//
//   // ✅ Clear error
//   void clearError() {
//     _error = null;
//     notifyListeners();
//   }
// }


import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/match_model.dart';
import 'team_provider.dart';

/// MatchProvider extends TeamProvider to include both team and match functionality
class MatchProvider extends TeamProvider {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  List<MatchModel> _matches = [];
  String? _matchError;

  List<MatchModel> get matches => _matches;
  String? get matchError => _matchError;

  // ✅ BACKWARD COMPATIBILITY: Add loadTeams() method
  Future<void> loadTeams() async {
    await fetchTeams(); // Calls parent's fetchTeams()
  }

  /// Get match by ID
  MatchModel? getMatchById(String matchId) {
    try {
      return _matches.firstWhere((m) => m.id == matchId);
    } catch (e) {
      debugPrint('❌ Match not found: $matchId');
      return null;
    }
  }

  /// Fetch all matches
  Future<void> fetchMatches() async {
    debugPrint('═══════════════════════════════════');
    debugPrint('🔄 Fetching matches...');
    debugPrint('═══════════════════════════════════');

    _matchError = null;
    notifyListeners();

    try {
      final snapshot = await _firestore
          .collection('matches')
          .orderBy('date', descending: true)
          .get();

      debugPrint('📦 Found ${snapshot.docs.length} matches');

      _matches = snapshot.docs
          .map((doc) => MatchModel.fromFirestore(doc))
          .toList();

      debugPrint('✅ Matches loaded successfully');
      notifyListeners();
    } catch (e, stackTrace) {
      debugPrint('❌ Error fetching matches: $e');
      debugPrint('Stack: $stackTrace');
      _matchError = e.toString();
      notifyListeners();
    }
  }

  /// Load matches by admin
  Future<void> loadMatchesByAdmin(String adminFullName) async {
    try {
      debugPrint('🔍 Loading matches for admin: $adminFullName');

      QuerySnapshot snapshot = await _firestore
          .collection('matches')
          .where('adminFullName', isEqualTo: adminFullName)
          .orderBy('date', descending: true)
          .get();

      _matches = snapshot.docs
          .map((doc) => MatchModel.fromFirestore(doc))
          .toList();

      debugPrint('✅ Loaded ${_matches.length} matches for $adminFullName');
      notifyListeners();
    } catch (e) {
      debugPrint('❌ Error loading matches: $e');
      notifyListeners();
    }
  }

  /// Create new match
  Future<String?> createMatch(MatchModel match, String adminFullName) async {
    try {
      final data = match.toFirestore();
      data['adminFullName'] = adminFullName;
      data['createdAt'] = FieldValue.serverTimestamp();

      await _firestore.collection('matches').add(data);

      await loadMatchesByAdmin(adminFullName);
      return null;
    } catch (e) {
      return e.toString();
    }
  }

  /// Update lineup
  Future<String?> updateLineUp(
      String matchId,
      LineUp? lineUpA,
      LineUp? lineUpB,
      ) async {
    try {
      debugPrint('📝 Updating lineup for match: $matchId');

      Map<String, dynamic> updates = {};

      if (lineUpA != null) {
        updates['lineUpA'] = lineUpA.toMap();
      }

      if (lineUpB != null) {
        updates['lineUpB'] = lineUpB.toMap();
      }

      await _firestore.collection('matches').doc(matchId).update(updates);

      debugPrint('✅ Lineup updated successfully');
      await fetchMatches();
      return null;
    } catch (e) {
      debugPrint('❌ Error updating lineup: $e');
      return e.toString();
    }
  }

  /// Add timeline event
  Future<String?> addTimelineEvent(String matchId, MatchEvent event) async {
    try {
      debugPrint('📝 Adding timeline event: ${event.type}');

      await _firestore.collection('matches').doc(matchId).update({
        'timeline': FieldValue.arrayUnion([event.toMap()])
      });

      debugPrint('✅ Timeline event added');
      await fetchMatches();
      return null;
    } catch (e) {
      debugPrint('❌ Error adding timeline event: $e');
      return e.toString();
    }
  }

  /// Update match score
  Future<String?> updateMatchScore(
      String matchId,
      int scoreA,
      int scoreB,
      ) async {
    try {
      debugPrint('📝 Updating score: $scoreA - $scoreB');

      await _firestore.collection('matches').doc(matchId).update({
        'scoreA': scoreA,
        'scoreB': scoreB,
      });

      debugPrint('✅ Score updated');
      await fetchMatches();
      return null;
    } catch (e) {
      debugPrint('❌ Error updating score: $e');
      return e.toString();
    }
  }

  /// Update match status
  Future<String?> updateMatchStatus(String matchId, String status) async {
    try {
      debugPrint('📝 Updating status to: $status');

      await _firestore.collection('matches').doc(matchId).update({
        'status': status,
      });

      debugPrint('✅ Status updated');
      await fetchMatches();
      return null;
    } catch (e) {
      debugPrint('❌ Error updating status: $e');
      return e.toString();
    }
  }

  /// Update statistics
  Future<String?> updateStats(String matchId, MatchStats stats) async {
    try {
      debugPrint('📝 Updating match statistics');

      await _firestore.collection('matches').doc(matchId).update({
        'stats': stats.toMap(),
      });

      int index = _matches.indexWhere((m) => m.id == matchId);
      if (index != -1) {
        _matches[index] = _matches[index].copyWith(stats: stats);
        notifyListeners();
      }

      debugPrint('✅ Statistics updated');
      return null;
    } catch (e) {
      debugPrint('❌ Error updating statistics: $e');
      return e.toString();
    }
  }

  /// Delete match
  Future<String?> deleteMatch(String matchId) async {
    try {
      debugPrint('🗑️ Deleting match: $matchId');

      await _firestore.collection('matches').doc(matchId).delete();

      debugPrint('✅ Match deleted');
      await fetchMatches();
      return null;
    } catch (e) {
      debugPrint('❌ Error deleting match: $e');
      return e.toString();
    }
  }

  /// Stream matches (real-time)
  Stream<List<MatchModel>> streamMatches() {
    return _firestore
        .collection('matches')
        .orderBy('date', descending: true)
        .snapshots()
        .map((snapshot) {
      final matches = snapshot.docs
          .map((doc) => MatchModel.fromFirestore(doc))
          .toList();

      _matches = matches;
      return matches;
    });
  }

  /// Filter matches by status
  List<MatchModel> getMatchesByStatus(String status) {
    return _matches.where((m) => m.status == status).toList();
  }

  /// Calculate stats from timeline
  MatchStats calculateStatsFromTimeline(MatchModel match) {
    int yellowCardsA = 0;
    int yellowCardsB = 0;
    int redCardsA = 0;
    int redCardsB = 0;

    for (var event in match.timeline) {
      if (event.type == 'card') {
        if (event.details == 'yellow') {
          if (event.team == 'teamA') {
            yellowCardsA++;
          } else {
            yellowCardsB++;
          }
        } else if (event.details == 'red') {
          if (event.team == 'teamA') {
            redCardsA++;
          } else {
            redCardsB++;
          }
        }
      }
    }

    return (match.stats ?? MatchStats()).copyWith(
      yellowCardsA: yellowCardsA,
      yellowCardsB: yellowCardsB,
      redCardsA: redCardsA,
      redCardsB: redCardsB,
    );
  }

  // ✅ BACKWARD COMPATIBILITY: Add loadPlayersByTeam() if not in TeamProvider
  Future<List<dynamic>> loadPlayersByTeam(String teamId) async {
    // Check if parent has this method, otherwise implement
    try {
      return await fetchTeamPlayers(teamId).then((_) => getCachedTeamPlayers(teamId));
    } catch (e) {
      debugPrint('❌ Error loading players by team: $e');
      return [];
    }
  }

  /// Clear all cache (matches + teams)
  @override
  void clearCache() {
    _matches.clear();
    _matchError = null;
    super.clearCache();
  }

  /// Clear only match error
  void clearMatchError() {
    _matchError = null;
    notifyListeners();
  }

  // ✅ BACKWARD COMPATIBILITY: Add clearError() alias
  void clearError() {
    _matchError = null;
    super.clearError(); // Also clear parent's error
  }
}