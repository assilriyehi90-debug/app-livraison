import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import '../models/app_user.dart';
import '../models/enums.dart';
import '../repositories/user_repository.dart';
import '../services/auth_service.dart';

enum AuthStatus { initial, unauthenticated, authenticated }

class AuthProvider extends ChangeNotifier {
  final AuthService _auth;
  final UserRepository _users;
  StreamSubscription<User?>? _sub;

  AuthStatus status = AuthStatus.initial;
  AppUser? user;
  bool loading = false;
  String? error;

  AuthProvider(this._auth, this._users) {
    _sub = _auth.authStateChanges.listen(_onAuthChanged);
  }

  Future<void> _onAuthChanged(User? fu) async {
    if (fu == null) {
      user = null;
      status = AuthStatus.unauthenticated;
      notifyListeners();
      return;
    }
    try {
      final profile = await _users.getUser(fu.uid);
      if (profile == null) {
        // Compte Auth sans profil Firestore (ex. inscription en cours) : on attend.
        if (status == AuthStatus.initial) {
          status = AuthStatus.unauthenticated;
          notifyListeners();
        }
        return;
      }
      if (!profile.actif) {
        error = 'Ce compte a été désactivé par un administrateur.';
        await _auth.signOut();
        return;
      }
      user = profile;
      status = AuthStatus.authenticated;
    } catch (_) {
      error = 'Impossible de charger le profil.';
      status = AuthStatus.unauthenticated;
    }
    notifyListeners();
  }

  Future<bool> login(String email, String password) => _run(() async {
        await _auth.signIn(email, password);
      });

  /// Inscription publique : toujours le rôle Client (règle de gestion RG1).
  Future<bool> register({
    required String nom,
    required String email,
    required String telephone,
    required String password,
  }) =>
      _run(() async {
        final cred = await _auth.register(email, password);
        final newUser = AppUser(
          id: cred.user!.uid,
          nom: nom.trim(),
          email: email.trim(),
          telephone: telephone.trim(),
          role: UserRole.client,
          actif: true,
          dateCreation: DateTime.now(),
        );
        await _users.createUser(newUser);
        user = newUser;
        status = AuthStatus.authenticated;
      });

  Future<bool> resetPassword(String email) => _run(() => _auth.sendPasswordReset(email));

  Future<void> logout() async {
    await _auth.signOut();
  }

  Future<bool> updateProfile(String nom, String telephone) => _run(() async {
        await _users.updateProfile(user!.id, nom: nom.trim(), telephone: telephone.trim());
        user = user!.copyWith(nom: nom.trim(), telephone: telephone.trim());
      });

  void clearError() {
    error = null;
    notifyListeners();
  }

  Future<bool> _run(Future<void> Function() action) async {
    loading = true;
    error = null;
    notifyListeners();
    try {
      await action();
      return true;
    } catch (e) {
      error = AuthService.messageFor(e);
      return false;
    } finally {
      loading = false;
      notifyListeners();
    }
  }

  @override
  void dispose() {
    _sub?.cancel();
    super.dispose();
  }
}
