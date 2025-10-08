import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/character_models.dart';
import '../../state/character_form_controller.dart';
import '../../utils/text_formatters.dart';
import '../widgets/section_card.dart';

class HistoryStep extends StatelessWidget {
  const HistoryStep({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<CharacterFormController>(
      builder: (context, controller, _) {
        final validation = controller.validation;

        return SingleChildScrollView(
          padding: const EdgeInsets.only(bottom: 48),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SectionCard(
                title: 'Deployment Zone',
                subtitle: const Text(
                  'Establish the zone that anchors this dossier.',
                ),
                child: _DeploymentZone(
                  controller: controller,
                  validation: validation,
                ),
              ),
              const SizedBox(height: 24),
              SectionCard(
                title: 'Guild & Accolades',
                subtitle: const Text(
                  'Attach guild affiliation and notable achievements.',
                ),
                child: _GuildAccolades(
                  controller: controller,
                  validation: validation,
                ),
              ),
              const SizedBox(height: 24),
              SectionCard(
                title: 'Mission Dossier',
                subtitle: const Text(
                  'Summarise recent campaigns, objectives, or hooks.',
                ),
                child: _MissionDossier(
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

class _DeploymentZone extends StatelessWidget {
  const _DeploymentZone({required this.controller, required this.validation});

  final CharacterFormController controller;
  final CharacterFormValidation validation;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final zone = controller.data.selectedZone;
    final zoneError = validation.messageFor(CharacterFormField.zone);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        DropdownButtonFormField<WorldZone>(
          key: ValueKey(zone?.id),
          value: zone,
          decoration: InputDecoration(
            labelText: 'Zone',
            errorText: zoneError,
            border: const OutlineInputBorder(),
          ),
          items: [
            for (final candidate in controller.zones)
              DropdownMenuItem<WorldZone>(
                value: candidate,
                child: Text(candidate.name),
              ),
          ],
          onChanged: controller.selectZone,
        ),
        const SizedBox(height: 16),
        if (zone != null) ...[
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              Chip(
                avatar: const Icon(Icons.thermostat, size: 16),
                label: Text(zone.climateType),
              ),
              Chip(
                avatar: Icon(
                  zone.hasTechnology ? Icons.memory : Icons.handyman,
                  size: 16,
                ),
                label: Text(
                  zone.hasTechnology ? 'Advanced tech' : 'Analog frontier',
                ),
              ),
              Chip(
                avatar: Icon(
                  zone.hasMagic ? Icons.auto_awesome : Icons.shield,
                  size: 16,
                ),
                label: Text(
                  zone.hasMagic ? 'Ancient magic' : 'Suppressed magic',
                ),
              ),
            ],
          ),
          if (zone.description != null) ...[
            const SizedBox(height: 12),
            Text(zone.description!, style: theme.textTheme.bodyMedium),
          ],
          const SizedBox(height: 16),
          _SpawnRateRow(
            icon: Icons.warning_amber,
            label: 'Monster spawn chance',
            value: zone.monsterSpawnRate,
          ),
          const SizedBox(height: 12),
          _SpawnRateRow(
            icon: Icons.bubble_chart,
            label: 'Essence manifestation',
            value: zone.essenceSpawnRate,
          ),
          const SizedBox(height: 12),
          _SpawnRateRow(
            icon: Icons.auto_fix_high,
            label: 'Awakening stone discovery',
            value: zone.awakeningStoneSpawnRate,
          ),
        ] else ...[
          Text(
            'Zones drive encounter probabilities and automate the default magic density.',
            style: theme.textTheme.bodyMedium,
          ),
        ],
      ],
    );
  }
}

class _GuildAccolades extends StatelessWidget {
  const _GuildAccolades({required this.controller, required this.validation});

  final CharacterFormController controller;
  final CharacterFormValidation validation;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final guildError = validation.messageFor(CharacterFormField.guild);
    final data = controller.data;
    final selectedAchievementIds = data.achievements
        .map((achievement) => achievement.id)
        .toSet();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        DropdownButtonFormField<GuildAffiliation>(
          value: data.guild,
          decoration: InputDecoration(
            labelText: 'Guild affiliation',
            errorText: guildError,
            border: const OutlineInputBorder(),
          ),
          items: [
            for (final guild in controller.guilds)
              DropdownMenuItem<GuildAffiliation>(
                value: guild,
                child: Text(guild.name),
              ),
          ],
          onChanged: controller.selectGuild,
        ),
        if (data.guild != null) ...[
          const SizedBox(height: 12),
          Text(data.guild!.focus, style: theme.textTheme.bodyMedium),
          const SizedBox(height: 4),
          Text(
            data.guild!.motto,
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ],
        const SizedBox(height: 20),
        Text('Achievements', style: theme.textTheme.titleSmall),
        const SizedBox(height: 12),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: [
            for (final badge in controller.achievementCatalog)
              FilterChip(
                label: Text(badge.title),
                tooltip: badge.description,
                selected: selectedAchievementIds.contains(badge.id),
                onSelected: (_) => controller.toggleAchievement(badge),
              ),
          ],
        ),
      ],
    );
  }
}

class _MissionDossier extends StatelessWidget {
  const _MissionDossier({required this.controller, required this.validation});

  final CharacterFormController controller;
  final CharacterFormValidation validation;

  @override
  Widget build(BuildContext context) {
    final missionError = validation.messageFor(
      CharacterFormField.missionSummary,
    );

    return TextFormField(
      key: ValueKey(controller.data.notes),
      initialValue: controller.data.notes,
      onChanged: controller.setMissionSummary,
      minLines: 4,
      maxLines: 6,
      decoration: InputDecoration(
        border: const OutlineInputBorder(),
        hintText: 'Mission briefs, personal hooks, or narrative notes...',
        errorText: missionError,
      ),
    );
  }
}

class _SpawnRateRow extends StatelessWidget {
  const _SpawnRateRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final double value;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final clampedValue = value.clamp(0, 1).toDouble();
    return Row(
      children: [
        Icon(icon, color: theme.colorScheme.primary),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: theme.textTheme.bodyMedium),
              const SizedBox(height: 4),
              LinearProgressIndicator(
                value: clampedValue,
                minHeight: 6,
                backgroundColor: theme.colorScheme.surfaceContainerHighest,
              ),
            ],
          ),
        ),
        const SizedBox(width: 12),
        SizedBox(
          width: 64,
          child: Text(
            formatAsPercent(clampedValue, fractionDigits: 0),
            textAlign: TextAlign.end,
            style: theme.textTheme.titleSmall,
          ),
        ),
      ],
    );
  }
}
