// lib/bloc/integrator_state.dart
abstract class IntegratorState {
  final String? projectPath;  // Add this to all states
  const IntegratorState({this.projectPath});
}

class IdleState extends IntegratorState {
  const IdleState() : super();
}

class ProcessingState extends IntegratorState {
  const ProcessingState({super.projectPath});
}

class SuccessState extends IntegratorState {
  final String message;
  const SuccessState(this.message, {super.projectPath});
}

class ErrorState extends IntegratorState {
  final String error;
  const ErrorState(this.error, {super.projectPath});
}
// lib/bloc/integrator_state.dart
class IntegrationProgressState extends IntegratorState {
  final List<String> completedSteps;
  final String? currentStep;
  final bool isComplete;

  const IntegrationProgressState({
    required this.completedSteps,
    this.currentStep,
    this.isComplete = false,
    required String projectPath,
  }) : super(projectPath: projectPath);

  @override
  List<Object?> get props => [completedSteps, currentStep, isComplete, projectPath];
}

class ApiKeyPromptState extends IntegratorState {
  final String projectPath;

  const ApiKeyPromptState(this.projectPath) : super(projectPath: projectPath);
}