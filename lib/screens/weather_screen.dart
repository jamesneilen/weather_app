import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:weather_app/api/api_client.dart';
import 'package:weather_app/api/api_endpoints.dart';
import 'package:weather_app/models/weather_model.dart';
import '../api/api_key.dart';

class WeatherScreen extends ConsumerStatefulWidget {
  const WeatherScreen({super.key});

  @override
  _WeatherScreenState createState() => _WeatherScreenState();
}

class _WeatherScreenState extends ConsumerState<WeatherScreen> {
  String? _errorMessage;
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
    fetchWeatherData();
  }

  Future<void> fetchWeatherData() async {
    List<Weather> weatherList = [];
    try {
      for (String city in cities) {
        final response = await _apiClient.get(
          ApiEndpoints.currentWeather,
          params: {"q": "$city,CM", "appid": ApiKey.openWeatherKey},
        );
        weatherList.add(Weather.fromJson(response.data));
      }
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // final weatherAsyncValue = ref.watch(weatherProvider(_cityController.text));

    //   return Scaffold(
    //     appBar: AppBar(title: Text("Cameroon Weather App")),
    //     body: Padding(
    //       padding: const EdgeInsets.all(16.0),
    //       child: Column(
    //         children: [
    //           TextField(
    //             controller: _cityController,
    //             decoration: InputDecoration(
    //               labelText: "Enter City",
    //               suffixIcon: Icon(Icons.search),
    //             ),
    //             onSubmitted: (value) => setState(() {}),
    //           ),
    //           SizedBox(height: 20),
    //            Column(
    //                   children: [
    //                     Text(
    //                       "hey",
    //                       style: TextStyle(
    //                         fontSize: 24,
    //                         fontWeight: FontWeight.bold,
    //                       ),
    //                     ),
    //                     Image.network(
    //                       "https://openweathermap.org/img/wn/${weather.icon}.png",
    //                     ),
    //                     Text(
    //                       "${weather.temperature}°C",
    //                       style: TextStyle(fontSize: 30),
    //                     ),
    //                     Text(weather.description, style: TextStyle(fontSize: 18)),
    //                   ],
    //                 ),
    //             loading: () => CircularProgressIndicator(),
    //             error: (error, stack) => Text("Error: $error"),
    //           ),
    //         ],
    //       ),
    //     ),
    //   );
    // }
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Cameroon Weather App",
          style: TextStyle(fontWeight: FontWeight.w300, fontSize: 50),
        ),
        foregroundColor: Colors.green,

        centerTitle: true,
      ),
      body: Center(
        child: Column(
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 50),
            Row(
              children: [
                Card(
                  color: Colors.greenAccent,
                  child: TextButton(
                    onPressed: () {},
                    child: Text(cities[0], selectionColor: Colors.grey),
                  ),
                ),
              ],
            ),
            ListView.builder(
              itemCount: weatherData.length,
              itemBuilder: (context, index) {
                final weather = weatherData[index];
                return ListTile(
                  leading: Image.network(
                    "https://openweathermap.org/img/wn/${weather.icon}.png",
                  ),
                  title: Text(weather.city),
                  subtitle: Text(
                    "${weather.temperature.toStringAsFixed(1)}°C - ${weather.description}",
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
