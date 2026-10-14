import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pills_reminder/app/routes/app_routes.dart';
import 'package:pills_reminder/domain/entities/medicine.dart';
import 'package:pills_reminder/presentation/controllers/medicine_controller.dart';
import 'package:pills_reminder/presentation/widgets/confirm_dialog.dart';
import 'package:pills_reminder/presentation/widgets/empty_state.dart';
import 'package:pills_reminder/presentation/widgets/medicine_card.dart';

/// Daftar seluruh obat yang tersimpan.
class MedicineListPage extends GetView<MedicineController> {
  const MedicineListPage({super.key});

  Future<void> _confirmDelete(Medicine m) async {
    final ok = await showConfirmDialog(
      title: 'Hapus obat?',
      message:
          'Data "${m.name}" dan seluruh pengingatnya akan dihapus. Riwayat minum tetap tersimpan.',
      confirmText: 'Hapus',
      destructive: true,
    );
    if (ok) await controller.delete(m);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Daftar Obat')),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Get.toNamed(Routes.form),
        icon: const Icon(Icons.add),
        label: const Text('Tambah Obat'),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }
        final list = controller.medicines;
        if (list.isEmpty) {
          return EmptyState(
            icon: Icons.medication_outlined,
            title: 'Belum ada obat',
            message: 'Tekan tombol di bawah untuk menambahkan obat pertama Anda.',
            actionLabel: 'Tambah Obat',
            onAction: () => Get.toNamed(Routes.form),
          );
        }
        return ListView.builder(
          padding: const EdgeInsets.only(bottom: 96, top: 4),
          itemCount: list.length,
          itemBuilder: (_, i) {
            final m = list[i];
            return MedicineCard(
              medicine: m,
              onTap: () => Get.toNamed(Routes.detail, arguments: m.id),
              onMenu: (action) {
                switch (action) {
                  case MedicineMenuAction.edit:
                    Get.toNamed(Routes.form, arguments: m);
                    break;
                  case MedicineMenuAction.delete:
                    _confirmDelete(m);
                    break;
                }
              },
            );
          },
        );
      }),
    );
  }
}
