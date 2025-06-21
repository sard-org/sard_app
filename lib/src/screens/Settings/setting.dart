import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sard/src/screens/Settings/profile/profile_cubit.dart';
import 'package:sard/src/screens/Settings/profile/profile_state.dart';
import 'package:sard/src/screens/auth/login/View/Login.dart';
import 'package:sard/style/Colors.dart';
import 'package:sard/style/Fonts.dart';
import 'package:sard/style/BaseScreen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'Change Password/change_password.dart';
import 'profile/edit_profile.dart';


class SettingsScreen extends StatefulWidget {
  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  late Future<ProfileCubit> _profileCubitFuture;

  @override
  void initState() {
    super.initState();
    _profileCubitFuture = ProfileCubit.init(); // تحميل cubit مع التوكن
  }

  // إضافة popup تأكيد تسجيل الخروج في أسفل الصفحة
  void _showLogoutConfirmation() {
    showModalBottomSheet(
      context: context,
      isDismissible: true,
      enableDrag: true,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(18),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // العنوان
                Text(
                  'تسجيل خروج',
                  style: AppTexts.heading1Bold.copyWith(
                    color: AppColors.neutral1000,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                
                // خط فاصل
                Container(
                  height: 1,
                  width: double.infinity,
                  color: AppColors.neutral300,
                ),
                const SizedBox(height: 24),
                
                // أيقونة التحذير
                Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    color: AppColors.red200.withOpacity(0.2),
                    shape: BoxShape.circle,
                  ),
                  child: Container(
                    margin: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: AppColors.red200,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.help_outline,
                      color: Colors.white,
                      size: 32,
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                
                // النص الرئيسي
                RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: 'هل أنت متأكد من رغبتك في ',
                        style: AppTexts.heading2Bold.copyWith(
                          color: AppColors.neutral1000,
                        ),
                      ),
                      TextSpan(
                        text: 'تسجيل الخروج؟',
                        style: AppTexts.heading2Bold.copyWith(
                          color: AppColors.red200,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                
                // النص الفرعي
                Text(
                  'هل أنت متأكد أنك تريد تسجيل الخروج؟',
                  style: AppTexts.contentRegular.copyWith(
                    color: AppColors.neutral600,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 32),
                
                // الأزرار
                Row(
                  children: [
                    // زر الخروج
                    Expanded(
                      child: SizedBox(
                        height: 50,
                        child: OutlinedButton(
                          onPressed: () async {
                            Navigator.of(context).pop(); // إغلاق الـ popup
                            
                            // حذف جميع البيانات المحفوظة بما في ذلك التوكين
                            final prefs = await SharedPreferences.getInstance();
                            await prefs.clear();
                            
                            // الانتقال لصفحة تسجيل الدخول
                            Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(builder: (_) => LoginScreen()),
                              (route) => false,
                            );
                          },
                          style: OutlinedButton.styleFrom(
                            foregroundColor: AppColors.primary500,
                            side: BorderSide(color: AppColors.primary500),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: Text(
                            'خروج',
                            style: AppTexts.contentEmphasis.copyWith(
                              color: AppColors.primary500,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    // زر الإلغاء
                    Expanded(
                      child: SizedBox(
                        height: 50,
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.of(context).pop(); // إغلاق الـ popup فقط
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary500,
                            foregroundColor: Colors.white,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: Text(
                            'إلغاء',
                            style: AppTexts.contentEmphasis.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<ProfileCubit>(
      future: _profileCubitFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return Scaffold(
            backgroundColor: Colors.white,
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (snapshot.hasError) {
          return Scaffold(
            backgroundColor: Colors.white,
            body: Center(child: Text('Error: ${snapshot.error}')),
          );
        }

        final profileCubit = snapshot.data!;
        profileCubit.getUserProfile();

        return BlocProvider<ProfileCubit>.value(
          value: profileCubit,
          child: BlocBuilder<ProfileCubit, ProfileState>(
            builder: (context, state) {
              return Scaffold(
                backgroundColor: Colors.white,
                body: Column(
                  children: [
                    _buildAppBar(state),
                    Expanded(
                      child: BaseScreen(
                        child: Column(
                          children: [
                            _buildSettingsItem(
                              context,
                              "تعديل البيانات",
                              "assets/img/Edit.png",
                              () async {
                                await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => BlocProvider.value(
                                      value: profileCubit,
                                      child: EditProfileScreen(),
                                    ),
                                  ),
                                );
                                profileCubit.getUserProfile();
                              },
                            ),
                            const SizedBox(height: 4),
                            _buildDivider(),
                            const SizedBox(height: 4),
                            _buildSettingsItem(
                              context,
                              "تعديل كلمة المرور",
                              "assets/img/password.png",
                              () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (_) => ChangePassword()),
                              ),
                            ),
                            const SizedBox(height: 4),
                            _buildDivider(),
                            const SizedBox(height: 4),
                            _buildSettingsItem(
                              context,
                              "تسجيل الخروج",
                              "assets/img/Logout.png",
                              () => _showLogoutConfirmation(),
                              isLogout: true,
                            ),
                            const SizedBox(height: 4),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildAppBar(ProfileState state) {
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
        children: [
          ClipOval(
            child: state is ProfileLoaded && state.user.imageUrl != null
                ? Image.network(
                    state.user.imageUrl!,
                    width: 50,
                    height: 50,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Image.asset(
                      'assets/img/Avatar.png', // Default avatar
                      width: 50,
                      height: 50,
                      fit: BoxFit.cover,
                    ),
                  )
                : Image.asset(
                    'assets/img/Avatar.png', // Default avatar
                    width: 50,
                    height: 50,
                    fit: BoxFit.cover,
                  ),
          ),
          SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "يومك سعيد!",
                style: AppTexts.contentRegular.copyWith(
                  color: AppColors.neutral100,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                state is ProfileLoaded ? state.user.name : "جاري التحميل...",
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

  Widget _buildSettingsItem(
    BuildContext context,
    String title,
    String iconPath,
    VoidCallback onTap, {
    bool isLogout = false,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 0, vertical: 8),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: isLogout ? Colors.red.shade100 : AppColors.neutral100,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: isLogout ? AppColors.red100 : AppColors.neutral300,
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
                    color: isLogout ? AppColors.red100 : AppColors.neutral1000,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Icon(Icons.arrow_forward_ios,
                  size: 16, color: AppColors.neutral500),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDivider() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 0),
      child: Divider(
        color: AppColors.neutral300,
        thickness: 1,
      ),
    );
  }
}
