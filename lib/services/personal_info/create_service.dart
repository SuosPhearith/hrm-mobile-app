import 'package:dio/dio.dart';
import 'package:mobile_app/error_type.dart';
import 'package:mobile_app/models/response_structure_model.dart';
import 'package:mobile_app/utils/dio.client.dart';
import 'package:mobile_app/utils/help_util.dart';

class CreatePersonalService {

  Future<ResponseStructure<Map<String, dynamic>>> dataSetup() async {
    try {
      final response = await DioClient.dio.get("/shared/setup?models=family_role");
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

  Future<String> createUserFamily({
    required String userId,
    required String nameKh,
    required String nameEn,
    required String sexId,
    required String? dob,
    required String? familyRoleId,
    required String? job,
    required String? workPlace,
    required String? note,
  }) async {
    try {
      final response = await DioClient.dio.post(
        "/account/profile/$userId/user_family",
        data: {
          "name_kh": nameKh,
          "name_en": nameEn,
          "sex_id": sexId,
          "dob":dob,
          "family_role_id":familyRoleId,
          "job":job,
          "work_place":workPlace,
          "note":note,
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
        printError(
          errorMessage: ErrorType.networkError,
          statusCode: null,
        );
        throw Exception(ErrorType.networkError);
      }
    } catch (e) {
      printError(errorMessage: 'Something went wrong.', statusCode: 500);
      throw Exception(ErrorType.unexpectedError);
    }
  }
  //create education for personal info
  Future<String> createUserEducation({
    required String userId,
    required String educationTypeId,
    required String educationLevelId,
    required String certificateTypeId,
    required String? majorId,
    required String? schoolId,
    required String? educationPlaceId,
    required String? studyAt,
    required String? graduateAt,
    required String? note,
    required String? attachmentId,
  }) async {
    try {
      final response = await DioClient.dio.post(
        "/account/profile/$userId/user_education",
        data: {
          "education_type_id": educationTypeId,
          "education_level_id": educationLevelId,
          "certificate_type_id": certificateTypeId,
          "major_id":majorId,
          "school_id":schoolId,
          "education_place_id":educationPlaceId,
          "study_at":studyAt,
          "graduate_at":graduateAt,
          "note":note,
          "attachment_id":attachmentId,
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
        printError(
          errorMessage: ErrorType.networkError,
          statusCode: null,
        );
        throw Exception(ErrorType.networkError);
      }
    } catch (e) {
      printError(errorMessage: 'Something went wrong.', statusCode: 500);
      throw Exception(ErrorType.unexpectedError);
    }
  }

  //create langauge for personal info
  Future<String> createUserLanguage({
    required String userId,
    required String languageId,
    required String speakingLevelId,
    required String writingLevelId,
    required String listeningLevelId,
    required String readingLevelId,
  }) async {
    try {
      final response = await DioClient.dio.post(
        "/account/profile/$userId/user_language",
        data: {
          "language_id": languageId,
          "speaking_level_id": speakingLevelId,
          "writing_level_id": writingLevelId,
          "listening_level_id":listeningLevelId,
          "reading_level_id":readingLevelId,
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
        printError(
          errorMessage: ErrorType.networkError,
          statusCode: null,
        );
        throw Exception(ErrorType.networkError);
      }
    } catch (e) {
      printError(errorMessage: 'Something went wrong.', statusCode: 500);
      throw Exception(ErrorType.unexpectedError);
    }
  }
}
