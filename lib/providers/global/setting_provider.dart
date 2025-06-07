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
      handleSelectLanguage();
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

  Future<void> handleSelectLanguage() async {
    notifyListeners();
    String lang = '';
    try {
      String? langValue = await _storage.read(key: 'lang');
      lang = langValue ?? '';
    } catch (e) {
      await _storage.delete(key: 'lang');
      lang = '';
    }

    if (lang.isNotEmpty) {
      _isSelectingLanguage = true;
    } else {
      _isSelectingLanguage = false;
    }

    notifyListeners();
  }
}
