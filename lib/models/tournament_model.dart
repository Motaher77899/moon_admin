// import 'package:cloud_firestore/cloud_firestore.dart';
//
// class TournamentModel {
//   final String? tournamentId;
//   final String name;
//   final String description;
//   final DateTime startDate;
//   final DateTime endDate;
//   final String status;
//   final List<String> teamIds;
//   final String? logoUrl;
//   final String createdBy; // ✅ Added
//   final DateTime createdAt;
//
//   TournamentModel({
//     this.tournamentId,
//     required this.name,
//     required this.description,
//     required this.startDate,
//     required this.endDate,
//     this.status = 'upcoming',
//     required this.teamIds,
//     this.logoUrl,
//     required this.createdBy, // ✅ Added
//     required this.createdAt,
//   });
//
//   factory TournamentModel.fromFirestore(DocumentSnapshot doc) {
//     Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
//     return TournamentModel(
//       tournamentId: doc.id,
//       name: data['name'] ?? '',
//       description: data['description'] ?? '',
//       startDate: (data['startDate'] as Timestamp?)?.toDate() ?? DateTime.now(),
//       endDate: (data['endDate'] as Timestamp?)?.toDate() ?? DateTime.now(),
//       status: data['status'] ?? 'upcoming',
//       teamIds: List<String>.from(data['teamIds'] ?? []),
//       logoUrl: data['logoUrl'],
//       createdBy: data['createdBy'] ?? 'Unknown', // ✅ Added
//       createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
//     );
//   }
//
//   Map<String, dynamic> toFirestore() {
//     return {
//       'name': name,
//       'description': description,
//       'startDate': Timestamp.fromDate(startDate),
//       'endDate': Timestamp.fromDate(endDate),
//       'status': status,
//       'teamIds': teamIds,
//       'logoUrl': logoUrl,
//       'createdBy': createdBy, // ✅ Added
//       'createdAt': Timestamp.fromDate(createdAt),
//     };
//   }
//
//   TournamentModel copyWith({
//     String? tournamentId,
//     String? name,
//     String? description,
//     DateTime? startDate,
//     DateTime? endDate,
//     String? status,
//     List<String>? teamIds,
//     String? logoUrl,
//     String? createdBy, // ✅ Added
//     DateTime? createdAt,
//   }) {
//     return TournamentModel(
//       tournamentId: tournamentId ?? this.tournamentId,
//       name: name ?? this.name,
//       description: description ?? this.description,
//       startDate: startDate ?? this.startDate,
//       endDate: endDate ?? this.endDate,
//       status: status ?? this.status,
//       teamIds: teamIds ?? this.teamIds,
//       logoUrl: logoUrl ?? this.logoUrl,
//       createdBy: createdBy ?? this.createdBy, // ✅ Added
//       createdAt: createdAt ?? this.createdAt,
//     );
//   }
// }

import 'package:cloud_firestore/cloud_firestore.dart';

// ============================================================================
// TOURNAMENT MODEL
// ============================================================================
class TournamentModel {
  final String? tournamentId;
  final String name;
  final String description;
  final DateTime startDate;
  final DateTime endDate;
  final String status;
  final List<String> teamIds;
  final String? logoUrl;
  final String createdBy;
  final DateTime createdAt;

  // Tournament settings
  final String format; // 'groups', 'knockout', 'league'
  final int numberOfGroups;
  final int teamsPerGroup;
  final int qualifiedTeamsPerGroup;
  final bool hasKnockoutStage;
  final int matchDuration; // in minutes

  TournamentModel({
    this.tournamentId,
    required this.name,
    required this.description,
    required this.startDate,
    required this.endDate,
    this.status = 'upcoming',
    required this.teamIds,
    this.logoUrl,
    required this.createdBy,
    required this.createdAt,
    this.format = 'groups',
    this.numberOfGroups = 1,
    this.teamsPerGroup = 4,
    this.qualifiedTeamsPerGroup = 2,
    this.hasKnockoutStage = true,
    this.matchDuration = 90,
  });

