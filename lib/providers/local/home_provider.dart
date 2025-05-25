import 'package:flutter/material.dart';
import 'package:mobile_app/models/pagination_structure_model.dart';
import 'package:mobile_app/models/response_structure_model.dart';
import 'package:mobile_app/services/home_service.dart';

class HomeProvider extends ChangeNotifier {
  // Feilds
  bool _isLoading = false;
  String? _error;

  Map<String, dynamic>? _name;
  String? _email;
  Map<String, dynamic>? _department;

  ResponseStructure<Map<String, dynamic>>? _scanByDayData;
  ResponseStructure<Map<String, dynamic>>? _scanByMonthData;
  ResponseStructure<PaginationStructure<Map<String, dynamic>>>? _requestData;

  // Services
  final HomeService _homeService = HomeService();

  // Getters
  bool get isLoading => _isLoading;
  String? get error => _error;

  Map<String, dynamic>? get name => _name;
  String? get email => _email;
  Map<String, dynamic>? get department => _department;

  ResponseStructure<Map<String, dynamic>>? get scanByDayData => _scanByDayData;
  ResponseStructure<Map<String, dynamic>>? get scanByMonthData =>
      _scanByMonthData;
  ResponseStructure<PaginationStructure<Map<String, dynamic>>>?
      get requestData => _requestData;

  // Setters

  // Initialize
  HomeProvider() {
    getHome();
  }

  // Functions
  Future<void> getHome() async {
    _isLoading = true;
    notifyListeners();
    try {
      // =================================================
      final response = await _homeService.scanByDay();
      _scanByDayData = response;
      // =================================================
      final response2 = await _homeService.scanByMonth();
      _scanByMonthData = response2;
      // =================================================
      final response3 = await _homeService.request();
      _requestData = response3;
    } catch (e) {
      _error = "Invalid Credential.";
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
