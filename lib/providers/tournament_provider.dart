
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/tournament_model.dart';


class TournamentProvider with ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  List<TournamentModel> _tournaments = [];
  List<TournamentGroup> _groups = [];
  List<TournamentMatch> _tournamentMatches = [];
  List<TournamentTeamStats> _teamStats = [];
  List<TournamentPlayerStats> _playerStats = [];
  bool _isLoading = false;

  List<TournamentModel> get tournaments => _tournaments;
  List<TournamentGroup> get groups => _groups;
  List<TournamentMatch> get tournamentMatches => _tournamentMatches;
  List<TournamentTeamStats> get teamStats => _teamStats;
  List<TournamentPlayerStats> get playerStats => _playerStats;
  bool get isLoading => _isLoading;

  // ============================================================================
  // LOAD TOURNAMENTS BY ADMIN
  // ============================================================================
  Future<void> loadTournamentsByAdmin(String adminFullName) async {
    _isLoading = true;
    notifyListeners();

    try {
      print('🔍 Loading tournaments for admin: $adminFullName');

      QuerySnapshot snapshot = await _firestore
          .collection('tournaments')
          .where('createdBy', isEqualTo: adminFullName)
          .orderBy('startDate', descending: true)
          .get();

      _tournaments = snapshot.docs
          .map((doc) => TournamentModel.fromFirestore(doc))
          .toList();

      print('✅ Loaded ${_tournaments.length} tournaments');
    } catch (e) {
      print('❌ Error loading tournaments: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // ============================================================================
  // CREATE TOURNAMENT
  // ============================================================================
  Future<String?> createTournament(
      TournamentModel tournament, String adminFullName) async {
    try {
      Map<String, dynamic> tournamentData = tournament.toFirestore();
      tournamentData['createdBy'] = adminFullName;
      tournamentData['createdAt'] = FieldValue.serverTimestamp();

      DocumentReference docRef =
      await _firestore.collection('tournaments').add(tournamentData);

      print('✅ Tournament created: ${docRef.id}');

      // Create groups if format is 'groups'
      if (tournament.format == 'groups') {
        await _createTournamentGroups(docRef.id, tournament);
      }

      // Initialize team stats
      await _initializeTeamStats(docRef.id, tournament.teamIds);

      await loadTournamentsByAdmin(adminFullName);
      return null;
    } catch (e) {
      print('❌ Error creating tournament: $e');
      return 'টুর্নামেন্ট তৈরি করতে সমস্যা: $e';
    }
  }
  // ============================================================================
// INITIALIZE TEAM STATS WITH GROUP ASSIGNMENT
// ============================================================================
  Future<void> initializeTeamStats(
      String tournamentId,
      List<String> teamIds,
      Map<String, String?> teamToGroupMap,
      ) async {
    try {
      // Get team details
      for (String teamId in teamIds) {
        DocumentSnapshot teamDoc =
        await _firestore.collection('teams').doc(teamId).get();

        if (teamDoc.exists) {
          Map<String, dynamic> teamData =
          teamDoc.data() as Map<String, dynamic>;

          TournamentTeamStats stats = TournamentTeamStats(
            tournamentId: tournamentId,
            teamId: teamId,
            teamName: teamData['name'] ?? '',
            teamLogo: teamData['logoUrl'],
            groupName: teamToGroupMap[teamId],
          );

          await _firestore
              .collection('tournament_team_stats')
              .add(stats.toFirestore());

          print('✅ Initialized stats for team: ${stats.teamName} in ${stats.groupName}');
        }
      }
    } catch (e) {
      print('❌ Error initializing team stats: $e');
    }
  }
  // ============================================================================
  // CREATE TOURNAMENT GROUPS
  // ============================================================================
  Future<void> _createTournamentGroups(
      String tournamentId, TournamentModel tournament) async {
    try {
      List<String> teamIds = List.from(tournament.teamIds);
      teamIds.shuffle(); // Randomize teams

      int teamsPerGroup = tournament.teamsPerGroup;
      int numberOfGroups = tournament.numberOfGroups;

      for (int i = 0; i < numberOfGroups; i++) {
        String groupName = 'Group ${String.fromCharCode(65 + i)}'; // A, B, C...

        int startIndex = i * teamsPerGroup;
        int endIndex = (startIndex + teamsPerGroup).clamp(0, teamIds.length);

        List<String> groupTeamIds =
        teamIds.sublist(startIndex, endIndex.clamp(0, teamIds.length));

        if (groupTeamIds.isEmpty) continue;

        TournamentGroup group = TournamentGroup(
          tournamentId: tournamentId,
          groupName: groupName,
          teamIds: groupTeamIds,
          groupOrder: i,
        );

        await _firestore
            .collection('tournament_groups')
            .add(group.toFirestore());

        print('✅ Created $groupName with ${groupTeamIds.length} teams');
      }
    } catch (e) {
      print('❌ Error creating groups: $e');
    }
  }

  // ============================================================================
  // INITIALIZE TEAM STATS
  // ============================================================================
  Future<void> _initializeTeamStats(
      String tournamentId, List<String> teamIds) async {
    try {
      // Load groups to assign groupName
      QuerySnapshot groupsSnapshot = await _firestore
          .collection('tournament_groups')
          .where('tournamentId', isEqualTo: tournamentId)
          .get();

      Map<String, String> teamToGroup = {};
      for (var groupDoc in groupsSnapshot.docs) {
        TournamentGroup group = TournamentGroup.fromFirestore(groupDoc);
        for (String teamId in group.teamIds) {
          teamToGroup[teamId] = group.groupName;
        }
      }

      // Get team details
      for (String teamId in teamIds) {
        DocumentSnapshot teamDoc =
        await _firestore.collection('teams').doc(teamId).get();

        if (teamDoc.exists) {
          Map<String, dynamic> teamData =
          teamDoc.data() as Map<String, dynamic>;

          TournamentTeamStats stats = TournamentTeamStats(
            tournamentId: tournamentId,
            teamId: teamId,
            teamName: teamData['name'] ?? '',
            teamLogo: teamData['logoUrl'],
            groupName: teamToGroup[teamId],
          );

          await _firestore
              .collection('tournament_team_stats')
              .add(stats.toFirestore());

          print('✅ Initialized stats for team: ${stats.teamName}');
        }
      }
    } catch (e) {
      print('❌ Error initializing team stats: $e');
    }
  }

  // ============================================================================
  // LOAD TOURNAMENT GROUPS
  // ============================================================================
  Future<void> loadTournamentGroups(String tournamentId) async {
    try {
      QuerySnapshot snapshot = await _firestore
          .collection('tournament_groups')
          .where('tournamentId', isEqualTo: tournamentId)
          .orderBy('groupOrder')
          .get();

      _groups = snapshot.docs
          .map((doc) => TournamentGroup.fromFirestore(doc))
          .toList();

      print('✅ Loaded ${_groups.length} groups');
      notifyListeners();
    } catch (e) {
      print('❌ Error loading groups: $e');
    }
  }

  // ============================================================================
  // LOAD TOURNAMENT MATCHES
  // ============================================================================
  Future<void> loadTournamentMatches(String tournamentId) async {
    try {
      QuerySnapshot snapshot = await _firestore
          .collection('tournament_matches')
          .where('tournamentId', isEqualTo: tournamentId)
          .orderBy('matchDate')
          .get();

      _tournamentMatches = snapshot.docs
          .map((doc) => TournamentMatch.fromFirestore(doc))
          .toList();

      print('✅ Loaded ${_tournamentMatches.length} tournament matches');
      notifyListeners();
    } catch (e) {
      print('❌ Error loading tournament matches: $e');
    }
  }

  // ============================================================================
  // CREATE TOURNAMENT MATCH
  // ============================================================================
  Future<String?> createTournamentMatch(
      TournamentMatch match, String adminFullName) async {
    try {
      await _firestore
          .collection('tournament_matches')
          .add(match.toFirestore());

      print('✅ Tournament match created');
      await loadTournamentMatches(match.tournamentId);
      return null;
    } catch (e) {
      print('❌ Error creating tournament match: $e');
      return 'ম্যাচ তৈরি করতে সমস্যা: $e';
    }
  }

  // ============================================================================
  // UPDATE MATCH RESULT
  // ============================================================================
  Future<String?> updateMatchResult(
      String matchId, int scoreA, int scoreB) async {
    try {
      // Update match
      await _firestore.collection('tournament_matches').doc(matchId).update({
        'scoreA': scoreA,
        'scoreB': scoreB,
        'status': 'completed',
      });

      // Get match details
      DocumentSnapshot matchDoc =
      await _firestore.collection('tournament_matches').doc(matchId).get();
      TournamentMatch match = TournamentMatch.fromFirestore(matchDoc);

      // Update team stats
      await _updateTeamStatsAfterMatch(match, scoreA, scoreB);

      print('✅ Match result updated');
      await loadTournamentMatches(match.tournamentId);
      await loadTeamStats(match.tournamentId);
      return null;
    } catch (e) {
      print('❌ Error updating match result: $e');
      return 'রেজাল্ট আপডেট করতে সমস্যা: $e';
    }
  }

  // ============================================================================
  // UPDATE TEAM STATS AFTER MATCH
  // ============================================================================
  Future<void> _updateTeamStatsAfterMatch(
      TournamentMatch match, int scoreA, int scoreB) async {
    try {
      // Get team A stats
      QuerySnapshot teamASnapshot = await _firestore
          .collection('tournament_team_stats')
          .where('tournamentId', isEqualTo: match.tournamentId)
          .where('teamId', isEqualTo: match.teamAId)
          .limit(1)
          .get();

      // Get team B stats
      QuerySnapshot teamBSnapshot = await _firestore
          .collection('tournament_team_stats')
          .where('tournamentId', isEqualTo: match.tournamentId)
          .where('teamId', isEqualTo: match.teamBId)
          .limit(1)
          .get();

      if (teamASnapshot.docs.isEmpty || teamBSnapshot.docs.isEmpty) {
        print('⚠️ Team stats not found');
        return;
      }

      DocumentSnapshot teamADoc = teamASnapshot.docs.first;
      DocumentSnapshot teamBDoc = teamBSnapshot.docs.first;

      TournamentTeamStats teamAStats =
      TournamentTeamStats.fromFirestore(teamADoc);
      TournamentTeamStats teamBStats =
      TournamentTeamStats.fromFirestore(teamBDoc);

      // Calculate new stats for Team A
      int teamAWins = teamAStats.wins;
      int teamADraws = teamAStats.draws;
      int teamALosses = teamAStats.losses;
      int teamAPoints = teamAStats.points;

      if (scoreA > scoreB) {
        teamAWins++;
        teamAPoints += 3;
      } else if (scoreA == scoreB) {
        teamADraws++;
        teamAPoints += 1;
      } else {
        teamALosses++;
      }

      // Calculate new stats for Team B
      int teamBWins = teamBStats.wins;
      int teamBDraws = teamBStats.draws;
      int teamBLosses = teamBStats.losses;
      int teamBPoints = teamBStats.points;

      if (scoreB > scoreA) {
        teamBWins++;
        teamBPoints += 3;
      } else if (scoreB == scoreA) {
        teamBDraws++;
        teamBPoints += 1;
      } else {
        teamBLosses++;
      }

      // Update Team A stats
      await _firestore
          .collection('tournament_team_stats')
          .doc(teamADoc.id)
          .update({
        'matchesPlayed': teamAStats.matchesPlayed + 1,
        'wins': teamAWins,
        'draws': teamADraws,
        'losses': teamALosses,
        'goalsFor': teamAStats.goalsFor + scoreA,
        'goalsAgainst': teamAStats.goalsAgainst + scoreB,
        'points': teamAPoints,
      });

      // Update Team B stats
      await _firestore
          .collection('tournament_team_stats')
          .doc(teamBDoc.id)
          .update({
        'matchesPlayed': teamBStats.matchesPlayed + 1,
        'wins': teamBWins,
        'draws': teamBDraws,
        'losses': teamBLosses,
        'goalsFor': teamBStats.goalsFor + scoreB,
        'goalsAgainst': teamBStats.goalsAgainst + scoreA,
        'points': teamBPoints,
      });

      print('✅ Team stats updated');
    } catch (e) {
      print('❌ Error updating team stats: $e');
    }
  }

  // ============================================================================
  // LOAD TEAM STATS (POINTS TABLE)
  // ============================================================================
  Future<void> loadTeamStats(String tournamentId) async {
    try {
      QuerySnapshot snapshot = await _firestore
          .collection('tournament_team_stats')
          .where('tournamentId', isEqualTo: tournamentId)
          .get();

      _teamStats = snapshot.docs
          .map((doc) => TournamentTeamStats.fromFirestore(doc))
          .toList();

      // Sort by points, then goal difference
      _teamStats.sort((a, b) {
        if (a.points != b.points) {
          return b.points.compareTo(a.points);
        }
        return b.goalDifference.compareTo(a.goalDifference);
      });

      print('✅ Loaded ${_teamStats.length} team stats');
      notifyListeners();
    } catch (e) {
      print('❌ Error loading team stats: $e');
    }
  }

  // ============================================================================
  // LOAD PLAYER STATS
  // ============================================================================
  Future<void> loadPlayerStats(String tournamentId) async {
    try {
      QuerySnapshot snapshot = await _firestore
          .collection('tournament_player_stats')
          .where('tournamentId', isEqualTo: tournamentId)
          .get();

      _playerStats = snapshot.docs
          .map((doc) => TournamentPlayerStats.fromFirestore(doc))
          .toList();

      // Sort by goals
      _playerStats.sort((a, b) => b.goals.compareTo(a.goals));

      print('✅ Loaded ${_playerStats.length} player stats');
      notifyListeners();
    } catch (e) {
      print('❌ Error loading player stats: $e');
    }
  }

  // ============================================================================
  // UPDATE TOURNAMENT STATUS
  // ============================================================================
  Future<String?> updateTournamentStatus(
      String tournamentId, String newStatus) async {
    try {
      await _firestore
          .collection('tournaments')
          .doc(tournamentId)
          .update({'status': newStatus});

      // Update local list
      int index =
      _tournaments.indexWhere((t) => t.tournamentId == tournamentId);
      if (index != -1) {
        _tournaments[index] =
            _tournaments[index].copyWith(status: newStatus);
        notifyListeners();
      }

      return null;
    } catch (e) {
      print('❌ Error updating tournament status: $e');
      return 'স্ট্যাটাস আপডেট করতে সমস্যা: $e';
    }
  }

  // ============================================================================
  // DELETE TOURNAMENT
  // ============================================================================
  Future<String?> deleteTournament(String tournamentId) async {
    try {
      // Delete tournament
      await _firestore.collection('tournaments').doc(tournamentId).delete();

      // Delete groups
      QuerySnapshot groupsSnapshot = await _firestore
          .collection('tournament_groups')
          .where('tournamentId', isEqualTo: tournamentId)
          .get();

      for (var doc in groupsSnapshot.docs) {
        await doc.reference.delete();
      }

      // Delete matches
      QuerySnapshot matchesSnapshot = await _firestore
          .collection('tournament_matches')
          .where('tournamentId', isEqualTo: tournamentId)
          .get();

      for (var doc in matchesSnapshot.docs) {
        await doc.reference.delete();
      }

      // Delete team stats
      QuerySnapshot statsSnapshot = await _firestore
          .collection('tournament_team_stats')
          .where('tournamentId', isEqualTo: tournamentId)
          .get();

      for (var doc in statsSnapshot.docs) {
        await doc.reference.delete();
      }

      // Delete player stats
      QuerySnapshot playerStatsSnapshot = await _firestore
          .collection('tournament_player_stats')
          .where('tournamentId', isEqualTo: tournamentId)
          .get();

      for (var doc in playerStatsSnapshot.docs) {
        await doc.reference.delete();
      }

      _tournaments.removeWhere((t) => t.tournamentId == tournamentId);
      notifyListeners();

      print('✅ Tournament and all related data deleted');
      return null;
    } catch (e) {
      print('❌ Error deleting tournament: $e');
      return 'টুর্নামেন্ট মুছতে সমস্যা: $e';
    }
  }

  // ============================================================================
  // GET MATCHES BY GROUP
  // ============================================================================
  List<TournamentMatch> getMatchesByGroup(String? groupName) {
    if (groupName == null) {
      return _tournamentMatches.where((m) => m.groupName == null).toList();
    }
    return _tournamentMatches.where((m) => m.groupName == groupName).toList();
  }

  // ============================================================================
  // GET TEAM STATS BY GROUP
  // ============================================================================
  List<TournamentTeamStats> getTeamStatsByGroup(String groupName) {
    List<TournamentTeamStats> groupStats =
    _teamStats.where((s) => s.groupName == groupName).toList();

    // Sort by points, then goal difference
    groupStats.sort((a, b) {
      if (a.points != b.points) {
        return b.points.compareTo(a.points);
      }
      return b.goalDifference.compareTo(a.goalDifference);
    });

    return groupStats;
  }

  // ============================================================================
  // GET TOP SCORERS
  // ============================================================================
  List<TournamentPlayerStats> getTopScorers({int limit = 10}) {
    List<TournamentPlayerStats> topScorers = List.from(_playerStats);
    topScorers.sort((a, b) => b.goals.compareTo(a.goals));
    return topScorers.take(limit).toList();
  }

  // ============================================================================
  // GET TOP ASSISTS
  // ============================================================================
  List<TournamentPlayerStats> getTopAssists({int limit = 10}) {
    List<TournamentPlayerStats> topAssists = List.from(_playerStats);
    topAssists.sort((a, b) => b.assists.compareTo(a.assists));
    return topAssists.take(limit).toList();
  }
}