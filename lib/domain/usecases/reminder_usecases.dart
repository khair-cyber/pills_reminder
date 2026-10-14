import 'package:pills_reminder/domain/repositories/medicine_repository.dart';
import 'package:pills_reminder/domain/services/reminder_scheduler.dart';

/// Menyelaraskan seluruh notifikasi dengan data obat (dipanggil saat
/// aplikasi dibuka, misalnya setelah perangkat dinyalakan ulang).
class SyncRemindersUseCase {
  SyncRemindersUseCase(this._medicines, this._scheduler);
  final MedicineRepository _medicines;
  final ReminderScheduler _scheduler;

  Future<void> call() async {
    final list = await _medicines.getAll();
    await _scheduler.syncAll(list);
  }
}
