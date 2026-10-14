import 'package:get/get.dart';
import 'package:pills_reminder/app/routes/app_routes.dart';

class SplashController extends GetxController {
  @override
  void onReady() {
    super.onReady();
    Future.delayed(const Duration(milliseconds: 1500), () {
      Get.offAllNamed(Routes.main);
    });
  }
}
