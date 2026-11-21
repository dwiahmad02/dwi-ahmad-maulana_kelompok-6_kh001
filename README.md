# Horas Justitia

Aplikasi mobile berbasis **Flutter (Dart)** untuk Horas Advokat, dikembangkan sebagai proyek Praktikum Pemrograman Mobile.

> Ganti bagian bertanda `TODO` dengan informasi sebenarnya dari proyekmu.

## Deskripsi

Horas Justitia adalah aplikasi yang membantu pengelolaan data pada layanan Horas Advokat, termasuk pengelolaan data admin dan pengguna, serta tampilan detail data. Aplikasi terhubung ke Firebase dan layanan API.

TODO: tuliskan 2-3 kalimat tentang tujuan aplikasi dan siapa penggunanya.

## Fitur

- Daftar admin dan halaman detail data
- Manajemen data admin dan pengguna
- Integrasi Firebase
- Dukungan multi bahasa (l10n)
- TODO: tambahkan fitur lain yang sudah jadi

## Teknologi

| Komponen | Keterangan |
|---|---|
| Framework | Flutter |
| Bahasa | Dart |
| Backend | Firebase, REST API |
| Lokalisasi | Flutter l10n (`.arb`) |
| Platform | Android, iOS, Web, Windows, Linux |

## Struktur Folder

```
horas_justitia/
├── android/          # Konfigurasi platform Android
├── ios/              # Konfigurasi platform iOS
├── web/              # Konfigurasi platform Web
├── windows/          # Konfigurasi platform Windows
├── linux/            # Konfigurasi platform Linux
├── test/             # Pengujian
├── lib/
│   ├── constant/     # Warna dan konfigurasi konstan
│   ├── l10n/         # File terjemahan (app_en.arb, dst.)
│   ├── models/       # Model data (admin, user)
│   ├── screens/      # Tampilan (daftar admin, detail)
│   ├── service/      # Layanan data (admin_service, api_service)
│   ├── firebase_options.dart
│   └── main.dart     # Titik masuk aplikasi
├── firebase.json
├── l10n.yaml
└── pubspec.yaml
```

## Prasyarat

- [Flutter SDK](https://docs.flutter.dev/get-started/install) (versi stabil terbaru)
- Android Studio atau VS Code dengan plugin Flutter dan Dart
- Akun Firebase (jika ingin memakai project Firebase sendiri)
- Git

Cek instalasi dengan:

```bash
flutter doctor
```

## Cara Menjalankan

1. Clone repository:

   ```bash
   git clone https://github.com/Horas-Advokat/Horas-Justitia.git
   cd Horas-Justitia
   ```

2. Pasang dependensi:

   ```bash
   flutter pub get
   ```

3. Generate file lokalisasi (jika diperlukan):

   ```bash
   flutter gen-l10n
   ```

4. Jalankan aplikasi:

   ```bash
   flutter run
   ```

   Untuk memilih perangkat tertentu, misalnya Windows:

   ```bash
   flutter run -d windows
   ```

## Konfigurasi Firebase

Proyek ini memakai `firebase_options.dart` hasil FlutterFire CLI. Untuk memakai project Firebase sendiri:

```bash
dart pub global activate flutterfire_cli
flutterfire configure
```

Catatan: jangan menyimpan kunci rahasia atau kredensial pribadi di repository publik.

## Build

```bash
flutter build apk          # Android
flutter build web          # Web
flutter build windows      # Windows
```

## Tim Pengembang

| Nama | Peran |
|---|---|
| Dwi Ahmad Maulana | Developer |

TODO: tambahkan anggota kelompok lain beserta perannya.

## Lisensi

TODO: tentukan lisensi (misalnya MIT) atau tuliskan bahwa proyek ini dibuat untuk keperluan akademik.
