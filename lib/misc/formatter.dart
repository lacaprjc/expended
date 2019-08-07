import 'package:intl/intl.dart';

class Formatter {
  static final NumberFormat numberFormat = NumberFormat('#.##');
  static final DateFormat dateFormat =
      DateFormat(DateFormat.YEAR_ABBR_MONTH_DAY);
  static final DateFormat timeFormat = DateFormat(DateFormat.HOUR_MINUTE);
}
