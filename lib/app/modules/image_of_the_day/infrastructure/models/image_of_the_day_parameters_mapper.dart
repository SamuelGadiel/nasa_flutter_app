import '../../domain/entities/image_of_the_day_parameters.dart';

class ImageOfTheDayParametersMapper {
  static Map<String, dynamic> toJson(ImageOfTheDayParameters parameters, String apiKey) {
    return {
      'api_key': apiKey,
      'date': parameters.date,
    };
  }
}
