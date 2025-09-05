class AuthService {
  static final AuthService _instance = AuthService._internal();
  factory AuthService() => _instance;
  AuthService._internal();

  bool _isLoggedIn = false;
  String? _currentUser;

  // Tài khoản mẫu có sẵn
  static const String _demoEmail = 'demo@datingapp.com';
  static const String _demoPassword = '123456';
  static const String _demoName = 'Nguyễn Văn Demo';

  bool get isLoggedIn => _isLoggedIn;
  String? get currentUser => _currentUser;

  Future<bool> signIn(String email, String password) async {
    // Simulate API call
    await Future.delayed(const Duration(seconds: 1));
    
    // Kiểm tra tài khoản demo
    if (email == _demoEmail && password == _demoPassword) {
      _isLoggedIn = true;
      _currentUser = _demoName;
      return true;
    }
    
    // Hoặc bất kỳ email/password nào khác
    if (email.isNotEmpty && password.isNotEmpty) {
      _isLoggedIn = true;
      _currentUser = email;
      return true;
    }
    return false;
  }

  Future<bool> signUp(String email, String password) async {
    // Simulate API call
    await Future.delayed(const Duration(seconds: 1));
    
    if (email.isNotEmpty && password.isNotEmpty) {
      _isLoggedIn = true;
      _currentUser = email;
      return true;
    }
    return false;
  }

  Future<void> signOut() async {
    await Future.delayed(const Duration(milliseconds: 500));
    _isLoggedIn = false;
    _currentUser = null;
  }
}
