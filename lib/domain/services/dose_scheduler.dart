import 'package:pills_reminder/core/utils/date_time_utils.dart';
import 'package:pills_reminder/domain/entities/medicine.dart';

/// Logika murni (tanpa dependensi framework) untuk menentukan kapan
/// sebuah obat harus diminum.
class DoseScheduler {
  DoseScheduler._();

  /// Apakah obat [m] harus diminum pada tanggal [day].
  static bool occursOn(Medicine m, DateTime day) {
    final d = DateTimeUtils.dateOnly(day);
    final start = DateTimeUtils.dateOnly(m.startDate);
    if (m.frequency == Frequency.once) return d == start;
    if (d.isBefore(start)) return false;
    if (m.endDate != null && d.isAfter(DateTimeUtils.dateOnly(m.endDate!))) {
      return false;
    }
    if (m.frequency == Frequency.weekly) return m.weekdays.contains(d.weekday);
    return true; // daily
  }

  /// Seluruh waktu minum obat [m] pada tanggal [day], terurut naik.
  static List<DateTime> doseTimesOn(Medicine m, DateTime day) {
    if (!occursOn(m, day)) return const [];
    final d = DateTimeUtils.dateOnly(day);
    final list = m.times.map((t) => DateTimeUtils.combine(d, t)).toList()
      ..sort();
    return list;
  }

  /// Waktu minum berikutnya setelah [now] (mencari maksimal 1 tahun ke depan).
  static DateTime? nextDose(Medicine m, DateTime now) {
    final today = DateTimeUtils.dateOnly(now);
    for (var i = 0; i <= 366; i++) {
      final day = DateTime(today.year, today.month, today.day + i);
      for (final t in doseTimesOn(m, day)) {
        if (t.isAfter(now)) return t;
      }
    }
    return null;
  }
}
