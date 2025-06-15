import 'package:dio/dio.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'dart:html' as html;
import '../screens/Books/data/dio_client.dart';

class TextToSpeechService {
  final Dio _dio = DioClient.dio;
  late AudioPlayer _audioPlayer;
  html.AudioElement? _webAudioElement; // For web-specific audio
  List<Map<String, String>> _audioUrls = [];
  int _currentIndex = 0;
  bool _isPlaying = false;
  TextToSpeechService() {
    _audioPlayer = AudioPlayer();
    _setupAudioPlayerListeners();

    // Configure for web if running on web
    if (kIsWeb) {
      _audioPlayer.setPlayerMode(PlayerMode.lowLatency);
    }
  }
  void _setupAudioPlayerListeners() {
    _audioPlayer.onPlayerStateChanged.listen((PlayerState state) {
      print('Audio player state changed: $state');
      if (state == PlayerState.completed) {
        print('Audio completed, playing next...');
        _playNext();
      } else if (state == PlayerState.stopped) {
        print('Audio stopped');
        _isPlaying = false;
      }
    });

    // Listen for errors
    _audioPlayer.onLog.listen((String message) {
      print('AudioPlayer log: $message');
    });
  }

  Future<void> convertTextToSpeech(String text) async {
    try {
      // Reset state
      _audioUrls.clear();
      _currentIndex = 0;
      _isPlaying = false;

      // Stop any currently playing audio
      await _audioPlayer.stop();

      // Prepare audio for web (handle autoplay policies)
      if (kIsWeb) {
        print('Preparing audio for web platform...');
        await prepareAudioForWeb();

        // Check if user has interacted with the page (required for autoplay)
        print(
            'Note: Web audio requires user interaction for autoplay policy compliance');
      }

      // Validate input text
      if (text.trim().isEmpty) {
        throw Exception('النص المدخل فارغ');
      }

      print(
          'Converting text to speech: ${text.substring(0, text.length > 50 ? 50 : text.length)}...');

      final response = await _dio.post(
        'https://api.mohamed-ramadan.me/api/books/text-to-speech',
        data: {
          'text': text.trim(),
        },
        options: Options(
          headers: {
            'Content-Type': 'application/json',
          },
          sendTimeout: Duration(seconds: 30),
          receiveTimeout: Duration(seconds: 30),
        ),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = response.data;
        if (data != null && data['url'] != null && data['url'] is List) {
          final urlList = data['url'] as List;
          if (urlList.isEmpty) {
            throw Exception('لم يتم إنشاء أي ملفات صوتية');
          }
          _audioUrls = urlList
              .map((item) => {
                    'shortText': item['shortText']?.toString() ?? '',
                    'url': item['url']?.toString() ?? '',
                  })
              .where((item) => item['url']!.isNotEmpty) // Filter out empty URLs
              .toList();

          if (_audioUrls.isEmpty) {
            throw Exception('لا توجد ملفات صوتية صالحة');
          } // Debug: Print URLs to console
          print('TTS URLs received:');
          for (int i = 0; i < _audioUrls.length; i++) {
            print('[$i] ${_audioUrls[i]['url']}');
          }

          // Test the first URL before attempting to play
          if (_audioUrls.isNotEmpty) {
            await testPlayUrl(_audioUrls[0]['url']!);
          }

          // Validate URLs before playing
          bool hasValidUrls = false;
          for (var audioUrl in _audioUrls) {
            if (_isValidUrl(audioUrl['url']!)) {
              hasValidUrls = true;
              break;
            }
          }

          if (!hasValidUrls) {
            throw Exception(
                'جميع الروابط الصوتية غير صالحة. يرجى المحاولة مرة أخرى.');
          }

          // Start playing the first valid audio
          await _playFirstValidAudio();
        } else {
          throw Exception('تنسيق الاستجابة غير صحيح');
        }
      } else {
        throw Exception(
            'فشل في تحويل النص إلى صوت: خطأ في الخادم (${response.statusCode})');
      }
    } on DioException catch (e) {
      String errorMessage;
      if (e.response?.statusCode == 401) {
        errorMessage = 'غير مصرح: يرجى تسجيل الدخول مرة أخرى';
      } else if (e.response?.statusCode == 400) {
        errorMessage = 'طلب غير صحيح: يرجى المحاولة مرة أخرى';
      } else if (e.response?.statusCode == 500) {
        errorMessage = 'خطأ في الخادم: يرجى المحاولة لاحقاً';
      } else if (e.type == DioExceptionType.connectionTimeout) {
        errorMessage = 'انتهت مهلة الاتصال: يرجى التحقق من اتصال الإنترنت';
      } else if (e.type == DioExceptionType.receiveTimeout) {
        errorMessage = 'انتهت مهلة الاستجابة من الخادم';
      } else if (e.type == DioExceptionType.sendTimeout) {
        errorMessage = 'انتهت مهلة إرسال البيانات';
      } else if (e.type == DioExceptionType.connectionError) {
        errorMessage = 'خطأ في الاتصال: يرجى التحقق من اتصال الإنترنت';
      } else {
        errorMessage =
            'فشل في تحويل النص إلى صوت: ${e.message ?? 'خطأ غير معروف'}';
      }
      throw Exception(errorMessage);
    } catch (e) {
      if (e is Exception && e.toString().startsWith('Exception: ')) {
        rethrow; // Rethrow our custom exceptions
      }
      throw Exception('خطأ غير متوقع: $e');
    }
  }

