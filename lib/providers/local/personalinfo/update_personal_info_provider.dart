import 'package:flutter/material.dart';
import 'package:mobile_app/models/response_structure_model.dart';
import 'package:mobile_app/services/personal_info/update_personal_info_service.dart';


class UpdatePersonalInfoProvider extends ChangeNotifier {
  // Feilds
  bool _isLoading = false;
  String? _error;
  ResponseStructure<Map<String, dynamic>>? _data;
   ResponseStructure<Map<String, dynamic>>? _dataSetup;

  // Services
  final UpdatePersonalInfoService _service = UpdatePersonalInfoService();
  // Getters
  bool get isLoading => _isLoading;
  String? get error => _error;
  ResponseStructure<Map<String, dynamic>>? get data => _data;
  ResponseStructure<Map<String, dynamic>>? get dataSetup => _dataSetup;
  // Setters  

  // Initialize
  UpdatePersonalInfoProvider() {
    getHome();
  }

  // Functions
  Future<void> getHome() async {
    _isLoading = true;
    notifyListeners();
    try {
      // Do anything
      final res = await _service.viewUser();
      final resSetup = await _service.dataSetup();
      _dataSetup = resSetup;
      _data = res;
    } catch (e) {
      _error = "Invalid Credential.";
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}

