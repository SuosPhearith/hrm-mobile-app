import 'package:flutter/material.dart';
import 'package:mobile_app/models/response_structure_model.dart';
import 'package:mobile_app/services/personal_info/create_personalinfo_service.dart';

class CreateRelativeProvider extends ChangeNotifier {
  // Feilds
  bool _isLoading = false;
  String? _error;
  // ResponseStructure<Map<String, dynamic>>? _data;
    ResponseStructure<Map<String, dynamic>>? _dataSetup;
  // Services
  final CreatePersonalService _createPersonalService = CreatePersonalService();

  // Getters
  bool get isLoading => _isLoading;
  String? get error => _error;
  // ResponseStructure<Map<String, dynamic>>? get data => _data;
  ResponseStructure<Map<String, dynamic>>? get dataSetup => _dataSetup;
  // Setters

  // Initialize
 CreateRelativeProvider() {
    getHome();
  }

  // Functions
  Future<void> getHome() async {
    _isLoading = true;
    notifyListeners();
    try {
      final res = await _createPersonalService.dataSetup();
      _dataSetup = res;
      // _data = res;
    } catch (e) {
      _error = "Invalid Credential.";
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
