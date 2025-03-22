import 'package:dio/dio.dart';
import 'package:mobile_app/error_type.dart';
import 'package:mobile_app/utils/dio.client.dart';
import 'package:mobile_app/utils/help_util.dart';

class AuthService {
  Future<Map<String, dynamic>> login({
    required String username,
    required String password,
  }) async {
    try {
      final response = await DioClient.dio.post(
        "/auth/login",
        data: {"username": username, "password": password},
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

  Future<Map<String, dynamic>> checkAuth() async {
    try {
      final response = await DioClient.dio.get(
        "/auth/me",
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
