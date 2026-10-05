class Validators {
  static String? required(String? v, [String champ = 'Ce champ']) =>
      (v == null || v.trim().isEmpty) ? '$champ est obligatoire' : null;

  static String? email(String? v) {
    if (v == null || v.trim().isEmpty) return "L'e-mail est obligatoire";
    final ok = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(v.trim());
    return ok ? null : 'E-mail invalide';
  }

  static String? password(String? v) {
    if (v == null || v.isEmpty) return 'Le mot de passe est obligatoire';
    if (v.length < 6) return 'Au moins 6 caractères';
    return null;
  }

  static String? phone(String? v) {
    if (v == null || v.trim().isEmpty) return 'Le téléphone est obligatoire';
    return RegExp(r'^[0-9+ ]{8,15}$').hasMatch(v.trim()) ? null : 'Numéro invalide';
  }
}
