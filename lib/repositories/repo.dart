import '../api/api_client.dart';
import '../api/api_endpoints.dart';
import '../models/weather_model.dart';

class WeatherRepository {
  final ApiClient _apiClient = ApiClient();

  Future<Weather> fetchWeather(String city) async {
    final response = await _apiClient.get(
      ApiEndpoints.currentWeather,
      params: {"q": city},
    );
    return Weather.fromJson(response.data);
  }
}
