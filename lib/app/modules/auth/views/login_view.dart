import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:weather_app/app/modules/auth/controllers/auth_controller.dart';
import 'package:weather_app/app/routes/app_routes.dart';

class LoginView extends GetView<AuthController> {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 100),

              Icon(
                Icons.cloud_queue,
                size: 80,
                color: Theme.of(context).primaryColor,
              ),
              const SizedBox(height: 16),

              const Text(
                'Welcome',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              const Text(
                'Please sign in to continue',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
              const SizedBox(height: 40),

              TextField(
                controller: controller.emailController,
                decoration: InputDecoration(
                  labelText: 'Email',
                  prefixIcon: const Icon(Icons.email_outlined),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 16),

              TextField(
                controller: controller.passwordController,
                decoration: InputDecoration(
                  labelText: 'Password',
                  prefixIcon: const Icon(Icons.lock_outline),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                obscureText: true,
              ),

              Container(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: controller.sendPasswordReset,
                  child: const Text('Forgot Password?'),
                ),
              ),

              const SizedBox(height: 12),
              ElevatedButton(
                onPressed: controller.login,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color.fromRGBO(171, 214, 255, 1),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text('Login', style: TextStyle(fontSize: 18)),
              ),
              const SizedBox(height: 12),

              TextButton(
                onPressed: () => Get.toNamed(AppRoutes.REGISTER),
                child: const Text("Don't have an account? Sign up here"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
