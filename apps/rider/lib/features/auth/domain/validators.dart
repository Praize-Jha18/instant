/// Pure form validators (unit-tested; also drive the widget tests).
abstract final class Validators {
  static final RegExp _email = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');
  static final RegExp _phone = RegExp(r'^\+?[0-9]{7,15}$');

  static String? email(String? value) {
    final v = value?.trim() ?? '';
    if (v.isEmpty) return 'Email is required';
    if (!_email.hasMatch(v)) return 'Enter a valid email address';
    return null;
  }

  /// Contract §3: min 8 characters.
  static String? password(String? value) {
    final v = value ?? '';
    if (v.isEmpty) return 'Password is required';
    if (v.length < 8) return 'Password must be at least 8 characters';
    return null;
  }

  static String? fullName(String? value) {
    final v = value?.trim() ?? '';
    if (v.isEmpty) return 'Full name is required';
    if (v.length < 2) return 'Enter your full name';
    return null;
  }

  static String? phone(String? value) {
    final v = value?.replaceAll(RegExp(r'[\s\-()]'), '') ?? '';
    if (v.isEmpty) return null; // optional
    if (!_phone.hasMatch(v)) return 'Enter a valid phone number';
    return null;
  }

  static String? required(String? value, {String label = 'This field'}) {
    if ((value?.trim() ?? '').isEmpty) return '$label is required';
    return null;
  }

  /// 4–8 digits.
  static String? otp(String? value) {
    final v = value?.trim() ?? '';
    if (v.isEmpty) return 'Enter the code from the customer';
    if (!RegExp(r'^[0-9]{4,8}$').hasMatch(v)) return 'The code should be 4 to 8 digits';
    return null;
  }
}
