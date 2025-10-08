import 'package:flutter/foundation.dart';

enum RaceType {
  outworlder,
  human,
  elf,
  runic,
  smolder,
  celestine,
  draconian,
  leonid,
  merfolk,
}

enum RacialAbilityType { passive, active, triggered, enhancement }

enum MagicDensityLevel { none, low, medium, high, extreme }

enum MainRank { iron, bronze, silver, gold, diamond }

@immutable
class Race {
  const Race({
    required this.id,
    required this.type,
    required this.name,
    required this.description,
    required this.maxRacialAbilities,
    this.baseLifespanCenturies,
    this.icon,
  });

  final String id;
  final RaceType type;
  final String name;
  final String description;
  final int maxRacialAbilities;
  final int? baseLifespanCenturies;
  final String? icon;
}

@immutable
class RacialAbility {
  const RacialAbility({
    required this.id,
    required this.raceId,
    required this.type,
    required this.name,
    required this.description,
    required this.isPassive,
    required this.effectDescription,
  });

  final String id;
  final String raceId;
  final RacialAbilityType type;
  final String name;
  final String description;
  final bool isPassive;
  final String effectDescription;
}

@immutable
class MagicDensityDetails {
  const MagicDensityDetails({
    required this.level,
    required this.displayName,
    required this.densityValue,
    required this.manaRegenerationModifier,
    required this.monsterSpawnModifier,
    required this.essenceSpawnModifier,
    this.description,
  });

  final MagicDensityLevel level;
  final String displayName;
  final double densityValue;
  final double manaRegenerationModifier;
  final double monsterSpawnModifier;
  final double essenceSpawnModifier;
  final String? description;
}

@immutable
class RankDetails {
  const RankDetails({
    required this.rank,
    required this.displayName,
    required this.rankOrder,
    required this.powerMultiplier,
    required this.description,
  });

  final MainRank rank;
  final String displayName;
  final int rankOrder;
  final double powerMultiplier;
  final String description;
}

@immutable
class PronounSet {
  const PronounSet({
    required this.id,
    required this.label,
    required this.subject,
    required this.object,
    required this.possessive,
  });

  final String id;
  final String label;
  final String subject;
  final String object;
  final String possessive;
}

@immutable
class CulturalLineage {
  const CulturalLineage({
    required this.id,
    required this.name,
    required this.region,
    required this.description,
  });

  final String id;
  final String name;
  final String region;
  final String description;
}

@immutable
class CombatStance {
  const CombatStance({
    required this.id,
    required this.name,
    required this.style,
    required this.range,
    required this.description,
  });

  final String id;
  final String name;
  final String style;
  final String range;
  final String description;
}

@immutable
class WeaponBlueprint {
  const WeaponBlueprint({
    required this.id,
    required this.name,
    required this.category,
    required this.range,
    required this.description,
  });

  final String id;
  final String name;
  final String category;
  final String range;
  final String description;
}

@immutable
class TechniqueTag {
  const TechniqueTag({
    required this.id,
    required this.label,
    required this.summary,
  });

  final String id;
  final String label;
  final String summary;
}

@immutable
class GuildAffiliation {
  const GuildAffiliation({
    required this.id,
    required this.name,
    required this.focus,
    required this.motto,
  });

  final String id;
  final String name;
  final String focus;
  final String motto;
}

@immutable
class AchievementBadge {
  const AchievementBadge({
    required this.id,
    required this.title,
    required this.tier,
    required this.description,
  });

  final String id;
  final String title;
  final String tier;
  final String description;
}

@immutable
class WorldZone {
  const WorldZone({
    required this.id,
    required this.name,
    required this.climateType,
    required this.magicDensityLevel,
    required this.hasTechnology,
    required this.hasMagic,
    required this.monsterSpawnRate,
    required this.essenceSpawnRate,
    required this.awakeningStoneSpawnRate,
    this.description,
  });

  final String id;
  final String name;
  final String climateType;
  final MagicDensityLevel magicDensityLevel;
  final bool hasTechnology;
  final bool hasMagic;
  final double monsterSpawnRate;
  final double essenceSpawnRate;
  final double awakeningStoneSpawnRate;
  final String? description;
}

@immutable
class CharacterDTO {
  const CharacterDTO({
    required this.displayName,
    required this.callSign,
    required this.pronouns,
    required this.lineage,
    required this.combatStance,
    required this.primaryWeapon,
    required this.secondaryWeapon,
    required this.techniqueTags,
    required this.guild,
    required this.achievements,
    required this.race,
    required this.abilities,
    required this.zone,
    required this.magicDensity,
    required this.rank,
    required this.subRank,
    required this.powerMultiplier,
    required this.manaRegenModifier,
    required this.monsterSpawnRate,
    required this.essenceSpawnRate,
    required this.awakeningStoneSpawnRate,
    required this.centuriesLifespan,
    required this.hasMagicPowers,
    required this.notes,
  });

  final String displayName;
  final String callSign;
  final PronounSet? pronouns;
  final CulturalLineage? lineage;
  final CombatStance? combatStance;
  final WeaponBlueprint? primaryWeapon;
  final WeaponBlueprint? secondaryWeapon;
  final List<TechniqueTag> techniqueTags;
  final GuildAffiliation? guild;
  final List<AchievementBadge> achievements;
  final Race? race;
  final List<RacialAbility> abilities;
  final WorldZone? zone;
  final MagicDensityDetails? magicDensity;
  final RankDetails? rank;
  final int subRank;
  final double powerMultiplier;
  final double manaRegenModifier;
  final double monsterSpawnRate;
  final double essenceSpawnRate;
  final double awakeningStoneSpawnRate;
  final int centuriesLifespan;
  final bool hasMagicPowers;
  final String notes;

