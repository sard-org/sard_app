import 'dart:async';
import 'package:flutter/material.dart';

import '../../../../style/Colors.dart';
import '../../../../style/Fonts.dart';
import '../../boarding/Oboarding.dart'; // استيراد شاشة Onboarding

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeInAnimation;

  @override
  void initState() {
    super.initState();

    // إعداد الأنيميشن
    _controller = AnimationController(vsync: this, duration: Duration(seconds: 2));
    _fadeInAnimation = CurvedAnimation(parent: _controller, curve: Curves.easeIn);

    // تشغيل الأنيميشن عند بدء الصفحة
    _controller.forward();

    // الانتقال بعد 3 ثوانٍ إلى شاشة الـ Onboarding
    Timer(Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => OnboardingScreen()),
      );
    });
  }

  @override
  void dispose() {
    _controller.dispose(); // تنظيف الأنيميشن عند انتهاء الصفحة
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary500, // استخدام اللون الأخضر من ملف الألوان
      body: Column(
        children: [
          // الجزء العلوي: اللوجو والنص في المنتصف
          Expanded(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // اللوجو في المنتصف
                  Container(
                    width: 150,
                    height: 150,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage('assets/img/Logo1.png'), // مسار اللوجو الصحيح
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                  // نص "مرحبًا بك في سرد" مع أنيميشن Fade In
                  FadeTransition(
                    opacity: _fadeInAnimation,
                    child: Text(
                      "مرحبًا بك في سرد",
                      style: AppTexts.heading2Bold.copyWith(
                        color: AppColors.neutral100
                      ), // استخدام الخط من ملف النصوص
                    ),
                  ),
                ],
              ),
            ),
          ),

          // الجزء السفلي: اللودر في الأسفل
          Padding(
            padding: EdgeInsets.only(bottom: 40), // يضيف مسافة 40 بكسل من الأسفل
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(AppColors.neutral100), // لون اللودر أبيض
            ),
          ),
        ],
      ),
    );
  }
}
