import 'package:flutter/material.dart';
import 'package:sard/style/Colors.dart';
import 'package:sard/style/Fonts.dart';
import 'package:sard/style/BaseScreen.dart';
import 'change_password_screen.dart';
import 'edit_profile_screen.dart'; // استيراد شاشة تغيير كلمة المرور

class SettingsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BaseScreen(
      child: Column(
        children: [
          // ✅ الهيدر "الإعدادات"
          Container(
            padding: EdgeInsets.symmetric(vertical: 16),
            decoration: BoxDecoration(
              color: AppColors.primary500,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(12),
                bottomRight: Radius.circular(12),
              ),
            ),
            child: Center(
              child: Text(
                "الإعدادات",
                style: AppTexts.heading2Bold.copyWith(
                  color: AppColors.neutral100,
                ),
              ),
            ),
          ),
          SizedBox(height: 18),

          // ✅ عناصر الإعدادات مع التنقل بين الصفحات
          Expanded(
            child: Column(
              children: [
                _buildSettingsItem(
                  context,
                  "تعديل البيانات",
                  Icons.edit,
                      () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => EditProfileScreen()),
                  ),
                ),
                _buildSettingsItem(
                  context,
                  "تعديل كلمة المرور",
                  Icons.lock,
                      () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ChangePasswordScreen()),
                  ),
                ),
                _buildSettingsItem(
                  context,
                  "تسجيل الخروج",
                  Icons.logout,
                      () {
                    // هنا تضيف كود تسجيل الخروج الفعلي
                    print("تم تسجيل الخروج");
                  },
                  isLogout: true,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ✅ تحسين شكل الزرار وخليه متناسق مع التصميم
  Widget _buildSettingsItem(BuildContext context, String title, IconData icon, VoidCallback onTap, {bool isLogout = false}) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8), // مسافات داخلية
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: isLogout ? Colors.red.shade100 : AppColors.neutral100, // لون الخلفية
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: isLogout ? Colors.red : AppColors.neutral300, // حدود العنصر
              width: 1.2,
            ),
          ),
          child: Row(
            children: [
              Icon(icon, color: isLogout ? Colors.red : AppColors.primary500, size: 22),
              SizedBox(width: 12),
              Expanded(
                child: Text(
                  title,
                  style: AppTexts.highlightEmphasis.copyWith(
                    color: isLogout ? Colors.red : AppColors.neutral1000, // لون النص
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Icon(Icons.arrow_forward_ios, size: 16, color: AppColors.neutral500),
            ],
          ),
        ),
      ),
    );
  }
}
