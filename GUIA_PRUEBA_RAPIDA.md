# 🧪 Guía de Prueba Rápida - MishiGPT

## 🚀 Pasos para Probar la Aplicación

### 1. **Registro de Usuario**
1. La aplicación se abrirá en Chrome
2. Verás la pantalla de Login
3. Haz clic en "¿No tienes cuenta? Regístrate"
4. Completa el formulario:
   - **Nombre**: Ej. "María" o "Juan"
   - **Edad**: Entre 3 y 12 años (Ej. 8)
   - **Email**: Un email válido (Ej. "maria@test.com")
   - **Contraseña**: Mínimo 6 caracteres (Ej. "123456")
   - **Confirmar Contraseña**: La misma contraseña
5. Haz clic en "Registrarse"
6. Deberías ser redirigido a la pantalla principal de MishiGPT

### 2. **Pantalla Principal - Navegación**
Verás la pantalla principal con:
- **Header**: MishiGPT con tu nombre y botón de logout
- **Indicadores de estado**: Felicidad, Hambre, Sueño
- **Barra de navegación inferior** con 4 botones:
  - 🏠 **Sala**: Chat con MishiGPT
  - 🍽️ **Comedor**: Alimentar a Mishi
  - 🎤 **Voz**: Hablar con Mishi
  - 🛏️ **Dormitorio**: Dormir/Despertar a Mishi

### 3. **Probar la Sala (Chat)**
1. Haz clic en el botón **Sala** (🏠)
2. Verás a Mishi en el centro
3. **Toca a Mishi** - Debería ronronear y mostrar un mensaje
4. Haz clic en **"Abrir Chat Completo"**
5. Envía un mensaje, por ejemplo: "Hola MishiGPT"
6. **Verifica que MishiGPT menciona tu nombre** en la respuesta
7. Envía más mensajes para verificar que el contexto se mantiene

### 4. **Probar el Comedor**
1. Haz clic en el botón **Comedor** (🍽️)
2. Verás a Mishi y opciones de comida
3. Haz clic en una de las comidas:
   - 🐱 Comida de Gatos
   - 🐟 Atún (favorito de Mishi)
   - 🐠 Pescado
4. Mishi debería animarse y mostrar un mensaje como "¡Qué rico!"
5. Los indicadores de hambre y felicidad deberían aumentar

### 5. **Probar el Dormitorio**
1. Haz clic en el botón **Dormitorio** (🛏️)
2. Verás el interruptor de luz
3. Haz clic en el interruptor para **apagar la luz**
4. Mishi debería dormir y mostrar "Zzzzzz..."
5. El fondo debería volverse oscuro
6. Haz clic nuevamente para **encender la luz**
7. Mishi debería despertar y mostrar "¡Buenos días!"

### 6. **Probar la Voz (Opcional)**
1. Haz clic en el botón **Voz** (🎤)
2. **Nota**: En la web, necesitarás permitir el acceso al micrófono
3. Haz clic en el botón de grabar
4. Habla un mensaje (Ej. "Hola MishiGPT, ¿cómo estás?")
5. MishiGPT debería responder por voz
6. **Nota**: La funcionalidad de voz puede tener limitaciones en la web

### 7. **Verificar Persistencia de Mensajes**
1. Ve a la **Sala** y envía varios mensajes
2. Haz clic en el botón de **logout** (arriba a la derecha)
3. Vuelve a iniciar sesión con el mismo usuario
4. Ve a la **Sala** nuevamente
5. **Verifica que tus mensajes anteriores se cargan**
6. El contexto de la conversación se mantiene

## ✅ Checklist de Verificación

### Autenticación
- [ ] Puedo registrarme con nombre, email, contraseña y edad
- [ ] Puedo iniciar sesión con email y contraseña
- [ ] Los datos se guardan correctamente en Supabase

### Chat con MishiGPT
- [ ] Puedo enviar mensajes a MishiGPT
- [ ] MishiGPT responde con mensajes coherentes
- [ ] **MishiGPT menciona mi nombre en las respuestas**
- [ ] El contexto de la conversación se mantiene
- [ ] Los mensajes se guardan en Supabase
- [ ] Los mensajes se cargan al reiniciar la sesión

### Interacciones con Mishi
- [ ] Puedo hacer que Mishi ronronee tocándolo
- [ ] Puedo alimentar a Mishi en el Comedor
- [ ] Puedo dormir/despertar a Mishi en el Dormitorio
- [ ] Las animaciones funcionan correctamente
- [ ] Los indicadores de estado se actualizan

### Navegación
- [ ] Puedo navegar entre Sala, Comedor, Voz y Dormitorio
- [ ] La barra de navegación funciona correctamente
- [ ] Puedo hacer logout y volver a iniciar sesión

## 🐛 Problemas Comunes

### Error: "No se puede conectar a Supabase"
- Verifica que las credenciales en `lib/core/config/env.dart` sean correctas
- Verifica que las tablas en Supabase estén creadas (ejecuta `supabase_setup.sql`)

### Error: "MishiGPT no menciona mi nombre"
- Verifica que el nombre se haya guardado correctamente en Supabase
- Verifica que el nombre se pase correctamente al servicio de IA

### Error: "Los mensajes no se cargan"
- Verifica que la tabla `messages` exista en Supabase
- Verifica que las políticas RLS estén configuradas correctamente
- Verifica que el usuario esté autenticado correctamente

### Error: "La voz no funciona"
- En la web, la funcionalidad de voz puede tener limitaciones
- Asegúrate de permitir el acceso al micrófono en Chrome
- Verifica que el navegador soporte Web Speech API

## 📝 Notas

- La aplicación está optimizada para Chrome
- La funcionalidad de voz puede tener limitaciones en la web
- Los mensajes se guardan en tiempo real en Supabase
- El contexto de la conversación se mantiene entre sesiones
- MishiGPT siempre menciona el nombre del usuario en sus respuestas

---

¡Disfruta probando MishiGPT! 🐱💕


