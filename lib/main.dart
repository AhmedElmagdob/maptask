import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'bloc/integrator_bloc.dart';
import 'bloc/integrator_event.dart';
import 'bloc/integrator_state.dart';
import 'widgets/api_key_dialog.dart';
import 'widgets/integration_progress.dart';

void main() {
  runApp(
    BlocProvider(
      create: (context) => IntegratorBloc(),
      child: const PackageIntegratorApp(),
    ),
  );
}

class PackageIntegratorApp extends StatelessWidget {
  const PackageIntegratorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Package Integrator',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const IntegrationScreen(),
    );
  }
}

class IntegrationScreen extends StatelessWidget {
  const IntegrationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Google Maps Integration'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Project Selection
            BlocBuilder<IntegratorBloc, IntegratorState>(
              builder: (context, state) {
                return ElevatedButton(
                  onPressed: () => context.read<IntegratorBloc>().add(
                    InitializeProjectEvent(),
                  ),
                  child: const Text('Select Flutter Project'),
                );
              },
            ),

            const SizedBox(height: 20),

            // Main Integration Controls
            BlocConsumer<IntegratorBloc, IntegratorState>(
              listener: (context, state) {
                if (state is ApiKeyPromptState) {
                  showDialog(
                    context: context,
                    builder: (_) => BlocProvider.value(
                      value: context.read<IntegratorBloc>(),
                      child: ApiKeyDialog(projectPath: state.projectPath),
                    ),
                  );
                }
              },
              builder: (context, state) {
                if (state.projectPath == null) {
                  return const Text(
                    'Please select a Flutter project first',
                    textAlign: TextAlign.center,
                  );
                }

                return Column(
                  children: [
                    ElevatedButton(
                      onPressed: () => context.read<IntegratorBloc>().add(
                        ShowApiKeyDialogEvent(state.projectPath!),
                      ),
                      child: const Text('Run Full Integration'),
                    ),
                    const SizedBox(height: 20),
                    const IntegrationProgress(),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}