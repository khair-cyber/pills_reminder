import 'package:pills_reminder/domain/entities/medicine.dart';

/// Serialisasi entitas Medicine <-> Map (disimpan di Hive).
class MedicineModel {
  MedicineModel._();

  static Map<String, dynamic> toMap(Medicine m) => {
        'id': m.id,
        'name': m.name,
        'doseAmount': m.doseAmount,
        'doseUnit': m.doseUnit,
        'frequency': m.frequency.name,
        'weekdays': m.weekdays,
        'times': m.times,
        'startDate': m.startDate.toIso8601String(),
        'endDate': m.endDate?.toIso8601String(),
        'notes': m.notes,
        'createdAt': m.createdAt.toIso8601String(),
      };

  static Medicine fromMap(Map<String, dynamic> map) {
    return Medicine(
      id: map['id'] as int,
      name: map['name'] as String,
      doseAmount: (map['doseAmount'] as num).toDouble(),
      doseUnit: map['doseUnit'] as String,
      frequency: Frequency.values.byName(map['frequency'] as String),
      weekdays: List<int>.from(map['weekdays'] as List),
      times: List<String>.from(map['times'] as List),
      startDate: DateTime.parse(map['startDate'] as String),
      endDate: map['endDate'] == null
          ? null
          : DateTime.parse(map['endDate'] as String),
      notes: map['notes'] as String?,
      createdAt: DateTime.parse(map['createdAt'] as String),
    );
  }
}
