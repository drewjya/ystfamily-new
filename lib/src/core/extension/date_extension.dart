import 'package:intl/intl.dart';

extension DateTimeX on DateTime {
  String formatTimeAgo() {
    DateTime now = DateTime.now();
    Duration difference = now.difference(this);

    if (difference.inMinutes < 1) {
      return "Baru Saja";
    } else if (difference.inHours < 1) {
      return "${difference.inMinutes} menit yang lalu";
    } else if (difference.inDays < 1) {
      return "${difference.inHours} jam yang lalu";
    } else if (difference.inDays == 1) {
      return "Kemarin";
    } else {
      return DateFormat('dd MMM yyyy').format(this);
    }
  }

  String formatTimePesanan() {
    return DateFormat("dd MMM yyyy, HH:mm").format(this);
  }

  String getDate() {
    return DateFormat("dd MMM yyyy").format(this);
  }

  String getMonthYear() {
    return DateFormat("MMM yyyy").format(this);
  }

  String yearMonthDate() {
    return DateFormat("yyyy-MM-dd").format(this);
  }

  String getHour() {
    return DateFormat("HH:mm").format(this);
  }
}

extension StringDate on String {
  DateTime? get toDate => DateTime.tryParse(this);

  String get toTitle {
    return this[0].toUpperCase() + substring(1).toLowerCase();
  }

  String get date {
    return DateFormat("dd MMM yyyy").format(DateTime.parse(this));
  }

  String get getHour {
    return DateFormat("HH:mm:ss").format(DateTime.parse(this));
  }
}
