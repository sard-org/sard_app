import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../cubit/global_favorite_cubit.dart';
import '../../../../style/Colors.dart';
import '../../../../style/Fonts.dart';

class BookCardWidget extends StatefulWidget {
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

  @override
  State<BookCardWidget> createState() => _BookCardWidgetState();
}

class _BookCardWidgetState extends State<BookCardWidget> {
  bool _descriptionExpanded = false;

  Widget buildPriceTag() {
    if (widget.isFree) {
      return Text(
        'مجانا',
        style: AppTexts.highlightAccent.copyWith(color: AppColors.primary1000),
      );
    } else if (widget.price != null) {
      return Row(
        children: [
          Text(
            '${widget.price}',
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
    } else if (widget.pricePoints != null) {
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
              '${widget.pricePoints}',
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

  Widget _buildExpandableDescription(String description) {
    if (description.isEmpty) {
      return const SizedBox.shrink();
    }

    // حساب عدد الأسطر التقريبي
    final textStyle = AppTexts.contentRegular.copyWith(color: AppColors.neutral400);
    final textSpan = TextSpan(text: description, style: textStyle);
    final textPainter = TextPainter(
      text: textSpan,
      textDirection: TextDirection.rtl,
      maxLines: 2,
    );
    
    // قياس النص
    textPainter.layout(maxWidth: MediaQuery.of(context).size.width - 150);
    final isTextOverflowing = textPainter.didExceedMaxLines;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          description,
          style: textStyle,
          textAlign: TextAlign.start,
          maxLines: _descriptionExpanded ? null : 2,
          overflow: _descriptionExpanded ? TextOverflow.visible : TextOverflow.ellipsis,
        ),
        if (isTextOverflowing) ...[
          const SizedBox(height: 4),

        ],
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: GestureDetector(
        onTap: widget.onTap,
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
                height: 125,
                decoration: ShapeDecoration(
                  image: DecorationImage(
                    image: widget.imageUrl.startsWith('http')
                        ? NetworkImage(widget.imageUrl) as ImageProvider
                        : AssetImage(widget.imageUrl),
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
                      widget.author,
                      style: AppTexts.captionRegular
                          .copyWith(color: AppColors.neutral400),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      widget.title,
                      style: AppTexts.highlightStandard
                          .copyWith(color: AppColors.neutral1000),
                    ),
                    const SizedBox(height: 8),
                    _buildExpandableDescription(widget.description),
                    const SizedBox(height: 12),
                    buildPriceTag(),
                  ],
                ),
              ),
              BlocBuilder<GlobalFavoriteCubit, GlobalFavoriteState>(
                builder: (context, state) {
                  final globalFavoriteCubit =
                      context.read<GlobalFavoriteCubit>();
                  final isCurrentlyFavorite =
                      globalFavoriteCubit.isFavorite(widget.id);

                  return IconButton(
                    icon: Icon(
                      isCurrentlyFavorite
                          ? Icons.favorite
                          : Icons.favorite_border,
                      color: isCurrentlyFavorite
                          ? Colors.red
                          : AppColors.primary900,
                    ),
                    onPressed: widget.onFavoriteTap ?? () {},
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
