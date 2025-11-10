# 📡 Cómo Usar la API de Gradio desde Flutter

## Endpoint de la API

Gradio expone automáticamente una API cuando creas una interfaz. Para usar la función `generate_response`, necesitas usar el endpoint `/api/predict/`.

## Formato de la Solicitud

**URL:** `https://TU_SPACE.hf.space/api/predict/`

**Método:** POST

**Headers:**
```
Content-Type: application/json
```

**Body:**
```json
{
  "data": [
    "mensaje del usuario",
    "nombre del usuario",
    8
  ]
}
```

**Response:**
```json
{
  "data": [
    "¡Miau! Respuesta del gatito..."
  ]
}
```

## Ejemplo en Flutter

```dart
import 'dart:convert';
import 'package:http/http.dart' as http;

Future<String> getGatitoResponse(String message, String userName, int userAge) async {
  final response = await http.post(
    Uri.parse('https://TU_USUARIO-gatito-virtual-amigo.hf.space/api/predict/'),
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode({
      'data': [message, userName, userAge]
    }),
  );

  if (response.statusCode == 200) {
    final data = jsonDecode(response.body);
    return data['data'][0] as String;
  } else {
    throw Exception('Error: ${response.statusCode}');
  }
}
```

## Actualizar el Servicio de IA en Flutter

Actualiza `lib/data/services/ai_service.dart`:

```dart
Future<String> getResponse(String userMessage, String userName, int userAge) async {
  try {
    final response = await http.post(
      Uri.parse('https://TU_USUARIO-gatito-virtual-amigo.hf.space/api/predict/'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'data': [userMessage, userName, userAge]
      }),
    );

    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);
      final generatedText = responseData['data'][0] as String;
      
      // Limpiar la respuesta
      String cleanedResponse = generatedText.trim();
      
      // Si no empieza con "¡Miau!", agregarlo
      if (!cleanedResponse.startsWith('¡Miau') && 
          !cleanedResponse.startsWith('¡Ronroneo') &&
          !cleanedResponse.startsWith('¡Purr')) {
        cleanedResponse = '¡Miau! $cleanedResponse';
      }
      
      // Limitar la longitud
      if (cleanedResponse.length > 500) {
        cleanedResponse = '${cleanedResponse.substring(0, 497)}...';
      }
      
      return cleanedResponse;
    } else {
      throw Exception('Error en la solicitud: ${response.statusCode}');
    }
  } catch (e) {
    return '¡Miau! Algo salió mal, pero estoy aquí contigo 🐱\n\n¿Puedes repetir tu pregunta?';
  }
}
```

## Notas Importantes

1. **Reemplaza `TU_USUARIO`** con tu nombre de usuario de Hugging Face
2. **Reemplaza `gatito-virtual-amigo`** con el nombre de tu Space
3. La URL completa será: `https://TU_USUARIO-gatito-virtual-amigo.hf.space/api/predict/`
4. El Space debe estar despierto (no durmiendo) para que la API funcione
5. La primera solicitud puede tardar más tiempo si el modelo está cargando

## Alternativa: Usar FastAPI

Si prefieres una API REST más estándar, puedes usar el archivo `app_with_fastapi.py` que crea un endpoint `/api/chat` más fácil de usar.




