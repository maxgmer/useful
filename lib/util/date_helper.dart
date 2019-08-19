class DateHelper {
  //when we specify 0 for day it gives us last day of the previous month
  static int getDaysInCurrentMonth(DateTime date) {
    return (date.month == 12 ?
    DateTime(date.year + 1, 1, 0) :
    DateTime(date.year, date.month + 1, 0))
        .day;
  }
}