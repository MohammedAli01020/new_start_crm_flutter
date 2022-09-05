extension DateValues on DateTime {
  DateTime get now => DateTime.now();

  int get firstTimeOfCurrentMonthMillis =>
      DateTime(now.year, now.month, 0, 24).millisecondsSinceEpoch;

  int get lastTimOfCurrentMonthMillis =>
      DateTime(now.year, now.month + 1, -1, 24).millisecondsSinceEpoch;


  int get firstTimePreviousMonthMillis =>
      DateTime(now.year, now.month -1 , 0, 24).millisecondsSinceEpoch;

  int get lastTimOfPreviousMonthMillis =>
      DateTime(now.year, now.month, -1, 24).millisecondsSinceEpoch;


  int get firstTimeOfTwoPreviousMonthMillis =>
      DateTime(now.year, now.month -2 , 0, 24).millisecondsSinceEpoch;

  int get lastTimeOfTwoPreviousMonthMillis =>
      DateTime(now.year, now.month, -2, 24).millisecondsSinceEpoch;


  int get firstTimeOfThreePreviousMonthMillis =>
      DateTime(now.year, now.month -3 , 0, 24).millisecondsSinceEpoch;

  int get lastTimeOfThreePreviousMonthMillis =>
      DateTime(now.year, now.month, -3, 24).millisecondsSinceEpoch;

  int get firstTimOfCurrentDayMillis =>
      DateTime(now.year, now.month, now.day - 1, 24).millisecondsSinceEpoch;

  int get lastTimOfCurrentDayMillis =>
      DateTime(now.year, now.month, now.day, 24).millisecondsSinceEpoch;
}
