import 'package:firebase_auth/firebase_auth.dart';

/// Encapsule Firebase Authentication.
class AuthService {
  final FirebaseAuth _auth;
  AuthService([FirebaseAuth? auth]) : _auth = auth ?? FirebaseAuth.instance;

  Stream<User?> get authStateChanges => _auth.authStateChanges();
  User? get currentUser => _auth.currentUser;

  Future<UserCredential> signIn(String email, String password) =>
      _auth.signInWithEmailAndPassword(email: email.trim(), password: password);

  Future<UserCredential> register(String email, String password) =>
      _auth.createUserWithEmailAndPassword(email: email.trim(), password: password);

  Future<void> signOut() => _auth.signOut();

  Future<void> sendPasswordReset(String email) => _auth.sendPasswordResetEmail(email: email.trim());

  /// Message d'erreur lisible en français.
  static String messageFor(Object e) {
    if (e is FirebaseAuthException) {
      switch (e.code) {
        case 'invalid-email':
          return 'Adresse e-mail invalide.';
        case 'user-not-found':
        case 'wrong-password':
        case 'invalid-credential':
          return 'E-mail ou mot de passe incorrect.';
        case 'user-disabled':
          return 'Ce compte a été désactivé.';
        case 'email-already-in-use':
          return 'Cette adresse e-mail est déjà utilisée.';
        case 'weak-password':
          return 'Mot de passe trop faible (6 caractères minimum).';
        case 'network-request-failed':
          return 'Problème de connexion réseau.';
        case 'too-many-requests':
          return 'Trop de tentatives. Réessayez plus tard.';
      }
      return e.message ?? "Erreur d'authentification.";
    }
    return 'Une erreur est survenue.';
  }
}
