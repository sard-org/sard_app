import 'package:flutter/material.dart';
import '../../../../style/Colors.dart';
import '../../../../style/Fonts.dart';
import '../widgets/BookCardWidget.dart';

class CategoryDetailsPage extends StatelessWidget {
  final int id;
  final Map<int, String> categoryTitles = {
    1: 'فانتازيا',
    2: 'دراما',
    3: 'تحقيق',
    4: 'رعب',
    5: 'تاريخي',
  };

  // Sample books data organized by category ID
  final Map<int, List<Map<String, dynamic>>> booksByCategory = {
    1: [ // فانتازيا
      {
        'author': 'أحمد خالد توفيق',
        'title': 'يوتوبيا',
        'description': 'رواية خيال علمي مصرية تدور أحداثها في مستقبل قريب حول مجتمع منقسم',
        'imageUrl': 'https://picsum.photos/200/300',
        'isFavorite': true,
        'price': 150,
        'isFree': false,
      },
      {
        'author': 'أحمد خالد توفيق',
        'title': 'في ممر الفئران',
        'description': 'رواية فانتازيا مثيرة تجمع بين الرعب والخيال',
        'imageUrl': 'https://picsum.photos/200/301',
        'isFavorite': false,
        'pricePoints': 100,
        'isFree': false,
      },
      {
        'author': 'أحمد خالد توفيق',
        'title': 'السنجة',
        'description': 'قصة فانتازيا مصرية مستوحاة من التراث الشعبي',
        'imageUrl': 'https://picsum.photos/200/302',
        'isFavorite': false,
        'isFree': true,
      },
    ],
    2: [ // دراما
      {
        'author': 'نجيب محفوظ',
        'title': 'أولاد حارتنا',
        'description': 'رواية ملحمية تحكي قصة حارة مصرية على مر الأجيال',
        'imageUrl': 'https://picsum.photos/200/303',
        'isFavorite': true,
        'price': 120,
        'isFree': false,
      },
      {
        'author': 'طه حسين',
        'title': 'دعاء الكروان',
        'description': 'قصة درامية عن الثأر والحب في الريف المصري',
        'imageUrl': 'https://picsum.photos/200/304',
        'isFavorite': false,
        'pricePoints': 80,
        'isFree': false,
      },
      {
        'author': 'يوسف إدريس',
        'title': 'العيب',
        'description': 'مجموعة قصص قصيرة تتناول قضايا اجتماعية',
        'imageUrl': 'https://picsum.photos/200/305',
        'isFavorite': false,
        'isFree': true,
      },
    ],
    3: [ // تحقيق
      {
        'author': 'أجاثا كريستي',
        'title': 'جريمة في قطار الشرق السريع',
        'description': 'رواية بوليسية كلاسيكية من روائع الأدب العالمي',
        'imageUrl': 'https://picsum.photos/200/306',
        'isFavorite': true,
        'price': 180,
        'isFree': false,
      },
      {
        'author': 'آرثر كونان دويل',
        'title': 'مغامرات شيرلوك هولمز',
        'description': 'سلسلة قصص المحقق الشهير شيرلوك هولمز',
        'imageUrl': 'https://picsum.photos/200/307',
        'isFavorite': false,
        'pricePoints': 150,
        'isFree': false,
      },
      {
        'author': 'توفيق الحكيم',
        'title': 'يوميات نائب في الأرياف',
        'description': 'رواية تحقيقية عن الحياة في الريف المصري',
        'imageUrl': 'https://picsum.photos/200/308',
        'isFavorite': false,
        'isFree': true,
      },
    ],
  };

  CategoryDetailsPage({Key? key, required this.id}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final books = booksByCategory[id] ?? [];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 24),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    categoryTitles[id] ?? 'فئة غير معروفة',
                    style: AppTexts.heading1Bold.copyWith(
                      fontSize: 24,
                      color: AppColors.neutral900,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.primary100,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      '${books.length} كتب',
                      style: AppTexts.contentRegular.copyWith(
                        color: AppColors.primary700,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              ...books.map((book) => BookCardWidget(
                    author: book['author'] as String,
                    title: book['title'] as String,
                    description: book['description'] as String,
                    imageUrl: book['imageUrl'] as String,
                    isFavorite: book['isFavorite'] as bool,
                    price: book['price'] as int?,
                    pricePoints: book['pricePoints'] as int?,
                    isFree: book['isFree'] as bool,
                    onTap: () {
                      // Handle book tap
                      print('Book tapped: ${book['title']}');
                    },
                  )),
            ],
          ),
        ),
      ],
    );
  }
}