  Future<void> _playAudio(String url) async {
    try {
      print('Attempting to play audio from: $url');
      _isPlaying = true;

      // Validate URL before attempting to play
      if (!_isValidUrl(url)) {
        throw Exception('رابط صوتي غير صالح: $url');
      } // For web, use HTML Audio element for better Google TTS compatibility
      if (kIsWeb) {
        await _playAudioWeb(url);
        return;
      }

      // For non-web platforms, use AudioPlayer
      print('Playing audio on non-web platform');
      await _audioPlayer.setPlayerMode(PlayerMode.lowLatency);

      // Create the source and play
      final source = UrlSource(url);
      await _audioPlayer.play(source);

      print('Audio playback command sent successfully');

      // Wait a bit to see if playback actually started
      await Future.delayed(Duration(milliseconds: 500));

      // Check if audio is actually playing
      final state = await _audioPlayer.getCurrentPosition();
      print('Current position after 500ms: $state');
    } catch (e) {
      print('Error playing audio: $e');
      _isPlaying = false;

      // Provide more specific error messages
      String errorMessage = 'فشل في تشغيل الملف الصوتي';
      if (kIsWeb) {
        errorMessage += ' (متصفح الويب)';
        if (e.toString().contains('CORS')) {
          errorMessage += ': مشكلة في أذونات الوصول للملف الصوتي';
        } else if (e.toString().contains('autoplay')) {
          errorMessage += ': يرجى النقر على الصفحة أولاً لتفعيل تشغيل الصوت';
        }
      }
      errorMessage += ': $e';

      throw Exception(errorMessage);
    }
  }

  // Web-specific audio playback using HTML Audio element
  Future<void> _playAudioWeb(String url) async {
    if (!kIsWeb) return;

    try {
      print('Playing audio on web using HTML Audio element: $url');

      // Stop any existing web audio
      _webAudioElement?.pause();
      _webAudioElement = null;

      // For Google TTS URLs, try direct approach first (without CORS-restricted fetch)
      print('Trying direct HTML Audio element approach...');
      _webAudioElement = html.AudioElement();

      // Set CORS mode to anonymous to handle cross-origin requests better
      _webAudioElement!.crossOrigin = 'anonymous';

      // Set up event listeners before setting src
      _webAudioElement!.onEnded.listen((_) {
        print('Web audio completed, playing next...');
        _isPlaying = false;
        _playNext();
      });

      _webAudioElement!.onError.listen((event) {
        print('Web audio error event: $event');
        _isPlaying = false;
      });

      _webAudioElement!.onLoadedData.listen((_) {
        print('Web audio data loaded successfully');
      });
      _webAudioElement!.onCanPlay.listen((_) {
        print('Web audio can play');
      });

      // Set the source and load
      _webAudioElement!.src = url;
      _webAudioElement!.load();

      // Wait a bit for loading
      await Future.delayed(Duration(milliseconds: 500));

      // Start playing
      _isPlaying = true;
      await _webAudioElement!.play();
      print('Web audio play command sent successfully');
    } catch (e) {
      print('Direct audio approach failed: $e');

      // Try alternative approach with different CORS settings
      print('Trying alternative CORS approach...');
      try {
        _webAudioElement = html.AudioElement();

        // Try without crossOrigin attribute
        _webAudioElement!.onEnded.listen((_) {
          print('Alternative audio completed');
          _isPlaying = false;
          _playNext();
        });

        _webAudioElement!.onError.listen((event) {
          print('Alternative audio error: $event');
          _isPlaying = false;
        });

        // Set source and try to play
        _webAudioElement!.src = url;
        _isPlaying = true;
        await _webAudioElement!.play();
        print('Alternative audio approach succeeded');
      } catch (altError) {
        print('Alternative approach also failed: $altError');
        _isPlaying = false;

        // Provide user-friendly error message with solutions
        throw Exception('''
فشل في تشغيل الصوت على المتصفح بسبب قيود الأمان.

الحلول المقترحة:
• استخدم التطبيق على الهاتف المحمول للحصول على تجربة أفضل
• أو جرب متصفح آخر (Chrome/Firefox)
• تأكد من تفعيل الصوت في المتصفح

سبب المشكلة: متصفحات الويب تمنع الوصول المباشر لخدمات Google TTS لأسباب أمنية.
        ''');
      }
    }
  }

