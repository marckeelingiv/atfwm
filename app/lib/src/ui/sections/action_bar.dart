import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../state/character_form_controller.dart';
import '../../state/step_progress.dart';

class CharacterActionBar extends StatelessWidget {
  const CharacterActionBar({
    super.key,
    required this.currentStep,
    required this.stepProgress,
    required this.onNext,
    required this.onPrevious,
    required this.onJumpTo,
  });

  final int currentStep;
  final List<StepProgress> stepProgress;
  final VoidCallback onNext;
  final VoidCallback onPrevious;
  final ValueChanged<int> onJumpTo;

  @override
  Widget build(BuildContext context) {
    return Consumer<CharacterFormController>(
      builder: (context, controller, _) {
        final theme = Theme.of(context);
        final isLastStep = currentStep == stepProgress.length - 1;
        final current = stepProgress[currentStep];
        final stepReady = current.complete;
        final overallValid = controller.isValid;
        final statusText = current.complete
            ? (isLastStep
                  ? (overallValid
                        ? 'All steps complete. Ready to export or save.'
                        : 'Finalise outstanding items before saving.')
                  : 'Step looks good. Continue when ready.')
            : 'Complete required fields in this step.';
        final nextLabel = isLastStep ? 'Finish' : 'Next';

        final buttons = [
          TextButton.icon(
            icon: const Icon(Icons.refresh),
            label: const Text('Reset'),
            onPressed: () {
              controller.reset();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Form reset to defaults.')),
              );
            },
          ),
          OutlinedButton.icon(
            icon: const Icon(Icons.arrow_back),
            label: const Text('Back'),
            onPressed: currentStep == 0 ? null : onPrevious,
          ),
          FilledButton.icon(
            icon: Icon(isLastStep ? Icons.done : Icons.arrow_forward),
            label: Text(nextLabel),
            onPressed: stepReady ? onNext : null,
          ),
          FilledButton.icon(
            icon: const Icon(Icons.save_alt),
            label: const Text('Export JSON'),
            onPressed: overallValid
                ? () => _showExportDialog(context, controller)
                : null,
          ),
          ElevatedButton.icon(
            icon: const Icon(Icons.save),
            label: const Text('Save'),
            onPressed: overallValid
                ? () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                          'Save integration pending backend hookup.',
                        ),
                      ),
                    );
                  }
                : null,
          ),
        ];

        return Container(
          color: theme.colorScheme.surface,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          child: LayoutBuilder(
            builder: (context, constraints) {
              final compact = constraints.maxWidth < 720;
              final stepChips = Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  for (var i = 0; i < stepProgress.length; i++)
                    _StepChip(
                      progress: stepProgress[i],
                      index: i,
                      isCurrent: i == currentStep,
                      onTap: () => onJumpTo(i),
                    ),
                ],
              );

              if (compact) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    stepChips,
                    const SizedBox(height: 12),
                    Text(statusText, style: theme.textTheme.bodyMedium),
                    const SizedBox(height: 12),
                    Align(
                      alignment: Alignment.centerRight,
                      child: Wrap(
                        spacing: 12,
                        runSpacing: 8,
                        alignment: WrapAlignment.end,
                        children: buttons,
                      ),
                    ),
                  ],
                );
              }

              return Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        stepChips,
                        const SizedBox(height: 8),
                        Text(statusText, style: theme.textTheme.bodyMedium),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),
                  Wrap(
                    spacing: 12,
                    runSpacing: 8,
                    alignment: WrapAlignment.end,
                    children: buttons,
                  ),
                ],
              );
            },
          ),
        );
      },
    );
  }

  static Future<void> _showExportDialog(
    BuildContext context,
    CharacterFormController controller,
  ) async {
    final json = const JsonEncoder.withIndent(
      '  ',
    ).convert(controller.toJson());
    await showDialog<void>(
      context: context,
      builder: (context) {
        final theme = Theme.of(context);
        return AlertDialog(
          title: const Text('Character JSON Preview'),
          content: SizedBox(
            width: 500,
            child: SingleChildScrollView(
              child: SelectableText(
                json,
                style: theme.textTheme.bodySmall?.copyWith(
                  fontFamily: 'Courier New',
                ),
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }
}

class _StepChip extends StatelessWidget {
  const _StepChip({
    required this.progress,
    required this.index,
    required this.isCurrent,
    required this.onTap,
  });

  final StepProgress progress;
  final int index;
  final bool isCurrent;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    Color? background;
    Color? foreground;
    IconData icon;

    if (progress.complete) {
      background = theme.colorScheme.secondaryContainer;
      foreground = theme.colorScheme.onSecondaryContainer;
      icon = Icons.check;
    } else if (isCurrent) {
      background = theme.colorScheme.primaryContainer;
      foreground = theme.colorScheme.onPrimaryContainer;
      icon = Icons.edit;
    } else if (progress.hasError) {
      background = theme.colorScheme.errorContainer;
      foreground = theme.colorScheme.onErrorContainer;
      icon = Icons.error_outline;
    } else {
      background = theme.colorScheme.surfaceContainerHighest;
      foreground = theme.colorScheme.onSurfaceVariant;
      icon = Icons.radio_button_unchecked;
    }

    return ActionChip(
      avatar: Icon(icon, size: 18, color: foreground),
      label: Text(progress.title, style: TextStyle(color: foreground)),
      backgroundColor: background,
      onPressed: onTap,
    );
  }
}
