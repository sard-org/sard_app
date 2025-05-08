import 'package:flutter/material.dart';
import '../../../style/BaseScreen.dart';
import '../../../style/Colors.dart';
import '../../../style/Fonts.dart';

class AudioBookScreen extends StatelessWidget {
  Widget _buildAppBar(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: 32, horizontal: 18),
      decoration: BoxDecoration(
        color: AppColors.primary500,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(12),
          bottomRight: Radius.circular(12),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Text(
            "تفاصيل الكتاب",
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
              child: Icon(Icons.arrow_forward, color: AppColors.primary500),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSuggestedBooks() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Align(
          alignment: Alignment.centerRight,
          child: Text('كتب مقترحة', style: AppTexts.heading2Bold),
        ),
        SizedBox(height: 12),
        SizedBox(
          height: 190,
          child: Directionality(
            textDirection: TextDirection.rtl,
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
                          crossAxisAlignment: CrossAxisAlignment.end,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'د.أحمد حسين الرفاعي',
                              style: AppTexts.captionRegular.copyWith(
                                color: AppColors.neutral400,
                              ),
                              textAlign: TextAlign.right,
                            ),
                            SizedBox(height: 4),
                            Text(
                              'كيف تكون إنساناً قوياً قيادياً رائعاً محبوباً',
                              style: AppTexts.highlightStandard.copyWith(
                                color: AppColors.neutral1000,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.right,
                            ),
                            SizedBox(height: 4),
                            Text(
                              'انشغلنا بقوة وعظمة الدول المتطورة تكنولوجياً...',
                              style: AppTexts.contentRegular.copyWith(
                                color: AppColors.neutral400,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.right,
                            ),
                          ],
                        ),
                      ),
                      SizedBox(width: 12),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            '19.99 ر.س',
                            style: AppTexts.highlightStandard.copyWith(
                              color: AppColors.primary600,
                            ),
                            textAlign: TextAlign.left,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBottomBar(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 8,
            offset: Offset(0, -2),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary500,
                padding: EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onPressed: () {},
              child: Text('شراء الكتاب  |  396 ج.م', style: AppTexts.highlightAccent.copyWith(color: Colors.white)),
            ),
          ),
          SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              style: OutlinedButton.styleFrom(
                side: BorderSide(color: AppColors.primary200!),
                padding: EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              icon: Icon(Icons.smart_toy_outlined, color: AppColors.primary200, size: 24),
              label: Text('تلخيص بواسطة الذكاء الاصطناعي', style: AppTexts.highlightAccent.copyWith(color: AppColors.primary200)),
              onPressed: () {},
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: BaseScreen(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                _buildAppBar(context),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      SizedBox(height: 24),
                      // Book Cover (centered)
                      Center(
                        child: Container(
                          width: 220,
                          height: 260,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black26,
                                blurRadius: 8,
                                offset: Offset(0, 4),
                              ),
                            ],
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Image.asset(
                              'assets/img/Book_1.png', // Replace with your book cover
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 24),
                      // Price and Author Row
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          RichText(
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text: '396',
                                  style: AppTexts.heading1Bold.copyWith(
                                    color: Colors.green[800],
                                    fontSize: 28,
                                  ),
                                ),
                                TextSpan(
                                  text: ' ج.م',
                                  style: AppTexts.captionRegular.copyWith(
                                    color: AppColors.neutral500,
                                    fontSize: 18,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Row(
                            children: [
                              Text(
                                'احمد خالد توفيق',
                                style: AppTexts.highlightEmphasis.copyWith(color: AppColors.neutral500),
                                textAlign: TextAlign.right,
                              ),
                              SizedBox(width: 8),
                              CircleAvatar(
                                radius: 18,
                                backgroundImage: AssetImage('assets/img/author.png'),
                              ),
                            ],
                          ),
                        ],
                      ),
                      SizedBox(height: 16),
                      // Book Title
                      Text(
                        'ما وراء الطبيعة - اسطورة النداهة',
                        style: AppTexts.heading1Bold,
                        textAlign: TextAlign.right,
                      ),
                      SizedBox(height: 12),
                      // Book Description
                      Text(
                        'وصل خطاب باسمي، تسلمه ( طلعت ) زوج أختي ... يكون أمراً إذا بال يمكنه هو التصرف في لم ير فائدة',
                        style: AppTexts.contentRegular.copyWith(color: AppColors.neutral500),
                        textAlign: TextAlign.right,
                      ),
                      SizedBox(height: 12),
                      // Rating
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text('( 54 ) ', style: AppTexts.contentBold.copyWith(color: AppColors.neutral500)),
                          SizedBox(width: 6),
                          ...List.generate(4, (index) => Icon(Icons.star, color: Colors.amber, size: 22)),
                          Icon(Icons.star_border, color: Colors.amber, size: 22),
                        ],
                      ),
                      SizedBox(height: 24),
                      // Suggested Books
                      _buildSuggestedBooks(),
                      SizedBox(height: 32),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: _buildBottomBar(context),
    );
  }
}
