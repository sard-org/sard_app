import 'package:flutter/material.dart';
import '../../../main.dart';
import '../../../style/BaseScreen.dart';
import '../../../style/Colors.dart';
import '../../../style/Fonts.dart';
import '../auth/login/View/Login.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({Key? key}) : super(key: key);

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<Map<String, String>> onboardingData = [
    {
      "image": "assets/img/1_Onb.png",
      "title": "مرحبًا بك في سرد",
      "description": "تطبيق كتب صوتية بميزات ذكية وتنافسية.",
    },
    {
      "image": "assets/img/2_Onb.png",
      "title": "اكتشف الآن",
      "description": "استمتع برحلة معرفية غنية مع آلاف الكتب الصوتية المختارة خصيصًا لك.",
    },
    {
      "image": "assets/img/3_Onb.png",
      "title": "ابدأ الآن مع سرد",
      "description": "خطوتك الأولى نحو تجربة معرفية فريدة تبدأ هنا، لا تؤجل شغفك.",
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Stack(
          children: [
            Column(
              children: [
                Expanded(
                  child: PageView.builder(
                    controller: _pageController,
                    itemCount: onboardingData.length,
                    physics: BouncingScrollPhysics(),
                    reverse: true,
                    onPageChanged: (index) {
                      setState(() {
                        _currentPage = index;
                      });
                    },
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Image.asset(
                          onboardingData[index]["image"]!,
                          fit: BoxFit.contain,
                          errorBuilder: (_, __, ___) =>
                              Icon(Icons.broken_image, size: 100, color: Colors.grey),
                        ),
                      );
                    },
                  ),
                ),
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 10,
                        offset: Offset(0, -4),
                      ),
                    ],
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 28),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        onboardingData[_currentPage]["title"]!,
                        textAlign: TextAlign.center,
                        style: AppTexts.heading1Bold.copyWith(fontSize: 22),
                      ),
                      SizedBox(height: 12),
                      Text(
                        onboardingData[_currentPage]["description"]!,
                        textAlign: TextAlign.center,
                        style: AppTexts.contentEmphasis.copyWith(
                          fontSize: 14,
                          color: AppColors.neutral500,
                        ),
                      ),
                      SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(
                          onboardingData.length,
                              (i) => _buildIndicator(isActive: i == _currentPage),
                        ),
                      ),
                      SizedBox(height: 28),
                      _currentPage == onboardingData.length - 1
                          ? UpdateButton(
                        title: "ابدأ الآن",
                        onPressed: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(builder: (context) => LoginScreen()),
                          );
                        },
                      )
                          : Row(
                        children: [
                          Expanded(
                            child: UpdateButton(
                              title: "السابق",
                              isOutlined: true,
                              onPressed: _currentPage == 0
                                  ? null
                                  : () {
                                _pageController.previousPage(
                                  duration: Duration(milliseconds: 400),
                                  curve: Curves.easeInOut,
                                );
                              },
                            ),
                          ),
                          SizedBox(width: 12),
                          Expanded(
                            child: UpdateButton(
                              title: "التالي",
                              onPressed: () {
                                _pageController.nextPage(
                                  duration: Duration(milliseconds: 400),
                                  curve: Curves.easeInOut,
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Positioned(
              top: 0,
              left: 0,
              child: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => MainScreen()),
                      );
                    },
                    child: Text(
                      "تخطي",
                      style: AppTexts.contentBold.copyWith(
                        fontSize: 14,
                        color: AppColors.primary500,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildIndicator({required bool isActive}) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 300),
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

class UpdateButton extends StatelessWidget {
  final String title;
  final VoidCallback? onPressed;
  final bool isOutlined;

  const UpdateButton({
    required this.title,
    required this.onPressed,
    this.isOutlined = false,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: onPressed,
        style: isOutlined
            ? ElevatedButton.styleFrom(
          backgroundColor: Colors.white,
          foregroundColor: AppColors.primary500,
          side: BorderSide(color: AppColors.primary500, width: 2),
          minimumSize: Size(double.infinity, 50),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        )
            : ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary500,
          minimumSize: Size(double.infinity, 50),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        child: Text(
          title,
          style: AppTexts.highlightAccent.copyWith(
            color: isOutlined ? AppColors.primary500 : Colors.white,
          ),
        ),
      ),
    );
  }
}
