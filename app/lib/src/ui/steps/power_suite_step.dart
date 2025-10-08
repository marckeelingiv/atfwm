import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/character_models.dart';
import '../../state/character_form_controller.dart';
import '../../utils/text_formatters.dart';
import '../widgets/section_card.dart';

class PowerSuiteStep extends StatelessWidget {
  const PowerSuiteStep({super.key});

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
                title: 'Combat Composition',
                subtitle: const Text('Select stance and primary gear loadout.'),
                child: _CombatComposition(
                  controller: controller,
                  validation: validation,
                  data: data,
                ),
              ),
              const SizedBox(height: 24),
              SectionCard(
                title: 'Technique Matrix',
                subtitle: const Text(
                  'Tag the battle disciplines that define this operative.',
                ),
                child: _TechniqueTags(
                  controller: controller,
                  validation: validation,
                ),
              ),
              const SizedBox(height: 24),
              SectionCard(
                title: 'Racial Toolkit',
                subtitle: const Text(
                  'Curate lineage abilities to complement the role.',
                ),
                child: _RacialAbilities(
                  controller: controller,
                  validation: validation,
                ),
              ),
              const SizedBox(height: 24),
              SectionCard(
                title: 'Rank Progression',
                subtitle: const Text(
                  'Capture current standing and sub-rank momentum.',
                ),
                child: _RankProgression(
                  controller: controller,
                  validation: validation,
                ),
              ),
              const SizedBox(height: 24),
              SectionCard(
                title: 'Ambient Density',
                subtitle: const Text(
                  'Adjust ambient density overrides and examine modifiers.',
                ),
                child: _DensityPanel(
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

class _CombatComposition extends StatelessWidget {
  const _CombatComposition({
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
        final stanceError = validation.messageFor(
          CharacterFormField.combatStance,
        );
        final primaryWeaponError = validation.messageFor(
          CharacterFormField.primaryWeapon,
        );

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

        final stanceField = buildDropdown<CombatStance>(
          label: 'Combat stance',
          value: data.combatStance,
          items: controller.combatStances,
          itemBuilder: (stance) => Text(stance.name),
          onChanged: controller.selectCombatStance,
          errorText: stanceError,
        );

        final primaryWeaponField = buildDropdown<WeaponBlueprint>(
          label: 'Primary weapon',
          value: data.primaryWeapon,
          items: controller.weaponCatalog,
          itemBuilder: (weapon) => Text(weapon.name),
          onChanged: controller.selectPrimaryWeapon,
          errorText: primaryWeaponError,
        );

        final secondaryItems = [
          const DropdownMenuItem<WeaponBlueprint?>(
            value: null,
            child: Text('No secondary'),
          ),
          ...controller.weaponCatalog.map(
            (weapon) => DropdownMenuItem<WeaponBlueprint?>(
              value: weapon,
              child: Text(weapon.name),
            ),
          ),
        ];

        final secondaryWeaponField = DropdownButtonFormField<WeaponBlueprint?>(
          value: data.secondaryWeapon,
          decoration: const InputDecoration(
            labelText: 'Secondary weapon',
            border: OutlineInputBorder(),
          ),
          items: secondaryItems,
          onChanged: controller.selectSecondaryWeapon,
        );

        final fields = <Widget>[
          stanceField,
          SizedBox(height: fieldSpacing),
          primaryWeaponField,
          SizedBox(height: fieldSpacing),
          secondaryWeaponField,
        ];

        Widget buildDescription({required String? text}) {
          if (text == null || text.isEmpty) {
            return const SizedBox.shrink();
          }
          return Padding(
            padding: const EdgeInsets.only(top: 12),
            child: Text(text, style: Theme.of(context).textTheme.bodyMedium),
          );
        }

        final stanceDescription = buildDescription(
          text: data.combatStance?.description,
        );
        final weaponDescription = buildDescription(
          text: data.primaryWeapon?.description,
        );

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (isWide)
              Row(
                children: [
                  Expanded(child: fields[0]),
                  SizedBox(width: fieldSpacing),
                  Expanded(child: fields[2]),
                ],
              )
            else ...[
              fields[0],
              fields[1],
              fields[2],
            ],
            const SizedBox(height: 12),
            if (data.combatStance != null)
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  Chip(
                    avatar: const Icon(Icons.style, size: 16),
                    label: Text(data.combatStance!.style),
                  ),
                  Chip(
                    avatar: const Icon(Icons.swap_horiz, size: 16),
                    label: Text('Range '),
                  ),
                ],
              ),
            stanceDescription,
            const SizedBox(height: 16),
            if (isWide)
              Row(children: [Expanded(child: fields[4])])
            else ...[
              fields[3],
              fields[4],
            ],
            weaponDescription,
          ],
        );
      },
    );
  }
}

