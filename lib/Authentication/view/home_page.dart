import 'package:flutter/material.dart';
import 'package:flutter_firebase_11_12/Authentication/service/auth_service.dart';
import 'package:flutter_firebase_11_12/Authentication/view/login_screen.dart';
import 'package:get/get.dart';
class HomePage extends StatelessWidget {
   HomePage({super.key});
  AuthService authService = AuthService();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Home page'
        ),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            authService.logoutAccount();
            Get.off(const LoginScreen());
          },
          child: const Text(
            'L O G O U T'
          ),
        ),
      ),
    );
  }
}