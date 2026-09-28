/// Form validators shared by the auth and address forms.
abstract final class Validators {
  static final RegExp _email = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');

  static String? email(String? value) {
    final v = value?.trim() ?? '';
    if (v.isEmpty) return 'Enter your email';
    if (!_email.hasMatch(v)) return 'Enter a valid email';
    return null;
  }

  static String? password(String? value) {
    final v = value ?? '';
    if (v.isEmpty) return 'Enter your password';
    if (v.length < 8) return 'Password must be at least 8 characters';
    return null;
  }

  static String? Function(String?) required(String label) => (value) {
        if ((value?.trim() ?? '').isEmpty) return 'Enter $label';
        return null;
      };

  static String? phone(String? value) {
    final v = value?.trim() ?? '';
    if (v.isEmpty) return null;
    if (v.replaceAll(RegExp(r'[\s\-()+]'), '').length < 7) return 'Enter a valid phone number';
    return null;
  }
}
