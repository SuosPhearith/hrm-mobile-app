import 'package:flutter/material.dart';
import 'package:mobile_app/models/pagination_structure_model.dart';
import 'package:mobile_app/models/response_structure_model.dart';
import 'package:mobile_app/services/daily_service.dart';

class DailyProvider extends ChangeNotifier {
  // Feilds
  bool _isLoading = false;
  String? _error;
  ResponseStructure<PaginationStructure<Map<String, dynamic>>>? _data;

  // Services
  final DailyService _dailyService = DailyService();

  // Getters
  bool get isLoading => _isLoading;
  String? get error => _error;
  ResponseStructure<PaginationStructure<Map<String, dynamic>>>? get data =>
      _data;

  // Setters

  // Initialize
  DailyProvider({String? startDate, String? endDate}) {
    getHome(startDate: startDate, endDate: endDate);
  }

  // Functions
  Future<void> getHome({String? startDate, String? endDate}) async {
    _isLoading = true;
    notifyListeners();
    try {
      final response =
          await _dailyService.daily(startDate: startDate, endDate: endDate);
      _data = response;
    } catch (e) {
      _error = "Invalid Credential.";
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
