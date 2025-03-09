import 'package:flutter/material.dart';
import '../../../style/BaseScreen.dart';
import '../../../style/Colors.dart';
import '../../../style/Fonts.dart';

class EditProfileScreen extends StatefulWidget {
  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  String? emailError;
  String? phoneError;
  String selectedGender = "ذكر"; // القيمة الافتراضية للنوع

  void validateEmail() {
    setState(() {
      if (!emailController.text.contains("@") || !emailController.text.contains(".")) {
        emailError = "تأكد من إدخال بريد إلكتروني صحيح";
      } else {
        emailError = null;
      }
    });
  }

  void validatePhone(String value) {
    setState(() {
      if (!RegExp(r'^[0-9]+$').hasMatch(value)) {
        phoneError = "يجب إدخال أرقام فقط";
      } else {
        phoneError = null;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return BaseScreen(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildAppBar(context),
          SizedBox(height: 16),
          Center(child: CircleAvatar(radius: 40, backgroundImage: AssetImage("assets/img/profile.png"))),
          SizedBox(height: 16),
          _buildTextField("الاسم", "أحمد حسام"),
          _buildEmailField(),
          _buildPhoneField(),
          _buildDropdownField("النوع", ["ذكر", "أنثى"]),
          _buildTextField("تاريخ الميلاد", "اختر تاريخ الميلاد", icon: Icons.calendar_today),
          Spacer(),
          _buildUpdateButton(),
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
        children: [
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
              child: Icon(Icons.arrow_back, color: AppColors.primary500),
            ),
          ),
          SizedBox(width: 12),
          Text(
            "تعديل البيانات",
            style: AppTexts.heading2Bold.copyWith(
              color: AppColors.neutral100,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField(String label, String hint, {IconData? icon}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(label, style: AppTexts.contentRegular, textAlign: TextAlign.right),
        SizedBox(height: 8),
        TextField(
          textAlign: TextAlign.right,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: AppTexts.contentRegular,
            prefixIcon: icon != null ? Icon(icon, color: AppColors.neutral400) : null,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide(color: AppColors.neutral400)),
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
        Text("البريد الإلكتروني", style: AppTexts.contentRegular, textAlign: TextAlign.right),
        SizedBox(height: 8),
        TextField(
          controller: emailController,
          textAlign: TextAlign.right,
          decoration: InputDecoration(
            hintText: "ahmdhsamhmd2@gmail.com",
            hintStyle: AppTexts.contentRegular,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide(color: AppColors.neutral400)),
            filled: true,
            fillColor: Colors.white,
          ),
          onChanged: (value) => validateEmail(),
        ),
        if (emailError != null)
          Padding(
            padding: EdgeInsets.only(top: 4, right: 8),
            child: Align(
              alignment: Alignment.centerRight,
              child: Text(emailError!, style: TextStyle(color: Colors.red, fontSize: 12)),
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
        Text("رقم الهاتف", style: AppTexts.contentRegular, textAlign: TextAlign.right),
        SizedBox(height: 8),
        TextField(
          controller: phoneController,
          keyboardType: TextInputType.number,
          textAlign: TextAlign.right,
          decoration: InputDecoration(
            hintText: "01023359621",
            hintStyle: AppTexts.contentRegular,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide(color: AppColors.neutral400)),
            filled: true,
            fillColor: Colors.white,
          ),
          onChanged: (value) => validatePhone(value),
        ),
        if (phoneError != null)
          Padding(
            padding: EdgeInsets.only(top: 4, right: 8),
            child: Align(
              alignment: Alignment.centerRight,
              child: Text(phoneError!, style: TextStyle(color: Colors.red, fontSize: 12)),
            ),
          ),
        SizedBox(height: 12),
      ],
    );
  }

  Widget _buildDropdownField(String label, List<String> options) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(label, style: AppTexts.contentRegular, textAlign: TextAlign.right),
        SizedBox(height: 8),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            border: Border.all(color: AppColors.neutral400),
            borderRadius: BorderRadius.circular(8),
            color: Colors.white,
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              isExpanded: true,
              value: selectedGender,
              onChanged: (String? newValue) {
                setState(() {
                  selectedGender = newValue!;
                });
              },
              items: options.map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value, textAlign: TextAlign.right),
                );
              }).toList(),
            ),
          ),
        ),
        SizedBox(height: 12),
      ],
    );
  }

  Widget _buildUpdateButton() {
    return ElevatedButton(
      onPressed: () {},
      style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary500, minimumSize: Size(double.infinity, 50)),
      child: Text("تحديث", style: TextStyle(color: Colors.white, fontSize: 16)),
    );
  }
}
