import 'package:flutter/material.dart';
import 'package:mobile_app/models/response_structure_model.dart';
import 'package:mobile_app/services/personal_info/update_personal_info_service.dart';


class UpdatePersonalInfoProvider extends ChangeNotifier {
  // Feilds
  bool _isLoading = false;
  String? _error;
  ResponseStructure<Map<String, dynamic>>? _data;

  // Services
  final UpdatePersonalInfoService _service = UpdatePersonalInfoService();
  // Getters
  bool get isLoading => _isLoading;
  String? get error => _error;
  ResponseStructure<Map<String, dynamic>>? get data => _data;

  // Setters

  // Initialize
  UpdatePersonalInfoProvider() {
    getHome();
  }

  // Functions
  Future<void> getHome() async {
    _isLoading = true;
    notifyListeners();
    try {
      // Do anything
      final res = await _service.viewUser();
      _data = res;
    } catch (e) {
      _error = "Invalid Credential.";
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}

// class UpdatePersonalInfoProvider extends ChangeNotifier {
//   bool _isLoading = false;
//   String? _error;


  // ResponseStructure<Map<String, dynamic>>? _data;
  // ResponseStructure<Map<String, dynamic>>? _viewUser;
  
//   //service
//   final UpdatePersonalInfoService _service = UpdatePersonalInfoService();

//   bool get isLoading => _isLoading;
//   String? get error => _error;


  // ResponseStructure<Map<String, dynamic>>? get data => _data;
//   ResponseStructure<Map<String, dynamic>>? get viewUser => _viewUser;

//   // Load data setup (positions, departments, etc.)
//   Future<void> getHome() async {
//     _isLoading = true;
//     notifyListeners();
//     try {
//       final res = await _service.dataSetup();
//       _data = res;
//       _error = null;
//     } catch (e) {
//       _error = "Invalid Credential.";
//     } finally {
//       _isLoading = false;
//       notifyListeners();
//     }
//   }

//   Future<void> viewUserToUpdate(String? userId) async {
//     _isLoading = true;
//     notifyListeners();
//     try {
//       final response = await _service.viewUser();
//       _viewUser = response;
//       _error = null;
//     } catch (e) {
//       _error = "Failed to load user profile.";
//       _viewUser = null;
//     } finally {
//       _isLoading = false;
//       notifyListeners();
//     }
//   }

//   Future<void> updatePersonalInfo({
//     required String userId,
//     required String nameKh,
//     required String nameEn,
//     required String phoneCode,
//     required String phoneNumber,
//     required String? email,
//     required String? dob,
//     required String? identityCardNumber,
//     required int saluteId,
//     required int sexId,
//     required int? statusCode,
//     required int organizationId,
//     required int generalDepartmentId,
//     required int? departmentId,
//     required int officeId,
//     required int positionId,
//     required int staffTypeId,
//     required int rankPositionId,
//   }) async {
//     _isLoading = true;
//     notifyListeners();
//     try {
//       await _service.updatePersonalInfo(
//         userId: userId,
//         nameKh: nameKh,
//         nameEn: nameEn,
//         phoneCode: phoneCode,
//         phoneNumber: phoneNumber,
//         email: email,
//         dob: dob,
//         identityCardNumber: identityCardNumber,
//         saluteId: saluteId,
//         sexId: sexId,
//         statusCode: statusCode,
//         organizationId: organizationId,
//         generalDepartmentId: generalDepartmentId,
//         departmentId: departmentId,
//         officeId: officeId,
//         positionId: positionId,
//         staffTypeId: staffTypeId,
//         rankPositionId: rankPositionId,
//       );
//       _error = null;
//     } catch (e) {
//       _error = "Failed to update info.";
//     } finally {
//       _isLoading = false;
//       notifyListeners();
//     }
//   }
// }
