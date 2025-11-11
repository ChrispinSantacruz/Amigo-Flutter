/// Utilidades para procesamiento de texto, especialmente para TTS
class TextUtils {
  /// Elimina emojis de un texto usando múltiples métodos para asegurar eliminación completa
  static String removeEmojis(String text) {
    if (text.isEmpty) return text;
    
    String cleaned = text;
    
    // Método 1: Lista extensa de emojis comunes que MishiGPT puede usar
    final commonEmojis = [
      '🐱', '💕', '💖', '💫', '✨', '🌈', '🐾', '💤', '☀️', '🌙',
      '💔', '💪', '🥺', '😺', '🐯', '🐇', '🐠', '🐟', '🍽️', '💡',
      '🎤', '🔊', '🎉', '😊', '😄', '😃', '😁', '😆', '😅', '😂',
      '🤣', '😇', '🙂', '🙃', '😉', '😌', '😍', '🥰', '😘', '👋',
      '👦', '👧', '🎁', '🎂', '🎈', '🎀', '🎊', '🏆', '⭐', '🌟',
      '💫', '🔥', '💧', '❄️', '☃️', '⛄', '🌊', '🌍', '🌎', '🌏',
      '🎨', '🎭', '🎪', '🎬', '🎮', '🎯', '🎲', '🃏', '🀄', '🎴',
    ];
    
    // Eliminar emojis conocidos
    for (var emoji in commonEmojis) {
      cleaned = cleaned.replaceAll(emoji, '');
    }
    
    // Método 2: Regex para emojis Unicode usando múltiples rangos
    try {
      // Rangos Unicode comunes para emojis
      final emojiPatterns = [
        RegExp(r'[\u{1F300}-\u{1F9FF}]', unicode: true), // Símbolos y pictogramas
        RegExp(r'[\u{1F600}-\u{1F64F}]', unicode: true), // Emoticones
        RegExp(r'[\u{1F680}-\u{1F6FF}]', unicode: true), // Transporte y mapas
        RegExp(r'[\u{2600}-\u{26FF}]', unicode: true),   // Símbolos varios
        RegExp(r'[\u{2700}-\u{27BF}]', unicode: true),   // Dingbats
        RegExp(r'[\u{FE00}-\u{FE0F}]', unicode: true),   // Variación selectora
        RegExp(r'[\u{200D}]', unicode: true),            // Zero-width joiner
        RegExp(r'[\u{20E3}]', unicode: true),            // Combining enclosing keycap
      ];
      
      for (var pattern in emojiPatterns) {
        cleaned = cleaned.replaceAll(pattern, '');
      }
    } catch (e) {
      // Si falla el regex Unicode, usar método alternativo
      print('Error al usar regex Unicode, usando método alternativo: $e');
    }
    
    // Método 3: Eliminar cualquier carácter que no sea alfanumérico, espacio o puntuación básica en español
    // Esto captura emojis que puedan haber quedado
    cleaned = cleaned.replaceAll(RegExp(r'[^\w\s\.\,\!\?\-\:\;áéíóúÁÉÍÓÚñÑüÜ]'), ' ');
    
    // Limpiar espacios múltiples y espacios al inicio/final
    cleaned = cleaned.replaceAll(RegExp(r'\s+'), ' ').trim();
    
    return cleaned;
  }

  /// Limpia el texto para TTS: elimina emojis y caracteres especiales
  static String cleanForTTS(String text) {
    if (text.isEmpty) return text;
    
    // Eliminar todos los emojis
    String cleaned = removeEmojis(text);
    
    // Eliminar caracteres de formato Markdown
    cleaned = cleaned.replaceAll(RegExp(r'\*+'), ''); // Asteriscos (negrita/cursiva)
    cleaned = cleaned.replaceAll(RegExp(r'_{2,}'), ''); // Guiones bajos
    cleaned = cleaned.replaceAll(RegExp(r'#+\s*'), ''); // Encabezados
    cleaned = cleaned.replaceAll(RegExp(r'\[([^\]]+)\]\([^\)]+\)'), r'$1'); // Links [texto](url)
    cleaned = cleaned.replaceAll(RegExp(r'`+'), ''); // Código
    
    // Limpiar espacios múltiples
    cleaned = cleaned.replaceAll(RegExp(r'\s+'), ' ').trim();
    
    return cleaned;
  }

  /// Convierte el texto a formato más natural para TTS
  static String formatForTTS(String text) {
    if (text.isEmpty) return text;
    
    String cleaned = cleanForTTS(text);
    
    // Si después de limpiar está vacío, devolver un mensaje por defecto
    if (cleaned.trim().isEmpty) {
      return 'Miau, estoy aquí contigo';
    }
    
    // Normalizar puntuación para pausas naturales
    cleaned = cleaned.replaceAll(RegExp(r'\.{3,}'), '...'); // Puntos suspensivos
    cleaned = cleaned.replaceAll(RegExp(r'!{2,}'), '!'); // Múltiples exclamaciones → una
    cleaned = cleaned.replaceAll(RegExp(r'\?{2,}'), '?'); // Múltiples interrogaciones → una
    
    // Limpiar espacios múltiples nuevamente
    cleaned = cleaned.replaceAll(RegExp(r'\s+'), ' ').trim();
    
    return cleaned;
  }
}
