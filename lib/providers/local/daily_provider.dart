import 'package:flutter/material.dart';
import 'package:mobile_app/models/response_structure_model.dart';
import 'package:mobile_app/services/daily_service.dart';

class DailyProvider extends ChangeNotifier {
  // Feilds
  bool _isLoading = false;
  String? _error;
  ResponseStructure<Map<String, dynamic>>? _dailyProviderListData;

  // Services

  // Getters
  bool get isLoading => _isLoading;
  String? get error => _error;
  ResponseStructure<Map<String, dynamic>>? get dailyProviderListData => _dailyProviderListData;

  // Setters
  final DailyService _dailyService = DailyService();

  // Initialize
  DailyProvider() {
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
      final response = await _dailyService.deilyList(
        startDate: startDate,
        endDate: endDate,
        limit: limit,
        offset: offset,
      );
      _dailyProviderListData = response;
      _error = null;
    } catch (e) {
      _error = "Invalid Credential.";
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
