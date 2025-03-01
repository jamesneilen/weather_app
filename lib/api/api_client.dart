import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class ApiClient {
  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: "https://api.openweathermap.org/data/2.5/",
      connectTimeout: Duration(seconds: 10),
      receiveTimeout: Duration(seconds: 10),
    ),
  );

  Future<Response> get(String endpoint, {Map<String, dynamic>? params}) async {
    try {
      params ??= {};
      params["appid"] = dotenv.env['OPEN_WEATHER_API_KEY']; // Load API key
      params["units"] = "metric"; // Default to Celsius

      final response = await _dio.get(endpoint, queryParameters: params);
      return response;
    } on DioException catch (e) {
      throw Exception("API Error: ${e.response?.statusMessage ?? e.message}");
    }
  }
}
