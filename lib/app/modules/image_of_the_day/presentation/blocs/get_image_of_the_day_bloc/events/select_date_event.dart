import 'image_of_the_day_events.dart';

class SelectDateEvent implements ImageOfTheDayEvents {
  final DateTime date;

  SelectDateEvent(this.date);
}
