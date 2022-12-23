import 'package:dartz/dartz.dart';

import '../../../../core/failures/failure.dart';
import '../entities/image_of_the_day.dart';
import '../entities/image_of_the_day_parameters.dart';

abstract class ImageOfTheDayRepository {
  Future<Either<Failure, ImageOfTheDay>> call(ImageOfTheDayParameters parameters);
}
