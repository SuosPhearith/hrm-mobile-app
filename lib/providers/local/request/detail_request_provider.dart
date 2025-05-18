import 'package:flutter/material.dart';
import 'package:mobile_app/models/response_structure_model.dart';
import 'package:mobile_app/services/request/detail_request_service.dart';

class DetailRequestProvider extends ChangeNotifier {
  // Feilds
  bool _isLoading = false;
  String? _error;
  ResponseStructure<Map<String, dynamic>>? _data;

  // Services
  final DetailRequestService _detailRequestService = DetailRequestService();

  // Getters
  bool get isLoading => _isLoading;
  String? get error => _error;
  ResponseStructure<Map<String, dynamic>>? get data => _data;

  // Setters

  // Initialize
  DetailRequestProvider({required String id}) {
    getHome(id: id);
  }

  // Functions
  Future<void> getHome({required String id}) async {
    _isLoading = true;
    notifyListeners();
    try {
      final res = await _detailRequestService.detail(id: id);
      _data = res;
    } catch (e) {
      _error = "Invalid Credential.";
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
