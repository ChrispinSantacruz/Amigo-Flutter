# 📱 Guía para Generar y Transferir el APK al Celular

## 🎯 Paso 1: Preparar el Proyecto

### 1.1 Verificar que tienes Android SDK instalado
```bash
flutter doctor
```

Asegúrate de que Android toolchain esté configurado correctamente.

### 1.2 Verificar que el proyecto compile
```bash
flutter clean
flutter pub get
flutter build apk --debug
```

## 🎯 Paso 2: Generar el APK

### Opción A: APK de Debug (más rápido, para pruebas)
```bash
flutter build apk --debug
```

El APK se generará en:
```
build/app/outputs/flutter-apk/app-debug.apk
```

### Opción B: APK de Release (optimizado, para distribución)
```bash
flutter build apk --release
```

El APK se generará en:
```
build/app/outputs/flutter-apk/app-release.apk
```

### Opción C: APK Dividido por ABI (más pequeño)
```bash
flutter build apk --split-per-abi
```

Esto generará APKs separados para:
- `app-armeabi-v7a-release.apk` (32-bit)
- `app-arm64-v8a-release.apk` (64-bit)
- `app-x86_64-release.apk` (x86_64)

## 🎯 Paso 3: Transferir el APK al Celular

### Método 1: USB (Recomendado)

1. **Conectar el celular por USB**
   - Activa "Depuración USB" en tu celular:
     - Configuración → Opciones de desarrollador → Depuración USB
   - Si no ves "Opciones de desarrollador":
     - Configuración → Acerca del teléfono → Toca 7 veces en "Número de compilación"

2. **Copiar el APK al celular**
   ```bash
   # En Windows PowerShell
   adb devices  # Verificar que el celular esté conectado
   adb install build/app/outputs/flutter-apk/app-release.apk
   ```

   O manualmente:
   - Abre el explorador de archivos
   - Copia el archivo `app-release.apk` desde:
     `C:\Users\chris\OneDrive\Desktop\flutter amigo\build\app\outputs\flutter-apk\`
   - Pégalo en la carpeta de descargas de tu celular

3. **Instalar en el celular**
   - Abre el explorador de archivos del celular
   - Ve a Descargas
   - Toca el archivo `.apk`
   - Permite "Instalar desde fuentes desconocidas" si te lo pide
   - Toca "Instalar"

### Método 2: Google Drive / Email

1. **Subir el APK a Google Drive**
   - Sube el archivo `app-release.apk` a Google Drive
   - Comparte el enlace contigo mismo

2. **Descargar en el celular**
   - Abre Google Drive en el celular
   - Descarga el APK
   - Instálalo desde Descargas

### Método 3: Bluetooth

1. **Enviar por Bluetooth**
   - En la PC: Click derecho en `app-release.apk` → Enviar a → Dispositivo Bluetooth
   - En el celular: Acepta el archivo
   - Instala desde Descargas

### Método 4: ADB Wireless (Avanzado)

1. **Conectar por WiFi**
   ```bash
   # Conecta el celular por USB primero
   adb tcpip 5555
   adb connect [IP_DEL_CELULAR]:5555
   # Desconecta el USB
   adb install build/app/outputs/flutter-apk/app-release.apk
   ```

## 🎯 Paso 4: Instalar el APK

1. **Habilitar instalación desde fuentes desconocidas**
   - Configuración → Seguridad → Permitir instalación de apps de fuentes desconocidas
   - O cuando intentes instalar, el sistema te pedirá permiso

2. **Instalar**
   - Abre el archivo `.apk` desde el explorador de archivos
   - Toca "Instalar"
   - Espera a que termine
   - Toca "Abrir" o busca "MishiGPT" en el menú de apps

## ⚠️ Solución de Problemas

### Error: "APK no se puede instalar"
- **Solución**: Verifica que el APK no esté corrupto. Regenera el APK:
  ```bash
  flutter clean
  flutter pub get
  flutter build apk --release
  ```

### Error: "Aplicación no instalada"
- **Solución**: Desinstala cualquier versión anterior de la app primero

### Error: "ADB no reconocido"
- **Solución**: Instala Android SDK Platform Tools:
  - Descarga desde: https://developer.android.com/studio/releases/platform-tools
  - Agrega la carpeta `platform-tools` al PATH de Windows

### El APK es muy grande
- **Solución**: Usa APK dividido por ABI:
  ```bash
  flutter build apk --split-per-abi --release
  ```
  Esto generará APKs más pequeños (solo para tu arquitectura)

## 📝 Comandos Rápidos

```bash
# Limpiar y regenerar
flutter clean && flutter pub get

# Generar APK de release
flutter build apk --release

# Instalar directamente (si el celular está conectado)
adb install build/app/outputs/flutter-apk/app-release.apk

# Verificar dispositivos conectados
adb devices
```

## 🎉 ¡Listo!

Una vez instalado, podrás usar MishiGPT en tu celular. El APK incluye todas las funcionalidades:
- ✅ Chat con MishiGPT
- ✅ Alimentar a Mishi
- ✅ Voz (Speech-to-Text y Text-to-Speech)
- ✅ Dormitorio con interruptor de luz
- ✅ Todas las pantallas y navegación

---

**Nota**: Para distribuir la app a otros usuarios, considera usar Google Play Store o generar un APK Bundle (AAB) con:
```bash
flutter build appbundle --release
```


