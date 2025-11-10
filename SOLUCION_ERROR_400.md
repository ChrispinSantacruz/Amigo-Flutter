# 🔧 Solución para Error 400 en Registro

## ❌ Error: `POST https://lzvgxpwbmzdnvzlmebhv.supabase.co/auth/v1/signup? 400 (Bad Request)`

Este error puede ocurrir por varias razones. Sigue estos pasos para solucionarlo:

## 🔍 Paso 1: Verificar Configuración de Supabase Auth

### 1.1. Desactivar Confirmación de Email (Recomendado para desarrollo)

1. Ve al **Dashboard de Supabase**: https://supabase.com/dashboard
2. Selecciona tu proyecto
3. Ve a **Authentication** > **Settings** (Configuración)
4. Busca la sección **"Email Auth"**
5. **Desactiva** "Enable email confirmations" (Confirmación de email)
6. Haz clic en **Save** (Guardar)

### 1.2. Verificar que los Sign Ups estén Habilitados

1. En la misma página de **Authentication** > **Settings**
2. Verifica que **"Enable sign ups"** esté **activado**
3. Si no está activado, actívalo y guarda

## 🔧 Paso 2: Ejecutar el Script SQL Mejorado

He creado un script SQL mejorado que incluye un **trigger automático** para crear el usuario en la tabla `users` cuando se registra en `auth.users`.

### 2.1. Ejecutar el Script

1. Ve al **SQL Editor** en el Dashboard de Supabase
2. Abre el archivo `supabase_setup_fix.sql`
3. Copia y pega todo el contenido
4. Haz clic en **Run** (Ejecutar)
5. Verifica que no haya errores

### 2.2. Verificar que el Trigger se Creó

Ejecuta esta consulta para verificar:

```sql
SELECT 
  trigger_name, 
  event_manipulation, 
  event_object_table 
FROM information_schema.triggers 
WHERE trigger_name = 'on_auth_user_created';
```

Deberías ver el trigger listado.

## 🧪 Paso 3: Probar el Registro

### 3.1. Limpiar Usuarios Existentes (Opcional)

Si ya intentaste registrar un email, puede que esté bloqueado. Puedes:

1. Ir a **Authentication** > **Users** en Supabase
2. Eliminar el usuario si existe (o usar un email diferente)

### 3.2. Probar el Registro

1. Intenta registrar un nuevo usuario
2. El error 400 debería desaparecer
3. Si aún hay error, revisa la consola del navegador (F12) para ver el mensaje exacto

## 🔍 Paso 4: Verificar Errores Específicos

### Error: "User already registered"
- **Solución**: El email ya está registrado. Usa otro email o inicia sesión.

### Error: "Invalid email format"
- **Solución**: Verifica que el email tenga un formato válido (ej: `usuario@ejemplo.com`)

### Error: "Password too short"
- **Solución**: La contraseña debe tener al menos 6 caracteres

### Error: "RLS policy violation"
- **Solución**: Ejecuta el script SQL mejorado (`supabase_setup_fix.sql`)

## 📝 Paso 5: Verificar las Políticas RLS

Ejecuta esta consulta para verificar las políticas:

```sql
SELECT 
  schemaname, 
  tablename, 
  policyname, 
  permissive, 
  roles, 
  cmd, 
  qual 
FROM pg_policies 
WHERE tablename = 'users';
```

Deberías ver al menos estas políticas:
- `Users can read own data`
- `Users can insert own data` (o `Enable insert for authenticated users only`)
- `Users can update own data`

## 🔧 Solución Alternativa: Usar el Trigger

Si las políticas RLS siguen bloqueando, el trigger automático debería funcionar:

1. El trigger `on_auth_user_created` se ejecuta automáticamente
2. Crea el registro en `users` cuando se crea en `auth.users`
3. No requiere permisos RLS porque usa `SECURITY DEFINER`

## 🧪 Verificar que Funciona

### Test 1: Registrar un Usuario

1. Abre la aplicación
2. Intenta registrar un nuevo usuario
3. Deberías ser redirigido a la pantalla principal sin errores

### Test 2: Verificar en Supabase

1. Ve a **Authentication** > **Users**
2. Deberías ver el nuevo usuario
3. Ve a **Table Editor** > **users**
4. Deberías ver el registro con nombre, email y edad

### Test 3: Iniciar Sesión

1. Cierra sesión
2. Inicia sesión con el mismo usuario
3. Debería funcionar correctamente

## 🐛 Si Aún Hay Problemas

### 1. Revisar los Logs

1. Ve a **Logs** > **Auth Logs** en Supabase
2. Busca errores relacionados con el registro
3. Revisa el mensaje de error específico

### 2. Verificar las Credenciales

Abre `lib/core/config/env.dart` y verifica:
- `supabaseUrl`: Debe ser la URL correcta de tu proyecto
- `supabaseAnonKey`: Debe ser la clave pública (anon key o publishable key)

### 3. Verificar la Conexión

1. Abre la consola del navegador (F12)
2. Ve a la pestaña **Network** (Red)
3. Intenta registrar un usuario
4. Revisa la petición a `/auth/v1/signup`
5. Revisa la respuesta para ver el error exacto

### 4. Contactar Soporte

Si nada funciona:
1. Copia el error exacto de la consola
2. Revisa los logs de Supabase
3. Verifica que todas las configuraciones estén correctas

## ✅ Checklist de Verificación

- [ ] Confirmación de email desactivada en Supabase
- [ ] Sign ups habilitados en Supabase
- [ ] Script SQL ejecutado correctamente
- [ ] Trigger `on_auth_user_created` creado
- [ ] Políticas RLS configuradas correctamente
- [ ] Tabla `users` existe y tiene las columnas correctas
- [ ] Credenciales en `env.dart` son correctas
- [ ] No hay usuarios duplicados con el mismo email

## 📚 Referencias

- [Documentación de Supabase Auth](https://supabase.com/docs/guides/auth)
- [RLS Policies](https://supabase.com/docs/guides/auth/row-level-security)
- [Database Triggers](https://supabase.com/docs/guides/database/triggers)

---

¡Después de seguir estos pasos, el error 400 debería estar resuelto! 🎉


