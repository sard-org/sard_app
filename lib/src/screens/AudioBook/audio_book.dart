import 'package:flutter/material.dart';
import '../../../style/BaseScreen.dart';
import '../../../style/Colors.dart';
import '../../../style/Fonts.dart';

class AudioBookScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BaseScreen(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 12),

            // 📌 صورة المؤلف + الاسم
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircleAvatar(
                  radius: 24,
                  backgroundImage: AssetImage('assets/img/author.png'), // ✅ صورة المؤلف
                ),
                SizedBox(width: 8),
                Text(
                  "مارك مانسون",
                  style: AppTexts.contentBold.copyWith(color: AppColors.neutral500),
                ),
              ],
            ),

            SizedBox(height: 16),

            // 📌 اسم الكتاب
            Text(
              "فن اللامبالاة",
              style: AppTexts.heading1Bold,
              textAlign: TextAlign.center,
            ),

            SizedBox(height: 16),

            // 📌 صورة الكتاب
            Container(
              width: 180,
              height: 250,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 8,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.asset(
                  'assets/img/Book_1.png', // ✅ صورة الكتاب
                  fit: BoxFit.cover,
                ),
              ),
            ),

            Spacer(),

            // 📌 شريط التشغيل في أسفل الشاشة
            Column(
              children: [
                // 📌 وقت التشغيل
                Text(
                  "01:23:2 / 34:23",
                  style: AppTexts.contentBold.copyWith(
                    color: AppColors.primary500,
                  ),
                ),

                SizedBox(height: 8),

                // 📌 الـ Progress Bar
                Slider(
                  value: 23.2,
                  min: 0,
                  max: 34.23,
                  activeColor: AppColors.primary500,
                  inactiveColor: AppColors.neutral300,
                  onChanged: (value) {},
                ),

                SizedBox(height: 12),

                // 📌 أزرار التحكم
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    IconButton(
                      icon: Icon(Icons.replay_10, color: AppColors.primary500),
                      onPressed: () {},
                    ),
                    Container(
                      decoration: BoxDecoration(
                        color: AppColors.primary500,
                        shape: BoxShape.circle,
                      ),
                      padding: EdgeInsets.all(12),
                      child: Icon(
                        Icons.pause,
                        color: Colors.white,
                        size: 40,
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.forward_10, color: AppColors.primary500),
                      onPressed: () {},
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
