import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../state/character_form_controller.dart';
import '../state/step_progress.dart';
import 'sections/action_bar.dart';
import 'sections/summary_sidebar.dart';
import 'steps/history_step.dart';
import 'steps/power_suite_step.dart';
import 'steps/profile_step.dart';

class CharacterSheetPage extends StatefulWidget {
  const CharacterSheetPage({super.key});

  @override
  State<CharacterSheetPage> createState() => _CharacterSheetPageState();
}

class _CharacterSheetPageState extends State<CharacterSheetPage> {
  int _currentStep = 0;

  void _goToStep(int index) {
    setState(() {
      _currentStep = index.clamp(0, kStepTitles.length - 1);
    });
  }

  StepState _stepStateFor(int index, CharacterFormValidation validation) {
    final complete = isStepComplete(index, validation);
    final hasError = stepHasError(index, validation);

    if (complete) {
      return StepState.complete;
    }

    if (hasError && index != _currentStep) {
      return StepState.error;
    }

    return index == _currentStep ? StepState.editing : StepState.indexed;
  }

  void _handleNext(
    CharacterFormController controller,
    CharacterFormValidation validation,
  ) {
    final isLastStep = _currentStep == kStepTitles.length - 1;
    final stepComplete = isStepComplete(_currentStep, validation);

    if (!stepComplete) {
      _showSnack('Complete required fields in  before proceeding.');
      return;
    }

    if (!isLastStep) {
      setState(() => _currentStep += 1);
      return;
    }

    if (controller.isValid) {
      _showSnack(
        'All steps complete. Use Save or Export to persist this dossier.',
      );
    } else {
      _showSnack('Resolve remaining validation items before saving.');
    }
  }

  void _handlePrevious() {
    if (_currentStep == 0) {
      return;
    }
    setState(() => _currentStep -= 1);
  }

  void _handleStepTapped(int index) {
    if (index == _currentStep) {
      return;
    }
    _goToStep(index);
  }

  void _showSnack(String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  List<Step> _buildSteps(CharacterFormValidation validation) {
    return [
      Step(
        title: Text(kStepTitles[0]),
        state: _stepStateFor(0, validation),
        isActive: _currentStep >= 0,
        content: const ProfileStep(),
      ),
      Step(
        title: Text(kStepTitles[1]),
        state: _stepStateFor(1, validation),
        isActive: _currentStep >= 1,
        content: const PowerSuiteStep(),
      ),
      Step(
        title: Text(kStepTitles[2]),
        state: _stepStateFor(2, validation),
        isActive: _currentStep >= 2,
        content: const HistoryStep(),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Essence Character Forge'),
        backgroundColor: theme.colorScheme.surfaceContainerHighest,
        elevation: 1,
      ),
      body: SafeArea(
        child: Consumer<CharacterFormController>(
          builder: (context, controller, _) {
            final validation = controller.validation;
            final steps = _buildSteps(validation);
            final stepProgress = buildStepProgress(validation);

            final stepper = Card(
              margin: EdgeInsets.zero,
              elevation: 1,
              child: Stepper(
                type: StepperType.vertical,
                currentStep: _currentStep,
                onStepTapped: _handleStepTapped,
                controlsBuilder: (context, _) => const SizedBox.shrink(),
                steps: steps,
              ),
            );

            final summary = SummarySidebar(stepProgress: stepProgress);

            return LayoutBuilder(
              builder: (context, constraints) {
                final isWide = constraints.maxWidth >= 1100;
                if (isWide) {
                  return Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: SingleChildScrollView(
                          padding: const EdgeInsets.fromLTRB(24, 24, 24, 120),
                          child: stepper,
                        ),
                      ),
                      const SizedBox(width: 24),
                      SizedBox(
                        width: 360,
                        child: SingleChildScrollView(
                          padding: const EdgeInsets.fromLTRB(0, 24, 24, 120),
                          child: summary,
                        ),
                      ),
                    ],
                  );
                }

                return SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 160),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [stepper, const SizedBox(height: 16), summary],
                  ),
                );
              },
            );
          },
        ),
      ),
      bottomNavigationBar: Consumer<CharacterFormController>(
        builder: (context, controller, _) {
          final validation = controller.validation;
          final stepProgress = buildStepProgress(validation);
          return CharacterActionBar(
            currentStep: _currentStep,
            stepProgress: stepProgress,
            onNext: () => _handleNext(controller, validation),
            onPrevious: _handlePrevious,
            onJumpTo: _goToStep,
          );
        },
      ),
    );
  }
}
