-- Script SQL para configurar Supabase
-- Ejecuta este script en el SQL Editor de Supabase

-- Crear tabla de usuarios
CREATE TABLE IF NOT EXISTS users (
  id UUID PRIMARY KEY REFERENCES auth.users(id) ON DELETE CASCADE,
  email TEXT NOT NULL,
  name TEXT NOT NULL,
  age INTEGER NOT NULL CHECK (age >= 3 AND age <= 12),
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Habilitar RLS (Row Level Security)
ALTER TABLE users ENABLE ROW LEVEL SECURITY;

-- Eliminar políticas existentes si existen
DROP POLICY IF EXISTS "Users can read own data" ON users;
DROP POLICY IF EXISTS "Users can insert own data" ON users;
DROP POLICY IF EXISTS "Users can update own data" ON users;

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

-- Crear índice para búsquedas por email
CREATE INDEX IF NOT EXISTS idx_users_email ON users(email);

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

-- Crear índice para búsquedas por usuario
CREATE INDEX IF NOT EXISTS idx_messages_user_id ON messages(user_id);
CREATE INDEX IF NOT EXISTS idx_messages_created_at ON messages(created_at);

