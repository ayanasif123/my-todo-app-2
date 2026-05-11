class AuthHelper {
  static String? _email;
  static String? _password;

  static void register(String email, String pass) {
    _email = email;
    _password = pass;
  }

  static bool login(String email, String pass) {
    return _email == email && _password == pass;
  }

  static bool isLoggedIn() => _email != null;
}