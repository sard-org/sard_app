import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_tts/flutter_tts.dart';
import '../screens/AudioBook/audio_book_api_service.dart';
import '../screens/AudioBook/audio_book_model.dart';

class AudioBookService {
  final AudioBookApiService _apiService = AudioBookApiService();
  late AudioPlayer _audioPlayer;
  late FlutterTts _flutterTts;
  List<AudioSegment> _audioSegments = [];
  int _currentIndex = 0;
  bool _isPlaying = false;
  bool _isLoading = false;
  AudioBookContentResponse? _currentBook;

  AudioBookService() {
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

  Future<AudioBookContentResponse> loadBookByOrderId(String orderId) async {
    try {
      _isLoading = true;
      print('Loading audio book for order: $orderId');
      
      final bookContent = await _apiService.getAudioBookByOrderId(orderId);
      _currentBook = bookContent;
      _audioSegments = bookContent.audioSegments;
      _currentIndex = 0;
      _isPlaying = false;
      
      // Stop any current playback
      await stopAudio();
      
      print('Audio book loaded successfully: ${bookContent.title}');
      print('Audio URL: ${bookContent.audioUrl}');
      print('Audio segments count: ${_audioSegments.length}');
      
      return bookContent;
    } catch (e) {
      print('Error loading audio book: $e');
      rethrow;
    } finally {
      _isLoading = false;
    }
  }

  Future<void> convertTextToSpeech(String text) async {
    try {
      // Reset current state
      _audioSegments.clear();
      _currentIndex = 0;
      _isPlaying = false;
      await stopAudio();

      if (text.trim().isEmpty) {
        throw Exception('النص المدخل فارغ');
      }

      print('Converting text to speech: ${text.substring(0, text.length > 50 ? 50 : text.length)}...');

      // Create a single audio segment from text
      _audioSegments = [AudioSegment(text: text.trim(), url: '', order: 0)];
      
      await _playFirstValidAudio();
    } catch (e) {
      print('Error in convertTextToSpeech: $e');
      rethrow;
    }
  }

  Future<void> playAudioBook() async {
    if (_audioSegments.isEmpty) {
      throw Exception('لا توجد مقاطع صوتية متاحة');
    }

    await _playFirstValidAudio();
  }

  Future<void> _playAudio(String url) async {
    try {
      if (!_isValidUrl(url)) {
        // If no valid URL, try to use text-to-speech
        if (_currentIndex < _audioSegments.length) {
          final text = _audioSegments[_currentIndex].text;
          if (text.isNotEmpty) {
            await _playAudioWeb(); // Use TTS
            return;
          }
        }
        throw Exception('رابط صوتي غير صالح: $url');
      }

      // Process URL for Google Drive and other services
      final processedUrl = _processAudioUrl(url);
      print('Playing audio (cached) from: $processedUrl');
      _isPlaying = true;

      const cacheKey = 'audioBookCache';
      final cacheManager = CacheManager(
        Config(
          cacheKey,
          stalePeriod: const Duration(hours: 2), // Keep for 2 hours
          repo: JsonCacheInfoRepository(databaseName: cacheKey),
          fileService: HttpFileService(),
        ),
      );

      // Download and cache the file with proper User-Agent
      final file = await cacheManager.getSingleFile(
        processedUrl,
        headers: {
          'User-Agent':
              'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 '
                  '(KHTML, like Gecko) Chrome/91.0.4472.124 Safari/537.36'
        },
      );

      // Set player mode and play the cached file
      await _audioPlayer.setPlayerMode(PlayerMode.mediaPlayer);
      await _audioPlayer.setSourceDeviceFile(file.path);
      await _audioPlayer.resume();

      await Future.delayed(const Duration(milliseconds: 500));
      final state = await _audioPlayer.getCurrentPosition();
      print('Current position after 500ms: $state');
    } catch (e) {
      print('Error playing audio: $e');
      _isPlaying = false;
      
      // Fallback to TTS if audio fails
      try {
        await _playAudioWeb();
      } catch (ttsError) {
        print('TTS fallback also failed: $ttsError');
        throw Exception('فشل في تشغيل الملف الصوتي: $e');
      }
    }
  }

  Future<void> _playAudioWeb() async {
    try {
      if (_currentIndex >= _audioSegments.length) {
        throw Exception('لا يوجد مقطع صوتي متاح');
      }

      final text = _audioSegments[_currentIndex].text;

      if (text.isEmpty) {
        throw Exception('لا يوجد نص متاح للقراءة');
      }

      print('Using flutter_tts for: ${text.substring(0, text.length > 50 ? 50 : text.length)}...');

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
    if (_audioSegments.isEmpty) throw Exception('لا توجد مقاطع صوتية متاحة');

    _currentIndex = 0;

    if (kIsWeb) {
      await _playAudioWeb();
    } else {
      final url = _audioSegments[0].url;
      if (url.isNotEmpty && _isValidUrl(url)) {
        await _playAudio(url);
      } else {
        // Fallback to TTS
        await _playAudioWeb();
      }
    }
  }

  Future<void> _playNext() async {
    if (_currentIndex < _audioSegments.length - 1) {
      _currentIndex++;
      if (kIsWeb) {
        await _playAudioWeb();
      } else {
        final url = _audioSegments[_currentIndex].url;
        if (url.isNotEmpty && _isValidUrl(url)) {
          await _playAudio(url);
        } else {
          // Fallback to TTS
          await _playAudioWeb();
        }
      }
    } else {
      _isPlaying = false;
      print('Reached end of audio book');
    }
  }

  Future<void> playPrevious() async {
    if (_currentIndex > 0) {
      _currentIndex--;
      if (kIsWeb) {
        await _playAudioWeb();
      } else {
        final url = _audioSegments[_currentIndex].url;
        if (url.isNotEmpty && _isValidUrl(url)) {
          await _playAudio(url);
        } else {
          // Fallback to TTS
          await _playAudioWeb();
        }
      }
    }
  }

  Future<void> playNext() async {
    await _playNext();
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
      await _flutterTts.stop(); // pause غير مدعوم في TTS
    } else {
      await _audioPlayer.pause();
    }
  }

  Future<void> resumeAudio() async {
    if (!kIsWeb) {
      await _audioPlayer.resume();
    } else {
      // For web, restart the current segment
      await _playAudioWeb();
    }
  }

  bool _isValidUrl(String url) {
    return url.isNotEmpty &&
        (url.startsWith('http://') || url.startsWith('https://'));
  }

  // Convert Google Drive URL to direct download URL if needed
  String _processAudioUrl(String url) {
    if (url.isEmpty) return url;
    
    // If it's already a direct download URL, return as is
    if (url.contains('export=download')) {
      return url;
    }
    
    // Handle Google Drive share URLs
    if (url.contains('drive.google.com')) {
      // Extract file ID from various Google Drive URL formats
      RegExp regExp = RegExp(r'[/=]([\w-]{25,})');
      Match? match = regExp.firstMatch(url);
      if (match != null) {
        String fileId = match.group(1)!;
        return 'https://drive.google.com/uc?id=$fileId&export=download';
      }
    }
    
    return url;
  }

  // Getters
  double get progress =>
      _audioSegments.isEmpty ? 0.0 : (_currentIndex + 1) / _audioSegments.length;

  bool get isPlaying => _isPlaying;
  bool get isLoading => _isLoading;
  
  int get currentIndex => _currentIndex;
  int get totalSegments => _audioSegments.length;
  
  String get currentSegmentText => 
      _currentIndex < _audioSegments.length ? _audioSegments[_currentIndex].text : '';
  
  AudioBookContentResponse? get currentBook => _currentBook;

  void dispose() {
    _audioPlayer.dispose();
    _flutterTts.stop();
  }
} 