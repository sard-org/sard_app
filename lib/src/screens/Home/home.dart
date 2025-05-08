import 'package:flutter/material.dart';
import '../../../style/BaseScreen.dart';
import '../../../style/Colors.dart';
import '../../../style/Fonts.dart';
import '../AudioBook/audio_book.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<Map<String, dynamic>> categories = [
    {'label': 'فانتازيا', 'icon': Icons.auto_awesome},
    {'label': 'دراما', 'icon': Icons.theater_comedy},
    {'label': 'تحقيق', 'icon': Icons.person_search},
    {'label': 'رعب', 'icon': Icons.nightlight_round},
    {'label': 'تاريخي', 'icon': Icons.account_balance},
  ];

  final FocusNode _searchFocusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: BaseScreen(
        child: SingleChildScrollView(
          padding: const EdgeInsets.only(top: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                children: [
                  CircleAvatar(
                    radius: 24,
                    backgroundImage: AssetImage('assets/images/profile.png'),
                  ),
                  const SizedBox(width: 6),
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: 'أهلاً',
                          style: AppTexts.featureStandard.copyWith(
                            color: AppColors.neutral700,
                          ),
                        ),
                        TextSpan(
                          text: ', خالد',
                          style: AppTexts.heading2Accent.copyWith(
                            color: AppColors.neutral1000,
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Text(
                    'أنت تبلي حسناً 💪',
                    style: AppTexts.captionRegular.copyWith(
                      color: AppColors.neutral700, // أو أي لون تفضله هنا
                    ),
                  ),
                  Text(
                    ' استمر في الاستماع للكتب يومياً',
                    style: AppTexts.contentAccent.copyWith(
                      color: AppColors.neutral1000,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              // Progress Tracker
              Row(
                children: [
                  // Existing progress containers
                  ...List.generate(
                    7,
                        (index) => Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4.0),
                      child: Container(
                        width: 32,
                        height: 32,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(2),
                          color: index < 3
                              ? AppColors.primary100
                              : AppColors.neutral200,
                          border: Border.all(color: AppColors.primary500),
                        ),
                        child: index == 2
                            ? Icon(Icons.verified, color: AppColors.primary700, size: 18)
                            : null,
                      ),
                    ),
                  ),
                  // Space between the progress and the star + points
                  Expanded(child: SizedBox()),  // This will take up the remaining space
                  // Star icon with points
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0), // Space inside the container
                      decoration: BoxDecoration(
                        color: AppColors.primary100, // Background color (you can change it)
                        borderRadius: BorderRadius.circular(8), // Rounded corners
                        border: Border.all(
                          color: AppColors.primary700, // Border color
                          width: 1.5,  // Border width
                        ),
                      ),
                      child: Row(
                        children: [
                          // Replace the Icon with Image.asset for your custom star image
                          Image.asset(
                            'assets/img/icons/star.png', // Path to your custom star image
                            width: 18,  // Width of the star image
                            height: 18, // Height of the star image
                          ),
                          SizedBox(width: 4),
                          Text(
                            '12',  // Number of points
                            style: AppTexts.contentAccent.copyWith(
                              color: AppColors.neutral1000,  // Color of the text
                            ),
                          ),
                        ],
                      ),
                    ),
                  )

                ],
              ),
              const SizedBox(height: 8),

              // Search
              Focus(
                focusNode: _searchFocusNode,
                child: Builder(
                  builder: (context) {
                    return TextField(
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                        hintText: 'ابحث عن كتاب، مؤلف، تصنيف...',
                        hintStyle: AppTexts.contentAccent.copyWith(color: AppColors.neutral500),
                        prefixIcon: Icon(Icons.search, color: AppColors.neutral500),
                        filled: true,
                        fillColor: AppColors.neutral100,
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: AppColors.neutral300),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: AppColors.primary600),
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 16),
              // Categories
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: categories.map((category) {
                    return InkWell(
                      onTap: () {
                        // لا حاجة لأي تغيير عند الضغط
                      },
                      borderRadius: BorderRadius.circular(12),
                      child: Container(
                        margin: EdgeInsets.only(right: 8),
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                        decoration: BoxDecoration(
                          color: AppColors.neutral100, // إلغاء التحديد
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: AppColors.neutral300,
                          ),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              category['icon'],
                              size: 18,
                              color: AppColors.neutral1000,
                            ),
                            const SizedBox(width: 12),
                            Text(
                              category['label'],
                              style: AppTexts.contentAccent.copyWith(
                                color: AppColors.neutral1000,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
              const SizedBox(height: 20),

              // Suggested Books Section
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'كتب مرشحة لك',
                    style: AppTexts.heading2Bold.copyWith(
                      color: AppColors.neutral1000,
                    ),
                  ),
                  TextButton(
                    onPressed: () {},
                    child: Text(
                      'عرض المزيد',
                      style: AppTexts.captionBold.copyWith(
                        color: AppColors.primary700,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ],
              ),

              SizedBox(
                height: 190,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: 10,
                  itemBuilder: (context, index) => GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => AudioBookScreen()),
                      );
                      print('Item $index tapped');
                    },
                    child: Container(
                      width: 280,
                      margin: EdgeInsets.only(right: index == 0 ? 0 : 12),
                      padding: const EdgeInsets.all(12),
                      decoration: ShapeDecoration(
                        color: Color(0xFFFCFEF5),
                        shape: RoundedRectangleBorder(
                          side: BorderSide(width: 0.50, color: AppColors.primary900),
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            width: 93,
                            height: 125,
                            decoration: ShapeDecoration(
                              image: DecorationImage(
                                image: AssetImage('assets/img/Book_1.png'),
                                fit: BoxFit.fill,
                              ),
                              shape: RoundedRectangleBorder(
                                side: BorderSide(width: 2, color: Color(0xFF2B2B2B)),
                                borderRadius: BorderRadius.circular(4),
                              ),
                            ),
                          ),
                          SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'د.أحمد حسين الرفاعي',
                                  style: AppTexts.captionRegular.copyWith(
                                    color: AppColors.neutral400,
                                  ),
                                ),
                                SizedBox(height: 4),
                                Text(
                                  'كيف تكون إنساناً قوياً قيادياً رائعاً محبوباً',
                                  style: AppTexts.highlightStandard.copyWith(
                                    color: AppColors.neutral1000,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                SizedBox(height: 4),
                                Text(
                                  'انشغلنا بقوة وعظمة الدول المتطورة تكنولوجياً...',
                                  style: AppTexts.contentRegular.copyWith(
                                    color: AppColors.neutral400,
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                SizedBox(height: 4),
                                Text(
                                  '19.99 ر.س',
                                  style: AppTexts.highlightStandard.copyWith(
                                    color: AppColors.primary600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              // Rewards Section (استبدل نقاطك)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'استبدل نقاطك',
                    style: AppTexts.heading2Bold.copyWith(
                      color: AppColors.neutral1000,
                    ),
                  ),
                  TextButton(
                    onPressed: () {},
                    child: Text(
                      'عرض المزيد',
                      style: AppTexts.captionBold.copyWith(
                        color: AppColors.primary700,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 220,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: 10,
                  itemBuilder: (context, index) => Container(
                    width: 130,
                    margin: EdgeInsets.only(right: index == 0 ? 0 : 12),
                    decoration: BoxDecoration(
                      border: Border.all(color: AppColors.neutral200),
                      borderRadius: BorderRadius.circular(12),
                      color: AppColors.neutral100,
                    ),
                    padding: const EdgeInsets.all(8),
                    child: Column(
                      children: [
                        Stack(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.asset(
                                'assets/img/Book_1.png',
                                width: 114,
                                height: 140,
                                fit: BoxFit.cover,
                              ),
                            ),
                            Positioned(
                              top: 8,
                              right: 8,
                              child: Container(
                                padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                decoration: BoxDecoration(
                                  color: AppColors.primary600,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Row(
                                  children: [
                                    Icon(Icons.star, size: 12, color: Colors.white),
                                    SizedBox(width: 4),
                                    Text(
                                      '7',
                                      style: AppTexts.captionBold.copyWith(color: Colors.white),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Positioned(
                              top: 8,
                              left: 8,
                              child: Icon(Icons.favorite_border, color: AppColors.primary600),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'اسم 1',
                          style: AppTexts.captionBold.copyWith(color: AppColors.neutral1000),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'اسم 2',
                          style: AppTexts.captionRegular.copyWith(color: AppColors.neutral700),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ),
              ),

            ],
          ),
        ),
      ),
    );
  }
}
