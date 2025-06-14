import 'package:dio/dio.dart';
import 'package:mobile_app/error_type.dart';
import 'package:mobile_app/models/pagination_structure_model.dart';
import 'package:mobile_app/models/response_structure_model.dart';
import 'package:mobile_app/utils/dio.client.dart';
import 'package:mobile_app/utils/help_util.dart';

class DetailRequestService {
  Future<ResponseStructure<Map<String, dynamic>>> detail(
      {required String id}) async {
    try {
      final response = await DioClient.dio.get("/user/request/$id");
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

  Future<ResponseStructure<PaginationStructure<Map<String, dynamic>>>> users(
      {String? key = ''}) async {
    try {
      final response = await DioClient.dio.get(
        "/shared/user?limit=50&offset=0&key=$key",
      );
      return ResponseStructure<
          PaginationStructure<Map<String, dynamic>>>.fromJson(
        response.data as Map<String, dynamic>,
        dataFromJson: (json) =>
            PaginationStructure<Map<String, dynamic>>.fromJson(
          json,
          resultFromJson: (item) => item,
        ),
      );
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

  Future<Map<String, dynamic>> assign({
    required String requestId,
    required String comment,
    required List<Map<String, int>> reviewers,
  }) async {
    // Validate reviewers array
    if (reviewers.isEmpty) {
      printError(
          errorMessage: 'Reviewers list cannot be empty', statusCode: null);
      throw Exception('Reviewers list cannot be empty');
    }
    for (var reviewer in reviewers) {
      if (!reviewer.containsKey('user_id') ||
          !reviewer.containsKey('flow_reviewer_type_id')) {
        printError(errorMessage: 'Invalid reviewer format', statusCode: null);
        throw Exception('Invalid reviewer format');
      }
    }

    try {
      final response = await DioClient.dio.post(
        "/user/request/$requestId/assign-reviewer",
        data: {
          "submit_action": "submit",
          "comment": comment,
          "reviewers": reviewers,
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

  Future<Map<String, dynamic>> downloadReport(
      {required String id}) async {
    try {
      final response = await DioClient.dio.get("/sup/request/$id/print");
      if (response.data is Map<String, dynamic>) {
        return response.data as Map<String, dynamic>;
      } else {
        throw Exception('Response data is not a Map<String, dynamic>');
      }
    } on DioException catch (_) {
      rethrow;
    } catch (e) {
      rethrow;
    }
  }
}
