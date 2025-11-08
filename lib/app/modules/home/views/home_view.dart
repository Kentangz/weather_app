// lib/app/modules/home/views/home_view.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:weather_app/app/modules/home/controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      Color backgroundColor = controller.weather.value != null
          ? controller.getBackgroundColor(
              controller.weather.value!.mainCondition,
            )
          : Colors.blue.shade400;

      return Container(
        color: backgroundColor,
        child: Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            title: const Text('Weather App'),
            backgroundColor: Colors.transparent,
            elevation: 0,
          ),

          // --- PERUBAHAN DIMULAI DI SINI ---
          body: RefreshIndicator(
            // 1. Hubungkan fungsi onRefresh ke controller
            onRefresh: controller.fetchWeather,

            // 2. Bungkus konten kita dengan ListView agar bisa di-scroll
            child: ListView(
              // Ini penting agar RefreshIndicator berfungsi
              // bahkan saat konten tidak penuh
              physics: const AlwaysScrollableScrollPhysics(),
              children: [
                // 3. Kita gunakan SizedBox untuk membuat konten tetap di tengah
                SizedBox(
                  // Sesuaikan tinggi agar konten pas di tengah layar
                  height: MediaQuery.of(context).size.height * 0.75,
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Obx(() {
                        if (controller.isLoading.value &&
                            controller.weather.value == null) {
                          // Hanya tampilkan loading besar saat pertama kali
                          return const CircularProgressIndicator(
                            color: Colors.white,
                          );
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
                          // Jika error
                          return Text(
                            controller.weatherMessage.value,
                            style: const TextStyle(
                              fontSize: 16,
                              color: Colors.white,
                            ),
                            textAlign: TextAlign.center,
                          );
                        }
                      }),
                    ),
                  ),
                ),
              ],
            ),
          ),
          // 4. Hapus FloatingActionButton
          // floatingActionButton: ... (Baris ini dihapus)
          // --- PERUBAHAN SELESAI ---
        ),
      );
    });
  }
}
