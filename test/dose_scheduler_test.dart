import 'package:flutter_test/flutter_test.dart';
import 'package:pills_reminder/domain/entities/medicine.dart';
import 'package:pills_reminder/domain/services/dose_scheduler.dart';

Medicine _med({
  Frequency frequency = Frequency.daily,
  List<int> weekdays = const [],
  List<String> times = const ['08:00', '20:00'],
  DateTime? start,
  DateTime? end,
}) {
  return Medicine(
    id: 1,
    name: 'Amlodipine',
    doseAmount: 1,
    doseUnit: 'tablet',
    frequency: frequency,
    weekdays: weekdays,
    times: times,
    startDate: start ?? DateTime(2026, 10, 12),
    endDate: end,
    createdAt: DateTime(2026, 10, 1),
  );
}

void main() {
  group('DoseScheduler.occursOn', () {
    test('harian: terjadi pada setiap hari dalam rentang', () {
      final m = _med(end: DateTime(2026, 10, 14));
      expect(DoseScheduler.occursOn(m, DateTime(2026, 10, 11)), isFalse);
      expect(DoseScheduler.occursOn(m, DateTime(2026, 10, 12)), isTrue);
      expect(DoseScheduler.occursOn(m, DateTime(2026, 10, 14)), isTrue);
      expect(DoseScheduler.occursOn(m, DateTime(2026, 10, 15)), isFalse);
    });

    test('sekali: hanya pada tanggal mulai', () {
      final m = _med(frequency: Frequency.once);
      expect(DoseScheduler.occursOn(m, DateTime(2026, 10, 12)), isTrue);
      expect(DoseScheduler.occursOn(m, DateTime(2026, 10, 13)), isFalse);
    });

    test('mingguan: hanya pada hari terpilih (1=Senin, 3=Rabu)', () {
      // 12 Okt 2026 = Senin, 14 Okt 2026 = Rabu
      final m = _med(frequency: Frequency.weekly, weekdays: [1, 3]);
      expect(DoseScheduler.occursOn(m, DateTime(2026, 10, 12)), isTrue);
      expect(DoseScheduler.occursOn(m, DateTime(2026, 10, 13)), isFalse);
      expect(DoseScheduler.occursOn(m, DateTime(2026, 10, 14)), isTrue);
    });
  });

  group('DoseScheduler.doseTimesOn / nextDose', () {
    test('mengembalikan semua jam pada hari tsb, terurut', () {
      final m = _med(times: ['20:00', '08:00']);
      final list = DoseScheduler.doseTimesOn(m, DateTime(2026, 10, 12));
      expect(list, [
        DateTime(2026, 10, 12, 8, 0),
        DateTime(2026, 10, 12, 20, 0),
      ]);
    });

    test('hari tanpa jadwal menghasilkan daftar kosong', () {
      final m = _med(frequency: Frequency.weekly, weekdays: [1]);
      expect(DoseScheduler.doseTimesOn(m, DateTime(2026, 10, 13)), isEmpty);
    });

    test('nextDose mencari jadwal terdekat setelah sekarang', () {
      final m = _med();
      final next = DoseScheduler.nextDose(m, DateTime(2026, 10, 12, 9, 0));
      expect(next, DateTime(2026, 10, 12, 20, 0));
    });

    test('nextDose bernilai null jika jadwal sudah selesai', () {
      final m = _med(end: DateTime(2026, 10, 13));
      expect(DoseScheduler.nextDose(m, DateTime(2026, 10, 20)), isNull);
    });
  });

  group('Medicine', () {
    test('doseLabel memakai koma desimal', () {
      final m = _med().copyWith(doseAmount: 0.5);
      expect(m.doseLabel, '0,5 tablet');
      expect(_med().doseLabel, '1 tablet');
    });

    test('statusOn: belum mulai, aktif, selesai', () {
      final m = _med(end: DateTime(2026, 10, 14));
      expect(m.statusOn(DateTime(2026, 10, 11)), MedicineStatus.upcoming);
      expect(m.statusOn(DateTime(2026, 10, 13)), MedicineStatus.active);
      expect(m.statusOn(DateTime(2026, 10, 15)), MedicineStatus.finished);
    });
  });
}
