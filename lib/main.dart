import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:pills_reminder/app/app.dart';
import 'package:pills_reminder/core/constants/app_constants.dart';
import 'package:pills_reminder/data/services/local_notification_scheduler.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Basis data lokal (Hive)
  await Hive.initFlutter();
  await Future.wait([
    Hive.openBox(AppConstants.medicinesBox),
    Hive.openBox(AppConstants.logsBox),
    Hive.openBox(AppConstants.metaBox),
  ]);

  // Layanan notifikasi lokal + zona waktu
  final scheduler = LocalNotificationScheduler();
  await scheduler.init();

  runApp(PillsReminderApp(scheduler: scheduler));
}
