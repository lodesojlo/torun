import 'dart:io';
import 'dart:typed_data';
import 'dart:async';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart' show kIsWeb, debugPrint;
import 'package:path_provider/path_provider.dart';
import 'sound_generator.dart';

class SoundService {
  static final SoundService _instance = SoundService._internal();
  factory SoundService() => _instance;
  SoundService._internal();

  bool enabled = true;
  String _currentPack = 'sounds_default';
  final Map<String, AudioPlayer> _players = {};
  bool _initialized = false;
  Directory? _soundDir;

  final Set<String> _generatedPacks = {};
  final Map<String, Uint8List> _soundBytes = {};

  Future<void>? _initializing;

  static const List<String> _allSounds = [
    'jump', 'duck', 'score', 'game_over', 'new_high_score', 'milestone',
    'pause', 'resume', 'click',
  ];

  Future<void> initialize() async {
    if (_initialized) return;
    if (_initializing != null) return _initializing;

    _initializing = _doInitialize();
    return _initializing;
  }

  Future<void> _doInitialize() async {
    try {
      if (!kIsWeb) {
        final appDir = await getApplicationDocumentsDirectory();
        _soundDir = Directory('${appDir.path}/talvo_sounds');
        if (!await _soundDir!.exists()) {
          await _soundDir!.create(recursive: true);
        }
      }
      _initialized = true;
      debugPrint('✅ SoundService ready');
    } catch (e) {
      debugPrint('⚠️ SoundService init failed: $e');
    }
  }

  /// توليد pack واحد فقط (في الخلفية)
  Future<void> _ensurePackGenerated(String pack) async {
    if (_generatedPacks.contains(pack)) return;

    try {
      for (final sound in _allSounds) {
        if (kIsWeb) {
          final key = '${pack}_$sound';
          if (!_soundBytes.containsKey(key)) {
            _soundBytes[key] = SoundGenerator.generate(pack, sound);
          }
        } else {
          final file = File('${_soundDir!.path}/${pack}_$sound.wav');
          if (!await file.exists()) {
            final bytes = SoundGenerator.generate(pack, sound);
            await file.writeAsBytes(bytes);
          }
        }
        // ✅ اسمح للـ UI يتنفس
        await Future.delayed(const Duration(milliseconds: 1));
      }
      _generatedPacks.add(pack);
      debugPrint('✅ Sound pack generated: $pack');
    } catch (e) {
      debugPrint('⚠️ Pack generation error ($pack): $e');
    }
  }

  Future<void> play(String soundName) async {
    if (!enabled) return;
    if (!_initialized) return;

    try {
      // ✅ ولد الـ pack لو مش موجود (في الخلفية)
      if (!_generatedPacks.contains(_currentPack)) {
        unawaited(_ensurePackGenerated(_currentPack));
        return;
      }

      final player = _players[soundName] ??= AudioPlayer();
      await player.stop();

      if (kIsWeb) {
        final key = '${_currentPack}_$soundName';
        final bytes = _soundBytes[key];
        if (bytes != null && bytes.isNotEmpty) {
          await player.play(BytesSource(bytes));
        }
      } else {
        final path = '${_soundDir!.path}/${_currentPack}_$soundName.wav';
        final file = File(path);
        if (!await file.exists()) return;
        await player.play(DeviceFileSource(path));
      }
    } catch (e) {
      debugPrint('⚠️ Sound play error ($soundName): $e');
    }
  }

  void setPack(String pack) {
    if (_currentPack == pack) return;
    _currentPack = pack;
    // ✅ ولد الـ pack الجديد في الخلفية
    unawaited(_ensurePackGenerated(pack));
  }

  String getPack() => _currentPack;

  bool toggle() {
    enabled = !enabled;
    return enabled;
  }

  void setEnabled(bool value) {
    enabled = value;
  }

  Future<void> cleanup() async {
    for (final player in _players.values) {
      await player.dispose();
    }
    _players.clear();
  }
}