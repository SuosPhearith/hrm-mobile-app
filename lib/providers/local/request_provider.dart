import 'package:flutter/material.dart';
import 'package:mobile_app/models/pagination_structure_model.dart';
import 'package:mobile_app/models/response_structure_model.dart';
import 'package:mobile_app/services/request_service.dart';

class RequestProvider extends ChangeNotifier {
  // Feilds
  bool _isLoading = false;
  String? _error;
  ResponseStructure<PaginationStructure<Map<String, dynamic>>>? _requestData;

  // Services
  final RequestService _requestService = RequestService();

  // Getters
  bool get isLoading => _isLoading;
  String? get error => _error;
  ResponseStructure<PaginationStructure<Map<String, dynamic>>>?
      get requestData => _requestData;

  // Setters

  // Initialize
  RequestProvider() {
    getHome();
  }

  // Functions
  Future<void> getHome() async {
    _isLoading = true;
    notifyListeners();
    try {
      final response = await _requestService.request();
      _requestData = response;
    } catch (e) {
      _error = "Invalid Credential.";
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
