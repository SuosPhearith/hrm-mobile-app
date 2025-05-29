import 'package:flutter/material.dart';
import 'package:mobile_app/models/response_structure_model.dart';
import 'package:mobile_app/services/personal_info/create_personalinfo_service.dart';

class UpdateLanguageProvider extends ChangeNotifier {
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
  UpdateLanguageProvider(
      {required String userId, required String languageId}) {
    getHome(userId: userId, languageId: languageId);
  }

  // Functions
  Future<void> getHome({String? languageId, String? userId}) async {
    _isLoading = true;
    notifyListeners();
    try {
      final resSetUp = await _createPersonalService.dataSetup();
      final res = await _createPersonalService.getUserLanguageById(
          languageId: languageId!, userId: userId!);
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
