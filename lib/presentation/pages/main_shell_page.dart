import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pills_reminder/presentation/controllers/app_controller.dart';
import 'package:pills_reminder/presentation/pages/history_page.dart';
import 'package:pills_reminder/presentation/pages/medicine_list_page.dart';
import 'package:pills_reminder/presentation/pages/today_page.dart';

/// Kerangka utama dengan navigasi bawah (Hari Ini, Obat, Riwayat).
class MainShellPage extends GetView<AppController> {
  const MainShellPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
        body: IndexedStack(
          index: controller.currentTab.value,
          children: const [
            TodayPage(),
            MedicineListPage(),
            HistoryPage(),
          ],
        ),
        bottomNavigationBar: NavigationBar(
          selectedIndex: controller.currentTab.value,
          onDestinationSelected: controller.changeTab,
          destinations: const [
            NavigationDestination(
              icon: Icon(Icons.today_outlined),
              selectedIcon: Icon(Icons.today),
              label: 'Hari Ini',
            ),
            NavigationDestination(
              icon: Icon(Icons.medication_outlined),
              selectedIcon: Icon(Icons.medication),
              label: 'Obat',
            ),
            NavigationDestination(
              icon: Icon(Icons.history),
              selectedIcon: Icon(Icons.history_toggle_off),
              label: 'Riwayat',
            ),
          ],
        ),
      ),
    );
  }
}
