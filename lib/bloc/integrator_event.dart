abstract class IntegratorEvent {}

class InitializeProjectEvent extends IntegratorEvent {}

class AddPackageEvent extends IntegratorEvent {
  final String packageName;
  final String filePath;
  AddPackageEvent(this.packageName, this.filePath);
}

class ConfigureAndroidEvent extends IntegratorEvent {
  final String projectPath;
  ConfigureAndroidEvent(this.projectPath);
}

class ConfigureIOSEvent extends IntegratorEvent {
  final String projectPath;
  ConfigureIOSEvent(this.projectPath);
}

class GenerateExampleEvent extends IntegratorEvent {
  final String projectPath;
  GenerateExampleEvent(this.projectPath);
}
class RunFullIntegrationEvent extends IntegratorEvent {
  final String projectPath;
  RunFullIntegrationEvent(this.projectPath);
}
// In integrator_event.dart
class ShowApiKeyDialogEvent extends IntegratorEvent {
  final String projectPath;
  ShowApiKeyDialogEvent(this.projectPath);
}

class ConfirmApiKeysEvent extends IntegratorEvent {
  final String projectPath;
  final bool configureKeys;
  final String? androidKey;
  final String? iosKey;

  ConfirmApiKeysEvent({
    required this.projectPath,
    required this.configureKeys,
    this.androidKey,
    this.iosKey,
  });
}