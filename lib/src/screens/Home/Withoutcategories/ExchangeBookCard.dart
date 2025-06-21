import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../cubit/global_favorite_cubit.dart';
import '../../../../style/Colors.dart';
import '../../../../style/Fonts.dart';

class ExchangeBookCard extends StatelessWidget {
  final String id;
  final String title;
  final String author;
  final String coverUrl;
  final int pricePoints;
  final bool isFavorite;
  final VoidCallback onTap;
  final VoidCallback onFavoriteTap;

  const ExchangeBookCard({
    Key? key,
    required this.id,
    required this.title,
    required this.author,
    required this.coverUrl,
    required this.pricePoints,
    required this.isFavorite,
    required this.onTap,
    required this.onFavoriteTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 150,
        height: 250, // إضافة ارتفاع ثابت
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.neutral300),
          borderRadius: BorderRadius.circular(8),
          color: AppColors.neutral100,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(8),
                    topRight: Radius.circular(8),
                  ),
                  child: Image.network(
                    coverUrl,
                    height: 180,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
                Positioned(
                  top: 8,
                  left: 8,
                  child: BlocBuilder<GlobalFavoriteCubit, GlobalFavoriteState>(
                    builder: (context, state) {
                      final globalFavoriteCubit =
                          context.read<GlobalFavoriteCubit>();
                      final isCurrentlyFavorite =
                          globalFavoriteCubit.isFavorite(id);

                      return GestureDetector(
                        onTap: onFavoriteTap,
                        child: Container(
                          width: 24,
                          height: 24,
                          decoration: BoxDecoration(
                            color: AppColors.neutral100,
                            borderRadius: BorderRadius.circular(2),
                            border: Border.all(
                              color: AppColors.neutral300, // لون البورد، غيّره حسب نظام ألوانك
                              width: 1, // سمك البورد
                            ),
                          ),
                          child: Icon(
                            isCurrentlyFavorite ? Icons.favorite : Icons.favorite_border,
                            size: 16,
                            color: isCurrentlyFavorite ? AppColors.red100 : AppColors.neutral600,
                          ),
                        ),
                      );


                    },
                  ),
                ),
                Positioned(
                  top: 8,
                  right: 8,
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: AppColors.primary100,
                      borderRadius: BorderRadius.circular(2),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Image.asset(
                          'assets/img/coin.png',
                          width: 12,
                          height: 12,
                        ),
                        const SizedBox(width: 2),
                        Text(
                          '$pricePoints',
                          style: AppTexts.contentBold.copyWith(
                            color: AppColors.neutral1000,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),

                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              child: Text(
                author,
                style: AppTexts.contentRegular.copyWith(
                  fontSize: 12,
                  color: AppColors.neutral600,
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Text(
                  title,
                  style: AppTexts.contentBold.copyWith(
                    fontSize: 14,
                    color: AppColors.neutral900,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}
