import 'package:dio/dio.dart';
import 'package:mobile_app/error_type.dart';
import 'package:mobile_app/models/response_structure_model.dart';
import 'package:mobile_app/utils/dio.client.dart';
import 'package:mobile_app/utils/help_util.dart';

class EvaluationService {
  Future<ResponseStructure<Map<String, dynamic>>> evaluationList({
  int? limit,
  int? offset,
  String? startDate,
  String? endDate,
}) async {
  // Provide fallback default values if parameters are null
  final queryParams = {
    'limit': limit ?? 50,
    'offset': offset ?? 0,
    'start_date': startDate ?? '2025-03-01',
    'end_date': endDate ?? '2025-05-30',
  };

  try {
    final response = await DioClient.dio.get(
      "/user/home/evaluation",
      queryParameters: queryParams,
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

}
