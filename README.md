# 🧩 ZIP Game · Guía de Instalación y Ejecución

Aplicación móvil y web de lógica y caminos hamiltonianos construida con:
- **Backend:** AdonisJS 6 + TypeScript + Lucid ORM + MySQL 8.4
- **Frontend:** Flutter + Dart (Material 3)
- **Base de Datos:** MySQL 8.4 en Docker

---

## 📋 Prerrequisitos

- **Docker y Docker Compose:** 20.x o superior
- **Node.js:** 20.6 o superior (`node -v`)
- **Flutter:** 3.x estable (`flutter --version`)
- **Navegador:** Google Chrome

---

## 🛠️ Proceso de Instalación

### 1. Clonar o posicionarse en el proyecto
```bash
cd "Practice I"
```

### 2. Configurar Base de Datos (Docker)
El archivo `compose.yml` ya está configurado con el servicio de MySQL 8.4:
```bash
docker compose up -d
```
Verifica que el contenedor esté activo y saludable:
```bash
docker ps --filter "name=zip_game_mysql"
```

### 3. Configurar e Instalar Dependencias del Backend
```bash
cd zip_game_api

# Instalar paquetes de Node.js
npm install

# Generar llave de aplicación (si no está generada)
node ace generate:key

# Ejecutar migraciones para crear las tablas
node ace migration:run

# Poblar la base de datos con los niveles iniciales y usuario demo
node ace db:seed

cd ..
```

### 4. Instalar Dependencias del Frontend
```bash
cd zip_game

# Descargar paquetes de Flutter
flutter pub get

cd ..
```

---

## 🚀 Proceso de Ejecución

Para ejecutar la aplicación se requieren **dos terminales abiertas**:

### Terminal 1 — Backend (API REST)
```bash
cd zip_game_api
node ace serve --hmr
```
> El servidor quedará escuchando en `http://localhost:3333`. Mantén esta terminal abierta.

### Terminal 2 — Frontend (Flutter Web)
```bash
cd zip_game
flutter run -d chrome
```
> Esto compilará y abrirá automáticamente Google Chrome con la app interactiva.

---

## 🔑 Credenciales de Prueba

Puedes iniciar sesión con el usuario de demostración generado por los seeders:
- **Correo:** `demo@zipgame.test`
- **Contraseña:** `demo12345`

*O también puedes crear una cuenta nueva desde el enlace "¿No tienes cuenta? Regístrate".*

---

## 🧪 Ejecución de Pruebas

### Pruebas del Backend (37 pruebas: unitarias y funcionales)
```bash
cd zip_game_api
node ace test
```

### Pruebas del Frontend (19 pruebas: unitarias, controladores y widgets)
```bash
cd zip_game
flutter test
```

### Prueba de Integración Frontend ↔ Backend (con servidor encendido)
```bash
cd zip_game
flutter test test/integration --dart-define=INTEGRATION=true
```
