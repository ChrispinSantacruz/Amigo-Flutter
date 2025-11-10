// Test simple para probar el servicio de IA
// Ejecuta con: flutter test test/test_ai_service.dart

import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_amigo/data/services/ai_service.dart';

void main() {
  group('AIService Tests', () {
    test('El servicio de IA debe responder con el saludo del gatito', () async {
      final aiService = AIService();
      
      print('\n🐱 Probando el servicio de IA...');
      print('📝 Enviando mensaje: "Hola, ¿cómo estás?"');
      
      final response = await aiService.getResponse(
        'Hola, ¿cómo estás?',
        'María',
        8,
      );
      
      print('\n✅ Respuesta recibida:');
      print(response);
      print('\n');
      
      // Verificar que la respuesta no esté vacía
      expect(response.isNotEmpty, true);
      
      // Verificar que empiece con el saludo del gatito
      expect(
        response.startsWith('¡Miau') || 
        response.startsWith('¡Ronroneo') || 
        response.startsWith('¡Purr'),
        true,
        reason: 'La respuesta debe empezar con el saludo del gatito',
      );
    }, timeout: const Timeout(Duration(minutes: 2))); // La primera llamada puede tardar
    
    test('El servicio debe manejar temas serios correctamente', () async {
      final aiService = AIService();
      
      print('\n🐱 Probando manejo de temas serios...');
      print('📝 Enviando mensaje sobre tristeza');
      
      final response = await aiService.getResponse(
        'Estoy triste porque me quitaron mi juguete',
        'Juan',
        7,
      );
      
      print('\n✅ Respuesta recibida:');
      print(response);
      print('\n');
      
      expect(response.isNotEmpty, true);
      expect(
        response.startsWith('¡Miau') || 
        response.startsWith('¡Ronroneo') || 
        response.startsWith('¡Purr'),
        true,
      );
    }, timeout: const Timeout(Duration(minutes: 2)));
  });
}




