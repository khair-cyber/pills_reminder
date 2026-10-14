import 'package:get/get.dart';
import 'package:pills_reminder/app/routes/app_routes.dart';
import 'package:pills_reminder/domain/services/reminder_scheduler.dart';
import 'package:pills_reminder/domain/usecases/reminder_usecases.dart';

/// Controller global: tab aktif, penanda perubahan data, dan izin notifikasi.
class AppController extends GetxController {
  AppController(this._scheduler, this._syncReminders);

  final ReminderScheduler _scheduler;
  final SyncRemindersUseCase _syncReminders;

  final RxInt currentTab = 0.obs;

  /// Dinaikkan setiap data berubah; controller lain memantau nilai ini.
  final RxInt dataVersion = 0.obs;

  void changeTab(int index) => currentTab.value = index;

  void notifyDataChanged() => dataVersion.value++;

  @override
  void onReady() {
    super.onReady();
    _scheduler.setTapHandler((medicineId) {
      Get.toNamed(Routes.detail, arguments: medicineId);
    });
    _bootstrapReminders();
  }

  Future<void> _bootstrapReminders() async {
    try {
      await _scheduler.requestPermission();
      await _syncReminders();
    } catch (_) {
      // Kegagalan penjadwalan tidak boleh menghentikan aplikasi.
    }
  }

  Future<void> requestPermission() async {
    final granted = await _scheduler.requestPermission();
    Get.snackbar(
      granted ? 'Izin diberikan' : 'Izin ditolak',
      granted
          ? 'Notifikasi pengingat dapat ditampilkan.'
          : 'Aktifkan izin notifikasi di pengaturan perangkat.',
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  Future<void> sendTestNotification() async {
    try {
      await _scheduler.showTest();
      Get.snackbar(
        'Tes notifikasi',
        'Notifikasi akan muncul dalam 5 detik.',
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      Get.snackbar('Gagal', 'Notifikasi uji tidak dapat dijadwalkan.',
          snackPosition: SnackPosition.BOTTOM);
    }
  }
}