  // Method to prepare audio for web (handle autoplay policies)
  Future<void> prepareAudioForWeb() async {
    if (kIsWeb) {
      try {
        // Try to prepare the audio context by playing a silent audio
        await _audioPlayer.setVolume(0.0);
        const silentUrl =
            "data:audio/wav;base64,UklGRnoGAABXQVZFZm10IBAAAAABAAEAQB8AAEAfAAABAAgAZGF0YQoGAACBhYqFbF1QO8FsxRCmhYqFbF1QO8FsxRCmhYqFbF1QO8FsxRCmhYqFbF1QO8FsxRCmhYqFbF1QO8FsxRCmhYqFbF1QO8FsxRCm";
        await _audioPlayer.play(UrlSource(silentUrl));
        await Future.delayed(Duration(milliseconds: 100));
        await _audioPlayer.stop();
        await _audioPlayer.setVolume(1.0);
        print('Audio context prepared for web');
      } catch (e) {
        print('Could not prepare audio context: $e');
      }
    }
  }

  void _playNext() {
    // Find the next valid URL to play
    while (_currentIndex < _audioUrls.length - 1) {
      _currentIndex++;
      if (_isValidUrl(_audioUrls[_currentIndex]['url']!)) {
        _playAudio(_audioUrls[_currentIndex]['url']!).catchError((error) {
          print('Error playing next audio: $error');
          // If playing next audio fails, try to continue with the next one
          _isPlaying = false;
          _playNext();
        });
        return;
      }
    }

    // No more valid URLs to play
    print('All audio segments completed or no more valid URLs');
    _isPlaying = false;
    _currentIndex = 0;
  }

  Future<void> stopAudio() async {
    _isPlaying = false;
    if (kIsWeb && _webAudioElement != null) {
      _webAudioElement!.pause();
      _webAudioElement = null;
    } else {
      await _audioPlayer.stop();
    }
  }

  Future<void> pauseAudio() async {
    if (kIsWeb && _webAudioElement != null) {
      _webAudioElement!.pause();
    } else {
      await _audioPlayer.pause();
    }
  }

  Future<void> resumeAudio() async {
    if (kIsWeb && _webAudioElement != null) {
      await _webAudioElement!.play();
    } else {
      await _audioPlayer.resume();
    }
  }

  bool get isPlaying => _isPlaying;

  String? get currentText =>
      _audioUrls.isNotEmpty && _currentIndex < _audioUrls.length
          ? _audioUrls[_currentIndex]['shortText']
          : null;

  int get currentIndex => _currentIndex;

  int get totalSegments => _audioUrls.length;

  double get progress =>
      _audioUrls.isEmpty ? 0.0 : (_currentIndex + 1) / _audioUrls.length;
  void dispose() {
    if (kIsWeb && _webAudioElement != null) {
      _webAudioElement!.pause();
      _webAudioElement = null;
    }
    _audioPlayer.dispose();
  }

  bool _isValidUrl(String url) {
    // Check if URL is a valid HTTP/HTTPS URL
    try {
      final uri = Uri.parse(url);
      return uri.hasScheme &&
          (uri.scheme == 'http' || uri.scheme == 'https') &&
          uri.hasAuthority &&
          uri.host.isNotEmpty;
    } catch (e) {
      return false;
    }
  }

  Future<void> _playFirstValidAudio() async {
    for (int i = 0; i < _audioUrls.length; i++) {
      if (_isValidUrl(_audioUrls[i]['url']!)) {
        _currentIndex = i;
        await _playAudio(_audioUrls[i]['url']!);
        return;
      }
    }
    throw Exception('لا توجد روابط صوتية صالحة للتشغيل');
  }

