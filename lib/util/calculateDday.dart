// 물주기 D-Day 계산
int calculateWater(DateTime date, double cycleDays) {
  final nextDate = date.add(Duration(days: cycleDays.toInt()));
  return nextDate.difference(DateTime.now()).inDays + 1;
}

// 함께한날 D-Day 계산
int calculateLife(DateTime date) {
  return DateTime.now().difference(date).inDays + 1;
}