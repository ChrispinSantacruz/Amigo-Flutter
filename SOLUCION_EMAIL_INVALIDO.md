# 🔧 Solución: "Email address is invalid" en Supabase

## ❌ Error
```
AuthException: Email address "chris@gmail.com" is invalid
Status Code: 400
```

## 🔍 Causa del Problema

Este error ocurre porque Supabase tiene configuraciones que pueden estar bloqueando el registro. Las causas más comunes son:

1. **Confirmación de email habilitada sin SMTP configurado**
2. **Dominios bloqueados o restricciones de email**
3. **Configuración de Auth demasiado estricta**

## ✅ Solución Paso a Paso

### Paso 1: Deshabilitar Confirmación de Email

1. Ve al **Dashboard de Supabase**: https://supabase.com/dashboard
2. Selecciona tu proyecto
3. Ve a **Authentication** > **Settings** (Configuración)
4. Busca la sección **"Email Auth"**
5. **DESACTIVA** "Enable email confirmations" (Confirmación de email)
6. Haz clic en **Save** (Guardar)

### Paso 2: Verificar Configuración de Sign Ups

1. En la misma página de **Authentication** > **Settings**
2. Verifica que **"Enable sign ups"** esté **ACTIVADO**
3. Si no está activado, actívalo y guarda

### Paso 3: Configurar SMTP (Opcional pero Recomendado)

Si quieres habilitar confirmación de email más tarde:

1. Ve a **Authentication** > **Settings** > **SMTP Settings**
2. Configura un proveedor SMTP (Gmail, SendGrid, etc.)
3. O usa el servicio SMTP de Supabase (limitado a miembros de la organización)

### Paso 4: Verificar Restricciones de Dominio

1. Ve a **Authentication** > **Settings**
2. Busca la sección **"Email Templates"** o **"Auth Providers"**
3. Verifica que no haya restricciones de dominio activas
4. Si hay una lista de dominios permitidos, agrega los que necesites

### Paso 5: Verificar Configuración de Rate Limiting

1. Ve a **Authentication** > **Settings**
2. Busca **"Rate Limiting"**
3. Verifica que no esté bloqueando demasiadas solicitudes
4. Ajusta los límites si es necesario

## 🔧 Configuración Alternativa: Deshabilitar Validación Estricta

Si el problema persiste, puedes intentar deshabilitar la validación estricta de email temporalmente:

### Opción 1: Usar Email de Prueba Temporal

1. Ve a **Authentication** > **Settings**
2. Busca **"Email Auth"**
3. Habilita **"Allow unverified email sign-ins"** (si está disponible)
4. Guarda los cambios

### Opción 2: Configurar Dominios Permitidos

1. Ve a **Authentication** > **Settings**
2. Busca **"Email Domains"** o **"Allowed Domains"**
3. Agrega los dominios que quieras permitir (ej: `gmail.com`, `test.com`)
4. O desactiva las restricciones de dominio completamente

## 🧪 Verificar que Funciona

### Test 1: Verificar Configuración

1. Ve a **Authentication** > **Settings**
2. Verifica:
   - ✅ "Enable sign ups" está **ACTIVADO**
   - ✅ "Enable email confirmations" está **DESACTIVADO**
   - ✅ No hay restricciones de dominio activas

### Test 2: Probar Registro

1. Intenta registrar un usuario con:
   - Email: `test@example.com` o `test@gmail.com`
   - Contraseña: mínimo 6 caracteres
   - Nombre: cualquier nombre
   - Edad: entre 3-12 años

2. El registro debería funcionar sin errores

### Test 3: Verificar en Supabase

1. Ve a **Authentication** > **Users**
2. Deberías ver el nuevo usuario registrado
3. El usuario debería estar activo sin necesidad de confirmación

## 🐛 Si Aún Hay Problemas

### 1. Verificar Logs de Auth

1. Ve a **Logs** > **Auth Logs** en Supabase
2. Busca el error específico
3. Revisa el mensaje de error completo

### 2. Verificar Credenciales

Abre `lib/core/config/env.dart` y verifica:
- `supabaseUrl`: Debe ser la URL correcta de tu proyecto
- `supabaseAnonKey`: Debe ser la clave pública (anon key o publishable key)

### 3. Probar con API Directa

Puedes probar el registro directamente con la API de Supabase:

```bash
curl -X POST 'https://lzvgxpwbmzdnvzlmebhv.supabase.co/auth/v1/signup' \
  -H "apikey: sb_publishable_5G1hgPkVDw7Unvm6-9OKgA_6y_DELDx" \
  -H "Content-Type: application/json" \
  -d '{
    "email": "test@example.com",
    "password": "123456"
  }'
```

Si esto funciona, el problema está en el código de Flutter.
Si no funciona, el problema está en la configuración de Supabase.

### 4. Contactar Soporte

Si nada funciona:
1. Ve a **Support** en el Dashboard de Supabase
2. Abre un ticket con:
   - El error exacto
   - Los logs de autenticación
   - La configuración actual de Auth

## 📝 Checklist de Verificación

- [ ] Confirmación de email **DESACTIVADA** en Supabase
- [ ] Sign ups **HABILITADOS** en Supabase
- [ ] No hay restricciones de dominio activas
- [ ] Credenciales en `env.dart` son correctas
- [ ] No hay rate limiting bloqueando las solicitudes
- [ ] SMTP configurado (si se requiere confirmación de email)

## 🔗 Referencias

- [Documentación de Supabase Auth](https://supabase.com/docs/guides/auth)
- [Configuración de Email en Supabase](https://supabase.com/docs/guides/auth/email-auth)
- [Debugging Auth Errors](https://supabase.com/docs/guides/auth/debugging/error-codes)

---

**La solución más común es desactivar la confirmación de email en Supabase.** 🎯


