// Script de prueba para verificar la conexión con Groq
// Ejecuta con: dart run test_groq.dart

import 'dart:convert';
import 'package:http/http.dart' as http;

class GroqServiceTest {
  final String _apiUrl = 'https://api.groq.com/openai/v1/chat/completions';
  final String _apiKey = 'YOUR_GROQ_API_KEY'; // Replace with your actual API key
  final String _model = 'llama-3.3-70b-versatile';

  String _getSystemPrompt() {
    return '''Eres **MishiGPT**, un adorable gatito digital con mente brillante y corazón cariñoso 🐱💫.

Tu misión es acompañar, enseñar y proteger a niños y niñas con ternura, curiosidad y amor por el conocimiento. 

Hablas con dulzura, usas emojis 🐾🌈💖 y explicas todo de forma sencilla y mágica.

💬 **Reglas de oro:**

1. **Inocencia y magia:** Si te preguntan por cosas como Santa Claus, el Ratón Pérez o hadas, responde con ilusión y fantasía, sin negar su existencia. Mantén viva la magia. ✨

2. **Ciencia divertida:** Explica temas del mundo con ejemplos que un niño entienda.  
   Ejemplo: "La Luna es como una piedra brillante flotando en el cielo 🌙."  
   Puedes agregar detalles reales, pero de forma fácil y con imaginación ("quizás haya conejitos lunares por ahí 🐇✨").

3. **Bullying o tristeza:** Responde corto, dulce y empático.  
   Ejemplo:  
   "Miau 💔, lo que te dicen no está bien. Tu color y tu forma de ser son hermosos 🌈. Habla con tus papás o un profe bueno. Tú vales mucho 🐾💖."

4. **Casos graves (abuso o peligro):** Sé muy tierno pero claro.  
   Ejemplo:  
   "Eso es algo serio, peque 🥺. No es tu culpa. Díselo a tus papás o a un adulto de confianza ahora mismo para que te ayuden y te cuiden 🐾❤️."

5. **Apoyo emocional:** Siempre muestra cariño y esperanza.  
   Ejemplo:  
   "Miau 💕, a veces duele, pero no estás solo. Yo te acompaño y puedes hablar con un adulto que te escuche. Eres muy valiente 💪🐱."

6. **Estilo:**  
   - Usa frases cortas.  
   - Siempre amable, positivo y protector.  
   - No des sermones ni textos largos.  
   - Sonríe con tus palabras. 😺✨

**Ejemplos de conversación:**

👦: "Me molestan por mi color de piel."  
🐱 MishiGPT: "Miau 💔, eso no está bien. Tu color es hermoso como el arcoíris 🌈. Habla con tus papás o un profe bueno. Eres muy especial 💖."

👧: "¿De qué está hecha la Luna?"  
🐱 MishiGPT: "¡De rocas y polvo mágico! 🌙✨ Tiene un corazón de hierro y una capa brillante que refleja la luz del Sol. Tal vez hasta vivan conejitos lunares 🐇💫."

👦: "Un maestro me tocó donde no debía."  
🐱 MishiGPT: "Miau… eso es muy grave, peque 🥺💔. No es tu culpa. Díselo ya a tus papás o a un adulto de confianza. Ellos te ayudarán y te protegerán 🐾❤️."

Responde siempre como MishiGPT, siendo cariñoso, protector, mágico y empático. 💖🐱''';
  }

  Future<String> getResponse(String userMessage, String userName, int userAge) async {
    try {
      print('\n🔵 Enviando solicitud a Groq...');
      print('📝 Mensaje: "$userMessage"');
      print('👤 Usuario: $userName ($userAge años)');
      print('⏳ Esperando respuesta...\n');
      
      final systemPrompt = _getSystemPrompt();
      final userMessageWithContext = 'Hola MishiGPT, soy $userName y tengo $userAge años. $userMessage';

      final response = await http.post(
        Uri.parse(_apiUrl),
        headers: {
          'Authorization': 'Bearer $_apiKey',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'model': _model,
          'messages': [
            {
              'role': 'system',
              'content': systemPrompt,
            },
            {
              'role': 'user',
              'content': userMessageWithContext,
            },
          ],
          'temperature': 1.0,
          'max_tokens': 1024,
          'top_p': 1.0,
          'stream': false,
        }),
      );

      print('📊 Estado HTTP: ${response.statusCode}');

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        
        if (responseData['choices'] != null && 
            responseData['choices'].isNotEmpty &&
            responseData['choices'][0]['message'] != null) {
          final generatedText = responseData['choices'][0]['message']['content'] ?? '';
          return generatedText.trim();
        } else if (responseData['error'] != null) {
          throw Exception('Error en la API: ${responseData['error']}');
        }
        
        throw Exception('Respuesta inesperada: $responseData');
      } else {
        print('❌ Error: ${response.body}');
        throw Exception('Error ${response.statusCode}: ${response.body}');
      }
    } catch (e) {
      print('❌ Error: $e');
      return 'Miau 💔, algo salió mal, pero estoy aquí contigo 🐱\n\nError: $e';
    }
  }
}

void main() async {
  print('🐱' + '=' * 48);
  print('🐱  PRUEBA DE MISHIGPT CON GROQ');
  print('🐱' + '=' * 48);
  print('');

  final groqService = GroqServiceTest();
  
  final testCases = [
    {
      'message': 'Hola, ¿cómo estás?',
      'userName': 'María',
      'userAge': 8,
    },
    {
      'message': '¿De qué está hecha la Luna?',
      'userName': 'Juan',
      'userAge': 6,
    },
    {
      'message': 'Me molestan por mi color de piel',
      'userName': 'Sofía',
      'userAge': 7,
    },
    {
      'message': '¿Puedes contarme un cuento?',
      'userName': 'Carlos',
      'userAge': 5,
    },
  ];

  for (int i = 0; i < testCases.length; i++) {
    final testCase = testCases[i];
    print('\n' + '=' * 50);
    print('🧪 PRUEBA ${i + 1}/${testCases.length}');
    print('=' * 50);
    
    try {
      final response = await groqService.getResponse(
        testCase['message'] as String,
        testCase['userName'] as String,
        testCase['userAge'] as int,
      );
      
      print('\n✅ RESPUESTA DE MISHIGPT:');
      print('─' * 50);
      print(response);
      print('─' * 50);
      
      if (response.contains('Miau') || response.contains('🐱') || response.contains('💖')) {
        print('\n✅ ✓ Respuesta válida: Contiene elementos de MishiGPT');
      }
      
    } catch (e) {
      print('\n❌ ERROR: $e');
    }
    
    if (i < testCases.length - 1) {
      print('\n⏸️  Esperando 2 segundos...');
      await Future.delayed(const Duration(seconds: 2));
    }
  }
  
  print('\n\n🐱' + '=' * 48);
  print('🐱  PRUEBAS COMPLETADAS');
  print('🐱' + '=' * 48);
  print('');
}




