import 'package:nasa_app/app/modules/image_of_the_day/domain/failures/date_not_allowed_failure.dart';
import 'package:nasa_app/app/modules/image_of_the_day/presentation/blocs/get_image_of_the_day_bloc/states/get_image_of_the_day_states.dart';

class DateNotAllowedFailureState implements GetImageOfTheDayStates {
  final DateNotAllowedFailure failure;

  DateNotAllowedFailureState(this.failure);
}
 