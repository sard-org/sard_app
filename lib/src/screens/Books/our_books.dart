import 'package:flutter/material.dart';
import 'package:sard/style/Colors.dart';
import 'package:sard/style/Fonts.dart';
import 'package:sard/style/BaseScreen.dart';

import '../AudioBook/audio_book.dart';

class BookListScreen extends StatelessWidget {
  final List<Map<String, String>> books = [
    {
      "author": "د.احمد حسين الرفاعي",
      "title": "كيف تكون إنسانا قويا قياديا رائعا محبوبا",
      "description": "انشغلنا نحن العرب بقوة وعظمة الدول المتطورة تكنولوجيا وعلميا واقتصاديا...",
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
    return Scaffold(
      body: Stack(
        children: [
          BaseScreen(
            child: Column(
              children: [
                SizedBox(height: 80),
                Expanded(
                  child: ListView.builder(
                    itemCount: books.length,
                    itemBuilder: (context, index) {
                      final book = books[index % books.length];
                      return BookItem(
                        author: book["author"]!,
                        title: book["title"]!,
                        description: book["description"]!,
                        imageUrl: book["imageUrl"]!,
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => AudioBookScreen(), // ✅ التنقل إلى صفحة الكتاب الصوتي
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 32, horizontal: 16),
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
  final VoidCallback onTap; // ✅ استدعاء عند الضغط

  const BookItem({
    required this.author,
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.onTap, // ✅ استقبال الدالة
  });

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: GestureDetector(
        onTap: onTap, // ✅ تنفيذ التنقل عند الضغط
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
                    image: AssetImage(imageUrl),
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
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(author, textAlign: TextAlign.start, style: AppTexts.captionRegular.copyWith(
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
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
