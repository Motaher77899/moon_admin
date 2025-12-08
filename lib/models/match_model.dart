//
// import 'package:cloud_firestore/cloud_firestore.dart';
//
// class MatchModel {
//   final String? matchId;
//   final String teamAId;
//   final String teamBId;
//   final String teamAName;
//   final String teamBName;
//   final String? teamALogo;
//   final String? teamBLogo;
//   final DateTime matchDate;
//   final String venue;
//   final String status;           // upcoming, live, finished
//   final int teamAScore;
//   final int teamBScore;
//   final String? tournamentId;
//   final String? tournamentName;
//   final String matchType;
//   final String createdBy;
//   final DateTime createdAt;
//   final List<MatchEvent> timeline;
//   final MatchStats? stats;
//   final LineUp? lineUpA;
//   final LineUp? lineUpB;
//   final String? h2h;
//
//   MatchModel({
//     this.matchId,
//     required this.teamAId,
//     required this.teamBId,
//     required this.teamAName,
//     required this.teamBName,
//     this.teamALogo,
//     this.teamBLogo,
//     required this.matchDate,
//     required this.venue,
//     this.status = 'upcoming',
//     this.teamAScore = 0,
//     this.teamBScore = 0,
//     this.tournamentId,
//     this.tournamentName,
//     this.matchType = 'single',
//     required this.createdBy,
//     required this.createdAt,
//     this.timeline = const [],
//     this.stats,
//     this.lineUpA,
//     this.lineUpB,
//     this.h2h,
//   });
//
//   factory MatchModel.fromFirestore(DocumentSnapshot doc) {
//     Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
//
//     // matchDate বা date — যেকোনো একটা থাকলেই চলবে
//     DateTime? parsedDate;
//     if (data['matchDate'] != null) {
//       parsedDate = (data['matchDate'] as Timestamp?)?.toDate();
//     } else if (data['date'] != null) {
//       parsedDate = (data['date'] as Timestamp?)?.toDate();
//     }
//     parsedDate ??= DateTime.now();
//
//     return MatchModel(
//       matchId: doc.id,
//       teamAId: data['teamAId'] ?? '',
//       teamBId: data['teamBId'] ?? '',
//       teamAName: data['teamAName'] ?? '',
//       teamBName: data['teamBName'] ?? '',
//       teamALogo: data['teamALogo'],
//       teamBLogo: data['teamBLogo'],
//       matchDate: parsedDate,
//       venue: data['venue'] ?? '',
//       status: data['status'] ?? 'upcoming',
//       teamAScore: data['teamAScore'] ?? data['scoreA'] ?? 0,
//       teamBScore: data['teamBScore'] ?? data['scoreB'] ?? 0,
//       tournamentId: data['tournamentId'],
//       tournamentName: data['tournamentName'],
//       matchType: data['matchType'] ?? 'single',
//       createdBy: data['createdBy'] ?? 'Unknown',
//       createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
//       timeline: (data['timeline'] as List<dynamic>?)
//           ?.map((e) => MatchEvent.fromMap(e as Map<String, dynamic>))
//           .toList() ??
//           [],
//       stats: data['stats'] != null
//           ? MatchStats.fromMap(data['stats'] as Map<String, dynamic>)
//           : null,
//       lineUpA: data['lineUpA'] != null
//           ? LineUp.fromMap(data['lineUpA'] as Map<String, dynamic>)
//           : null,
//       lineUpB: data['lineUpB'] != null
//           ? LineUp.fromMap(data['lineUpB'] as Map<String, dynamic>)
//           : null,
//       h2h: data['h2h'],
//     );
//   }
//
//   Map<String, dynamic> toFirestore() {
//     return {
//       'teamAId': teamAId,
//       'teamBId': teamBId,
//       'teamAName': teamAName,
//       'teamBName': teamBName,
//       'teamALogo': teamALogo,
//       'teamBLogo': teamBLogo,
//
//       // User App এর জন্য জরুরি
//       'date': Timestamp.fromDate(matchDate),        // এটা ছাড়া User App ম্যাচ পাবে না
//
//       // Admin App এর জন্য (পুরানো কোড ভাঙবে না)
//       'matchDate': Timestamp.fromDate(matchDate),
//
//       'venue': venue,
//       'status': status,                             // upcoming / live / finished
//       'teamAScore': teamAScore,
//       'teamBScore': teamBScore,
//       'scoreA': teamAScore,        // compatibility
//       'scoreB': teamBScore,        // compatibility
//       'tournamentId': tournamentId,
//       'tournamentName': tournamentName,
//       'matchType': matchType,
//       'createdBy': createdBy,
//       'createdAt': Timestamp.fromDate(createdAt),
//       'timeline': timeline.map((e) => e.toMap()).toList(),
//       if (stats != null) 'stats': stats!.toMap(),
//       if (lineUpA != null) 'lineUpA': lineUpA!.toMap(),
//       if (lineUpB != null) 'lineUpB': lineUpB!.toMap(),
//       if (h2h != null) 'h2h': h2h,
//     };
//   }
//
//   MatchModel copyWith({
//     String? matchId,
//     String? teamAId,
//     String? teamBId,
//     String? teamAName,
//     String? teamBName,
//     String? teamALogo,
//     String? teamBLogo,
//     DateTime? matchDate,
//     String? venue,
//     String? status,
//     int? teamAScore,
//     int? teamBScore,
//     String? tournamentId,
//     String? tournamentName,
//     String? matchType,
//     String? createdBy,
//     DateTime? createdAt,
//     List<MatchEvent>? timeline,
//     MatchStats? stats,
//     LineUp? lineUpA,
//     LineUp? lineUpB,
//     String? h2h,
//   }) {
//     return MatchModel(
//       matchId: matchId ?? this.matchId,
//       teamAId: teamAId ?? this.teamAId,
//       teamBId: teamBId ?? this.teamBId,
//       teamAName: teamAName ?? this.teamAName,
//       teamBName: teamBName ?? this.teamBName,
//       teamALogo: teamALogo ?? this.teamALogo,
//       teamBLogo: teamBLogo ?? this.teamBLogo,
//       matchDate: matchDate ?? this.matchDate,
//       venue: venue ?? this.venue,
//       status: status ?? this.status,
//       teamAScore: teamAScore ?? this.teamAScore,
//       teamBScore: teamBScore ?? this.teamBScore,
//       tournamentId: tournamentId ?? this.tournamentId,
//       tournamentName: tournamentName ?? this.tournamentName,
//       matchType: matchType ?? this.matchType,
//       createdBy: createdBy ?? this.createdBy,
//       createdAt: createdAt ?? this.createdAt,
//       timeline: timeline ?? this.timeline,
//       stats: stats ?? this.stats,
//       lineUpA: lineUpA ?? this.lineUpA,
//       lineUpB: lineUpB ?? this.lineUpB,
//       h2h: h2h ?? this.h2h,
//     );
//   }
// }
//
// // বাকি সব ক্লাস (MatchEvent, MatchStats, LineUp, PlayerLineUp) আগের মতোই থাকবে
// // তুমি চাইলে নিচে পেস্ট করতে পারো, না হলে আগেরটা রেখে দিলেই হবে।
//
// class MatchEvent {
//   final String type;
//   final String team;
//   final String playerName;
//   final String playerId;
//   final int minute;
//   final String? details;
//   final String? assistPlayerId;
//   final String? assistPlayerName;
//
//   MatchEvent({
//     required this.type,
//     required this.team,
//     required this.playerName,
//     required this.playerId,
//     required this.minute,
//     this.details,
//     this.assistPlayerId,
//     this.assistPlayerName,
//   });
//
//   factory MatchEvent.fromMap(Map<String, dynamic> map) {
//     return MatchEvent(
//       type: map['type'] ?? '',
//       team: map['team'] ?? '',
//       playerName: map['playerName'] ?? '',
//       playerId: map['playerId'] ?? '',
//       minute: map['minute'] ?? 0,
//       details: map['details'],
//       assistPlayerId: map['assistPlayerId'],
//       assistPlayerName: map['assistPlayerName'],
//     );
//   }
//
//   Map<String, dynamic> toMap() {
//     return {
//       'type': type,
//       'team': team,
//       'playerName': playerName,
//       'playerId': playerId,
//       'minute': minute,
//       if (details != null) 'details': details,
//       if (assistPlayerId != null) 'assistPlayerId': assistPlayerId,
//       if (assistPlayerName != null) 'assistPlayerName': assistPlayerName,
//     };
//   }
// }
//
// class MatchStats {
//   final int possessionA;
//   final int possessionB;
//   final int shotsA;
//   final int shotsB;
//   final int shotsOnTargetA;
//   final int shotsOnTargetB;
//   final int cornersA;
//   final int cornersB;
//   final int foulsA;
//   final int foulsB;
//   final int yellowCardsA;
//   final int yellowCardsB;
//   final int redCardsA;
//   final int redCardsB;
//
//   MatchStats({
//     this.possessionA = 50,
//     this.possessionB = 50,
//     this.shotsA = 0,
//     this.shotsB = 0,
//     this.shotsOnTargetA = 0,
//     this.shotsOnTargetB = 0,
//     this.cornersA = 0,
//     this.cornersB = 0,
//     this.foulsA = 0,
//     this.foulsB = 0,
//     this.yellowCardsA = 0,
//     this.yellowCardsB = 0,
//     this.redCardsA = 0,
//     this.redCardsB = 0,
//   });
//
//   factory MatchStats.fromMap(Map<String, dynamic> map) {
//     return MatchStats(
//       possessionA: map['possessionA'] ?? 50,
//       possessionB: map['possessionB'] ?? 50,
//       shotsA: map['shotsA'] ?? 0,
//       shotsB: map['shotsB'] ?? 0,
//       shotsOnTargetA: map['shotsOnTargetA'] ?? 0,
//       shotsOnTargetB: map['shotsOnTargetB'] ?? 0,
//       cornersA: map['cornersA'] ?? 0,
//       cornersB: map['cornersB'] ?? 0,
//       foulsA: map['foulsA'] ?? 0,
//       foulsB: map['foulsB'] ?? 0,
//       yellowCardsA: map['yellowCardsA'] ?? 0,
//       yellowCardsB: map['yellowCardsB'] ?? 0,
//       redCardsA: map['redCardsA'] ?? 0,
//       redCardsB: map['redCardsB'] ?? 0,
//     );
//   }
//
//   Map<String, dynamic> toMap() {
//     return {
//       'possessionA': possessionA,
//       'possessionB': possessionB,
//       'shotsA': shotsA,
//       'shotsB': shotsB,
//       'shotsOnTargetA': shotsOnTargetA,
//       'shotsOnTargetB': shotsOnTargetB,
//       'cornersA': cornersA,
//       'cornersB': cornersB,
//       'foulsA': foulsA,
//       'foulsB': foulsB,
//       'yellowCardsA': yellowCardsA,
//       'yellowCardsB': yellowCardsB,
//       'redCardsA': redCardsA,
//       'redCardsB': redCardsB,
//     };
//   }
//
//   MatchStats copyWith({
//     int? possessionA,
//     int? possessionB,
//     int? shotsA,
//     int? shotsB,
//     int? shotsOnTargetA,
//     int? shotsOnTargetB,
//     int? cornersA,
//     int? cornersB,
//     int? foulsA,
//     int? foulsB,
//     int? yellowCardsA,
//     int? yellowCardsB,
//     int? redCardsA,
//     int? redCardsB,
//   }) {
//     return MatchStats(
//       possessionA: possessionA ?? this.possessionA,
//       possessionB: possessionB ?? this.possessionB,
//       shotsA: shotsA ?? this.shotsA,
//       shotsB: shotsB ?? this.shotsB,
//       shotsOnTargetA: shotsOnTargetA ?? this.shotsOnTargetA,
//       shotsOnTargetB: shotsOnTargetB ?? this.shotsOnTargetB,
//       cornersA: cornersA ?? this.cornersA,
//       cornersB: cornersB ?? this.cornersB,
//       foulsA: foulsA ?? this.foulsA,
//       foulsB: foulsB ?? this.foulsB,
//       yellowCardsA: yellowCardsA ?? this.yellowCardsA,
//       yellowCardsB: yellowCardsB ?? this.yellowCardsB,
//       redCardsA: redCardsA ?? this.redCardsA,
//       redCardsB: redCardsB ?? this.redCardsB,
//     );
//   }
// }
//
// class LineUp {
//   final String formation;
//   final List<PlayerLineUp> players;
//
//   LineUp({
//     required this.formation,
//     required this.players,
//   });
//
//   factory LineUp.fromMap(Map<String, dynamic> map) {
//     return LineUp(
//       formation: map['formation'] ?? '4-4-2',
//       players: (map['players'] as List<dynamic>?)
//           ?.map((e) => PlayerLineUp.fromMap(e as Map<String, dynamic>))
//           .toList() ??
//           [],
//     );
//   }
//
//   Map<String, dynamic> toMap() {
//     return {
//       'formation': formation,
//       'players': players.map((e) => e.toMap()).toList(),
//     };
//   }
// }
//
// class PlayerLineUp {
//   final String playerName;
//   final String playerId;
//   final int jerseyNumber;
//   final String position;
//   final bool isCaptain;
//   final bool isSubstitute;
//
//   PlayerLineUp({
//     required this.playerName,
//     required this.playerId,
//     required this.jerseyNumber,
//     required this.position,
//     this.isCaptain = false,
//     this.isSubstitute = false,
//   });
//
//   factory PlayerLineUp.fromMap(Map<String, dynamic> map) {
//     return PlayerLineUp(
//       playerName: map['playerName'] ?? '',
//       playerId: map['playerId'] ?? '',
//       jerseyNumber: map['jerseyNumber'] ?? 0,
//       position: map['position'] ?? 'MID',
//       isCaptain: map['isCaptain'] ?? false,
//       isSubstitute: map['isSubstitute'] ?? false,
//     );
//   }
//
//   Map<String, dynamic> toMap() {
//     return {
//       'playerName': playerName,
//       'playerId': playerId,
//       'jerseyNumber': jerseyNumber,
//       'position': position,
//       'isCaptain': isCaptain,
//       'isSubstitute': isSubstitute,
//     };
//   }
// }
import 'package:cloud_firestore/cloud_firestore.dart';

