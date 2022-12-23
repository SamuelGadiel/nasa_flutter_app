import '../../../../../domain/failures/image_of_the_day_failure.dart';
import 'image_of_the_day_failure_states.dart';

class ImageOfTheDayFailureState implements ImageOfTheDayFailureStates {
  final ImageOfTheDayFailure failure;

  ImageOfTheDayFailureState(this.failure);
}
