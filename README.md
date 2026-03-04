# 🌿 Herbal App

Aplikasi Herbal App adalah platform mobile berbasis Flutter yang dirancang untuk menemukan produk herbal berkualitas, berkonsultasi dengan praktisi herbal, dan berbagi pengetahuan tentang kesehatan tradisional.



---

## ✨ Fitur Utama

### 👥 Untuk Pembeli
- 🔍 **Jelajahi Produk** - Cari produk herbal dari berbagai penjual dengan kategori lengkap
- 💬 **Konsultasi Praktisi** - Hubungi praktisi herbal berpengalaman untuk konsultasi
- 💬 **Forum Komunitas** - Diskusi dan berbagi pengalaman dengan pengguna lain (perencanaan)
- ❤️ **Wishlist** - Simpan produk favorit untuk dibeli kemudian (perencanaan)

### 🏪 Untuk Penjual (UMKM)
- 📦 **Kelola Produk** - Tambah, edit, dan hapus produk dengan mudah
- 📊 **Dashboard Toko** - Lihat info toko dan performa penjualan
- 📸 **Upload Gambar** - Unggah multiple gambar produk ke cloud storage
- 🔄 **Multi-Role Account** - Satu akun bisa jadi penjual sekaligus praktisi

### 🌱 Untuk Praktisi Herbal
- 👤 **Profile Profesional** - Tampilkan kredensial dan sertifikasi
- 🏥 **Kelola Praktik** - Informasi tempat praktik dan layanan yang ditawarkan
- 📱 **Kontak Langsung** - Customer bisa menghubungi via WhatsApp atau media sosial
- 📋 **Riwayat Praktik** - Tampilkan pengalaman dan keahlian

---

## 🛠️ Tech Stack

### Frontend
- **Framework**: Flutter 3.0+
- **Language**: Dart
- **State Management**: BLoC Pattern
- **Navigation**: GoRouter
- **UI Components**: 
  - Material Design 3
  - FlexColorScheme (theming)
  - Cached Network Image
  - Staggered Grid View
  - Carousel Slider

### Backend & Services
- **Backend**: Supabase (PostgreSQL)
- **Authentication**: Supabase Auth + Google Sign-In
- **File Storage**: Supabase Storage
- **Database**: PostgreSQL
- **API**: RESTful (via Supabase)

### Tools & Libraries
- **Dependency Injection**: GetIt
- **Local Storage**: SharedPreferences
- **Image Picker**: image_picker
- **UUID Generation**: uuid
- **HTTP Client**: Built-in dari Supabase SDK

---

## 📱 Struktur Aplikasi

```
lib/
├── Feature/
│   ├── authentication/    # Login, Register, OTP verification
│   ├── home/             # Home screen & product showcase
│   ├── product/          # Product list & detail
│   ├── praktisi/         # Practitioner directory
│   ├── forum/            # Community forum
│   ├── profile/          # User profiles (buyer, seller, practitioner)
│   └── settings/         # App settings & role management
├── core/
│   ├── themes/           # App theming
│   ├── router/           # Navigation routes
│   └── dependency_injector/ # Service locator setup
├── data/
│   ├── models/           # Data models
│   ├── services/         # API & business logic
│   └── repositories/     # Data access layer
└── components/           # Reusable UI widgets
```

---

## 📋 Fitur Detail

### Sistem Role Multi-Account
Pengguna bisa memiliki multiple role dalam satu akun:
- **Pengguna Biasa** - Pembeli standar
- **Penjual** - UMKM yang menjual produk herbal
- **Praktisi** - Ahli herbal/terapis tradisional

Ganti role kapan saja melalui Settings.

### Manajemen Produk
- Upload gambar produk (multiple images)
- Detail lengkap: harga, kategori, khasiat, kemasan, dll
- Edit dan hapus produk
- Kategorisasi otomatis berdasarkan database

### Autentikasi Aman
- Email + Password dengan OTP verification
- Google Sign-In integration
- Role-based access control
- Session management

---

## 📸 Screenshots
  | Home | List Products | Practitioner Detail | Product Detail |
|------|----------|-----------------|---------|
| <img src="https://github.com/user-attachments/assets/c2c07190-7d0e-4179-b1c2-2746403e765f" height="400em" > | <img src="https://github.com/user-attachments/assets/22b198b5-e985-4161-8735-f1bec5354738" height="400em" > | <img src="https://github.com/user-attachments/assets/8227fd42-92b2-4c1c-b918-8458b436e86e" height="400em" > | <img src="https://github.com/user-attachments/assets/ee423a44-1792-46e1-9d48-937df78dec19" height="400em" > |

  | Splash | User Profile | Seller Profile | Practitioner Profile |
|------|----------|-----------------|---------|
| <img src="https://github.com/user-attachments/assets/6e75a694-eb69-43f5-a443-58e78a40f5b1" height="400em" > | <img src="https://github.com/user-attachments/assets/13aa1f55-0556-4a52-8a7a-3012912edabe" height="400em" > | <img src="https://github.com/user-attachments/assets/6d87433a-fbf7-498c-bae4-403391ee7d82" height="400em" > | <img src="https://github.com/user-attachments/assets/8a25d8be-7c5c-40db-9390-4055a2d79457" height="400em" > |

| Add Product | Settings | Role Management | Login |
|-------------|----------|-----------------|---------|
| <img src="https://github.com/user-attachments/assets/963ca546-1dca-4d50-9660-aeeaa5f51de7" height="400em" >|   <img src="https://github.com/user-attachments/assets/58feaf45-665e-40fc-b00b-73d5975215c8" height="400em" > | <img src="https://github.com/user-attachments/assets/6287eaab-9d9d-4a74-94e0-e2f370045086" height="400em" > |<img src="https://github.com/user-attachments/assets/97c1a47c-c639-4997-88af-43cd3b4b99c1" height="400em" >|
  

---

## 🔐 Keamanan

- ✅ Authentication dengan Supabase Auth
- ✅ Row Level Security (RLS) di database
- ✅ Secure file upload ke cloud storage
- ✅ Input validation di semua forms

---


## 👨‍💻 Author

**[Zaky Zaidan]**
- GitHub: [@zakyzaidan](https://github.com/zakyzaidan)
- Email: zakyzaidan.id@gmail.com

---

*note: masih terdapat error dalam aplikasi


<div align="center">

**[⬆ Kembali ke atas](#-herbal-app)**



</div>
