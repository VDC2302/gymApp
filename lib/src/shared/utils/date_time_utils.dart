import 'package:intl/intl.dart';

String _getDaySuffix(int day) {
  if (day >= 11 && day <= 13) {
    return 'th';
  }
  switch (day % 10) {
    case 1:
      return 'st';
    case 2:
      return 'nd';
    case 3:
      return 'rd';
    default:
      return 'th';
  }
}

String formatDate(DateTime dateTime) {
  String daySuffix = _getDaySuffix(dateTime.day);
  return DateFormat("d'$daySuffix' MMM, y").format(dateTime);
}

bool isAppointmentForToday(DateTime appointmentDate) {
  // Get today's date
  DateTime today = DateTime.now();

  // Compare the year, month, and day of the appointmentDate with today's date
  return appointmentDate.year == today.year &&
      appointmentDate.month == today.month &&
      appointmentDate.day == today.day;
}

bool isAppointmentCompleted(DateTime appointmentDate) {
  // Get today's date
  DateTime today = DateTime.now();

  // Check if the appointment date is before today's date
  return appointmentDate.isBefore(DateTime(today.year, today.month, today.day));
}

bool isAppointmentUpcoming(DateTime appointmentDate) {
  // Get today's date
  DateTime today = DateTime.now();

  // Check if the appointment date is after today's date
  return appointmentDate.isAfter(DateTime(today.year, today.month, today.day));
}
