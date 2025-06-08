import 'package:dio/dio.dart';
import 'package:mobile_app/utils/dio.client.dart';

class HolidayService {
  Future<Map<String, dynamic>> holidays() async {
    try {
      final response = await DioClient.dio.get("/user/holiday");
      if (response.data is Map<String, dynamic>) {
        return response.data as Map<String, dynamic>;
      } else {
        throw Exception('Response data is not a Map<String, dynamic>');
      }
    } on DioException catch (dioError) {
      rethrow;
    } catch (e) {
      rethrow;
    }
  }
}