  factory TournamentModel.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return TournamentModel(
      tournamentId: doc.id,
      name: data['name'] ?? '',
      description: data['description'] ?? '',
      startDate: (data['startDate'] as Timestamp?)?.toDate() ?? DateTime.now(),
      endDate: (data['endDate'] as Timestamp?)?.toDate() ?? DateTime.now(),
      status: data['status'] ?? 'upcoming',
      teamIds: List<String>.from(data['teamIds'] ?? []),
      logoUrl: data['logoUrl'],
      createdBy: data['createdBy'] ?? 'Unknown',
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      format: data['format'] ?? 'groups',
      numberOfGroups: data['numberOfGroups'] ?? 1,
      teamsPerGroup: data['teamsPerGroup'] ?? 4,
      qualifiedTeamsPerGroup: data['qualifiedTeamsPerGroup'] ?? 2,
      hasKnockoutStage: data['hasKnockoutStage'] ?? true,
      matchDuration: data['matchDuration'] ?? 90,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'name': name,
      'description': description,
      'startDate': Timestamp.fromDate(startDate),
      'endDate': Timestamp.fromDate(endDate),
      'status': status,
      'teamIds': teamIds,
      'logoUrl': logoUrl,
      'createdBy': createdBy,
      'createdAt': Timestamp.fromDate(createdAt),
      'format': format,
      'numberOfGroups': numberOfGroups,
      'teamsPerGroup': teamsPerGroup,
      'qualifiedTeamsPerGroup': qualifiedTeamsPerGroup,
      'hasKnockoutStage': hasKnockoutStage,
      'matchDuration': matchDuration,
    };
  }

  TournamentModel copyWith({
    String? tournamentId,
    String? name,
    String? description,
    DateTime? startDate,
    DateTime? endDate,
    String? status,
    List<String>? teamIds,
    String? logoUrl,
    String? createdBy,
    DateTime? createdAt,
    String? format,
    int? numberOfGroups,
    int? teamsPerGroup,
    int? qualifiedTeamsPerGroup,
    bool? hasKnockoutStage,
    int? matchDuration,
  }) {
    return TournamentModel(
      tournamentId: tournamentId ?? this.tournamentId,
      name: name ?? this.name,
      description: description ?? this.description,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      status: status ?? this.status,
      teamIds: teamIds ?? this.teamIds,
      logoUrl: logoUrl ?? this.logoUrl,
      createdBy: createdBy ?? this.createdBy,
      createdAt: createdAt ?? this.createdAt,
      format: format ?? this.format,
      numberOfGroups: numberOfGroups ?? this.numberOfGroups,
      teamsPerGroup: teamsPerGroup ?? this.teamsPerGroup,
      qualifiedTeamsPerGroup: qualifiedTeamsPerGroup ?? this.qualifiedTeamsPerGroup,
      hasKnockoutStage: hasKnockoutStage ?? this.hasKnockoutStage,
      matchDuration: matchDuration ?? this.matchDuration,
    );
  }
}

// ============================================================================
// TOURNAMENT GROUP MODEL
// ============================================================================
class TournamentGroup {
  final String? groupId;
  final String tournamentId;
  final String groupName; // 'Group A', 'Group B', etc.
  final List<String> teamIds;
  final int groupOrder; // 0, 1, 2... for sorting

  TournamentGroup({
    this.groupId,
    required this.tournamentId,
    required this.groupName,
    required this.teamIds,
    required this.groupOrder,
  });

  factory TournamentGroup.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return TournamentGroup(
      groupId: doc.id,
      tournamentId: data['tournamentId'] ?? '',
      groupName: data['groupName'] ?? '',
      teamIds: List<String>.from(data['teamIds'] ?? []),
      groupOrder: data['groupOrder'] ?? 0,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'tournamentId': tournamentId,
      'groupName': groupName,
      'teamIds': teamIds,
      'groupOrder': groupOrder,
    };
  }
}

