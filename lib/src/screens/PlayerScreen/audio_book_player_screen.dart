import 'dart:async';
import 'package:flutter/material.dart';
import '../../../style/BaseScreen.dart';
import '../../../style/Colors.dart';
import '../../../style/Fonts.dart';
import '../../services/book_service.dart';
import '../../services/text_to_speech_service.dart';
import '../../services/audio_book_service.dart';
import '../AudioBook/audio_book_api_service.dart';
import '../AudioBook/audio_book_model.dart';

class AudioBookPlayer extends StatefulWidget {
  final String? bookId;
  final String? orderId;

  const AudioBookPlayer({
    Key? key,
    this.bookId,
    this.orderId,
  }) : super(key: key);

  @override
  _AudioBookPlayerState createState() => _AudioBookPlayerState();
}

class _AudioBookPlayerState extends State<AudioBookPlayer> {
  bool _isLoadingSummary = false;
  String? _summaryError;
  String? _bookSummary;
  final BookService _bookService = BookService();
  final TextToSpeechService _ttsService = TextToSpeechService();
  final AudioBookService _audioBookService = AudioBookService();
  bool _isTTSLoading = false;
  StateSetter? _modalSetState; // Add this to store modal setState
  AudioBookApiService? _apiService;
  AudioBookContentResponse? _bookData;
  bool _isLoadingAudio = true;
  String? _audioError;
  bool _isPlaying = false;
  Timer? _playbackTimer;
  bool _isSubmittingRating = false;
  bool _descriptionExpanded = false; // إضافة متغير لتتبع حالة التوسع

  // Get book ID and order ID from widget
  late final String? bookId;
  late final String? orderId;
  @override
  void initState() {
    super.initState();
    // Initialize book ID and order ID from widget parameters
    bookId = widget.bookId;
    orderId = widget.orderId;
    _apiService = AudioBookApiService();
    _loadAudioBook();
    _startPlaybackTimer();
  }

  @override
  void dispose() {
    _playbackTimer?.cancel();
    _audioBookService.dispose();
    _ttsService.dispose();
    super.dispose();
  }

  void _startPlaybackTimer() {
    _playbackTimer = Timer.periodic(Duration(milliseconds: 500), (timer) {
      if (mounted) {
        final currentlyPlaying = _audioBookService.isPlaying;
        if (_isPlaying != currentlyPlaying) {
          setState(() {
            _isPlaying = currentlyPlaying;
          });
        }
      }
    });
  }

  Future<void> _loadAudioBook() async {
    if (orderId == null) {
      setState(() {
        _audioError = 'معرف الطلب غير متوفر';
        _isLoadingAudio = false;
      });
      return;
    }

    setState(() {
      _isLoadingAudio = true;
      _audioError = null;
    });

    try {
      final bookContent = await _audioBookService.loadBookByOrderId(orderId!);
      setState(() {
        _bookData = bookContent;
        _isLoadingAudio = false;
      });
      print('Audio book loaded successfully: ${bookContent.title}');
    } catch (e) {
      setState(() {
        _audioError = e.toString();
        _isLoadingAudio = false;
      });
      print('Error loading audio book: $e');
    }
  }

