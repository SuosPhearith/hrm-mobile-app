import 'package:dio/dio.dart';
import 'package:mobile_app/error_type.dart';
import 'package:mobile_app/models/response_structure_model.dart';
import 'package:mobile_app/utils/dio.client.dart';
import 'package:mobile_app/utils/help_util.dart';

class UpdatePersonalInfoService {
  Future<ResponseStructure<Map<String, dynamic>>> dataSetup() async {
    try {
      final response = await DioClient.dio.get("/user/request/data-setup");
      return ResponseStructure<Map<String, dynamic>>.fromJson(
        response.data as Map<String, dynamic>,
        dataFromJson: (json) => json,
      );
    } on DioException catch (dioError) {
      if (dioError.response != null) {
        printError(
          errorMessage: ErrorType.requestError,
          statusCode: dioError.response!.statusCode,
        );
        throw Exception(ErrorType.requestError);
      } else {
        printError(errorMessage: ErrorType.networkError, statusCode: null);
        throw Exception(ErrorType.networkError);
      }
    } catch (e) {
      printError(errorMessage: 'Something went wrong.', statusCode: 500);
      throw Exception(ErrorType.unexpectedError);
    }
  }

  Future<ResponseStructure<Map<String, dynamic>>> viewUser(
  ) async {
    try {
      final response = await DioClient.dio.get("/account/profile");
      return ResponseStructure<Map<String, dynamic>>.fromJson(
        response.data as Map<String, dynamic>,
        dataFromJson: (json) => json,
      );
    } on DioException catch (dioError) {
      if (dioError.response != null) {
        printError(
          errorMessage: ErrorType.requestError,
          statusCode: dioError.response!.statusCode,
        );
        throw Exception(ErrorType.requestError);
      } else {
        printError(errorMessage: ErrorType.networkError, statusCode: null);
        throw Exception(ErrorType.networkError);
      }
    } catch (e) {
      printError(errorMessage: 'Something went wrong.', statusCode: 500);
      throw Exception(ErrorType.unexpectedError);
    }
  }

  Future<Map<String, dynamic>> updatePersonalInfo({
    required String userId,
    required String nameKh,
    required String nameEn,
    required String phoneCode,
    required String phoneNumber,
    required String? email,
    required String? dob,
    required String? identityCardNumber ,
    required int saluteId,
    required int sexId,
    required int? statusCode,
    required int organizationId,
    required int generalDepartmentId,
    required int? departmentId,
    required int officeId,
    required int positionId,
    required int staffTypeId,
    required int rankPositionId,

  }) async {
    try {
      final response = await DioClient.dio.put(
        "/account/profile/$userId",
        data: {
          "name_kh": nameKh,
          "name_en": nameEn,
          "phone_code": phoneCode,
          "phone_number":phoneNumber,
          "email":email,
          "dob":dob,
          "identity_card_number":identityCardNumber,
          "salute_id": saluteId,
          "sex_id": sexId,
          "status_code":statusCode,
          "organization_id":organizationId,
          "general_department_id":generalDepartmentId,
          "department_id":departmentId,
          "office_id":officeId,
          "position_id":positionId,
          "staff_type_id":staffTypeId,
          "rank_position_id":rankPositionId,
        },
      );
      return response.data;
    } on DioException catch (dioError) {
      if (dioError.response != null) {
        printError(
          errorMessage: ErrorType.requestError,
          statusCode: dioError.response!.statusCode,
        );
        throw Exception(ErrorType.requestError);
      } else {
        printError(errorMessage: ErrorType.networkError, statusCode: null);
        throw Exception(ErrorType.networkError);
      }
    } catch (e) {
      printError(errorMessage: 'Something went wrong. $e', statusCode: 500);
      throw Exception(ErrorType.unexpectedError);
    }
  }

  
}
