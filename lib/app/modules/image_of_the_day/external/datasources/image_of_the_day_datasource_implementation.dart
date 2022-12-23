import 'package:dio/dio.dart';

import '../../../../../secrets.dart';
import '../../../../core/config/config.dart';
import '../../domain/entities/image_of_the_day.dart';
import '../../domain/entities/image_of_the_day_parameters.dart';
import '../../infrastructure/datasources/image_of_the_day_datasources.dart';
import '../../infrastructure/errors/date_not_allowed_datasource_error.dart';
import '../../infrastructure/errors/image_of_the_day_datasource_error.dart';
import '../../infrastructure/models/image_of_the_day_model.dart';
import '../../infrastructure/models/image_of_the_day_parameters_mapper.dart';
import '../settings/image_of_the_day_settings.dart';

class ImageOfTheDayDatasourceImplementation implements ImageOfTheDayDatasource {
  final Dio dio;

  ImageOfTheDayDatasourceImplementation(this.dio);

  @override
  Future<ImageOfTheDay> call(ImageOfTheDayParameters parameters) async {
    final result = await dio.get(
      '${Config.baseUrl}${ImageOfTheDaySettings.endpoint}',
      queryParameters: ImageOfTheDayParametersMapper.toJson(parameters, Secrets.apiKey),
      options: Options(validateStatus: (status) => true),
    );

    if (result.statusCode == 200) {
      return ImageOfTheDayModel.fromJson(result.data);
    } else if (result.statusCode == 400) {
      throw DateNotAllowedDatasourceError(result.data['msg'] ?? 'Data não permitida');
    } else {
      throw ImageOfTheDayDatasourceError('Erro ao buscar a imagem');
    }
  }
}
