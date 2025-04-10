class AuthService {
  String? _userId;
  String? get userId => _userId;

  void setUser(String userId) {
    _userId = userId;
  }
}
