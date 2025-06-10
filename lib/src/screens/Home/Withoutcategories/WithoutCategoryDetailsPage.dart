import 'package:flutter/material.dart';
import '../../../../style/Colors.dart';
import '../../../../style/Fonts.dart';
import '../categories/CategoryDetailsPage.dart';
import 'ExchangeBookCard.dart';

class WithoutCategoryDetailsPage extends StatelessWidget {
  final List<Map<String, dynamic>> recommendedBooks = [
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
      'author': 'نجيب محفوظ',
      'title': 'أولاد حارتنا',
      'description': 'رواية ملحمية تحكي قصة حارة مصرية على مر الأجيال',
      'imageUrl': 'https://picsum.photos/200/301',
      'isFavorite': false,
      'pricePoints': 100,
      'isFree': false,
    },
    {
      'author': 'طه حسين',
      'title': 'الأيام',
      'description': 'سيرة ذاتية تحكي قصة حياة عميد الأدب العربي',
      'imageUrl': 'https://picsum.photos/200/302',
      'isFavorite': false,
      'isFree': true,
    },
  ];

  final List<Map<String, dynamic>> exchangeBooks = [
    {
      'id': '1',
      'author': 'مارك مانسون',
      'title': 'فن اللامبالاة',
      'coverUrl': 'https://picsum.photos/200/303',
      'pricePoints': 7,
      'isFavorite': false,
    },
    {
      'id': '2',
      'author': 'مارك مانسون',
      'title': 'فن اللامبالاة',
      'coverUrl': 'https://picsum.photos/200/304',
      'pricePoints': 7,
      'isFavorite': false,
    },
    {
      'id': '3',
      'author': 'مارك مانسون',
      'title': 'فن اللامبالاة',
      'coverUrl': 'https://picsum.photos/200/305',
      'pricePoints': 7,
      'isFavorite': false,
    },
  ];

  Widget _buildSectionHeader(String title, int count) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Text(
              title,
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
              child: Row(
                children: [
                  Text(
                    '$count كتب',
                    style: AppTexts.contentRegular.copyWith(
                      color: AppColors.primary700,
                    ),
                  ),
                  if (title == 'ستبدل نقاطك') ...[
                    const SizedBox(width: 4),
                    Image.asset('assets/img/coin.png', width: 16, height: 16),
                  ],
                ],
              ),
            ),
          ],
        ),
        TextButton(
          onPressed: () {
            print('شاهد المزيد: $title');
          },
          child: Text(
            'شاهد المزيد',
            style: AppTexts.contentRegular.copyWith(
              color: AppColors.primary600,
              decoration: TextDecoration.underline,
            ),
          ),
        ),
      ],
    );
  }

  WithoutCategoryDetailsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 24),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSectionHeader('كتب مرشحة لك', recommendedBooks.length),
              const SizedBox(height: 12),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: recommendedBooks.map((book) {
                    return Container(
                      width: 280,
                      margin: EdgeInsets.only(right: 12),
                      child: BookCardWidget(
                        author: book['author'] as String,
                        title: book['title'] as String,
                        description: book['description'] as String,
                        imageUrl: book['imageUrl'] as String,
                        isFavorite: book['isFavorite'] as bool,
                        price: book['price'] as int?,
                        pricePoints: book['pricePoints'] as int?,
                        isFree: book['isFree'] as bool,
                        onTap: () {
                          print('Book tapped: ${book['title']}');
                        },
                      ),
                    );
                  }).toList(),
                ),
              ),
              const SizedBox(height: 24),
              _buildSectionHeader('استبدل نقاطك', exchangeBooks.length),
              const SizedBox(height: 12),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: exchangeBooks.map((book) {
                    return ExchangeBookCard(
                      id: book['id'] as String,
                      title: book['title'] as String,
                      author: book['author'] as String,
                      coverUrl: book['coverUrl'] as String,
                      pricePoints: book['pricePoints'] as int,
                      isFavorite: book['isFavorite'] as bool,
                      onTap: () {
                        print('Book tapped: ${book['title']}');
                      },
                      onFavoriteTap: () {
                        print('Favorite tapped for: ${book['title']}');
                      },
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
} 