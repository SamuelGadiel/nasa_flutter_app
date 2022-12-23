import '../../../../domain/entities/image_of_the_day.dart';
import 'image_of_the_day_states.dart';

class GetImageOfTheDaySuccessState implements ImageOfTheDayStates {
  final ImageOfTheDay imageOfTheDay;

  GetImageOfTheDaySuccessState(this.imageOfTheDay);
}
