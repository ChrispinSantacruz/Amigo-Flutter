import 'package:audioplayers/audioplayers.dart';

class SoundService {
  static final AudioPlayer _player = AudioPlayer();

  /// Reproducir maullo
  static Future<void> playMeow() async {
    try {
      await _player.play(AssetSource('sounds/maullo.mp3'));
    } catch (e) {
      print('Error al reproducir maullo: $e');
    }
  }

  /// Reproducir sonido de masticar
  static Future<void> playChewing() async {
    try {
      await _player.play(AssetSource('sounds/masticar.mp3'));
    } catch (e) {
      print('Error al reproducir masticar: $e');
    }
  }

  /// Reproducir ronroneo
  static Future<void> playPurr() async {
    try {
      await _player.play(AssetSource('sounds/ronroneo.mp3'));
    } catch (e) {
      print('Error al reproducir ronroneo: $e');
    }
  }

  /// Detener todos los sonidos
  static Future<void> stop() async {
    try {
      await _player.stop();
    } catch (e) {
      print('Error al detener sonido: $e');
    }
  }
}


