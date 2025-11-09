import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:weather_app/app/data/models/weather_model.dart';
import 'package:weather_app/app/data/services/weather_service.dart';
import 'package:weather_app/app/utils/notification_helper.dart';
import 'package:geolocator/geolocator.dart';
import 'package:weather_app/app/data/errors/location_exceptions.dart';
import 'dart:io';
import 'package:get_storage/get_storage.dart';

enum LocationErrorType { serviceDisabled, permissionDenied }

class HomeController extends GetxController {
  final WeatherService _weatherService = Get.find<WeatherService>();
  final GetStorage _storage = GetStorage();

  var isLoading = true.obs;
  var weatherMessage = "Loading weather data...".obs;
  Rx<Weather?> weather = Rx<Weather?>(null);
  var locationErrorType = Rx<LocationErrorType?>(null);

  @override
  void onInit() {
    super.onInit();
    _loadWeatherFromCache();
    fetchWeather();
  }

  void _loadWeatherFromCache() {
    try {
      final cachedData = _storage.read<Map<String, dynamic>>('lastWeather');
      if (cachedData != null) {
        weather.value = Weather.fromJson(cachedData);
        isLoading(false);
      }
    } catch (e) {
      // Ignore cache loading errors
    }
  }

  Future<void> fetchWeather() async {
    try {
      isLoading(true);
      locationErrorType.value = null;
      weatherMessage("Finding location & weather data...");

      final Map<String, dynamic> resultData = await _weatherService
          .getWeatherDataByLocation();

      weather.value = Weather.fromJson(resultData);
      _storage.write('lastWeather', resultData);
    } on SocketException catch (_) {
      String errorMsg = 'Connection lost. Showing last data.';
      weatherMessage.value = errorMsg;
      NotificationHelper.showError('Offline', 'No internet connection.');
    } on CustomLocationServiceDisabledException catch (e) {
      weather.value = null;
      weatherMessage.value = e.toString();
      locationErrorType.value = LocationErrorType.serviceDisabled;
      NotificationHelper.showError('Failed to Load Data', e.toString());
    } on CustomLocationPermissionDeniedException catch (e) {
      weather.value = null;
      weatherMessage.value = e.toString();
      locationErrorType.value = LocationErrorType.permissionDenied;
      NotificationHelper.showError('Failed to Load Data', e.toString());
    } catch (e) {
      weather.value = null;
      locationErrorType.value = null;
      weatherMessage.value = e.toString();
      NotificationHelper.showError('Failed to Load Data', e.toString());
    } finally {
      isLoading(false);
    }
  }

  Future<void> openSettings() async {
    if (locationErrorType.value == LocationErrorType.serviceDisabled) {
      await Geolocator.openLocationSettings();
    } else if (locationErrorType.value == LocationErrorType.permissionDenied) {
      await Geolocator.openAppSettings();
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
