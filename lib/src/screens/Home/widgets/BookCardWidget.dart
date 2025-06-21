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
  final bool showDescription; // إضافة parameter للتحكم في عرض الوصف

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
    this.showDescription = false, // القيمة الافتراضية false (مخفي)
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
            Image.asset('assets/img/coin.png', width: 24, height: 24),
            const SizedBox(width: 4),
            Text(
              '${widget.pricePoints}',
              style: AppTexts.highlightAccent.copyWith(
                color: AppColors.primary800,
              ),
            ),
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
          width: double.infinity,
          margin: const EdgeInsets.only(bottom: 16),
          padding: const EdgeInsets.all(16),
          decoration: ShapeDecoration(
            color: AppColors.neutral100,
            shape: RoundedRectangleBorder(
              side: BorderSide( color: AppColors.neutral300),
              borderRadius: BorderRadius.circular(8),
            ),
            shadows: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 4,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 80,
                  height: 120,
                  decoration: ShapeDecoration(
                    image: DecorationImage(
                      image: widget.imageUrl.startsWith('http')
                          ? NetworkImage(widget.imageUrl) as ImageProvider
                          : AssetImage(widget.imageUrl),
                      fit: BoxFit.cover,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.author,
                            style: AppTexts.captionRegular
                                .copyWith(color: AppColors.neutral500),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            widget.title,
                            style: AppTexts.contentBold
                                .copyWith(
                                  color: AppColors.neutral900,
                                  fontSize: 16,
                                ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 8),
                          if (widget.description.isNotEmpty)
                            Expanded(
                              child: Text(
                                widget.description,
                                style: AppTexts.captionRegular
                                    .copyWith(
                                      color: AppColors.neutral600,
                                      height: 1.4,
                                    ),
                                maxLines: 3,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 8),
                    buildPriceTag(),
                  ],
                ),
              ),
              Column(
                children: [
                  BlocBuilder<GlobalFavoriteCubit, GlobalFavoriteState>(
                    builder: (context, state) {
                      final globalFavoriteCubit =
                          context.read<GlobalFavoriteCubit>();
                      final isCurrentlyFavorite =
                          globalFavoriteCubit.isFavorite(widget.id);

                      return IconButton(
                        padding: EdgeInsets.all(4),
                        constraints: BoxConstraints(
                          minWidth: 40,
                          minHeight: 40,
                        ),
                        icon: Icon(
                          isCurrentlyFavorite
                              ? Icons.favorite
                              : Icons.favorite_border,
                          color: isCurrentlyFavorite
                              ? Colors.red
                              : AppColors.neutral500,
                          size: 28,
                        ),
                        onPressed: widget.onFavoriteTap ?? () {},
                      );
                    },
                  ),
                  const Spacer(),
                ],
              ),
            ],
          ),
            ),
        ),
      ),
    );
  }
}