class _TechniqueTags extends StatelessWidget {
  const _TechniqueTags({required this.controller, required this.validation});

  final CharacterFormController controller;
  final CharacterFormValidation validation;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final selectedIds = controller.selectedTechniqueTags
        .map((tag) => tag.id)
        .toSet();
    final error = validation.messageFor(CharacterFormField.techniqueTags);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: [
            for (final tag in controller.techniqueCatalog)
              FilterChip(
                label: Text(tag.label),
                tooltip: tag.summary,
                selected: selectedIds.contains(tag.id),
                onSelected: (_) => controller.toggleTechniqueTag(tag),
              ),
          ],
        ),
        if (error != null)
          Padding(
            padding: const EdgeInsets.only(top: 12),
            child: Text(
              error,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.error,
              ),
            ),
          ),
      ],
    );
  }
}

class _RacialAbilities extends StatelessWidget {
  const _RacialAbilities({required this.controller, required this.validation});

  final CharacterFormController controller;
  final CharacterFormValidation validation;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final race = controller.data.selectedRace;
    final available = controller.availableAbilities;
    final selectedIds = controller.selectedAbilities.map((a) => a.id).toSet();
    final abilityError = validation.messageFor(CharacterFormField.abilities);
    final abilityLimitMessage = controller.abilityLimitMessage;

    if (race == null) {
      return const _PlaceholderMessage(
        icon: Icons.auto_fix_high,
        message: 'Choose a race first to curate racial abilities.',
      );
    }

    if (available.isEmpty) {
      return _PlaceholderMessage(
        icon: Icons.inbox,
        message: 'No abilities are catalogued for  yet.',
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            Chip(
              label: Text('/ selected'),
              avatar: const Icon(Icons.tune, size: 16),
            ),
          ],
        ),
        const SizedBox(height: 16),
        for (final ability in available)
          _AbilityTile(
            ability: ability,
            selected: selectedIds.contains(ability.id),
            onChanged: () => controller.toggleAbility(ability),
          ),
        if (abilityLimitMessage != null) ...[
          const SizedBox(height: 12),
          Row(
            children: [
              const Icon(Icons.info_outline, size: 16),
              const SizedBox(width: 8),
              Expanded(child: Text(abilityLimitMessage)),
            ],
          ),
        ],
        if (abilityError != null)
          Padding(
            padding: const EdgeInsets.only(top: 12),
            child: Text(
              abilityError,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.error,
              ),
            ),
          ),
      ],
    );
  }
}

class _RankProgression extends StatelessWidget {
  const _RankProgression({required this.controller, required this.validation});

  final CharacterFormController controller;
  final CharacterFormValidation validation;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final rank = controller.data.selectedRank;
    final rankError = validation.messageFor(CharacterFormField.rank);
    final subRankError = validation.messageFor(CharacterFormField.subRank);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SegmentedButton<MainRank>(
          emptySelectionAllowed: true,
          key: ValueKey(rank?.rank),
          segments: [
            for (final details in controller.ranks)
              ButtonSegment<MainRank>(
                value: details.rank,
                label: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Text(details.displayName),
                ),
                tooltip: details.description,
              ),
          ],
          selected: rank != null ? {rank.rank} : const <MainRank>{},
          showSelectedIcon: false,
          onSelectionChanged: (selection) {
            if (selection.isEmpty) return;
            final selectedRank = controller.ranks.firstWhere(
              (details) => details.rank == selection.first,
            );
            controller.selectRank(selectedRank);
          },
        ),
        if (rankError != null)
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Text(
              rankError,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.error,
              ),
            ),
          ),
        if (rank != null) ...[
          const SizedBox(height: 12),
          Text(rank.description, style: theme.textTheme.bodyMedium),
        ],
        const SizedBox(height: 20),
        Text('Sub-rank', style: theme.textTheme.titleSmall),
        Slider(
          value: controller.data.subRank.toDouble(),
          min: CharacterFormController.subRankMin.toDouble(),
          max: CharacterFormController.subRankMax.toDouble(),
          divisions: CharacterFormController.subRankMax,
          label: controller.data.subRank.toString(),
          onChanged: (value) => controller.setSubRank(value.round()),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Progress: ', style: theme.textTheme.bodyMedium),
            Text('Multiplier: ', style: theme.textTheme.titleSmall),
          ],
        ),
        if (subRankError != null)
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Text(
              subRankError,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.error,
              ),
            ),
          ),
      ],
    );
  }
}

class _DensityPanel extends StatelessWidget {
  const _DensityPanel({required this.controller, required this.validation});

