import 'package:get/get.dart';
import 'package:pills_reminder/core/utils/date_time_utils.dart';
import 'package:pills_reminder/domain/entities/adherence_summary.dart';
import 'package:pills_reminder/domain/entities/intake_log.dart';
import 'package:pills_reminder/domain/usecases/dose_usecases.dart';
import 'package:pills_reminder/presentation/controllers/app_controller.dart';

/// Riwayat konsumsi + ringkasan kepatuhan 7 hari terakhir.
class HistoryController extends GetxController {
  HistoryController(this._getHistory, this._getAdherence, this._app);

  final GetHistoryUseCase _getHistory;
  final GetAdherenceUseCase _getAdherence;
  final AppController _app;

  final RxList<IntakeLog> logs = <IntakeLog>[].obs;
  final Rx<AdherenceSummary> adherence =
      const AdherenceSummary(scheduled: 0, taken: 0).obs;
  final RxBool isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    ever(_app.dataVersion, (_) => load());
    load();
  }

  Future<void> load() async {
    try {
      logs.assignAll(await _getHistory());
      adherence.value = await _getAdherence(days: 7);
    } finally {
      isLoading.value = false;
    }
  }

  /// Riwayat dikelompokkan per tanggal (terbaru di atas).
  Map<DateTime, List<IntakeLog>> get grouped {
    final map = <DateTime, List<IntakeLog>>{};
    for (final l in logs) {
      final day = DateTimeUtils.dateOnly(l.takenAt);
      map.putIfAbsent(day, () => []).add(l);
    }
    return map;
  }
}
