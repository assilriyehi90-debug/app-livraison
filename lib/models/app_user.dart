import 'package:cloud_firestore/cloud_firestore.dart';
import 'enums.dart';

class AppUser {
  final String id;
  final String nom;
  final String email;
  final String telephone;
  final UserRole role;
  final bool actif;
  final String? photoUrl;
  final DateTime dateCreation;

  const AppUser({
    required this.id,
    required this.nom,
    required this.email,
    required this.telephone,
    required this.role,
    required this.actif,
    required this.dateCreation,
    this.photoUrl,
  });

  factory AppUser.fromMap(String id, Map<String, dynamic> m) => AppUser(
        id: id,
        nom: (m['nom'] ?? '') as String,
        email: (m['email'] ?? '') as String,
        telephone: (m['telephone'] ?? '') as String,
        role: UserRole.fromString(m['role'] as String?),
        actif: (m['actif'] ?? true) as bool,
        photoUrl: m['photoUrl'] as String?,
        dateCreation: (m['dateCreation'] as Timestamp?)?.toDate() ?? DateTime.now(),
      );

  Map<String, dynamic> toMap() => {
        'nom': nom,
        'email': email,
        'telephone': telephone,
        'role': role.value,
        'actif': actif,
        'photoUrl': photoUrl,
        'dateCreation': Timestamp.fromDate(dateCreation),
      };

  AppUser copyWith({String? nom, String? telephone, bool? actif, String? photoUrl}) => AppUser(
        id: id,
        nom: nom ?? this.nom,
        email: email,
        telephone: telephone ?? this.telephone,
        role: role,
        actif: actif ?? this.actif,
        photoUrl: photoUrl ?? this.photoUrl,
        dateCreation: dateCreation,
      );
}