class MatchModel {
  final String id;
  final String teamA;  // Team A ID
  final String teamB;  // Team B ID
  final String teamAName;  // ✅ Team A Name (stored)
  final String teamBName;  // ✅ Team B Name (stored)
  final int scoreA;
  final int scoreB;
  final DateTime date;
  final DateTime time;
  final String status; // live, upcoming, completed
  final String? tournament;
  final String? tournamentId;
  final String? venue;
  final List<MatchEvent> timeline;
  final MatchStats? stats;
  final LineUp? lineUpA;
  final LineUp? lineUpB;
  final HeadToHead? h2h;
  final String? adminFullName;
  final DateTime? createdAt;

  MatchModel({
    required this.id,
    required this.teamA,
    required this.teamB,
    required this.teamAName,  // ✅ Required
    required this.teamBName,  // ✅ Required
    required this.scoreA,
    required this.scoreB,
    required this.date,
    required this.time,
    required this.status,
    this.tournament,
    this.tournamentId,
    this.venue,
    this.timeline = const [],
    this.stats,
    this.lineUpA,
    this.lineUpB,
    this.h2h,
    this.adminFullName,
    this.createdAt, required String createdBy,
  });

  factory MatchModel.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

    return MatchModel(
      id: doc.id,
      teamA: data['teamA'] ?? '',
      teamB: data['teamB'] ?? '',
      teamAName: data['teamAName'] ?? '',  // ✅ Added
      teamBName: data['teamBName'] ?? '',  // ✅ Added
      scoreA: data['scoreA'] ?? 0,
      scoreB: data['scoreB'] ?? 0,
      date: (data['date'] as Timestamp).toDate(),
      time: (data['time'] as Timestamp).toDate(),
      status: data['status'] ?? 'upcoming',
      tournament: data['tournament'],
      tournamentId: data['tournamentId'],
      venue: data['venue'],
      timeline: (data['timeline'] as List<dynamic>?)
          ?.map((e) => MatchEvent.fromMap(e as Map<String, dynamic>))
          .toList() ??
          [],
      stats: data['stats'] != null
          ? MatchStats.fromMap(data['stats'] as Map<String, dynamic>)
          : null,
      lineUpA: data['lineUpA'] != null
          ? LineUp.fromMap(data['lineUpA'] as Map<String, dynamic>)
          : null,
      lineUpB: data['lineUpB'] != null
          ? LineUp.fromMap(data['lineUpB'] as Map<String, dynamic>)
          : null,
      h2h: data['h2h'] != null
          ? HeadToHead.fromMap(data['h2h'] as Map<String, dynamic>)
          : null,
      adminFullName: data['adminFullName'],
      createdAt: data['createdAt'] != null
          ? (data['createdAt'] as Timestamp).toDate()
          : null, createdBy: '',
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'teamA': teamA,
      'teamB': teamB,
      'teamAName': teamAName,  // ✅ Added
      'teamBName': teamBName,  // ✅ Added
      'scoreA': scoreA,
      'scoreB': scoreB,
      'date': Timestamp.fromDate(date),
      'time': Timestamp.fromDate(time),
      'status': status,
      if (tournament != null) 'tournament': tournament,
      if (tournamentId != null) 'tournamentId': tournamentId,
      if (venue != null) 'venue': venue,
      'timeline': timeline.map((e) => e.toMap()).toList(),
      if (stats != null) 'stats': stats!.toMap(),
      if (lineUpA != null) 'lineUpA': lineUpA!.toMap(),
      if (lineUpB != null) 'lineUpB': lineUpB!.toMap(),
      if (h2h != null) 'h2h': h2h!.toMap(),
      if (adminFullName != null) 'adminFullName': adminFullName,
      if (createdAt != null) 'createdAt': Timestamp.fromDate(createdAt!),
    };
  }

  // ✅ Add copyWith method for easy updates
  MatchModel copyWith({
    String? id,
    String? teamA,
    String? teamB,
    String? teamAName,  // ✅ Added
    String? teamBName,  // ✅ Added
    int? scoreA,
    int? scoreB,
    DateTime? date,
    DateTime? time,
    String? status,
    String? tournament,
    String? tournamentId,
    String? venue,
    List<MatchEvent>? timeline,
    MatchStats? stats,
    LineUp? lineUpA,
    LineUp? lineUpB,
    HeadToHead? h2h,
    String? adminFullName,
    DateTime? createdAt,
  }) {
    return MatchModel(
      id: id ?? this.id,
      teamA: teamA ?? this.teamA,
      teamB: teamB ?? this.teamB,
      teamAName: teamAName ?? this.teamAName,  // ✅ Added
      teamBName: teamBName ?? this.teamBName,  // ✅ Added
      scoreA: scoreA ?? this.scoreA,
      scoreB: scoreB ?? this.scoreB,
      date: date ?? this.date,
      time: time ?? this.time,
      status: status ?? this.status,
      tournament: tournament ?? this.tournament,
      tournamentId: tournamentId ?? this.tournamentId,
      venue: venue ?? this.venue,
      timeline: timeline ?? this.timeline,
      stats: stats ?? this.stats,
      lineUpA: lineUpA ?? this.lineUpA,
      lineUpB: lineUpB ?? this.lineUpB,
      h2h: h2h ?? this.h2h,
      adminFullName: adminFullName ?? this.adminFullName,
      createdAt: createdAt ?? this.createdAt, createdBy: '',
    );
  }
}

