import 'package:flutter_test/flutter_test.dart';
import 'package:pills_reminder/domain/entities/medicine.dart';
import 'package:pills_reminder/domain/validators/medicine_validator.dart';

void main() {
  group('Nama obat', () {
    test('kosong ditolak', () {
      expect(MedicineValidator.name(''), isNotNull);
      expect(MedicineValidator.name('   '), isNotNull);
    });
    test('terlalu pendek / panjang ditolak', () {
      expect(MedicineValidator.name('A'), isNotNull);
      expect(MedicineValidator.name('A' * 51), isNotNull);
    });
    test('valid diterima', () {
      expect(MedicineValidator.name('Amlodipine'), isNull);
    });
  });

  group('Dosis', () {
    test('kosong, bukan angka, nol, negatif ditolak', () {
      expect(MedicineValidator.dose(''), isNotNull);
      expect(MedicineValidator.dose('abc'), isNotNull);
      expect(MedicineValidator.dose('0'), isNotNull);
      expect(MedicineValidator.dose('-1'), isNotNull);
    });
    test('angka bulat dan desimal (titik/koma) diterima', () {
      expect(MedicineValidator.dose('1'), isNull);
      expect(MedicineValidator.dose('0.5'), isNull);
      expect(MedicineValidator.dose('0,5'), isNull);
    });
  });

  group('Jadwal', () {
    test('jam pengingat wajib minimal satu', () {
      expect(MedicineValidator.times([]), isNotNull);
      expect(MedicineValidator.times(['08:00']), isNull);
    });
    test('mingguan wajib memilih hari', () {
      expect(MedicineValidator.weekdays(Frequency.weekly, []), isNotNull);
      expect(MedicineValidator.weekdays(Frequency.weekly, [1]), isNull);
      expect(MedicineValidator.weekdays(Frequency.daily, []), isNull);
    });
    test('tanggal selesai tidak boleh sebelum tanggal mulai', () {
      final start = DateTime(2026, 10, 12);
      expect(
        MedicineValidator.dateRange(
            Frequency.daily, start, DateTime(2026, 10, 11)),
        isNotNull,
      );
      expect(
        MedicineValidator.dateRange(
            Frequency.daily, start, DateTime(2026, 10, 12)),
        isNull,
      );
      expect(MedicineValidator.dateRange(Frequency.daily, start, null), isNull);
    });
    test('sekali: waktu yang sudah lewat ditolak', () {
      final now = DateTime(2026, 10, 12, 10, 0);
      final day = DateTime(2026, 10, 12);
      expect(
        MedicineValidator.onceNotInPast(Frequency.once, day, ['09:00'], now),
        isNotNull,
      );
      expect(
        MedicineValidator.onceNotInPast(Frequency.once, day, ['11:00'], now),
        isNull,
      );
    });
  });
}
