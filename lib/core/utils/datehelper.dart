import 'package:intl/intl.dart';

final _dateFormatter = DateFormat('dd MMM yyyy');

String formatDate(DateTime date) {
  return _dateFormatter.format(date.toLocal());
}
