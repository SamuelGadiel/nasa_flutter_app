import 'package:nasa_app/app/modules/image_of_the_day/domain/entities/image_of_the_day_parameters.dart';
import 'package:nasa_app/app/modules/image_of_the_day/presentation/blocs/get_image_of_the_day_bloc/events/get_image_of_the_day_events.dart';

class GetImageOfTheDayEvent implements GetImageOfTheDayEvents {
  final ImageOfTheDayParameters parameters;

  GetImageOfTheDayEvent(this.parameters);
}
