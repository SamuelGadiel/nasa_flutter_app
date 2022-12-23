import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_modular/flutter_modular.dart';

import '../../../domain/entities/image_of_the_day.dart';
import '../../../domain/entities/image_of_the_day_parameters.dart';
import '../../../domain/failures/date_not_allowed_failure.dart';
import '../../../domain/failures/image_of_the_day_failure.dart';
import '../../../domain/usecase/get_image_of_the_day.dart';
import 'events/catch_loading_image_error_event.dart';
import 'events/get_image_of_the_day_event.dart';
import 'events/image_of_the_day_events.dart';
import 'events/select_date_event.dart';
import 'states/failure_states/date_not_allowed_failure_state.dart';
import 'states/failure_states/image_of_the_day_failure_state.dart';
import 'states/get_image_of_the_day_loading_state.dart';
import 'states/get_image_of_the_day_success_state.dart';
import 'states/image_of_the_day_states.dart';
import 'states/select_date_loading_state.dart';
import 'states/select_date_success_state.dart';

class ImageOfTheDayBloc extends Bloc<ImageOfTheDayEvents, ImageOfTheDayStates> implements Disposable {
  final GetImageOfTheDay usecase;

  ImageOfTheDayBloc(this.usecase) : super(const GetImageOfTheDayLoadingState()) {
    on<GetImageOfTheDayEvent>(_mapGetImageOfTheDayEventToState);
    on<SelectDateEvent>(_mapSelectDateEventToState);
    on<CatchLoadingImageErrorEvent>(_mapCatchLoadingImageErrorEventToState);
  }

  DateTime selectedDate = DateTime.now();

  ImageOfTheDay imageOfTheDay = ImageOfTheDay(
    copyright: '',
    date: '',
    description: '',
    image: '',
    mediaType: '',
    title: '',
  );

  @override
  Future<void> dispose() async => await close();

  Future<void> _mapGetImageOfTheDayEventToState(GetImageOfTheDayEvent event, Emitter<ImageOfTheDayStates> emit) async {
    emit(const GetImageOfTheDayLoadingState());

    final result = await usecase(ImageOfTheDayParameters(date: event.date));

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
      (r) {
        imageOfTheDay = r;
        emit(GetImageOfTheDaySuccessState(r));
      },
    );
  }

  void _mapSelectDateEventToState(SelectDateEvent event, Emitter<ImageOfTheDayStates> emit) {
    emit(SelectDateLoadingState());

    selectedDate = event.date;

    emit(SelectDateSuccessState());
  }

  void _mapCatchLoadingImageErrorEventToState(CatchLoadingImageErrorEvent event, Emitter<ImageOfTheDayStates> emit) {
    emit(SelectDateLoadingState());

    emit(ImageOfTheDayFailureState(ImageOfTheDayFailure('Ocorreu um erro ao carregar a imagem.')));
  }
}
