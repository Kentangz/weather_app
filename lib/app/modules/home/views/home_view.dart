import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:weather_app/app/modules/auth/controllers/auth_controller.dart';
import 'package:weather_app/app/modules/home/controllers/home_controller.dart';
import 'package:weather_app/app/modules/home/widgets/skeleton_view.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final bool isInitialLoading =
          controller.isLoading.value && controller.weather.value == null;

      final Color backgroundColor;
      if (isInitialLoading) {
        backgroundColor = Colors.white;
      } else if (controller.weather.value != null) {
        backgroundColor = controller.getBackgroundColor(
          controller.weather.value!.mainCondition,
        );
      } else {
        backgroundColor = Colors.white;
      }

      final Color textColor =
          (isInitialLoading || controller.weather.value == null)
          ? Colors.black
          : Colors.white;

      return Container(
        color: backgroundColor,
        child: Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            title: const Text('Weather App'),
            backgroundColor:
                (isInitialLoading || controller.weather.value == null)
                ? null
                : Colors.transparent,
            elevation: (isInitialLoading || controller.weather.value == null)
                ? null
                : 0,
            foregroundColor: textColor,
            actions: [
              IconButton(
                icon: const Icon(Icons.logout),
                color: textColor,
                onPressed: () {
                  Get.find<AuthController>().logout();
                },
              ),
            ],
          ),
          body: RefreshIndicator(
            onRefresh: controller.fetchWeather,
            child: ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.75,
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Obx(() {
                        if (controller.isLoading.value &&
                            controller.weather.value == null) {
                          return const SkeletonView();
                        }

                        if (controller.weather.value != null) {
                          final weather = controller.weather.value!;
                          return Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                controller.getWeatherIcon(
                                  weather.mainCondition,
                                ),
                                size: 120,
                                color: Colors.white,
                              ),
                              const SizedBox(height: 20),
                              Text(
                                weather.cityName,
                                style: const TextStyle(
                                  fontSize: 32,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(height: 10),
                              Text(
                                '${weather.temperature.toStringAsFixed(1)} °C',
                                style: const TextStyle(
                                  fontSize: 48,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(height: 10),
                              Text(
                                weather.description,
                                style: const TextStyle(
                                  fontSize: 20,
                                  color: Colors.white70,
                                ),
                              ),
                            ],
                          );
                        } else {
                          return Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                controller.weatherMessage.value,
                                style: TextStyle(
                                  fontSize: 16,
                                  color: textColor,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              if (controller.locationErrorType.value != null)
                                const SizedBox(height: 20),
                              if (controller.locationErrorType.value != null)
                                ElevatedButton(
                                  onPressed: controller.openSettings,
                                  child: const Text('Open Settings'),
                                ),
                            ],
                          );
                        }
                      }),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    });
  }
}
