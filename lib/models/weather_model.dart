class Weather {
  final String city;
  final double temperature;
  final String description;
  final String icon;
  final String humidity;
  final String windSpeed;

  Weather({
    required this.city,
    required this.temperature,
    required this.description,
    required this.icon,
    required this.humidity,
    required this.windSpeed,
  });

  factory Weather.fromJson(Map<String, dynamic> json) {
    return Weather(
      city: json["name"],
      temperature: json["main"]["temp"].toDouble(),
      description: json["weather"][0]["description"],
      humidity: json["main"]["humidity"],
      windSpeed: json["wind"]["speed"],
      icon: json["weather"][0]["icon"],
    );
  }
  @override
  String toString() {
    return 'Weather{city: $city, temperature: $temperature, description: $description, icon: $icon, humidity: $humidity, windSpeed: $windSpeed}';
  }
}
