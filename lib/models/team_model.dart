// // import 'package:cloud_firestore/cloud_firestore.dart';
// //
// // class TeamModel {
// //   final String? teamId; // Admin app এ teamId হিসেবে use হবে
// //   final String name;
// //   final String? upazila;
// //   final String? district;
// //   final String? division;
// //   final String? logoUrl;
// //   final String? managerId;
// //   final List<String> playerIds;
// //   final DateTime createdAt;
// //
// //   TeamModel({
// //     this.teamId,
// //     required this.name,
// //     this.upazila,
// //     this.district,
// //     this.division,
// //     this.logoUrl,
// //     this.managerId,
// //     this.playerIds = const [],
// //     required this.createdAt,
// //   });
// //
// //   // Getter for backwards compatibility
// //   String? get id => teamId;
// //   int get playersCount => playerIds.length;
// //
// //   // fromFirestore
// //   factory TeamModel.fromFirestore(DocumentSnapshot doc) {
// //     final data = doc.data() as Map<String, dynamic>;
// //     return TeamModel(
// //       teamId: doc.id,
// //       name: data['name'] ?? '',
// //       upazila: data['upazila'],
// //       district: data['district'],
// //       division: data['division'],
// //       logoUrl: data['logoUrl'],
// //       managerId: data['managerId'],
// //       playerIds: List<String>.from(data['playerIds'] ?? []),
// //       createdAt: _parseTimestamp(data['createdAt']),
// //     );
// //   }
// //
// //   // fromMap
// //   factory TeamModel.fromMap(Map<String, dynamic> data, String id) {
// //     return TeamModel(
// //       teamId: id,
// //       name: data['name'] ?? '',
// //       upazila: data['upazila'],
// //       district: data['district'],
// //       division: data['division'],
// //       logoUrl: data['logoUrl'],
// //       managerId: data['managerId'],
// //       playerIds: List<String>.from(data['playerIds'] ?? []),
// //       createdAt: _parseTimestamp(data['createdAt']),
// //     );
// //   }
// //
// //   static DateTime _parseTimestamp(dynamic value) {
// //     if (value == null) return DateTime.now();
// //     if (value is Timestamp) return value.toDate();
// //     if (value is DateTime) return value;
// //     if (value is String) {
// //       try {
// //         return DateTime.parse(value);
// //       } catch (e) {
// //         return DateTime.now();
// //       }
// //     }
// //     return DateTime.now();
// //   }
// //
// //   Map<String, dynamic> toFirestore() {
// //     return {
// //       'name': name,
// //       'upazila': upazila,
// //       'district': district,
// //       'division': division,
// //       'logoUrl': logoUrl,
// //       'managerId': managerId,
// //       'playerIds': playerIds,
// //       'createdAt': Timestamp.fromDate(createdAt),
// //     };
// //   }
// //
// //   Map<String, dynamic> toMap() {
// //     return {
// //       'teamId': teamId,
// //       'name': name,
// //       'upazila': upazila,
// //       'district': district,
// //       'division': division,
// //       'logoUrl': logoUrl,
// //       'managerId': managerId,
// //       'playerIds': playerIds,
// //       'createdAt': createdAt.toIso8601String(),
// //     };
// //   }
// //
// //   TeamModel copyWith({
// //     String? teamId,
// //     String? name,
// //     String? upazila,
// //     String? district,
// //     String? division,
// //     String? logoUrl,
// //     String? managerId,
// //     List<String>? playerIds,
// //     DateTime? createdAt,
// //   }) {
// //     return TeamModel(
// //       teamId: teamId ?? this.teamId,
// //       name: name ?? this.name,
// //       upazila: upazila ?? this.upazila,
// //       district: district ?? this.district,
// //       division: division ?? this.division,
// //       logoUrl: logoUrl ?? this.logoUrl,
// //       managerId: managerId ?? this.managerId,
// //       playerIds: playerIds ?? this.playerIds,
// //       createdAt: createdAt ?? this.createdAt,
// //     );
// //   }
// //
// //   @override
// //   String toString() {
// //     return 'TeamModel(id: $teamId, name: $name, players: ${playerIds.length})';
// //   }
// //
// //   @override
// //   bool operator ==(Object other) {
// //     if (identical(this, other)) return true;
// //     return other is TeamModel && other.teamId == teamId;
// //   }
// //
// //   @override
// //   int get hashCode => teamId.hashCode;
// // }
//
// import 'package:cloud_firestore/cloud_firestore.dart';
//
// class TeamModel {
//   final String? teamId;
//   final String name;
//   final String? logoUrl;  // ✅ Made nullable
//   final String? district;
//   final String? upazila;
//   final String? description;
//   final DateTime createdAt;
//   final String createdBy;
//
//   TeamModel({
//     this.teamId,
//     required this.name,
//     this.logoUrl,  // ✅ Nullable
//     this.district,
//     this.upazila,
//     this.description,
//     required this.createdAt,
//     required this.createdBy,
//   });
//
//   // From Firestore
//   factory TeamModel.fromFirestore(DocumentSnapshot doc) {
//     Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
//
//     return TeamModel(
//       teamId: doc.id,
//       name: data['name'] ?? '',
//       logoUrl: data['logoUrl'],  // ✅ Can be null
//       district: data['district'],
//       upazila: data['upazila'],
//       description: data['description'],
//       createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
//       createdBy: data['createdBy'] ?? '',
//     );
//   }
//
//   // From Map (for queries)
//   factory TeamModel.fromMap(Map<String, dynamic> data, String id) {
//     return TeamModel(
//       teamId: id,
//       name: data['name'] ?? '',
//       logoUrl: data['logoUrl'],  // ✅ Can be null
//       district: data['district'],
//       upazila: data['upazila'],
//       description: data['description'],
//       createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
//       createdBy: data['createdBy'] ?? '',
//     );
//   }
//
//   // To Firestore
//   Map<String, dynamic> toFirestore() {
//     return {
//       'name': name,
//       'logoUrl': logoUrl,
//       'district': district,
//       'upazila': upazila,
//       'description': description,
//       'createdAt': Timestamp.fromDate(createdAt),
//       'createdBy': createdBy,
//     };
//   }
//
//   // To Map
//   Map<String, dynamic> toMap() {
//     return {
//       'teamId': teamId,
//       'name': name,
//       'logoUrl': logoUrl,
//       'district': district,
//       'upazila': upazila,
//       'description': description,
//       'createdAt': createdAt.toIso8601String(),
//       'createdBy': createdBy,
//     };
//   }
//
//   // CopyWith method
//   TeamModel copyWith({
//     String? teamId,
//     String? name,
//     String? logoUrl,
//     String? district,
//     String? upazila,
//     String? description,
//     DateTime? createdAt,
//     String? createdBy,
//   }) {
//     return TeamModel(
//       teamId: teamId ?? this.teamId,
//       name: name ?? this.name,
//       logoUrl: logoUrl ?? this.logoUrl,
//       district: district ?? this.district,
//       upazila: upazila ?? this.upazila,
//       description: description ?? this.description,
//       createdAt: createdAt ?? this.createdAt,
//       createdBy: createdBy ?? this.createdBy,
//     );
//   }
//
//   @override
//   String toString() {
//     return 'TeamModel(teamId: $teamId, name: $name, logoUrl: $logoUrl, district: $district, upazila: $upazila)';
//   }
//
//   @override
//   bool operator ==(Object other) {
//     if (identical(this, other)) return true;
//
//     return other is TeamModel &&
//         other.teamId == teamId &&
//         other.name == name &&
//         other.logoUrl == logoUrl &&
//         other.district == district &&
//         other.upazila == upazila;
//   }
//
//   @override
//   int get hashCode {
//     return teamId.hashCode ^
//     name.hashCode ^
//     logoUrl.hashCode ^
//     district.hashCode ^
//     upazila.hashCode;
//   }
// }
import 'package:cloud_firestore/cloud_firestore.dart';

