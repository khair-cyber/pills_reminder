import 'package:pills_reminder/domain/entities/intake_log.dart';

/// Serialisasi entitas IntakeLog <-> Map (disimpan di Hive).
class IntakeLogModel {
  IntakeLogModel._();

  static Map<String, dynamic> toMap(IntakeLog l) => {
        'key': l.key,
        'medicineId': l.medicineId,
        'medicineName': l.medicineName,
        'doseLabel': l.doseLabel,
        'scheduledAt': l.scheduledAt.toIso8601String(),
        'takenAt': l.takenAt.toIso8601String(),
      };

  static IntakeLog fromMap(Map<String, dynamic> map) {
    return IntakeLog(
      key: map['key'] as String,
      medicineId: map['medicineId'] as int,
      medicineName: map['medicineName'] as String,
      doseLabel: map['doseLabel'] as String,
      scheduledAt: DateTime.parse(map['scheduledAt'] as String),
      takenAt: DateTime.parse(map['takenAt'] as String),
    );
  }
}
