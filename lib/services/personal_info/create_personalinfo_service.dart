import 'package:dio/dio.dart';
import 'package:mobile_app/error_type.dart';
import 'package:mobile_app/models/response_structure_model.dart';
import 'package:mobile_app/utils/dio.client.dart';
import 'package:mobile_app/utils/help_util.dart';

class CreatePersonalService {
  Future<ResponseStructure<Map<String, dynamic>>> dataSetup() async {
    try {
      final response = await DioClient.dio.get(
          "/shared/setup?models=family_role,education_type,certificate_type,language,language_level,major,school,province,education_level");
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

  Future<Map<String, dynamic>> createUserFamily({
    required String userId,
    required String nameKh,
    required String nameEn,
    required String sexId,
    required String? dob,
    required String? familyRoleId,
    required String? job,
    required String? workPlace,
    String? note,
  }) async {
    try {
      final response = await DioClient.dio.post(
        "/account/profile/$userId/user_family",
        data: {
          "name_kh": nameKh,
          "name_en": nameEn,
          "sex_id": sexId,
          "dob": dob,
          "family_role_id": familyRoleId,
          "job": job,
          "work_place": workPlace,
          "note_": note,
        },
      );

      return response.data;
    } on DioException catch (_) {
      rethrow;
    } catch (e) {
      rethrow;
    }
  }

  //create education for personal info
  Future<Map<String, dynamic>> createUserEducation({
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
          "major_id": majorId,
          "school_id": schoolId,
          "education_place_id": educationPlaceId,
          "study_at": studyAt,
          "graduate_at": graduateAt,
          "note": note,
          // "attachment_id":attachmentId,
        },
      );
      return response.data;
    } on DioException catch (_) {
      rethrow;
    } catch (e) {
      rethrow;
    }
  }

  //create langauge for personal info
  Future<Map<String, dynamic>> createUserLanguage({
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
          "language_id": int.tryParse(languageId) ?? 0,
          "speaking_level_id": int.tryParse(speakingLevelId) ?? 0,
          "writing_level_id": int.tryParse(writingLevelId) ?? 0,
          "listening_level_id": int.tryParse(listeningLevelId) ?? 0,
          "reading_level_id": int.tryParse(readingLevelId) ?? 0,
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
