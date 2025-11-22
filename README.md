# Car Rental App : TryCarRent

<div align="center">

![Flutter](https://img.shields.io/badge/Flutter-02569B?style=for-the-badge&logo=flutter&logoColor=white)
![Dart](https://img.shields.io/badge/Dart-0175C2?style=for-the-badge&logo=dart&logoColor=white)
![SQLite](https://img.shields.io/badge/SQLite-07405E?style=for-the-badge&logo=sqlite&logoColor=white)

**Aplikasi Penyewaan Mobil Berbasis Flutter dengan Database SQFLite**

</div>

---

##  Tentang Aplikasi

**Car Rental App** adalah aplikasi mobile untuk manajemen penyewaan mobil yang dibangun menggunakan Flutter dan SQLite. Aplikasi ini memungkinkan pengguna untuk melihat katalog mobil, melakukan penyewaan, melihat riwayat transaksi, dan mengelola profil mereka.

###  Tujuan Aplikasi

- Mempermudah proses penyewaan mobil secara digital
- Mengelola data pengguna, mobil, dan transaksi rental
- Memberikan pengalaman user yang intuitif dan modern
- Implementasi database lokal dengan SQfLite
- Menyelesaikan Project UTS Pemprograman IF 5B dengan kode soal C3

---

## Features

###  User Management
- 1 **Registrasi User** - Daftar akun baru dengan validasi lengkap
- 2 **Login/Logout** - Autentikasi pengguna yang aman
- 3 **Profile Management** - Edit profil pengguna (nama, email, telepon, alamat)
- 4 **Password Change** - Ubah password dengan validasi

###  Car Management
- 1 **Katalog Mobil** - Lihat daftar mobil dengan detail lengkap
- 2 **Filter & Search** - Cari mobil berdasarkan tipe dan ketersediaan
- 3 **Car Details** - Informasi lengkap mobil (harga, transmisi, kapasitas)
- 4 **Availability Status** - Real-time status ketersediaan mobil

###  Rental Management
- ✅ **Create Rental** - Buat transaksi penyewaan baru
- ✅ **Rental History** - Lihat riwayat penyewaan (Active & Completed)
- ✅ **Rental Details** - Detail transaksi lengkap
- ✅ **Complete Rental** - Selesaikan penyewaan dan kembalikan mobil
- ✅ **Auto Price Calculation** - Hitung otomatis total harga berdasarkan durasi

### 🎨 UI/UX Features
- ✅ **Onboarding Screens** - Welcome screens dengan animasi smooth
- ✅ **Purple Theme** - Tema konsisten dengan purple family colors
- ✅ **Responsive Design** - Tampilan optimal di berbagai ukuran layar
- ✅ **Loading States** - Indikator loading saat fetch data
- ✅ **Error Handling** - Penanganan error dengan pesan yang jelas
- ✅ **Pull to Refresh** - Refresh data dengan pull gesture
- ✅ **Empty States** - Tampilan menarik saat data kosong
- ✅ **Confirmation Dialogs** - Konfirmasi untuk aksi penting

### 🛠️ Developer Tools
- ✅ **Debug Page** - Monitor database (jumlah users, cars, rentals)
- ✅ **Reset Car Availability** - Set semua mobil jadi available
- ✅ **Console Logging** - Debug logs untuk tracking data flow
- ✅ **Database Migration** - Upgrade database tanpa hapus data

---

## 🛠️ Tech Stack

### Frontend
- **Flutter** - UI Framework
- **Dart** - Programming Language
- **Material Design** - Design System

### Backend/Database
- **SQLite** - Local Database
- **sqflite** - SQLite plugin for Flutter
- **path** - File path manipulation

### State Management
- **StatefulWidget** - Flutter state management

### Utilities
- **intl** - Internationalization & date formatting
- **path_provider** - File system path

---

##  Struktur Folder

```
car_rental_app/
│
├── assets/
│   └── images/
│       ├── onboarding1.png
│       ├── onboarding2.png
│       ├── onboarding3.png
│       ├── avanza.png
│       ├── civic.png
│       ├── xpander.png
│       ├── fortuner.png
│       └── ertiga.png
│
├── lib/
│   ├── main.dart                          # Entry point aplikasi
│   │
│   ├── data/
│   │   ├── db/
│   │   │   └── db_helper.dart            # Database helper & configuration
│   │   │
│   │   ├── dao/
│   │   │   ├── user_dao.dart             # User Data Access Object
│   │   │   ├── car_dao.dart              # Car Data Access Object
│   │   │   └── rental_dao.dart           # Rental Data Access Object
│   │   │
│   │   └── model/
│   │       ├── user_model.dart           # User data model
│   │       ├── car_model.dart            # Car data model
│   │       └── rental_model.dart         # Rental data model
│   │
│   └── screen/
│       ├── onboarding_page.dart          # Welcome screens
│       ├── login_page.dart               # Login screen
│       ├── register_page.dart            # Register screen
│       ├── home_page.dart                # Dashboard/Home
│       ├── car_list_page.dart            # Daftar semua mobil
│       ├── rental_page.dart              # Form penyewaan
│       ├── history_page.dart             # Riwayat transaksi
│       ├── detail_rental_page.dart       # Detail transaksi
│       ├── profile_page.dart             # Profile user
│       
│
├── pubspec.yaml                           # Dependencies
└── README.md                              # Dokumentasi
```

---

##  Database Structure

### Database Schema

#### **Table: users**
```sql
CREATE TABLE users (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  username TEXT UNIQUE NOT NULL,
  name TEXT NOT NULL,
  nik TEXT NOT NULL,
  email TEXT NOT NULL,
  phone TEXT NOT NULL,
  address TEXT NOT NULL,
  password TEXT NOT NULL
)
```

| Column | Type | Description |
|--------|------|-------------|
| id | INTEGER | Primary key (auto increment) |
| username | TEXT | Username unik untuk login |
| name | TEXT | Nama lengkap user |
| nik | TEXT | Nomor Induk Kependudukan (16 digit) |
| email | TEXT | Email user |
| phone | TEXT | Nomor telepon |
| address | TEXT | Alamat lengkap |
| password | TEXT | Password (stored as plain text) |

---

#### **Table: cars**
```sql
CREATE TABLE cars (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  name TEXT NOT NULL,
  type TEXT NOT NULL,
  image TEXT,
  price_per_day INTEGER NOT NULL,
  year INTEGER NOT NULL,
  transmission TEXT NOT NULL,
  seats INTEGER NOT NULL,
  is_available INTEGER NOT NULL DEFAULT 1
)
```

| Column | Type | Description |
|--------|------|-------------|
| id | INTEGER | Primary key (auto increment) |
| name | TEXT | Nama mobil (e.g., "Toyota Avanza") |
| type | TEXT | Tipe mobil (MPV, Sedan, SUV) |
| image | TEXT | Path gambar mobil |
| price_per_day | INTEGER | Harga sewa per hari (Rupiah) |
| year | INTEGER | Tahun produksi |
| transmission | TEXT | Jenis transmisi (Manual/Automatic) |
| seats | INTEGER | Kapasitas kursi |
| is_available | INTEGER | Status ketersediaan (1=available, 0=rented) |

**Default Cars Data:**
```dart
1. Toyota Avanza   - MPV    - Rp 350,000/hari - 7 seats - Manual
2. Honda Civic     - Sedan  - Rp 500,000/hari - 5 seats - Automatic
3. Mitsubishi Xpander - MPV - Rp 400,000/hari - 7 seats - Automatic
4. Toyota Fortuner - SUV    - Rp 800,000/hari - 7 seats - Automatic
5. Suzuki Ertiga   - MPV    - Rp 300,000/hari - 7 seats - Manual
```

---

#### **Table: rentals**
```sql
CREATE TABLE rentals (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  user_id INTEGER NOT NULL,
  car_id INTEGER NOT NULL,
  car_name TEXT NOT NULL,
  renter_name TEXT NOT NULL,
  rental_days INTEGER NOT NULL,
  start_date TEXT NOT NULL,
  end_date TEXT NOT NULL,
  total_price INTEGER NOT NULL,
  status TEXT NOT NULL DEFAULT 'active',
  created_at TEXT NOT NULL,
  FOREIGN KEY (user_id) REFERENCES users (id),
  FOREIGN KEY (car_id) REFERENCES cars (id)
)
```

| Column | Type | Description |
|--------|------|-------------|
| id | INTEGER | Primary key (auto increment) |
| user_id | INTEGER | ID user yang menyewa (FK) |
| car_id | INTEGER | ID mobil yang disewa (FK) |
| car_name | TEXT | Nama mobil (denormalized) |
| renter_name | TEXT | Nama penyewa |
| rental_days | INTEGER | Durasi sewa (hari) |
| start_date | TEXT | Tanggal mulai (ISO 8601) |
| end_date | TEXT | Tanggal selesai (ISO 8601) |
| total_price | INTEGER | Total harga (price_per_day × rental_days) |
| status | TEXT | Status rental (active/completed) |
| created_at | TEXT | Timestamp pembuatan (ISO 8601) |

---

### Database Relationships

```
users (1) ──────< (N) rentals
                    │
cars (1) ───────< (N) rentals

One user can have many rentals
One car can have many rentals
```

---

###  Database Migration

**Version 1 → Version 2:**
```dart
// Menambahkan tabel rentals tanpa hapus data users & cars
Future _onUpgrade(Database db, int oldVersion, int newVersion) async {
  if (oldVersion < 2) {
    await db.execute('''
      CREATE TABLE IF NOT EXISTS rentals (...)
    ''');
  }
}
```

---

##  UI Flow Diagram

```
┌─────────────────┐
│  Onboarding     │
│  (3 Screens)    │
└────────┬────────┘
         │
         ▼
┌─────────────────┐
│  Login Page     │◄─────────┐
└────────┬────────┘          │
         │                   │
         ▼                   │
┌─────────────────┐          │
│  Register Page  │──────────┘
└─────────────────┘

         │ Login Success
         ▼
┌─────────────────────────────────────┐
│           Home Page                 │
│  ┌─────────────────────────────┐   │
│  │ Header: Welcome, [Name]     │   │
│  │ Avatar Circle               │   │
│  └─────────────────────────────┘   │
│                                     │
│  ┌─────────────────────────────┐   │
│  │ Menu Grid (2x2):            │   │
│  │ • Tambah Sewa    • Riwayat  │   │
│  │ • Profil         • Keluar   │   │
│  │ • Debug DB (optional)       │   │
│  └─────────────────────────────┘   │
│                                     │
│  ┌─────────────────────────────┐   │
│  │ Mobil Rekomendasi (Top 3)   │   │
│  │ [Card][Card][Card]          │   │
│  └─────────────────────────────┘   │
└──────┬──────┬──────┬──────┬────────┘
       │      │      │      │
       ▼      ▼      ▼      ▼
   ┌────┐ ┌─────┐ ┌────┐ ┌─────┐
   │Cars│ │Hist │ │Prof│ │Logout│
   └──┬─┘ └──┬──┘ └──┬─┘ └─────┘
      │      │       │
      ▼      ▼       ▼
┌──────────┐ ┌─────────┐ ┌──────────┐
│Car List  │ │History  │ │Profile   │
│Page      │ │Page     │ │Page      │
│          │ │         │ │          │
│• Filter  │ │• Active │ │• Edit    │
│• Available│ │• Completed│ │• Change │
│• Card    │ │• Detail │ │  Password│
└────┬─────┘ └─────┬───┘ └──────────┘
     │             │
     ▼             ▼
┌──────────┐ ┌──────────┐
│Rental    │ │Detail    │
│Form Page │ │Rental    │
│          │ │Page      │
│• Select  │ │          │
│  Dates   │ │• Complete│
│• Auto    │ │  Rental  │
│  Calculate│ │• Return  │
│• Submit  │ │  Car     │
└──────────┘ └──────────┘
```

---

##  User Journey

###  New User Flow
```
1. Open App
   ↓
2. Onboarding (Swipe 3 screens atau Skip)
   ↓
3. Login Page → Click "Register"
   ↓
4. Fill Registration Form
   • Name, NIK (16 digits)
   • Email, Phone
   • Address
   • Username, Password
   ↓
5. Submit → Validation
   ↓
6. Success → Auto redirect to Login
   ↓
7. Login with new account
   ↓
8. Home Page
```

### Existing User Flow
```
1. Open App
   ↓
2. Onboarding → Skip
   ↓
3. Login
   ↓
4. Home Page
   ↓
5. Browse Cars atau Check History
```

###  Rental Flow
```
1. Home Page → "Tambah Sewa"
   ↓
2. Car List Page
   • Lihat semua mobil
   • Filter by type (All/MPV/Sedan/SUV)
   • Hanya tampil mobil available
   ↓
3. Select Car → "Sewa"
   ↓
4. Rental Form Page
   • Isi nama penyewa
   • Pilih tanggal mulai
   • Pilih tanggal selesai
   • Sistem auto hitung durasi & total harga
   ↓
5. Submit Rental
   • Insert rental ke database
   • Set car availability = false
   • Redirect ke Home
   ↓
6. Check History
   • Active rentals (ongoing)
   • Completed rentals (finished)
   ↓
7. Complete Rental
   • Click rental card
   • Detail Rental Page
   • Click "Selesaikan Penyewaan"
   • Confirmation dialog
   • Update status = completed
   • Set car availability = true
   • Mobil kembali tersedia
```

---

##  Key Features Detail

###  Search & Filter
```dart
// Filter by car type
List<String> types = ['All', 'MPV', 'Sedan', 'SUV'];

// Auto-filter available cars only
final availableCars = cars.where((car) => car.isAvailable).toList();
```

###  Auto Price Calculation
```dart
// Hitung otomatis saat pilih tanggal
int rentalDays = _endDate!.difference(_startDate!).inDays + 1;
int totalPrice = widget.car.pricePerDay * rentalDays;

// Format Rupiah
NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0)
```

###  Date Validation
```dart
// Start date harus hari ini atau lebih
minimumDate: DateTime.now()

// End date otomatis adjust jika < start date
if (_endDate != null && _endDate!.isBefore(_startDate!)) {
  _endDate = _startDate;
}
```

###  Real-time Availability
```dart
// Saat create rental
await CarDao().updateAvailability(carId, false); // Set unavailable

// Saat complete rental
await CarDao().updateAvailability(carId, true); // Set available

// Auto refresh list
await _loadCars();
```

---

## 🚀 Installation

### Prerequisites
- Flutter SDK 3.x atau lebih baru
- Dart SDK 3.x atau lebih baru
- Android Studio / VS Code
- Android Emulator atau Physical Device

### Setup Steps

**1. Clone Repository**
```bash
git clone https://github.com/yourusername/car_rental_app.git
cd car_rental_app
```

**2. Install Dependencies**
```bash
flutter pub get
```

**3. Prepare Assets**
Pastikan folder `assets/images/` berisi gambar-gambar mobil dan onboarding.

**4. Update `pubspec.yaml`**
```yaml
dependencies:
  flutter:
    sdk: flutter
  sqflite: ^2.3.0
  path: ^1.8.3
  intl: ^0.18.1

flutter:
  assets:
    - assets/images/
```

**5. Run App**
```bash
# Pilih device/emulator
flutter devices

# Run app
flutter run

# Atau run with debug
flutter run -d <device-id>
```

**6. Build APK (Optional)**
```bash
# Debug APK
flutter build apk

# Release APK
flutter build apk --release

# Output: build/app/outputs/flutter-apk/app-release.apk
```

---

##  Usage

###  First Time Setup

**1. Launch App**
```
App akan menampilkan Onboarding screens
Swipe atau klik "Skip" untuk lewati
```

**2. Register Account**
```
• Klik "Register" di Login Page
• Isi form registrasi lengkap
• Username harus unik
• NIK harus 16 digit
• Submit → Auto redirect ke Login
```

**3. Login**
```
• Masukkan username & password
• Klik "Login"
• Redirect ke Home Page
```

###  Sewa Mobil

**1. Browse Cars**
```
Home Page → Klik "Tambah Sewa"
atau
Scroll ke "Mobil Rekomendasi" → Klik "Lihat Semua"
```

**2. Filter Cars**
```
Car List Page → Filter by type:
• All (Semua mobil)
• MPV (7-seater family cars)
• Sedan (Compact cars)
• SUV (Large family cars)
```

**3. Create Rental**
```
• Pilih mobil → Klik "Sewa"
• Isi nama penyewa
• Pilih tanggal mulai & selesai
• Cek total harga (auto calculate)
• Klik "Buat Penyewaan"
```

**4. Check Rental**
```
Home Page → Klik "Riwayat Sewa"
• Tab "Aktif" = Ongoing rentals
• Tab "Selesai" = Completed rentals
• Klik card untuk lihat detail
```

**5. Complete Rental**
```
• Detail Rental Page → Klik "Selesaikan Penyewaan"
• Konfirmasi → Klik "Selesaikan"
• Status berubah jadi "Selesai"
• Mobil kembali available
```

###  Manage Profile

**1. Edit Profile**
```
Home Page → Klik "Profil"
• Edit Name, Email, Phone, Address
• Klik "Update Profile"
```

**2. Change Password**
```
Profile Page → Klik "Ubah Password"
• Masukkan password lama
• Masukkan password baru (min 6 karakter)
• Konfirmasi password baru
• Klik "Ubah Password"
```

###  Debug Tools

**1. Access Debug Page**
```
Home Page → Klik "Debug DB"
```

**2. Features**
```
• View total users, cars, rentals
• View available cars count
• Print all data to console
• Reset all cars to AVAILABLE
```

---

## Screenshots

### Onboarding & Auth
```
┌────────────┐  ┌────────────┐  ┌────────────┐
│ Onboarding │  │   Login    │  │  Register  │
│  Screen 1  │→ │    Page    │→ │    Page    │
└────────────┘  └────────────┘  └────────────┘
```

### Main Features
```
┌────────────┐  ┌────────────┐  ┌────────────┐
│    Home    │  │  Car List  │  │   Rental   │
│    Page    │→ │    Page    │→ │    Form    │
└────────────┘  └────────────┘  └────────────┘
```

### History & Profile
```
┌────────────┐  ┌────────────┐  ┌────────────┐
│  History   │  │   Detail   │  │  Profile   │
│    Page    │→ │   Rental   │  │    Page    │
└────────────┘  └────────────┘  └────────────┘
```

---

##  Testing

### Manual Testing Checklist

**Authentication**
- [ ] Register dengan data lengkap
- [ ] Register dengan username yang sudah ada (should error)
- [ ] Login dengan credentials benar
- [ ] Login dengan credentials salah (should error)
- [ ] Logout dari app

**Car Management**
- [ ] Lihat semua mobil di Car List
- [ ] Filter mobil by type (MPV/Sedan/SUV)
- [ ] Available cars only muncul
- [ ] Unavailable cars tidak muncul di list

**Rental Management**
- [ ] Create rental baru
- [ ] Auto calculation total price
- [ ] Date validation (end > start)
- [ ] Car availability berubah jadi unavailable setelah rental
- [ ] Lihat active rentals di History
- [ ] Complete rental
- [ ] Car availability berubah jadi available setelah complete
- [ ] Rental muncul di tab "Selesai"

**Profile Management**
- [ ] Edit profile
- [ ] Change password
- [ ] Validation password (min 6 chars)

**UI/UX**
- [ ] Pull to refresh works
- [ ] Loading states muncul
- [ ] Empty states muncul saat data kosong
- [ ] Confirmation dialogs muncul
- [ ] Error messages jelas


## 📚 Code Examples

### Create New User
```dart
final newUser = UserModel(
  name: 'John Doe',
  nik: '1234567890123456',
  email: 'john@example.com',
  phone: '081234567890',
  address: 'Jakarta',
  username: 'johndoe',
  password: 'password123',
);

await UserDao().insert(newUser);
```

### Create Rental
```dart
final rental = RentalModel(
  userId: user.id!,
  carId: car.id!,
  carName: car.name,
  renterName: 'John Doe',
  rentalDays: 3,
  startDate: DateTime.now(),
  endDate: DateTime.now().add(Duration(days: 3)),
  totalPrice: car.pricePerDay * 3,
);

await RentalDao().insert(rental);
await CarDao().updateAvailability(car.id!, false);
```

### Update Car Availability
```dart
// Set unavailable
await CarDao().updateAvailability(carId, false);

// Set available
await CarDao().updateAvailability(carId, true);
```

### Query Data
```dart
// Get all available cars
final availableCars = await CarDao().findAvailable();

// Get active rentals by user
final activeRentals = await RentalDao().findActiveByUserId(userId);

// Get completed rentals
final completedRentals = await RentalDao().findCompletedByUserId(userId);
```

**UI Referensi & ImageCar**
- https://www.sketchflow.ai/designPage/editor?project_id=43372&design_id=44020&pageId=778660

**Video Recording TryCarRent**


**Dibuat**
- Nama: Sustri Elina Simamora
- Kelas: IF 5B
- NIM : 3012310040
