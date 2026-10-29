# Catálogo Reactivo — Semana 07

**Desarrollo Móvil Integral | Flutter + Firebase Cloud Firestore**

Aplicación móvil desarrollada con Flutter y Firebase Cloud Firestore que permite administrar un catálogo de productos mediante operaciones CRUD, sincronización en tiempo real, persistencia de datos en caché y una arquitectura organizada en Modelo–Repositorio–Vista.

## 1. Tecnologías utilizadas

- Flutter y Dart
- Firebase Core
- Cloud Firestore
- FlutterFire CLI
- Android Studio
- Visual Studio Code
- Git y GitHub
- Emulador Android Pixel 8 Pro

## 2. Requisitos previos

Antes de comenzar, verificar que estén instalados Flutter SDK, Dart SDK, Android Studio, Visual Studio Code, Git y Node.js.

Comprobar las instalaciones desde PowerShell:

```powershell
flutter --version
dart --version
git --version
node --version
flutter doctor
```

Si `flutter doctor` muestra problemas con Android SDK o las licencias, solucionarlos antes de continuar.

## 3. Crear el proyecto Flutter desde cero

Abrir Visual Studio Code y una terminal PowerShell.

Crear el proyecto:

```powershell
flutter create --project-name semana07_firestore --platforms android,ios,web semana07_flutter_firestore
```

Entrar a la carpeta:

```powershell
cd semana07_flutter_firestore
```

Si ya existe la carpeta del proyecto con los archivos Dart, no es necesario volver a crearlo.

Para regenerar archivos nativos faltantes desde la raíz:

```powershell
flutter create --project-name semana07_firestore --platforms android,ios,web .
```

## 4. Estructura del proyecto

```text
semana07_flutter_firestore/
│
├── android/
├── ios/
├── web/
├── lib/
│   ├── main.dart
│   ├── firebase_options.dart
│   ├── models/
│   │   └── item_model.dart
│   ├── repositories/
│   │   └── catalog_repository.dart
│   ├── screens/
│   │   └── catalog_screen.dart
│   └── widgets/
│       └── item_form.dart
│
├── test/
├── docs/
│   └── GUIA_PASO_A_PASO.md
├── firestore.rules
├── firebase.json
├── pubspec.yaml
└── README.md
```

**Descripción de las carpetas principales:**

- `models/`: representa los documentos de Firestore mediante objetos Dart.
- `repositories/`: contiene las consultas y operaciones CRUD.
- `screens/`: contiene las pantallas de la aplicación.
- `widgets/`: contiene componentes reutilizables.
- `test/`: almacena las pruebas automatizadas.
- `docs/`: contiene la documentación de la práctica.

## 5. Instalar las dependencias

Dentro del proyecto ejecutar:

```powershell
flutter pub get
```

Las dependencias principales utilizadas son:

```yaml
dependencies:
  flutter:
    sdk: flutter
  firebase_core: ^3.15.2
  cloud_firestore: ^5.6.12
```

Estas versiones corresponden a las utilizadas durante la práctica. Si el proyecto ya tiene `pubspec.yaml` y `pubspec.lock`, conservarlos para evitar cambios de versiones innecesarios.

## 6. Crear y configurar Firebase

Ingresar a:

https://console.firebase.google.com/

Crear o seleccionar el proyecto:

**Nombre:** `semana07-catalogo`

Después:

1. Entrar a Firebase Console.
2. Seleccionar el proyecto.
3. Abrir **Compilación → Firestore Database**.
4. Crear la base de datos si todavía no existe.
5. Seleccionar una ubicación disponible.
6. Configurar reglas de acceso apropiadas para las pruebas.

**Advertencia:** el modo de prueba permite acceso amplio durante un periodo limitado. No utilizar reglas abiertas en producción.

## 7. Instalar Firebase CLI y FlutterFire CLI

Instalar Firebase CLI:

```powershell
npm install -g firebase-tools
```

Iniciar sesión:

```powershell
firebase login
```

Instalar FlutterFire CLI:

```powershell
dart pub global activate flutterfire_cli
```

Verificar:

```powershell
flutterfire --version
```

Durante la práctica se utilizó FlutterFire CLI `1.4.1`.

### Solución al error: flutterfire no se reconoce

Si PowerShell no encuentra el comando, ejecutar:

```powershell
$env:Path += ";$env:LOCALAPPDATA\Pub\Cache\bin"
```

Después:

```powershell
flutterfire --version
```

Alternativamente:

```powershell
dart pub global run flutterfire_cli:flutterfire configure
```

## 8. Vincular Flutter con Firebase

Desde la raíz del proyecto:

