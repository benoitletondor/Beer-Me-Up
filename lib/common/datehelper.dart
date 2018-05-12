import 'package:tuple/tuple.dart';

Tuple2<DateTime, DateTime> getWeekStartAndEndDate(DateTime date) {
  final day = DateTime(
    date.year,
    date.month,
    date.day,
  );

  final DateTime weekStartDate = day.add(
    Duration(
      days: -(day.weekday - 1)
    )
  );

  final DateTime weekEndDate = day.add(
    Duration(
      days: 8 - day.weekday
    )
  );

  return Tuple2(weekStartDate, weekEndDate);
}