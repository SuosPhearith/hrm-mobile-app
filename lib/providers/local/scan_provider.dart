import 'package:flutter/material.dart';
import 'package:mobile_app/models/response_structure_model.dart';
import 'package:mobile_app/services/scan_service.dart';

class ScanProvider extends ChangeNotifier {
  // Feilds
  bool _isLoading = false;
  String? _error;
  ResponseStructure<Map<String, dynamic>>? _scanListData;

  // Services

  // Getters
  bool get isLoading => _isLoading;
  String? get error => _error;
  ResponseStructure<Map<String, dynamic>>? get scanListData => _scanListData;

  // Setters
  final ScanService _scanService = ScanService();

  // Initialize
  ScanProvider() {
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
      final response = await _scanService.scanList(
        startDate: startDate,
        endDate: endDate,
        limit: limit,
        offset: offset,
      );
      _scanListData = response;
      _error = null;
    } catch (e) {
      _error = "Invalid Credential.";
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