```powershell
flutterfire configure
```

Seleccionar el proyecto:

```text
semana07-catalogo
```

Seleccionar las plataformas:

```text
Android
iOS
Web
```

Al finalizar se genera:

```text
lib/firebase_options.dart
```

El archivo contiene la configuración del cliente Firebase para cada plataforma.

En `lib/main.dart` verificar la inicialización:

```dart
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const CatalogApp());
}
```

El ejemplo presupone que `CatalogApp` está definida en el proyecto. Conservar el nombre real del widget principal si es diferente.

No incluir claves privadas de cuentas de servicio ni credenciales administrativas en el repositorio.

## 9. Comprobar el proyecto

Descargar dependencias:

```powershell
flutter pub get
```

Analizar el código:

```powershell
flutter analyze
```

Ejecutar pruebas:

```powershell
flutter test
```

Si aparecen advertencias sobre versiones más recientes de paquetes, no significa necesariamente que exista un error.

### Error corregido durante la práctica

En `catalog_screen.dart` se presentó un error porque `Wrap` no admite `mainAxisSize`.

Se corrigió utilizando:

```dart
trailing: Row(
  mainAxisSize: MainAxisSize.min,
  children: [
    IconButton(
      icon: const Icon(Icons.edit),
      onPressed: () => openForm(item),
    ),
    IconButton(
      icon: const Icon(Icons.delete_outline),
      onPressed: () => remove(item),
    ),
  ],
),
```

También se corrigieron problemas de paréntesis y una prueba que hacía referencia a una clase `MyApp` inexistente.

## 10. Configurar el emulador Pixel 8 Pro

Abrir Android Studio.

1. Seleccionar **Tools → Device Manager**.
2. Presionar **Create Virtual Device**.
3. Elegir **Phone → Pixel 8 Pro**.
4. Seleccionar una imagen de Android compatible, preferentemente con Google APIs o Google Play.
5. Descargarla si es necesario.
6. Finalizar y encender el emulador.

En VS Code verificar:

```powershell
flutter devices
```

Ejemplo:

```text
Pixel 8 Pro • emulator-5554 • android
Chrome      • chrome        • web
```

Para ejecutar en el Pixel 8 Pro:

```powershell
flutter run -d emulator-5554
```

El identificador puede variar. Utilizar el que muestre `flutter devices`.

También se puede ejecutar en Chrome:

```powershell
flutter run -d chrome
```

## 11. Funcionalidades de la aplicación

La aplicación implementa:

**Agregar productos:** registrar nombre, descripción, precio y stock.

**Consultar productos:** mostrar los documentos de Firestore en una lista dinámica.

**Editar productos:** modificar registros existentes.

**Eliminar productos:** borrar documentos previa confirmación.

**Sincronización en tiempo real:** recibir actualizaciones automáticamente mediante Streams.

**Estados de interfaz:** representar Loading, Success, Empty y Error.

## 12. Streams y StreamBuilder

Cloud Firestore permite escuchar cambios mediante:

```dart
.snapshots()
```

El repositorio expone un Stream que la interfaz consume utilizando `StreamBuilder`.

Esto permite actualizar la lista cuando se agregan, modifican o eliminan documentos, sin necesidad de recargar manualmente.

`StreamBuilder` administra la suscripción al Stream durante el ciclo de vida del widget.

## 13. Pruebas de sincronización en tiempo real

1. Ejecutar la aplicación en el Pixel 8 Pro.
2. Agregar productos desde la aplicación.
3. Abrir Firebase Console desde la computadora.
4. Entrar a Firestore Database.
5. Modificar el precio o nombre de un producto.
6. Regresar al emulador.
7. Comprobar que la lista se actualice automáticamente.

También probar la eliminación de documentos.

La actualización puede depender de la conexión y la latencia de red.

## 14. Prueba de caché y modo offline

Firestore en Android conserva localmente documentos consultados previamente.

Para comprobarlo:

1. Ejecutar la aplicación con Internet.
2. Agregar y consultar varios productos.
3. Esperar a que los datos se sincronicen.
4. Activar modo avión y comprobar que no exista conexión.
5. Regresar a la aplicación sin cerrarla.
6. Verificar que los productos previamente consultados continúen visibles.
7. Modificar un producto desde Firebase Console en la computadora.
8. Reactivar Internet en el emulador.
9. Verificar que el cambio remoto aparezca automáticamente.

Para recibir cambios en los metadatos de caché, utilizar en el repositorio:

```dart
.snapshots(includeMetadataChanges: true)
```

El indicador `isFromCache` permite identificar si los datos provienen de caché, aunque no sustituye por sí solo una comprobación completa de conectividad.