  Future<List<String>> getValidUrls() async {
    List<String> validUrls = [];
    for (var audioUrl in _audioUrls) {
      if (_isValidUrl(audioUrl['url']!)) {
        try {
          // Test if the audio player can load this URL
          AudioPlayer testPlayer = AudioPlayer();
          await testPlayer.setSource(UrlSource(audioUrl['url']!));
          validUrls.add(audioUrl['url']!);
          await testPlayer.dispose();
        } catch (e) {
          print('Invalid audio URL: ${audioUrl['url']} - Error: $e');
        }
      }
    }
    return validUrls;
  }

  // Test method to try playing a URL directly
  Future<void> testPlayUrl(String url) async {
    try {
      print('=== TESTING URL ===');
      print('URL: $url');
      print('Is valid URL: ${_isValidUrl(url)}');
      print('Platform: ${kIsWeb ? 'Web' : 'Native'}');
      if (kIsWeb) {
        // Test with HTML Audio element using blob URL
        print('Testing with HTML Audio element and blob URL...');

        try {
          // Fetch audio data
          final response = await _dio.get(
            url,
            options: Options(
              responseType: ResponseType.bytes,
              headers: {
                'User-Agent':
                    'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36',
              },
            ),
          );

          if (response.statusCode == 200) {
            print('Audio data fetched for test: ${response.data.length} bytes');

            // Create blob URL
            final blob = html.Blob([response.data], 'audio/mpeg');
            final blobUrl = html.Url.createObjectUrl(blob);
            print('Test blob URL created: $blobUrl');

            final testAudio = html.AudioElement(blobUrl);

            testAudio.onError.listen((error) {
              print('HTML Audio test error: $error');
            });

            testAudio.onLoadedData.listen((_) {
              print('HTML Audio test loaded successfully');
            });

            testAudio.onEnded.listen((_) {
              print('HTML Audio test completed');
              html.Url.revokeObjectUrl(blobUrl);
            });

            await testAudio.play();
            print('HTML Audio test play command sent');

            // Wait and then stop
            await Future.delayed(Duration(seconds: 2));
            testAudio.pause();
            html.Url.revokeObjectUrl(blobUrl);
          } else {
            print('Failed to fetch audio data: ${response.statusCode}');
          }
        } catch (e) {
          print('Blob URL test failed: $e');
        }
      } else {
        // Test with AudioPlayer for native platforms
        final testPlayer = AudioPlayer();

        // Test if we can create a source
        final source = UrlSource(url);
        print('Source created successfully');

        // Try to play
        await testPlayer.play(source);
        print('Play command sent');

        // Wait and check status
        await Future.delayed(Duration(seconds: 2));
        final position = await testPlayer.getCurrentPosition();
        print('Position after 2 seconds: $position');

        await testPlayer.stop();
        await testPlayer.dispose();
      }

      print('=== TEST COMPLETED ===');
    } catch (e) {
      print('=== TEST FAILED ===');
      print('Error: $e');
    }
  }

  // Check if we're running on web and provide guidance
  bool get isWebPlatform => kIsWeb;

  String getWebCompatibilityMessage() {
    if (!kIsWeb) return '';

    return '''
ℹ️ معلومات مهمة للمتصفح:
• قد تواجه مشاكل في تشغيل الصوت على المتصفح بسبب قيود الأمان
• للحصول على أداء أفضل، استخدم التطبيق على الهاتف المحمول
• تأكد من تفعيل الصوت والسماح بالتشغيل التلقائي في المتصفح
• قد تحتاج للنقر على الصفحة أولاً قبل تشغيل الصوت
    ''';
  }

  // Test web audio compatibility
  Future<bool> testWebAudioSupport() async {
    if (!kIsWeb) return true;

    try {
      print('Testing web audio support...');

      // Test basic audio element creation
      final testAudio = html.AudioElement();

      // Test if we can play audio
      final canPlayOgg = testAudio.canPlayType('audio/ogg');
      final canPlayMp3 = testAudio.canPlayType('audio/mpeg');
      final canPlayWav = testAudio.canPlayType('audio/wav');

      print('Audio format support:');
      print('- OGG: $canPlayOgg');
      print('- MP3: $canPlayMp3');
      print('- WAV: $canPlayWav');

      // Test if we can create a basic working audio element
      const testUrl =
          "data:audio/wav;base64,UklGRnoGAABXQVZFZm10IBAAAAABAAEAQB8AAEAfAAABAAgAZGF0YQoGAACBhYqFbF1fdw==";
      testAudio.src = testUrl;

      try {
        await testAudio.play();
        testAudio.pause();
        print('Basic audio playback test: SUCCESS');
        return true;
      } catch (e) {
        print('Basic audio playback test: FAILED - $e');
        return false;
      }
    } catch (e) {
      print('Web audio support test failed: $e');
      return false;
    }
  }
}
