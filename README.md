<div align="center">

# ⚖️ Cuma Project Praktikum  + timpaan tugas

![Flutter](https://img.shields.io/badge/Flutter-02569B?logo=flutter&logoColor=white)
![Dart](https://img.shields.io/badge/Dart-0175C2?logo=dart&logoColor=white)
![Firebase](https://img.shields.io/badge/Firebase-FFCA28?logo=firebase&logoColor=black)
![Platform](https://img.shields.io/badge/Platform-Android%20%7C%20iOS%20%7C%20Web%20%7C%20Windows%20%7C%20Linux-lightgrey)

</div>

---

## 📖 Tentang Proyek

**Horas Justitia** adalah aplikasi lintas platform yang dibangun dengan Flutter sebagai bagian dari Praktikum Pemrograman Mobile. Aplikasi ini menampilkan dan mengelola data admin serta pengguna Horas Advokat, terhubung ke Firebase dan layanan API, dan mendukung banyak bahasa.

## ✨ Fitur

- 📋 Daftar admin dengan tampilan tab
- 🔍 Halaman detail data
- 👤 Pengelolaan data admin dan pengguna
- 🔥 Integrasi Firebase
- 🌐 Konsumsi data dari REST API
- 🌍 Dukungan multi bahasa (lokalisasi)
- 💻 Berjalan di Android, iOS, Web, Windows, dan Linux

## 🛠️ Teknologi

| Kategori | Teknologi |
|---|---|
| Framework | Flutter |
| Bahasa | Dart |
| Backend | Firebase, REST API |
| Lokalisasi | Flutter l10n (`.arb`) |
| IDE | Android Studio |

## 📁 Struktur Folder

```
horas_justitia/
├── android/              # Konfigurasi Android
├── ios/                  # Konfigurasi iOS
├── web/                  # Konfigurasi Web
├── windows/              # Konfigurasi Windows
├── linux/                # Konfigurasi Linux
├── test/                 # Pengujian
├── lib/
│   ├── constant/         # Warna dan konfigurasi konstan
│   ├── l10n/             # File terjemahan (.arb)
│   ├── models/           # Model data (admin, user)
│   ├── screens/          # Halaman aplikasi
│   ├── service/          # Layanan data (admin, API)
│   ├── firebase_options.dart
│   └── main.dart         # Titik masuk aplikasi
├── firebase.json
├── l10n.yaml
└── pubspec.yaml
```

## ✅ Prasyarat

- [Flutter SDK](https://docs.flutter.dev/get-started/install) versi stabil
- Android Studio (dengan plugin Flutter dan Dart)
- Git

Pastikan lingkungan siap dengan menjalankan:

```bash
flutter doctor
```

## 🚀 Cara Menjalankan

**1. Clone repository**

```bash
git clone https://github.com/Horas-Advokat/Horas-Justitia.git
cd Horas-Justitia
```

**2. Pasang dependensi**

```bash
flutter pub get
```

**3. Generate file lokalisasi**

```bash
flutter gen-l10n
```

**4. Jalankan aplikasi**

```bash
flutter run
```

Untuk memilih perangkat tertentu:

```bash
flutter devices          # lihat daftar perangkat
flutter run -d windows   # contoh: jalankan di Windows
```

## 🔥 Konfigurasi Firebase

Proyek ini memakai `lib/firebase_options.dart` yang dibuat oleh FlutterFire CLI. Untuk memakai project Firebase milikmu sendiri:

```bash
dart pub global activate flutterfire_cli
flutterfire configure
```

> ⚠️ Jangan menyimpan kunci rahasia atau kredensial pribadi di repository publik.

## 📦 Build

```bash
flutter build apk        # Android
flutter build web        # Web
flutter build windows    # Windows
```

## 👥 Tim Pengembang

| Nama | GitHub |
|---|---|
| Dwi Ahmad Maulana | [@dwiahmad02](https://github.com/dwiahmad02) |

## 📄 Lisensi

Proyek ini dibuat untuk keperluan akademik (Praktikum Pemrograman Mobile).
