import 'dart:async';

import 'package:get/get.dart';
import 'package:pills_reminder/domain/entities/scheduled_dose.dart';
import 'package:pills_reminder/domain/usecases/dose_usecases.dart';
import 'package:pills_reminder/presentation/controllers/app_controller.dart';

/// Mengelola jadwal obat hari ini dan penandaan "sudah diminum".
class TodayController extends GetxController {
  TodayController(
      this._getDoses, this._markTaken, this._undoTaken, this._app);

  final GetDosesForDayUseCase _getDoses;
  final MarkDoseTakenUseCase _markTaken;
  final UndoDoseTakenUseCase _undoTaken;
  final AppController _app;

  final RxList<ScheduledDose> doses = <ScheduledDose>[].obs;
  final RxBool isLoading = true.obs;

  /// Diperbarui tiap menit agar status "terlewat" ikut berubah.
  final Rx<DateTime> now = DateTime.now().obs;
  Timer? _timer;

  int get total => doses.length;
  int get takenCount => doses.where((d) => d.isTaken).length;

  @override
  void onInit() {
    super.onInit();
    ever(_app.dataVersion, (_) => load());
    _timer = Timer.periodic(const Duration(minutes: 1), (_) {
      now.value = DateTime.now();
    });
    load();
  }

  @override
  void onClose() {
    _timer?.cancel();
    super.onClose();
  }

  Future<void> load() async {
    try {
      now.value = DateTime.now();
      doses.assignAll(await _getDoses(DateTime.now()));
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> markTaken(ScheduledDose dose) async {
    await _markTaken(dose);
    _app.notifyDataChanged();
  }

  Future<void> undoTaken(ScheduledDose dose) async {
    await _undoTaken(dose);
    _app.notifyDataChanged();
  }
}
