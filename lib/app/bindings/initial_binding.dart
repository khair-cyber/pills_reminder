import 'package:get/get.dart';
import 'package:pills_reminder/data/datasources/local_data_source.dart';
import 'package:pills_reminder/data/repositories/intake_log_repository_impl.dart';
import 'package:pills_reminder/data/repositories/medicine_repository_impl.dart';
import 'package:pills_reminder/domain/repositories/intake_log_repository.dart';
import 'package:pills_reminder/domain/repositories/medicine_repository.dart';
import 'package:pills_reminder/domain/services/reminder_scheduler.dart';
import 'package:pills_reminder/domain/usecases/dose_usecases.dart';
import 'package:pills_reminder/domain/usecases/medicine_usecases.dart';
import 'package:pills_reminder/domain/usecases/reminder_usecases.dart';
import 'package:pills_reminder/presentation/controllers/app_controller.dart';
import 'package:pills_reminder/presentation/controllers/history_controller.dart';
import 'package:pills_reminder/presentation/controllers/medicine_controller.dart';
import 'package:pills_reminder/presentation/controllers/today_controller.dart';

/// Dependency injection: merangkai data layer -> domain layer -> controller.
class InitialBinding extends Bindings {
  InitialBinding(this.scheduler);

  final ReminderScheduler scheduler;

  @override
  void dependencies() {
    // Data sources
    Get.put(MedicineLocalDataSource(), permanent: true);
    Get.put(IntakeLogLocalDataSource(), permanent: true);

    // Repositories
    Get.put<MedicineRepository>(
      MedicineRepositoryImpl(Get.find<MedicineLocalDataSource>()),
      permanent: true,
    );
    Get.put<IntakeLogRepository>(
      IntakeLogRepositoryImpl(Get.find<IntakeLogLocalDataSource>()),
      permanent: true,
    );

    // Services
    Get.put<ReminderScheduler>(scheduler, permanent: true);

    final meds = Get.find<MedicineRepository>();
    final logs = Get.find<IntakeLogRepository>();

    // Use cases
    Get.put(GetMedicinesUseCase(meds), permanent: true);
    Get.put(AddMedicineUseCase(meds, scheduler), permanent: true);
    Get.put(UpdateMedicineUseCase(meds, scheduler), permanent: true);
    Get.put(DeleteMedicineUseCase(meds, scheduler), permanent: true);
    Get.put(GetDosesForDayUseCase(meds, logs), permanent: true);
    Get.put(MarkDoseTakenUseCase(logs), permanent: true);
    Get.put(UndoDoseTakenUseCase(logs), permanent: true);
    Get.put(GetHistoryUseCase(logs), permanent: true);
    Get.put(GetAdherenceUseCase(meds, logs), permanent: true);
    Get.put(SyncRemindersUseCase(meds, scheduler), permanent: true);

    // Controllers
    final app = Get.put(
      AppController(scheduler, Get.find<SyncRemindersUseCase>()),
      permanent: true,
    );
    Get.put(
      MedicineController(
        Get.find<GetMedicinesUseCase>(),
        Get.find<DeleteMedicineUseCase>(),
        app,
      ),
      permanent: true,
    );
    Get.put(
      TodayController(
        Get.find<GetDosesForDayUseCase>(),
        Get.find<MarkDoseTakenUseCase>(),
        Get.find<UndoDoseTakenUseCase>(),
        app,
      ),
      permanent: true,
    );
    Get.put(
      HistoryController(
        Get.find<GetHistoryUseCase>(),
        Get.find<GetAdherenceUseCase>(),
        app,
      ),
      permanent: true,
    );
  }
}
