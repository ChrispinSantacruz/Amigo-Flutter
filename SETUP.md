# 🚀 Guía de Configuración - Flutter Amigo

## 📋 Requisitos Previos

1. Flutter SDK >=3.0.0
2. Cuenta de Supabase
3. Token de Hugging Face (ya incluido en el código)

## 🔧 Pasos de Configuración

### 1. Instalar Dependencias

```bash
flutter pub get
```

### 2. Configurar Supabase

1. Crea un proyecto en [Supabase](https://supabase.com)
2. Ve a Settings > API y copia:
   - URL del proyecto
   - Anon key

3. Edita `lib/core/config/env.dart` y actualiza:
```dart
static const String supabaseUrl = 'TU_SUPABASE_URL';
static const String supabaseAnonKey = 'TU_SUPABASE_ANON_KEY';
```

### 3. Crear Tabla en Supabase

Ejecuta este SQL en el SQL Editor de Supabase:

```sql
-- Crear tabla de usuarios
CREATE TABLE users (
  id UUID PRIMARY KEY REFERENCES auth.users(id) ON DELETE CASCADE,
  email TEXT NOT NULL,
  name TEXT NOT NULL,
  age INTEGER NOT NULL,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Habilitar RLS (Row Level Security)
ALTER TABLE users ENABLE ROW LEVEL SECURITY;

-- Política para que los usuarios puedan leer sus propios datos
CREATE POLICY "Users can read own data"
  ON users FOR SELECT
  USING (auth.uid() = id);

-- Política para que los usuarios puedan insertar sus propios datos
CREATE POLICY "Users can insert own data"
  ON users FOR INSERT
  WITH CHECK (auth.uid() = id);

-- Política para que los usuarios puedan actualizar sus propios datos
CREATE POLICY "Users can update own data"
  ON users FOR UPDATE
  USING (auth.uid() = id);
```

### 4. Configurar Android/iOS (si es necesario)

#### Android
- Asegúrate de que `minSdkVersion` sea al menos 21 en `android/app/build.gradle`

#### iOS
- Asegúrate de que el deployment target sea iOS 11.0 o superior

### 5. Ejecutar la Aplicación

```bash
flutter run
```

## 📱 Funcionalidades

- ✅ Registro de usuarios (con validación de edad 3-12 años)
- ✅ Login de usuarios
- ✅ Chat con el gatito virtual usando IA
- ✅ Almacenamiento local de mensajes
- ✅ Sincronización con Supabase
- ✅ UI infantil y colorida

## 🐱 Personalidad del Gatito

El gatito virtual tiene las siguientes características:
- Empieza siempre con "¡Miau!" o "¡Ronroneo!"
- Lenguaje infantil y tierno
- Protector y empático
- Maneja temas serios (bullying) de forma apropiada
- Crea mundos mágicos para jugar

## 🔒 Seguridad

- Los datos se almacenan de forma segura en Supabase
- Row Level Security (RLS) habilitado
- Validación de edad (3-12 años)
- Contraseñas encriptadas

## 📝 Notas

- El token de Hugging Face ya está configurado en el código
- La primera llamada a la API de Hugging Face puede tardar unos segundos (el modelo se carga)
- Los mensajes se guardan tanto localmente como en Supabase




