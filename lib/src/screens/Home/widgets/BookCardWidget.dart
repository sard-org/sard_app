import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../cubit/global_favorite_cubit.dart';
import '../../../../style/Colors.dart';
import '../../../../style/Fonts.dart';

class BookCardWidget extends StatelessWidget {
  final String id;
  final String author;
  final String title;
  final String description;
  final String imageUrl;
  final VoidCallback onTap;
  final VoidCallback? onFavoriteTap;
  final bool is_favorite;
  final int? price;
  final int? pricePoints;
  final bool isFree;

  const BookCardWidget({
    required this.id,
    required this.author,
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.onTap,
    this.onFavoriteTap,
    required this.is_favorite,
    this.price,
    this.pricePoints,
    required this.isFree,
    super.key,
  });

  Widget buildPriceTag() {
    if (isFree) {
      return Text(
        'مجانا',
        style: AppTexts.highlightAccent.copyWith(color: AppColors.primary1000),
      );
    } else if (price != null) {
      return Row(
        children: [
          Text(
            '$price',
            style:
                AppTexts.highlightAccent.copyWith(color: AppColors.primary1000),
          ),
          const SizedBox(width: 2),
          Text(
            'ج.م',
            style: AppTexts.footnoteRegular11
                .copyWith(color: AppColors.primary1000),
          ),
        ],
      );
    } else if (pricePoints != null) {
      return Container(
        padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: AppColors.primary100,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              '$pricePoints',
              style: AppTexts.highlightAccent
                  .copyWith(color: AppColors.primary800),
            ),
            const SizedBox(width: 4),
            Image.asset('assets/img/coin.png', width: 20, height: 20),
          ],
        ),
      );
    } else {
      return SizedBox();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(12),
          decoration: ShapeDecoration(
            color: const Color(0xFFFCFEF5),
            shape: RoundedRectangleBorder(
              side: const BorderSide(width: 0.50, color: AppColors.primary900),
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 93,
                height: 155,
                decoration: ShapeDecoration(
                  image: DecorationImage(
                    image: imageUrl.startsWith('http')
                        ? NetworkImage(imageUrl) as ImageProvider
                        : AssetImage(imageUrl),
                    fit: BoxFit.fill,
                  ),
                  shape: RoundedRectangleBorder(
                    side: const BorderSide(width: 2, color: Color(0xFF2B2B2B)),
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      author,
                      style: AppTexts.captionRegular
                          .copyWith(color: AppColors.neutral400),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      title,
                      style: AppTexts.highlightStandard
                          .copyWith(color: AppColors.neutral1000),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      description,
                      style: AppTexts.contentRegular
                          .copyWith(color: AppColors.neutral400),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),
                    buildPriceTag(),
                  ],
                ),
              ),
              BlocBuilder<GlobalFavoriteCubit, GlobalFavoriteState>(
                builder: (context, state) {
                  final globalFavoriteCubit =
                      context.read<GlobalFavoriteCubit>();
                  final isCurrentlyFavorite =
                      globalFavoriteCubit.isFavorite(id);

                  return IconButton(
                    icon: Icon(
                      isCurrentlyFavorite
                          ? Icons.favorite
                          : Icons.favorite_border,
                      color: isCurrentlyFavorite
                          ? Colors.red
                          : AppColors.primary900,
                    ),
                    onPressed: onFavoriteTap ?? () {},
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
