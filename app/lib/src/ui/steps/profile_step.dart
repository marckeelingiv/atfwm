import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/character_models.dart';
import '../../state/character_form_controller.dart';
import '../../utils/text_formatters.dart';
import '../widgets/section_card.dart';

class ProfileStep extends StatelessWidget {
  const ProfileStep({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<CharacterFormController>(
      builder: (context, controller, _) {
        final validation = controller.validation;
        final data = controller.data;

        return SingleChildScrollView(
          padding: const EdgeInsets.only(bottom: 48),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SectionCard(
                title: 'Identity Profile',
                subtitle: const Text(
                  'Ground the dossier with name, pronouns, and cultural lineage.',
                ),
                child: _IdentityForm(
                  controller: controller,
                  validation: validation,
                  data: data,
                ),
              ),
              const SizedBox(height: 24),
              SectionCard(
                title: 'Race & Essence',
                subtitle: const Text(
                  'Select racial heritage and tune innate essence capacity.',
                ),
                child: _RaceAndEssence(
                  controller: controller,
                  validation: validation,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _IdentityForm extends StatelessWidget {
  const _IdentityForm({
    required this.controller,
    required this.validation,
    required this.data,
  });

  final CharacterFormController controller;
  final CharacterFormValidation validation;
  final CharacterFormData data;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isWide = constraints.maxWidth >= 680;
        final fieldSpacing = isWide ? 20.0 : 16.0;
        final displayNameError = validation.messageFor(
          CharacterFormField.displayName,
        );
        final pronounError = validation.messageFor(CharacterFormField.pronouns);
        final lineageError = validation.messageFor(CharacterFormField.lineage);

        Widget buildTextField({
          required String fieldKey,
          required String label,
          String? hint,
          String? errorText,
          required String value,
          required ValueChanged<String> onChanged,
          TextInputAction action = TextInputAction.next,
        }) {
          return TextFormField(
            key: ValueKey<String>('profile-$fieldKey-$value'),
            initialValue: value,
            onChanged: onChanged,
            textInputAction: action,
            autocorrect: true,
            decoration: InputDecoration(
              labelText: label,
              hintText: hint,
              errorText: errorText,
              border: const OutlineInputBorder(),
            ),
          );
        }

        Widget buildDropdown<T>({
          required String label,
          required T? value,
          required Iterable<T> items,
          required Widget Function(T value) itemBuilder,
          required ValueChanged<T?> onChanged,
          String? errorText,
        }) {
          return DropdownButtonFormField<T>(
            value: value,
            decoration: InputDecoration(
              labelText: label,
              errorText: errorText,
              border: const OutlineInputBorder(),
            ),
            items: [
              for (final option in items)
                DropdownMenuItem<T>(value: option, child: itemBuilder(option)),
            ],
            onChanged: onChanged,
          );
        }

        final identityFields = <Widget>[
          buildTextField(
            fieldKey: 'displayName',
            label: 'Codex name',
            hint: 'e.g. Aurora Valen',
            errorText: displayNameError,
            value: data.displayName,
            onChanged: controller.setDisplayName,
          ),
          SizedBox(height: fieldSpacing),
          buildTextField(
            fieldKey: 'callSign',
            label: 'Call sign',
            hint: 'Optional field alias or squad handle',
            value: data.callSign,
            onChanged: controller.setCallSign,
            action: TextInputAction.done,
          ),
        ];

        final metaFields = <Widget>[
          buildDropdown<PronounSet>(
            label: 'Pronouns',
            value: data.pronouns,
            items: controller.pronounSets,
            itemBuilder: (set) => Text(set.label),
            onChanged: controller.selectPronouns,
            errorText: pronounError,
          ),
          SizedBox(height: fieldSpacing),
          buildDropdown<CulturalLineage>(
            label: 'Cultural lineage',
            value: data.lineage,
            items: controller.lineages,
            itemBuilder: (lineage) => Text(lineage.name),
            onChanged: controller.selectLineage,
            errorText: lineageError,
          ),
        ];

        if (isWide) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(child: identityFields[0]),
                  SizedBox(width: fieldSpacing),
                  Expanded(child: identityFields[2]),
                ],
              ),
              SizedBox(height: fieldSpacing),
              Row(
                children: [
                  Expanded(child: metaFields[0]),
                  SizedBox(width: fieldSpacing),
                  Expanded(child: metaFields[2]),
                ],
              ),
            ],
          );
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [...identityFields, ...metaFields],
        );
      },
    );
  }
}

