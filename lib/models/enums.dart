/// Rôles de la plateforme.
enum UserRole {
  client('client', 'Client'),
  vendeur('vendeur', 'Vendeur'),
  livreur('livreur', 'Livreur'),
  admin('admin', 'Administrateur');

  final String value;
  final String label;
  const UserRole(this.value, this.label);

  static UserRole fromString(String? v) =>
      UserRole.values.firstWhere((r) => r.value == v, orElse: () => UserRole.client);

  /// Route d'accueil de chaque rôle.
  String get homeRoute => '/$value';
}
