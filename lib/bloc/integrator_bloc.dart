import 'dart:io';
import 'package:bloc/bloc.dart';
import '../services/pubspec_service.dart';
import '../services/android_service.dart';
import '../services/ios_service.dart';
import '../services/template_service.dart';
import 'integrator_event.dart';
import 'integrator_state.dart';
import 'package:file_picker/file_picker.dart';

class IntegratorBloc extends Bloc<IntegratorEvent, IntegratorState> {
  IntegratorBloc() : super(IdleState()) {
    on<InitializeProjectEvent>(_initializeProject);
    on<ShowApiKeyDialogEvent>(_onShowApiKeyDialog);
    on<ConfirmApiKeysEvent>(_onConfirmApiKeys);
    on<RunFullIntegrationEvent>(_runFullIntegration);

  }



  Future<void> _initializeProject(
    InitializeProjectEvent event,
    Emitter<IntegratorState> emit,
  ) async {
    emit(ProcessingState());
    try {
      // Open directory picker
      final String? selectedDirectory = await FilePicker.platform
          .getDirectoryPath(dialogTitle: 'Select your Flutter project');

      if (selectedDirectory == null) {
        emit(ErrorState("❌ No directory selected"));
        return;
      }

      // Validate Flutter project
      final pubspecFile = File('$selectedDirectory/pubspec.yaml');
      if (!await pubspecFile.exists()) {
        emit(ErrorState("❌ Not a Flutter project (pubspec.yaml not found)"));
        return;
      }
      emit(SuccessState("✅ Selected project: $selectedDirectory", projectPath: selectedDirectory));
    } catch (e) {
      emit(ErrorState("❌ Failed to pick directory: $e"));
    }
  }
}


Future<void> _runFullIntegration(
    RunFullIntegrationEvent event,
Emitter<IntegratorState> emit,
    ) async {
  final steps = [
    'Adding Package',
    'Configuring Android',
    'Configuring iOS',
    'Generating Example Code',
  ];

  final completedSteps = <String>[];

  // Start progress
  emit(IntegrationProgressState(
    completedSteps: completedSteps,
    currentStep: steps[0],
    projectPath: event.projectPath,
  ));

  try {
    // Step 1: Add Package
    await PubSpecService.addPackage('google_maps_flutter',event.projectPath);
    completedSteps.add(steps[0]);
    emit(IntegrationProgressState(
      completedSteps: completedSteps,
      currentStep: steps[1],
      projectPath:event.projectPath,
    ));

    // Step 2: Configure Android
    await AndroidService.configureGoogleMaps(event.projectPath);
    await AndroidService.updateMinSdkVersion(event.projectPath, 20);
    completedSteps.add(steps[1]);
    emit(IntegrationProgressState(
      completedSteps: completedSteps,
      currentStep: steps[2],
      projectPath: event.projectPath,
    ));

    // Step 3: Configure iOS
    await IOSService.addAPIKeyToAppDelegate(event.projectPath);
    await IOSService.addLocationPermissionToInfoPlist(event.projectPath);
    completedSteps.add(steps[2]);
    emit(IntegrationProgressState(
      completedSteps: completedSteps,
      currentStep: steps[3],
      projectPath: event.projectPath,
    ));

    // Step 4: Generate Example
    await TemplateService.generateBLoCTemplates(event.projectPath);
    await TemplateService.generateMapScreen(event.projectPath);
    completedSteps.add(steps[3]);

    // Final completion
    emit(IntegrationProgressState(
      completedSteps: completedSteps,
      isComplete: true,
      projectPath: event.projectPath,
    ));

  } catch (e) {
    emit(ErrorState("Failed at step: ${completedSteps.length + 1}\nError: $e",
        projectPath: event.projectPath));
  }
}
// In integrator_bloc.dart
Future<void> _onShowApiKeyDialog(
    ShowApiKeyDialogEvent event,
    Emitter<IntegratorState> emit,
    ) async {
  emit(ApiKeyPromptState(event.projectPath));
}

Future<void> _onConfirmApiKeys(
    ConfirmApiKeysEvent event,
    Emitter<IntegratorState> emit,
    ) async {
  if (event.configureKeys) {
    print(event.configureKeys);
    print(event.projectPath);
    print( event.androidKey);
    print( event.iosKey);

    // Update keys if user wants to configure
    await _updateApiKeys(event.projectPath, event.androidKey, event.iosKey);
    await _runFullIntegration(RunFullIntegrationEvent(event.projectPath), emit);
  }
  // Proceed with integration
  await _runFullIntegration(RunFullIntegrationEvent(event.projectPath), emit);
}

Future<void> _updateApiKeys(
    String projectPath,
    String? androidKey,
    String? iosKey,
    ) async {
  if (androidKey != null && androidKey.isNotEmpty) {
    await AndroidService.updateApiKey(projectPath, androidKey);
    print( "done1");
  }

  if (iosKey != null && iosKey.isNotEmpty) {
    await IOSService.updateApiKey(projectPath, iosKey);
    print( "done2");
  }
}
