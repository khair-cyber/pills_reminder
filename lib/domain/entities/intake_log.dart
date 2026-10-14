import 'package:pills_reminder/core/utils/date_time_utils.dart';

/// Catatan bahwa sebuah dosis sudah diminum.
class IntakeLog {
  const IntakeLog({
    required this.key,
    required this.medicineId,
    required this.medicineName,
    required this.doseLabel,
    required this.scheduledAt,
    required this.takenAt,
  });

  /// Kunci unik: idObat_yyyyMMdd_HHmm (satu dosis = satu catatan).
  final String key;
  final int medicineId;
  final String medicineName;
  final String doseLabel;
  final DateTime scheduledAt;
  final DateTime takenAt;

  static String buildKey(int medicineId, DateTime scheduledAt) {
    final hm = DateTimeUtils.formatTime(scheduledAt).replaceAll(':', '');
    return '${medicineId}_${DateTimeUtils.dateKey(scheduledAt)}_$hm';
  }
}
