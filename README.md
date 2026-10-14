# Pills Reminder

Aplikasi manajemen dan pengingat obat berbasis Flutter.
Proyek Mobile Programming - Kelompok 3, Teknik Informatika UIN Maulana Malik Ibrahim Malang.

Pengguna dapat mencatat obat (nama, dosis, frekuensi, jam, rentang tanggal), menerima
notifikasi pengingat otomatis (sekali / harian / mingguan), menandai dosis sudah diminum,
dan melihat riwayat serta kepatuhan 7 hari terakhir. Semua data tersimpan lokal (Hive),
tanpa akun dan tanpa internet.

## Teknologi

| Kebutuhan | Paket |
|---|---|
| State management & DI & routing | `get` (GetX) |
| Basis data lokal (NoSQL) | `hive`, `hive_flutter` |
| Notifikasi terjadwal | `flutter_local_notifications` (dikunci 17.2.4), `timezone`, `flutter_timezone` (dikunci 3.0.1) |
| Arsitektur | Clean Architecture (domain / data / presentation) |

> Versi `flutter_local_notifications` dan `flutter_timezone` sengaja dikunci karena
> versi mayor yang lebih baru mengubah signature API (mis. parameter bernama pada
> `initialize` / `zonedSchedule`). Jika ingin memperbarui, sesuaikan
> `lib/data/services/local_notification_scheduler.dart`.

## Cara menjalankan

Folder ini berisi kode Dart (`lib/`, `test/`, `pubspec.yaml`). Folder platform
(`android/`, `ios/`) dibuat oleh Flutter agar sesuai versi SDK Anda:

```bash
# 1. Buat proyek Flutter kosong sebagai kerangka platform
flutter create --org id.ac.uinmalang --project-name pills_reminder pills_reminder_app

# 2. Ganti kode bawaan dengan kode proyek ini
cd pills_reminder_app
rm -rf lib test pubspec.yaml
cp -r ../pills_reminder/lib ../pills_reminder/test ../pills_reminder/pubspec.yaml \
      ../pills_reminder/analysis_options.yaml ../pills_reminder/.gitignore .

# 3. Konfigurasi Android/iOS (lihat docs/ANDROID_SETUP.md), lalu:
flutter pub get
flutter analyze
flutter test
flutter run
```

Setup platform wajib agar notifikasi berfungsi: **docs/ANDROID_SETUP.md**.

## Struktur folder (Clean Architecture)

```
lib/
  main.dart                      titik masuk: init Hive + notifikasi
  app/                           GetMaterialApp, rute, binding (DI)
  core/                          konstanta, tema, utilitas tanggal
  domain/                        lapisan bisnis (tanpa dependensi framework)
    entities/                    Medicine, IntakeLog, ScheduledDose, AdherenceSummary
    repositories/                kontrak repositori
    services/                    ReminderScheduler (kontrak), DoseScheduler (logika jadwal)
    usecases/                    aksi bisnis (tambah, ubah, hapus, tandai diminum, dst.)
    validators/                  aturan validasi masukan
  data/                          lapisan data
    models/                      serialisasi entitas <-> Map
    datasources/                 akses Hive
    repositories/                implementasi repositori
    services/                    LocalNotificationScheduler
  presentation/                  lapisan UI
    controllers/                 GetxController
    pages/                       halaman
    widgets/                     komponen UI bersama
test/                            unit test (jadwal dosis & validasi)
```

## Navigasi

`Splash` -> `MainShell` (tab: **Hari Ini**, **Obat**, **Riwayat**) -> `Form Obat` (tambah/ubah)
dan `Detail Obat`.

## Fitur MVP

- Tambah, ubah, hapus obat (validasi masukan lengkap)
- Frekuensi: sekali, harian, mingguan (pilih hari), hingga 4 jam pengingat per obat
- Notifikasi terjadwal (tetap berjalan saat aplikasi ditutup) + tombol "Tes notifikasi"
- Jadwal hari ini dengan status Belum waktunya / Terlewat / Sudah diminum
- Tandai sudah diminum (dan batalkan jika salah tekan)
- Riwayat konsumsi per tanggal + persentase kepatuhan 7 hari
- Penyimpanan lokal Hive

## Batasan yang diketahui

- Notifikasi berulang tidak berhenti sendiri saat tanggal selesai terlewati; jadwal
  diselaraskan ulang setiap aplikasi dibuka (`SyncRemindersUseCase`).
- Mengetuk notifikasi saat aplikasi sudah tertutup total hanya membuka aplikasi
  (belum langsung ke halaman detail).
- Android 12+ memerlukan izin "alarm presisi"; jika ditolak, aplikasi memakai alarm
  tidak presisi (bisa terlambat beberapa menit).
- Beberapa pabrikan (Xiaomi, Oppo, Vivo, dll.) membatasi aplikasi di latar belakang;
  matikan optimasi baterai untuk aplikasi ini agar notifikasi tepat waktu.

## Alur kerja Git yang disarankan

```bash
git init
git add .
git commit -m "chore: inisialisasi proyek Flutter Pills Reminder"
git branch -M main
git remote add origin <URL-REPOSITORI>
git push -u origin main
```

Gunakan cabang `feature/<nama-fitur>` per fitur dan pesan commit berawalan
`feat:`, `fix:`, `docs:`, `test:`, `refactor:`.
