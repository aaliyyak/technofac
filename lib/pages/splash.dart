import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

import 'onboarding.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((_) {
      Future.delayed(const Duration(seconds: 3), () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const OnboardingScreen()),
        );
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Positioned(
            top: 30,
            right: 0,
            child: Image.asset(
              'assets/6.png',
              width: 90,
              height: 120,
            ),
          ),

          Positioned(
            bottom: 0,
            left: 0,
            child: Image.asset(
              'assets/7.png',
              width: 60,
              height: 118,
            ),
          ),

          // Konten utama
          Center(
            child: Column(
              children: [
                const SizedBox(height: 290),
                Image.asset(
                  'assets/splash.png',
                  width: 150,
                  height: 140,
                ),
                const Spacer(),
                const Column(
                  children: [
                    Text(
                      'Copyright © 2025',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    Text(
                      'UNIVERSITAS INDO GLOBAL MANDIRI',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(height: 10),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