class _RaceAndEssence extends StatelessWidget {
  const _RaceAndEssence({required this.controller, required this.validation});

  final CharacterFormController controller;
  final CharacterFormValidation validation;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final race = controller.data.selectedRace;
    final raceError = validation.messageFor(CharacterFormField.race);
    final lifespanError = validation.messageFor(CharacterFormField.lifespan);
    final raceHelper = race != null
        ? 'Max  abilities | Base lifespan '
              ' centuries'
        : 'Select a race to unlock lineage abilities.';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        DropdownButtonFormField<Race>(
          key: ValueKey(race?.id ?? 'race'),
          value: race,
          decoration: InputDecoration(
            labelText: 'Race',
            helperText: raceHelper,
            errorText: raceError,
            border: const OutlineInputBorder(),
          ),
          items: [
            for (final candidate in controller.races)
              DropdownMenuItem<Race>(
                value: candidate,
                child: Text(candidate.name),
              ),
          ],
          onChanged: controller.selectRace,
        ),
        if (race != null) ...[
          const SizedBox(height: 16),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              Chip(
                avatar: const Icon(Icons.people_alt, size: 18),
                label: Text(enumLabel(race.type.name)),
              ),
              Text(race.description, style: theme.textTheme.bodyMedium),
            ],
          ),
        ],
        const SizedBox(height: 20),
        SwitchListTile.adaptive(
          contentPadding: EdgeInsets.zero,
          value: controller.data.hasMagicPowers,
          onChanged: controller.setHasMagicPowers,
          title: const Text('Magic attuned'),
          subtitle: const Text(
            'Toggle if the character actively channels essence.',
          ),
          secondary: const Icon(Icons.auto_awesome),
        ),
        const SizedBox(height: 16),
        _LifespanEditor(
          value: controller.data.centuriesLifespan,
          onChanged: controller.setCenturiesLifespan,
          errorText: lifespanError,
        ),
      ],
    );
  }
}

class _LifespanEditor extends StatelessWidget {
  const _LifespanEditor({
    required this.value,
    required this.onChanged,
    this.errorText,
  });

  final int value;
  final ValueChanged<int> onChanged;
  final String? errorText;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Lifespan (centuries)', style: theme.textTheme.titleSmall),
        const SizedBox(height: 8),
        Row(
          children: [
            _LifespanControlButton(
              icon: Icons.remove,
              onTap: value > 0 ? () => onChanged(value - 1) : null,
            ),
            SizedBox(
              width: 72,
              child: Center(
                child: Text(
                  value.toString(),
                  style: theme.textTheme.headlineSmall,
                ),
              ),
            ),
            _LifespanControlButton(
              icon: Icons.add,
              onTap: () => onChanged(value + 1),
            ),
          ],
        ),
        if (errorText != null) ...[
          const SizedBox(height: 8),
          Text(
            errorText!,
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.error,
            ),
          ),
        ],
      ],
    );
  }
}

class _LifespanControlButton extends StatelessWidget {
  const _LifespanControlButton({required this.icon, this.onTap});

  final IconData icon;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 40,
      height: 40,
      child: OutlinedButton(
        onPressed: onTap,
        style: OutlinedButton.styleFrom(padding: EdgeInsets.zero),
        child: Icon(icon, size: 20),
      ),
    );
  }
}
