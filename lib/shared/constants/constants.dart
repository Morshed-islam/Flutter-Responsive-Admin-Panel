import 'package:intl/intl.dart';

class AppConstant {
  static String dateFormat(String input) {
    DateTime dateTime = DateTime.parse(input); // parse the input string
    dateTime = dateTime.toUtc(); // convert to UTC
    dateTime = dateTime.add(Duration(hours: 6)); // add 6 hours to account for UTC+6 offset

    String formattedDate = DateFormat('MMMM d, yyyy').format(dateTime); // format the date
    print(formattedDate); // Output: September 1, 2024
    return formattedDate;
  }
}