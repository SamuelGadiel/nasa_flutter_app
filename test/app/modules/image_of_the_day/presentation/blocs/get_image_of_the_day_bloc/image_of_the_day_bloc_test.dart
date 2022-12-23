import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:nasa_app/app/modules/image_of_the_day/domain/entities/image_of_the_day.dart';
import 'package:nasa_app/app/modules/image_of_the_day/domain/entities/image_of_the_day_parameters.dart';
import 'package:nasa_app/app/modules/image_of_the_day/domain/failures/date_not_allowed_failure.dart';
import 'package:nasa_app/app/modules/image_of_the_day/domain/failures/image_of_the_day_failure.dart';
import 'package:nasa_app/app/modules/image_of_the_day/domain/usecase/get_image_of_the_day.dart';
import 'package:nasa_app/app/modules/image_of_the_day/presentation/blocs/get_image_of_the_day_bloc/events/catch_loading_image_error_event.dart';
import 'package:nasa_app/app/modules/image_of_the_day/presentation/blocs/get_image_of_the_day_bloc/events/get_image_of_the_day_event.dart';
import 'package:nasa_app/app/modules/image_of_the_day/presentation/blocs/get_image_of_the_day_bloc/events/select_date_event.dart';
import 'package:nasa_app/app/modules/image_of_the_day/presentation/blocs/get_image_of_the_day_bloc/image_of_the_day_bloc.dart';
import 'package:nasa_app/app/modules/image_of_the_day/presentation/blocs/get_image_of_the_day_bloc/states/failure_states/date_not_allowed_failure_state.dart';
import 'package:nasa_app/app/modules/image_of_the_day/presentation/blocs/get_image_of_the_day_bloc/states/failure_states/image_of_the_day_failure_state.dart';
import 'package:nasa_app/app/modules/image_of_the_day/presentation/blocs/get_image_of_the_day_bloc/states/get_image_of_the_day_loading_state.dart';
import 'package:nasa_app/app/modules/image_of_the_day/presentation/blocs/get_image_of_the_day_bloc/states/get_image_of_the_day_success_state.dart';
import 'package:nasa_app/app/modules/image_of_the_day/presentation/blocs/get_image_of_the_day_bloc/states/select_date_loading_state.dart';
import 'package:nasa_app/app/modules/image_of_the_day/presentation/blocs/get_image_of_the_day_bloc/states/select_date_success_state.dart';

class GetImageOfTheDayMock extends Mock implements GetImageOfTheDay {}

class ImageOfTheDayParametersFake extends Fake implements ImageOfTheDayParameters {}

class ImageOfTheDayFake extends Fake implements ImageOfTheDay {}

void main() {
  final usecase = GetImageOfTheDayMock();
  final bloc = ImageOfTheDayBloc(usecase);

  setUp(() {
    registerFallbackValue(ImageOfTheDayParametersFake());
  });

  const parameters = '2022-05-27';
  final datetime = DateTime(2022);

  group('Get image of the day - ', () {
    test('Must emit all states in order on success', () {
      when(() => usecase(any())).thenAnswer((invocation) async => Right(ImageOfTheDayFake()));

      bloc.add(GetImageOfTheDayEvent(date: parameters));

      expect(
        bloc.stream,
        emitsInOrder([
          isA<GetImageOfTheDayLoadingState>(),
          isA<GetImageOfTheDaySuccessState>(),
        ]),
      );
    });

    test('Must emit all states in order on DateNotAllowedFailure failure', () {
      when(() => usecase(any())).thenAnswer((invocation) async => Left(DateNotAllowedFailure('')));

      bloc.add(GetImageOfTheDayEvent(date: parameters));

      expect(
        bloc.stream,
        emitsInOrder([
          isA<GetImageOfTheDayLoadingState>(),
          isA<DateNotAllowedFailureState>(),
        ]),
      );
    });

    test('Must emit all states in order on ImageOfTheDayFailure failure', () {
      when(() => usecase(any())).thenAnswer((invocation) async => Left(ImageOfTheDayFailure('')));

      bloc.add(GetImageOfTheDayEvent(date: parameters));

      expect(
        bloc.stream,
        emitsInOrder([
          isA<GetImageOfTheDayLoadingState>(),
          isA<ImageOfTheDayFailureState>(),
        ]),
      );
    });
  });

  group('Select Date - ', () {
    test('Must emit all states in order on success', () {
      bloc.add(SelectDateEvent(datetime));

      expect(
        bloc.stream,
        emitsInOrder([
          isA<SelectDateLoadingState>(),
          isA<SelectDateSuccessState>(),
        ]),
      );
    });
  });

  group('Catch Loading Image Error - ', () {
    test('Must emit all states in order on success', () {
      bloc.add(CatchLoadingImageErrorEvent());

      expect(
        bloc.stream,
        emitsInOrder([
          isA<SelectDateLoadingState>(),
          isA<ImageOfTheDayFailureState>(),
        ]),
      );
    });
  });

  test('Must dispose bloc', () async {
    await bloc.dispose();

    expect(bloc.isClosed, true);
  });
}
