import '../../../../../../../core/failures/failure.dart';
import '../image_of_the_day_states.dart';

abstract class ImageOfTheDayFailureStates implements ImageOfTheDayStates {
  final Failure failure;

  ImageOfTheDayFailureStates(this.failure); // coverage:ignore-line
}
