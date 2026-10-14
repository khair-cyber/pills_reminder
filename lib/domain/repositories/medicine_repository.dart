import 'package:pills_reminder/domain/entities/medicine.dart';

/// Kontrak penyimpanan data obat (diimplementasikan di data layer).
abstract class MedicineRepository {
  Future<List<Medicine>> getAll();

  /// Menyimpan obat baru dan mengembalikan obat dengan ID yang sudah terisi.
  Future<Medicine> add(Medicine medicine);

  Future<void> update(Medicine medicine);

  Future<void> delete(int id);
}
