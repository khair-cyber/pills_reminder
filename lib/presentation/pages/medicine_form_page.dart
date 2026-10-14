import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pills_reminder/core/constants/app_constants.dart';
import 'package:pills_reminder/core/theme/app_theme.dart';
import 'package:pills_reminder/core/utils/date_time_utils.dart';
import 'package:pills_reminder/domain/validators/medicine_validator.dart';
import 'package:pills_reminder/domain/entities/medicine.dart';
import 'package:pills_reminder/presentation/controllers/medicine_form_controller.dart';

/// Formulir tambah / ubah obat.
class MedicineFormPage extends GetView<MedicineFormController> {
  const MedicineFormPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(controller.isEdit ? 'Ubah Obat' : 'Tambah Obat'),
      ),
      body: SafeArea(
        child: Form(
          key: controller.formKey,
          child: ListView(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
            children: [
              const _Label('Nama obat'),
              TextFormField(
                controller: controller.nameC,
                textCapitalization: TextCapitalization.words,
                textInputAction: TextInputAction.next,
                decoration: const InputDecoration(hintText: 'Contoh: Amlodipine'),
                validator: MedicineValidator.name,
              ),
              const SizedBox(height: 20),

              const _Label('Dosis sekali minum'),
              TextFormField(
                controller: controller.doseC,
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                textInputAction: TextInputAction.done,
                decoration: const InputDecoration(hintText: 'Contoh: 1 atau 0,5'),
                validator: MedicineValidator.dose,
              ),
              const SizedBox(height: 10),
              Obx(
                () => Wrap(
                  spacing: 8,
                  runSpacing: 4,
                  children: [
                    for (final u in AppConstants.doseUnits)
                      ChoiceChip(
                        label: Text(u),
                        selected: controller.unit.value == u,
                        onSelected: (_) => controller.unit.value = u,
                      ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              const _Label('Frekuensi'),
              Obx(
                () => SegmentedButton<Frequency>(
                  showSelectedIcon: false,
                  segments: const [
                    ButtonSegment(
                        value: Frequency.once, label: Text('Sekali')),
                    ButtonSegment(
                        value: Frequency.daily, label: Text('Harian')),
                    ButtonSegment(
                        value: Frequency.weekly, label: Text('Mingguan')),
                  ],
                  selected: {controller.frequency.value},
                  onSelectionChanged: (s) => controller.setFrequency(s.first),
                ),
              ),
              Obx(() {
                if (controller.frequency.value != Frequency.weekly) {
                  return const SizedBox.shrink();
                }
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 14),
                    const _Label('Hari konsumsi'),
                    Wrap(
                      spacing: 8,
                      runSpacing: 4,
                      children: [
                        for (var d = 1; d <= 7; d++)
                          FilterChip(
                            label: Text(DateTimeUtils.dayShort(d)),
                            selected: controller.weekdays.contains(d),
                            onSelected: (_) => controller.toggleWeekday(d),
                          ),
                      ],
                    ),
                    _ErrorText(controller.weekdaysError.value),
                  ],
                );
              }),
              const SizedBox(height: 20),

              const _Label('Jam pengingat'),
              Obx(
                () => Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    for (final t in controller.times)
                      InputChip(
                        avatar: const Icon(Icons.alarm, size: 18),
                        label: Text(t,
                            style: const TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w700)),
                        onDeleted: () => controller.removeTime(t),
                      ),
                    ActionChip(
                      avatar: const Icon(Icons.add, size: 18),
                      label: const Text('Tambah jam'),
                      onPressed: () => controller.pickTime(context),
                    ),
                  ],
                ),
              ),
              Obx(() => _ErrorText(controller.timesError.value)),
              const SizedBox(height: 20),

              const _Label('Tanggal mulai'),
              Obx(
                () => _DateField(
                  icon: Icons.event,
                  text: DateTimeUtils.formatFullDate(controller.startDate.value),
                  onTap: () => controller.pickStartDate(context),
                ),
              ),
              Obx(() {
                if (controller.frequency.value == Frequency.once) {
                  return const SizedBox.shrink();
                }
                final end = controller.endDate.value;
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 20),
                    const _Label('Tanggal selesai (opsional)'),
                    _DateField(
                      icon: Icons.event_busy,
                      text: end == null
                          ? 'Tanpa batas waktu'
                          : DateTimeUtils.formatFullDate(end),
                      onTap: () => controller.pickEndDate(context),
                      onClear: end == null ? null : controller.clearEndDate,
                    ),
                  ],
                );
              }),
              Obx(() => _ErrorText(controller.dateError.value)),
              const SizedBox(height: 20),

              const _Label('Catatan (opsional)'),
              TextFormField(
                controller: controller.notesC,
                maxLines: 2,
                maxLength: 120,
                decoration: const InputDecoration(
                    hintText: 'Contoh: diminum setelah makan'),
                validator: MedicineValidator.notes,
              ),
              const SizedBox(height: 12),

              Obx(
                () => FilledButton.icon(
                  style: FilledButton.styleFrom(
                      minimumSize: const Size.fromHeight(56)),
                  onPressed:
                      controller.isSaving.value ? null : controller.save,
                  icon: controller.isSaving.value
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Icon(Icons.save),
                  label: Text(
                    controller.isEdit ? 'Simpan Perubahan' : 'Simpan Obat',
                    style: theme.textTheme.titleMedium?.copyWith(
                        color: Colors.white, fontWeight: FontWeight.w700),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Label extends StatelessWidget {
  const _Label(this.text);
  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        text,
        style: Theme.of(context)
            .textTheme
            .titleSmall
            ?.copyWith(fontWeight: FontWeight.w700),
      ),
    );
  }
}

class _ErrorText extends StatelessWidget {
  const _ErrorText(this.message);
  final String? message;

  @override
  Widget build(BuildContext context) {
    if (message == null) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.only(top: 6, left: 4),
      child: Text(
        message!,
        style: TextStyle(
            color: Theme.of(context).colorScheme.error, fontSize: 13),
      ),
    );
  }
}

class _DateField extends StatelessWidget {
  const _DateField({
    required this.icon,
    required this.text,
    required this.onTap,
    this.onClear,
  });

  final IconData icon;
  final String text;
  final VoidCallback onTap;
  final VoidCallback? onClear;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.border),
        ),
        child: Row(
          children: [
            Icon(icon, color: Theme.of(context).colorScheme.primary),
            const SizedBox(width: 12),
            Expanded(
                child: Text(text, style: const TextStyle(fontSize: 16))),
            if (onClear != null)
              IconButton(
                tooltip: 'Hapus tanggal',
                onPressed: onClear,
                icon: const Icon(Icons.close),
              ),
          ],
        ),
      ),
    );
  }
}
