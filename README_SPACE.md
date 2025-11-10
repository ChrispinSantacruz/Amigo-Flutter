# 📋 Instrucciones para Crear el Space en Hugging Face

## Pasos para Crear el Space

1. **Ir a Hugging Face Spaces**
   - Ve a [https://huggingface.co/spaces](https://huggingface.co/spaces)
   - Haz clic en "Create new Space"

2. **Configurar el Space**
   - **Nombre del Space**: `gatito-virtual-amigo` (o el nombre que prefieras)
   - **SDK**: Selecciona **Gradio**
   - **Visibility**: Público o Privado (según prefieras)
   - Haz clic en "Create Space"

3. **Subir los Archivos**
   - Sube el archivo `app.py` que creamos
   - Sube el archivo `requirements.txt`
   - Sube el archivo `README.md` (opcional, pero recomendado)

4. **Configurar el Hardware**
   - Ve a "Settings" en tu Space
   - En "Hardware", selecciona al menos **CPU basic** (o GPU si está disponible)
   - Para el modelo Llama 3.1-8B, se recomienda GPU si es posible

5. **Esperar a que se Construya**
   - Hugging Face construirá automáticamente el Space
   - Esto puede tardar varios minutos la primera vez
   - Verás el progreso en la pestaña "Logs"

6. **Obtener la URL de la API**
   - Una vez que el Space esté funcionando, la URL será:
     `https://TU_USUARIO-gatito-virtual-amigo.hf.space`
   - La API estará disponible en:
     `https://TU_USUARIO-gatito-virtual-amigo.hf.space/api/chat`

## 🔧 Configuración Adicional

### Variables de Entorno (Opcional)

Si necesitas configurar variables de entorno:
- Ve a "Settings" > "Repository secrets"
- Agrega cualquier variable que necesites

### Hardware Recomendado

- **Mínimo**: CPU basic (puede ser lento)
- **Recomendado**: GPU T4 small o superior
- **Óptimo**: GPU A10G o superior

## 📱 Usar desde Flutter

Una vez que el Space esté funcionando, actualiza `lib/data/services/ai_service.dart`:

```dart
final String _apiUrl = 'https://TU_USUARIO-gatito-virtual-amigo.hf.space/api/chat';
```

Y actualiza el método `getResponse` para usar el nuevo formato:

```dart
final response = await http.post(
  Uri.parse(_apiUrl),
  headers: {
    'Content-Type': 'application/json',
  },
  body: jsonEncode({
    'message': userMessage,
    'user_name': userName,
    'user_age': userAge,
  }),
);

final responseData = jsonDecode(response.body);
if (responseData['success'] == true) {
  return responseData['response'];
} else {
  throw Exception(responseData['error']);
}
```

## 🐛 Solución de Problemas

### El modelo no se carga
- Verifica que tienes suficiente espacio/hardware
- Revisa los logs en la pestaña "Logs" del Space
- Asegúrate de que el modelo existe: `meta-llama/Llama-3.1-8B-Instruct`

### La API no responde
- Verifica que el Space está en funcionamiento (no está durmiendo)
- Revisa que la URL de la API es correcta
- Verifica los logs para errores

### Errores de memoria
- Aumenta el hardware asignado al Space
- Considera usar un modelo más pequeño o cuantizado

## 📚 Recursos

- [Documentación de Hugging Face Spaces](https://huggingface.co/docs/hub/spaces)
- [Documentación de Gradio](https://www.gradio.app/docs/)
- [Documentación de Llama 3.1](https://huggingface.co/meta-llama/Llama-3.1-8B-Instruct)




