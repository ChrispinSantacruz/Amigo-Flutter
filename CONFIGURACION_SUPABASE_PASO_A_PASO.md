# ⚙️ Configuración de Supabase - Paso a Paso

## 🚨 PROBLEMA ACTUAL
```
Error: Email address "chris@gmail.com" is invalid
Status Code: 400
```

## ✅ SOLUCIÓN: Configurar Supabase Correctamente

### Paso 1: Ir al Dashboard de Supabase

1. Abre tu navegador y ve a: https://supabase.com/dashboard
2. Inicia sesión con tu cuenta
3. Selecciona tu proyecto: **lzvgxpwbmzdnvzlmebhv**

### Paso 2: Deshabilitar Confirmación de Email

1. En el menú izquierdo, haz clic en **Authentication**
2. Haz clic en **Settings** (Configuración)
3. Busca la sección **"Email Auth"**
4. **DESACTIVA** el toggle **"Enable email confirmations"**
   - Esto permitirá que los usuarios se registren sin confirmar el email
5. Haz clic en **Save** (Guardar) en la parte inferior

### Paso 3: Verificar que Sign Ups estén Habilitados

1. En la misma página de **Authentication** > **Settings**
2. Busca la sección **"Auth Providers"**
3. Verifica que **"Email"** esté **HABILITADO**
4. Si no está habilitado, actívalo y guarda

### Paso 4: Verificar Configuración de Rate Limiting

1. En **Authentication** > **Settings**
2. Busca **"Rate Limiting"**
3. Verifica que los límites no sean demasiado restrictivos
4. Para desarrollo, puedes aumentar los límites o desactivarlos temporalmente

### Paso 5: Verificar Restricciones de Dominio

1. En **Authentication** > **Settings**
2. Busca **"Email Domains"** o **"Allowed Domains"**
3. Si hay una lista de dominios permitidos, **ELIMÍNALA** o agrega los dominios que necesites
4. Guarda los cambios

### Paso 6: Verificar SMTP Settings (Opcional)

1. En **Authentication** > **Settings**
2. Busca **"SMTP Settings"**
3. Si quieres enviar emails, configura un proveedor SMTP
4. Si no, deja la configuración por defecto

## 🧪 Probar el Registro

### Test 1: Probar con Diferentes Emails

Después de configurar Supabase, prueba registrar con:

1. **Email simple**: `test@test.com`
2. **Email Gmail**: `test@gmail.com`
3. **Email con subdominio**: `test@example.com`

### Test 2: Verificar en Supabase

1. Ve a **Authentication** > **Users**
2. Deberías ver el usuario registrado
3. El usuario debería estar **ACTIVO** sin necesidad de confirmación

### Test 3: Verificar Logs

1. Ve a **Logs** > **Auth Logs**
2. Busca las solicitudes de registro
3. Verifica que no haya errores

## 📸 Capturas de Pantalla de Configuración

### Configuración Correcta:

```
Authentication > Settings > Email Auth
✅ Enable sign ups: ACTIVADO
❌ Enable email confirmations: DESACTIVADO
✅ Email provider: ACTIVADO
```

## 🔧 Si el Problema Persiste

### Opción 1: Verificar la Clave API

1. Ve a **Settings** > **API**
2. Verifica que estés usando la **"anon" key** o **"public" key**
3. NO uses la **"service_role" key** en el código cliente

### Opción 2: Verificar URL del Proyecto

1. Ve a **Settings** > **API**
2. Verifica que la URL sea: `https://lzvgxpwbmzdnvzlmebhv.supabase.co`
3. Verifica que la clave sea: `sb_publishable_5G1hgPkVDw7Unvm6-9OKgA_6y_DELDx`

### Opción 3: Probar con API Directa

Puedes probar el registro directamente con curl:

```bash
curl -X POST 'https://lzvgxpwbmzdnvzlmebhv.supabase.co/auth/v1/signup' \
  -H "apikey: sb_publishable_5G1hgPkVDw7Unvm6-9OKgA_6y_DELDx" \
  -H "Content-Type: application/json" \
  -d '{
    "email": "test@test.com",
    "password": "123456"
  }'
```

Si esto funciona, el problema está en el código de Flutter.
Si no funciona, el problema está en la configuración de Supabase.

### Opción 4: Contactar Soporte de Supabase

1. Ve a **Support** en el Dashboard
2. Abre un ticket con:
   - El error exacto
   - Los logs de autenticación
   - La configuración actual

## ✅ Checklist Final

- [ ] Confirmación de email **DESACTIVADA**
- [ ] Sign ups **HABILITADOS**
- [ ] Email provider **ACTIVADO**
- [ ] No hay restricciones de dominio
- [ ] Rate limiting no es demasiado restrictivo
- [ ] Credenciales correctas en `env.dart`
- [ ] URL del proyecto correcta
- [ ] Clave API correcta (anon/public key)

## 🎯 Solución Más Probable

**El problema más común es que la confirmación de email está activada.**

1. Ve a **Authentication** > **Settings**
2. **DESACTIVA** "Enable email confirmations"
3. **GUARDA** los cambios
4. **PRUEBA** el registro nuevamente

---

**Después de hacer estos cambios, el registro debería funcionar correctamente.** 🎉


