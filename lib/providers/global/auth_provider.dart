import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:mobile_app/services/auth_service.dart';

class AuthProvider extends ChangeNotifier {
  // Feilds
  bool _isLoading = false;
  String? _error;
  bool _isLoggedIn = false;
  bool _isChecking = false;
  bool _isSelectingLanguage = false;

  // Services
  final FlutterSecureStorage _storage = FlutterSecureStorage();
  final AuthService _authService = AuthService();

  // Getters
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get isLoggedIn => _isLoggedIn;
  bool get isChecking => _isChecking;
  bool get isSelectingLanguage => _isSelectingLanguage;

  // Setters

  // Initialize
  AuthProvider() {
    handleCheckAuth();
    handleSelectLanguage();
  }
  // Login
  Future<void> handleLogin(
      {required String username, required String password}) async {
    _isLoading = true;
    notifyListeners();
    try {
      Map<String, dynamic> data =
          await _authService.login(username: username, password: password);
      await saveAuthData(data);
      _isLoggedIn = true;
    } catch (e) {
      _error = "Invalid Credential.";
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Logout
  Future<void> handleLogout() async {
    _isLoggedIn = false;
    _isSelectingLanguage = false;
    _storage.delete(key: 'token');
    _storage.delete(key: 'lang');
    notifyListeners();
  }

  // Check Auth
  Future<void> handleCheckAuth() async {
    try {
      _isChecking = true;
      notifyListeners();
      _isLoggedIn = await _validateToken();
    } catch (e) {
      _isLoggedIn = false;
    } finally {
      _isChecking = false;
      notifyListeners();
    }
  }

  Future<bool> _validateToken() async {
    // Verrify token in here
    try {
      await _authService.checkAuth();
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<void> saveAuthData(Map<String, dynamic> data) async {
    try {
      await _storage.write(key: 'token', value: data['accessToken'] ?? '');
      await _storage.write(key: 'username', value: data['username'] ?? '');
      await _storage.write(key: 'email', value: data['email'] ?? '');
      await _storage.write(key: 'image', value: data['image'] ?? '');
    } catch (e) {
      rethrow;
    }
  }

  // Select Language
  Future<void> handleSelectLanguage() async {
    _isChecking = true;
    notifyListeners();
    String lang = await _storage.read(key: 'lang') ?? '';
    if (lang.isNotEmpty) {
      _isSelectingLanguage = true;
      notifyListeners();
      return;
    }
    _isSelectingLanguage = false;
    _isChecking = false;
    notifyListeners();
  }

  Future<void> handleSetLanguage(String lang) async {
    await _storage.write(key: 'lang', value: lang);
    _isSelectingLanguage = true;
    notifyListeners();
  }
}
