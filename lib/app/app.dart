import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pills_reminder/app/bindings/initial_binding.dart';
import 'package:pills_reminder/app/routes/app_pages.dart';
import 'package:pills_reminder/app/routes/app_routes.dart';
import 'package:pills_reminder/core/constants/app_constants.dart';
import 'package:pills_reminder/core/theme/app_theme.dart';
import 'package:pills_reminder/domain/services/reminder_scheduler.dart';

class PillsReminderApp extends StatelessWidget {
  const PillsReminderApp({super.key, required this.scheduler});

  final ReminderScheduler scheduler;

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: AppConstants.appName,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      initialBinding: InitialBinding(scheduler),
      initialRoute: Routes.splash,
      getPages: AppPages.pages,
    );
  }
}
