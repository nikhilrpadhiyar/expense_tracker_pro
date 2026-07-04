class Validators {
  Validators._();

  static String? email(String? value) {
    if (value == null || value.trim().isEmpty) return 'Email is required.';
    final RegExp regex = RegExp(r'^[\w-.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!regex.hasMatch(value.trim())) return 'Enter a valid email.';
    return null;
  }

  static String? password(String? value) {
    if (value == null || value.isEmpty) return 'Password is required.';
    if (value.length < 8) return 'Password must be at least 8 characters.';
    return null;
  }

  static String? required(String? value, {String field = 'This field'}) {
    if (value == null || value.trim().isEmpty) return '$field is required.';
    return null;
  }

  static String? amount(String? value) {
    if (value == null || value.trim().isEmpty) return 'Amount is required.';
    final double? parsed = double.tryParse(value.trim());
    if (parsed == null) return 'Enter a valid amount.';
    if (parsed <= 0) return 'Amount must be greater than zero.';
    return null;
  }
}
