import 'package:flutter/material.dart';
import '../../../style/BaseScreen.dart';
import '../../../style/Colors.dart';
import '../../../style/Fonts.dart';
import 'audio_book_api_service.dart';
import 'audio_book_model.dart';
import '../../services/book_service.dart';

class AudioBookScreen extends StatefulWidget {
  final String bookId;

  const AudioBookScreen({Key? key, required this.bookId}) : super(key: key);

  @override
  State<AudioBookScreen> createState() => _AudioBookScreenState();
}


class _AudioBookScreenState extends State<AudioBookScreen> {
  late AudioBookApiService _apiService;
  AudioBookResponse? bookData;
  bool isLoading = true;
  String? errorMessage; // Summary functionality
  final BookService _bookService = BookService();
  bool _isLoadingSummary = false;
  String? _summaryError;
  String? _bookSummary;
  bool _isTTSLoading = false;
  StateSetter? _modalSetState; // Add this to store modal setState
  @override
  void initState() {
    super.initState();
    _apiService = AudioBookApiService();
    _loadBookData();
  }

  @override

  Future<void> _loadBookData() async {
    try {
      setState(() {
        isLoading = true;
        errorMessage = null;
      });

      final data = await _apiService.getAudioBook(widget.bookId);
      setState(() {
        bookData = data;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        errorMessage = e.toString();
        isLoading = false;
      });
    }
  }

  void _openAISummary() async {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => StatefulBuilder(builder: (context, setModalState) {
        _modalSetState = setModalState; // Store the modal setState
        return DraggableScrollableSheet(
          initialChildSize: 0.5, // Reduced from 0.75 to 0.5 (50% of screen)
          minChildSize: 0.3, // Reduced from 0.5 to 0.3 (30% minimum)
          maxChildSize: 0.85, // Reduced from 0.95 to 0.85 (85% maximum)
          expand: false,
          builder: (context, scrollController) => Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(28),
                topRight: Radius.circular(28),
              ),
            ),
            child: SafeArea(
              child: Column(
                children: [
                  SizedBox(height: 12),
                  Container(
                    width: 40,
                    height: 5,
                    margin: EdgeInsets.only(bottom: 12),
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(3),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(width: 44),
                      Text(
                        "ملخص الكتاب",
                        style: AppTexts.heading2Bold,
                      ),
                      GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: Container(
                          width: 44,
                          height: 44,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Icon(Icons.arrow_forward,
                              color: AppColors.primary500),
                        ),
                      ),
                    ],
                  ),
                  Expanded(
                    child:
                        _buildSummaryContent(scrollController, setModalState),
                  ),
                  if (!_isLoadingSummary && _summaryError == null)
                    Padding(
                      padding: EdgeInsets.only(bottom: 16),
                      child: GestureDetector(
                        onTap: () => _handleTextToSpeech(),
                        child: Container(
                          width: 60,
                          height: 60,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: _isTTSLoading
                                ? AppColors.primary300
                                : AppColors.primary500,
                          ),
                          child: _isTTSLoading
                              ? SizedBox(
                                  width: 30,
                                  height: 30,
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 2,
                                  ),
                                )
                              : Icon(
                                  Icons.volume_up_outlined,
                                  size: 30,
                                  color: Colors.white,
                                ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        );
      }),
    );

    // Fetch summary if not already loaded
    if (_bookSummary == null && !_isLoadingSummary) {
      _fetchBookSummary();
    }
  }

