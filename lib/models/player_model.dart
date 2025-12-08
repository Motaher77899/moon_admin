import 'package:cloud_firestore/cloud_firestore.dart';

class PlayerModel {
  final String id;
  final String userId;
  final String name;
  final String position;
  final String imageUrl;
  final String? profilePhotoUrl;
  final String upazila;
  final String district;
  final String division;
  final DateTime dateOfBirth;
  final String playerId;
  final String? teamName;
  final DateTime createdAt;

  // Admin specific fields (optional)
  final int? jerseyNumber;
  final bool? isCaptain;
  final int? goals;
  final int? assists;
  final int? yellowCards;
  final int? redCards;
  final int? matchesPlayed;

  PlayerModel({
    required this.id,
    required this.userId,
    required this.name,
    required this.position,
    required this.imageUrl,
    this.profilePhotoUrl,
    required this.upazila,
    required this.district,
    required this.division,
    required this.dateOfBirth,
    required this.playerId,
    this.teamName,
    required this.createdAt,
    this.jerseyNumber,
    this.isCaptain = false,
    this.goals = 0,
    this.assists = 0,
    this.yellowCards = 0,
    this.redCards = 0,
    this.matchesPlayed = 0,
  });

  factory PlayerModel.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return PlayerModel(
      id: doc.id,
      userId: data['userId'] ?? '',
      name: data['name'] ?? '',
      position: data['position'] ?? '',
      imageUrl: data['imageUrl'] ?? '',
      profilePhotoUrl: data['profilePhotoUrl'],
      upazila: data['upazila'] ?? '',
      district: data['district'] ?? '',
      division: data['division'] ?? '',
      dateOfBirth: data['dateOfBirth'] != null
          ? (data['dateOfBirth'] as Timestamp).toDate()
          : DateTime.now(),
      playerId: data['playerId'] ?? doc.id,
      teamName: data['teamName'],
      createdAt: data['createdAt'] != null
          ? (data['createdAt'] as Timestamp).toDate()
          : DateTime.now(),
      jerseyNumber: data['jerseyNumber'],
      isCaptain: data['isCaptain'] ?? false,
      goals: data['goals'] ?? 0,
      assists: data['assists'] ?? 0,
      yellowCards: data['yellowCards'] ?? 0,
      redCards: data['redCards'] ?? 0,
      matchesPlayed: data['matchesPlayed'] ?? 0,
    );
  }

  // Map থেকে PlayerModel তৈরি (lineup এর জন্য)
  factory PlayerModel.fromMap(Map<String, dynamic> data, String docId) {
    return PlayerModel(
      id: docId,
      userId: data['userId'] ?? '',
      name: data['name'] ?? '',
      position: data['position'] ?? '',
      imageUrl: data['imageUrl'] ?? '',
      profilePhotoUrl: data['profilePhotoUrl'],
      upazila: data['upazila'] ?? '',
      district: data['district'] ?? '',
      division: data['division'] ?? '',
      dateOfBirth: data['dateOfBirth'] is Timestamp
          ? (data['dateOfBirth'] as Timestamp).toDate()
          : DateTime.now(),
      playerId: data['playerId'] ?? docId,
      teamName: data['teamName'],
      createdAt: data['createdAt'] is Timestamp
          ? (data['createdAt'] as Timestamp).toDate()
          : DateTime.now(),
      jerseyNumber: data['jerseyNumber'],
      isCaptain: data['isCaptain'] ?? false,
      goals: data['goals'] ?? 0,
      assists: data['assists'] ?? 0,
      yellowCards: data['yellowCards'] ?? 0,
      redCards: data['redCards'] ?? 0,
      matchesPlayed: data['matchesPlayed'] ?? 0,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'userId': userId,
      'name': name,
      'position': position,
      'imageUrl': imageUrl,
      'profilePhotoUrl': profilePhotoUrl,
      'upazila': upazila,
      'district': district,
      'division': division,
      'dateOfBirth': Timestamp.fromDate(dateOfBirth),
      'playerId': playerId,
      'teamName': teamName,
      'createdAt': Timestamp.fromDate(createdAt),
      if (jerseyNumber != null) 'jerseyNumber': jerseyNumber,
      'isCaptain': isCaptain ?? false,
      'goals': goals ?? 0,
      'assists': assists ?? 0,
      'yellowCards': yellowCards ?? 0,
      'redCards': redCards ?? 0,
      'matchesPlayed': matchesPlayed ?? 0,
    };
  }

  PlayerModel copyWith({
    String? id,
    String? userId,
    String? name,
    String? position,
    String? imageUrl,
    String? profilePhotoUrl,
    String? upazila,
    String? district,
    String? division,
    DateTime? dateOfBirth,
    String? playerId,
    String? teamName,
    DateTime? createdAt,
    int? jerseyNumber,
    bool? isCaptain,
    int? goals,
    int? assists,
    int? yellowCards,
    int? redCards,
    int? matchesPlayed,
  }) {
    return PlayerModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      name: name ?? this.name,
      position: position ?? this.position,
      imageUrl: imageUrl ?? this.imageUrl,
      profilePhotoUrl: profilePhotoUrl ?? this.profilePhotoUrl,
      upazila: upazila ?? this.upazila,
      district: district ?? this.district,
      division: division ?? this.division,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      playerId: playerId ?? this.playerId,
      teamName: teamName ?? this.teamName,
      createdAt: createdAt ?? this.createdAt,
      jerseyNumber: jerseyNumber ?? this.jerseyNumber,
      isCaptain: isCaptain ?? this.isCaptain,
      goals: goals ?? this.goals,
      assists: assists ?? this.assists,
      yellowCards: yellowCards ?? this.yellowCards,
      redCards: redCards ?? this.redCards,
      matchesPlayed: matchesPlayed ?? this.matchesPlayed,
    );
  }
}