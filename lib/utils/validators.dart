class Validators {
  static String? basic(String? value) {
    if (value == null || value.isEmpty) {
      return 'Cannot be empty ';
    }
    return null;
  }

  static String? mobile(String? value) {
    String patttern = r'(^(?:[+0]9)?[0-9]{10,12}$)';
    RegExp regExp = RegExp(patttern);
    if (value?.isEmpty ?? true) {
      return 'Please enter mobile number';
    } else if (!regExp.hasMatch(value ?? "")) {
      return 'Please enter valid mobile number';
    }
    return null;
  }

  static String? email(String? value) {
    String patttern =
        r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+";
    RegExp regExp = RegExp(patttern);
    if (value?.isEmpty ?? true) {
      return 'Please enter Email';
    } else if (!regExp.hasMatch(value ?? "")) {
      return 'Please enter valid Email';
    }
    return null;
  }
}
