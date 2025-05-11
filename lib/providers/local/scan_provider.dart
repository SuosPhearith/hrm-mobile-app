import 'package:flutter/material.dart';
import 'package:mobile_app/models/pagination_structure_model.dart';
import 'package:mobile_app/models/response_structure_model.dart';
import 'package:mobile_app/services/scan_service.dart';

class ScanProvider extends ChangeNotifier {
  // Feilds
  bool _isLoading = false;
  String? _error;
  ResponseStructure<PaginationStructure<Map<String, dynamic>>>? _data;

  // Services
  final ScanService _scanService = ScanService();

  // Getters
  bool get isLoading => _isLoading;
  String? get error => _error;
  ResponseStructure<PaginationStructure<Map<String, dynamic>>>? get data =>
      _data;

  // Setters

  // Initialize
  ScanProvider({String? startDate, String? endDate}) {
    getHome(startDate: startDate, endDate: endDate);
  }

  // Functions
  Future<void> getHome({String? startDate, String? endDate}) async {
    _isLoading = true;
    notifyListeners();
    try {
      final response =
          await _scanService.scan(startDate: startDate, endDate: endDate);
      _data = response;
    } catch (e) {
      _error = "Invalid Credential.";
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
