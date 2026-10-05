import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/app_user.dart';

/// Accès à la collection Firestore `users` (profil + rôle).
class UserRepository {
  final FirebaseFirestore _db;
  UserRepository([FirebaseFirestore? db]) : _db = db ?? FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>> get _col => _db.collection('users');

  Future<AppUser?> getUser(String uid) async {
    final doc = await _col.doc(uid).get();
    if (!doc.exists) return null;
    return AppUser.fromMap(doc.id, doc.data()!);
  }

  Future<void> createUser(AppUser user) => _col.doc(user.id).set(user.toMap());

  Future<void> updateProfile(String uid, {required String nom, required String telephone}) =>
      _col.doc(uid).update({'nom': nom, 'telephone': telephone});
}
