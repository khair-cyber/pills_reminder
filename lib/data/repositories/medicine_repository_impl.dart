import 'package:pills_reminder/data/datasources/local_data_source.dart';
import 'package:pills_reminder/domain/entities/medicine.dart';
import 'package:pills_reminder/domain/repositories/medicine_repository.dart';

class MedicineRepositoryImpl implements MedicineRepository {
  MedicineRepositoryImpl(this._local);
  final MedicineLocalDataSource _local;

  @override
  Future<List<Medicine>> getAll() async => _local.getAll();

  @override
  Future<Medicine> add(Medicine medicine) async {
    final id = await _local.nextId();
    final saved = medicine.copyWith(id: id);
    await _local.put(saved);
    return saved;
  }

  @override
  Future<void> update(Medicine medicine) => _local.put(medicine);

  @override
  Future<void> delete(int id) => _local.delete(id);
}