  Map<String, dynamic> toJson() {
    return {
      'displayName': displayName,
      'callSign': callSign,
      'pronouns': pronouns?.label,
      'lineage': lineage?.name,
      'combatStance': combatStance?.name,
      'primaryWeapon': primaryWeapon?.name,
      'secondaryWeapon': secondaryWeapon?.name,
      'techniqueTags': techniqueTags
          .map((tag) => tag.label)
          .toList(growable: false),
      'guild': guild?.name,
      'achievements': achievements
          .map((achievement) => achievement.title)
          .toList(growable: false),
      'race': race?.name,
      'abilities': abilities
          .map((ability) => ability.name)
          .toList(growable: false),
      'zone': zone?.name,
      'magicDensity': magicDensity?.level.name,
      'rank': rank?.displayName,
      'subRank': subRank,
      'powerMultiplier': powerMultiplier,
      'manaRegenModifier': manaRegenModifier,
      'monsterSpawnRate': monsterSpawnRate,
      'essenceSpawnRate': essenceSpawnRate,
      'awakeningStoneSpawnRate': awakeningStoneSpawnRate,
      'centuriesLifespan': centuriesLifespan,
      'hasMagicPowers': hasMagicPowers,
      'notes': notes,
    };
  }
}

@immutable
class CharacterFormData {
  const CharacterFormData({
    required this.displayName,
    required this.callSign,
    required this.pronouns,
    required this.lineage,
    required this.combatStance,
    required this.primaryWeapon,
    required this.secondaryWeapon,
    required this.techniqueTags,
    required this.guild,
    required this.achievements,
    required this.selectedRace,
    required this.selectedAbilities,
    required this.selectedZone,
    required this.selectedDensity,
    required this.selectedRank,
    required this.subRank,
    required this.centuriesLifespan,
    required this.hasMagicPowers,
    required this.notes,
  });

  final String displayName;
  final String callSign;
  final PronounSet? pronouns;
  final CulturalLineage? lineage;
  final CombatStance? combatStance;
  final WeaponBlueprint? primaryWeapon;
  final WeaponBlueprint? secondaryWeapon;
  final List<TechniqueTag> techniqueTags;
  final GuildAffiliation? guild;
  final List<AchievementBadge> achievements;
  final Race? selectedRace;
  final List<RacialAbility> selectedAbilities;
  final WorldZone? selectedZone;
  final MagicDensityDetails? selectedDensity;
  final RankDetails? selectedRank;
  final int subRank;
  final int centuriesLifespan;
  final bool hasMagicPowers;
  final String notes;

  static const Object _unset = Object();

  CharacterFormData copyWith({
    String? displayName,
    String? callSign,
    Object? pronouns = _unset,
    Object? lineage = _unset,
    Object? combatStance = _unset,
    Object? primaryWeapon = _unset,
    Object? secondaryWeapon = _unset,
    List<TechniqueTag>? techniqueTags,
    Object? guild = _unset,
    List<AchievementBadge>? achievements,
    Object? selectedRace = _unset,
    List<RacialAbility>? selectedAbilities,
    Object? selectedZone = _unset,
    Object? selectedDensity = _unset,
    Object? selectedRank = _unset,
    int? subRank,
    int? centuriesLifespan,
    bool? hasMagicPowers,
    String? notes,
  }) {
    return CharacterFormData(
      displayName: displayName ?? this.displayName,
      callSign: callSign ?? this.callSign,
      pronouns: identical(pronouns, _unset)
          ? this.pronouns
          : pronouns as PronounSet?,
      lineage: identical(lineage, _unset)
          ? this.lineage
          : lineage as CulturalLineage?,
      combatStance: identical(combatStance, _unset)
          ? this.combatStance
          : combatStance as CombatStance?,
      primaryWeapon: identical(primaryWeapon, _unset)
          ? this.primaryWeapon
          : primaryWeapon as WeaponBlueprint?,
      secondaryWeapon: identical(secondaryWeapon, _unset)
          ? this.secondaryWeapon
          : secondaryWeapon as WeaponBlueprint?,
      techniqueTags: techniqueTags ?? this.techniqueTags,
      guild: identical(guild, _unset) ? this.guild : guild as GuildAffiliation?,
      achievements: achievements ?? this.achievements,
      selectedRace: identical(selectedRace, _unset)
          ? this.selectedRace
          : selectedRace as Race?,
      selectedAbilities: selectedAbilities ?? this.selectedAbilities,
      selectedZone: identical(selectedZone, _unset)
          ? this.selectedZone
          : selectedZone as WorldZone?,
      selectedDensity: identical(selectedDensity, _unset)
          ? this.selectedDensity
          : selectedDensity as MagicDensityDetails?,
      selectedRank: identical(selectedRank, _unset)
          ? this.selectedRank
          : selectedRank as RankDetails?,
      subRank: subRank ?? this.subRank,
      centuriesLifespan: centuriesLifespan ?? this.centuriesLifespan,
      hasMagicPowers: hasMagicPowers ?? this.hasMagicPowers,
      notes: notes ?? this.notes,
    );
  }
}
