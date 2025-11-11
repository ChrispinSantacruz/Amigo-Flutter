import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:flutter_tts/flutter_tts.dart';
import '../../core/utils/text_utils.dart';
import '../widgets/mishi_character.dart';
import '../providers/mishi_provider.dart';
import '../providers/chat_provider.dart';
import '../providers/auth_provider.dart';

/// Pantalla de Voz - Grabar y que Mishi hable
class VozScreen extends ConsumerStatefulWidget {
  const VozScreen({super.key});

  @override
  ConsumerState<VozScreen> createState() => _VozScreenState();
}

class _VozScreenState extends ConsumerState<VozScreen> {
  final stt.SpeechToText _speech = stt.SpeechToText();
  final FlutterTts _tts = FlutterTts();
  bool _isListening = false;
  bool _isSpeaking = false;
  String _recognizedText = '';

  @override
  void initState() {
    super.initState();
    _initializeSpeech();
    _initializeTTS();
  }

  Future<void> _initializeSpeech() async {
    bool available = await _speech.initialize(
      onStatus: (status) {
        if (status == 'done' || status == 'notListening') {
          setState(() {
            _isListening = false;
          });
        }
      },
      onError: (error) {
        print('Error en reconocimiento de voz: $error');
        setState(() {
          _isListening = false;
        });
      },
    );

    if (!available) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('El reconocimiento de voz no está disponible'),
          ),
        );
      }
    }
  }

  Future<void> _initializeTTS() async {
    await _tts.setLanguage('es-ES');
    // Velocidad más lenta y natural (0.5 = muy lento, 1.0 = normal, 1.2 = rápido pero claro)
    await _tts.setSpeechRate(0.5);
    // Pitch más alto para sonar más animado y alegre (1.0 = normal, 1.2 = más alegre)
    await _tts.setPitch(1.2);
    await _tts.setVolume(1.0);
    
    // Configurar voz para que suene más natural
    // En web, las opciones pueden ser limitadas, pero intentamos configurarlas
    try {
      // Algunas plataformas soportan seleccionar voces
      final voices = await _tts.getVoices;
      if (voices != null && voices.isNotEmpty) {
        // Buscar una voz en español que suene más natural
        final spanishVoice = voices.firstWhere(
          (voice) => voice.locale.startsWith('es'),
          orElse: () => voices.first,
        );
        await _tts.setVoice({'name': spanishVoice.name, 'locale': spanishVoice.locale});
      }
    } catch (e) {
      // Si no se puede configurar la voz, continuar con la predeterminada
      print('No se pudo configurar voz personalizada: $e');
    }

    _tts.setCompletionHandler(() {
      setState(() {
        _isSpeaking = false;
      });
    });
  }

  Future<void> _startListening() async {
    if (_isListening) return;

    setState(() {
      _isListening = true;
      _recognizedText = '';
    });

    await _speech.listen(
      onResult: (result) {
        setState(() {
          _recognizedText = result.recognizedWords;
        });

        if (result.finalResult) {
          _processVoiceInput(result.recognizedWords);
        }
      },
      listenFor: const Duration(seconds: 30),
      pauseFor: const Duration(seconds: 3),
      localeId: 'es_ES',
    );
  }

  Future<void> _stopListening() async {
    await _speech.stop();
    setState(() {
      _isListening = false;
    });

    if (_recognizedText.isNotEmpty) {
      await _processVoiceInput(_recognizedText);
    }
  }

  Future<void> _processVoiceInput(String text) async {
    if (text.trim().isEmpty) return;

    try {
      final authState = ref.read(authProvider);
      final user = authState.user;

      if (user == null) return;

      // Guardar mensaje del usuario primero
      await ref.read(chatProvider.notifier).sendMessage(text);

      // Esperar a que se complete el envío y llegue la respuesta
      // Usar un listener para detectar cuando llega la respuesta
      int attempts = 0;
      const maxAttempts = 10;
      
      while (attempts < maxAttempts) {
        await Future.delayed(const Duration(milliseconds: 300));
        final chatState = ref.read(chatProvider);
        
        if (chatState.messages.isNotEmpty && !chatState.isLoading) {
          final lastMessage = chatState.messages.last;
          if (!lastMessage.isFromUser && lastMessage.text.isNotEmpty) {
            // Hablar la respuesta (los emojis se eliminarán automáticamente)
            await _speak(lastMessage.text);
            break;
          }
        }
        
        attempts++;
      }
      
      // Si no se obtuvo respuesta después de los intentos
      if (attempts >= maxAttempts) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('No se pudo obtener la respuesta. Intenta de nuevo.'),
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    }
  }

  Future<void> _speak(String text) async {
    setState(() {
      _isSpeaking = true;
    });

    // Limpiar el texto: eliminar emojis y formatear para TTS
    final cleanedText = TextUtils.formatForTTS(text);
    
    // Verificar que el texto no esté vacío después de limpiar
    if (cleanedText.isEmpty || cleanedText.trim().isEmpty) {
      // Si el texto solo tenía emojis, usar un mensaje por defecto
      await _tts.speak('Miau, estoy aquí contigo');
    } else {
      await _tts.speak(cleanedText);
    }
  }

  Future<void> _stopSpeaking() async {
    await _tts.stop();
    setState(() {
      _isSpeaking = false;
    });
  }

  @override
  void dispose() {
    _speech.cancel();
    _tts.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final mishiState = ref.watch(mishiProvider);

    return Column(
      children: [
        // Área del gatito
        Expanded(
          child: Container(
            margin: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.9),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                MishiCharacter(state: mishiState),
                const SizedBox(height: 30),
                // Estado de escucha/habla
                if (_isListening)
                  const Column(
                    children: [
                      Text(
                        '🎤 Escuchando...',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFFFF6B35),
                        ),
                      ),
                      SizedBox(height: 10),
                      Text(
                        'Habla ahora',
                        style: TextStyle(
                          fontSize: 16,
                          color: Color(0xFF666666),
                        ),
                      ),
                    ],
                  )
                else if (_isSpeaking)
                  const Column(
                    children: [
                      Text(
                        '🔊 Mishi está hablando...',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF4ECDC4),
                        ),
                      ),
                      SizedBox(height: 10),
                      Text(
                        'Escucha',
                        style: TextStyle(
                          fontSize: 16,
                          color: Color(0xFF666666),
                        ),
                      ),
                    ],
                  )
                else
                  const Column(
                    children: [
                      Text(
                        '🎤',
                        style: TextStyle(fontSize: 48),
                      ),
                      SizedBox(height: 10),
                      Text(
                        'Presiona el botón para hablar',
                        style: TextStyle(
                          fontSize: 18,
                          color: Color(0xFF666666),
                          fontWeight: FontWeight.w500,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                if (_recognizedText.isNotEmpty && !_isListening)
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFF5E1),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Text(
                        'Dijiste: "$_recognizedText"',
                        style: const TextStyle(
                          fontSize: 16,
                          color: Color(0xFF333333),
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
        // Botones de control
        Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              // Botón de grabar
              _VoiceButton(
                icon: _isListening ? Icons.stop : Icons.mic,
                label: _isListening ? 'Detener' : 'Grabar',
                color: _isListening
                    ? Colors.red
                    : const Color(0xFFFF6B35),
                onTap: _isListening ? _stopListening : _startListening,
                isActive: _isListening,
              ),
              // Botón de detener habla
              if (_isSpeaking)
                _VoiceButton(
                  icon: Icons.stop,
                  label: 'Detener',
                  color: Colors.red,
                  onTap: _stopSpeaking,
                  isActive: true,
                ),
            ],
          ),
        ),
      ],
    );
  }
}

class _VoiceButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;
  final bool isActive;

  const _VoiceButton({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
    required this.isActive,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 120,
        height: 120,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.3),
              blurRadius: 15,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: Colors.white,
              size: 48,
            ),
            const SizedBox(height: 8),
            Text(
              label,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

