import 'package:flutter/material.dart';
import 'package:sard/style/Colors.dart';
import 'package:sard/style/Fonts.dart';
import 'package:sard/style/BaseScreen.dart'; // استيراد ملف BaseScreen الذي يحتوي على الـ padding

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Directionality(
        textDirection: TextDirection.rtl, // جعل الاتجاه من اليمين إلى اليسار
        child: BookListScreen(),
      ),
    );
  }
}

class BookListScreen extends StatelessWidget {
  final List<Map<String, String>> books = [
    {
      "author": "د.احمد حسين الرفاعي",
      "title": "كيف تكون إنسانا قويا قياديا رائعا محبوبا",
      "description": "انشغلنا نحن العرب بقوة وعظمة الدول المتطورة تكنولوجيا وعلميا واقتصاديا،وضخامتها وعظمة تكنولوجياتها!ليس من منطلق السعي للوصول إلى ما وصلت إليه،",
      "imageUrl": "assets/img/Book_1.png"
    },
    {
      "author": "د.محمد علي",
      "title": "فن القيادة والتأثير في الآخرين",
      "description": "تعلم كيفية التأثير على الآخرين وبناء شخصية قيادية قوية في مختلف المجالات.",
      "imageUrl": "assets/img/Book_1.png"
    },
  ];

  @override
  Widget build(BuildContext context) {
    return BaseScreen(
      child: Column(
        children: [
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
                "كتبي",
                style: AppTexts.heading2Bold.copyWith(
                  color: AppColors.neutral100,
                ),
              ),
            ),
          ),
          SizedBox(height: 18),
          Expanded(
            child: ListView.builder(
              itemCount: books.length * 10, // مضاعفة القائمة مرتين
              itemBuilder: (context, index) {
                final book = books[index % books.length];
                return BookItem(
                  author: book["author"]!,
                  title: book["title"]!,
                  description: book["description"]!,
                  imageUrl: book["imageUrl"]!,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class BookItem extends StatelessWidget {
  final String author;
  final String title;
  final String description;
  final String imageUrl;

  const BookItem({
    required this.author,
    required this.title,
    required this.description,
    required this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Container(
        margin: EdgeInsets.only(bottom: 12),
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
                  image: AssetImage(imageUrl), // استخدام AssetImage بدلاً من NetworkImage
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
                crossAxisAlignment: CrossAxisAlignment.start, // جعل النص يبدأ من جانب الصورة مباشرة
                mainAxisAlignment: MainAxisAlignment.center, // جعل النص في منتصف الكارد عمودياً
                children: [
                  Text(author, textAlign: TextAlign.start, style: AppTexts.footnoteRegular11.copyWith(
                    color: AppColors.neutral400
                  )),
                  SizedBox(height: 4),
                  Text(title, textAlign: TextAlign.start, style: AppTexts.highlightStandard.copyWith(
                    color: AppColors.neutral1000
                  )),
                  SizedBox(height: 8),
                  Text(
                    description,
                    textAlign: TextAlign.start,
                    style: AppTexts.contentRegular.copyWith(
                      color: AppColors.neutral400
                    ),
                    maxLines: 1, // زيادة عدد الأسطر
                    overflow: TextOverflow.ellipsis, // إضافة نقاط (...) عند تجاوز النص
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}