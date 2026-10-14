import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pills_reminder/core/theme/app_theme.dart';
import 'package:pills_reminder/core/utils/date_time_utils.dart';
import 'package:pills_reminder/presentation/controllers/history_controller.dart';
import 'package:pills_reminder/presentation/widgets/empty_state.dart';

/// Riwayat konsumsi obat dan ringkasan kepatuhan 7 hari.
class HistoryPage extends GetView<HistoryController> {
  const HistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(title: const Text('Riwayat')),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }
        final summary = controller.adherence.value;
        final groups = controller.grouped;

        return ListView(
          padding: const EdgeInsets.only(bottom: 24),
          children: [
            Container(
              margin: const EdgeInsets.fromLTRB(16, 4, 16, 12),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: AppColors.border),
              ),
              child: Row(
                children: [
                  SizedBox(
                    width: 72,
                    height: 72,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        SizedBox(
                          width: 72,
                          height: 72,
                          child: CircularProgressIndicator(
                            value: summary.ratio,
                            strokeWidth: 8,
                            backgroundColor: AppColors.neutralBg,
                          ),
                        ),
                        Text('${summary.percent}%',
                            style: theme.textTheme.titleMedium
                                ?.copyWith(fontWeight: FontWeight.w800)),
                      ],
                    ),
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Kepatuhan 7 hari terakhir',
                            style: theme.textTheme.titleMedium
                                ?.copyWith(fontWeight: FontWeight.w700)),
                        const SizedBox(height: 4),
                        Text(
                          summary.scheduled == 0
                              ? 'Belum ada dosis yang jatuh tempo.'
                              : '${summary.taken} dari ${summary.scheduled} dosis diminum',
                          style: theme.textTheme.bodyLarge,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            if (groups.isEmpty)
              const SizedBox(
                height: 320,
                child: EmptyState(
                  icon: Icons.history,
                  title: 'Belum ada riwayat',
                  message:
                      'Riwayat muncul setelah Anda menandai obat sebagai sudah diminum.',
                ),
              )
            else
              for (final entry in groups.entries) ...[
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 12, 20, 6),
                  child: Text(
                    DateTimeUtils.formatFullDate(entry.key),
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: AppColors.neutralFg,
                    ),
                  ),
                ),
                for (final log in entry.value)
                  Card(
                    elevation: 0,
                    color: Colors.white,
                    margin:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                      side: const BorderSide(color: AppColors.border),
                    ),
                    child: ListTile(
                      leading: const Icon(Icons.check_circle,
                          color: AppColors.takenFg, size: 32),
                      title: Text(log.medicineName,
                          style: const TextStyle(fontWeight: FontWeight.w700)),
                      subtitle: Text(
                        '${log.doseLabel} - jadwal ${DateTimeUtils.formatTime(log.scheduledAt)}',
                      ),
                      trailing: Text(
                        DateTimeUtils.formatTime(log.takenAt),
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w700,
                          color: theme.colorScheme.primary,
                        ),
                      ),
                    ),
                  ),
              ],
          ],
        );
      }),
    );
  }
}
