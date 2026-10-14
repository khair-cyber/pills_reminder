import 'package:pills_reminder/core/utils/date_time_utils.dart';
import 'package:pills_reminder/domain/entities/adherence_summary.dart';
import 'package:pills_reminder/domain/entities/intake_log.dart';
import 'package:pills_reminder/domain/entities/scheduled_dose.dart';
import 'package:pills_reminder/domain/repositories/intake_log_repository.dart';
import 'package:pills_reminder/domain/repositories/medicine_repository.dart';
import 'package:pills_reminder/domain/services/dose_scheduler.dart';

/// Daftar dosis yang harus diminum pada suatu tanggal.
class GetDosesForDayUseCase {
  GetDosesForDayUseCase(this._medicines, this._logs);
  final MedicineRepository _medicines;
  final IntakeLogRepository _logs;

  Future<List<ScheduledDose>> call(DateTime day) async {
    final medicines = await _medicines.getAll();
    final logs = await _logs.getAll();
    final logMap = {for (final l in logs) l.key: l};

    final result = <ScheduledDose>[];
    for (final m in medicines) {
      for (final t in DoseScheduler.doseTimesOn(m, day)) {
        result.add(ScheduledDose(
          medicine: m,
          scheduledAt: t,
          log: logMap[IntakeLog.buildKey(m.id, t)],
        ));
      }
    }
    result.sort((a, b) {
      final c = a.scheduledAt.compareTo(b.scheduledAt);
      return c != 0 ? c : a.medicine.name.compareTo(b.medicine.name);
    });
    return result;
  }
}

/// Menandai sebuah dosis sebagai sudah diminum.
class MarkDoseTakenUseCase {
  MarkDoseTakenUseCase(this._logs);
  final IntakeLogRepository _logs;

  Future<void> call(ScheduledDose dose, {DateTime? now}) {
    return _logs.save(IntakeLog(
      key: dose.key,
      medicineId: dose.medicine.id,
      medicineName: dose.medicine.name,
      doseLabel: dose.medicine.doseLabel,
      scheduledAt: dose.scheduledAt,
      takenAt: now ?? DateTime.now(),
    ));
  }
}

/// Membatalkan tanda "sudah diminum" (jika salah menekan).
class UndoDoseTakenUseCase {
  UndoDoseTakenUseCase(this._logs);
  final IntakeLogRepository _logs;

  Future<void> call(ScheduledDose dose) => _logs.delete(dose.key);
}

/// Riwayat konsumsi, terbaru di atas.
class GetHistoryUseCase {
  GetHistoryUseCase(this._logs);
  final IntakeLogRepository _logs;

  Future<List<IntakeLog>> call() async {
    final list = await _logs.getAll();
    list.sort((a, b) => b.takenAt.compareTo(a.takenAt));
    return list;
  }
}

/// Menghitung kepatuhan: dosis yang sudah lewat waktunya vs yang diminum.
class GetAdherenceUseCase {
  GetAdherenceUseCase(this._medicines, this._logs);
  final MedicineRepository _medicines;
  final IntakeLogRepository _logs;

  Future<AdherenceSummary> call({int days = 7, DateTime? now}) async {
    final current = now ?? DateTime.now();
    final today = DateTimeUtils.dateOnly(current);
    final medicines = await _medicines.getAll();
    final logKeys = (await _logs.getAll()).map((l) => l.key).toSet();

    var scheduled = 0;
    var taken = 0;
    for (var i = 0; i < days; i++) {
      final day = DateTime(today.year, today.month, today.day - i);
      for (final m in medicines) {
        for (final t in DoseScheduler.doseTimesOn(m, day)) {
          // Hanya dosis yang sudah lewat dan setelah obat didaftarkan.
          if (t.isAfter(current) || t.isBefore(m.createdAt)) continue;
          scheduled++;
          if (logKeys.contains(IntakeLog.buildKey(m.id, t))) taken++;
        }
      }
    }
    return AdherenceSummary(scheduled: scheduled, taken: taken);
  }
}
