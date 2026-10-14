import 'package:get/get.dart';
import 'package:pills_reminder/domain/entities/medicine.dart';
import 'package:pills_reminder/domain/usecases/medicine_usecases.dart';
import 'package:pills_reminder/presentation/controllers/app_controller.dart';

/// Mengelola daftar obat (baca dan hapus). Tambah/ubah ada di form controller.
class MedicineController extends GetxController {
  MedicineController(this._getMedicines, this._deleteMedicine, this._app);

  final GetMedicinesUseCase _getMedicines;
  final DeleteMedicineUseCase _deleteMedicine;
  final AppController _app;

  final RxList<Medicine> medicines = <Medicine>[].obs;
  final RxBool isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    ever(_app.dataVersion, (_) => load());
    load();
  }

  Future<void> load() async {
    try {
      medicines.assignAll(await _getMedicines());
    } finally {
      isLoading.value = false;
    }
  }

  Medicine? findById(int id) {
    for (final m in medicines) {
      if (m.id == id) return m;
    }
    return null;
  }

  Future<void> delete(Medicine medicine) async {
    await _deleteMedicine(medicine.id);
    _app.notifyDataChanged();
    Get.snackbar('Obat dihapus', '${medicine.name} dan pengingatnya dihapus.',
        snackPosition: SnackPosition.BOTTOM);
  }
}
