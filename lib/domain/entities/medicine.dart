import 'package:pills_reminder/core/utils/date_time_utils.dart';

/// Frekuensi konsumsi obat.
enum Frequency { once, daily, weekly }

extension FrequencyX on Frequency {
  String get label {
    switch (this) {
      case Frequency.once:
        return 'Sekali';
      case Frequency.daily:
        return 'Setiap hari';
      case Frequency.weekly:
        return 'Mingguan';
    }
  }
}

/// Status jadwal sebuah obat terhadap suatu tanggal.
enum MedicineStatus { upcoming, active, finished }

extension MedicineStatusX on MedicineStatus {
  String get label {
    switch (this) {
      case MedicineStatus.upcoming:
        return 'Belum mulai';
      case MedicineStatus.active:
        return 'Aktif';
      case MedicineStatus.finished:
        return 'Selesai';
    }
  }
}

/// Entitas bisnis: data sebuah obat beserta jadwalnya.
class Medicine {
  const Medicine({
    required this.id,
    required this.name,
    required this.doseAmount,
    required this.doseUnit,
    required this.frequency,
    this.weekdays = const [],
    required this.times,
    required this.startDate,
    this.endDate,
    this.notes,
    required this.createdAt,
  });

  /// ID unik (auto-increment). 0 berarti belum disimpan.
  final int id;
  final String name;
  final double doseAmount;
  final String doseUnit;
  final Frequency frequency;

  /// Hari konsumsi untuk frekuensi mingguan (1 = Senin ... 7 = Minggu).
  final List<int> weekdays;

  /// Jam pengingat, format 'HH:mm', terurut naik.
  final List<String> times;

  /// Hanya tanggal (tanpa jam).
  final DateTime startDate;
  final DateTime? endDate;
  final String? notes;
  final DateTime createdAt;

  /// Contoh: "1 tablet", "0,5 tablet".
  String get doseLabel {
    final isWhole = doseAmount == doseAmount.roundToDouble();
    final text =
        isWhole ? doseAmount.toInt().toString() : doseAmount.toString();
    return '${text.replaceAll('.', ',')} $doseUnit';
  }

  /// Deskripsi frekuensi untuk ditampilkan di UI.
  String get frequencyDescription {
    switch (frequency) {
      case Frequency.once:
        return 'Sekali pada ${DateTimeUtils.formatShortDate(startDate)}';
      case Frequency.daily:
        return 'Setiap hari';
      case Frequency.weekly:
        final days = [...weekdays]..sort();
        return 'Setiap ${days.map(DateTimeUtils.dayShort).join(', ')}';
    }
  }

  MedicineStatus statusOn(DateTime day) {
    final d = DateTimeUtils.dateOnly(day);
    final start = DateTimeUtils.dateOnly(startDate);
    if (d.isBefore(start)) return MedicineStatus.upcoming;
    if (frequency == Frequency.once) {
      return d.isAfter(start) ? MedicineStatus.finished : MedicineStatus.active;
    }
    if (endDate != null && d.isAfter(DateTimeUtils.dateOnly(endDate!))) {
      return MedicineStatus.finished;
    }
    return MedicineStatus.active;
  }

  Medicine copyWith({
    int? id,
    String? name,
    double? doseAmount,
    String? doseUnit,
    Frequency? frequency,
    List<int>? weekdays,
    List<String>? times,
    DateTime? startDate,
    DateTime? endDate,
    String? notes,
    DateTime? createdAt,
  }) {
    return Medicine(
      id: id ?? this.id,
      name: name ?? this.name,
      doseAmount: doseAmount ?? this.doseAmount,
      doseUnit: doseUnit ?? this.doseUnit,
      frequency: frequency ?? this.frequency,
      weekdays: weekdays ?? this.weekdays,
      times: times ?? this.times,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      notes: notes ?? this.notes,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
