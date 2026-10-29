# Semana 07 — Flutter + Cloud Firestore desde cero

## 1. ¿Qué necesitas?
- Flutter SDK instalado, VS Code con extensiones Flutter/Dart o Android Studio.
- Android SDK y emulador o teléfono Android con depuración USB.
- Cuenta Google y acceso a https://console.firebase.google.com
- Node.js para instalar Firebase CLI, si aún no lo tienes.

Abre una terminal y comprueba:
```bash
flutter doctor
flutter --version
```
Corrige los errores que muestre `flutter doctor` (licencias Android: `flutter doctor --android-licenses`).

## 2. Crear el proyecto Flutter base
**Importante:** el ZIP contiene el código Flutter completo, pero no contiene los archivos de plataforma generados por `flutter create` ni credenciales privadas. Esto evita incluir archivos dependientes de tu máquina.

1. Descomprime el ZIP.
2. Abre una terminal DENTRO de la carpeta `semana07_flutter_firestore`.
3. Ejecuta:
```bash
flutter create --project-name semana07_firestore --platforms android,ios,web .
flutter pub get
```
4. Abre la carpeta en VS Code con `code .` o Archivo > Abrir carpeta.

## 3. Crear Firebase
1. Entra a https://console.firebase.google.com y selecciona **Agregar proyecto**.
2. Llámalo `semana07-catalogo` (el ID único puede variar).
3. En Compilación > Firestore Database, elige **Crear base de datos**, selecciona región y modo de prueba temporal.
4. Abre la pestaña **Reglas** y pega `firestore.rules` (ajusta fecha de expiración para tu práctica), luego publica. ¡Nunca uses reglas públicas en producción!

## 4. Conectar Flutter a Firebase (recomendado: FlutterFire CLI)
Instala Firebase CLI y FlutterFire CLI:
```bash
npm install -g firebase-tools
firebase login
dart pub global activate flutterfire_cli
```
Si `flutterfire` no se reconoce, agrega el directorio Pub Cache/bin a PATH (en Windows suele ser `%LOCALAPPDATA%\Pub\Cache\bin`) y reinicia la terminal.
Desde la raíz del proyecto:
```bash
flutterfire configure
```
Selecciona el proyecto Firebase creado y la plataforma Android (y opcionalmente iOS/web). Esto genera `lib/firebase_options.dart` y configura los archivos de plataforma necesarios.

**Android:** verifica que `android/app/google-services.json` exista si la configuración de Android lo requiere y que su nombre de paquete coincida con el `applicationId` en `android/app/build.gradle.kts`. No copies archivos de otro proyecto. Para esta práctica Firestore sin Auth no requiere SHA-1, aunque otros servicios Firebase sí pueden necesitarla.

## 5. Ejecutar
```bash
flutter pub get
flutter devices
flutter run
```
Elige el emulador/teléfono cuando te lo solicite. Para Chrome, configura también la plataforma web con `flutterfire configure`.

## 6. Crear datos de prueba
En Firebase Console > Firestore Database > Datos, crea la colección `items` con un documento de ID automático:
- `name` (string): `Teclado`
- `description` (string): `Teclado mecánico`
- `price` (number): `450`
- `stock` (number): `12`
- `createdAt` (timestamp): fecha actual (opcional)

Crea también `Mouse` y `Monitor`. Los documentos se ordenan alfabéticamente por `name`. **El campo `name` debe existir** para aparecer en la consulta `orderBy('name')`.

## 7. Pruebas de la actividad
1. **Loading:** inicia app y observa indicador mientras llega el primer snapshot.
2. **Success:** aparecen productos en tarjetas; `ListView.builder` construye elementos a demanda.
3. **Empty:** elimina todos los documentos de `items` y verifica el mensaje.
4. **Error:** cambia temporalmente las reglas a `allow read, write: if false;` y reinicia la app sin caché para probar permisos denegados. Restaura reglas después.
5. **Tiempo real:** con la app abierta, crea/edita/borra un producto en Firebase Console. La UI debe actualizarse automáticamente; la latencia depende de red y servidor, no se garantiza menos de un segundo.
6. **Offline:** abre la app online primero, activa modo avión y revisa los datos en caché; vuelve a conectar. Firestore admite persistencia local en Android/iOS por defecto. La primera lectura offline sin caché puede fallar o estar vacía.
7. **CRUD:** usa Agregar, Editar y Eliminar desde la app.
8. Revisa `flutter run` y la consola del dispositivo para detectar errores.

## 8. Arquitectura
- `lib/models/item_model.dart`: modelo tipado con validación de nulos.
- `lib/repositories/catalog_repository.dart`: consulta `orderBy('name').limit(50)` y CRUD; ofrece `Stream<List<ItemModel>>` y snapshots con metadatos.
- `lib/screens/catalog_screen.dart`: `StreamBuilder`, estados, lista, indicador de caché y acciones.
- `lib/widgets/item_form.dart`: formulario con validaciones.

`StreamBuilder` administra la suscripción y la cancela al desmontarse. El Stream se crea una sola vez en `initState` y se recrea solo al reintentar.

## 9. Errores frecuentes
- `firebase_options.dart not found`: falta ejecutar `flutterfire configure`.
- `permission-denied`: revisa reglas, fecha de expiración y proyecto seleccionado.
- `No Firebase App`: revisa `Firebase.initializeApp` y configuración.
- `No devices`: abre emulador o conecta móvil con depuración USB.
- Android `applicationId` no coincide: vuelve a configurar Firebase con el paquete correcto.
- No aparecen documentos: revisa nombre exacto de colección `items` y campo `name`.

## 10. Pregunta de reflexión
**¿Cuándo Stream y cuándo Future?**
Stream: chat, tareas colaborativas, inventario y catálogos que cambian durante la sesión. Future: descarga puntual, inicio de sesión, consulta única o envío de formulario. Un Stream puede generar más actividad y lecturas facturables; conviene limitar consultas y liberar suscripciones.

## 11. Entrega sugerida
Capturas de Firebase Console con 3 productos; app con lista; alta/edición/baja reflejada; modo avión y reconexión; árbol de carpetas; breve conclusión.

**Seguridad:** las reglas incluidas son temporales, públicas y caducan el 15 de noviembre de 2026. Para una app real, implementa Firebase Authentication y reglas por usuario/rol, validación del esquema y pruebas con Emulator Suite.
