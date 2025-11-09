import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:weather_app/app/data/errors/location_exceptions.dart';

class WeatherService {
  final String _apiKey =
      dotenv.env['OPENWEATHER_API_KEY'] ?? 'API_KEY_NOT_FOUND';

  Future<Map<String, dynamic>> getWeatherDataByLocation() async {
    Position position = await _getCurrentLocation();
    String apiUrl =
        'https://api.openweathermap.org/data/2.5/weather?lat=${position.latitude}&lon=${position.longitude}&appid=$_apiKey&units=metric&lang=id';

    try {
      final response = await http.get(Uri.parse(apiUrl));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data as Map<String, dynamic>;
      } else {
        throw Exception(
          'Failed to load weather data. Code: ${response.statusCode}',
        );
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<Position> _getCurrentLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw CustomLocationServiceDisabledException();
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        throw Exception('Location permission denied.');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      throw CustomLocationPermissionDeniedException();
    }

    return await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
  }
}
