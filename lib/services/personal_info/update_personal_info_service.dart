import 'package:dio/dio.dart';
import 'package:mobile_app/error_type.dart';
import 'package:mobile_app/models/response_structure_model.dart';
import 'package:mobile_app/utils/dio.client.dart';
import 'package:mobile_app/utils/help_util.dart';

class UpdatePersonalInfoService {
  Future<ResponseStructure<Map<String, dynamic>>> dataSetup() async {
    try {
      final response = await DioClient.dio.get("/shared/setup?models=salute");
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

  Future<ResponseStructure<Map<String, dynamic>>> viewUser() async {
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
    required String? password,
    required String? dob,
    required String? identityCardNumber,
    required int? avatarId,
    required String? saluteId,
    required String sexId,
    required String? homeNumber,
    required String? streetNumber,
    required String? villageCode,
    required String? communeCode,
    required String? districtCode,
    required String? provinceCode,
    required String? pobVillageCode,
    required String? pobCommuneCode,
    required String? pobDistrictCode,
    required String? pobProvinceCode,
    required int? statusCode,
    required int? organizationId,
    required int? officeId,
    required int? positionId,
    required int? rankPositionId,
  }) async {
    try {
      final response = await DioClient.dio.put(
        "/user/personal_information/update/$userId",
        data: {
          "name_kh": nameKh,
          "name_en": nameEn,
          "phone_code": phoneCode,
          "phone_number": phoneNumber,
          "email": email,
          "password": password,
          "dob": dob,
          "identity_card_number": identityCardNumber,
          "avatar_id": avatarId,
          "salute_id": saluteId,
          "sex_id": sexId,
          "home_number": homeNumber,
          "street_number": streetNumber,
          "village_code": villageCode,
          "commune_code": communeCode,
          "district_code": districtCode,
          "province_code": provinceCode,
          "pob_village_code": pobVillageCode,
          "pob_commune_code": pobCommuneCode,
          "pob_district_code": pobDistrictCode,
          "pob_province_code": pobProvinceCode,
          "status_code": statusCode,
          "organization_id": organizationId,
          "office_id": officeId,
          "position_id": positionId,
          "rank_position_id": rankPositionId,
        },
      );
      return response.data;
    } on DioException catch (_) {
      rethrow;
    } catch (e) {
      rethrow;
    }
  }
}
