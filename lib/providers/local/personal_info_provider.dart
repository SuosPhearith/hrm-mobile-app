import 'package:flutter/material.dart';
import 'package:mobile_app/models/response_structure_model.dart';
import 'package:mobile_app/services/personal_info_service.dart';

class PersonalInfoProvider extends ChangeNotifier {
  // Feilds
  bool _isLoading = false;
  String? _error;
  ResponseStructure<Map<String, dynamic>>? _data;

  // Services
  final PersonalInfoService _personalInfoService = PersonalInfoService();

  // Getters
  bool get isLoading => _isLoading;
  String? get error => _error;
  ResponseStructure<Map<String, dynamic>>? get data => _data;

  // Setters
  void setNewLanguage(Map<String, dynamic> data) {
    // if (_data?.data != null && _data!.data['user']['user_languages'] is List) {
    //   // Cast to List and add the new education data
    //   List<dynamic> languages =
    //       _data?.data['user']['user_languages'] as List<dynamic>;
    //   languages.add(data);

    //   // Notify listeners about the change
    //   notifyListeners();
    // }
     if (_data?.data != null && _data!.data['user']['user_languages'] is List) {
      // Cast to List and add the new education data
      List<dynamic> educations = _data!.data['user']['user_languages'] as List<dynamic>;
      educations.add(data);
      
      // Notify listeners about the change
      notifyListeners();
    }
  }

  // Initialize
  PersonalInfoProvider() {
    getHome();
  }

  // Functions
  Future<void> getHome() async {
    _isLoading = true;
    notifyListeners();
    try {
      final response = await _personalInfoService.userInfo();
      _data = response;
    } catch (e) {
      _error = "Invalid Credential.";
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
