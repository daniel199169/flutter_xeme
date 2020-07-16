import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DateUtils {
  static String getTwoDigitString(int num) {
    if ((num / 10).toInt() == 0) {
      return '0$num';
    } else {
      return '$num';
    }
  }

  // Get Sri lanka time
  static String getDateStringForSms() {
    DateTime now = DateTime.now();
//    now = DateTime(now.year, now.month, now.day, now.hour + 6, now.minute, now.second, now.millisecond);
    now = DateTime(now.year, now.month, now.day, now.hour, now.minute,
        now.second, now.millisecond);
    return getTwoDigitString(now.year) +
        "-" +
        getTwoDigitString(now.month) +
        "-" +
        getTwoDigitString(now.day) +
        "T" +
        getTwoDigitString(now.hour) +
        ":" +
        getTwoDigitString(now.minute) +
        ":" +
        getTwoDigitString(now.second);
  }

  static String getTimeStringWithFormat(
      {@required dateTime: DateTime, @required format: String}) {
    return DateFormat(format).format(dateTime);
  }

  static String getHMFromMiliseconds(num miliseconds) {
    int seconds = (miliseconds / 1000).toInt();
    int hour = (seconds / 3600).toInt();
    hour = hour % 24;
    seconds = seconds % 3600;
    int min = (seconds / 60).toInt();
    return '${getTwoDigitString(hour)}:${getTwoDigitString(min)}';
  }

  static String getWeekday(DateTime date) {
    return DateFormat('EEEE').format(date);
  }

  static String getMonth(DateTime dateTime) {
    return DateFormat("MMMM").format(dateTime);
  }

  static int getMiliseconds(DateTime dateTime) {
    return dateTime.toUtc().millisecondsSinceEpoch;
  }

  static DateTime getYesterday() {
    var now = DateTime.now();
    var year = now.year;
    var month = now.day == 1 ? now.month - 1 : now.month;
    var day = now.day - 1;
    return DateTime(year, month, day);
  }

  static DateTime getDateTime(int miliseconds) {
    return DateTime.fromMillisecondsSinceEpoch(miliseconds);
  }

  static String getDay(DateTime dateTime) {
    var day = dateTime.day;
    return day.toString() + 'th';
  }

  static String getYear(DateTime dateTime) {
    return dateTime.year.toString();
  }

  static Future<DateTime> pickBookingDate({context: BuildContext}) async {
    var now = DateTime.now();
    var initialDate = DateTime(now.year, now.month, now.day, now.hour + 1);

    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );

    if (picked != null) {
      return picked;
    }
  }

  static Future<DateTime> pickDOM(
      {context: BuildContext,
      initialDate: DateTime,
      firstDate: DateTime}) async {
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: firstDate ?? DateTime(1900, 1, 1),
      lastDate: DateTime(2050, 12, 31),
      builder: (BuildContext context, Widget child) {
        return Theme(
          data: ThemeData(
              primarySwatch: Colors.blue, //Head background //OK/Cancel button text color
              primaryColor: const Color(0xFF272D3A), //Head background
              accentColor: const Color(0xFF272D3A) //selection color
              //dialogBackgroundColor: Colors.white,//Background color
              ),
          child: child,
        );
        
      },
    );

    if (picked != null) {
      return picked;
    }
  }

  static Future<TimeOfDay> pickTime(
      {context: BuildContext, initialTime: TimeOfDay}) async {
    final TimeOfDay selectedTime = await showTimePicker(
//      initialTime: TimeOfDay.now(),
      initialTime: initialTime,
      context: context,
    );
    if (selectedTime != null) {
      return selectedTime;
    }
  }

  static int CalcCustomTimeStamp(
      {@required DateTime dateTime, @required TimeOfDay timeOfDay}) {
    int year_diff = (dateTime.year - 1950);
    if (year_diff < 0) return 0;
    String year = year_diff.toString();
    String month = getTwoDigitString(dateTime.month);
    String day = getTwoDigitString(dateTime.day);
    String hour = getTwoDigitString(timeOfDay.hour);
    String minute = getTwoDigitString(timeOfDay.minute);
    String tot = year + month + day + hour + minute;
    return int.parse(tot);
  }
}