class TeamModel {
  final String id;  // ✅ REQUIRED
  final String name;
  final String? logoUrl;
  final String? description;
  final DateTime? createdAt;
  final List<String>? playerIds;

  TeamModel({
    required this.id,  // ✅ REQUIRED
    required this.name,
    this.logoUrl,
    this.description,
    this.createdAt,
    this.playerIds,
  });

  factory TeamModel.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

    return TeamModel(
      id: doc.id,  // ✅ From document ID
      name: data['name'] ?? '',
      logoUrl: data['logoUrl'],
      description: data['description'],
      createdAt: data['createdAt'] != null
          ? (data['createdAt'] as Timestamp).toDate()
          : null,
      playerIds: data['playerIds'] != null
          ? List<String>.from(data['playerIds'])
          : null,
    );
  }

  factory TeamModel.fromMap(Map<String, dynamic> data, String docId) {
    return TeamModel(
      id: docId,  // ✅ From parameter
      name: data['name'] ?? '',
      logoUrl: data['logoUrl'],
      description: data['description'],
      createdAt: data['createdAt'] != null
          ? (data['createdAt'] as Timestamp).toDate()
          : null,
      playerIds: data['playerIds'] != null
          ? List<String>.from(data['playerIds'])
          : null,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'name': name,
      if (logoUrl != null) 'logoUrl': logoUrl,
      if (description != null) 'description': description,
      if (createdAt != null) 'createdAt': Timestamp.fromDate(createdAt!),
      if (playerIds != null) 'playerIds': playerIds,
    };
  }

  TeamModel copyWith({
    String? id,
    String? name,
    String? logoUrl,
    String? description,
    DateTime? createdAt,
    List<String>? playerIds,
  }) {
    return TeamModel(
      id: id ?? this.id,
      name: name ?? this.name,
      logoUrl: logoUrl ?? this.logoUrl,
      description: description ?? this.description,
      createdAt: createdAt ?? this.createdAt,
      playerIds: playerIds ?? this.playerIds,
    );
  }
}