import 'package:flutter/material.dart';
import 'package:mobile_app/models/pagination_structure_model.dart';
import 'package:mobile_app/models/response_structure_model.dart';
import 'package:mobile_app/services/request/create_request_service.dart';
import 'package:mobile_app/services/request/detail_request_service.dart';

class DetailRequestProvider extends ChangeNotifier {
  // Feilds
  bool _isLoading = false;
  String? _error;
  ResponseStructure<Map<String, dynamic>>? _data;
  ResponseStructure<Map<String, dynamic>>? _dataSetup;
  ResponseStructure<PaginationStructure<Map<String, dynamic>>>? _users;

  // Services
  final DetailRequestService _detailRequestService = DetailRequestService();
  final CreateRequestService _createRequestService = CreateRequestService();

  // Getters
  bool get isLoading => _isLoading;
  String? get error => _error;
  ResponseStructure<Map<String, dynamic>>? get data => _data;
  ResponseStructure<Map<String, dynamic>>? get dataSetup => _dataSetup;
  ResponseStructure<PaginationStructure<Map<String, dynamic>>>? get users =>
      _users;

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
      final resSetup = await _createRequestService.dataSetup();
      _dataSetup = resSetup;
      final resUser = await _detailRequestService.users();
      _users = resUser;
    } catch (e) {
      _error = "Invalid Credential.";
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
