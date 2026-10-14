import 'package:pills_reminder/domain/entities/intake_log.dart';
import 'package:pills_reminder/domain/entities/medicine.dart';

enum DoseStatus { taken, upcoming, missed }

/// Satu kejadian dosis terjadwal (obat + waktu) beserta catatan
/// konsumsinya jika sudah diminum.
class ScheduledDose {
  const ScheduledDose({
    required this.medicine,
    required this.scheduledAt,
    this.log,
  });

  final Medicine medicine;
  final DateTime scheduledAt;
  final IntakeLog? log;

  bool get isTaken => log != null;

  String get key => IntakeLog.buildKey(medicine.id, scheduledAt);

  DoseStatus statusAt(DateTime now) {
    if (isTaken) return DoseStatus.taken;
    return scheduledAt.isBefore(now) ? DoseStatus.missed : DoseStatus.upcoming;
  }
}