// Timeline Event Model
class MatchEvent {
  final String type; // goal, card, substitution
  final String team; // teamA or teamB
  final String playerName;
  final String playerId;
  final int minute;
  final String? details; // yellow, red, out, in
  final String? assistPlayerId;
  final String? assistPlayerName; // ✅ Added for displaying assist info
  final String? assistType; // ✅ Added: penalty, alone, assist

  MatchEvent({
    required this.type,
    required this.team,
    required this.playerName,
    required this.playerId,
    required this.minute,
    this.details,
    this.assistPlayerId,
    this.assistPlayerName,
    this.assistType,
  });

  factory MatchEvent.fromMap(Map<String, dynamic> map) {
    return MatchEvent(
      type: map['type'] ?? '',
      team: map['team'] ?? '',
      playerName: map['playerName'] ?? '',
      playerId: map['playerId'] ?? '',
      minute: map['minute'] ?? 0,
      details: map['details'],
      assistPlayerId: map['assistPlayerId'],
      assistPlayerName: map['assistPlayerName'],
      assistType: map['assistType'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'type': type,
      'team': team,
      'playerName': playerName,
      'playerId': playerId,
      'minute': minute,
      if (details != null) 'details': details,
      if (assistPlayerId != null) 'assistPlayerId': assistPlayerId,
      if (assistPlayerName != null) 'assistPlayerName': assistPlayerName,
      if (assistType != null) 'assistType': assistType,
    };
  }
}

// Match Statistics Model
class MatchStats {
  final int possessionA;
  final int possessionB;
  final int shotsA;
  final int shotsB;
  final int shotsOnTargetA;
  final int shotsOnTargetB;
  final int cornersA;
  final int cornersB;
  final int foulsA;
  final int foulsB;
  final int yellowCardsA;
  final int yellowCardsB;
  final int redCardsA;
  final int redCardsB;