  Widget _buildSummaryContent(
      ScrollController scrollController, StateSetter setModalState) {
    if (_isLoadingSummary) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary500),
            ),
            SizedBox(height: 16),
            Text(
              'جاري تحميل الملخص...',
              style: AppTexts.contentRegular.copyWith(
                color: AppColors.neutral500,
              ),
            ),
          ],
        ),
      );
    }

    if (_summaryError != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 64,
              color: Colors.red.shade400,
            ),
            SizedBox(height: 16),
            Text(
              _summaryError!,
              style: AppTexts.contentRegular.copyWith(
                color: Colors.red.shade600,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                setModalState(() {
                  _summaryError = null;
                });
                _fetchBookSummary();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary500,
                foregroundColor: Colors.white,
              ),
              child: Text('إعادة المحاولة'),
            ),
          ],
        ),
      );
    }
    return SingleChildScrollView(
      controller: scrollController,
      padding: EdgeInsets.fromLTRB(
          16, 0, 16, 20), // Add bottom padding for better spacing
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: Text(
          _bookSummary ?? 'لا يوجد ملخص متاح',
          style: AppTexts.contentRegular.copyWith(height: 1.8),
          textAlign: TextAlign.right,
        ),
      ),
    );
  }

  Future<void> _fetchBookSummary() async {
    // Update both main widget and modal
    setState(() {
      _isLoadingSummary = true;
      _summaryError = null;
    });
    // Also update modal if it's open
    _modalSetState?.call(() {
      _isLoadingSummary = true;
      _summaryError = null;
    });

    try {
      final summary = await _bookService.getBookSummary(widget.bookId);
      setState(() {
        _bookSummary = summary;
        _isLoadingSummary = false;
      });
      _modalSetState?.call(() {
        _bookSummary = summary;
        _isLoadingSummary = false;
      });
    } catch (e) {
      setState(() {
        _summaryError = e.toString().replaceAll('Exception: ', '');
        _isLoadingSummary = false;
      });
      _modalSetState?.call(() {
        _summaryError = e.toString().replaceAll('Exception: ', '');
        _isLoadingSummary = false;
      });
    }
  }

  Future<void> _handleTextToSpeech() async {
    if (_bookSummary == null || _bookSummary!.isEmpty) {
      // Show snackbar if no summary is available
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('لا يوجد ملخص متاح للتحويل إلى صوت'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }


    try {
      setState(() {
        _isTTSLoading = true;
      });
      _modalSetState?.call(() {
        _isTTSLoading = true;
      });


      setState(() {
        _isTTSLoading = false;
      });
      _modalSetState?.call(() {
        _isTTSLoading = false;
      });
    } catch (e) {
      setState(() {
        _isTTSLoading = false;
      });
      _modalSetState?.call(() {
        _isTTSLoading = false;
      });

      // Show detailed error message
      String errorMessage = e.toString().replaceAll('Exception: ', '');

      // Add debugging information for URL issues
      if (errorMessage.contains('رابط صوتي غير صالح') ||
          errorMessage.contains('جميع الروابط الصوتية غير صالحة')) {
        errorMessage +=
            '\n\nيبدو أن هناك مشكلة في الروابط الصوتية المستلمة من الخادم. يرجى المحاولة مرة أخرى.';
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(errorMessage),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 5), // Show error longer
          action: SnackBarAction(
            label: 'إعادة المحاولة',
            textColor: Colors.white,
            onPressed: () => _handleTextToSpeech(),
          ),
        ),
      );

      // Log error for debugging
      print('TTS Error: $e');
    }
  }

  Widget _buildAppBar(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: 32, horizontal: 18),
      decoration: BoxDecoration(
        color: AppColors.primary500,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(12),
          bottomRight: Radius.circular(12),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Text(
            "تفاصيل الكتاب",
            style: AppTexts.heading2Bold.copyWith(
              color: AppColors.neutral100,
            ),
          ),
          SizedBox(width: 12),
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              width: 50,
              height: 50,
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(Icons.arrow_forward, color: AppColors.primary500),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomBar(BuildContext context) {
    if (bookData == null) return SizedBox.shrink();

    // Determine button text and enabled state
    String buttonText;
    bool isEnabled = true;
    Color buttonColor = AppColors.primary500;

    if (bookData!.isFree) {
      buttonText = 'احصل عليه مجانا';
    } else if (bookData!.price != null) {
      buttonText = 'شراء الكتاب  |  ${bookData!.price} ج.م';
    } else if (bookData!.pricePoints != null) {
      if (bookData!.userPoints != null &&
          bookData!.userPoints! < bookData!.pricePoints!) {
        buttonText = 'ليس لديك نقاط كافية';
        isEnabled = false;
        buttonColor = Colors.grey;
      } else {
        buttonText = 'استبدال بالنقاط  |  ${bookData!.pricePoints} نقاط';
      }
    } else {
      buttonText = 'غير متاح';
      isEnabled = false;
      buttonColor = Colors.grey;
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 8,
            offset: Offset(0, -2),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: buttonColor,
                padding: EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onPressed: isEnabled ? () {} : null,
              child: Text(
                buttonText,
                style: AppTexts.highlightAccent.copyWith(
                  color: isEnabled ? Colors.white : Colors.white70,
                ),
              ),
            ),
          ),
          SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              style: OutlinedButton.styleFrom(
                side: BorderSide(color: AppColors.primary200),
                padding: EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              icon: Icon(Icons.smart_toy_outlined,
                  color: AppColors.primary200, size: 24),
              label: Text('تلخيص بواسطة الذكاء الاصطناعي',
                  style: AppTexts.highlightAccent
                      .copyWith(color: AppColors.primary200)),
              onPressed: () {
                _openAISummary();
              },
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(
                color: AppColors.primary500,
              ),
            )
          : errorMessage != null
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.error_outline,
                        size: 64,
                        color: AppColors.primary600,
                      ),
                      SizedBox(height: 16),
                      Text(
                        'حدث خطأ في تحميل بيانات الكتاب',
                        style: AppTexts.heading3Bold
                            .copyWith(color: AppColors.neutral800),
                      ),
                      SizedBox(height: 8),
                      Text(
                        errorMessage!,
                        style: AppTexts.contentRegular
                            .copyWith(color: AppColors.neutral500),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: _loadBookData,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary500,
                        ),
                        child: Text(
                          'إعادة المحاولة',
                          style: AppTexts.highlightAccent
                              .copyWith(color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                )
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    _buildAppBar(context),
                    Expanded(
                      child: BaseScreen(
                        child: SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              SizedBox(height: 24),
                              // Book Cover (centered)
                              Center(
                                child: Container(
                                  width: 220,
                                  height: 260,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(12),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black26,
                                        blurRadius: 8,
                                        offset: Offset(0, 4),
                                      ),
                                    ],
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(12),
                                    child: Image.network(
                                      bookData!.cover,
                                      fit: BoxFit.cover,
                                      errorBuilder: (context, error, stackTrace) =>
                                          Image.asset(
                                        'assets/img/Book_1.png',
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(height: 24),
                              // Author and Price Row
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  // Price display logic - LEFT SIDE
                                  if (bookData!.isFree)
                                    Text(
                                      'مجانا',
                                      style: AppTexts.heading1Bold.copyWith(
                                        color: Colors.green[800],
                                        fontSize: 28,
                                      ),
                                    )
                                  else if (bookData!.price != null)
                                    RichText(
                                      textDirection: TextDirection.rtl,
                                      text: TextSpan(
                                        children: [
                                          TextSpan(
                                          text: '${bookData!.price}',
                                          style: AppTexts.heading1Bold
                                              .copyWith(
                                            color: Colors.green[800],
                                            fontSize: 28,
                                          ),
                                        ),
                                          TextSpan(
                                            text: 'ج.م',
                                            style: AppTexts.captionRegular
                                                .copyWith(
                                              color: AppColors.neutral500,
                                              fontSize: 18,
                                            ),
                                          ),
                                        ],
                                      ),
                                    )
                                  else if (bookData!.pricePoints != null)
                                    Row(
                                      children: [
                                        Image.asset(
                                          'assets/img/coin.png',
                                          width: 24,
                                          height: 24,
                                        ),
                                        SizedBox(width: 4),
                                        Text(
                                          '${bookData!.pricePoints}',
                                          style:
                                              AppTexts.heading1Bold.copyWith(
                                            color: Colors.green[800],
                                            fontSize: 28,
                                          ),
                                        ),
                                      ],
                                    )
                                  else
                                    SizedBox.shrink(),
                                  // Author info - RIGHT SIDE
                                  Row(
                                    children: [
                                      Text(
                                        bookData!.author.name,
                                        style: AppTexts.highlightEmphasis
                                            .copyWith(
                                                color: AppColors.neutral500),
                                        textAlign: TextAlign.right,
                                      ),
                                      SizedBox(width: 8),
                                      CircleAvatar(
                                        radius: 18,
                                        backgroundImage: NetworkImage(
                                            bookData!.author.photo),
                                        onBackgroundImageError:
                                            (exception, stackTrace) {},
                                        child: bookData!.author.photo.isEmpty
                                            ? Icon(Icons.person)
                                            : null,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              SizedBox(height: 16),
                              // Book Title
                              Text(
                                bookData!.title,
                                style: AppTexts.heading1Bold,
                                textAlign: TextAlign.right,
                              ),
                              SizedBox(height: 12),
                              // Book Description
                              Text(
                                bookData!.description.isNotEmpty
                                    ? bookData!.description
                                    : 'لا يوجد وصف متاح للكتاب',
                                style: AppTexts.contentRegular
                                    .copyWith(color: AppColors.neutral500),
                                textAlign: TextAlign.right,
                              ),
                              SizedBox(height: 12),
                              // Rating
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Text('( ${bookData!.count.reviews} ) ',
                                      style: AppTexts.contentBold.copyWith(
                                          color: AppColors.neutral500)),
                                  SizedBox(width: 6),
                                  ...List.generate(
                                      5,
                                      (index) => Icon(
                                            index < bookData!.rating.floor()
                                                ? Icons.star
                                                : Icons.star_border,
                                            color: Colors.amber,
                                            size: 22,
                                          )),
                                ],
                              ),
                              SizedBox(height: 24),
                              // Removed suggested books section
                              SizedBox(height: 32),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
      bottomNavigationBar: _buildBottomBar(context),
    );
  }
}
