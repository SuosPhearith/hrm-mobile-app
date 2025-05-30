import 'package:dio/dio.dart';
import 'package:mobile_app/error_type.dart';
import 'package:mobile_app/models/response_structure_model.dart';
import 'package:mobile_app/utils/dio.client.dart';
import 'package:mobile_app/utils/help_util.dart';

class CreateWorkService {
  Future<ResponseStructure<Map<String, dynamic>>> dataSetup() async {
    try {
      final response = await DioClient.dio.get(
          "/shared/setup?models=position,department,medal_type,medal");
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

  Future<Map<String, dynamic>> createUserWorkHistory({
    required String userId,
    required String organizatioId,
    required String departmentId,
    required String? generalDepartmentId,
    required String? officeId,
    required String? positionId,
    required String? rankPositionId,
    required String? startWorkingAt,
    required String? stopWorkingAt,

  }) async {
    try {
      final response = await DioClient.dio.post(
        "/account/profile/$userId/user_work_history",
        data: {
          "organization_id": organizatioId,
          "department_id": departmentId,
          "general_department_id": generalDepartmentId,
          "office_id": officeId,
          "position_id": positionId,
          "rank_position_id": rankPositionId,
          "start_working_at": startWorkingAt,
          "stop_working_at": stopWorkingAt,
          "staff_type_id":1,
        },
      );

      return response.data;
    } on DioException catch (_) {
      rethrow;
    } catch (e) {
      rethrow;
    }
  }

  //create user medal
  Future<Map<String, dynamic>> createUserMedal({
    required String userId,
    required String medalTypeId,
    required String medalId,
    required String? givenAt,
    required String? note,

  }) async {
    try {
      final response = await DioClient.dio.post(
        "/account/profile/$userId/user_medal",
        data: {
          "medal_type_id": medalTypeId,
          "medal_id": medalId,
          "given_at": givenAt,
          "note_": note,
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

  //get user work history by id
  Future<ResponseStructure<Map<String, dynamic>>> getUserWorkHistoryById({
    required String workId,
    required String userId
  }) async {
    try {
      final response =
          await DioClient.dio.get("/account/profile/$userId/user_work_history/$workId");
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
  //get user medal by id
  Future<ResponseStructure<Map<String, dynamic>>> getUserMedalById({
    required String medalId,
    required String userId
  }) async {
    try {
      final response =
          await DioClient.dio.get("/account/profile/$userId/user_medal/$medalId");
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

  //update user medal
  Future<Map<String, dynamic>> updateUserMedal({
    required String userId,
    required String userMedalId,
    required String medalTypeId,
    required String medalId,
    required String? givenAt,
    required String? note,

  }) async {
    try {
      final response = await DioClient.dio.put(
        "/account/profile/$userId/user_medal/$userMedalId",
        data: {
          "medal_type_id": medalTypeId,
          "medal_id": medalId,
          "given_at": givenAt,
          "note_": note,
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

  //update work history
  Future<Map<String, dynamic>> updateUserWorkHistory({
    required String userId,
    required String workId,
    required String organizatioId,
    required String departmentId,
    required String? generalDepartmentId,
    required String? officeId,
    required String? positionId,
    required String? rankPositionId,
    required String? startWorkingAt,
    required String? stopWorkingAt,

  }) async {
    try {
      final response = await DioClient.dio.put(
        "/account/profile/$userId/user_work_history/$workId",
        data: {
          "organization_id": organizatioId,
          "department_id": departmentId,
          "general_department_id": generalDepartmentId,
          "office_id": officeId,
          "position_id": positionId,
          "rank_position_id": rankPositionId,
          "start_working_at": startWorkingAt.toString(),
          "stop_working_at": stopWorkingAt.toString(),
          "staff_type_id":1,
        },
      );

      return response.data;
    } on DioException catch (_) {
      rethrow;
    } catch (e) {
      rethrow;
    }
  }

  //get user work history by id
  Future<ResponseStructure<Map<String, dynamic>>> getUserWorkById({
    required String workId,
    required String userId
  }) async {
    try {
      final response =
          await DioClient.dio.get("/account/profile/$userId/user_work/$workId");
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
  //update work 
Future<Map<String, dynamic>> updateUserWork({
  required String userId,
  required String workId,
  required String idNumber,
  required String staffCardNumber,
  required String? staffTypeId,
  required String organizationId,
  required String departmentId,
  required String? generalDepartmentId,
  required String? officeId,
  required String? positionId,
  required String? rankPositionId,
  required String? startWorkingAt,
  required String? appointedAt,
  required String? frameworkCategoryId,
  required String? salaryRankTypeId,
  required String? salaryRankGroupId,
  required String? certificateTypeId,
  required String? majorId,
  required String? upgradedSalaryRankAt,
  required String? graduatedAt,
  required String? prakasNumber,
  required String? prakasAt,
  required String? note,
  required String? attachmentId,
  required int sort,
}) async {
  try {
    final response = await DioClient.dio.put(
      "/account/profile/$userId/user_work/$workId",
      data: {
        "id_number": idNumber,
        "staff_card_number": staffCardNumber,
        "organization_id": organizationId,
        "department_id": departmentId,
        "general_department_id": generalDepartmentId,
        "office_id": officeId,
        "position_id": positionId,
        "rank_position_id": rankPositionId,
        "start_working_at": startWorkingAt?.toString(),
        "staff_type_id": staffTypeId,
        "appointed_at": appointedAt?.toString(),
        "framework_category_id": frameworkCategoryId,
        "salary_rank_type_id": salaryRankTypeId,
        "salary_rank_group_id": salaryRankGroupId,
        "certificate_type_id": certificateTypeId,
        "major_id": majorId,
        "upgraded_salary_rank_at": upgradedSalaryRankAt?.toString(),
        "graduated_at": graduatedAt?.toString(),
        "prakas_number": prakasNumber,
        "prakas_at": prakasAt?.toString(),
        "note_": note,
        "attachment_id": attachmentId,
        "sort": sort,
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
