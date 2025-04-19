import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SettingProvider extends ChangeNotifier {
  // Feilds
  bool _isLoading = false;
  String? _error;
  bool _isSelectingLanguage = false;
  String? _lang;

  // Services
  final FlutterSecureStorage _storage = FlutterSecureStorage();

  // Getters
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get isSelectingLanguage => _isSelectingLanguage;
  String? get lang => _lang;

  // Setters

  // Initialize
  SettingProvider() {
    getHome();
  }

  // Functions
  Future<void> getHome() async {
    _isLoading = true;
    notifyListeners();
    try {
      // Do anything
    } catch (e) {
      _error = "Invalid Credential.";
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> handleSetLanguage(String lang) async {
    await _storage.write(key: 'lang', value: lang);
    _lang = lang;
    _isSelectingLanguage = true;
    notifyListeners();
  }

  // Select Language
  Future<void> handleSelectLanguage() async {
    notifyListeners();
    String lang = await _storage.read(key: 'lang') ?? '';
    if (lang.isNotEmpty) {
      _isSelectingLanguage = true;
      notifyListeners();
      return;
    }
    _isSelectingLanguage = false;
    notifyListeners();
  }
}
