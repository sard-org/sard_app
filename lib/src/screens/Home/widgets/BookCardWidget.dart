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
          width: double.infinity, // تأكيد أن الكارد يأخذ العرض الكامل
          height: widget.showDescription ? 180 : 140, // زيادة الارتفاع عند عرض الوصف
          margin: const EdgeInsets.only(bottom: 16),
          padding: const EdgeInsets.all(16),
          decoration: ShapeDecoration(
            color: Colors.white,
            shape: RoundedRectangleBorder(
              side: BorderSide(width: 0.5, color: AppColors.neutral600), // تغيير إلى neutral600
              borderRadius: BorderRadius.circular(12),
            ),
            shadows: [
              BoxShadow(
                color: Colors.black.withOpacity(0.02), // تخفيف الشادو من 0.05 إلى 0.02
                blurRadius: 4, // تقليل الـ blur من 8 إلى 4
                offset: Offset(0, 1), // تقليل الـ offset من 2 إلى 1
              ),
            ],
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 120, // زيادة عرض الصورة أكثر
                height: 160, // زيادة ارتفاع الصورة
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
                  children: [
                    const SizedBox(height: 8),
                    Text(
                      widget.author,
                      style: AppTexts.captionRegular
                          .copyWith(color: AppColors.neutral500),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      widget.title,
                      style: AppTexts.contentAccent
                          .copyWith(
                            color: AppColors.neutral900,
                            fontWeight: FontWeight.w600,
                          ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 12),
                    // إضافة الوصف إذا كان مطلوب عرضه
                    if (widget.showDescription) ...[
                      Expanded(
                        child: Text(
                          widget.description.isNotEmpty ? widget.description : 'لا يوجد وصف متاح',
                          style: AppTexts.captionEmphasis
                              .copyWith(
                                color: AppColors.neutral500,
                                height: 1.5,
                              ),
                          textAlign: TextAlign.start,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(height: 12),
                    ],
                    buildPriceTag(),
                    const SizedBox(height: 4),
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
