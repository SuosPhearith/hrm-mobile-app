import 'package:flutter/material.dart';
import 'package:mobile_app/models/response_structure_model.dart';
import 'package:mobile_app/services/work/create_work_service.dart';

class UpdateWorkHistoryProvider extends ChangeNotifier {
  // Feilds
  bool _isLoading = false;
  String? _error;
  ResponseStructure<Map<String, dynamic>>? _dataSetup;
  ResponseStructure<Map<String, dynamic>>? _data;
  // Services
  final CreateWorkService _service = CreateWorkService();

  // Getters
  bool get isLoading => _isLoading;
  String? get error => _error;
  ResponseStructure<Map<String, dynamic>>? get dataSetup => _dataSetup;
  ResponseStructure<Map<String, dynamic>>? get data => _data;
  // Setters

  // Initialize
  UpdateWorkHistoryProvider(
      {required String userId, required String workId}) {
    getHome(userId: userId, workId: workId);
  }

  // Functions
  Future<void> getHome({String? workId, String? userId}) async {
    _isLoading = true;
    notifyListeners();
    try {
      final resSetUp = await _service.dataSetup();
      final res = await _service.getUserWorkHistoryById(
          workId: workId!, userId: userId!);
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
