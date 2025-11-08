import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:weather_app/app/data/models/weather_model.dart';
import 'package:weather_app/app/data/services/weather_service.dart';

class HomeController extends GetxController {
  final WeatherService _weatherService = WeatherService();

  var isLoading = true.obs;
  var weatherMessage = "Loading weather data...".obs;
  Rx<Weather?> weather = Rx<Weather?>(null);

  @override
  void onInit() {
    super.onInit();
    fetchWeather();
  }

  Future<void> fetchWeather() async {
    try {
      isLoading(true);
      weatherMessage("Searching location & weather data...");

      final Weather result = await _weatherService.getWeatherDataByLocation();

      weather.value = result;
    } catch (e) {
      weather.value = null;
      weatherMessage.value = e.toString();
    } finally {
      isLoading(false);
    }
  }

  IconData getWeatherIcon(String mainCondition) {
    switch (mainCondition.toLowerCase()) {
      case 'clouds':
        return Icons.cloud;
      case 'rain':
      case 'drizzle':
      case 'shower rain':
        return Icons.grain;
      case 'thunderstorm':
        return Icons.thunderstorm;
      case 'clear':
        return Icons.wb_sunny;
      case 'snow':
        return Icons.ac_unit;
      case 'mist':
      case 'fog':
      case 'haze':
        return Icons.foggy;
      default:
        return Icons.wb_sunny;
    }
  }

  Color getBackgroundColor(String mainCondition) {
    switch (mainCondition.toLowerCase()) {
      case 'clouds':
        return Colors.grey.shade600;
      case 'rain':
      case 'drizzle':
      case 'shower rain':
      case 'thunderstorm':
        return Colors.blueGrey.shade700;
      case 'clear':
        return Colors.blue.shade400;
      case 'snow':
        return Colors.lightBlue.shade100;
      case 'mist':
      case 'fog':
      case 'haze':
        return Colors.grey.shade500;
      default:
        return Colors.blue.shade400;
    }
  }
}
