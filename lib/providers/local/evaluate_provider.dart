import 'package:flutter/material.dart';

class EvaluateProvider extends ChangeNotifier {
  // Feilds
  bool _isLoading = false;
  String? _error;

  // Services

  // Getters
  bool get isLoading => _isLoading;
  String? get error => _error;

  // Setters

  // Initialize
  EvaluateProvider() {
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
}
