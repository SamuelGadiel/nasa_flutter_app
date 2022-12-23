import '../../../../../domain/failures/date_not_allowed_failure.dart';
import 'image_of_the_day_failure_states.dart';

class DateNotAllowedFailureState implements ImageOfTheDayFailureStates {
  final DateNotAllowedFailure failure;

  DateNotAllowedFailureState(this.failure);
}
