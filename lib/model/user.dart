class User {
  String userId = "";
  String userName = "";
  String phoneNumber = "";
  String gender = "";
  int age = 0;
  String file = "";

  static final User _singleton = User._internal();

  factory User() {
    return _singleton;
  }

  User._internal();
}
