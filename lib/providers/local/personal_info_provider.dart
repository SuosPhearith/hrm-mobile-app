import 'package:flutter/material.dart';
import 'package:mobile_app/models/response_structure_model.dart';
import 'package:mobile_app/services/personal_info_service.dart';

class PersonalInfoProvider extends ChangeNotifier {
  // Feilds
  bool _isLoading = false;
  String? _error;
  ResponseStructure<Map<String, dynamic>>? _data;

  // Services
  final PersonalInfoService _personalInfoService = PersonalInfoService();

  // Getters
  bool get isLoading => _isLoading;
  String? get error => _error;
  ResponseStructure<Map<String, dynamic>>? get data => _data;

  // Setters

  // Initialize
  PersonalInfoProvider() {
    getHome();
  }

  // Functions
  Future<void> getHome() async {
    _isLoading = true;
    notifyListeners();
    try {
      final response = await _personalInfoService.userInfo();
      _data = response;
    } catch (e) {
      _error = "Invalid Credential.";
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
