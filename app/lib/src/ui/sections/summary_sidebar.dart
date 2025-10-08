import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../state/character_form_controller.dart';
import '../../state/step_progress.dart';
import '../../utils/text_formatters.dart';

class SummarySidebar extends StatelessWidget {
  const SummarySidebar({super.key, required this.stepProgress});

  final List<StepProgress> stepProgress;

  @override
  Widget build(BuildContext context) {
    return Consumer<CharacterFormController>(
      builder: (context, controller, _) {
        final theme = Theme.of(context);
        final data = controller.data;
        final race = data.selectedRace;
        final zone = data.selectedZone;
        final density = data.selectedDensity;
        final rank = data.selectedRank;
        final guild = data.guild;
        final pronouns = data.pronouns;
        final lineage = data.lineage;
        final stance = data.combatStance;
        final primaryWeapon = data.primaryWeapon;
        final secondaryWeapon = data.secondaryWeapon;
        final techniqueTags = data.techniqueTags;
        final achievements = data.achievements;
        final abilities = data.selectedAbilities;
        final jsonPreview = const JsonEncoder.withIndent(
          '  ',
        ).convert(controller.toJson());

        return Card(
          margin: EdgeInsets.zero,
          elevation: 2,
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Character Summary',
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    for (final progress in stepProgress)
                      _StepIndicatorChip(progress: progress),
                  ],
                ),
                const SizedBox(height: 24),
                _SummarySection(
                  title: 'Identity',
                  children: [
                    _InfoRow(
                      'Codex name',
                      data.displayName.isEmpty ? '-' : data.displayName,
                    ),
                    if (data.callSign.isNotEmpty)
                      _InfoRow('Call sign', data.callSign),
                    _InfoRow('Pronouns', pronouns?.label ?? '-'),
                    _InfoRow('Cultural lineage', lineage?.name ?? '-'),
                    _InfoRow(
                      'Race',
                      race != null ? race.name : '-',
                      helper: race != null ? enumLabel(race.type.name) : null,
                    ),
                    _InfoRow(
                      'Magic attuned',
                      data.hasMagicPowers ? 'Yes' : 'No',
                    ),
                    _InfoRow('Lifespan', ' centuries'),
                  ],
                ),
                const SizedBox(height: 20),
                _SummarySection(
                  title: 'Combat Loadout',
                  children: [
                    _InfoRow(
                      'Combat stance',
                      stance?.name ?? '-',
                      helper: stance != null ? ' · Range ' : null,
                    ),
                    _InfoRow('Primary weapon', primaryWeapon?.name ?? '-'),
                    _InfoRow(
                      'Secondary weapon',
                      secondaryWeapon?.name ?? 'None',
                    ),
                    if (techniqueTags.isNotEmpty)
                      _ChipGroup(
                        label: 'Technique tags',
                        values: techniqueTags.map((tag) => tag.label).toList(),
                      )
                    else
                      _InfoRow('Technique tags', 'None'),
                    if (abilities.isNotEmpty)
                      _ChipGroup(
                        label: 'Racial abilities',
                        values: abilities
                            .map((ability) => ability.name)
                            .toList(),
                      )
                    else
                      _InfoRow('Racial abilities', 'None selected'),
                  ],
                ),
                const SizedBox(height: 20),
                _SummarySection(
                  title: 'Deployment & Resonance',
                  children: [
                    _InfoRow(
                      'Deployment zone',
                      zone?.name ?? '-',
                      helper: zone?.climateType,
                    ),
                    _InfoRow(
                      'Magic density',
                      density?.displayName ?? '-',
                      helper: density != null ? ' / min mana' : null,
                    ),
                    _InfoRow(
                      'Rank',
                      rank?.displayName ?? '-',
                      helper: rank != null ? 'x base power' : null,
                    ),
                    _InfoRow(
                      'Power multiplier',
                      formatAsMultiplier(
                        controller.powerMultiplier,
                        fractionDigits: 2,
                      ),
                    ),
                    _InfoRow('Mana regen', ' / min'),
                    _InfoRow(
                      'Monster spawn',
                      formatAsPercent(
                        controller.monsterSpawnRate,
                        fractionDigits: 0,
                      ),
                    ),
                    _InfoRow(
                      'Essence spawn',
                      formatAsPercent(
                        controller.essenceSpawnRate,
                        fractionDigits: 0,
                      ),
                    ),
                    _InfoRow(
                      'Awakening stones',
                      formatAsPercent(
                        controller.awakeningStoneSpawnRate,
                        fractionDigits: 0,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                _SummarySection(
                  title: 'Guild & Accolades',
                  children: [
                    _InfoRow('Guild', guild?.name ?? '-'),
                    if (guild != null) ...[
                      _InfoRow('Focus', guild.focus),
                      _InfoRow('Motto', guild.motto),
                    ],
                    if (achievements.isNotEmpty)
                      _ChipGroup(
                        label: 'Achievements',
                        values: achievements
                            .map((achievement) => achievement.title)
                            .toList(),
                      )
                    else
                      _InfoRow('Achievements', 'None recorded'),
                  ],
                ),
                const SizedBox(height: 20),
                _SummarySection(
                  title: 'Mission dossier',
                  children: [_DossierPreview(notes: data.notes)],
                ),
                const SizedBox(height: 20),
                _SummarySection(
                  title: 'JSON preview',
                  children: [
                    SizedBox(
                      height: 240,
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: theme.colorScheme.surfaceContainerHighest,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: SingleChildScrollView(
                          child: SelectableText(
                            jsonPreview,
                            style: const TextStyle(
                              fontFamily: 'Courier New',
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _SummarySection extends StatelessWidget {
  const _SummarySection({required this.title, required this.children});

  final String title;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        ...children,
      ],
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow(this.label, this.value, {this.helper});

  final String label;
  final String value;
  final String? helper;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: theme.textTheme.bodySmall),
          Text(
            value.isEmpty ? '-' : value,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          if (helper != null && helper!.isNotEmpty)
            Text(
              helper!,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
        ],
      ),
    );
  }
}

class _ChipGroup extends StatelessWidget {
  const _ChipGroup({required this.label, required this.values});

  final String label;
  final List<String> values;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: theme.textTheme.bodySmall),
          const SizedBox(height: 4),
          Wrap(
            spacing: 6,
            runSpacing: 6,
            children: values
                .map((value) => Chip(label: Text(value)))
                .toList(growable: false),
          ),
        ],
      ),
    );
  }
}

class _DossierPreview extends StatelessWidget {
  const _DossierPreview({required this.notes});

  final String notes;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    if (notes.trim().isEmpty) {
      return Text(
        'No dossier notes recorded.',
        style: theme.textTheme.bodySmall,
      );
    }
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(notes, style: theme.textTheme.bodySmall),
    );
  }
}

class _StepIndicatorChip extends StatelessWidget {
  const _StepIndicatorChip({required this.progress});

  final StepProgress progress;

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
    } else if (progress.hasError) {
      background = theme.colorScheme.errorContainer;
      foreground = theme.colorScheme.onErrorContainer;
      icon = Icons.error_outline;
    } else {
      background = theme.colorScheme.surfaceContainerHighest;
      foreground = theme.colorScheme.onSurfaceVariant;
      icon = Icons.radio_button_unchecked;
    }

    return Chip(
      avatar: Icon(icon, size: 18, color: foreground),
      label: Text(progress.title, style: TextStyle(color: foreground)),
      backgroundColor: background,
    );
  }
}
