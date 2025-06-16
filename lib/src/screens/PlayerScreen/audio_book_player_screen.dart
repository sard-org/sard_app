import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import '../../../style/BaseScreen.dart';
import '../../../style/Colors.dart';
import '../../../style/Fonts.dart';
import '../../services/book_service.dart';
import '../AudioBook/audio_book_api_service.dart';
import '../AudioBook/audio_book_model.dart';

class AudioBookPlayer extends StatefulWidget {
  final String? bookId;

  const AudioBookPlayer({
    Key? key,
    this.bookId,
  }) : super(key: key);

  @override
  _AudioBookPlayerState createState() => _AudioBookPlayerState();
}

class _AudioBookPlayerState extends State<AudioBookPlayer> {
  double _sliderValue = 0.25; // For demonstration purposes
  bool _isPlaying = false;
  bool _isLoadingSummary = false;
  String? _summaryError;
  String? _bookSummary;
  final BookService _bookService = BookService();
  bool _isTTSLoading = false;
  StateSetter? _modalSetState; // Add this to store modal setState
  AudioPlayer? _audioPlayer;
  String _audioUrl = 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-1.mp3'; // رابط صوتي تجريبي
  AudioBookApiService? _apiService;
  AudioBookResponse? _bookData;
  bool _isLoadingAudio = true;
  String? _audioError;

  // Get book ID from widget or use default
  late final String bookId;
  @override
  void initState() {
    super.initState();
    // Initialize book ID from widget parameter or use default
    bookId = widget.bookId ?? "681f4204645636b8e863c261";
    _audioPlayer = AudioPlayer();
    _apiService = AudioBookApiService();
    _fetchAudioUrl();
  }


  void _togglePlayPause() {
    setState(() {
      _isPlaying = !_isPlaying;
    });
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
                                      Icons.volume_up_outlined,
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
      final summary = await _bookService.getBookSummary(bookId);
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
    String bookTitle = "ما وراء الطبيعة - اسطورة النداهة";
    double screenWidth = MediaQuery.of(context).size.width;
    // تقدير تقريبي: كل 15 بكسل = حرف واحد (يمكنك تعديل الرقم حسب الخط)
    int maxChars = (screenWidth / 15).floor();
    String displayTitle = bookTitle.length > maxChars
        ? bookTitle.substring(0, maxChars) + "..."
        : bookTitle;
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
          Expanded(
            child: Text(
              displayTitle,
              style: AppTexts.heading2Bold.copyWith(
                color: AppColors.neutral100,
              ),
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
              textDirection: TextDirection.rtl,
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
          child: Image.asset(
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
        // Author name with circle avatar
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text(
              'احمد خالد توفيق',
              style: AppTexts.highlightEmphasis
                  .copyWith(color: AppColors.neutral500),
              textAlign: TextAlign.right,
            ),
            SizedBox(width: 8),
            CircleAvatar(
              radius: 16,
              backgroundImage: AssetImage('assets/img/avatar.png'),
            ),
          ],
        ),
        SizedBox(height: 12),
        // Book title
        Text(
          'ما وراء الطبيعة - اسطورة النداهة',
          style: AppTexts.heading2Bold,
          textAlign: TextAlign.right,
        ),
        SizedBox(height: 8),
        // Book description
        Text(
          'وصل خطاب باسمي، تسلمه ( طلعت ) زوج أختي ... يكون أمراً ذا بال يمكنه هو التصرف في لم ير فائدة',
          style: AppTexts.contentRegular.copyWith(color: AppColors.neutral500),
          textAlign: TextAlign.right,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        SizedBox(height: 8),
        // Rating and Add Comment button
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            // النجوم والتقييم
            GestureDetector(
              onTap: () {},
              child: Text(
                'إضافة تعليق',
                style: AppTexts.contentBold.copyWith(
                    color: AppColors.primary700,
                    decoration: TextDecoration.underline),
                textAlign: TextAlign.right,
              ),
            ),
            SizedBox(width: 16),
            Row(
              children: [
                Text('(54)',
                    style: AppTexts.contentBold
                        .copyWith(color: AppColors.neutral500)),
                SizedBox(width: 6),
                ...List.generate(4,
                    (index) => Icon(Icons.star, color: Colors.amber, size: 18)),
                Icon(Icons.star_border, color: Colors.amber, size: 18),
              ],
            ),
            // زر إضافة تعليق
          ],
        ),
      ],
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
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 4,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Icon(icon, size: 24, color: AppColors.primary900),
            if (text != null && textBelow)
              Positioned(
                bottom: 4,
                child: Text(
                  text,
                  style: AppTexts.captionBold.copyWith(
                    color: AppColors.neutral500,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildPlayButton() {
    return GestureDetector(
      onTap: _togglePlayPause,
      child: Container(
        width: 80,
        height: 80,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: AppColors.primary500,
        ),
        child: Icon(
          _isPlaying ? Icons.pause : Icons.play_arrow,
          size: 40,
          color: Colors.white,
        ),
      ),
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

  Future<void> _fetchAudioUrl() async {
    setState(() {
      _isLoadingAudio = true;
      _audioError = null;
    });
    try {
      final data = await _apiService!.getAudioBook(bookId);
      setState(() {
        _bookData = data;
        // لو الـ backend بيرجع audio مباشرة في الـ response
        _audioUrl = (data as dynamic).audio ?? _audioUrl;
        _isLoadingAudio = false;
      });
    } catch (e) {
      setState(() {
        _audioError = e.toString();
        _isLoadingAudio = false;
      });
    }
  }

  void _playSampleAudio() async {
    if (_isLoadingAudio || _audioError != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(_audioError ?? 'جاري تحميل الصوت...')),
      );
      return;
    }
    if (_isPlaying) {
      await _audioPlayer?.stop();
      setState(() {
        _isPlaying = false;
      });
    } else {
      await _audioPlayer?.play(UrlSource(_audioUrl));
      setState(() {
        _isPlaying = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: BaseScreen(
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildAppBar(context),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      SizedBox(height: 24),
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
                        value: _sliderValue,
                        onChanged: (value) {
                          setState(() {
                            _sliderValue = value;
                          });
                        },
                      ),
                    ),
                    // Time markers
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('34:23', style: AppTexts.captionBold),
                          Text('01:23:2', style: AppTexts.captionBold),
                        ],
                      ),
                    ),
                    SizedBox(height: 16),
                    // Playback controls
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _buildCircleButton(
                          icon: Icons.replay_10_outlined,
                          onTap: () {},
                          text: '10',
                          textBelow: true,
                        ),
                        SizedBox(width: 32),
                        _buildPlayButton(),
                        SizedBox(width: 32),
                        _buildCircleButton(
                          icon: Icons.forward_10_outlined,
                          onTap: () {},
                          text: '10',
                          textBelow: true,
                        ),
                      ],
                    ),
                    SizedBox(height: 16),
                    Center(
                      child: _isLoadingAudio
                          ? CircularProgressIndicator()
                          : _audioError != null
                              ? Text('خطأ في تحميل الصوت: $_audioError', style: TextStyle(color: Colors.red))
                              : ElevatedButton.icon(
                                  icon: Icon(_isPlaying ? Icons.stop : Icons.play_arrow),
                                  label: Text(_isPlaying ? 'إيقاف الصوت' : 'تشغيل الصوت'),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.green,
                                    foregroundColor: Colors.white,
                                  ),
                                  onPressed: _playSampleAudio,
                                ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
