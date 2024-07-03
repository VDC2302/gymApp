import 'package:intl/intl.dart';

class StringUtils {
  static String truncate(String stringToCut, int lengthToCutTo) {
    if (stringToCut.length > lengthToCutTo) {
      return "${stringToCut.substring(0, lengthToCutTo)}...";
    }
    return stringToCut;
  }

  static String formatDate(String val,
      {bool? showTimeStamp = true, bool? showOnlyTime = false}) {
    String amOrPm = '';
    List<String> hourOrMinsAgo = [];
    final dateFormat = DateFormat('EEE, dd MMM, yyy: HH:mm');
    if (val.isEmpty) {
      return '';
    } else {
      final date = DateTime.parse(val);
      final rr = date.difference(DateTime.now());
      final minsAgo = rr.inMinutes.abs() / 60;
      hourOrMinsAgo = minsAgo > 47
          ? [rr.inDays.abs().toString(), 'days']
          : minsAgo > 23
              ? [rr.inDays.abs().toString(), 'day']
              : minsAgo > 1
                  ? [rr.inHours.abs().toString(), 'mins']
                  : [rr.inMinutes.abs().toString(), 'min'];
      amOrPm = date.hour > 11 ? 'PM' : 'AM';
      if (showOnlyTime!) {
        return '${DateFormat('EEE, dd MMM, yyy').format(date)} at ${DateFormat(' HH:mm').format(date)}$amOrPm';
      }
      return '${dateFormat.format(date)}$amOrPm ${showTimeStamp! ? ' .  ${hourOrMinsAgo[0]} ${hourOrMinsAgo[1]} ago' : ''}';
    }
  }

  static String getInitials(String value, String value2) {
    if (value.isNotEmpty && value2.isNotEmpty) {
      return '${value[0].toUpperCase()}${value2[0].toUpperCase()}';
    } else {
      return '';
    }
  }

  static String formatCurrencyInput(String amount, {bool naira = true}) {
    final formatter = NumberFormat.currency(
      locale: naira ? "en_NG" : 'en_US',
      name: !naira ? 'USD' : 'NGN',
      symbol: !naira ? '\$' : "₦",
      decimalDigits: 2,
    );
    amount = amount.replaceAll(RegExp(r'[^0-9\.]'), "");
    final amountDouble = double.tryParse(amount);
    if (amountDouble == null) {
      return "";
    }
    return formatter.format(amountDouble);
  }

  static String formatNumber(String amount) {
    NumberFormat numberFormat = NumberFormat("#,##0", "en_US");
    final returnedAmount = numberFormat.format(double.parse(amount));
    return returnedAmount;
  }

  static String greeting() {
    var hour = DateTime.now().hour;
    if (hour < 12) {
      return "Morning";
    } else if (hour < 17) {
      return "Afternoon";
    }
    return "Evening";
  }

  static String formatPhoneNumberForApi(String phoneNumber, String dialCode) {
    final dialcode = dialCode.replaceAll("+", "");
    final firstDigit = phoneNumber.substring(0, 1);
    if (firstDigit == "0") {
      return "$dialcode${phoneNumber.substring(1)}";
    } else {
      return "$dialcode$phoneNumber";
    }
  }

  static String capitalize(String value) {
    return '${value[0].toUpperCase()}${value.substring(1)}';
  }

  static String formatTimeInMinutes(Duration duration) {
    return "${duration.inMinutes.remainder(60).toString().padLeft(2, "0")}:${duration.inSeconds.remainder(60).toString().padLeft(2, "0")}";
  }

  String splitAndJoinEachUpperCase(String value) {
    return value
        .split(
          RegExp('(?=[A-Z])'),
        )
        .join(' ');
  }
}
