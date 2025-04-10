
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/integrator_bloc.dart';
import '../bloc/integrator_state.dart';

class IntegrationProgress extends StatelessWidget {
  const IntegrationProgress({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<IntegratorBloc, IntegratorState>(
      builder: (context, state) {
        if (state is! IntegrationProgressState) return const SizedBox();

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (state.currentStep != null)
              Text('Current: ${state.currentStep}',
                  style: TextStyle(color: Colors.blue[800])),

            const SizedBox(height: 16),
            const Text('Completed Steps:'),
            ...state.completedSteps.map((step) => Row(
              children: [
                const Icon(Icons.check_circle, color: Colors.green),
                const SizedBox(width: 8),
                Text(step),
              ],
            )),

            if (state.isComplete)
              const Padding(
                padding: EdgeInsets.only(top: 16),
                child: Text('✅ Integration Complete!',
                    style: TextStyle(fontWeight: FontWeight.bold)),
              ),
          ],
        );
      },
    );
  }
}