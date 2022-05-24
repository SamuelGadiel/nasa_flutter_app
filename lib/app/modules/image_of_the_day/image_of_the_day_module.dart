import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

class ImageOfTheDayModule extends Module {
  @override
  final List<Bind> binds = [];

  @override
  final List<ModularRoute> routes = [
    ChildRoute("/", child: (context, args) => SizedBox()),
  ];
}
