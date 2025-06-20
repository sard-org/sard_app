import 'dart:async';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../style/Colors.dart';
import '../../../../style/Fonts.dart';
import '../../../main.dart';
import '../Onboarding/Onboarding Screen.dart';
import '../auth/login/View/Login.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeInAnimation;

  @override
  void initState() {
    super.initState();

    _controller =
        AnimationController(vsync: this, duration: Duration(seconds: 2));
    _fadeInAnimation =
        CurvedAnimation(parent: _controller, curve: Curves.easeIn);
    _controller.forward();

    // Navigate after 3 seconds
    Timer(const Duration(seconds: 2), _navigateBasedOnUserState);
  }

  Future<void> _navigateBasedOnUserState() async {
    final prefs = await SharedPreferences.getInstance();

    final hasSeenOnboarding = prefs.getBool('hasSeenOnboarding') ?? false;
    final isLoggedIn = prefs.getBool('is_logged_in') ?? false;

    Widget nextScreen;

    if (!hasSeenOnboarding) {
      await prefs.setBool('hasSeenOnboarding', true);
      nextScreen = Onboarding();
    } else if (isLoggedIn) {
      nextScreen = MainScreen(); // <- already logged in
    } else {
      nextScreen = LoginScreen(); // <- go to login
    }

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => nextScreen),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary500,
      body: Column(
        children: [
          Expanded(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 150,
                    height: 150,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage('assets/img/Logo1.png'),
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  FadeTransition(
                    opacity: _fadeInAnimation,
                    child: Text(
                      "مرحبًا بك في سرد",
                      style: AppTexts.heading2Bold.copyWith(
                        color: AppColors.neutral100,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(bottom: 40),
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(AppColors.neutral100),
            ),
          ),
        ],
      ),
    );
  }
}
