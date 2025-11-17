import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import '../../controllers/splash_controller.dart';

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final controller = Get.find<SplashController>();

    return Scaffold(
      backgroundColor: Color(0xFFE3D9FF),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset('assets/images/logo.svg', width: 120),
            SizedBox(height: 20),
            Text(
              "QuickTask",
              style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.purple[900]),
            ),
            SizedBox(height: 20),
            CircularProgressIndicator(color: Colors.purple),
          ],
        ),
      ),
    );
  }
}