  MatchStats({
    this.possessionA = 50,
    this.possessionB = 50,
    this.shotsA = 0,
    this.shotsB = 0,
    this.shotsOnTargetA = 0,
    this.shotsOnTargetB = 0,
    this.cornersA = 0,
    this.cornersB = 0,
    this.foulsA = 0,
    this.foulsB = 0,
    this.yellowCardsA = 0,
    this.yellowCardsB = 0,
    this.redCardsA = 0,
    this.redCardsB = 0,
  });

  factory MatchStats.fromMap(Map<String, dynamic> map) {
    return MatchStats(
      possessionA: (map['possessionA'] ?? 50).toInt(),
      possessionB: (map['possessionB'] ?? 50).toInt(),
      shotsA: (map['shotsA'] ?? 0).toInt(),
      shotsB: (map['shotsB'] ?? 0).toInt(),
      shotsOnTargetA: (map['shotsOnTargetA'] ?? 0).toInt(),
      shotsOnTargetB: (map['shotsOnTargetB'] ?? 0).toInt(),
      cornersA: (map['cornersA'] ?? 0).toInt(),
      cornersB: (map['cornersB'] ?? 0).toInt(),
      foulsA: (map['foulsA'] ?? 0).toInt(),
      foulsB: (map['foulsB'] ?? 0).toInt(),
      yellowCardsA: (map['yellowCardsA'] ?? 0).toInt(),
      yellowCardsB: (map['yellowCardsB'] ?? 0).toInt(),
      redCardsA: (map['redCardsA'] ?? 0).toInt(),
      redCardsB: (map['redCardsB'] ?? 0).toInt(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'possessionA': possessionA,
      'possessionB': possessionB,
      'shotsA': shotsA,
      'shotsB': shotsB,
      'shotsOnTargetA': shotsOnTargetA,
      'shotsOnTargetB': shotsOnTargetB,
      'cornersA': cornersA,
      'cornersB': cornersB,
      'foulsA': foulsA,
      'foulsB': foulsB,
      'yellowCardsA': yellowCardsA,
      'yellowCardsB': yellowCardsB,
      'redCardsA': redCardsA,
      'redCardsB': redCardsB,
    };
  }

  // Copy with method for easy updates
  MatchStats copyWith({
    int? possessionA,
    int? possessionB,
    int? shotsA,
    int? shotsB,
    int? shotsOnTargetA,
    int? shotsOnTargetB,
    int? cornersA,
    int? cornersB,
    int? foulsA,
    int? foulsB,
    int? yellowCardsA,
    int? yellowCardsB,
    int? redCardsA,
    int? redCardsB,
  }) {
    return MatchStats(
      possessionA: possessionA ?? this.possessionA,
      possessionB: possessionB ?? this.possessionB,
      shotsA: shotsA ?? this.shotsA,
      shotsB: shotsB ?? this.shotsB,
      shotsOnTargetA: shotsOnTargetA ?? this.shotsOnTargetA,
      shotsOnTargetB: shotsOnTargetB ?? this.shotsOnTargetB,
      cornersA: cornersA ?? this.cornersA,
      cornersB: cornersB ?? this.cornersB,
      foulsA: foulsA ?? this.foulsA,
      foulsB: foulsB ?? this.foulsB,
      yellowCardsA: yellowCardsA ?? this.yellowCardsA,
      yellowCardsB: yellowCardsB ?? this.yellowCardsB,
      redCardsA: redCardsA ?? this.redCardsA,
      redCardsB: redCardsB ?? this.redCardsB,
    );
  }
}

// LineUp Model
class LineUp {
  final String formation; // e.g., "4-4-2"
  final List<PlayerLineUp> players;

