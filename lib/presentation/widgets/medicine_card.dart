import 'package:flutter/material.dart';
import 'package:pills_reminder/core/theme/app_theme.dart';
import 'package:pills_reminder/domain/entities/medicine.dart';
import 'package:pills_reminder/presentation/widgets/status_badge.dart';

enum MedicineMenuAction { edit, delete }

/// Kartu obat pada halaman "Daftar Obat".
class MedicineCard extends StatelessWidget {
  const MedicineCard({
    super.key,
    required this.medicine,
    required this.onTap,
    required this.onMenu,
  });

  final Medicine medicine;
  final VoidCallback onTap;
  final void Function(MedicineMenuAction action) onMenu;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final status = medicine.statusOn(DateTime.now());

    late final Color fg;
    late final Color bg;
    switch (status) {
      case MedicineStatus.active:
        fg = AppColors.takenFg;
        bg = AppColors.takenBg;
        break;
      case MedicineStatus.upcoming:
        fg = AppColors.upcomingFg;
        bg = AppColors.upcomingBg;
        break;
      case MedicineStatus.finished:
        fg = AppColors.neutralFg;
        bg = AppColors.neutralBg;
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
          padding: const EdgeInsets.fromLTRB(16, 16, 4, 16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                radius: 24,
                backgroundColor: AppColors.upcomingBg,
                child: Icon(Icons.medication,
                    color: theme.colorScheme.primary, size: 28),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      medicine.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.titleMedium
                          ?.copyWith(fontWeight: FontWeight.w700),
                    ),
                    const SizedBox(height: 2),
                    Text('${medicine.doseLabel} - ${medicine.frequencyDescription}',
                        style: theme.textTheme.bodyMedium),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 6,
                      runSpacing: 6,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        StatusBadge(
                            label: status.label, foreground: fg, background: bg),
                        for (final t in medicine.times)
                          StatusBadge(
                            label: t,
                            foreground: AppColors.neutralFg,
                            background: AppColors.neutralBg,
                            icon: Icons.alarm,
                          ),
                      ],
                    ),
                  ],
                ),
              ),
              PopupMenuButton<MedicineMenuAction>(
                tooltip: 'Menu',
                onSelected: onMenu,
                itemBuilder: (_) => const [
                  PopupMenuItem(
                    value: MedicineMenuAction.edit,
                    child: Text('Ubah'),
                  ),
                  PopupMenuItem(
                    value: MedicineMenuAction.delete,
                    child: Text('Hapus'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
