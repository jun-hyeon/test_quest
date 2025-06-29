class Validator {
  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return '이메일을 입력해주세요';
    }
    final emailRegex =
        RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
    if (!emailRegex.hasMatch(value)) {
      return '올바른 이메일 형식이 아닙니다';
    }
    if (value.contains(' ')) {
      return '이메일에 공백이 포함되어 있습니다';
    }
    return null;
  }

  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return '비밀번호를 입력해주세요';
    }
    if (value.length < 6) {
      return '비밀번호는 최소 6자 이상이어야 합니다';
    }
    if (value.contains(' ')) {
      return '비밀번호에 공백이 포함되어 있습니다';
    }
    // if (!RegExp(r'[A-Z]').hasMatch(value)) {
    //   return '비밀번호에는 최소 하나의 대문자가 포함되어야 합니다';
    // }
    // if (!RegExp(r'[a-z]').hasMatch(value)) {
    //   return '비밀번호에는 최소 하나의 소문자가 포함되어야 합니다';
    // }
    // if (!RegExp(r'[0-9]').hasMatch(value)) {
    //   return '비밀번호에는 최소 하나의 숫자가 포함되어야 합니다';
    // }
    // if (!RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(value)) {
    //   return '비밀번호에는 최소 하나의 특수 문자가 포함되어야 합니다';
    // }
    return null;
  }

  static String? validateConfirmPassword(String? value, String password) {
    if (value == null || value.isEmpty) {
      return '비밀번호 확인을 입력해주세요';
    }
    if (value != password) {
      return '비밀번호가 일치하지 않습니다';
    }
    if (value.contains(' ')) {
      return '비밀번호 확인에 공백이 포함되어 있습니다';
    }
    return null;
  }

  static String? validateNickname(String? value) {
    if (value == null || value.isEmpty) {
      return '닉네임을 입력해주세요';
    }
    if (value.length < 2 || value.length > 20) {
      return '닉네임은 2자 이상 20자 이하이어야 합니다';
    }
    if (value.contains(' ')) {
      return '닉네임에 공백이 포함되어 있습니다';
    }
    return null;
  }

  static String? validateName(String? value) {
    if (value == null || value.isEmpty) {
      return '이름을 입력해주세요';
    }
    if (value.length < 2 || value.length > 20) {
      return '이름은 2자 이상 20자 이하이어야 합니다';
    }
    if (value.contains(' ')) {
      return '이름에 공백이 포함되어 있습니다';
    }
    return null;
  }
}
