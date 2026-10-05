import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../core/validators.dart';
import '../../providers/auth_provider.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nom = TextEditingController();
  final _email = TextEditingController();
  final _tel = TextEditingController();
  final _password = TextEditingController();
  final _confirm = TextEditingController();

  @override
  void dispose() {
    for (final c in [_nom, _email, _tel, _password, _confirm]) {
      c.dispose();
    }
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    final ok = await context.read<AuthProvider>().register(
          nom: _nom.text,
          email: _email.text,
          telephone: _tel.text,
          password: _password.text,
        );
    if (ok && mounted) context.go('/client');
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    return Scaffold(
      appBar: AppBar(title: const Text('Créer un compte')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _nom,
                decoration: const InputDecoration(labelText: 'Nom complet', prefixIcon: Icon(Icons.person_outline)),
                validator: (v) => Validators.required(v, 'Le nom'),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _email,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(labelText: 'E-mail', prefixIcon: Icon(Icons.email_outlined)),
                validator: Validators.email,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _tel,
                keyboardType: TextInputType.phone,
                decoration: const InputDecoration(labelText: 'Téléphone', prefixIcon: Icon(Icons.phone_outlined)),
                validator: Validators.phone,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _password,
                obscureText: true,
                decoration: const InputDecoration(labelText: 'Mot de passe', prefixIcon: Icon(Icons.lock_outline)),
                validator: Validators.password,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _confirm,
                obscureText: true,
                decoration: const InputDecoration(labelText: 'Confirmer le mot de passe', prefixIcon: Icon(Icons.lock_outline)),
                validator: (v) => v != _password.text ? 'Les mots de passe ne correspondent pas' : null,
              ),
              if (auth.error != null) ...[
                const SizedBox(height: 12),
                Text(auth.error!, style: TextStyle(color: Theme.of(context).colorScheme.error)),
              ],
              const SizedBox(height: 20),
              FilledButton(
                onPressed: auth.loading ? null : _submit,
                child: auth.loading
                    ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(strokeWidth: 2))
                    : const Text("S'inscrire"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
