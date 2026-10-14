/// Ringkasan kepatuhan minum obat pada rentang waktu tertentu.
class AdherenceSummary {
  const AdherenceSummary({required this.scheduled, required this.taken});

  final int scheduled;
  final int taken;

  double get ratio => scheduled == 0 ? 0 : taken / scheduled;
  int get percent => (ratio * 100).round();
}
