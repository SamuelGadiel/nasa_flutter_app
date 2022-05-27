import 'package:nasa_app/app/modules/image_of_the_day/domain/failures/image_of_the_day_failure.dart';
import 'package:nasa_app/app/modules/image_of_the_day/presentation/blocs/get_image_of_the_day_bloc/states/get_image_of_the_day_states.dart';

class ImageOfTheDayFailureState implements GetImageOfTheDayStates {
  final ImageOfTheDayFailure failure;

  ImageOfTheDayFailureState(this.failure);
}
