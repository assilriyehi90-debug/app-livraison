# Livraison – Module Authentification (Groupe 7)

Flutter · Firebase Authentication · Cloud Firestore · Provider · go_router

## Fonctionnalités (section 1 du sujet)
- Créer un compte (e-mail + mot de passe) – rôle **Client** par défaut
- Se connecter / se déconnecter
- Réinitialiser le mot de passe (e-mail Firebase)
- Consulter et modifier son profil (nom, téléphone)
- 4 rôles : Client, Vendeur, Livreur, Administrateur → redirection automatique vers l'espace du rôle
- Garde de routes : un utilisateur ne peut pas ouvrir l'espace d'un autre rôle
- Compte désactivé (`actif = false`) → connexion refusée
- Validation des formulaires, messages d'erreur en français, session persistante
- Règles de sécurité Firestore (`firestore.rules`)

## Installation
1. `flutter create . --org com.groupe7 --project-name livraison_app` (génère android/ios)
2. Projet Firebase : activer **Authentication > E-mail/Mot de passe** et **Cloud Firestore**
3. `dart pub global activate flutterfire_cli` puis `flutterfire configure` (remplace `lib/firebase_options.dart`)
4. `flutter pub get`
5. Copier `firestore.rules` dans Firestore > Règles
6. `flutter run`

## Comptes Vendeur / Livreur / Admin (pour les tests)
L'inscription crée toujours un Client. Pour tester les autres rôles :
1. Console Firebase > Authentication > Ajouter un utilisateur
2. Firestore > collection `users` > document dont l'ID = l'UID du compte, champs :
   `nom`, `email`, `telephone` (string) · `role` = `vendeur` | `livreur` | `admin` (string) · `actif` = true (bool) · `dateCreation` (timestamp)

(La création de vendeurs/livreurs depuis l'application relève du module « Gestion de l'administrateur ».)

## Structure
```
lib/
  core/          app_theme, app_router (redirection + garde de rôle), validators
  models/        enums (UserRole), app_user
  services/      auth_service (Firebase Auth)
  repositories/  user_repository (Firestore : users)
  providers/     auth_provider (état de session, login, register, reset, profil)
  screens/
    auth/        login, register, forgot_password
    common/      splash, profile, role_home_screen
```
