import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:intl/intl.dart';
import 'package:nasa_app/app/modules/image_of_the_day/domain/entities/image_of_the_day_parameters.dart';
import 'package:nasa_app/app/modules/image_of_the_day/presentation/blocs/get_image_of_the_day_bloc/events/get_image_of_the_day_event.dart';
import 'package:nasa_app/app/modules/image_of_the_day/presentation/blocs/get_image_of_the_day_bloc/events/get_image_of_the_day_events.dart';
import 'package:nasa_app/app/modules/image_of_the_day/presentation/blocs/get_image_of_the_day_bloc/events/select_date_event.dart';
import 'package:nasa_app/app/modules/image_of_the_day/presentation/blocs/get_image_of_the_day_bloc/get_image_of_the_day_bloc.dart';
import 'package:nasa_app/app/modules/image_of_the_day/presentation/blocs/get_image_of_the_day_bloc/states/date_not_allowed_failure_state.dart';
import 'package:nasa_app/app/modules/image_of_the_day/presentation/blocs/get_image_of_the_day_bloc/states/get_image_of_the_day_loading_state.dart';
import 'package:nasa_app/app/modules/image_of_the_day/presentation/blocs/get_image_of_the_day_bloc/states/get_image_of_the_day_states.dart';
import 'package:nasa_app/app/modules/image_of_the_day/presentation/blocs/get_image_of_the_day_bloc/states/get_image_of_the_day_success_state.dart';
import 'package:nasa_app/app/modules/image_of_the_day/presentation/blocs/get_image_of_the_day_bloc/states/image_of_the_day_failure_state.dart';

class ImageOfTheDayPage extends StatefulWidget {
  const ImageOfTheDayPage({Key? key}) : super(key: key);

  @override
  State<ImageOfTheDayPage> createState() => _ImageOfTheDayPageState();
}

class _ImageOfTheDayPageState extends State<ImageOfTheDayPage> {
  final getImageOfTheDayBloc = Modular.get<GetImageOfTheDayBloc>();

  @override
  void initState() {
    super.initState();
    getImageOfTheDayBloc.add(GetImageOfTheDayEvent(ImageOfTheDayParameters(date: '')));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Nasa app"),
        centerTitle: true,
      ),
      body: Center(
        child: BlocConsumer<GetImageOfTheDayBloc, GetImageOfTheDayStates>(
          bloc: getImageOfTheDayBloc,
          listener: (context, state) {
            if (state is ImageOfTheDayFailureState) {
              showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: Text('Erro'),
                    content: Text(state.failure.message),
                    actions: [
                      TextButton(
                        onPressed: () {
                          getImageOfTheDayBloc.add(GetImageOfTheDayEvent(ImageOfTheDayParameters(date: '')));
                          Modular.to.pop();
                        },
                        child: Text('Tentar novamente'),
                      ),
                      TextButton(
                        onPressed: () => Modular.to.pop(),
                        child: Text('Fechar'),
                      ),
                    ],
                  );
                },
              );
            } else if (state is DateNotAllowedFailureState) {
              showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: Text('Erro'),
                    content: Text(state.failure.message),
                    actions: [
                      TextButton(
                        onPressed: () => Modular.to.pop(),
                        child: Text('Fechar'),
                      ),
                    ],
                  );
                },
              );
            }
          },
          builder: (context, state) {
            if (state is GetImageOfTheDayLoadingState) {
              return CircularProgressIndicator();
            } else if (state is ImageOfTheDayFailureState) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Deu pau, clica ae pra tentar de novo!'),
                  SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      getImageOfTheDayBloc.add(GetImageOfTheDayEvent(ImageOfTheDayParameters(date: '')));
                    },
                    child: Text('Tentar novamente'),
                  ),
                ],
              );
            }

            return Image.network(
              getImageOfTheDayBloc.imageOfTheDay.image,
              errorBuilder: (context, error, stackTrace) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.error, color: Colors.red, size: 48),
                    Text(
                      'Ocorreu algum erro :(',
                      style: TextStyle(color: Colors.red, fontSize: 22),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 16),
                      child: ElevatedButton(
                        onPressed: () {
                          getImageOfTheDayBloc.add(GetImageOfTheDayEvent(ImageOfTheDayParameters(date: '')));
                        },
                        child: Text('Recarregar'),
                      ),
                    ),
                  ],
                );
              },
              loadingBuilder: (context, child, progress) {
                if (progress == null) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        onPressed: () async {
                          final date = await showDatePicker(
                            context: context,
                            initialDate: getImageOfTheDayBloc.selectedDate,
                            firstDate: DateTime(1900),
                            lastDate: DateTime.now(),
                          );

                          if (date != null) {
                            getImageOfTheDayBloc.add(SelectDateEvent(date));

                            getImageOfTheDayBloc.add(
                              GetImageOfTheDayEvent(
                                ImageOfTheDayParameters(date: DateFormat('yyyy-MM-dd').format(date)),
                              ),
                            );
                          }
                        },
                        child: Text('Selecione uma data'),
                      ),
                      Text('Data: ${DateFormat('dd/MM/yyyy').format(getImageOfTheDayBloc.selectedDate)}'),
                      Visibility(
                        visible: !(state is DateNotAllowedFailureState),
                        child: child,
                      ),
                    ],
                  );
                }

                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Carregando'),
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: LinearProgressIndicator(value: progress.cumulativeBytesLoaded / progress.expectedTotalBytes!),
                    ),
                  ],
                );
              },
            );
          },
        ),
      ),
    );
  }
}
