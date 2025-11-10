# 🔐 Flujo de Autenticación y Chat - MishiGPT

## ✅ Flujo Implementado

### 1. **Registro de Usuario**
- El usuario ingresa:
  - **Nombre** (requerido)
  - **Email** (requerido, validado)
  - **Contraseña** (mínimo 6 caracteres)
  - **Edad** (entre 3 y 12 años)
- Los datos se guardan en Supabase:
  - En la tabla `auth.users` (email y contraseña)
  - En la tabla `users` (id, email, name, age, created_at)

### 2. **Login de Usuario**
- El usuario ingresa:
  - **Email**
  - **Contraseña**
- Se autentica con Supabase Auth
- Se obtienen los datos del usuario desde la tabla `users`
- Se redirige a la pantalla principal de MishiGPT

### 3. **Chat con Contexto Completo**
- **Los mensajes se guardan en Supabase** en la tabla `messages`:
  - `id`: UUID único
  - `user_id`: ID del usuario
  - `message`: Texto del mensaje
  - `is_from_user`: Boolean (true para usuario, false para MishiGPT)
  - `created_at`: Timestamp

- **El contexto se mantiene**:
  - Al enviar un mensaje, se cargan todos los mensajes previos desde Supabase
  - Se envía el historial completo (últimos 20 mensajes) a la IA de Groq
  - La IA responde con el contexto completo de la conversación
  - Tanto el mensaje del usuario como la respuesta de MishiGPT se guardan en Supabase

### 4. **MishiGPT Siempre Menciona el Nombre del Usuario**
- El prompt del sistema incluye el nombre del usuario
- La IA está instruida para **SIEMPRE mencionar el nombre del usuario** en sus respuestas
- Ejemplos:
  - "¡Hola [Nombre]!"
  - "[Nombre], qué pregunta tan interesante"
  - "[Nombre], estoy aquí para ti"

## 🔧 Implementación Técnica

### Archivos Clave

1. **`lib/data/repositories/auth_repository_impl.dart`**
   - Maneja registro y login con Supabase
   - Guarda datos del usuario en la tabla `users`

2. **`lib/data/repositories/chat_repository_impl.dart`**
   - Guarda mensajes en Supabase
   - Obtiene el historial completo de mensajes
   - Envía el contexto completo a la IA

3. **`lib/data/services/ai_service.dart`**
   - Recibe el historial completo de conversación
   - El prompt del sistema incluye el nombre del usuario
   - La IA está instruida para mencionar el nombre en cada respuesta

4. **`lib/presentation/providers/chat_provider.dart`**
   - Carga mensajes desde Supabase al iniciar
   - Envía mensajes con el historial completo
   - Recarga mensajes después de enviar para sincronizar

### Flujo de Envío de Mensaje

1. Usuario escribe un mensaje
2. Se carga el historial actual desde el estado
3. Se llama a `sendMessage` con el historial
4. El repositorio:
   - Guarda el mensaje del usuario en Supabase
   - Convierte el historial al formato de la IA (incluyendo el nuevo mensaje)
   - Envía el historial completo a Groq
   - Guarda la respuesta de MishiGPT en Supabase
5. Se recargan todos los mensajes desde Supabase
6. El estado se actualiza con los nuevos mensajes

## 📊 Base de Datos Supabase

### Tabla `users`
```sql
CREATE TABLE users (
  id UUID PRIMARY KEY REFERENCES auth.users(id),
  email TEXT NOT NULL,
  name TEXT NOT NULL,
  age INTEGER NOT NULL CHECK (age >= 3 AND age <= 12),
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);
```

### Tabla `messages`
```sql
CREATE TABLE messages (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID NOT NULL REFERENCES auth.users(id),
  message TEXT NOT NULL,
  is_from_user BOOLEAN NOT NULL DEFAULT true,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);
```

## 🎯 Características Clave

✅ **Autenticación completa** con Supabase
✅ **Registro con validación** de edad (3-12 años)
✅ **Login con email y contraseña**
✅ **Mensajes guardados en Supabase**
✅ **Contexto completo** de conversación
✅ **MishiGPT menciona el nombre** del usuario en cada respuesta
✅ **Historial persistente** - las conversaciones se mantienen entre sesiones
✅ **RLS (Row Level Security)** - cada usuario solo ve sus propios mensajes

## 🚀 Próximos Pasos

1. ✅ Registro con nombre, email, contraseña y edad
2. ✅ Login con email y contraseña
3. ✅ Guardar mensajes en Supabase
4. ✅ Cargar historial de conversación
5. ✅ Enviar contexto completo a la IA
6. ✅ MishiGPT menciona el nombre del usuario
7. ✅ Persistencia de conversaciones

---

¡El flujo completo está implementado y funcionando! 🐱💕