  LineUp({
    this.formation = '4-4-2', // ✅ Default value
    required this.players,
  });

  factory LineUp.fromMap(Map<String, dynamic> map) {
    return LineUp(
      formation: map['formation'] ?? '4-4-2',
      players: (map['players'] as List<dynamic>?)
          ?.map((e) => PlayerLineUp.fromMap(e as Map<String, dynamic>))
          .toList() ??
          [],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'formation': formation,
      'players': players.map((e) => e.toMap()).toList(),
    };
  }
}

// Player LineUp Model
// lib/models/match_model.dart (শুধু PlayerLineUp অংশটা রিপ্লেস করো)

class PlayerLineUp {
  final String playerId;
  final String playerName;
  final String position;
  final int jerseyNumber;
  bool isSubstitute;
  bool isCaptain;        // ← এটা রাখলাম

  PlayerLineUp({
    required this.playerId,
    required this.playerName,
    required this.position,
    required this.jerseyNumber,
    this.isSubstitute = false,
    this.isCaptain = false,     // ডিফল্ট কেউ ক্যাপ্টেন না
  });

  factory PlayerLineUp.fromMap(Map<String, dynamic> map) {
    return PlayerLineUp(
      playerId: map['playerId'] ?? '',
      playerName: map['playerName'] ?? '',
      position: map['position'] ?? '',
      jerseyNumber: map['jerseyNumber'] ?? 0,
      isSubstitute: map['isSubstitute'] ?? false,
      isCaptain: map['isCaptain'] ?? false,        // ← এটা যোগ করলাম
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'playerId': playerId,
      'playerName': playerName,
      'position': position,
      'jerseyNumber': jerseyNumber,
      'isSubstitute': isSubstitute,
      'isCaptain': isCaptain,                      // ← সেভ করার সময়ও যাবে
    };
  }

