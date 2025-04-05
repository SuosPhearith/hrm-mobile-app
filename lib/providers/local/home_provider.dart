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
    getProfile();
    getScanByDay();
    getScanByMonth();
    getRequest();
  }

  // Functions
  Future<void> getProfile() async {
    _isLoading = true;
    notifyListeners();
    try {
      final storage = FlutterSecureStorage();
      final String loadedName = await storage.read(key: 'name_kh') ?? '';
      final String loadedEmail = await storage.read(key: 'avatar') ?? '';
      final String loadedDepart = await storage.read(key: 'department') ?? '';
      _name = loadedName;
      _email = loadedEmail;
      _department = loadedDepart;
    } catch (e) {
      _error = "Invalid Credential.";
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> getScanByDay() async {
    _isLoading = true;
    notifyListeners();
    try {
      final response = await _homeService.scanByDay();
      _scanByDayData = response;
    } on Exception catch (e) {
      _error = e.toString();
    } catch (e) {
      _error = "Invalid Credential.";
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> getScanByMonth() async {
    _isLoading = true;
    notifyListeners();
    try {
      final response = await _homeService.scanByMonth();
      _scanByMonthData = response;
    } on Exception catch (e) {
      _error = e.toString();
    } catch (e) {
      _error = "Invalid Credential.";
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> getRequest() async {
    _isLoading = true;
    notifyListeners();
    try {
      final response = await _homeService.request();
      _requestData = response;
    } on Exception catch (e) {
      _error = e.toString();
    } catch (e) {
      _error = "Invalid Credential.";
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
