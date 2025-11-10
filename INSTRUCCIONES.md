# 🐱 Instrucciones de Instalación - Flutter Amigo

## 📋 Pasos para Configurar la Aplicación

### 1. Instalar Dependencias

Abre una terminal en la carpeta del proyecto y ejecuta:

```bash
flutter pub get
```

### 2. Configurar Supabase

1. **Crear cuenta en Supabase:**
   - Ve a [https://supabase.com](https://supabase.com)
   - Crea una cuenta (es gratis)
   - Crea un nuevo proyecto

2. **Obtener credenciales:**
   - En el panel de Supabase, ve a **Settings** > **API**
   - Copia la **URL** del proyecto
   - Copia la **anon/public key**

3. **Configurar en la app:**
   - Abre el archivo `lib/core/config/env.dart`
   - Reemplaza `YOUR_SUPABASE_URL` con tu URL de Supabase
   - Reemplaza `YOUR_SUPABASE_ANON_KEY` con tu anon key

### 3. Crear Tabla en Supabase

1. En el panel de Supabase, ve a **SQL Editor**
2. Copia y pega el contenido del archivo `supabase_setup.sql`
3. Ejecuta el script SQL
4. Verifica que la tabla `users` se haya creado correctamente

### 4. Ejecutar la Aplicación

```bash
flutter run
```

## 🎯 Funcionalidades Implementadas

✅ **Registro de Usuarios:**
   - Validación de edad (3-12 años)
   - Campos: nombre, edad, email, contraseña
   - Almacenamiento en Supabase

✅ **Login de Usuarios:**
   - Autenticación segura con Supabase
   - Validación de credenciales

✅ **Chat con Gatito Virtual:**
   - Integración con IA (Llama 3.1)
   - Personalidad del gatito configurada
   - Almacenamiento local de mensajes
   - UI infantil y colorida

✅ **Arquitectura:**
   - Clean Architecture
   - Manejo de estado con Riverpod
   - Base de datos local (SQLite)
   - Sincronización con Supabase

## 🐱 Personalidad del Gatito

El gatito virtual tiene las siguientes características:

- **Saludo:** Siempre empieza con "¡Miau!" o "¡Ronroneo!"
- **Lenguaje:** Infantil, tierno y fácil de entender
- **Personalidad:** Protector, empático y mágico
- **Temas serios:** Maneja bullying y discriminación de forma apropiada
- **Imaginación:** Crea mundos mágicos para jugar

## 🔒 Seguridad

- Row Level Security (RLS) habilitado en Supabase
- Validación de edad en el registro
- Contraseñas encriptadas
- Autenticación segura

## 📱 Estructura del Proyecto

```
lib/
├── core/           # Configuración y utilidades
│   ├── config/     # Configuración (Supabase, Hugging Face)
│   ├── constants/  # Constantes de la aplicación
│   └── utils/      # Utilidades (colores, base de datos)
├── data/           # Capa de datos
│   ├── datasources/# Fuentes de datos
│   ├── repositories/# Implementación de repositorios
│   └── services/   # Servicios (IA)
├── domain/         # Capa de dominio
│   ├── entities/   # Entidades
│   ├── repositories/# Interfaces de repositorios
│   └── usecases/   # Casos de uso
└── presentation/   # Capa de presentación
    ├── providers/  # Providers de Riverpod
    └── screens/    # Pantallas de la aplicación
```

## 🚨 Solución de Problemas

### Error: "Target of URI doesn't exist"
**Solución:** Ejecuta `flutter pub get` para instalar las dependencias.

### Error: "Supabase connection failed"
**Solución:** Verifica que las credenciales en `env.dart` sean correctas.

### Error: "Table users does not exist"
**Solución:** Ejecuta el script SQL en Supabase (ver paso 3).

### Error: "Hugging Face API error"
**Solución:** La primera llamada puede tardar unos segundos (el modelo se carga). Espera y vuelve a intentar.

## 📝 Notas Importantes

- El token de Hugging Face ya está configurado en el código
- La primera llamada a la API de Hugging Face puede tardar 10-30 segundos (el modelo se carga)
- Los mensajes se guardan tanto localmente como en Supabase
- La aplicación requiere conexión a internet para funcionar

## 🎨 Personalización

Puedes personalizar:
- Colores en `lib/core/utils/app_colors.dart`
- Mensajes del gatito en `lib/data/services/ai_service.dart`
- Personalidad del gatito modificando el prompt del sistema

## 📞 Soporte

Si tienes problemas, verifica:
1. Que todas las dependencias estén instaladas
2. Que Supabase esté configurado correctamente
3. Que la tabla `users` exista en Supabase
4. Que tengas conexión a internet

¡Disfruta de tu gatito virtual! 🐱✨




