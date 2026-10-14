import 'package:pills_reminder/core/utils/date_time_utils.dart';
import 'package:pills_reminder/domain/entities/medicine.dart';

/// Validasi masukan formulir obat. Semua fungsi mengembalikan
/// pesan kesalahan (String) atau null jika masukan valid.
class MedicineValidator {
  MedicineValidator._();

  static String? name(String? value) {
    final v = (value ?? '').trim();
    if (v.isEmpty) return 'Nama obat wajib diisi';
    if (v.length < 2) return 'Nama obat minimal 2 karakter';
    if (v.length > 50) return 'Nama obat maksimal 50 karakter';
    return null;
  }

  static String? dose(String? value) {
    final v = (value ?? '').trim().replaceAll(',', '.');
    if (v.isEmpty) return 'Dosis wajib diisi';
    final n = double.tryParse(v);
    if (n == null) return 'Dosis harus berupa angka';
    if (n <= 0) return 'Dosis harus lebih dari 0';
    if (n > 1000) return 'Dosis terlalu besar';
    return null;
  }

  static String? notes(String? value) {
    if ((value ?? '').trim().length > 120) {
      return 'Catatan maksimal 120 karakter';
    }
    return null;
  }

  static String? times(List<String> times) =>
      times.isEmpty ? 'Pilih minimal satu jam pengingat' : null;

  static String? weekdays(Frequency frequency, List<int> days) {
    if (frequency == Frequency.weekly && days.isEmpty) {
      return 'Pilih minimal satu hari';
    }
    return null;
  }

  static String? dateRange(
      Frequency frequency, DateTime start, DateTime? end) {
    if (frequency == Frequency.once || end == null) return null;
    if (DateTimeUtils.dateOnly(end).isBefore(DateTimeUtils.dateOnly(start))) {
      return 'Tanggal selesai tidak boleh sebelum tanggal mulai';
    }
    return null;
  }

  /// Untuk frekuensi "sekali": minimal satu jam harus masih di masa depan.
  static String? onceNotInPast(
      Frequency frequency, DateTime start, List<String> times, DateTime now) {
    if (frequency != Frequency.once || times.isEmpty) return null;
    final hasFuture =
        times.any((t) => DateTimeUtils.combine(start, t).isAfter(now));
    return hasFuture ? null : 'Waktu pengingat sudah lewat';
  }
}
