import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pills_reminder/app/routes/app_routes.dart';
import 'package:pills_reminder/core/theme/app_theme.dart';
import 'package:pills_reminder/core/utils/date_time_utils.dart';
import 'package:pills_reminder/presentation/controllers/app_controller.dart';
import 'package:pills_reminder/presentation/controllers/today_controller.dart';
import 'package:pills_reminder/presentation/widgets/dose_tile.dart';
import 'package:pills_reminder/presentation/widgets/empty_state.dart';

/// Halaman utama: jadwal obat hari ini.
class TodayPage extends GetView<TodayController> {
  const TodayPage({super.key});

  @override
  Widget build(BuildContext context) {
    final app = Get.find<AppController>();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Hari Ini'),
        actions: [
          PopupMenuButton<String>(
            tooltip: 'Menu',
            onSelected: (v) {
              if (v == 'test') app.sendTestNotification();
              if (v == 'permission') app.requestPermission();
            },
            itemBuilder: (_) => const [
              PopupMenuItem(value: 'test', child: Text('Tes notifikasi')),
              PopupMenuItem(
                  value: 'permission', child: Text('Izinkan notifikasi')),
            ],
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Get.toNamed(Routes.form),
        icon: const Icon(Icons.add),
        label: const Text('Tambah Obat'),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }
        final now = controller.now.value;
        final doses = controller.doses;

        return RefreshIndicator(
          onRefresh: controller.load,
          child: ListView(
            padding: const EdgeInsets.only(bottom: 96),
            children: [
              _SummaryCard(
                date: now,
                taken: controller.takenCount,
                total: controller.total,
              ),
              if (doses.isEmpty)
                SizedBox(
                  height: 360,
                  child: EmptyState(
                    icon: Icons.event_available,
                    title: 'Tidak ada jadwal hari ini',
                    message:
                        'Tambahkan obat agar pengingat muncul pada jam yang Anda atur.',
                    actionLabel: 'Tambah Obat',
                    onAction: () => Get.toNamed(Routes.form),
                  ),
                )
              else
                for (final dose in doses)
                  DoseTile(
                    key: ValueKey(dose.key),
                    dose: dose,
                    now: now,
                    onTake: () => controller.markTaken(dose),
                    onUndo: () => controller.undoTaken(dose),
                    onTap: () => Get.toNamed(Routes.detail,
                        arguments: dose.medicine.id),
                  ),
            ],
          ),
        );
      }),
    );
  }
}

class _SummaryCard extends StatelessWidget {
  const _SummaryCard({
    required this.date,
    required this.taken,
    required this.total,
  });

  final DateTime date;
  final int taken;
  final int total;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final progress = total == 0 ? 0.0 : taken / total;
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 4, 16, 12),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: theme.colorScheme.primary,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            DateTimeUtils.formatFullDate(date),
            style: const TextStyle(color: Colors.white, fontSize: 16),
          ),
          const SizedBox(height: 8),
          Text(
            total == 0
                ? 'Belum ada dosis hari ini'
                : '$taken dari $total dosis sudah diminum',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 14),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 10,
              backgroundColor: AppColors.upcomingFg,
              valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}
