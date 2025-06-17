import 'package:dio/dio.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter_tts/flutter_tts.dart';
import '../screens/Books/data/dio_client.dart';

class TextToSpeechService {
  final Dio _dio = DioClient.dio;
  late AudioPlayer _audioPlayer;
  late FlutterTts _flutterTts;
  List<Map<String, String>> _audioUrls = [];
  int _currentIndex = 0;
  bool _isPlaying = false;

  TextToSpeechService() {
    _audioPlayer = AudioPlayer();
    _flutterTts = FlutterTts();
    _setupAudioPlayerListeners();
    _setupTtsListeners();
  }

  void _setupTtsListeners() {
    _flutterTts.setCompletionHandler(() {
      print('TTS completed, playing next...');
      _isPlaying = false;
      _playNext();
    });
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

    _audioPlayer.onLog.listen((String message) {
      print('AudioPlayer log: $message');
    });
  }

  Future<void> convertTextToSpeech(String text) async {
    try {
      _audioUrls.clear();
      _currentIndex = 0;
      _isPlaying = false;
      await stopAudio();

      if (text.trim().isEmpty) {
        throw Exception('النص المدخل فارغ');
      }

      print('Converting text to speech: ${text.substring(0, text.length > 50 ? 50 : text.length)}...');

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
          if (urlList.isEmpty) throw Exception('لم يتم إنشاء أي ملفات صوتية');

          _audioUrls = urlList
              .map((item) => {
            'shortText': item['shortText']?.toString() ?? '',
            'url': item['url']?.toString() ?? '',
          })
              .where((item) => item['url']!.isNotEmpty)
              .toList();

          if (_audioUrls.isEmpty) throw Exception('لا توجد ملفات صوتية صالحة');

          print('TTS URLs received:');
          for (int i = 0; i < _audioUrls.length; i++) {
            print('[$i] ${_audioUrls[i]['url']}');
          }

          await _playFirstValidAudio();
        } else {
          throw Exception('تنسيق الاستجابة غير صحيح');
        }
      } else {
        throw Exception('فشل في تحويل النص إلى صوت: خطأ في الخادم (${response.statusCode})');
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
        errorMessage = 'فشل في تحويل النص إلى صوت: ${e.message ?? 'خطأ غير معروف'}';
      }
      throw Exception(errorMessage);
    } catch (e) {
      if (e is Exception && e.toString().startsWith('Exception: ')) rethrow;
      throw Exception('خطأ غير متوقع: $e');
    }
  }

  Future<void> _playAudio(String url) async {
    try {
      if (!_isValidUrl(url)) throw Exception('رابط صوتي غير صالح: $url');

      print('Playing audio (mobile/native) from: $url');
      _isPlaying = true;

      await _audioPlayer.setPlayerMode(PlayerMode.lowLatency);
      final source = UrlSource(url);
      await _audioPlayer.play(source);

      await Future.delayed(Duration(milliseconds: 500));
      final state = await _audioPlayer.getCurrentPosition();
      print('Current position after 500ms: $state');
    } catch (e) {
      print('Error playing audio: $e');
      _isPlaying = false;
      throw Exception('فشل في تشغيل الملف الصوتي: $e');
    }
  }

  Future<void> _playAudioWeb() async {
    try {
      final text = _audioUrls[_currentIndex]['shortText'] ?? '';

      if (text.isEmpty) {
        throw Exception('لا يوجد نص متاح للقراءة');
      }

      print('Using flutter_tts on Web for: $text');

      await _flutterTts.setLanguage('ar-SA');
      await _flutterTts.setSpeechRate(0.5);
      await _flutterTts.setVolume(1.0);
      await _flutterTts.setPitch(1.0);

      _isPlaying = true;
      await _flutterTts.speak(text);
    } catch (e) {
      print('Error in web audio playback: $e');
      _isPlaying = false;
      throw Exception('فشل في تشغيل الصوت: $e');
    }
  }

  Future<void> _playFirstValidAudio() async {
    if (_audioUrls.isEmpty) throw Exception('لا توجد ملفات صوتية متاحة');

    _currentIndex = 0;

    if (kIsWeb) {
      await _playAudioWeb();
    } else {
      await _playAudio(_audioUrls[0]['url']!);
    }
  }

  Future<void> _playNext() async {
    if (_currentIndex < _audioUrls.length - 1) {
      _currentIndex++;
      if (kIsWeb) {
        await _playAudioWeb();
      } else {
        await _playAudio(_audioUrls[_currentIndex]['url']!);
      }
    } else {
      _isPlaying = false;
      print('Reached end of audio list');
    }
  }

  Future<void> stopAudio() async {
    _isPlaying = false;
    if (kIsWeb) {
      await _flutterTts.stop();
    } else {
      await _audioPlayer.stop();
    }
  }

  Future<void> pauseAudio() async {
    if (kIsWeb) {
      await _flutterTts.stop(); // pause غير مدعوم
    } else {
      await _audioPlayer.pause();
    }
  }

  Future<void> resumeAudio() async {
    if (!kIsWeb) {
      await _audioPlayer.resume();
    }
  }

  bool _isValidUrl(String url) {
    return url.isNotEmpty &&
        (url.endsWith('.mp3')) &&
        (url.startsWith('http://') || url.startsWith('https://'));
  }

  double get progress => _audioUrls.isEmpty ? 0.0 : (_currentIndex + 1) / _audioUrls.length;

  bool get isPlaying => _isPlaying;

  void dispose() {
    _audioPlayer.dispose();
  }
}
