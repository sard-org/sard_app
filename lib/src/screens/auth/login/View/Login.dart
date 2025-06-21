import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../../main.dart';
import '../../../../../style/BaseScreen.dart';
import '../../../../../style/Colors.dart';
import '../../../../../style/Fonts.dart';
import '../../../../cubit/global_favorite_cubit.dart';
import '../../../../utils/text_input_formatters.dart';
import '../../Create Account/registration/View/register_screen.dart';
import '../../Create Account/registration/logic/register_cubit.dart';
import '../../Create Account/otp/View/otp.dart';
import '../../Forgot Password/Enter Email/enter_email.dart';

import '../logic/login_cubit.dart';
import '../logic/login_state.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _obscurePassword = true;
  bool _rememberMe = false;

  @override
  void initState() {
    super.initState();
    _loadSavedCredentials();
  }

  Future<void> _loadSavedCredentials() async {
    final prefs = await SharedPreferences.getInstance();
    final rememberMe = prefs.getBool('remember_me') ?? false;

    if (rememberMe) {
      final savedEmail = prefs.getString('saved_email') ?? '';

      if (savedEmail.isNotEmpty) {
        setState(() {
          _emailController.text = savedEmail;
          _rememberMe = true;
        });
      }
    }
  }

  @override

  ///
  ///
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: AppColors.neutral100,
        body: SafeArea(
          child: BaseScreen(
            child: SingleChildScrollView(
              physics: const ClampingScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: MediaQuery.of(context).size.height * 0.06),
                  Align(
                    alignment: Alignment.center,
                    child: Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(
                            text: 'أهلاً',
                            style: AppTexts.display1Bold.copyWith(color: AppColors.neutral1000),
                          ),
                          TextSpan(
                            text: ' ',
                          ),
                          TextSpan(
                            text: 'بعودتك!',
                            style: AppTexts.display1Bold.copyWith(color: AppColors.primary500),
                          ),
                        ],
                      ),
                      textAlign: TextAlign.right,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Align(
                    alignment: Alignment.center,
                    child: Text(
                        "الرجاء إدخال بريدك الإلكتروني وكلمة المرور للوصول إلى حسابك.",
                        style: AppTexts.highlightEmphasis.copyWith(color: AppColors.neutral600),
                        textAlign: TextAlign.center),
                  ),
                  const SizedBox(height: 32),
                  _buildTextField(
                    label: 'البريد الإلكتروني',
                    hint: 'أدخل بريدك الإلكتروني',
                    controller: _emailController,
                    obscureText: false,
                    keyboardType: TextInputType.emailAddress,
                    isEmailField: true,
                  ),
                  const SizedBox(height: 16),
                  _buildTextField(
                    label: 'كلمة المرور',
                    hint: 'أدخل كلمة المرور',
                    controller: _passwordController,
                    obscureText: _obscurePassword,
                    toggleVisibility: () {
                      setState(() {
                        _obscurePassword = !_obscurePassword;
                      });
                    },
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                        ],
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      ForgotPasswordScreen()));
                        },
                        child: Text("نسيت كلمة المرور",
                            style: AppTexts.contentAccent.copyWith(
                                color: AppColors.primary500,
                                decoration: TextDecoration.underline)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),
                  BlocConsumer<AuthCubit, AuthState>(
                    listener: (context, state) async {
                      if (state is AuthSuccess) {
                        final prefs = await SharedPreferences.getInstance();

                        // Save login state and optionally email
                        await prefs.setBool('is_logged_in', true);

                        if (_rememberMe) {
                          await prefs.setBool('remember_me', true);
                          await prefs.setString(
                              'saved_email', _emailController.text.trim());
                        } else {
                          await prefs.remove('remember_me');
                          await prefs.remove('saved_email');
                        }

                        // Load data and navigate
                        context.read<GlobalFavoriteCubit>().loadFavorites();
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => MainScreen()),
                        );
                      } else if (state is EmailVerificationRequired) {
                        // Navigate to OTP verification screen
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => BlocProvider(
                              create: (_) => RegisterCubit()
                                ..setRegisteredEmail(state.email),
                              child: VerificationCodeScreen(email: state.email),
                            ),
                          ),
                        );
                      } else if (state is AuthError) {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text(state.message),
                          backgroundColor: AppColors.red100,
                        ));
                      }
                    },
                    builder: (context, state) {
                      final bool isLoading = state is AuthLoading;

                      return SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: isLoading
                              ? null // Disable button when loading
                              : () {
                                  final email = _emailController.text
                                      .trim()
                                      .toLowerCase();
                                  final password =
                                      _passwordController.text.trim();

                                  // Basic validation
                                  if (email.isEmpty) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                            content: Text(
                                                "الرجاء إدخال البريد الإلكتروني")));
                                    return;
                                  }

                                  if (password.isEmpty) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                            content: Text(
                                                "الرجاء إدخال كلمة المرور")));
                                    return;
                                  }

                                  // Validate email format
                                  final bool emailValid = RegExp(
                                          r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                                      .hasMatch(email);
                                  if (!emailValid) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                            content: Text(
                                                "الرجاء إدخال بريد إلكتروني صالح")));
                                    return;
                                  }

                                  BlocProvider.of<AuthCubit>(context).login(
                                      email, password,
                                      rememberMe: _rememberMe);
                                },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary500,
                            disabledBackgroundColor: AppColors
                                .primary300, // Lighter color when disabled
                            minimumSize: const Size(double.infinity, 50),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            padding: const EdgeInsets.symmetric(
                                vertical: 12, horizontal: 16),
                          ),
                          child: isLoading
                              ? SizedBox(
                                  height: 24,
                                  width: 24,
                                  child: CircularProgressIndicator(
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                        AppColors.neutral100),
                                    strokeWidth: 2.0,
                                  ),
                                )
                              : Text("تسجيل الدخول",
                                  style: AppTexts.contentEmphasis
                                      .copyWith(color: AppColors.neutral100)),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 16),
                  Center(
                    child: Wrap(
                      alignment: WrapAlignment.center,
                      children: [
                        Text("ليس لديك حساب؟",
                            style: AppTexts.contentRegular
                                .copyWith(color: AppColors.neutral900)),
                        const SizedBox(width: 4),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => RegisterScreen()));
                          },
                          child: Text("إنشاء حساب",
                              style: AppTexts.contentAccent.copyWith(
                                  color: AppColors.primary500,
                                  decoration: TextDecoration.underline)),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.05),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    required String hint,
    required TextEditingController controller,
    bool obscureText = false,
    VoidCallback? toggleVisibility,
    TextInputType? keyboardType,
    bool isEmailField = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: AppTexts.contentRegular),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          obscureText: obscureText,
          keyboardType: keyboardType,
          inputFormatters:
              isEmailField ? [LowercaseTextInputFormatter()] : null,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: AppTexts.contentRegular,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: AppColors.neutral400),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: AppColors.neutral400),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: AppColors.primary500, width: 2),
            ),
            filled: true,
            fillColor: AppColors.neutral100,
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            suffixIcon: toggleVisibility != null
                ? IconButton(
                    onPressed: toggleVisibility,
                    icon: Icon(
                        obscureText ? Icons.visibility_off : Icons.visibility,
                        color: AppColors.neutral400),
                  )
                : null,
          ),
        ),
        const SizedBox(height: 12),
      ],
    );
  }
}
