import 'package:flutter/material.dart';
import 'package:mobile_app/models/response_structure_model.dart';
import 'package:mobile_app/services/evaluate_service.dart';


class EvaluationProvider extends ChangeNotifier {
  // Feilds
  bool _isLoading = false;
  String? _error;
  ResponseStructure<Map<String, dynamic>>? _evaluationListData;


  // Getters
  bool get isLoading => _isLoading;
  String? get error => _error;
  ResponseStructure<Map<String, dynamic>>? get evaluationListData => _evaluationListData;

  // Services
  final EvaluationService _evaluationService = EvaluationService();

  // Initialize
  EvaluationProvider() {
    getHome();
  }

   // Functions
  Future<void> getHome({
    String? startDate,
    String? endDate,
    int limit = 10,
    int offset = 0,
  }) async {
    _isLoading = true;
    notifyListeners();

    try {
      final response = await  _evaluationService.evaluationList(
        startDate: startDate,
        endDate: endDate,
        limit: limit,
        offset: offset,
      );
     _evaluationListData = response;
      _error = null;
    } catch (e) {
      _error = "Invalid Credential.";
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }


}