  void _togglePlayPause() async {
    if (_audioBookService.isLoading) return;

    try {
      if (_audioBookService.isPlaying) {
        await _audioBookService.pauseAudio();
        _isPlaying = false;
      } else {
        if (_audioBookService.currentBook == null) {
          // Load the book first if not loaded
          await _loadAudioBook();
        }
        await _audioBookService.playAudioBook();
        _isPlaying = true;
      }
      setState(() {}); // Update UI
    } catch (e) {
      _isPlaying = false;
      setState(() {});
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Directionality(
            textDirection: TextDirection.rtl,
            child: Text('خطأ في تشغيل الصوت: $e'),
          ),
          backgroundColor: Colors.red,
        ),
      );
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
                    Column(
                      children: [
                        Padding(
                          padding:
                              EdgeInsets.only(bottom: 16), // Add bottom margin
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
                                      _ttsService.isPlaying
                                          ? Icons.stop
                                          : Icons.volume_up_outlined,
                                      size: 30,
                                      color: Colors.white,
                                    ),
                            ),
                          ),
                        ),
                      ],
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
          _bookSummary ?? '',
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
      // Try to fetch AI-generated summary from API first
      String summary;
      try {
        if (bookId != null) {
          summary = await _apiService!.getBookSummary(bookId!);
          print(
              'AI Summary fetched successfully: ${summary.length} characters');
        } else {
          throw Exception('معرف الكتاب غير متوفر');
        }
      } catch (apiError) {
        print('API Summary failed: $apiError');
        // Fallback to book description if API fails
        if (_bookData?.description != null &&
            _bookData!.description.isNotEmpty) {
          summary = _bookData!.description;
          print('Using book description as fallback summary');
        } else {
          // If no description available, throw the original API error
          throw apiError;
        }
      }

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

  Widget _buildAppBar(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top + 16,
        bottom: 24,
        left: 16,
        right: 16,
      ),
      decoration: BoxDecoration(
        color: AppColors.primary500,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(12),
          bottomRight: Radius.circular(12),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              _bookData?.title ?? "",
              style: AppTexts.heading2Bold.copyWith(
                color: AppColors.neutral100,
              ),
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
              textAlign: TextAlign.right,
              textDirection: TextDirection.rtl,
            ),
          ),
          SizedBox(width: 16),
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              width: 44,
              height: 44,
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

  Widget _buildBookCover() {
    return Center(
      child: Container(
        width: 220,
        height: 320,
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
          child: _bookData?.cover != null
              ? Image.network(
                  _bookData!.cover,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Image.asset(
                    'assets/img/Book_1.png',
                    fit: BoxFit.cover,
                  ),
                )
              : Image.asset(
                  'assets/img/Book_1.png',
                  fit: BoxFit.cover,
                ),
        ),
      ),
    );
  }

  Widget _buildBookInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        // Author name
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text(
              _bookData?.author.name ?? '',
              style: AppTexts.highlightEmphasis
                  .copyWith(color: AppColors.neutral500),
              textAlign: TextAlign.right,
            ),
          ],
        ),
        SizedBox(height: 12),
        // Book title
        Text(
          _bookData?.title ?? '',
          style: AppTexts.heading2Bold,
          textAlign: TextAlign.right,
        ),
        SizedBox(height: 8),
        // Book description
        _buildExpandableDescription(_bookData?.description ?? ''),
        SizedBox(height: 8),
        // Book categories if available
        if (_bookData != null && _bookData!.bookCategory.isNotEmpty)
          Padding(
            padding: EdgeInsets.only(bottom: 8),
            child: Wrap(
              alignment: WrapAlignment.end,
              children: _bookData!.bookCategory.map((bookCat) {
                return Container(
                  margin: EdgeInsets.only(left: 4, bottom: 4),
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.primary100,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    bookCat.category.name,
                    style: AppTexts.captionBold.copyWith(
                      color: AppColors.primary700,
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        // Rating and Add Comment button
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            // النجوم والتقييم
            GestureDetector(
              onTap: _showRatingDialog,
              child: Text(
                'إضافة تقييم',
                style: AppTexts.contentBold.copyWith(
                    color: AppColors.primary700,
                    decoration: TextDecoration.underline),
                textAlign: TextAlign.right,
              ),
            ),
            SizedBox(width: 16),
            Row(
              children: [
                Text('(${_bookData?.count.reviews ?? 0})',
                    style: AppTexts.contentBold
                        .copyWith(color: AppColors.neutral500)),
                SizedBox(width: 6),
                ...List.generate(
                  5,
                  (index) => Icon(
                    index < (_bookData?.rating ?? 0).floor()
                        ? Icons.star
                        : Icons.star_border,
                    color: Colors.amber,
                    size: 18,
                  ),
                ),
              ],
            ),
            // زر إضافة تقييم
          ],
        ),
      ],
    );
  }

  Widget _buildExpandableDescription(String description) {
    if (description.isEmpty) {
      return const SizedBox.shrink();
    }

    // حساب عدد الأسطر التقريبي
    final textStyle = AppTexts.contentRegular.copyWith(color: AppColors.neutral500);
    final textSpan = TextSpan(text: description, style: textStyle);
    final textPainter = TextPainter(
      text: textSpan,
      textDirection: TextDirection.rtl,
      maxLines: 2,
    );
    
    // قياس النص
    textPainter.layout(maxWidth: MediaQuery.of(context).size.width - 32);
    final isTextOverflowing = textPainter.didExceedMaxLines;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(
          description,
          style: textStyle,
          textAlign: TextAlign.right,
          maxLines: _descriptionExpanded ? null : 2,
          overflow: _descriptionExpanded ? TextOverflow.visible : TextOverflow.ellipsis,
        ),
        if (isTextOverflowing) ...[
          const SizedBox(height: 4),
          GestureDetector(
            onTap: () {
              setState(() {
                _descriptionExpanded = !_descriptionExpanded;
              });
            },
            child: Text(
              _descriptionExpanded ? 'عرض أقل' : 'قراءة المزيد',
              style: AppTexts.contentAccent.copyWith(
                color: AppColors.primary500,
                fontWeight: FontWeight.w600,
                decoration: TextDecoration.underline
              ),
            ),
          ),
        ],
      ],
    );
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

    if (_ttsService.isPlaying) {
      // Stop current audio if playing
      await _ttsService.pauseAudio();
      setState(() {});
      _modalSetState?.call(() {});
      return;
    }

    try {
      setState(() {
        _isTTSLoading = true;
      });
      _modalSetState?.call(() {
        _isTTSLoading = true;
      });

      await _ttsService.convertTextToSpeech(_bookSummary!);

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

      // Parse error message and provide helpful solutions
      String errorMessage = e.toString().replaceAll('Exception: ', '');
      String solutionText = '';

      // Check for specific error types and provide targeted solutions
      if (errorMessage.contains('CORS') ||
          errorMessage.contains('XMLHttpRequest') ||
          errorMessage.contains('قيود الأمان') ||
          errorMessage.contains('المتصفح')) {
        solutionText = '''
💡 نصائح لحل المشكلة:
• استخدم التطبيق على الهاتف المحمول
• جرب متصفح مختلف (Chrome أو Firefox)
• تأكد من السماح بتشغيل الصوت في المتصفح
• تحقق من اتصال الإنترنت
        ''';
      } else if (errorMessage.contains('انتهت مهلة')) {
        solutionText = '''
💡 يبدو أن هناك مشكلة في الاتصال:
• تحقق من اتصال الإنترنت
• أعد المحاولة بعد قليل
• تأكد من استقرار الشبكة
        ''';
      } else if (errorMessage.contains('رابط صوتي غير صالح')) {
        solutionText = '''
💡 مشكلة في الروابط الصوتية:
• أعد المحاولة 
• تحقق من تحديث التطبيق
• تواصل مع الدعم الفني إذا استمرت المشكلة
        ''';
      }

      // Show error dialog instead of snackbar for better user experience
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Row(
              children: [
                Icon(Icons.error_outline, color: Colors.red),
                SizedBox(width: 8),
                Text('خطأ في تشغيل الصوت'),
              ],
            ),
            content: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'تفاصيل الخطأ:',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  Text(errorMessage),
                  if (solutionText.isNotEmpty) ...[
                    SizedBox(height: 16),
                    Text(
                      solutionText,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text('إغلاق'),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  _handleTextToSpeech(); // Retry
                },
                child: Text('إعادة المحاولة'),
              ),
            ],
          );
        },
      );

      // Log error for debugging
      print('TTS Error: $e');
    }
  }

  void _playSampleAudio() async {
    if (_isLoadingAudio || _audioError != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Directionality(
            textDirection: TextDirection.rtl,
            child: Text(_audioError ?? 'جاري تحميل الصوت...'),
          ),
        ),
      );
      return;
    }

    try {
      if (_audioBookService.isPlaying) {
        await _audioBookService.stopAudio();
      } else {
        await _audioBookService.playAudioBook();
      }
      setState(() {});
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Directionality(
            textDirection: TextDirection.rtl,
            child: Text('خطأ في تشغيل الصوت: $e'),
          ),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Widget _buildPlayButton() {
    return GestureDetector(
      onTap: _togglePlayPause,
      child: Container(
        width: 70,
        height: 70,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: AppColors.primary500,
          boxShadow: [
            BoxShadow(
              color: AppColors.primary500.withOpacity(0.3),
              blurRadius: 12,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Icon(
          (_audioBookService.isPlaying || _isPlaying)
              ? Icons.pause
              : Icons.play_arrow,
          size: 35,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget _buildCircleButton({
    required IconData icon,
    required VoidCallback onTap,
    String? text,
    bool textBelow = false,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 50,
        height: 50,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white,
          border: Border.all(color: AppColors.neutral400, width: 1),
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Icon(icon, size: 24, color: AppColors.neutral700),
            if (text != null && textBelow)
              Positioned(
                bottom: 4,
                child: Text(
                  text,
                  style: TextStyle(
                    fontSize: 8,
                    fontWeight: FontWeight.bold,
                    color: AppColors.neutral700,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  void _showRatingDialog() {
    int hoveredRating = 0; // Track which star is being hovered/touched
    int selectedRating = 0; // Track selected rating

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              title: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                        style: AppTexts.heading2Bold,
                        children: [
                          TextSpan(text: 'تقييم '  ,
                              style: AppTexts.heading2Bold.copyWith(
                                color: AppColors.neutral1000,
                              ),),

                          TextSpan(
                            text: 'الكتاب',
                            style: AppTexts.heading2Bold.copyWith(
                              color: AppColors.primary500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'كم نجمة تعطي لهذا الكتاب؟',
                    style: AppTexts.contentRegular,
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 24),
                  // Stars with hover effect (RTL - Right to Left)
                  Container(
                    padding: EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: AppColors.primary100 ?? AppColors.primary100.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: AppColors.primary200.withOpacity(0.5),
                        width: 1,
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(5, (index) {
                        final starNumber = 5 - index; // Reverse for RTL
                        final isActive = (hoveredRating > 0
                                ? hoveredRating
                                : selectedRating) >=
                            starNumber;

                        return GestureDetector(
                          onTap: _isSubmittingRating
                              ? null
                              : () {
                                  setDialogState(() {
                                    selectedRating = starNumber;
                                    hoveredRating =
                                        0; // Reset hover when selected
                                  });
                                },
                          onTapDown: (_) {
                            if (!_isSubmittingRating) {
                              setDialogState(() {
                                hoveredRating = starNumber;
                              });
                            }
                          },
                          onTapCancel: () {
                            setDialogState(() {
                              hoveredRating = 0;
                            });
                          },
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 4),
                            child: AnimatedContainer(
                              duration: Duration(milliseconds: 150),
                              child: Icon(
                                isActive ? Icons.star : Icons.star_border,
                                size: 40,
                                color: isActive
                                    ? (hoveredRating == starNumber
                                        ? Colors.amber.shade400
                                        : Colors.amber)
                                    : Colors.grey.shade400,
                              ),
                            ),
                          ),
                        );
                      }),
                    ),
                  ),
                  SizedBox(height: 16),
                  // Show selected rating text
                  if (selectedRating > 0) ...[
                    Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: AppColors.primary100,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        'التقييم المختار: $selectedRating ${_getRatingText(selectedRating)}',
                        style: AppTexts.contentBold.copyWith(
                          color: AppColors.primary700,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    SizedBox(height: 12),
                    // Action buttons
                    Column(
                      children: [
                        // Confirm button
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: _isSubmittingRating
                                ? null
                                : () async {
                                    await _submitRating(
                                        selectedRating, setDialogState);
                                  },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primary500,
                              foregroundColor: Colors.white,
                              padding: EdgeInsets.symmetric(vertical: 12),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: Text(
                              'تأكيد التقييم',
                              style: AppTexts.contentBold,
                            ),
                          ),
                        ),
                        SizedBox(height: 8),
                        // Cancel button
                        SizedBox(
                          width: double.infinity,
                          child: OutlinedButton(
                            onPressed: _isSubmittingRating
                                ? null
                                : () => Navigator.of(context).pop(),
                            style: OutlinedButton.styleFrom(
                              side: BorderSide(color: AppColors.primary500),
                              foregroundColor: AppColors.primary500,
                              padding: EdgeInsets.symmetric(vertical: 12),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: Text(
                              'إلغاء',
                              style: AppTexts.contentBold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ] else ...[
                    Text(
                      'اضغط على النجوم لاختيار التقييم',
                      style: AppTexts.captionRegular.copyWith(
                        color: AppColors.neutral500,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                  if (_isSubmittingRating) ...[
                    SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: AppColors.primary500,
                          ),
                        ),
                        SizedBox(width: 12),
                        Text(
                          'جاري إرسال التقييم...',
                          style: AppTexts.contentRegular.copyWith(
                            color: AppColors.neutral500,
                          ),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
              actions: [],
            );
          },
        );
      },
    );
  }

  String _getRatingText(int rating) {
    switch (rating) {
      case 1:
        return '⭐ (ضعيف)';
      case 2:
        return '⭐⭐ (مقبول)';
      case 3:
        return '⭐⭐⭐ (جيد)';
      case 4:
        return '⭐⭐⭐⭐ (ممتاز)';
      case 5:
        return '⭐⭐⭐⭐⭐ (رائع)';
      default:
        return '';
    }
  }

  Future<void> _submitRating(int rating, StateSetter setDialogState) async {
    if (bookId == null) {
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Directionality(
            textDirection: TextDirection.rtl,
            child: Text('معرف الكتاب غير متوفر'),
          ),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setDialogState(() {
      _isSubmittingRating = true;
    });
    try {
      await _bookService.addBookReview(bookId!, rating);

      Navigator.of(context).pop(); // Close dialog

      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Directionality(
            textDirection: TextDirection.rtl,
            child: Text('تم إضافة تقييمك بنجاح! شكراً لك'),
          ),
          backgroundColor: Colors.green,
          duration: Duration(seconds: 3),
        ),
      );

      // Optionally, refresh the book data to show updated rating
      // You might want to reload the book data here if needed
    } catch (e) {
      setDialogState(() {
        _isSubmittingRating = false;
      });

      String errorMessage = e.toString().replaceAll('Exception: ', '');

      // Handle specific error messages
      if (errorMessage.contains('already reviewed') ||
          errorMessage.contains('لقد قمت بتقييم')) {
        Navigator.of(context).pop(); // Close dialog

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Directionality(
              textDirection: TextDirection.rtl,
              child: Text('لقد قمت بتقييم هذا الكتاب مسبقاً'),
            ),
            backgroundColor: Colors.orange,
            duration: Duration(seconds: 3),
          ),
        );
      } else {
        // Show error in dialog
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('خطأ في التقييم'),
              content: Text(errorMessage),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text('موافق'),
                ),
              ],
            );
          },
        );
      }
    }

    setState(() {
      _isSubmittingRating = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          _buildAppBar(context),
          Expanded(
            child: BaseScreen(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          const SizedBox(height: 16),
                          _buildBookCover(),
                          SizedBox(height: 24),
                          _buildBookInfo(),
                          SizedBox(height: 32),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    color: Colors.white,
                    child: Column(
                      children: [
                        // AI Summary Button
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
                            onPressed: _openAISummary,
                          ),
                        ),
                        SizedBox(height: 24),
                        // Progress Slider
                        SliderTheme(
                          data: SliderThemeData(
                            trackHeight: 4,
                            thumbShape:
                                RoundSliderThumbShape(enabledThumbRadius: 8),
                            overlayShape:
                                RoundSliderOverlayShape(overlayRadius: 16),
                            activeTrackColor: AppColors.primary500,
                            inactiveTrackColor: Colors.grey.shade300,
                            thumbColor: AppColors.primary500,
                          ),
                          child: Slider(
                            value: _audioBookService.progress,
                            onChanged: (value) {
                              // TODO: Implement seek functionality
                            },
                          ),
                        ),
                        // Progress indicators
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                (_audioBookService.isPlaying || _isPlaying)
                                    ? 'يتم التشغيل...'
                                    : 'متوقف',
                                style: AppTexts.captionBold,
                              ),
                              Text(
                                '${(_bookData?.duration ?? 0) } ثانية ',
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 16),
                        // Playback controls
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            _buildCircleButton(
                              icon: Icons.replay_10,
                              onTap: () {
                                // TODO: Implement 10 second rewind
                                print('Rewind 10 seconds');
                              },
                            ),
                            SizedBox(width: 32),
                            _buildPlayButton(),
                            SizedBox(width: 32),
                            _buildCircleButton(
                              icon: Icons.forward_10,
                              onTap: () {
                                // TODO: Implement 10 second forward
                                print('Forward 10 seconds');
                              },
                            ),
                          ],
                        ),
                        SizedBox(height: 16),
                        Center(
                          child: _isLoadingAudio
                              ? Column(
                                  children: [
                                    CircularProgressIndicator(
                                      color: AppColors.primary500,
                                    ),
                                    SizedBox(height: 8),
                                    Text(
                                      'جاري تحميل الكتاب الصوتي...',
                                      style: AppTexts.contentRegular.copyWith(
                                        color: AppColors.neutral500,
                                      ),
                                    ),
                                  ],
                                )
                              : _audioError != null
                                  ? Column(
                                      children: [
                                        Icon(
                                          Icons.error_outline,
                                          size: 32,
                                          color: Colors.red,
                                        ),
                                        SizedBox(height: 8),
                                        Text(
                                          'خطأ في تحميل الصوت: $_audioError',
                                          style: TextStyle(color: Colors.red),
                                          textAlign: TextAlign.center,
                                        ),
                                        SizedBox(height: 8),
                                        ElevatedButton(
                                          onPressed: _loadAudioBook,
                                          child: Text('إعادة المحاولة'),
                                        ),
                                      ],
                                    )
                                  : SizedBox.shrink(),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
