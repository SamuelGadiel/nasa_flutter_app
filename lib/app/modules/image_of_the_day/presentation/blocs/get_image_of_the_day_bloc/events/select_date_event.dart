import 'package:nasa_app/app/modules/image_of_the_day/presentation/blocs/get_image_of_the_day_bloc/events/get_image_of_the_day_events.dart';

class SelectDateEvent implements GetImageOfTheDayEvents {
  final DateTime date;

  SelectDateEvent(this.date);
}
