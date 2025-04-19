import 'package:dio/dio.dart';
import 'package:mobile_app/error_type.dart';
import 'package:mobile_app/models/pagination_structure_model.dart';
import 'package:mobile_app/models/response_structure_model.dart';
import 'package:mobile_app/utils/dio.client.dart';
import 'package:mobile_app/utils/help_util.dart';

class HomeService {
  Future<ResponseStructure<Map<String, dynamic>>> scanByDay() async {
    try {
      final response = await DioClient.dio.get(
        "/user/home/scan-day",
      );
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

  Future<ResponseStructure<Map<String, dynamic>>> scanByMonth() async {
    try {
      final response = await DioClient.dio.get(
        "/user/home/scan-month",
      );
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

  Future<ResponseStructure<PaginationStructure<Map<String, dynamic>>>>
      request() async {
    try {
      final response = await DioClient.dio.get(
        "/user/home/request?limit=50",
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
}
