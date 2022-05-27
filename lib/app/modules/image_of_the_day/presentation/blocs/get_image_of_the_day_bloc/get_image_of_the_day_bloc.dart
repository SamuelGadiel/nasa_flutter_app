import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nasa_app/app/modules/image_of_the_day/domain/failures/date_not_allowed_failure.dart';
import 'package:nasa_app/app/modules/image_of_the_day/domain/failures/image_of_the_day_failure.dart';
import 'package:nasa_app/app/modules/image_of_the_day/domain/usecase/get_image_of_the_day.dart';
import 'package:nasa_app/app/modules/image_of_the_day/presentation/blocs/get_image_of_the_day_bloc/events/get_image_of_the_day_events.dart';
import 'package:nasa_app/app/modules/image_of_the_day/presentation/blocs/get_image_of_the_day_bloc/states/date_not_allowed_failure_state.dart';
import 'package:nasa_app/app/modules/image_of_the_day/presentation/blocs/get_image_of_the_day_bloc/states/get_image_of_the_day_loading_state.dart';
import 'package:nasa_app/app/modules/image_of_the_day/presentation/blocs/get_image_of_the_day_bloc/states/get_image_of_the_day_states.dart';
import 'package:nasa_app/app/modules/image_of_the_day/presentation/blocs/get_image_of_the_day_bloc/states/get_image_of_the_day_success_state.dart';
import 'package:nasa_app/app/modules/image_of_the_day/presentation/blocs/get_image_of_the_day_bloc/states/image_of_the_day_failure_state.dart';

import 'events/get_image_of_the_day_event.dart';

class GetImageOfTheDayBloc extends Bloc<GetImageOfTheDayEvents, GetImageOfTheDayStates> {
  final GetImageOfTheDay usecase;

  GetImageOfTheDayBloc(this.usecase) : super(GetImageOfTheDayLoadingState()) {
    on<GetImageOfTheDayEvent>(_mapGetImageOfTheDayEventToState);
  }

  void _mapGetImageOfTheDayEventToState(GetImageOfTheDayEvent event, Emitter<GetImageOfTheDayStates> emit) async {
    emit(GetImageOfTheDayLoadingState());

    final result = await usecase(event.parameters);

    result.fold(
      (l) {
        switch (l.runtimeType) {
          case DateNotAllowedFailure:
            emit(DateNotAllowedFailureState(l as DateNotAllowedFailure));
            break;
          case ImageOfTheDayFailure:
            emit(ImageOfTheDayFailureState(l as ImageOfTheDayFailure));
            break;
        }
      },
      (r) => emit(GetImageOfTheDaySuccessState(r)),
    );
  }
}
