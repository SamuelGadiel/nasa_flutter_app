import 'image_of_the_day_failures.dart';

class DateNotAllowedFailure implements ImageOfTheDayFailures {
  final String message;

  DateNotAllowedFailure(this.message);
}
