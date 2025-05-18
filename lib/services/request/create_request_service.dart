import 'package:dio/dio.dart';
import 'package:mobile_app/error_type.dart';
import 'package:mobile_app/models/response_structure_model.dart';
import 'package:mobile_app/utils/dio.client.dart';
import 'package:mobile_app/utils/help_util.dart';

class CreateRequestService {
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

  Future<Map<String, dynamic>> createRequest({
    required String startDate,
    required String endDate,
    required String? objective,
    required int requestTypeId,
    required int requestCategoryId,
    required String attachment,
  }) async {
    try {
      final response = await DioClient.dio.post(
        "/user/request",
        data: {
          "start_date": startDate,
          "end_date": endDate,
          "objective": objective ?? '', // opt
          "request_type_id": requestTypeId,
          "request_category_id": requestCategoryId,
          "attachment": '',
          // "attachment": 'data:application/image;base64,$attachment',
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
