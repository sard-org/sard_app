import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:shared_preferences/shared_preferences.dart';
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
  
  // إضافة متغيرات لتتبع الوقت والمدة
  Duration _currentPosition = Duration.zero;
  Duration _totalDuration = Duration.zero;
  Duration? _savedPosition; // حفظ آخر موضع

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
      } else if (state == PlayerState.playing) {
        _isPlaying = true;
      } else if (state == PlayerState.paused) {
        _isPlaying = false;
      }
    });

    // إضافة مستمع لتتبع الموضع الحالي
    _audioPlayer.onPositionChanged.listen((Duration position) {
      _currentPosition = position;
      print('Position changed: $position');
    });

    // إضافة مستمع لتتبع المدة الكاملة
    _audioPlayer.onDurationChanged.listen((Duration duration) {
      _totalDuration = duration;
      print('Duration changed: $duration');
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
      print('Setting up audio player with file: ${file.path}');
      await _audioPlayer.setPlayerMode(PlayerMode.mediaPlayer);
      
      // Stop any previous audio
      await _audioPlayer.stop();
      
      // Set the source
      await _audioPlayer.setSourceDeviceFile(file.path);
      
      // Reset position tracking
      _currentPosition = Duration.zero;
      _totalDuration = Duration.zero;
      
      print('Starting audio playback...');
      await _audioPlayer.resume();
      
      // Wait a bit for the duration to be detected
      await Future.delayed(const Duration(milliseconds: 1000));
      print('Audio player state after start: ${_audioPlayer.state}');
      
      // استرجاع آخر موضع محفوظ والانتقال إليه
      final savedPos = await _getSavedPosition();
      if (savedPos.inMilliseconds > 0) {
        print('Resuming from saved position: ${savedPos.inSeconds} seconds');
        await _audioPlayer.seek(savedPos);
        _currentPosition = savedPos;
      }

      await Future.delayed(const Duration(milliseconds: 500));
      final currentPos = await _audioPlayer.getCurrentPosition();
      final duration = await _audioPlayer.getDuration();
      
      // Update our tracking variables manually if listeners didn't fire
      if (currentPos != null) {
        _currentPosition = currentPos;
        print('Manually updated current position: $currentPos');
      }
      if (duration != null) {
        _totalDuration = duration;
        print('Manually updated duration: $duration');
      }
      
      print('Final state - Position: $_currentPosition, Duration: $_totalDuration');
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
      // مسح الموضع المحفوظ عند انتهاء الكتاب
      await _clearSavedPosition();
      print('Reached end of audio book');
    }
  }

  // دالة لمسح الموضع المحفوظ
  Future<void> _clearSavedPosition() async {
    try {
      if (_currentBook != null) {
        final prefs = await SharedPreferences.getInstance();
        final key = 'audio_position_${_currentBook!.id}';
        await prefs.remove(key);
        print('Cleared saved position for book ${_currentBook!.id}');
      }
    } catch (e) {
      print('Error clearing saved position: $e');
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
    // حفظ الموضع الحالي قبل التوقف
    await _saveLastPosition();
    
    _isPlaying = false;
    if (kIsWeb) {
      await _flutterTts.stop();
    } else {
      await _audioPlayer.stop();
    }
    print('Audio stopped at position: ${_currentPosition.inSeconds} seconds');
  }

  Future<void> pauseAudio() async {
    // حفظ الموضع الحالي عند الإيقاف المؤقت
    await _saveLastPosition();
    
    if (kIsWeb) {
      await _flutterTts.stop(); // pause غير مدعوم في TTS
    } else {
      await _audioPlayer.pause();
    }
    print('Audio paused at position: ${_currentPosition.inSeconds} seconds');
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
        (url.startsWith('http://') || url.startsWith('https://')) &&
        (url.toLowerCase().contains('.mp3') || 
         url.toLowerCase().contains('.wav') || 
         url.toLowerCase().contains('.m4a') ||
         url.contains('drive.google.com') ||
         url.contains('export=download'));
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

  // دالة لحفظ آخر موضع
  Future<void> _saveLastPosition() async {
    try {
      if (_currentBook != null && _currentPosition.inSeconds > 0) {
        final prefs = await SharedPreferences.getInstance();
        final key = 'audio_position_${_currentBook!.id}';
        await prefs.setInt(key, _currentPosition.inMilliseconds);
        print('Saved position: ${_currentPosition.inSeconds} seconds for book ${_currentBook!.id}');
      }
    } catch (e) {
      print('Error saving position: $e');
    }
  }

  // دالة لاسترجاع آخر موضع
  Future<Duration> _getSavedPosition() async {
    try {
      if (_currentBook != null) {
        final prefs = await SharedPreferences.getInstance();
        final key = 'audio_position_${_currentBook!.id}';
        final milliseconds = prefs.getInt(key) ?? 0;
        final savedPos = Duration(milliseconds: milliseconds);
        print('Retrieved saved position: ${savedPos.inSeconds} seconds for book ${_currentBook!.id}');
        return savedPos;
      }
    } catch (e) {
      print('Error getting saved position: $e');
    }
    return Duration.zero;
  }

  // دالة لتحديث البيانات يدوياً
  Future<void> updateAudioData() async {
    try {
      if (!kIsWeb && _audioPlayer.state != PlayerState.stopped) {
        final currentPos = await _audioPlayer.getCurrentPosition();
        final duration = await _audioPlayer.getDuration();
        
        if (currentPos != null && currentPos != _currentPosition) {
          _currentPosition = currentPos;
          // حفظ الموضع تلقائياً كل تحديث
          _saveLastPosition();
        }
        if (duration != null && duration != _totalDuration) {
          _totalDuration = duration;
        }
      }
    } catch (e) {
      print('Error updating audio data: $e');
    }
  }

  // إضافة وظائف التحكم في الصوت
  Future<void> seekForward10Seconds() async {
    try {
      print('Seeking forward 10 seconds. Current position: $_currentPosition, Total: $_totalDuration');
      
             if (!kIsWeb && (_audioPlayer.state == PlayerState.playing || _audioPlayer.state == PlayerState.paused)) {
          final newPosition = _currentPosition + Duration(seconds: 10);
        if (_totalDuration.inMilliseconds > 0 && newPosition <= _totalDuration) {
          await _audioPlayer.seek(newPosition);
          print('Seeked to: $newPosition');
        } else if (_currentIndex < _audioSegments.length - 1) {
          // إذا تجاوز المدة، انتقل للمقطع التالي
          print('End reached, playing next segment');
          await playNext();
        }
      } else {
        print('Cannot seek: Web platform or not playing');
      }
    } catch (e) {
      print('Error seeking forward: $e');
    }
  }

  Future<void> seekBackward10Seconds() async {
    try {
      print('Seeking backward 10 seconds. Current position: $_currentPosition');
      
             if (!kIsWeb && (_audioPlayer.state == PlayerState.playing || _audioPlayer.state == PlayerState.paused)) {
          final newPosition = _currentPosition - Duration(seconds: 10);
        if (newPosition >= Duration.zero) {
          await _audioPlayer.seek(newPosition);
          print('Seeked to: $newPosition');
        } else if (_currentIndex > 0) {
          // إذا تجاوز البداية، ارجع للمقطع السابق
          print('Beginning reached, playing previous segment');
          await playPrevious();
        } else {
          // إذا كنا في المقطع الأول، ارجع للبداية
          await _audioPlayer.seek(Duration.zero);
          print('Seeked to beginning');
        }
      } else {
        print('Cannot seek: Web platform or not playing');
      }
    } catch (e) {
      print('Error seeking backward: $e');
    }
  }

  Future<void> seekToPosition(double value) async {
    try {
      if (!kIsWeb && _totalDuration.inMilliseconds > 0) {
        final position = Duration(
          milliseconds: (value * _totalDuration.inMilliseconds).round(),
        );
        await _audioPlayer.seek(position);
      }
    } catch (e) {
      print('Error seeking to position: $e');
    }
  }

  // Getters محدثة
  double get progress {
    if (_totalDuration.inMilliseconds > 0) {
      return _currentPosition.inMilliseconds / _totalDuration.inMilliseconds;
    }
    return _audioSegments.isEmpty ? 0.0 : (_currentIndex + 1) / _audioSegments.length;
  }

  Duration get currentPosition => _currentPosition;
  Duration get totalDuration => _totalDuration;
  
  // دالة لإعادة بدء الكتاب من البداية
  Future<void> restartFromBeginning() async {
    try {
      await _clearSavedPosition();
      _currentPosition = Duration.zero;
      if (!kIsWeb) {
        await _audioPlayer.seek(Duration.zero);
      }
      print('Restarted audio from beginning');
    } catch (e) {
      print('Error restarting from beginning: $e');
    }
  }
  
  String get currentPositionText {
    final minutes = _currentPosition.inMinutes;
    final seconds = _currentPosition.inSeconds % 60;
    return '$minutes:${seconds.toString().padLeft(2, '0')}';
  }
  
  String get totalDurationText {
    final minutes = _totalDuration.inMinutes;
    final seconds = _totalDuration.inSeconds % 60;
    return '$minutes:${seconds.toString().padLeft(2, '0')}';
  }

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