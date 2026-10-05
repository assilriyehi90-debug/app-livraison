import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../models/enums.dart';
import '../providers/auth_provider.dart';
import '../screens/auth/forgot_password_screen.dart';
import '../screens/auth/login_screen.dart';
import '../screens/auth/register_screen.dart';
import '../screens/common/role_home_screen.dart';
import '../screens/common/splash_screen.dart';

const _publicRoutes = {'/login', '/register', '/forgot-password'};

GoRouter buildRouter(AuthProvider auth) {
  return GoRouter(
    initialLocation: '/splash',
    refreshListenable: auth,
    redirect: (context, state) {
      final loc = state.matchedLocation;

      if (auth.status == AuthStatus.initial) return loc == '/splash' ? null : '/splash';

      if (auth.status == AuthStatus.unauthenticated) {
        return _publicRoutes.contains(loc) ? null : '/login';
      }

      // Authentifié : redirection vers l'espace du rôle + garde d'accès.
      final role = auth.user!.role;
      final home = role.homeRoute;
      if (loc == '/splash' || _publicRoutes.contains(loc) || loc == '/') return home;

      // Un utilisateur ne peut accéder qu'à l'espace de SON rôle.
      for (final r in UserRole.values) {
        if (loc.startsWith(r.homeRoute) && r != role) return home;
      }
      return null;
    },
    routes: [
      GoRoute(path: '/splash', builder: (_, __) => const SplashScreen()),
      GoRoute(path: '/login', builder: (_, __) => const LoginScreen()),
      GoRoute(path: '/register', builder: (_, __) => const RegisterScreen()),
      GoRoute(path: '/forgot-password', builder: (_, __) => const ForgotPasswordScreen()),
      for (final r in UserRole.values)
        GoRoute(path: r.homeRoute, builder: (_, __) => RoleHomeScreen(role: r)),
    ],
    errorBuilder: (_, state) => Scaffold(body: Center(child: Text('Page introuvable : ${state.uri}'))),
  );
}
