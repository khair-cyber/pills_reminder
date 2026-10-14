import 'package:get/get.dart';
import 'package:pills_reminder/app/routes/app_routes.dart';
import 'package:pills_reminder/domain/entities/medicine.dart';
import 'package:pills_reminder/domain/usecases/medicine_usecases.dart';
import 'package:pills_reminder/presentation/controllers/app_controller.dart';
import 'package:pills_reminder/presentation/controllers/medicine_form_controller.dart';
import 'package:pills_reminder/presentation/controllers/splash_controller.dart';
import 'package:pills_reminder/presentation/pages/main_shell_page.dart';
import 'package:pills_reminder/presentation/pages/medicine_detail_page.dart';
import 'package:pills_reminder/presentation/pages/medicine_form_page.dart';
import 'package:pills_reminder/presentation/pages/splash_page.dart';

/// Daftar halaman dan transisinya.
class AppPages {
  AppPages._();

  static final List<GetPage<dynamic>> pages = [
    GetPage(
      name: Routes.splash,
      page: () => const SplashPage(),
      binding: BindingsBuilder(() => Get.put(SplashController())),
    ),
    GetPage(
      name: Routes.main,
      page: () => const MainShellPage(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: Routes.form,
      page: () => const MedicineFormPage(),
      transition: Transition.rightToLeft,
      binding: BindingsBuilder(() {
        final args = Get.arguments;
        Get.put(
          MedicineFormController(
            Get.find<AddMedicineUseCase>(),
            Get.find<UpdateMedicineUseCase>(),
            Get.find<AppController>(),
            args is Medicine ? args : null,
          ),
        );
      }),
    ),
    GetPage(
      name: Routes.detail,
      page: () {
        final args = Get.arguments;
        return MedicineDetailPage(medicineId: args is int ? args : -1);
      },
      transition: Transition.rightToLeft,
    ),
  ];
}
