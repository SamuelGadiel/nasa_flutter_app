import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:intl/intl.dart';

import '../../../../core/helpers/error_dialog.dart';
import '../blocs/get_image_of_the_day_bloc/events/catch_loading_image_error_event.dart';
import '../blocs/get_image_of_the_day_bloc/events/get_image_of_the_day_event.dart';
import '../blocs/get_image_of_the_day_bloc/events/select_date_event.dart';
import '../blocs/get_image_of_the_day_bloc/image_of_the_day_bloc.dart';
import '../blocs/get_image_of_the_day_bloc/states/failure_states/date_not_allowed_failure_state.dart';
import '../blocs/get_image_of_the_day_bloc/states/failure_states/image_of_the_day_failure_state.dart';
import '../blocs/get_image_of_the_day_bloc/states/failure_states/image_of_the_day_failure_states.dart';
import '../blocs/get_image_of_the_day_bloc/states/get_image_of_the_day_loading_state.dart';
import '../blocs/get_image_of_the_day_bloc/states/image_of_the_day_states.dart';

class ImageOfTheDayPage extends StatefulWidget {
  const ImageOfTheDayPage({super.key});

  @override
  State<ImageOfTheDayPage> createState() => _ImageOfTheDayPageState();
}

class _ImageOfTheDayPageState extends State<ImageOfTheDayPage> {
  final getImageOfTheDayBloc = Modular.get<ImageOfTheDayBloc>();

  @override
  void initState() {
    getImageOfTheDayBloc.add(GetImageOfTheDayEvent(date: ''));

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Nasa image of the day'),
        centerTitle: true,
      ),
      body: Center(
        child: BlocConsumer<ImageOfTheDayBloc, ImageOfTheDayStates>(
          bloc: getImageOfTheDayBloc,
          listener: (context, state) {
            if (state is ImageOfTheDayFailureStates) {
              VoidCallback? callback;

              if (state is ImageOfTheDayFailureState) {
                callback = () => getImageOfTheDayBloc.add(GetImageOfTheDayEvent(date: ''));
              }

              ErrorDialog.show(
                context: context,
                message: state.failure.message,
                onPressed: callback,
              );
            }
          },
          builder: (context, state) {
            if (state is GetImageOfTheDayLoadingState) {
              return const CircularProgressIndicator();
            }

            if (state is ImageOfTheDayFailureState) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(state.failure.message),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => getImageOfTheDayBloc.add(GetImageOfTheDayEvent(date: '')),
                    child: const Text('Tentar novamente'),
                  ),
                ],
              );
            }

            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: CachedNetworkImage(
                    imageUrl: getImageOfTheDayBloc.imageOfTheDay.image,
                    errorWidget: (context, url, error) {
                      getImageOfTheDayBloc.add(CatchLoadingImageErrorEvent());
                      return const SizedBox();
                    },
                    progressIndicatorBuilder: (context, url, progress) {
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text('Carregando'),
                          Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: LinearProgressIndicator(value: progress.progress),
                          ),
                        ],
                      );
                    },
                    imageBuilder: (context, imageProvider) {
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Visibility(
                            visible: state is! DateNotAllowedFailureState,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 8),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(14),
                                child: Image(image: imageProvider),
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: 90,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        blurRadius: 14,
                        offset: const Offset(0, 2),
                        color: Colors.grey.shade400,
                      )
                    ],
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Text(
                        DateFormat('dd/MM/yyyy').format(getImageOfTheDayBloc.selectedDate),
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                      ),
                      ElevatedButton(
                        onPressed: () async {
                          final date = await showDatePicker(
                            context: context,
                            initialDate: getImageOfTheDayBloc.selectedDate,
                            firstDate: DateTime(1900),
                            lastDate: DateTime.now(),
                          );

                          if (date != null) {
                            getImageOfTheDayBloc
                              ..add(SelectDateEvent(date))
                              ..add(GetImageOfTheDayEvent(date: DateFormat('yyyy-MM-dd').format(date)));
                          }
                        },
                        child: const Text('Selecionar data'),
                      )
                    ],
                  ),
                )
              ],
            );
          },
        ),
      ),
    );
  }
}