// ============================================================================
// TOURNAMENT MATCH MODEL
// ============================================================================
class TournamentMatch {
  final String? tournamentName;
  final String? matchId;
  final String tournamentId;
  final String teamAId;
  final String teamBId;
  final String teamAName;
  final String teamBName;
  final String? teamALogo;
  final String? teamBLogo;
  final int scoreA;
  final int scoreB;
  final String status; // 'upcoming', 'live', 'completed'
  final DateTime matchDate;
  final String venue;
  final String round; // 'Group A - Match 1', 'Semi Final', 'Final'
  final String? groupName; // 'Group A', 'Group B', null for knockout
  final DateTime createdAt;

  TournamentMatch({
    this.tournamentName,
    this.matchId,
    required this.tournamentId,
    required this.teamAId,
    required this.teamBId,
    required this.teamAName,
    required this.teamBName,
    this.teamALogo,
    this.teamBLogo,
    this.scoreA = 0,
    this.scoreB = 0,
    this.status = 'upcoming',
    required this.matchDate,
    required this.venue,
    required this.round,
    this.groupName,
    required this.createdAt,
  });

  factory TournamentMatch.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return TournamentMatch(
      tournamentName: data['tournamentName'],
      matchId: doc.id,
      tournamentId: data['tournamentId'] ?? '',
      teamAId: data['teamAId'] ?? '',
      teamBId: data['teamBId'] ?? '',
      teamAName: data['teamAName'] ?? '',
      teamBName: data['teamBName'] ?? '',
      teamALogo: data['teamALogo'],
      teamBLogo: data['teamBLogo'],
      scoreA: data['scoreA'] ?? 0,
      scoreB: data['scoreB'] ?? 0,
      status: data['status'] ?? 'upcoming',
      matchDate: (data['matchDate'] as Timestamp?)?.toDate() ?? DateTime.now(),
      venue: data['venue'] ?? '',
      round: data['round'] ?? '',
      groupName: data['groupName'],
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'tournamentId': tournamentId,
      'teamAId': teamAId,
      'teamBId': teamBId,
      'teamAName': teamAName,
      'teamBName': teamBName,
      'teamALogo': teamALogo,
      'teamBLogo': teamBLogo,
      'scoreA': scoreA,
      'scoreB': scoreB,
      'status': status,
      'matchDate': Timestamp.fromDate(matchDate),
      'venue': venue,
      'round': round,
      'groupName': groupName,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }

