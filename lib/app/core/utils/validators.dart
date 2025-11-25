class Validator {
  static String? rule(String? value, {bool required = false}) {
    if (required && value!.isEmpty) {
      return "form ini wajib diisi";
    }
    return null;
  }

  static String? required(dynamic value, {String? fieldName}) {
    if (value == null) {
      return "form ini wajib diisi";
    }

    if (value is String || value == null) {
      if (value.toString() == "null") return "form ini wajib diisi";
      if (value.isEmpty) return "form ini wajib diisi";
    }

    if (value is List) {
      if (value.isEmpty) return "form ini wajib diisi";
    }
    return null;
  }

  static String? email(String? value) {
    if (value!.isEmpty) return "masukkan email";

    final bool isValidEmail = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,6}$',
    ).hasMatch(value);

    if (!isValidEmail) {
      return "format email tidak valid";
    }
    return null;
  }

  static String? password(String? value) {
    if (value!.isEmpty) {
      return "masukkan password";
    } else if (value.length < 8) {
      return "kata sandi harus 8 karakter atau lebih";
    }
    return null;
  }

  static String? number(String? value) {
    if (value!.isEmpty) return "form ini wajib diisi";

    final bool isNumber = RegExp(r"^[0-9]+$").hasMatch(value);
    if (!isNumber) {
      return "This field is not in a valid number format";
    }
    return null;
  }

  static String? atLeastOneitem(List<Map<String, dynamic>> items) {
    var checkedItems = items.where((i) => i["checked"] == true).toList();
    if (checkedItems.isEmpty) {
      return "you must choose at least one item";
    }
    return null;
  }

  static String? passwordConfirmation(String text, String? value) {
    if (value!.isEmpty) {
      return "masukkan password";
    } else if (value.length < 8) {
      return "kata sandi harus 8 karakter atau lebih";
    }
    return null;
  }
}
