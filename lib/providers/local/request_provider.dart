import 'package:flutter/material.dart';
import 'package:mobile_app/models/pagination_structure_model.dart';
import 'package:mobile_app/models/response_structure_model.dart';
import 'package:mobile_app/services/request/create_request_service.dart';
import 'package:mobile_app/services/request_service.dart';

class RequestProvider extends ChangeNotifier {
  // Feilds
  bool _isLoading = false;
  String? _error;
  ResponseStructure<PaginationStructure<Map<String, dynamic>>>? _requestData;
  ResponseStructure<Map<String, dynamic>>? _dataSetup;

  // Services
  final RequestService _requestService = RequestService();
  final CreateRequestService _createRequestService = CreateRequestService();

  // Getters
  bool get isLoading => _isLoading;
  String? get error => _error;
  ResponseStructure<PaginationStructure<Map<String, dynamic>>>?
      get requestData => _requestData;
  ResponseStructure<Map<String, dynamic>>? get dataSetup => _dataSetup;

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
      final res = await _createRequestService.dataSetup();
      _dataSetup = res;
      _requestData = response;
    } catch (e) {
      _error = "Invalid Credential.";
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
