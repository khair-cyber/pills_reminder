import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pills_reminder/app/routes/app_routes.dart';
import 'package:pills_reminder/core/theme/app_theme.dart';
import 'package:pills_reminder/core/utils/date_time_utils.dart';
import 'package:pills_reminder/domain/entities/medicine.dart';
import 'package:pills_reminder/domain/services/dose_scheduler.dart';
import 'package:pills_reminder/presentation/controllers/medicine_controller.dart';
import 'package:pills_reminder/presentation/widgets/confirm_dialog.dart';
import 'package:pills_reminder/presentation/widgets/status_badge.dart';

/// Detail satu obat. ID obat diteruskan dari rute (lihat app_pages.dart).
class MedicineDetailPage extends GetView<MedicineController> {
  const MedicineDetailPage({super.key, required this.medicineId});

  final int medicineId;

  Future<void> _delete(Medicine m) async {
    final ok = await showConfirmDialog(
      title: 'Hapus obat?',
      message:
          'Data "${m.name}" dan seluruh pengingatnya akan dihapus. Riwayat minum tetap tersimpan.',
      confirmText: 'Hapus',
      destructive: true,
    );
    if (!ok) return;
    await controller.delete(m);
    Get.back();
  }

  @override
  Widget build(BuildContext context) {
    final id = medicineId;
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Detail Obat')),
      body: Obx(() {
        final m = controller.findById(id);
        if (m == null) {
          return const Center(child: Text('Data obat tidak ditemukan.'));
        }
        final status = m.statusOn(DateTime.now());
        final next = DoseScheduler.nextDose(m, DateTime.now());

        return ListView(
          padding: const EdgeInsets.fromLTRB(16, 4, 16, 32),
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: theme.colorScheme.primary,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    m.name,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 26,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${m.doseLabel} - ${m.frequencyDescription}',
                    style: const TextStyle(color: Colors.white, fontSize: 16),
                  ),
                  const SizedBox(height: 12),
                  StatusBadge(
                    label: status.label,
                    foreground: AppColors.upcomingFg,
                    background: Colors.white,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            _InfoRow(
              icon: Icons.alarm,
              label: 'Jam pengingat',
              value: m.times.join('  -  '),
            ),
            _InfoRow(
              icon: Icons.notifications_active,
              label: 'Pengingat berikutnya',
              value: next == null
                  ? 'Tidak ada jadwal berikutnya'
                  : '${DateTimeUtils.formatFullDate(next)}, ${DateTimeUtils.formatTime(next)}',
            ),
            _InfoRow(
              icon: Icons.event,
              label: 'Mulai',
              value: DateTimeUtils.formatFullDate(m.startDate),
            ),
            if (m.frequency != Frequency.once)
              _InfoRow(
                icon: Icons.event_busy,
                label: 'Selesai',
                value: m.endDate == null
                    ? 'Tanpa batas waktu'
                    : DateTimeUtils.formatFullDate(m.endDate!),
              ),
            if (m.notes != null)
              _InfoRow(icon: Icons.notes, label: 'Catatan', value: m.notes!),
            const SizedBox(height: 24),
            FilledButton.icon(
              style: FilledButton.styleFrom(
                  minimumSize: const Size.fromHeight(52)),
              onPressed: () => Get.toNamed(Routes.form, arguments: m),
              icon: const Icon(Icons.edit),
              label: const Text('Ubah Obat'),
            ),
            const SizedBox(height: 12),
            OutlinedButton.icon(
              style: OutlinedButton.styleFrom(
                minimumSize: const Size.fromHeight(52),
                foregroundColor: AppColors.missedFg,
                side: const BorderSide(color: AppColors.missedFg),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
              ),
              onPressed: () => _delete(m),
              icon: const Icon(Icons.delete_outline),
              label: const Text('Hapus Obat'),
            ),
          ],
        );
      }),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: theme.colorScheme.primary),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label,
                    style: theme.textTheme.bodySmall
                        ?.copyWith(color: AppColors.neutralFg)),
                const SizedBox(height: 2),
                Text(value,
                    style: theme.textTheme.bodyLarge
                        ?.copyWith(fontWeight: FontWeight.w600)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
