-- Script SQL para configurar Supabase - VERSIÓN MEJORADA
-- Ejecuta este script en el SQL Editor de Supabase

-- ============================================
-- 1. CONFIGURACIÓN DE AUTENTICACIÓN
-- ============================================

-- Deshabilitar confirmación de email (opcional, para desarrollo)
-- Ve a Authentication > Settings > Auth en el dashboard de Supabase
-- y desactiva "Enable email confirmations" si quieres registro inmediato

-- ============================================
-- 2. CREAR TABLA DE USUARIOS
-- ============================================

-- Eliminar tabla si existe (solo para desarrollo)
-- DROP TABLE IF EXISTS users CASCADE;

-- Crear tabla de usuarios
CREATE TABLE IF NOT EXISTS users (
  id UUID PRIMARY KEY REFERENCES auth.users(id) ON DELETE CASCADE,
  email TEXT NOT NULL,
  name TEXT NOT NULL,
  age INTEGER NOT NULL CHECK (age >= 3 AND age <= 12),
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- ============================================
-- 3. CONFIGURAR RLS (Row Level Security)
-- ============================================

-- Habilitar RLS
ALTER TABLE users ENABLE ROW LEVEL SECURITY;

-- Eliminar políticas existentes si existen
DROP POLICY IF EXISTS "Users can read own data" ON users;
DROP POLICY IF EXISTS "Users can insert own data" ON users;
DROP POLICY IF EXISTS "Users can update own data" ON users;
DROP POLICY IF EXISTS "Enable insert for authenticated users only" ON users;

-- Política para que los usuarios puedan leer sus propios datos
CREATE POLICY "Users can read own data"
  ON users FOR SELECT
  USING (auth.uid() = id);

-- Política para que los usuarios puedan insertar sus propios datos
-- IMPORTANTE: Esta política permite que un usuario inserte su propio registro
CREATE POLICY "Users can insert own data"
  ON users FOR INSERT
  WITH CHECK (auth.uid() = id);

-- Política alternativa: Permitir inserción durante el registro
-- Esta política es más permisiva y puede ayudar durante el registro
CREATE POLICY "Enable insert for authenticated users only"
  ON users FOR INSERT
  TO authenticated
  WITH CHECK (auth.uid() = id);

-- Política para que los usuarios puedan actualizar sus propios datos
CREATE POLICY "Users can update own data"
  ON users FOR UPDATE
  USING (auth.uid() = id)
  WITH CHECK (auth.uid() = id);

-- ============================================
-- 4. CREAR FUNCIÓN PARA INSERTAR USUARIO AUTOMÁTICAMENTE
-- ============================================

-- Función que se ejecuta cuando se crea un usuario en auth.users
CREATE OR REPLACE FUNCTION public.handle_new_user()
RETURNS TRIGGER AS $$
BEGIN
  -- Intentar insertar en la tabla users
  -- Si el usuario ya existe, no hacer nada
  INSERT INTO public.users (id, email, name, age, created_at)
  VALUES (
    NEW.id,
    NEW.email,
    COALESCE(NEW.raw_user_meta_data->>'name', 'Usuario'),
    COALESCE((NEW.raw_user_meta_data->>'age')::integer, 8),
    NOW()
  )
  ON CONFLICT (id) DO NOTHING;
  
  RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Crear trigger que se ejecuta después de insertar en auth.users
DROP TRIGGER IF EXISTS on_auth_user_created ON auth.users;
CREATE TRIGGER on_auth_user_created
  AFTER INSERT ON auth.users
  FOR EACH ROW
  EXECUTE FUNCTION public.handle_new_user();

-- ============================================
-- 5. CREAR TABLA DE MENSAJES
-- ============================================

-- Crear tabla de mensajes del chat
CREATE TABLE IF NOT EXISTS messages (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  message TEXT NOT NULL,
  is_from_user BOOLEAN NOT NULL DEFAULT true,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Habilitar RLS para mensajes
ALTER TABLE messages ENABLE ROW LEVEL SECURITY;

-- Eliminar políticas existentes si existen
DROP POLICY IF EXISTS "Users can read own messages" ON messages;
DROP POLICY IF EXISTS "Users can insert own messages" ON messages;
DROP POLICY IF EXISTS "Users can delete own messages" ON messages;

-- Política para que los usuarios puedan leer sus propios mensajes
CREATE POLICY "Users can read own messages"
  ON messages FOR SELECT
  USING (auth.uid() = user_id);

-- Política para que los usuarios puedan insertar sus propios mensajes
CREATE POLICY "Users can insert own messages"
  ON messages FOR INSERT
  WITH CHECK (auth.uid() = user_id);

-- Política para que los usuarios puedan eliminar sus propios mensajes
CREATE POLICY "Users can delete own messages"
  ON messages FOR DELETE
  USING (auth.uid() = user_id);

-- ============================================
-- 6. CREAR ÍNDICES
-- ============================================

-- Índices para búsquedas
CREATE INDEX IF NOT EXISTS idx_users_email ON users(email);
CREATE INDEX IF NOT EXISTS idx_messages_user_id ON messages(user_id);
CREATE INDEX IF NOT EXISTS idx_messages_created_at ON messages(created_at);

-- ============================================
-- 7. VERIFICAR CONFIGURACIÓN
-- ============================================

-- Verificar que las tablas existen
SELECT 'Tabla users creada correctamente' AS status
WHERE EXISTS (SELECT 1 FROM information_schema.tables WHERE table_name = 'users');

SELECT 'Tabla messages creada correctamente' AS status
WHERE EXISTS (SELECT 1 FROM information_schema.tables WHERE table_name = 'messages');

-- ============================================
-- NOTAS IMPORTANTES:
-- ============================================
-- 1. Ve a Authentication > Settings en Supabase Dashboard
-- 2. Desactiva "Enable email confirmations" para desarrollo (opcional)
-- 3. Verifica que "Enable sign ups" esté activado
-- 4. Asegúrate de que la URL de redirección esté configurada correctamente
-- 5. El trigger handle_new_user() creará automáticamente el registro en users
--    cuando se cree un usuario en auth.users
-- ============================================





