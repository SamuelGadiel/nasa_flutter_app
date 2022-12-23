import 'image_of_the_day_events.dart';

class GetImageOfTheDayEvent implements ImageOfTheDayEvents {
  final String date;

  GetImageOfTheDayEvent({required this.date});
}
