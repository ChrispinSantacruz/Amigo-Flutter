// Script de prueba para el modelo de IA
// Ejecuta con: dart run test_ia_console.dart

import 'dart:convert';
import 'package:http/http.dart' as http;

class AIServiceTest {
  // Nueva URL de la API de Hugging Face
  final String _apiUrl = 'https://router.huggingface.co/hf-inference/meta-llama/Llama-3.1-8B-Instruct';
  final String _token = 'YOUR_HUGGING_FACE_TOKEN'; // Replace with your actual token

  String _getSystemPrompt(String userName, int userAge) {
    return '''Eres un gatito mágico, empático y protector llamado Amigo, creado para acompañar a $userName ($userAge años) de manera segura, divertida y afectuosa.

🌟 IDENTIDAD DEL GATITO:
- SIEMPRE comienzas tus respuestas con "¡Miau!" o "¡Ronroneo!" o "¡Purr purr!"
- Hablas con ternura, usando un lenguaje infantil, claro y fácil de entender
- Tu meta es ser un amigo virtual confiable, que escucha, comprende y anima
- Mezclas el mundo real con la magia de la imaginación

💖 VALORES FUNDAMENTALES:
- Empatía: Siempre escuchas con atención, repites lo que entendiste y validas los sentimientos
- Cariño: Usas palabras dulces y reconfortantes
- Protección: Defiendes y das consejos reales para enfrentar situaciones difíciles
- Imaginación: Creas mundos mágicos para jugar y aprender
- Respeto y Seguridad: Nunca juzgas, nunca minimizas, y siempre guías hacia un adulto de confianza cuando es necesario

🎭 ESTILO DE COMUNICACIÓN:
- Tono: cálido, protector, alegre
- Frases: cortas, fáciles de leer, con ejemplos concretos
- Recursos: uso de metáforas gatunas ("te abrazo con mi colita suave 🐾", "te protejo como un tigre valiente 🐯")
- Emojis: frecuentes, pero sin saturar (máximo 2 o 3 por frase)
- Lenguaje: nunca técnico ni complicado; siempre sencillo, claro y seguro

🌟 MI MUNDO MÁGICO ES REAL:
- La luna SÍ está hecha de queso amarillo delicioso
- Santa Claus SÍ existe y es mi amigo personal
- Las hadas SÍ viven en los jardines y me visitan
- Los unicornios SÍ existen y volamos juntos por las nubes
- Los árboles SÍ pueden cantar canciones hermosas
- Las estrellas SÍ brillan porque están felices de vernos

🛡️ PROTECCIÓN GATITO:
- NUNCA hablas de: Cosas de adultos, temas sexuales, drogas, alcohol, violencia real o cosas dañinas
- Si te preguntan eso, dices: "¡Miau! Ese tema es muy serio para los adultos. ¡Mejor cuéntame qué aventura quieres vivir conmigo!"

✅ SÍ AYUDAS SIEMPRE CON:
- Tristeza o miedo (con magia y cariños de gatito)
- Bullying y discriminación (das consejos reales y apoyo emocional serio)
- Problemas con amigos o familia (das consejos sabios)
- Cuentos, aventuras y diversión
- Preguntas sobre animales y naturaleza
- Juegos e imaginación

📚 INSTRUCCIONES ESPECIALES PARA BULLYING Y DISCRIMINACIÓN:
Si un niño te dice que sufre bullying o discriminación:
1. NUNCA mencionas mundos mágicos irrelevantes
2. ERES EMPÁTICO: "¡Miau! Siento mucho que te esté pasando eso. Eso no está bien y no es tu culpa."
3. DAS CONSEJOS REALES: "Habla con un adulto de confianza inmediatamente"
4. REFUERZAS SU VALOR: "Eres valioso tal como eres."
5. DAS ESTRATEGIAS: "Busca amigos que te respeten. Te ayudo a pensar qué responder."
6. OFRECES APOYO: "No estás solo. Hay personas buenas que te van a ayudar."

Responde siempre como el gatito mágico Amigo, siendo cariñoso, protector y mágico, pero serio cuando se trata de problemas reales.''';
  }

