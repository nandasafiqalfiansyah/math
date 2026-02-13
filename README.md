Math
====

A simple SwiftUI calculator app (Basic, Scientific, Programmer) built with SwiftData for persistence.

Deskripsi
---------
Aplikasi "Math" adalah demo kalkulator multiplatform (iOS & macOS) dibuat dengan SwiftUI dan SwiftData. Aplikasi menyediakan tiga mode kalkulator (Basic, Scientific, Programmer) dengan navigasi sidebar, penyimpanan riwayat per-kalkulator, dan About sheet yang menampilkan versi serta pembuat.

Fitur Utama
-----------
- Tiga tipe kalkulator: Basic, Scientific, Programmer
- Sidebar navigation (NavigationSplitView) untuk memilih kalkulator
- Default: aplikasi membuat Kalkulator Basic otomatis saat pertama kali dibuka jika belum ada
- Riwayat per-kalkulator disimpan menggunakan SwiftData; sidebar menampilkan ringkasan riwayat global
- About sheet (menu) menampilkan versi dan pembuat: Nanda Safiq Alfiansyah
- Ikon menggunakan SF Symbols di sidebar dan toolbar
- Fallback ModelContainer in-memory saat ada mismatch schema untuk kenyamanan development

Screenshot
----------
(Sertakan screenshot di GitHub repo dengan menambahkan file di `Assets` dan referensi di sini.)

Persyaratan
-----------
- Xcode 15 atau lebih baru (disarankan)
- Target: iOS 17+ / macOS Sonoma+ untuk fitur SwiftData terbaik

Membangun & Menjalankan
-----------------------
1) Buka proyek di Xcode

```bash
open "math.xcodeproj"
```

2) Clean build (optional but recommended)
- Product → Clean Build Folder (Shift-Command-K)

3) Build & Run
- Build: Command-B
- Run: Command-R (pilih simulator atau perangkat)

Menjalankan tests (opsional)

```bash
xcodebuild test -project "math.xcodeproj" -scheme math -destination 'platform=iOS Simulator,name=iPhone 14'
```

Catatan SwiftData & Persistensi
-------------------------------
- Model disimpan dengan SwiftData `ModelContainer`.
- Jika schema model berubah selama development, app akan mencoba create persistent container; bila gagal, aplikasi akan fallback ke in-memory ModelContainer agar tetap bisa dibuka (berguna saat mengembangkan model).
- Untuk mereset data saat development: uninstall app dari simulator/device atau Reset Content & Settings di Simulator.

Behavior Default
----------------
- Saat pertama kali dijalankan (atau kalau database kosong), aplikasi membuat kalkulator bertipe Basic dan langsung memilihnya.
- Pilih kalkulator di sidebar untuk membuka tampilan kalkulator.
- Setiap perhitungan disimpan ke riwayat per-kalkulator dan terlihat di bagian History di detail serta ringkasan di sidebar.

Troubleshooting (SIGABRT / getValue)
-----------------------------------
Jika Anda menemukan crash SIGABRT atau error runtime berkaitan dengan SwiftData:

1. Aktifkan Exception Breakpoint di Xcode (Debug navigator → + → Add Exception Breakpoint) dan jalankan ulang untuk mendapatkan stack trace.
2. Lihat console / device logs untuk pesan runtime yang mengarah ke SwiftData atau macro.
3. Jika masalah berkaitan dengan schema mismatch, hapus aplikasi dari simulator/device dan build ulang.
4. Jika crash terjadi pada selection/listing SwiftUI (getValue), pastikan Anda menggunakan `UUID`/id untuk selection (project ini sudah menerapkan pattern tersebut).

Contributing
------------
Kontribusi kecil diterima: file issue untuk bug, PR untuk perbaikan UX atau penambahan fitur. Beberapa ide pengembangan:
- Tombol "Clear History" per-kalkulator atau "Clear All History"
- Pilihan ikon kustom per-kalkulator (disimpan ke model)
- Ganti evaluator `NSExpression` di `BasicCalculatorView` dengan parser ekspresi yang lebih aman untuk produksi
- Unit tests untuk evaluator dan operasi ilmiah

License
-------
Proyek ini dilisensikan di bawah MIT License — lihat `LICENSE` (tambahkan file LICENSE di repo jika ingin menerapkan).

Author & Kontak
----------------
Pembuat: Nanda Safiq Alfiansyah

Jika ada bug atau permintaan fitur, buka issue atau kirim PR di GitHub. Terima kasih telah melihat proyek ini.
