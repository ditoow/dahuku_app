# DahuKu 💰

Aplikasi manajemen keuangan pribadi berbasis Flutter dengan fitur **offline-first** dan **edukasi finansial** melalui komik interaktif.

![Flutter](https://img.shields.io/badge/Flutter-3.9+-02569B?style=flat&logo=flutter)
![Dart](https://img.shields.io/badge/Dart-3.0+-0175C2?style=flat&logo=dart)
![Supabase](https://img.shields.io/badge/Supabase-Backend-3ECF8E?style=flat&logo=supabase)

---

## 📱 Screenshots

<!-- Tambahkan screenshot aplikasi di sini -->

| Dashboard                               | Analytics                               | Education                               |
| --------------------------------------- | --------------------------------------- | --------------------------------------- |
| ![Dashboard](screenshots/dashboard.png) | ![Analytics](screenshots/analytics.png) | ![Education](screenshots/education.png) |

---

## ✨ Fitur Utama

### 🏠 Dashboard

- **Wallet Cards** - Kelola multi-wallet (Dompet, Tabungan, Dana Darurat)
- **Quick Summary** - Ringkasan pengeluaran mingguan
- **Transaksi Terbaru** - Daftar transaksi terkini dengan navigasi ke detail

### 📊 Analytics

- **Grafik Pengeluaran** - Visualisasi tren keuangan
- **Kategori Spending** - Breakdown pengeluaran per kategori
- **Riwayat Transaksi** - History lengkap semua transaksi

### 💸 Manajemen Transaksi

- **Catat Transaksi** - Input pemasukan & pengeluaran
- **Pindah Uang** - Transfer antar wallet
- **Multi-Wallet Support** - Dompet, Tabungan, Dana Darurat

### 📚 Education

- **Komik Finansial** - Belajar keuangan melalui komik interaktif
- **Tips & Artikel** - Edukasi manajemen uang

### 🔐 Keamanan

- **PIN Authentication** - Keamanan akses aplikasi
- **Secure Storage** - Penyimpanan data terenkripsi

### 🌐 Offline First

- **Offline Mode** - Aplikasi tetap berfungsi tanpa internet
- **Auto Sync** - Sinkronisasi otomatis saat online
- **Local Storage** - Data tersimpan lokal dengan Hive

---

## 🛠️ Tech Stack

| Teknologi             | Penggunaan                        |
| --------------------- | --------------------------------- |
| **Flutter 3.9+**      | Framework UI cross-platform       |
| **Dart 3.0+**         | Programming language              |
| **BLoC Pattern**      | State management                  |
| **Supabase**          | Backend (Auth, Database, Storage) |
| **Hive**              | Local database untuk offline      |
| **GetIt**             | Dependency injection              |
| **Connectivity Plus** | Deteksi koneksi internet          |

---

## 📁 Struktur Project

```
lib/
├── core/                    # Core utilities & theme
│   └── theme/              # App theming
├── features/               # Feature modules
│   ├── account/            # Profile & settings
│   ├── analytics/          # Analytics & reports
│   ├── boardingfeature/    # Onboarding, Auth, PIN
│   │   ├── auth/           # Login & Register
│   │   ├── onboarding/     # Intro screens
│   │   ├── pin/            # PIN authentication
│   │   ├── questionnaire/  # User questionnaire
│   │   └── splash/         # Splash screen
│   ├── dashboard/          # Main dashboard
│   │   ├── bloc/           # Dashboard state
│   │   ├── pindah_uang/    # Transfer feature
│   │   ├── presentation/   # UI components
│   │   └── transaction/    # Transaction feature
│   └── education/          # Comics & education
├── app.dart                # App routes & config
├── main.dart               # Entry point
└── main_shell_page.dart    # Bottom navigation shell
```

---

## 🚀 Getting Started

### Prerequisites

- Flutter SDK 3.9+
- Dart SDK 3.0+
- Supabase Project (untuk backend)

### Installation

1. **Clone repository**

   ```bash
   git clone https://github.com/username/dahuku_app.git
   cd dahuku_app
   ```

2. **Install dependencies**

   ```bash
   flutter pub get
   ```

3. **Setup Supabase**
   - Buat project di [Supabase](https://supabase.com)
   - Import schema dari `supabase_schema.sql`
   - Update konfigurasi Supabase di project

4. **Generate Hive Adapters**

   ```bash
   flutter pub run build_runner build --delete-conflicting-outputs
   ```

5. **Run aplikasi**
   ```bash
   flutter run
   ```

---

## 📦 Dependencies

```yaml
# State Management
flutter_bloc: ^9.1.1
bloc: ^9.0.0
equatable: ^2.0.7

# Backend
supabase_flutter: ^2.8.4

# Local Storage
hive_flutter: ^1.1.0
shared_preferences: ^2.3.4
flutter_secure_storage: ^9.2.4

# Utilities
get_it: ^8.0.3
connectivity_plus: ^6.1.4
google_fonts: ^6.1.0
intl: ^0.19.0
skeletonizer: ^1.4.2
```

---

## 🔧 Build

### Android

```bash
flutter build apk --release
# atau
flutter build appbundle
```

### iOS

```bash
flutter build ios --release
```

---

## 📄 Database Schema

Database schema tersedia di file `supabase_schema.sql`. Import ke Supabase untuk setup database.

---

## 👨‍💻 Developer

Dibuat dengan ❤️ menggunakan Flutter

---

## 📝 License

MIT License - lihat file [LICENSE](LICENSE) untuk detail.
