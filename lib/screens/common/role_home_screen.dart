import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/enums.dart';
import '../../providers/auth_provider.dart';
import 'profile_screen.dart';

/// Page d'accueil provisoire de chaque rôle (Accueil + Profil).
/// Les modules métier viendront s'y brancher aux sprints suivants.
class RoleHomeScreen extends StatefulWidget {
  final UserRole role;
  const RoleHomeScreen({super.key, required this.role});

  @override
  State<RoleHomeScreen> createState() => _RoleHomeScreenState();
}

class _RoleHomeScreenState extends State<RoleHomeScreen> {
  int _index = 0;

  static const _icons = {
    UserRole.client: Icons.storefront,
    UserRole.vendeur: Icons.store,
    UserRole.livreur: Icons.delivery_dining,
    UserRole.admin: Icons.admin_panel_settings,
  };

  @override
  Widget build(BuildContext context) {
    final user = context.watch<AuthProvider>().user!;
    return Scaffold(
      appBar: AppBar(title: Text('Espace ${widget.role.label}')),
      body: IndexedStack(index: _index, children: [
        Center(
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            Icon(_icons[widget.role], size: 72, color: Theme.of(context).colorScheme.primary),
            const SizedBox(height: 12),
            Text('Bienvenue, ${user.nom}', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 4),
            Text('Connecté en tant que ${widget.role.label}'),
          ]),
        ),
        const ProfileScreen(),
      ]),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _index,
        onDestinationSelected: (i) => setState(() => _index = i),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.home), label: 'Accueil'),
          NavigationDestination(icon: Icon(Icons.person), label: 'Profil'),
        ],
      ),
    );
  }
}
