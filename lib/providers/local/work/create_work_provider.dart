import 'package:flutter/material.dart';
import 'package:mobile_app/models/response_structure_model.dart';

import 'package:mobile_app/services/work/create_work_service.dart';


class CreateWorkProvider extends ChangeNotifier {
  // Feilds
  bool _isLoading = false;
  String? _error;
  ResponseStructure<Map<String, dynamic>>? _dataSetup;

  // Services
    final CreateWorkService _service = CreateWorkService();

  // Getters
  bool get isLoading => _isLoading;
  String? get error => _error;
  ResponseStructure<Map<String, dynamic>>? get dataSetup => _dataSetup;

  // Setters

  // Initialize
  CreateWorkProvider() {
    getHome();
  }

  // Functions
  Future<void> getHome() async {
    _isLoading = true;
    notifyListeners();
    try {
      final res = await _service.dataSetup();
      _dataSetup = res;
    } catch (e) {
      _error = "Invalid Credential.";
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
