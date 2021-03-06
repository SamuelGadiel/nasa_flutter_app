import 'package:nasa_app/app/modules/image_of_the_day/domain/entities/image_of_the_day.dart';
import 'package:nasa_app/app/modules/image_of_the_day/presentation/blocs/get_image_of_the_day_bloc/states/get_image_of_the_day_states.dart';

class GetImageOfTheDaySuccessState implements GetImageOfTheDayStates {
  final ImageOfTheDay imageOfTheDay;

  GetImageOfTheDaySuccessState(this.imageOfTheDay);
}
