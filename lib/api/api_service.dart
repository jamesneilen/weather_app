import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class ApiService {
  final String apiKey = dotenv.env['API_KEY'] ?? '';

  Future<void> loadApiKey() async {
    await dotenv.load(fileName: ".env");
  }

  Future<List<dynamic>> fetchData() async {
    final response = await http.get(
      Uri.parse("http://api.openweathermap.org/"),
      headers: {"Authorization": "Bearer $apiKey"},
    );
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception("Failed to fetch data");
    }
  }
}
