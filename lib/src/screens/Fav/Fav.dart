import 'package:flutter/material.dart';
import 'package:sard/style/Colors.dart';
import 'package:sard/style/Fonts.dart';
import 'package:sard/style/BaseScreen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Directionality(
        textDirection: TextDirection.rtl,
        child: FavoritesScreen(),
      ),
    );
  }
}

class FavoritesScreen extends StatefulWidget {
  @override
  _FavoritesScreenState createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  List<Map<String, String>> books = [
    {
      "author": "د.احمد حسين الرفاعي",
      "title": "كيف تكون إنسانا قويا قياديا رائعا محبوبا",
      "description": "انشغلنا نحن العرب بقوة وعظمة الدول المتطورة تكنولوجيا وعلميا واقتصاديا،وضخامتها وعظمة تكنولوجياتها!ليس من منطلق السعي للوصول إلى ما وصلت إليه،",
      "price": "45",
      "currency": "ريال",
      "imageUrl": "assets/img/Book_1.png"
    },
    {
      "author": "د.محمد علي",
      "title": "فن القيادة والتأثير في الآخرين",
      "description": "تعلم كيفية التأثير على الآخرين وبناء شخصية قيادية قوية في مختلف المجالات.",
      "price": "50",
      "currency": "ريال",
      "imageUrl": "assets/img/Book_1.png"
    },
  ];

  void toggleFavorite(int index) {
    setState(() {
      books.removeAt(index);
    });
  }

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
                "المفضلة",
                style: AppTexts.heading2Bold.copyWith(
                  color: AppColors.neutral100,
                ),
              ),
            ),
          ),
          SizedBox(height: 18),
          Expanded(
            child: ListView.builder(
              itemCount: books.length,
              itemBuilder: (context, index) {
                final book = books[index];
                return BookItem(
                  author: book["author"]!,
                  title: book["title"]!,
                  description: book["description"]!,
                  price: book["price"]!,
                  currency: book["currency"]!,
                  imageUrl: book["imageUrl"]!,
                  onFavoritePressed: () => toggleFavorite(index),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class BookItem extends StatefulWidget {
  final String author;
  final String title;
  final String description;
  final String price;
  final String currency;
  final String imageUrl;
  final VoidCallback onFavoritePressed;

  const BookItem({
    required this.author,
    required this.title,
    required this.description,
    required this.price,
    required this.currency,
    required this.imageUrl,
    required this.onFavoritePressed,
  });

  @override
  _BookItemState createState() => _BookItemState();
}

class _BookItemState extends State<BookItem> {
  bool isFavorite = true;
  double size = 1.0;

  void toggleFavorite() {
    setState(() {
      isFavorite = !isFavorite;
      size = 1.2; // تكبير الحجم مؤقتًا
    });

    Future.delayed(Duration(milliseconds: 200), () {
      setState(() {
        size = 1.0; // إعادة الحجم الطبيعي
      });

      if (!isFavorite) {
        widget.onFavoritePressed(); // إزالة العنصر من القائمة
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: AnimatedContainer(
        duration: Duration(milliseconds: 200),
        transform: Matrix4.identity()..scale(size),
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
                  image: AssetImage(widget.imageUrl),
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
                  Text(widget.author, textAlign: TextAlign.start, style: AppTexts.footnoteRegular11.copyWith(
                      color: AppColors.neutral400
                  )),
                  SizedBox(height: 4),
                  Text(widget.title, textAlign: TextAlign.start, style: AppTexts.highlightStandard.copyWith(
                      color: AppColors.neutral1000
                  )),
                  SizedBox(height: 8),
                  Text(
                    widget.description,
                    textAlign: TextAlign.start,
                    style: AppTexts.contentRegular.copyWith(
                        color: AppColors.neutral400
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 8),
                  Row(
                    children: [
                      Text(
                        widget.price,
                        style: AppTexts.highlightAccent.copyWith(color: AppColors.primary1000),
                      ),
                      SizedBox(width: 4),
                      Text(
                        widget.currency,
                        style: AppTexts.footnoteRegular11.copyWith(color: AppColors.primary1000),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            IconButton(
              icon: Icon(
                isFavorite ? Icons.favorite : Icons.favorite_border,
                color: isFavorite ? Colors.red : AppColors.primary900,
              ),
              onPressed: toggleFavorite,
            ),
          ],
        ),
      ),
    );
  }
}
