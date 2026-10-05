import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/validators.dart';
import '../../providers/auth_provider.dart';

/// Profil commun à tous les rôles : consultation, modification, déconnexion.
class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nom;
  late final TextEditingController _tel;

  @override
  void initState() {
    super.initState();
    final u = context.read<AuthProvider>().user!;
    _nom = TextEditingController(text: u.nom);
    _tel = TextEditingController(text: u.telephone);
  }

  @override
  void dispose() {
    _nom.dispose();
    _tel.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    final ok = await context.read<AuthProvider>().updateProfile(_nom.text, _tel.text);
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(ok ? 'Profil mis à jour' : (context.read<AuthProvider>().error ?? 'Erreur'))),
    );
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final u = auth.user!;
    return ListView(
      padding: const EdgeInsets.all(24),
      children: [
        const CircleAvatar(radius: 40, child: Icon(Icons.person, size: 40)),
        const SizedBox(height: 12),
        Center(child: Chip(label: Text(u.role.label))),
        const SizedBox(height: 8),
        Center(child: Text(u.email)),
        const SizedBox(height: 24),
        Form(
          key: _formKey,
          child: Column(children: [
            TextFormField(
              controller: _nom,
              decoration: const InputDecoration(labelText: 'Nom'),
              validator: (v) => Validators.required(v, 'Le nom'),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _tel,
              keyboardType: TextInputType.phone,
              decoration: const InputDecoration(labelText: 'Téléphone'),
              validator: Validators.phone,
            ),
          ]),
        ),
        const SizedBox(height: 20),
        FilledButton(onPressed: auth.loading ? null : _save, child: const Text('Enregistrer')),
        const SizedBox(height: 12),
        OutlinedButton.icon(
          onPressed: () => context.read<AuthProvider>().logout(),
          icon: const Icon(Icons.logout),
          label: const Text('Se déconnecter'),
        ),
      ],
    );
  }
}