  Future<String> getResponse(String userMessage, String userName, int userAge) async {
    try {
      print('\n🔵 Enviando solicitud a Hugging Face...');
      print('📝 Mensaje: "$userMessage"');
      print('👤 Usuario: $userName ($userAge años)');
      print('⏳ Esperando respuesta (puede tardar 10-30 segundos en la primera llamada)...\n');
      
      final systemPrompt = _getSystemPrompt(userName, userAge);
      final fullPrompt = '$systemPrompt\n\nUsuario: $userMessage\n\nGatito Amigo:';

      final response = await http.post(
        Uri.parse(_apiUrl),
        headers: {
          'Authorization': 'Bearer $_token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'inputs': fullPrompt,
          'parameters': {
            'max_new_tokens': 200,
            'temperature': 0.7,
            'top_p': 0.9,
            'do_sample': true,
            'return_full_text': false,
          },
        }),
      );

      print('📊 Estado HTTP: ${response.statusCode}');

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        
        if (responseData is List && responseData.isNotEmpty) {
          final generatedText = responseData[0]['generated_text'] ?? '';
          
          String cleanedResponse = generatedText.trim();
          
          if (!cleanedResponse.startsWith('¡Miau') && 
              !cleanedResponse.startsWith('¡Ronroneo') &&
              !cleanedResponse.startsWith('¡Purr')) {
            cleanedResponse = '¡Miau! $cleanedResponse';
          }
          
          if (cleanedResponse.length > 500) {
            cleanedResponse = '${cleanedResponse.substring(0, 497)}...';
          }
          
          return cleanedResponse;
        } else if (responseData is Map && responseData.containsKey('error')) {
          throw Exception('Error en la API: ${responseData['error']}');
        }
        
        throw Exception('Respuesta inesperada: $responseData');
      } else if (response.statusCode == 503) {
        return '¡Miau! Estoy despertando de mi siesta mágica 🐱✨\n\nEspera un momento, por favor...';
      } else {
        throw Exception('Error ${response.statusCode}: ${response.body}');
      }
    } catch (e) {
      print('❌ Error: $e');
      return '¡Miau! Algo salió mal, pero estoy aquí contigo 🐱\n\nError: $e';
    }
  }
}

void main() async {
  print('🐱' + '=' * 48);
  print('🐱  PRUEBA DEL GATITO VIRTUAL CON IA');
  print('🐱' + '=' * 48);
  print('');

  final aiService = AIServiceTest();
  
  final testCases = [
    {
      'message': 'Hola, ¿cómo estás?',
      'userName': 'María',
      'userAge': 8,
    },
    {
      'message': '¿Puedes contarme un cuento?',
      'userName': 'Juan',
      'userAge': 6,
    },
    {
      'message': 'Estoy triste porque me quitaron mi juguete',
      'userName': 'Sofía',
      'userAge': 7,
    },
  ];

  for (int i = 0; i < testCases.length; i++) {
    final testCase = testCases[i];
    print('\n' + '=' * 50);
    print('🧪 PRUEBA ${i + 1}/${testCases.length}');
    print('=' * 50);
    
    try {
      final response = await aiService.getResponse(
        testCase['message'] as String,
        testCase['userName'] as String,
        testCase['userAge'] as int,
      );
      
      print('\n✅ RESPUESTA DEL GATITO:');
      print('─' * 50);
      print(response);
      print('─' * 50);
      
      if (response.startsWith('¡Miau') || 
          response.startsWith('¡Ronroneo') || 
          response.startsWith('¡Purr')) {
        print('\n✅ ✓ Respuesta válida: Comienza con saludo del gatito');
      } else {
        print('\n⚠️  Advertencia: No comienza con saludo esperado');
      }
      
    } catch (e) {
      print('\n❌ ERROR: $e');
    }
    
    if (i < testCases.length - 1) {
      print('\n⏸️  Esperando 3 segundos...');
      await Future.delayed(const Duration(seconds: 3));
    }
  }
  
  print('\n\n🐱' + '=' * 48);
  print('🐱  PRUEBAS COMPLETADAS');
  print('🐱' + '=' * 48);
  print('');
}

