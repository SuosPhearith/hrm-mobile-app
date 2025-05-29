import 'package:flutter/material.dart';
import 'package:mobile_app/models/response_structure_model.dart';
import 'package:mobile_app/services/personal_info/create_personalinfo_service.dart';

class UpdateEducationProvider extends ChangeNotifier {
  // Feilds
  bool _isLoading = false;
  String? _error;
  ResponseStructure<Map<String, dynamic>>? _dataSetup;
  ResponseStructure<Map<String, dynamic>>? _data;
  // Services
  final CreatePersonalService _createPersonalService = CreatePersonalService();

  // Getters
  bool get isLoading => _isLoading;
  String? get error => _error;
  ResponseStructure<Map<String, dynamic>>? get dataSetup => _dataSetup;
  ResponseStructure<Map<String, dynamic>>? get data => _data;
  // Setters

  // Initialize
  UpdateEducationProvider(
      {required String userId, required String educationId}) {
    getHome(userId: userId, educationId: educationId);
  }

  // Functions
  Future<void> getHome({String? educationId, String? userId}) async {
    _isLoading = true;
    notifyListeners();
    try {
      final resSetUp = await _createPersonalService.dataSetup();
      final res = await _createPersonalService.getUserEducationById(
          educationId: educationId!, userId: userId!);
      _dataSetup = resSetUp;

      _data = res;
    } catch (e) {
      _error = "Invalid Credential.";
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