  final CharacterFormController controller;
  final CharacterFormValidation validation;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final density = controller.data.selectedDensity;
    final densityError = validation.messageFor(CharacterFormField.density);
    final overrideMessage = controller.densityOverrideMessage;
    final defaultDensity = controller.defaultDensityForSelectedZone;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        DropdownButtonFormField<MagicDensityDetails>(
          key: ValueKey(density?.level),
          value: density,
          decoration: InputDecoration(
            labelText: 'Density level',
            errorText: densityError,
            border: const OutlineInputBorder(),
          ),
          items: [
            for (final profile in controller.densities)
              DropdownMenuItem<MagicDensityDetails>(
                value: profile,
                child: Text(profile.displayName),
              ),
          ],
          onChanged: (profile) =>
              controller.selectDensity(profile, markOverride: true),
        ),
        if (overrideMessage != null) ...[
          const SizedBox(height: 12),
          Row(
            children: [
              const Icon(Icons.warning_amber, size: 16),
              const SizedBox(width: 8),
              Expanded(child: Text(overrideMessage)),
            ],
          ),
        ] else if (defaultDensity != null) ...[
          const SizedBox(height: 12),
          Text('Default for zone: .', style: theme.textTheme.bodySmall),
        ],
        if (density != null) ...[
          if (density.description != null) ...[
            const SizedBox(height: 16),
            Text(density.description!, style: theme.textTheme.bodyMedium),
          ],
          const SizedBox(height: 16),
          _DensityStat(
            icon: Icons.water_drop,
            label: 'Mana regeneration',
            valueText: ' / min',
          ),
          const SizedBox(height: 12),
          _DensityStat(
            icon: Icons.bug_report,
            label: 'Monster spawn modifier',
            valueText: formatAsPercent(
              density.monsterSpawnModifier,
              fractionDigits: 0,
            ),
          ),
          const SizedBox(height: 12),
          _DensityStat(
            icon: Icons.spa,
            label: 'Essence spawn modifier',
            valueText: formatAsPercent(
              density.essenceSpawnModifier,
              fractionDigits: 0,
            ),
          ),
        ] else ...[
          const SizedBox(height: 16),
          Text(
            'Choose a zone or set density manually to view modifiers.',
            style: theme.textTheme.bodyMedium,
          ),
        ],
      ],
    );
  }
}

class _DensityStat extends StatelessWidget {
  const _DensityStat({
    required this.icon,
    required this.label,
    required this.valueText,
  });

  final IconData icon;
  final String label;
  final String valueText;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      children: [
        Icon(icon, color: theme.colorScheme.secondary),
        const SizedBox(width: 12),
        Expanded(child: Text(label, style: theme.textTheme.bodyMedium)),
        Text(
          valueText,
          style: theme.textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}

class _AbilityTile extends StatelessWidget {
  const _AbilityTile({
    required this.ability,
    required this.selected,
    required this.onChanged,
  });

  final RacialAbility ability;
  final bool selected;
  final VoidCallback onChanged;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final borderColor = selected
        ? theme.colorScheme.primary
        : theme.colorScheme.outlineVariant;
    final backgroundColor = selected
        ? theme.colorScheme.primaryContainer
        : theme.colorScheme.surface;

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: DecoratedBox(
        decoration: BoxDecoration(
          border: Border.all(color: borderColor),
          borderRadius: BorderRadius.circular(12),
          color: backgroundColor,
        ),
        child: CheckboxListTile(
          value: selected,
          onChanged: (_) => onChanged(),
          controlAffinity: ListTileControlAffinity.leading,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 12,
          ),
          title: Text(ability.name, style: theme.textTheme.titleMedium),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  Chip(
                    label: Text(enumLabel(ability.type.name)),
                    avatar: const Icon(Icons.star, size: 16),
                    backgroundColor: theme.colorScheme.secondaryContainer,
                  ),
                  Chip(
                    label: Text(ability.isPassive ? 'Passive' : 'Active'),
                    avatar: Icon(
                      ability.isPassive ? Icons.bolt : Icons.flash_on,
                      size: 16,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(ability.description, style: theme.textTheme.bodyMedium),
              const SizedBox(height: 4),
              Text(
                ability.effectDescription,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _PlaceholderMessage extends StatelessWidget {
  const _PlaceholderMessage({required this.icon, required this.message});

  final IconData icon;
  final String message;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: theme.colorScheme.surfaceContainerHigh,
      ),
      child: Row(
        children: [
          Icon(icon, color: theme.colorScheme.primary),
          const SizedBox(width: 12),
          Expanded(child: Text(message, style: theme.textTheme.bodyMedium)),
        ],
      ),
    );
  }
}
