import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'core/app_router.dart';
import 'core/app_theme.dart';
import 'firebase_options.dart';
import 'providers/auth_provider.dart';
import 'repositories/user_repository.dart';
import 'services/auth_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const LivraisonApp());
}

class LivraisonApp extends StatefulWidget {
  const LivraisonApp({super.key});

  @override
  State<LivraisonApp> createState() => _LivraisonAppState();
}

class _LivraisonAppState extends State<LivraisonApp> {
  late final AuthProvider _auth = AuthProvider(AuthService(), UserRepository());
  late final _router = buildRouter(_auth);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<AuthProvider>.value(
      value: _auth,
      child: MaterialApp.router(
        title: 'Livraison',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.light,
        routerConfig: _router,
      ),
    );
  }
}