  // খুবই জরুরি: copyWith (immutable way তে চেঞ্জ করার জন্য)
  PlayerLineUp copyWith({
    bool? isSubstitute,
    bool? isCaptain,
  }) {
    return PlayerLineUp(
      playerId: playerId,
      playerName: playerName,
      position: position,
      jerseyNumber: jerseyNumber,
      isSubstitute: isSubstitute ?? this.isSubstitute,
      isCaptain: isCaptain ?? this.isCaptain,
    );
  }
}

// Head to Head Model
class HeadToHead {
  final int totalMatches;
  final int teamAWins;
  final int teamBWins;
  final int draws;
  final int teamAGoals;
  final int teamBGoals;

  HeadToHead({
    this.totalMatches = 0,
    this.teamAWins = 0,
    this.teamBWins = 0,
    this.draws = 0,
    this.teamAGoals = 0,
    this.teamBGoals = 0,
  });

  factory HeadToHead.fromMap(Map<String, dynamic> map) {
    return HeadToHead(
      totalMatches: map['totalMatches'] ?? 0,
      teamAWins: map['teamAWins'] ?? 0,
      teamBWins: map['teamBWins'] ?? 0,
      draws: map['draws'] ?? 0,
      teamAGoals: map['teamAGoals'] ?? 0,
      teamBGoals: map['teamBGoals'] ?? 0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'totalMatches': totalMatches,
      'teamAWins': teamAWins,
      'teamBWins': teamBWins,
      'draws': draws,
      'teamAGoals': teamAGoals,
      'teamBGoals': teamBGoals,
    };
  }
}