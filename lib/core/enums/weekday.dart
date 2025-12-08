enum Weekday {
  sunday(1 << 0),
  monday(1 << 1),
  tuesday(1 << 2),
  wednesday(1 << 3),
  thursday(1 << 4),
  friday(1 << 5),
  saturday(1 << 6);

  const Weekday(this.value);
  final int value;

  static int get all =>
      sunday.value | monday.value | tuesday.value | wednesday.value | thursday.value | friday.value | saturday.value;

  static bool isEnabled(int value) => value & all != 0;

  static bool isDisabled(int value) => value & all == 0;

  static bool isAll(int value) => value == all;

  static bool isNone(int value) => value == 0;

  static int bitMask(List<Weekday> weekdays) => weekdays.fold(0, (total, weekday) => total | weekday.value);

  static List<Weekday> fromMask(int mask) => Weekday.values.where((weekday) => mask & weekday.value != 0).toList();
}
