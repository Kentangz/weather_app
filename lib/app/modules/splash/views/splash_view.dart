import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:weather_app/app/modules/splash/controllers/splash_controller.dart';

class SplashView extends GetView<SplashController> {
  const SplashView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 16),
            Icon( 
              Icons.cloud_queue,
              size: 100,
              color: Theme.of(context).primaryColor,
            ),

            Text(
              'Weather App',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),

          ],
        ),
      ),
    );
  }
}
