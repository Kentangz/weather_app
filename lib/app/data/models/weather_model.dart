class Weather {
  final String cityName;
  final String description;
  final double temperature;
  final String mainCondition; 

  Weather({
    required this.cityName,
    required this.description,
    required this.temperature,
    required this.mainCondition,
  });

  // Factory constructor to create Weather from JSON
  factory Weather.fromJson(Map<String, dynamic> json) {
    return Weather(
      cityName: json['name'],
      description: json['weather'][0]['description'],
      temperature: json['main']['temp'].toDouble(),
      mainCondition: json['weather'][0]['main'],
    );
  }
}
