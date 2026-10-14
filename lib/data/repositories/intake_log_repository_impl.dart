import 'package:pills_reminder/data/datasources/local_data_source.dart';
import 'package:pills_reminder/domain/entities/intake_log.dart';
import 'package:pills_reminder/domain/repositories/intake_log_repository.dart';

class IntakeLogRepositoryImpl implements IntakeLogRepository {
  IntakeLogRepositoryImpl(this._local);
  final IntakeLogLocalDataSource _local;

  @override
  Future<List<IntakeLog>> getAll() async => _local.getAll();

  @override
  Future<void> save(IntakeLog log) => _local.put(log);

  @override
  Future<void> delete(String key) => _local.delete(key);
}
