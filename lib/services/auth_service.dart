import 'package:dio/dio.dart';
import 'package:mobile_app/models/response_structure_model.dart';
import 'package:mobile_app/utils/dio.client.dart';
import 'package:mobile_app/utils/help_util.dart';

class AuthService {
  Future<ResponseStructure<Map<String, dynamic>>> login({
    required String username,
    required String password,
  }) async {
    try {
      final response = await DioClient.dio.post(
        "/account/auth/login-password",
        data: {"credential": username, "password": password},
      );
      return ResponseStructure<Map<String, dynamic>>.fromJson(
        response.data as Map<String, dynamic>,
        dataFromJson: (json) => json,
      );
    } on DioException catch (_) {
      rethrow;
    } catch (e) {
      printError(errorMessage: 'Something went wrong.', statusCode: 500);
      rethrow;
    }
  }
}
