import 'package:intl/intl.dart';

String formatDate(String? date) {
  final DateTime parsedDate = DateTime.tryParse(date ?? '') ?? DateTime.now();
  return DateFormat.yMMMd().format(parsedDate);
}
