import 'package:flutter/material.dart';
import 'package:pills_reminder/core/theme/app_theme.dart';
import 'package:pills_reminder/core/utils/date_time_utils.dart';
import 'package:pills_reminder/domain/entities/scheduled_dose.dart';
import 'package:pills_reminder/presentation/widgets/status_badge.dart';

/// Satu baris dosis pada halaman "Hari Ini".
class DoseTile extends StatelessWidget {
  const DoseTile({
    super.key,
    required this.dose,
    required this.now,
    required this.onTake,
    required this.onUndo,
    this.onTap,
  });

  final ScheduledDose dose;
  final DateTime now;
  final VoidCallback onTake;
  final VoidCallback onUndo;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final status = dose.statusAt(now);

    late final Color fg;
    late final Color bg;
    late final String label;
    late final IconData icon;
    switch (status) {
      case DoseStatus.taken:
        fg = AppColors.takenFg;
        bg = AppColors.takenBg;
        label = 'Sudah diminum';
        icon = Icons.check_circle;
        break;
      case DoseStatus.missed:
        fg = AppColors.missedFg;
        bg = AppColors.missedBg;
        label = 'Terlewat';
        icon = Icons.error_outline;
        break;
      case DoseStatus.upcoming:
        fg = AppColors.upcomingFg;
        bg = AppColors.upcomingBg;
        label = 'Belum waktunya';
        icon = Icons.schedule;
        break;
    }

    return Card(
      elevation: 0,
      color: Colors.white,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: const BorderSide(color: AppColors.border),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Text(
                DateTimeUtils.formatTime(dose.scheduledAt),
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w800,
                  color: theme.colorScheme.primary,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      dose.medicine.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.titleMedium
                          ?.copyWith(fontWeight: FontWeight.w700),
                    ),
                    const SizedBox(height: 2),
                    Text(dose.medicine.doseLabel,
                        style: theme.textTheme.bodyMedium),
                    const SizedBox(height: 8),
                    StatusBadge(
                        label: label, foreground: fg, background: bg, icon: icon),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              if (dose.isTaken)
                IconButton(
                  tooltip: 'Batalkan tanda sudah diminum',
                  iconSize: 32,
                  onPressed: onUndo,
                  icon: const Icon(Icons.undo, color: AppColors.neutralFg),
                )
              else
                FilledButton(onPressed: onTake, child: const Text('Minum')),
            ],
          ),
        ),
      ),
    );
  }
}
