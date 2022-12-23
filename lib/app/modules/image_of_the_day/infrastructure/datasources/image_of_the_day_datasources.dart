import '../../domain/entities/image_of_the_day.dart';
import '../../domain/entities/image_of_the_day_parameters.dart';

abstract class ImageOfTheDayDatasource {
  Future<ImageOfTheDay> call(ImageOfTheDayParameters parameters);
}
