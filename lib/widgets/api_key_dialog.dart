
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/integrator_bloc.dart';
import '../bloc/integrator_event.dart';

// api_key_dialog.dart
class ApiKeyDialog extends StatelessWidget {
  final String projectPath;

  const ApiKeyDialog({super.key, required this.projectPath});

  @override
  Widget build(BuildContext context) {
    final androidController = TextEditingController();
    final iosController = TextEditingController();

    return AlertDialog(
      title: const Text('Google Maps API Keys'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text('Enter your API keys (or leave blank to skip):'),
          TextField(
            controller: androidController,
            decoration: const InputDecoration(labelText: 'Android API Key'),
          ),
          TextField(
            controller: iosController,
            decoration: const InputDecoration(labelText: 'iOS API Key'),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => _closeDialog(context, false, null, null),
          child: const Text('Skip'),
        ),
        ElevatedButton(
          onPressed: () => _closeDialog(
            context,
            true,
            androidController.text,
            iosController.text,
          ),
          child: const Text('Continue'),
        ),
      ],
    );
  }

  void _closeDialog(
      BuildContext context,
      bool configureKeys,
      String? androidKey,
      String? iosKey,
      ) {
    context.read<IntegratorBloc>().add(
      ConfirmApiKeysEvent(
        projectPath: projectPath,
        configureKeys: configureKeys,
        androidKey: androidKey,
        iosKey: iosKey,
      ),
    );
    Navigator.pop(context);
  }
}