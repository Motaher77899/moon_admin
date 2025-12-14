import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/team_model.dart';
import '../models/player_model.dart';

class TeamProvider extends ChangeNotifier {
  List<TeamModel> _teams = [];
  bool _isLoading = false;
  String? _error;

  // Store team players in memory for quick access
  Map<String, List<PlayerModel>> teamPlayers = {};

  List<TeamModel> get teams => _teams;
  bool get isLoading => _isLoading;
  String? get error => _error;

  // ✅ Team ID দিয়ে team খুঁজে বের করুন
  TeamModel? getTeamById(String teamId) {
    if (teamId.isEmpty) {
      debugPrint('⚠️ Empty team ID provided');
      return null;
    }

    try {
      final team = _teams.firstWhere(
            (team) => team.id == teamId,
        orElse: () => throw Exception('Team not found'),
      );
      return team;
    } catch (e) {
      debugPrint('❌ Team not found with ID: $teamId');
      debugPrint('   Available IDs: ${_teams.map((t) => t.id).join(", ")}');
      return null;
    }
  }

  // ✅ Team Name দিয়ে team খুঁজে বের করুন
  TeamModel? getTeamByName(String teamName) {
    if (teamName.isEmpty) return null;

    try {
      return _teams.firstWhere(
            (team) => team.name.toLowerCase() == teamName.toLowerCase(),
        orElse: () => throw Exception('Team not found'),
      );
    } catch (e) {
      debugPrint('❌ Team not found with name: $teamName');
      return null;
    }
  }

  // ✅ Multiple team IDs দিয়ে teams খুঁজুন
  List<TeamModel> getTeamsByIds(List<String> teamIds) {
    return _teams.where((team) => teamIds.contains(team.id)).toList();
  }

  // ✅ Fetch all teams from Firebase
  Future<void> fetchTeams() async {
    debugPrint('═══════════════════════════════════');
    debugPrint('🔄 Starting to fetch teams...');
    debugPrint('═══════════════════════════════════');

    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      debugPrint('📡 Querying Firestore collection: teams');

      final snapshot = await FirebaseFirestore.instance
          .collection('teams')
          .get();

      debugPrint('📦 Received ${snapshot.docs.length} documents from Firebase');

      if (snapshot.docs.isEmpty) {
        debugPrint('⚠️  WARNING: No teams found in Firebase!');
        _teams = [];
      } else {
        debugPrint('✨ Processing documents...');
        _teams = [];

        for (var doc in snapshot.docs) {
          try {
            final data = doc.data();
            debugPrint('   📄 Document: ${doc.id}');

            TeamModel team;
            try {
              team = TeamModel.fromFirestore(doc);
              debugPrint('      ✅ Parsed with fromFirestore');
            } catch (e1) {
              team = TeamModel.fromMap(data, doc.id);
              debugPrint('      ✅ Parsed with fromMap');
            }

            _teams.add(team);
            debugPrint('      ✅ SUCCESS: ${team.id} - "${team.name}"');
          } catch (e) {
            debugPrint('      ❌ ERROR parsing ${doc.id}: $e');
          }
        }

        debugPrint('');
        debugPrint('═══════════════════════════════════');
        debugPrint('🎉 Team loading complete!');
        debugPrint('   Total teams loaded: ${_teams.length}');
        debugPrint('═══════════════════════════════════');
      }

      _isLoading = false;
      notifyListeners();
    } catch (e, stackTrace) {
      _error = e.toString();
      _isLoading = false;
      debugPrint('❌ ERROR fetching teams: $e');
      notifyListeners();
    }
  }

  // ✅ NEW: Fetch team players for lineup selection
  Future<void> fetchTeamPlayers(String teamId) async {
    try {
      final teamDoc = await FirebaseFirestore.instance
          .collection('teams')
          .doc(teamId)
          .get();

      final playerIds = List<String>.from(teamDoc.data()?['playerIds'] ?? []);

      List<PlayerModel> players = [];
      for (String playerId in playerIds) {
        final playerDoc = await FirebaseFirestore.instance
            .collection('players')
            .doc(playerId)
            .get();

        if (playerDoc.exists) {
          players.add(PlayerModel.fromFirestore(playerDoc));
        }
      }

      teamPlayers[teamId] = players;
      notifyListeners();
    } catch (e) {
      debugPrint('Error fetching team players: $e');
    }
  }

  // ✅ Get cached team players (returns immediately)
  List<PlayerModel> getCachedTeamPlayers(String teamId) {
    return teamPlayers[teamId] ?? [];
  }

  // Stream teams (real-time updates)
  Stream<List<TeamModel>> streamTeams() {
    return FirebaseFirestore.instance
        .collection('teams')
        .snapshots()
        .map((snapshot) {
      final teams = snapshot.docs.map((doc) {
        try {
          return TeamModel.fromFirestore(doc);
        } catch (e) {
          try {
            return TeamModel.fromMap(doc.data(), doc.id);
          } catch (e2) {
            debugPrint('❌ Error parsing team ${doc.id}: $e2');
            return null;
          }
        }
      }).whereType<TeamModel>().toList();

      _teams = teams;
      return teams;
    });
  }

  // Add new team
  Future<void> addTeam(TeamModel team) async {
    try {
      debugPrint('➕ Adding new team: ${team.name}');

      final docRef = await FirebaseFirestore.instance
          .collection('teams')
          .add(team.toFirestore());

      debugPrint('✅ Team added with ID: ${docRef.id}');
      await fetchTeams();
    } catch (e) {
      debugPrint('❌ Error adding team: $e');
      rethrow;
    }
  }

  // Update team
  Future<void> updateTeam(String teamId, TeamModel team) async {
    try {
      debugPrint('📝 Updating team: $teamId');

      await FirebaseFirestore.instance
          .collection('teams')
          .doc(teamId)
          .update(team.toFirestore());

      debugPrint('✅ Team updated');
      await fetchTeams();
    } catch (e) {
      debugPrint('❌ Error updating team: $e');
      rethrow;
    }
  }

  // Delete team
  Future<void> deleteTeam(String teamId) async {
    try {
      debugPrint('🗑️ Deleting team: $teamId');

      await FirebaseFirestore.instance
          .collection('teams')
          .doc(teamId)
          .delete();

      debugPrint('✅ Team deleted');

      // Remove from cache
      teamPlayers.remove(teamId);

      await fetchTeams();
    } catch (e) {
      debugPrint('❌ Error deleting team: $e');
      rethrow;
    }
  }

  // Search teams by name
  List<TeamModel> searchTeams(String query) {
    if (query.isEmpty) return _teams;

    final lowerQuery = query.toLowerCase();
    return _teams.where((team) {
      return team.name.toLowerCase().contains(lowerQuery);
    }).toList();
  }

  // Clear cache
  void clearCache() {
    _teams.clear();
    teamPlayers.clear();
    _error = null;
    _isLoading = false;
    notifyListeners();
  }

  // Clear error
  void clearError() {
    _error = null;
    notifyListeners();
  }

  // Clear team players cache for specific team
  void clearTeamPlayersCache(String teamId) {
    teamPlayers.remove(teamId);
    notifyListeners();
  }
}