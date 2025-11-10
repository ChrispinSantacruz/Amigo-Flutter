# 🐱 MishiGPT - Resumen de Funcionalidades

## ✨ Características Implementadas

### 🏠 Navegación Principal
- **Barra de navegación inferior** con 4 secciones:
  - 🏠 **Sala**: Chat con MishiGPT y ronroneo
  - 🍽️ **Comedor**: Alimentar a Mishi
  - 🎤 **Voz**: Hablar con Mishi por voz
  - 🛏️ **Dormitorio**: Dormir/Despertar a Mishi

### 🏠 Sala
- **Chat con IA**: Interfaz completa de chat con MishiGPT usando Groq
- **Ronroneo**: Tocar o mantener presionado a Mishi para que ronronee
- **Vista previa de mensajes**: Muestra los últimos 3 mensajes del chat
- **Burbujas de diálogo**: Mishi muestra mensajes cuando ronronea
- **Botón para abrir chat completo**: Acceso directo a la pantalla de chat completa

### 🍽️ Comedor
- **3 tipos de comida**:
  - 🐱 Comida de Gatos (+25 hambre, +10 felicidad)
  - 🐟 Atún (+30 hambre, +15 felicidad) - favorito de Mishi
  - 🐠 Pescado (+20 hambre, +12 felicidad)
- **Animaciones**: Mishi se anima cuando come
- **Burbujas de diálogo**: Mishi dice cosas como "¡Qué rico!" o "¡Mmm! El atún es mi favorito"
- **Indicadores de estado**: Muestra felicidad y hambre en tiempo real

### 🎤 Voz
- **Reconocimiento de voz**: Grabar mensajes hablados (speech_to_text)
- **Síntesis de voz**: Mishi habla las respuestas (flutter_tts)
- **Interfaz visual**: Indicadores de estado (escuchando, hablando)
- **Integración con IA**: Los mensajes de voz se procesan con MishiGPT
- **Botones de control**: Grabar, detener grabación, detener habla

### 🛏️ Dormitorio
- **Interruptor de luz**: Encender/apagar la luz para dormir/despertar a Mishi
- **Animaciones de sueño**: Mishi muestra "Zzzzzz..." cuando duerme
- **Cambio de ambiente**: Fondo oscuro cuando duerme, claro cuando está despierto
- **Burbujas de diálogo**: Mensajes como "¡Buenos días!" o "Mishi está soñando"
- **Indicador de sueño**: Muestra el nivel de sueño de Mishi

### 🐱 Sistema de Estado de Mishi
- **Hambre** (0-100): Disminuye con el tiempo, aumenta al comer
- **Sueño** (0-100): Aumenta con el tiempo, se resetea al dormir
- **Felicidad** (0-100): Aumenta con interacciones positivas
- **Estados especiales**: Durmiendo, comiendo
- **Mensajes de acción**: Burbujas de diálogo para acciones rápidas

### 🎨 Diseño
- **Temática infantil**: Colores pastel, gradientes suaves
- **Emojis**: Uso extensivo de emojis para hacerlo más amigable
- **Animaciones**: Animaciones suaves con flutter_animate
- **Burbujas de diálogo**: Mensajes visuales atractivos
- **Indicadores de estado**: Iconos y barras de progreso visuales

## 🔧 Tecnologías Utilizadas

- **Flutter**: Framework principal
- **Riverpod**: Gestión de estado global
- **Supabase**: Backend (autenticación y base de datos)
- **Groq API**: IA para las respuestas de MishiGPT
- **speech_to_text**: Reconocimiento de voz
- **flutter_tts**: Síntesis de voz
- **flutter_animate**: Animaciones

## 📱 Estructura de Archivos

```
lib/
├── domain/
│   └── entities/
│       └── mishi_state.dart          # Estado del gatito
├── presentation/
│   ├── providers/
│   │   └── mishi_provider.dart       # Provider de estado de Mishi
│   ├── screens/
│   │   ├── mishi_main_screen.dart    # Pantalla principal con navegación
│   │   ├── sala_screen.dart          # Sala - Chat y ronroneo
│   │   ├── comedor_screen.dart       # Comedor - Alimentar
│   │   ├── voz_screen.dart           # Voz - Grabar y hablar
│   │   └── dormitorio_screen.dart    # Dormitorio - Dormir/Despertar
│   └── widgets/
│       ├── bottom_nav_bar.dart       # Barra de navegación inferior
│       ├── mishi_character.dart      # Widget del personaje Mishi
│       └── action_bubble.dart        # Burbujas de diálogo
```

## 🚀 Próximos Pasos (Opcionales)

- [ ] Añadir más animaciones de Mishi (saltar, jugar, etc.)
- [ ] Sistema de logros/recompensas
- [ ] Mini-juegos interactivos
- [ ] Personalización de Mishi (colores, accesorios)
- [ ] Sonidos ambientales
- [ ] Recordatorios y notificaciones
- [ ] Estadísticas de uso
- [ ] Compartir momentos con Mishi

## 🎯 Funcionalidades Clave

1. **Chat con IA**: Conversaciones naturales con MishiGPT usando Groq
2. **Interacciones táctiles**: Tocar, mantener presionado, alimentar
3. **Voz**: Hablar y escuchar respuestas de Mishi
4. **Estados dinámicos**: Hambre, sueño, felicidad que cambian con el tiempo
5. **Animaciones**: Mishi reacciona a las interacciones
6. **Burbujas de diálogo**: Feedback visual inmediato
7. **Navegación intuitiva**: Barra inferior fácil de usar

---

¡MishiGPT está listo para ser tu compañero virtual! 🐱💕