## 15. Crear y subir el proyecto a GitHub

Repositorio:

https://github.com/DiegoTecorralco/semana07-flutter-firestore

Inicializar Git:

```powershell
git init
```

Preparar archivos:

```powershell
git add .
```

Crear el primer commit:

```powershell
git commit -m "Initial commit: Flutter Firestore realtime catalog"
```

Cambiar el nombre de la rama:

```powershell
git branch -M main
```

Vincular GitHub:

```powershell
git remote add origin https://github.com/DiegoTecorralco/semana07-flutter-firestore.git
```

Subir los cambios:

```powershell
git push -u origin main
```

Estos comandos corresponden a la configuración inicial y no deben repetirse cada vez que se abre el proyecto.

### Conflicto encontrado con README.md

Durante la práctica, el repositorio remoto ya tenía un archivo `README.md`.

Para integrar ambos historiales se utilizó:

```powershell
git pull origin main --allow-unrelated-histories --no-rebase
```

Se presentó un conflicto `add/add` en `README.md`.

Para conservar la versión local:

```powershell
git checkout --ours README.md
git add README.md
git commit -m "Merge GitHub repository with Flutter project"
git push -u origin main
```

Este procedimiento se utiliza únicamente para resolver aquel conflicto, no para las actualizaciones normales.

## 16. Cómo volver a abrir el proyecto

Si el proyecto ya está guardado en la computadora:

1. Abrir Visual Studio Code.
2. Seleccionar **Archivo → Abrir carpeta**.
3. Abrir `semana07_flutter_firestore`.
4. Iniciar el emulador Pixel 8 Pro.
5. Ejecutar:

```powershell
flutter pub get
flutter devices
flutter run -d emulator-5554
```

No es necesario volver a crear el proyecto, ejecutar `git init` ni configurar Firebase cada vez.

## 17. Cómo descargarlo en otra computadora

Instalar Flutter, Android Studio y Git.

Después ejecutar:

```powershell
git clone https://github.com/DiegoTecorralco/semana07-flutter-firestore.git
cd semana07-flutter-firestore
flutter pub get
```

Si no existe `lib/firebase_options.dart`, instalar FlutterFire CLI y ejecutar:

```powershell
firebase login
flutterfire configure
```

Seleccionar el proyecto Firebase correspondiente, siempre que se tenga acceso autorizado.

Después iniciar un emulador y ejecutar:

```powershell
flutter run
```

## 18. Cómo guardar cambios nuevos en GitHub

Cuando se modifique el código:

```powershell
git status
git add .
git commit -m "Update Flutter Firestore project"
git push origin main
```

Si el repositorio remoto contiene cambios nuevos, primero revisar e integrar esos cambios mediante `git pull` antes de subir.

No es necesario crear un nuevo repositorio.

## 19. Comandos útiles

| Comando | Función |
|---|---|
| `flutter doctor` | Revisar instalación de Flutter |
| `flutter pub get` | Descargar dependencias |
| `flutter analyze` | Analizar errores |
| `flutter test` | Ejecutar pruebas |
| `flutter devices` | Mostrar dispositivos disponibles |
| `flutter run -d chrome` | Ejecutar en Chrome |
| `flutter run -d emulator-5554` | Ejecutar en Android |
| `flutter clean` | Limpiar archivos de compilación |
| `flutterfire configure` | Configurar Firebase |
| `git status` | Revisar cambios |
| `git add .` | Preparar cambios |
| `git commit -m "mensaje"` | Guardar una versión |
| `git push origin main` | Subir cambios a GitHub |
| `git pull origin main` | Descargar e integrar cambios |

## 20. Seguridad

Antes de publicar o compartir la aplicación:

- Verificar las reglas de Cloud Firestore.
- Evitar mantener el modo de prueba con acceso abierto.
- No subir contraseñas, tokens privados ni claves administrativas.
- Utilizar autenticación y permisos adecuados para aplicaciones reales.
- Mantener los archivos generados y las dependencias actualizados cuando corresponda.

## 21. Referencias

- Flutter: https://docs.flutter.dev/
- Firebase Flutter: https://firebase.google.com/docs/flutter/setup
- Cloud Firestore: https://firebase.google.com/docs/firestore
- Streams: https://dart.dev/libraries/async/using-streams
- StreamBuilder: https://api.flutter.dev/flutter/widgets/StreamBuilder-class.html
- Git: https://git-scm.com/docs
- GitHub: https://docs.github.com/

---

**Proyecto académico — Semana 07 · Desarrollo Móvil Integral**

Flutter · Dart · Firebase Cloud Firestore · Streams · CRUD · Android
