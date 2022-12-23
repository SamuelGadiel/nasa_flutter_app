import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

class ErrorDialog extends StatelessWidget {
  final String message;
  final VoidCallback? onPressed;

  const ErrorDialog({
    required this.message,
    this.onPressed,
    super.key,
  });

  static void show({
    required BuildContext context,
    required String message,
    VoidCallback? onPressed,
  }) {
    showDialog(
      context: context,
      builder: (context) {
        return ErrorDialog(message: message, onPressed: onPressed);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Erro'),
      content: Text(message),
      actions: [
        Visibility(
          visible: onPressed != null,
          child: TextButton(
            onPressed: () {
              onPressed!.call();
              Modular.to.pop();
            },
            child: const Text('Tentar novamente'),
          ),
        ),
        TextButton(
          onPressed: () => Modular.to.pop(),
          child: const Text('Fechar'),
        ),
      ],
    );
  }
}
