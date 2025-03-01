import 'dart:convert';

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
    fetchWeatherData("Bamenda");
  }

  Future<void> fetchWeatherData(String city) async {
    if (!cities.contains(city)) {
      setState(() {
        _errorMessage = 'City not a capital of any region in Cameroon';
        return;
      });
    }
    try {
      final response = await http.get(
        Uri.parse(
          'https://api.openweathermap.org/data/2.5/weather?q=$city&appid=${ApiKey.openWeatherKey}&units=metric',
        ),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        print(data);
        setState(() {
          weatherData = [
            Weather(
              city: data['name'],
              temperature: data['main']['temp'],
              description: data['weather'][0]['description'],
              humidity: data['main']['humidity'],
              windSpeed: data['wind']['speed'],
              icon: data['weather'][0]['icon'],
            ),
          ];
          _errorMessage = '';
        });
      } else {
        setState(() {
          _errorMessage = 'Failed to load weather data';
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
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
            child: ListView.builder(
              itemCount: weatherData.length,
              itemBuilder: (context, index) {
                final weather = weatherData[index];
                return ListTile(
                  leading: Container(
                    color: Colors.green,
                    height: 50.0,
                    width: 50.0,
                    child: Image.network(
                      "https://openweathermap.org/img/wn/${weather.icon}.png",
                    ),
                  ),
                  title: Text(weather.city),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Temperature: ${weather.temperature.toStringAsFixed(1)}°C",
                      ),
                      Text("Description: ${weather.description}"),
                      Text("Humidity: ${weather.humidity}%"),
                      Text("Wind Speed: ${weather.windSpeed} m/s"),
                    ],
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
