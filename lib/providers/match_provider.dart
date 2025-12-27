
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/match_model.dart';
import 'team_provider.dart';

class MatchProvider extends TeamProvider {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  List<MatchModel> _matches = [];
  bool _isLoading = false;
  String? _matchError;

  List<MatchModel> get matches => _matches;
  bool get isLoading => _isLoading;
  String? get matchError => _matchError;

  // ১. অ্যাডমিনের নাম অনুযায়ী ম্যাচ লোড করা (image_95f0fe.jpg এর সমাধান)
  Future<void> loadMatchesByAdmin(String adminFullName) async {
    _isLoading = true;
    notifyListeners();
    try {
      QuerySnapshot snapshot = await _firestore
          .collection('matches')
          .where('adminFullName', isEqualTo: adminFullName)
          .orderBy('date', descending: true)
          .get();

      _matches = snapshot.docs.map((doc) => MatchModel.fromFirestore(doc)).toList();
    } catch (e) {
      debugPrint('❌ Error loading matches: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> loadTeams() async {
    // আপনার TeamProvider থেকে সব টিম লোড করার লজিক এখানে থাকবে
    // যদি MatchProvider, TeamProvider-কে এক্সটেন্ড করে তবে fetchTeams() কল করুন
    await fetchTeams();
  }

  // ৩. নতুন ম্যাচ তৈরি করা (Create Match)
  Future<String?> createMatch(MatchModel match, String adminName) async {
    try {
      await _firestore.collection('matches').add(match.toFirestore());
      await loadMatchesByAdmin(adminName); // লিস্ট আপডেট করা
      return null;
    } catch (e) {
      return e.toString();
    }
  }

  // ৪. টাইমলাইন থেকে স্ট্যাটাস ক্যালকুলেট করা (image_958aca.jpg এর সমাধান)
  MatchStats calculateStatsFromTimeline(MatchModel match) {
    int yA = 0, yB = 0, rA = 0, rB = 0;

    for (var event in match.timeline) {
      if (event.type == 'card') {
        String detail = event.details?.toLowerCase() ?? '';
        if (detail.contains('yellow')) {
          if (event.team == 'teamA') yA++; else yB++;
        } else if (detail.contains('red')) {
          if (event.team == 'teamA') rA++; else rB++;
        }
      }
    }

    // MatchStats এর copyWith ব্যবহার করে ডাটা রিটার্ন (yellowCardsA এখন মডেলে আছে)
    return (match.stats ?? MatchStats()).copyWith(
      yellowCardsA: yA,
      yellowCardsB: yB,
      redCardsA: rA,
      redCardsB: rB,
    );
  }

  // ৫. ম্যাচের স্কোর আপডেট করা
  Future<String?> updateMatchScore(String matchId, int scoreA, int scoreB) async {
    try {
      await _firestore.collection('matches').doc(matchId).update({
        'scoreA': scoreA,
        'scoreB': scoreB,
      });
      return null;
    } catch (e) {
      return e.toString();
    }
  }
  // MatchProvider ক্লাসের ভেতরে এই মেথডগুলো যোগ করুন
  // ৫. স্ট্যাটাস আপডেট করা
  Future<String?> updateMatchStatus(String matchId, String newStatus) async {
    try {
      await _firestore.collection('matches').doc(matchId).update({'status': newStatus});
      int index = _matches.indexWhere((m) => m.id == matchId);
      if (index != -1) {
        _matches[index] = _matches[index].copyWith(status: newStatus);
        notifyListeners();
      }
      return null;
    } catch (e) {
      return e.toString();
    }
  }

  Future<String?> deleteMatch(String matchId) async {
    try {
      await _firestore.collection('matches').doc(matchId).delete();
      _matches.removeWhere((m) => m.id == matchId);
      notifyListeners();
      return null;
    } catch (e) {
      return e.toString();
    }
  }

  MatchModel? getMatchById(String id) {
    try {
      return _matches.firstWhere((m) => m.id == id);
    } catch (_) {
      return null;
    }
  }

  // ৬. ম্যাচের স্ট্যাটাস আপডেট করা (stats সহ)
  // MatchProvider ক্লাসের ভেতরে এটি যোগ করুন
  Future<String?> updateStats(String matchId, MatchStats stats) async {
    try {
      await _firestore.collection('matches').doc(matchId).update({
        'stats': stats.toMap(),
      });

      int index = _matches.indexWhere((m) => m.id == matchId);
      if (index != -1) {
        _matches[index] = _matches[index].copyWith(stats: stats);
        notifyListeners();
      }
      return null;
    } catch (e) {
      return e.toString();
    }
  }
  Future<String?> addTimelineEvent(String matchId, MatchEvent event) async {
    try {
      await _firestore.collection('matches').doc(matchId).update({
        'timeline': FieldValue.arrayUnion([event.toMap()])
      });

      // লোকাল লিস্ট আপডেট করা
      int index = _matches.indexWhere((m) => m.id == matchId);
      if (index != -1) {
        List<MatchEvent> updatedTimeline = List.from(_matches[index].timeline)..add(event);
        _matches[index] = _matches[index].copyWith(timeline: updatedTimeline);

        // কার্ডের ক্ষেত্রে স্ট্যাটাস ক্যালকুলেট করে আপডেট করা
        if (event.type == 'card') {
          MatchStats newStats = calculateStatsFromTimeline(_matches[index]);
          await updateStats(matchId, newStats);
        }
        notifyListeners();
      }
      return null;
    } catch (e) {
      return e.toString();
    }
  }
  // MatchProvider ক্লাসের ভেতরে এটি যোগ করুন
// MatchProvider ক্লাসের ভেতরে এই মেথডটি যোগ করুন
//   Future<String?> updateLineUp(String matchId, LineUp? lineUpA, LineUp? lineUpB) async {
//     try {
//       Map<String, dynamic> updateData = {};
//       if (lineUpA != null) updateData['lineUpA'] = lineUpA.toMap();
//       if (lineUpB != null) updateData['lineUpB'] = lineUpB.toMap();
//
//       await _firestore.collection('matches').doc(matchId).update(updateData);
//
//       // লোকাল ডাটা আপডেট করুন
//       int index = _matches.indexWhere((m) => m.id == matchId);
//       if (index != -1) {
//         _matches[index] = _matches[index].copyWith(
//           lineUpA: lineUpA ?? _matches[index].lineUpA,
//           lineUpB: lineUpB ?? _matches[index].lineUpB,
//         );
//         notifyListeners();
//       }
//       return null;
//     } catch (e) {
//       return e.toString();
//     }
//   }
  Future<String?> updateLineUp(String matchId, LineUp? lineupA, LineUp? lineupB) async {
    try {
      final docRef = FirebaseFirestore.instance.collection('matches').doc(matchId);

      Map<String, dynamic> updateData = {};

      if (lineupA != null) {
        updateData['lineUpA'] = lineupA.toMap();
      }
      if (lineupB != null) {
        updateData['lineUpB'] = lineupB.toMap();
      }

      // 🔥 এখানে set() + merge: true ব্যবহার করুন
      await docRef.set(updateData, SetOptions(merge: true));

      return null; // সাকসেস
    } catch (e) {
      return e.toString();
    }
  }
  @override
  void clearCache() {
    _matches = [];
    _matchError = null;
    super.clearCache();
  }
}