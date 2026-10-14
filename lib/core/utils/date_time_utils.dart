/// Fungsi bantu tanggal & waktu (format Bahasa Indonesia tanpa paket intl).
class DateTimeUtils {
  DateTimeUtils._();

  static const List<String> _dayNames = [
    'Senin', 'Selasa', 'Rabu', 'Kamis', 'Jumat', 'Sabtu', 'Minggu',
  ];
  static const List<String> _dayShort = [
    'Sen', 'Sel', 'Rab', 'Kam', 'Jum', 'Sab', 'Min',
  ];
  static const List<String> _months = [
    'Januari', 'Februari', 'Maret', 'April', 'Mei', 'Juni', 'Juli',
    'Agustus', 'September', 'Oktober', 'November', 'Desember',
  ];

  /// Hanya bagian tanggal (jam 00:00).
  static DateTime dateOnly(DateTime d) => DateTime(d.year, d.month, d.day);

  static bool isSameDay(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;

  /// weekday: 1 = Senin ... 7 = Minggu (sesuai DateTime.weekday).
  static String dayName(int weekday) => _dayNames[weekday - 1];
  static String dayShort(int weekday) => _dayShort[weekday - 1];

  /// Contoh: 12 Oktober 2026
  static String formatDate(DateTime d) =>
      '${d.day} ${_months[d.month - 1]} ${d.year}';

  /// Contoh: Senin, 12 Oktober 2026
  static String formatFullDate(DateTime d) =>
      '${dayName(d.weekday)}, ${formatDate(d)}';

  /// Contoh: 12 Okt 2026
  static String formatShortDate(DateTime d) =>
      '${d.day} ${_months[d.month - 1].substring(0, 3)} ${d.year}';

  /// 'HH:mm' dari jam & menit.
  static String formatHm(int hour, int minute) =>
      '${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')}';

  static String formatTime(DateTime d) => formatHm(d.hour, d.minute);

  /// Kunci tanggal: yyyyMMdd.
  static String dateKey(DateTime d) =>
      '${d.year.toString().padLeft(4, '0')}'
      '${d.month.toString().padLeft(2, '0')}'
      '${d.day.toString().padLeft(2, '0')}';

  static int hourOf(String hhmm) => int.parse(hhmm.split(':')[0]);
  static int minuteOf(String hhmm) => int.parse(hhmm.split(':')[1]);

  /// Menggabungkan tanggal dan string 'HH:mm'.
  static DateTime combine(DateTime day, String hhmm) =>
      DateTime(day.year, day.month, day.day, hourOf(hhmm), minuteOf(hhmm));
}
