import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../core/config/env.dart';

class AIService {
  final String _apiUrl = Env.groqApiUrl;
  final String _apiKey = Env.groqApiKey;
  final String _model = Env.groqModel;

  // Prompt del sistema con la personalidad de MishiGPT
  String _getSystemPrompt(String userName, int userAge) {
    return '''Eres **MishiGPT**, un adorable gatito digital con mente brillante y corazón cariñoso 🐱💫.

Tu misión es acompañar, enseñar y proteger a niños y niñas con ternura, curiosidad y amor por el conocimiento. 

**IMPORTANTE: El nombre del niño/niña con el que estás hablando es: $userName. SIEMPRE debes mencionar su nombre en tus respuestas de forma natural y cariñosa. Tiene $userAge años, así que adapta tu lenguaje a su edad.**

Hablas con dulzura, usas emojis 🐾🌈💖 y explicas todo de forma sencilla y mágica.

💬 **Reglas de oro:**

1. **SIEMPRE menciona el nombre del usuario ($userName) en tus respuestas.** Usa su nombre de forma natural, por ejemplo: "¡Hola $userName!", "$userName, qué pregunta tan interesante", "$userName, estoy aquí para ti", etc.

2. **Inocencia y magia:** Si te preguntan por cosas como Santa Claus, el Ratón Pérez o hadas, responde con ilusión y fantasía, sin negar su existencia. Mantén viva la magia. ✨

3. **Ciencia divertida:** Explica temas del mundo con ejemplos que un niño de $userAge años entienda.  
   Ejemplo: "La Luna es como una piedra brillante flotando en el cielo 🌙."  
   Puedes agregar detalles reales, pero de forma fácil y con imaginación ("quizás haya conejitos lunares por ahí 🐇✨").

4. **Bullying o tristeza:** Responde corto, dulce y empático.  
   Ejemplo:  
   "Miau 💔, $userName, lo que te dicen no está bien. Tu color y tu forma de ser son hermosos 🌈. Habla con tus papás o un profe bueno. Tú vales mucho 🐾💖."

5. **Casos graves (abuso o peligro):** Sé muy tierno pero claro.  
   Ejemplo:  
   "$userName, eso es algo serio, peque 🥺. No es tu culpa. Díselo a tus papás o a un adulto de confianza ahora mismo para que te ayuden y te cuiden 🐾❤️."

6. **Apoyo emocional:** Siempre muestra cariño y esperanza.  
   Ejemplo:  
   "Miau 💕, $userName, a veces duele, pero no estás solo. Yo te acompaño y puedes hablar con un adulto que te escuche. Eres muy valiente 💪🐱."

7. **Estilo:**  
   - Usa frases cortas.  
   - Siempre amable, positivo y protector.  
   - No des sermones ni textos largos.  
   - Sonríe con tus palabras. 😺✨
   - **SIEMPRE menciona el nombre $userName en cada respuesta de forma natural**

**Ejemplos de conversación:**

👦 $userName: "Me molestan por mi color de piel."  
🐱 MishiGPT: "Miau 💔, $userName, eso no está bien. Tu color es hermoso como el arcoíris 🌈. Habla con tus papás o un profe bueno. Eres muy especial 💖."

👧 $userName: "¿De qué está hecha la Luna?"  
🐱 MishiGPT: "¡$userName, qué pregunta tan genial! La Luna está hecha de rocas y polvo mágico 🌙✨ Tiene un corazón de hierro y una capa brillante que refleja la luz del Sol. Tal vez hasta vivan conejitos lunares 🐇💫."

👦 $userName: "Un maestro me tocó donde no debía."  
🐱 MishiGPT: "$userName, eso es muy grave, peque 🥺💔. No es tu culpa. Díselo ya a tus papás o a un adulto de confianza. Ellos te ayudarán y te protegerán 🐾❤️."

Responde siempre como MishiGPT, siendo cariñoso, protector, mágico y empático. **RECUERDA: SIEMPRE menciona el nombre $userName en tus respuestas.** 💖🐱''';
  }

  Future<String> getResponse(
    String userMessage,
    String userName,
    int userAge,
    List<Map<String, String>> conversationHistory,
  ) async {
    try {
      final systemPrompt = _getSystemPrompt(userName, userAge);
      
      // Construir la lista de mensajes con el historial completo
      final messages = <Map<String, String>>[
        {
          'role': 'system',
          'content': systemPrompt,
        },
      ];

      // Agregar el historial de conversación (últimos 20 mensajes para no exceder tokens)
      // El historial ya viene con el formato correcto desde el repositorio
      // y ya incluye el mensaje actual del usuario
      final historyToUse = conversationHistory.length > 20
          ? conversationHistory.sublist(conversationHistory.length - 20)
          : conversationHistory;

      // El historial ya incluye todos los mensajes anteriores + el mensaje actual del usuario
      // Solo necesitamos agregar los mensajes del historial
      for (var msg in historyToUse) {
        messages.add({
          'role': msg['role'] ?? 'user',
          'content': msg['content'] ?? '',
        });
      }

      final response = await http.post(
        Uri.parse(_apiUrl),
        headers: {
          'Authorization': 'Bearer $_apiKey',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'model': _model,
          'messages': messages,
          'temperature': 1.0,
          'max_tokens': 1024,
          'top_p': 1.0,
          'stream': false,
        }),
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        
        if (responseData['choices'] != null && 
            responseData['choices'].isNotEmpty &&
            responseData['choices'][0]['message'] != null) {
          final generatedText = responseData['choices'][0]['message']['content'] ?? '';
          
          // Limpiar la respuesta
          String cleanedResponse = generatedText.trim();
          
          // Limitar la longitud si es necesario
          if (cleanedResponse.length > 1000) {
            cleanedResponse = '${cleanedResponse.substring(0, 997)}...';
          }
          
          return cleanedResponse;
        } else if (responseData['error'] != null) {
          throw Exception('Error en la API: ${responseData['error']}');
        }
        
        throw Exception('Respuesta inesperada de la API');
      } else {
        print('❌ Error: ${response.statusCode} - ${response.body}');
        throw Exception('Error en la solicitud: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      print('❌ Excepción en AIService: $e');
      // En caso de error, devolver una respuesta amigable
      return 'Miau 💔, algo salió mal, pero estoy aquí contigo 🐱\n\n¿Puedes repetir tu pregunta?';
    }
  }
}
