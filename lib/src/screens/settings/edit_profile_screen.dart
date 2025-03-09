import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../style/BaseScreen.dart';
import '../../../style/Colors.dart';
import '../../../style/Fonts.dart';
import 'change_password_screen.dart';

class EditProfileScreen extends StatefulWidget {
  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  String? _emailError;
  String selectedGender = "ذكر"; // ✅ الافتراضي

  @override
  Widget build(BuildContext context) {
    return BaseScreen(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildAppBar(context),
          SizedBox(height: 16),
          Center(
            child: CircleAvatar(
              radius: 40,
              backgroundImage: AssetImage("assets/img/profile.png"),
            ),
          ),
          SizedBox(height: 16),
          _buildTextField("الاسم", "أحمد حسام"),
          _buildEmailField(),
          _buildPhoneField(),
          _buildDropdownField("النوع", ["ذكر", "أنثى"], selectedGender, (value) {
            setState(() {
              selectedGender = value!;
            });
          }),
          _buildTextField("تاريخ الميلاد", "اختر تاريخ الميلاد", icon: Icons.calendar_today),
          Spacer(),
          UpdateButton(
            title: "تحديث",
            onPressed: _validateAndUpdate,
          ),
        ],
      ),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 16, horizontal: 16),
      decoration: BoxDecoration(
        color: AppColors.primary500,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(12),
          bottomRight: Radius.circular(12),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end, // ✅ جعل العنوان على اليمين
        children: [
          Text(
            "تعديل البيانات",
            style: AppTexts.heading2Bold.copyWith(
              color: AppColors.neutral100,
            ),
          ),
          SizedBox(width: 12),
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              width: 50,
              height: 50,
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(Icons.arrow_forward, color: AppColors.primary500), // ✅ السهم لليمين
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField(String label, String hint, {IconData? icon}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end, // ✅ العنوان على اليمين
      children: [
        Text(label, style: AppTexts.contentRegular),
        SizedBox(height: 8),
        TextField(
          textAlign: TextAlign.right, // ✅ النص يبدأ من اليمين
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: AppTexts.contentRegular,
            prefixIcon: icon != null ? Icon(icon, color: AppColors.neutral400) : null,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: AppColors.neutral400),
            ),
            filled: true,
            fillColor: Colors.white,
          ),
        ),
        SizedBox(height: 12),
      ],
    );
  }

  Widget _buildEmailField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text("البريد الإلكتروني", style: AppTexts.contentRegular),
        SizedBox(height: 8),
        TextField(
          controller: _emailController,
          textAlign: TextAlign.right,
          keyboardType: TextInputType.emailAddress,
          decoration: InputDecoration(
            hintText: "ahmdhsamhmd2@gmail.com",
            hintStyle: AppTexts.contentRegular,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: AppColors.neutral400),
            ),
            filled: true,
            fillColor: Colors.white,
          ),
          onChanged: (value) {
            setState(() {
              _emailError = _isValidEmail(value) ? null : "تأكد من إدخال بريد إلكتروني صحيح";
            });
          },
        ),
        if (_emailError != null)
          Padding(
            padding: EdgeInsets.only(top: 4, right: 8), // ✅ محاذاة اليمين
            child: Text(
              _emailError!,
              textAlign: TextAlign.right,
              style: AppTexts.contentRegular.copyWith(color: Colors.red), // ✅ تحسين الفونت
            ),
          ),
        SizedBox(height: 12),
      ],
    );
  }

  Widget _buildPhoneField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text("رقم الهاتف", style: AppTexts.contentRegular),
        SizedBox(height: 8),
        TextField(
          controller: _phoneController,
          textAlign: TextAlign.right,
          keyboardType: TextInputType.number,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly], // ✅ يمنع الحروف والرموز
          decoration: InputDecoration(
            hintText: "01023359621",
            hintStyle: AppTexts.contentRegular,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: AppColors.neutral400),
            ),
            filled: true,
            fillColor: Colors.white,
          ),
        ),
        SizedBox(height: 12),
      ],
    );
  }
  Widget _buildDropdownField(String label, List<String> options, String selectedValue, Function(String?) onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(label, style: AppTexts.contentRegular),
        SizedBox(height: 8),
        Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            border: Border.all(color: AppColors.neutral400),
            borderRadius: BorderRadius.circular(8),
            color: Colors.white,
          ),
          child: Directionality(
            textDirection: TextDirection.rtl, // ✅ جعل الاتجاه من اليمين لليسار
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                isExpanded: true,
                value: selectedValue,
                icon: Icon(Icons.arrow_drop_down, color: AppColors.neutral500), // ✅ السهم على الشمال
                items: options.map((option) {
                  return DropdownMenuItem<String>(
                    value: option,
                    child: Text(option, textAlign: TextAlign.right), // ✅ النص يظل على اليمين
                  );
                }).toList(),
                onChanged: onChanged,
              ),
            ),
          ),
        ),
        SizedBox(height: 12),
      ],
    );
  }

  void _validateAndUpdate() {
    if (!_isValidEmail(_emailController.text)) {
      setState(() {
        _emailError = "تأكد من إدخال بريد إلكتروني صحيح";
      });
    } else {
      _emailError = null;
    }
  }

  /// ✅ **دالة التحقق من صحة البريد الإلكتروني**
  bool _isValidEmail(String email) {
    return RegExp(r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$").hasMatch(email);
  }
}
