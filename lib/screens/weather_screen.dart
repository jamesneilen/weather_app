import 'dart:convert';
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'package:weather_app/api/api_client.dart';
import 'package:weather_app/models/weather_model.dart';
import '../api/api_key.dart';

class WeatherScreen extends StatefulWidget {
  const WeatherScreen({super.key});

  @override
  _WeatherScreenState createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  String? _errorMessage = '';
  List<String> cities = [
    "Douala",
    "Yaounde",
    "Bamenda",
    "Bafoussam",
    "Garoua",
    "Buea",
    "Ngaundere",
    "Maroua",
    "Ebolowa",
    "Bertoua",
  ];
  final TextEditingController _cityController = TextEditingController();
  final ApiClient _apiClient = ApiClient();
  List<Weather> weatherData = [];

  @override
  void initState() {
    super.initState();
    //log("Fetching weather for Bamenda...");
    log("Fetching weather for Bamenda...");
    fetchWeatherData("Bamenda");
  }

  Future<void> fetchWeatherData(String city) async {
    log("fetchWeatherData called with city: $city");
    log(
      "requesting: https://api.openweathermap.org/data/2.5/weather?q=$city&appid=${ApiKey.openWeatherKey}&units=metric",
    );
    if (!cities.contains(city)) {
      setState(() {
        _errorMessage = 'City not a capital of any region in Cameroon';
        return;
      });
    }
    try {
      log("Fetching weather for $city...");
      final response = await http.get(
        Uri.parse(
          'https://api.openweathermap.org/data/2.5/weather?q=$city&appid=${ApiKey.openWeatherKey}&units=metric',
        ),
      );
      log("Response received with status code: ${response.statusCode}");

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        log("api response: ${data.toString()}");

        if (data.containsKey('main') && data['main'].containsKey('temp')) {
          log("valid data received");
        } else {
          log("invalid data received");
        }
        try {
          final weather = Weather(
            city: data['name'],
            temperature: (data['main']['temp'] as num).toDouble(),
            description: data['weather'][0]['description'],
            humidity: data['main']['humidity'],
            windSpeed: (data['wind']['speed'] as num).toDouble().toString(),
            icon: data['weather'][0]['icon'],
          );

          log("Weather data: $weather");

          setState(() {
            weatherData = [weather];
            _errorMessage = '';
          });
          log("weather data updated!! New length: ${weatherData.length}");
        } catch (e) {
          log("error in parsing weather data: $e");
        }
      } else {
        setState(() {
          log("Failed to load weather data: ${response.body}");
          _errorMessage = 'Failed to load weather data: ${response.body}';
        });
      }
    } catch (e) {
      log("Exception in fetchWeatherData: $e");
      setState(() {
        _errorMessage = e.toString();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    log(weatherData.length.toString());
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(height: 20),
          Container(
            width: 500,
            height: 50,
            child: SearchBar(
              leading: Icon(Icons.search, color: Colors.green),
              hintText: "Enter City",
              hintStyle: WidgetStateProperty.all(
                TextStyle(color: Colors.green),
              ),
              controller: _cityController,
              onSubmitted: (value) => fetchWeatherData(value),
            ),
          ),
          SizedBox(height: 20),
          Expanded(
            child:
                weatherData.isEmpty
                    ? Center(
                      child: Text(
                        _errorMessage!.isNotEmpty
                            ? _errorMessage!
                            : "No weather data available",
                        style: TextStyle(color: Colors.red),
                      ),
                    )
                    : ListView.builder(
                      itemCount: weatherData.length,
                      itemBuilder: (context, index) {
                        final weather = weatherData[index];
                        return Card(
                          margin: EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          elevation: 4,
                          child: ListTile(
                            leading: ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.network(
                                "https://openweathermap.org/img/wn/${weather.icon}.png",

                                height: 50,
                                width: 50,
                                fit: BoxFit.cover,
                                errorBuilder:
                                    (context, error, stackTrace) =>
                                        Icon(Icons.error, color: Colors.red),
                              ),
                            ),
                            title: Text(
                              weather.city,
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(height: 4),
                                Text(
                                  "Temperature: ${weather.temperature.toStringAsFixed(1)}°C",
                                ),
                                Text("Description: ${weather.description}"),
                                Text("Humidity: ${weather.humidity}%"),
                                Text("Wind Speed: ${weather.windSpeed} m/s"),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            DrawerHeader(
              decoration: BoxDecoration(color: Colors.green),
              child: Text(
                "Cameroon Weather App",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ),
            ListTile(
              title: Text("Home"),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: Text("About"),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: Text("Contact"),
              onTap: () {
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}
