import 'package:pills_reminder/domain/entities/intake_log.dart';

/// Kontrak penyimpanan riwayat konsumsi obat.
abstract class IntakeLogRepository {
  Future<List<IntakeLog>> getAll();

  Future<void> save(IntakeLog log);

  Future<void> delete(String key);
}