  TournamentMatch copyWith({
    String? matchId,
    String? tournamentId,
    String? teamAId,
    String? teamBId,
    String? teamAName,
    String? teamBName,
    String? teamALogo,
    String? teamBLogo,
    int? scoreA,
    int? scoreB,
    String? status,
    DateTime? matchDate,
    String? venue,
    String? round,
    String? groupName,
    DateTime? createdAt,
  }) {
    return TournamentMatch(
      matchId: matchId ?? this.matchId,
      tournamentId: tournamentId ?? this.tournamentId,
      teamAId: teamAId ?? this.teamAId,
      teamBId: teamBId ?? this.teamBId,
      teamAName: teamAName ?? this.teamAName,
      teamBName: teamBName ?? this.teamBName,
      teamALogo: teamALogo ?? this.teamALogo,
      teamBLogo: teamBLogo ?? this.teamBLogo,
      scoreA: scoreA ?? this.scoreA,
      scoreB: scoreB ?? this.scoreB,
      status: status ?? this.status,
      matchDate: matchDate ?? this.matchDate,
      venue: venue ?? this.venue,
      round: round ?? this.round,
      groupName: groupName ?? this.groupName,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}

// ============================================================================
// TOURNAMENT TEAM STATS MODEL (Points Table)
// ============================================================================
class TournamentTeamStats {
  final String? statsId;
  final String tournamentId;
  final String teamId;
  final String teamName;
  final String? teamLogo;
  final String? groupName;
  final int matchesPlayed;
  final int wins;
  final int draws;
  final int losses;
  final int goalsFor;
  final int goalsAgainst;
  final int points;

  TournamentTeamStats({
    this.statsId,
    required this.tournamentId,
    required this.teamId,
    required this.teamName,
    this.teamLogo,
    this.groupName,
    this.matchesPlayed = 0,
    this.wins = 0,
    this.draws = 0,
    this.losses = 0,
    this.goalsFor = 0,
    this.goalsAgainst = 0,
    this.points = 0,
  });

  factory TournamentTeamStats.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return TournamentTeamStats(
      statsId: doc.id,
      tournamentId: data['tournamentId'] ?? '',
      teamId: data['teamId'] ?? '',
      teamName: data['teamName'] ?? '',
      teamLogo: data['teamLogo'],
      groupName: data['groupName'],
      matchesPlayed: data['matchesPlayed'] ?? 0,
      wins: data['wins'] ?? 0,
      draws: data['draws'] ?? 0,
      losses: data['losses'] ?? 0,
      goalsFor: data['goalsFor'] ?? 0,
      goalsAgainst: data['goalsAgainst'] ?? 0,
      points: data['points'] ?? 0,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'tournamentId': tournamentId,
      'teamId': teamId,
      'teamName': teamName,
      'teamLogo': teamLogo,
      'groupName': groupName,
      'matchesPlayed': matchesPlayed,
      'wins': wins,
      'draws': draws,
      'losses': losses,
      'goalsFor': goalsFor,
      'goalsAgainst': goalsAgainst,
      'points': points,
    };
  }

  int get goalDifference => goalsFor - goalsAgainst;

  TournamentTeamStats copyWith({
    String? statsId,
    String? tournamentId,
    String? teamId,
    String? teamName,
    String? teamLogo,
    String? groupName,
    int? matchesPlayed,
    int? wins,
    int? draws,
    int? losses,
    int? goalsFor,
    int? goalsAgainst,
    int? points,
  }) {
    return TournamentTeamStats(
      statsId: statsId ?? this.statsId,
      tournamentId: tournamentId ?? this.tournamentId,
      teamId: teamId ?? this.teamId,
      teamName: teamName ?? this.teamName,
      teamLogo: teamLogo ?? this.teamLogo,
      groupName: groupName ?? this.groupName,
      matchesPlayed: matchesPlayed ?? this.matchesPlayed,
      wins: wins ?? this.wins,
      draws: draws ?? this.draws,
      losses: losses ?? this.losses,
      goalsFor: goalsFor ?? this.goalsFor,
      goalsAgainst: goalsAgainst ?? this.goalsAgainst,
      points: points ?? this.points,
    );
  }
}

// ============================================================================
// TOURNAMENT PLAYER STATS MODEL
// ============================================================================
class TournamentPlayerStats {
  final String? statsId;
  final String tournamentId;
  final String playerId;
  final String playerName;
  final String? playerPhoto;
  final String teamId;
  final String teamName;
  final int goals;
  final int assists;
  final int yellowCards;
  final int redCards;
  final int matchesPlayed;

  TournamentPlayerStats({
    this.statsId,
    required this.tournamentId,
    required this.playerId,
    required this.playerName,
    this.playerPhoto,
    required this.teamId,
    required this.teamName,
    this.goals = 0,
    this.assists = 0,
    this.yellowCards = 0,
    this.redCards = 0,
    this.matchesPlayed = 0,
  });

  factory TournamentPlayerStats.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return TournamentPlayerStats(
      statsId: doc.id,
      tournamentId: data['tournamentId'] ?? '',
      playerId: data['playerId'] ?? '',
      playerName: data['playerName'] ?? '',
      playerPhoto: data['playerPhoto'],
      teamId: data['teamId'] ?? '',
      teamName: data['teamName'] ?? '',
      goals: data['goals'] ?? 0,
      assists: data['assists'] ?? 0,
      yellowCards: data['yellowCards'] ?? 0,
      redCards: data['redCards'] ?? 0,
      matchesPlayed: data['matchesPlayed'] ?? 0,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'tournamentId': tournamentId,
      'playerId': playerId,
      'playerName': playerName,
      'playerPhoto': playerPhoto,
      'teamId': teamId,
      'teamName': teamName,
      'goals': goals,
      'assists': assists,
      'yellowCards': yellowCards,
      'redCards': redCards,
      'matchesPlayed': matchesPlayed,
    };
  }
}