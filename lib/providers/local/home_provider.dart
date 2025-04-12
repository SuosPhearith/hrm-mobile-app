import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:mobile_app/models/pagination_structure_model.dart';
import 'package:mobile_app/models/response_structure_model.dart';
import 'package:mobile_app/services/home_service.dart';

class HomeProvider extends ChangeNotifier {
  // Feilds
  bool _isLoading = false;
  String? _error;

  String? _name;
  String? _email;
  String? _department;

  ResponseStructure<Map<String, dynamic>>? _scanByDayData;
  ResponseStructure<Map<String, dynamic>>? _scanByMonthData;
  ResponseStructure<PaginationStructure<Map<String, dynamic>>>? _requestData;

  // Services
  final HomeService _homeService = HomeService();

  // Getters
  bool get isLoading => _isLoading;
  String? get error => _error;

  String? get name => _name;
  String? get email => _email;
  String? get department => _department;

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
      final storage = FlutterSecureStorage();
      final String loadedName = await storage.read(key: 'name_kh') ?? '';
      final String loadedEmail = await storage.read(key: 'avatar') ?? '';
      final String loadedDepart = await storage.read(key: 'department') ?? '';
      _name = loadedName;
      _email = loadedEmail;
      _department = loadedDepart;
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
