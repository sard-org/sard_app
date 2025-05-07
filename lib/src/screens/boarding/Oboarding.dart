import 'package:flutter/material.dart';
import '../../../main.dart';
import '../../../style/BaseScreen.dart';
import '../../../style/Colors.dart';
import '../../../style/Fonts.dart';
import '../auth/login/View/Login.dart';

class OnboardingScreen extends StatefulWidget {
  @override
  _OnboardingScreenState createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  // بيانات الشاشات
  final List<Map<String, String>> onboardingData = [
    {
      "image": "assets/img/1_Onb.png",
      "title": "مرحبا بك في سرد",
      "description": "تطبيق كتب صوتية بميزات ذكية وتنافسية.",
    },
    {
      "image": "assets/img/2_Onb.png",
      "title": "Develop Your Skills",
      "description": "Gain hands-on experience and build a strong skill set.",
    },
    {
      "image": "assets/img/3_Onb.png",
      "title": "Welcome To MSP Tech Club\n- Al Azhar University",
      "description": "Step into the world of innovation and creativity, and inspire unconventional thinking for positive change.",
    },
  ];

  @override
  Widget build(BuildContext context) {
    return BaseScreen(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(height: 20),

          // زر تخطي (لا يظهر في آخر صفحة)
          if (_currentPage != onboardingData.length - 1)
            Align(
              alignment: Alignment.topRight,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: GestureDetector(
                  onTap: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => MainScreen()),
                    );
                  },
                  child: Text(
                    "Skip",
                    style: AppTexts.contentBold.copyWith(
                      color: AppColors.primary500,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
              ),
            ),

          SizedBox(height: 20),

          // PageView أفقي مع سكرول تلقائي
          Expanded(
            child: PageView.builder(
              controller: _pageController,
              scrollDirection: Axis.horizontal, // ✅ سكرول يمين وشمال
              physics: BouncingScrollPhysics(), // ✅ سكرول سلس
              itemCount: onboardingData.length,
              onPageChanged: (index) {
                setState(() {
                  _currentPage = index;
                });
              },
              itemBuilder: (context, index) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      onboardingData[index]["image"]!,
                      fit: BoxFit.contain,
                    ),
                    SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            onboardingData[index]["title"]!,
                            textAlign: TextAlign.center,
                            style: AppTexts.heading1Bold,
                          ),
                          SizedBox(height: 12),
                          Text(
                            onboardingData[index]["description"]!,
                            textAlign: TextAlign.center,
                            style: AppTexts.contentEmphasis.copyWith(
                              color: AppColors.neutral500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              },
            ),
          ),

          SizedBox(height: 24),

          // مؤشر الصفحات
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              onboardingData.length,
                  (index) => _buildIndicator(isActive: index == _currentPage),
            ),
          ),

          SizedBox(height: 24),

          // زر التالي / ابدأ
          UpdateButton(
            title: _currentPage == onboardingData.length - 1 ? "ابدأ الآن" : "التالي",
            onPressed: () {
              if (_currentPage == onboardingData.length - 1) {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => LoginScreen()),
                );
              } else {
                _pageController.nextPage(
                  duration: Duration(milliseconds: 500),
                  curve: Curves.easeInOut,
                );
              }
            },
          ),

          SizedBox(height: 20),
        ],
      ),
    );
  }

  // ويدجت لمؤشر الصفحة
  Widget _buildIndicator({required bool isActive}) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4),
      width: isActive ? 24 : 8,
      height: 8,
      decoration: BoxDecoration(
        color: isActive ? AppColors.primary500 : AppColors.neutral300,
        borderRadius: BorderRadius.circular(4),
      ),
    );
  }
}

/// ✅ زر التحديث المعاد استخدامه
class UpdateButton extends StatelessWidget {
  final String title;
  final VoidCallback onPressed;

  const UpdateButton({required this.title, required this.onPressed, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary500,
            minimumSize: Size(double.infinity, 50),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        child: Text(
          title,
          style: AppTexts.highlightAccent.copyWith(color: Colors.white),
        ),
      ),
    );
  }
}
