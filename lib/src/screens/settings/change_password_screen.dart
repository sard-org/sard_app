import 'package:flutter/material.dart';
import '../../../style/BaseScreen.dart';
import '../../../style/Colors.dart';
import '../../../style/Fonts.dart';

class ChangePasswordScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BaseScreen(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 16),
          _buildPasswordField("كلمة المرور القديمة"),
          _buildPasswordField("كلمة المرور الجديدة"),
          _buildPasswordField("تأكيد كلمة المرور الجديدة"),
          Spacer(),
          _buildUpdateButton(),
        ],
      ),
    );
  }

  Widget _buildPasswordField(String label) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: AppTexts.contentRegular),
        SizedBox(height: 8),
        TextField(
          obscureText: true,
          decoration: InputDecoration(
            hintText: "••••••••",
            hintStyle: AppTexts.contentRegular,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide(color: AppColors.primary500)),
            filled: true,
            fillColor: Colors.white,
            suffixIcon: Icon(Icons.visibility_off, color: AppColors.neutral400),
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
