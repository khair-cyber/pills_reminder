import 'package:pills_reminder/domain/entities/medicine.dart';
import 'package:pills_reminder/domain/repositories/medicine_repository.dart';
import 'package:pills_reminder/domain/services/reminder_scheduler.dart';

/// Mengambil seluruh obat, terbaru di atas.
class GetMedicinesUseCase {
  GetMedicinesUseCase(this._repository);
  final MedicineRepository _repository;

  Future<List<Medicine>> call() async {
    final list = await _repository.getAll();
    list.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return list;
  }
}

/// Menyimpan obat baru lalu menjadwalkan notifikasinya.
class AddMedicineUseCase {
  AddMedicineUseCase(this._repository, this._scheduler);
  final MedicineRepository _repository;
  final ReminderScheduler _scheduler;

  Future<Medicine> call(Medicine medicine) async {
    final saved = await _repository.add(medicine);
    await _scheduler.schedule(saved);
    return saved;
  }
}

/// Memperbarui obat lalu menjadwalkan ulang notifikasinya.
class UpdateMedicineUseCase {
  UpdateMedicineUseCase(this._repository, this._scheduler);
  final MedicineRepository _repository;
  final ReminderScheduler _scheduler;

  Future<void> call(Medicine medicine) async {
    await _repository.update(medicine);
    await _scheduler.cancel(medicine.id);
    await _scheduler.schedule(medicine);
  }
}

/// Menghapus obat beserta seluruh jadwal notifikasinya.
class DeleteMedicineUseCase {
  DeleteMedicineUseCase(this._repository, this._scheduler);
  final MedicineRepository _repository;
  final ReminderScheduler _scheduler;

  Future<void> call(int id) async {
    await _scheduler.cancel(id);
    await _repository.delete(id);
  }
}
