import 'package:flutter/material.dart';
import 'package:sard/style/Colors.dart';
import 'package:sard/style/Fonts.dart';
import 'package:sard/style/BaseScreen.dart';
import 'change_password_screen.dart';
import 'edit_profile_screen.dart';

class SettingsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          _buildAppBar(), // ✅ الـ AppBar خارج الـ BaseScreen
          Expanded(
            child: BaseScreen(
              child: Column(
                children: [
                  SizedBox(height: 18),
                  _buildSettingsItem(
                    context,
                    "تعديل البيانات",
                    "assets/img/Edit.png",
                        () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => EditProfileScreen()),
                    ),
                  ),
                  _buildDivider(),
                  _buildSettingsItem(
                    context,
                    "تعديل كلمة المرور",
                    "assets/img/password.png",
                        () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ChangePasswordScreen()),
                    ),
                  ),
                  _buildDivider(),
                  _buildSettingsItem(
                    context,
                    "تسجيل الخروج",
                    "assets/img/Logout.png",
                        () {
                      print("تم تسجيل الخروج");
                    },
                    isLogout: true,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAppBar() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 32, horizontal: 18),
      decoration: BoxDecoration(
        color: AppColors.primary500,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(12),
          bottomRight: Radius.circular(12),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 24,
            backgroundImage: AssetImage("assets/img/profile.jpg"),
          ),
          SizedBox(width: 8), // مسافة بين النص والصورة
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "يومك سعيد!",
                style: AppTexts.contentRegular.copyWith(
                  color: AppColors.neutral400,
                ),
              ),
              Text(
                "أحمد حسام",
                style: AppTexts.heading2Bold.copyWith(
                  color: AppColors.neutral100,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsItem(BuildContext context, String title, String iconPath, VoidCallback onTap, {bool isLogout = false}) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: isLogout ? Colors.red.shade100 : AppColors.neutral100,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: isLogout ? Colors.red : AppColors.neutral300,
              width: 1.2,
            ),
          ),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.asset(
                  iconPath,
                  width: 50,
                  height: 50,
                  fit: BoxFit.cover,
                ),
              ),
              SizedBox(width: 12),
              Expanded(
                child: Text(
                  title,
                  style: AppTexts.highlightEmphasis.copyWith(
                    color: isLogout ? Colors.red : AppColors.neutral1000,
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

  Widget _buildDivider() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: Divider(
        color: AppColors.neutral300,
        thickness: 1,
      ),
    );
  }
}
