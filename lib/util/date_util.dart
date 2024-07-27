class DateUtil {

  static Map<int, String> days = {
    1: "Mon.",
    2: "Tues.",
    3: "Wed.",
    4: "Thurs.",
    5: "Fri.",
    6: "Sat.",
    7: "Sun."
  };

  static Map<int, String> months = {
    1: "January",
    2: "February",
    3: "March",
    4: "April",
    5: "May",
    6: "June",
    7: "July",
    8: "August",
    9: "September",
    10: "October",
    11: "November",
    12: "December"
  };


  static String getCurrentTime() {
    DateTime now = DateTime.now();
    int hour = now.hour;
    int minute = now.minute;

    String period = hour >= 12 ? "PM" : "AM";

    // Hour to 12-hour format Convertion
    hour = hour % 12;

    if (hour == 0) {
      hour = 12;
    }

    String minuteStr = minute < 10 ? "0$minute" : "$minute";

    return "$hour:$minuteStr $period";
  }

  static String getInitTime(DateTime itemInitDate) {
    int hour = itemInitDate.hour;
    int minute = itemInitDate.minute;

    String period = hour >= 12 ? "PM" : "AM";

    // Hour to 12-hour format Convertion
    hour = hour % 12;

    if (hour == 0) {
      hour = 12;
    }

    String minuteStr = minute < 10 ? "0$minute" : "$minute";

    return "$hour:$minuteStr $period";
  }

  static String getCurrentDay() {
    return days[DateTime.now().day]!;
  }

  static String getCurrentMonth() {
    return months[DateTime.now().month]!;
  }

  static String getCurrentYear() {
    return DateTime.now().year.toString();
  }

  static bool isLeapYear(int year) {
    if (year % 4 != 0) return false;
    if (year % 100 != 0) return true;
    if (year % 400 != 0) return false;
    return true;
  }

  // Different versions based on time difference between current time and init time for the item
  static String getCurrentDate(DateTime itemInitDate) {
    DateTime now = DateTime.now();
    Duration difference = now.difference(itemInitDate);

    // Check if the difference is more than or equal to a year
    bool moreThanAYear = (now.year > itemInitDate.year) ||
                        (now.year == itemInitDate.year && difference.inDays >= 365) ||
                        (isLeapYear(itemInitDate.year) && difference.inDays >= 366);

    if (moreThanAYear) {
      // String for dates more than a year ago
      return "${itemInitDate.day} ${months[itemInitDate.month]} ${itemInitDate.year}";
    } else if (difference.inDays >= 7) {
      // String for dates more than a week ago
      return "${itemInitDate.day} ${months[itemInitDate.month]}";
    } else if (difference.inDays >= 1) {
      // String for dates more than a day ago
      return "${getInitTime(itemInitDate)} ${days[itemInitDate.weekday]}";
    } else {
      // String for dates within a day
      return getInitTime(itemInitDate);
    }
  }
}
