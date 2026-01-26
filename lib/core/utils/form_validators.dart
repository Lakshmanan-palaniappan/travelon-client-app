class FormValidators {
  static String? requiredField(String? value, String label) {
    if (value == null || value.isEmpty) {
      return 'Please enter $label';
    }
    return null;
  }

  static String? email(String? value) {
    
    if (value == null || value.isEmpty) return 'Please enter your email';
    final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
    if (!emailRegex.hasMatch(value)) return 'Enter a valid email';
    return null;
  }

  static String? password(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your password';
    }

    // Minimum 8 characters
    if (value.length < 8) {
      return 'Password must be at least 8 characters long';
    }

    // At least one uppercase letter
    if (!RegExp(r'[A-Z]').hasMatch(value)) {
      return 'Password must contain at least one uppercase letter';
    }

    // At least one number
    if (!RegExp(r'[0-9]').hasMatch(value)) {
      return 'Password must contain at least one number';
    }

    // At least one special character
    if (!RegExp(r'[!@#\$&*~^%()\-_+=<>?/.,;:{}|]').hasMatch(value)) {
      return 'Password must contain at least one special character';
    }

    return null;
  }

  static String? confirmPassword(String? value, String original) {
    if (value == null || value.isEmpty) return 'Please confirm your password';
    if (value != original) return 'Passwords do not match';
    return null;
  }

  static String? name(String? value, {String label = 'name'}) {
  if (value == null || value.trim().isEmpty) {
    return 'Please enter your $label';
  }

  final trimmedValue = value.trim();

  // Minimum length
  if (trimmedValue.length < 2) {
    return '${label[0].toUpperCase()}${label.substring(1)} must be at least 2 characters';
  }

  // Allow only letters and spaces
  final nameRegex = RegExp(r'^[A-Za-z ]+$');
  if (!nameRegex.hasMatch(trimmedValue)) {
    return '$label can only contain letters and spaces';
  }

  return null;
}

static String? phone(String? value, {String label = 'contact number'}) {
  if (value == null || value.isEmpty) {
    return 'Please enter $label';
  }

  if (!RegExp(r'^[0-9]{10}$').hasMatch(value)) {
    return 'Enter a valid 10-digit $label';
  }

  return null;
}


}
