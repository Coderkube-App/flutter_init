# 🚀 flutter_init

A powerful CLI tool to instantly scaffold a modern Flutter app with your custom architecture and preferred state management:
**Simple GetX**, **Reactive GetX**, **Provider**, or **Bloc**. 
Designed for productivity, best practices, and rapid prototyping.

---

## ✨ Features

- 📁 Custom folder structure with best practices
- 🔧 Supports 3 state management options:
  -  ✅ **Simple GetX**
  -  🔄 **Reactive GetX**
  -  🧩 **Provider**
  -  ⚙️ **Bloc + Equatable**
- 📦 Auto-installs essential dependencies:
  -  **Common:** shared_preferences, dynamicutils, http, connectivity_plus, file_picker, cached_network_image, flutter_offline, image_picker
  -  **GetX:** get, get_storage
  -  **Provider:** provider, flutter_localization
  -  **Bloc:** `flutter_bloc`, `equatable`
- 🔁 Handles **package import replacement** automatically
- 📂 Creates `assets/images/` and auto-links it in `pubspec.yaml`
- 🌐 Adds **common API handler** class with:
  - `GET`, `POST`, `PUT`, `DELETE`, and `FormData` methods
  - Reusable and customizable HTTP logic
- 🧩 Generates reusable structure in:
  - `repository/` – Centralized API layer
  - `controller/` or `bloc/` – Clean integration with controller logic
- 📡 Handles offline support with:
  - `OfflineBuilder` for no-network banners
  - Optional offline full screen layout (pre-coded)

---

## 📦 Installation

Install the CLI tool globally using npm:

```bash
npm install -g flutter_init
```

---

## 🚀 Usage
After installation, simply run:

```bash
flutter-init
```
