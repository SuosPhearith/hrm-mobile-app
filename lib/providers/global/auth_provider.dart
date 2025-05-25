import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:mobile_app/models/response_structure_model.dart';
import 'package:mobile_app/utils/help_util.dart';

class AuthProvider extends ChangeNotifier {
  // Feilds
  String? _error;
  bool _isLoggedIn = false;
  bool _isChecking = false;
  ResponseStructure<Map<String, dynamic>>? _profile;

  // Services
  final FlutterSecureStorage _storage = FlutterSecureStorage();
  final dio = Dio();

  // Getters
  String? get error => _error;
  bool get isLoggedIn => _isLoggedIn;
  bool get isChecking => _isChecking;
  ResponseStructure<Map<String, dynamic>>? get profile => _profile;

  // Setters
  void setIsChecking(bool value) {
    _isChecking = value;
    notifyListeners();
  }

  void setIsLoggedIn(bool value) {
    _isLoggedIn = value;
    notifyListeners();
  }

  void setSaveToken(
      bool value, ResponseStructure<Map<String, dynamic>> data) async {
    await _storage.write(
        key: 'access_token',
        value: getSafeString(value: data.data['access_token']));
    await _storage.write(
        key: 'refresh_token',
        value: getSafeString(value: data.data['refresh_token']));
    _isLoggedIn = true;
    notifyListeners();
  }

  // Initialize
  AuthProvider() {
    handleCheckAuth();
  }

  // Logout
  Future<void> handleLogout() async {
    _isLoggedIn = false;
    _storage.delete(key: 'access_token');
    notifyListeners();
  }

  // Check Auth
  Future<bool> handleCheckAuth() async {
    try {
      _isChecking = true;
      notifyListeners();

      String token = await _storage.read(key: 'access_token') ?? '';
      if (token.isEmpty) {
        _isLoggedIn = false;
        return false;
      }

      String apiUrl = dotenv.get('API_URL',
          fallback: 'https://hrm-api.dev.camcyber.com/api/v1');
      final response = await dio.get(
        '$apiUrl/account/profile',
        options: Options(
          headers: {'Authorization': 'Bearer $token'},
        ),
      );

      final profile = ResponseStructure<Map<String, dynamic>>.fromJson(
        response.data as Map<String, dynamic>,
        dataFromJson: (json) => json,
      );

      if (response.statusCode == 200 && response.data != null) {
        _profile = profile;
        _isLoggedIn = true;
        return true;
      } else {
        _isLoggedIn = false;
        return false;
      }
    } catch (e) {
      _isLoggedIn = false;
      return false;
    } finally {
      _isChecking = false;
      notifyListeners();
    }
  }
}
