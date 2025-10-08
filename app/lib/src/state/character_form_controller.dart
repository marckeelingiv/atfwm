import 'dart:collection';
import 'dart:math' as math;

import 'package:flutter/foundation.dart';

import '../data/static_data.dart';
import '../models/character_models.dart';

enum CharacterFormField {
  displayName,
  callSign,
  pronouns,
  lineage,
  race,
  abilities,
  combatStance,
  primaryWeapon,
  secondaryWeapon,
  techniqueTags,
  zone,
  density,
  rank,
  subRank,
  lifespan,
  guild,
  missionSummary,
}

class CharacterFormValidation {
  const CharacterFormValidation({
    this.displayNameError,
    this.pronounsError,
    this.lineageError,
    this.raceError,
    this.abilitiesError,
    this.combatStanceError,
    this.primaryWeaponError,
    this.secondaryWeaponError,
    this.techniqueTagsError,
    this.zoneError,
    this.densityError,
    this.rankError,
    this.subRankError,
    this.lifespanError,
    this.guildError,
    this.missionSummaryError,
  });

  final String? displayNameError;
  final String? pronounsError;
  final String? lineageError;
  final String? raceError;
  final String? abilitiesError;
  final String? combatStanceError;
  final String? primaryWeaponError;
  final String? secondaryWeaponError;
  final String? techniqueTagsError;
  final String? zoneError;
  final String? densityError;
  final String? rankError;
  final String? subRankError;
  final String? lifespanError;
  final String? guildError;
  final String? missionSummaryError;

  static const CharacterFormValidation pristine = CharacterFormValidation();

  bool get isValid =>
      displayNameError == null &&
      pronounsError == null &&
      lineageError == null &&
      raceError == null &&
      abilitiesError == null &&
      combatStanceError == null &&
      primaryWeaponError == null &&
      secondaryWeaponError == null &&
      techniqueTagsError == null &&
      zoneError == null &&
      densityError == null &&
      rankError == null &&
      subRankError == null &&
      lifespanError == null &&
      guildError == null &&
      missionSummaryError == null;

  String? messageFor(CharacterFormField field) {
    switch (field) {
      case CharacterFormField.displayName:
        return displayNameError;
      case CharacterFormField.callSign:
        return null;
      case CharacterFormField.pronouns:
        return pronounsError;
      case CharacterFormField.lineage:
        return lineageError;
      case CharacterFormField.race:
        return raceError;
      case CharacterFormField.abilities:
        return abilitiesError;
      case CharacterFormField.combatStance:
        return combatStanceError;
      case CharacterFormField.primaryWeapon:
        return primaryWeaponError;
      case CharacterFormField.secondaryWeapon:
        return secondaryWeaponError;
      case CharacterFormField.techniqueTags:
        return techniqueTagsError;
      case CharacterFormField.zone:
        return zoneError;
      case CharacterFormField.density:
        return densityError;
      case CharacterFormField.rank:
        return rankError;
      case CharacterFormField.subRank:
        return subRankError;
      case CharacterFormField.lifespan:
        return lifespanError;
      case CharacterFormField.guild:
        return guildError;
      case CharacterFormField.missionSummary:
        return missionSummaryError;
    }
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is CharacterFormValidation &&
        other.displayNameError == displayNameError &&
        other.pronounsError == pronounsError &&
        other.lineageError == lineageError &&
        other.raceError == raceError &&
        other.abilitiesError == abilitiesError &&
        other.combatStanceError == combatStanceError &&
        other.primaryWeaponError == primaryWeaponError &&
        other.secondaryWeaponError == secondaryWeaponError &&
        other.techniqueTagsError == techniqueTagsError &&
        other.zoneError == zoneError &&
        other.densityError == densityError &&
        other.rankError == rankError &&
        other.subRankError == subRankError &&
        other.lifespanError == lifespanError &&
        other.guildError == guildError &&
        other.missionSummaryError == missionSummaryError;
  }

  @override
  int get hashCode => Object.hash(
    displayNameError,
    pronounsError,
    lineageError,
    raceError,
    abilitiesError,
    combatStanceError,
    primaryWeaponError,
    secondaryWeaponError,
    techniqueTagsError,
    zoneError,
    densityError,
    rankError,
    subRankError,
    lifespanError,
    guildError,
    missionSummaryError,
  );
}

class CharacterFormController extends ChangeNotifier {
  static const int subRankMin = 0;
  static const int subRankMax = 9;
  static const int defaultLifespanCenturies = 1;

  CharacterFormController({
    List<Race>? races,
    List<RacialAbility>? abilities,
    List<WorldZone>? zones,
    List<MagicDensityDetails>? densities,
    List<RankDetails>? ranks,
    List<PronounSet>? pronounSets,
    List<CulturalLineage>? lineages,
    List<CombatStance>? combatStances,
    List<WeaponBlueprint>? weaponCatalog,
    List<TechniqueTag>? techniqueTags,
    List<GuildAffiliation>? guilds,
    List<AchievementBadge>? achievements,
  }) : _races = UnmodifiableListView(races ?? kRaces),
       _abilities = UnmodifiableListView(abilities ?? kRacialAbilities),
       _zones = UnmodifiableListView(zones ?? kWorldZones),
       _densities = UnmodifiableListView(densities ?? kMagicDensityDetails),
       _ranks = UnmodifiableListView(ranks ?? kRankDetails),
       _pronounSets = UnmodifiableListView(pronounSets ?? kPronounSets),
       _lineages = UnmodifiableListView(lineages ?? kCulturalLineages),
       _combatStances = UnmodifiableListView(combatStances ?? kCombatStances),
       _weaponCatalog = UnmodifiableListView(
         weaponCatalog ?? kWeaponBlueprints,
       ),
       _techniqueCatalog = UnmodifiableListView(
         techniqueTags ?? kTechniqueTags,
       ),
       _guilds = UnmodifiableListView(guilds ?? kGuildAffiliations),
       _achievementCatalog = UnmodifiableListView(
         achievements ?? kAchievementBadges,
       ),
       _abilityMap = _buildAbilityMap(abilities ?? kRacialAbilities),
       _densityByLevel = Map.unmodifiable(
         (densities ?? kMagicDensityDetails)
             .fold<Map<MagicDensityLevel, MagicDensityDetails>>(
               <MagicDensityLevel, MagicDensityDetails>{},
               (acc, profile) => acc..[profile.level] = profile,
             ),
       ),
       _data = const CharacterFormData(
         displayName: '',
         callSign: '',
         pronouns: null,
         lineage: null,
         combatStance: null,
         primaryWeapon: null,
         secondaryWeapon: null,
         techniqueTags: <TechniqueTag>[],
         guild: null,
         achievements: <AchievementBadge>[],
         selectedRace: null,
         selectedAbilities: <RacialAbility>[],
         selectedZone: null,
         selectedDensity: null,
         selectedRank: null,
         subRank: subRankMin,
         centuriesLifespan: defaultLifespanCenturies,
         hasMagicPowers: false,
         notes: '',
       ),
       _validation = CharacterFormValidation.pristine;

  final UnmodifiableListView<Race> _races;
  final UnmodifiableListView<RacialAbility> _abilities;
  final UnmodifiableListView<WorldZone> _zones;
  final UnmodifiableListView<MagicDensityDetails> _densities;
  final UnmodifiableListView<RankDetails> _ranks;
  final UnmodifiableListView<PronounSet> _pronounSets;
  final UnmodifiableListView<CulturalLineage> _lineages;
  final UnmodifiableListView<CombatStance> _combatStances;
  final UnmodifiableListView<WeaponBlueprint> _weaponCatalog;
  final UnmodifiableListView<TechniqueTag> _techniqueCatalog;
  final UnmodifiableListView<GuildAffiliation> _guilds;
  final UnmodifiableListView<AchievementBadge> _achievementCatalog;
  final UnmodifiableMapView<String, List<RacialAbility>> _abilityMap;
  final Map<MagicDensityLevel, MagicDensityDetails> _densityByLevel;

  CharacterFormData _data;
  CharacterFormValidation _validation;
  bool _densityOverridden = false;
  String? _abilityLimitMessage;

  UnmodifiableListView<Race> get races => _races;
  UnmodifiableListView<RacialAbility> get abilities => _abilities;
  UnmodifiableListView<WorldZone> get zones => _zones;
  UnmodifiableListView<MagicDensityDetails> get densities => _densities;
  UnmodifiableListView<RankDetails> get ranks => _ranks;
  UnmodifiableListView<PronounSet> get pronounSets => _pronounSets;
  UnmodifiableListView<CulturalLineage> get lineages => _lineages;
  UnmodifiableListView<CombatStance> get combatStances => _combatStances;
  UnmodifiableListView<WeaponBlueprint> get weaponCatalog => _weaponCatalog;
  UnmodifiableListView<TechniqueTag> get techniqueCatalog => _techniqueCatalog;
  UnmodifiableListView<GuildAffiliation> get guilds => _guilds;
  UnmodifiableListView<AchievementBadge> get achievementCatalog =>
      _achievementCatalog;

  CharacterFormData get data => _data;
  CharacterFormValidation get validation => _validation;
  bool get isValid => _validation.isValid;

  List<RacialAbility> get selectedAbilities =>
      List.unmodifiable(_data.selectedAbilities);
  List<TechniqueTag> get selectedTechniqueTags =>
      List.unmodifiable(_data.techniqueTags);
  List<AchievementBadge> get selectedAchievements =>
      List.unmodifiable(_data.achievements);
  int get maxSelectableAbilities => _data.selectedRace?.maxRacialAbilities ?? 0;

  String? get abilityLimitMessage => _abilityLimitMessage;

  bool get isDensityOverridden => _densityOverridden;
  String? get densityOverrideMessage {
    if (!_densityOverridden || _data.selectedZone == null) {
      return null;
    }
    final zone = _data.selectedZone!;
    final defaultDensity = _densityByLevel[zone.magicDensityLevel];
    if (defaultDensity == null || _data.selectedDensity == null) {
      return null;
    }
    return 'Magic density differs from ${zone.name} default (${defaultDensity.displayName}).';
  }

  List<RacialAbility> get availableAbilities {
    final raceId = _data.selectedRace?.id;
    if (raceId == null) {
      return const <RacialAbility>[];
    }
    return _abilityMap[raceId] ?? const <RacialAbility>[];
  }

  MagicDensityDetails? get defaultDensityForSelectedZone {
    final zone = _data.selectedZone;
    if (zone == null) return null;
    return _densityByLevel[zone.magicDensityLevel];
  }

  double get manaRegenPerMinute =>
      _data.selectedDensity?.manaRegenerationModifier ?? 0;

  double get monsterSpawnRate => _computeSpawnRate(
    _data.selectedZone?.monsterSpawnRate ?? 0,
    _data.selectedDensity?.monsterSpawnModifier ?? 0,
  );

  double get essenceSpawnRate => _computeSpawnRate(
    _data.selectedZone?.essenceSpawnRate ?? 0,
    _data.selectedDensity?.essenceSpawnModifier ?? 0,
  );

  double get awakeningStoneSpawnRate => _computeSpawnRate(
    _data.selectedZone?.awakeningStoneSpawnRate ?? 0,
    (_data.selectedDensity?.essenceSpawnModifier ?? 0) * 0.75,
  );

  double get powerMultiplier {
    final base = _data.selectedRank?.powerMultiplier ?? 1;
    final subRankBonus =
        1 + (_data.subRank / (subRankMax == 0 ? 1 : (subRankMax + 1)));
    return base * subRankBonus;
  }

  CharacterDTO toDto() {
    return CharacterDTO(
      displayName: _data.displayName,
      callSign: _data.callSign,
      pronouns: _data.pronouns,
      lineage: _data.lineage,
      combatStance: _data.combatStance,
      primaryWeapon: _data.primaryWeapon,
      secondaryWeapon: _data.secondaryWeapon,
      techniqueTags: List.unmodifiable(_data.techniqueTags),
      guild: _data.guild,
      achievements: List.unmodifiable(_data.achievements),
      race: _data.selectedRace,
      abilities: List.unmodifiable(_data.selectedAbilities),
      zone: _data.selectedZone,
      magicDensity: _data.selectedDensity,
      rank: _data.selectedRank,
      subRank: _data.subRank,
      powerMultiplier: powerMultiplier,
      manaRegenModifier: manaRegenPerMinute,
      monsterSpawnRate: monsterSpawnRate,
      essenceSpawnRate: essenceSpawnRate,
      awakeningStoneSpawnRate: awakeningStoneSpawnRate,
      centuriesLifespan: _data.centuriesLifespan,
      hasMagicPowers: _data.hasMagicPowers,
      notes: _data.notes,
    );
  }

  Map<String, dynamic> toJson() => toDto().toJson();

  void reset() {
    _data = const CharacterFormData(
      displayName: '',
      callSign: '',
      pronouns: null,
      lineage: null,
      combatStance: null,
      primaryWeapon: null,
      secondaryWeapon: null,
      techniqueTags: <TechniqueTag>[],
      guild: null,
      achievements: <AchievementBadge>[],
      selectedRace: null,
      selectedAbilities: <RacialAbility>[],
      selectedZone: null,
      selectedDensity: null,
      selectedRank: null,
      subRank: subRankMin,
      centuriesLifespan: defaultLifespanCenturies,
      hasMagicPowers: false,
      notes: '',
    );
    _densityOverridden = false;
    _abilityLimitMessage = null;
    _validateAndNotify();
  }

  void setDisplayName(String value) {
    if (value == _data.displayName) {
      return;
    }
    _data = _data.copyWith(displayName: value);
    _validateAndNotify();
  }

  void setCallSign(String value) {
    if (value == _data.callSign) {
      return;
    }
    _data = _data.copyWith(callSign: value);
    _validateAndNotify();
  }

  void selectPronouns(PronounSet? pronouns) {
    if (_data.pronouns == pronouns) {
      return;
    }
    _data = _data.copyWith(pronouns: pronouns);
    _validateAndNotify();
  }

  void selectLineage(CulturalLineage? lineage) {
    if (_data.lineage == lineage) {
      return;
    }
    _data = _data.copyWith(lineage: lineage);
    _validateAndNotify();
  }

  void selectCombatStance(CombatStance? stance) {
    if (_data.combatStance == stance) {
      return;
    }
    _data = _data.copyWith(combatStance: stance);
    _validateAndNotify();
  }

  void selectPrimaryWeapon(WeaponBlueprint? weapon) {
    if (_data.primaryWeapon == weapon) {
      return;
    }
    _data = _data.copyWith(primaryWeapon: weapon);
    _validateAndNotify();
  }

  void selectSecondaryWeapon(WeaponBlueprint? weapon) {
    if (_data.secondaryWeapon == weapon) {
      return;
    }
    _data = _data.copyWith(secondaryWeapon: weapon);
    _validateAndNotify();
  }

  void toggleTechniqueTag(TechniqueTag tag) {
    final existing = _data.techniqueTags;
    if (existing.any((current) => current.id == tag.id)) {
      final updated = existing
          .where((current) => current.id != tag.id)
          .toList(growable: false);
      _data = _data.copyWith(techniqueTags: List.unmodifiable(updated));
      _validateAndNotify();
      return;
    }

    final updated = List<TechniqueTag>.from(existing)..add(tag);
    _data = _data.copyWith(techniqueTags: List.unmodifiable(updated));
    _validateAndNotify();
  }

  void selectGuild(GuildAffiliation? guild) {
    if (_data.guild == guild) {
      return;
    }
    _data = _data.copyWith(guild: guild);
    _validateAndNotify();
  }

  void toggleAchievement(AchievementBadge achievement) {
    final existing = _data.achievements;
    if (existing.any((current) => current.id == achievement.id)) {
      final updated = existing
          .where((current) => current.id != achievement.id)
          .toList(growable: false);
      _data = _data.copyWith(achievements: List.unmodifiable(updated));
      _validateAndNotify();
      return;
    }

    final updated = List<AchievementBadge>.from(existing)..add(achievement);
    _data = _data.copyWith(achievements: List.unmodifiable(updated));
    _validateAndNotify();
  }

  void setMissionSummary(String value) {
    if (value == _data.notes) {
      return;
    }
    _data = _data.copyWith(notes: value);
    _validateAndNotify();
  }

  void setNotes(String value) => setMissionSummary(value);

  void selectRace(Race? race) {
    if (_data.selectedRace == race) {
      return;
    }

    final filteredAbilities = race == null
        ? <RacialAbility>[]
        : _data.selectedAbilities
              .where((ability) => ability.raceId == race.id)
              .take(race.maxRacialAbilities)
              .toList(growable: false);

    final baseLifespan = race?.baseLifespanCenturies;
    final lifespan =
        baseLifespan ??
        (_data.selectedRace == null
            ? defaultLifespanCenturies
            : _data.centuriesLifespan);

    _data = _data.copyWith(
      selectedRace: race,
      selectedAbilities: List.unmodifiable(filteredAbilities),
      centuriesLifespan: lifespan,
    );
    _abilityLimitMessage = null;
    _validateAndNotify();
  }

  void toggleAbility(RacialAbility ability) {
    final race = _data.selectedRace;
    if (race == null || ability.raceId != race.id) {
      return;
    }

    final existing = _data.selectedAbilities;
    if (existing.any((current) => current.id == ability.id)) {
      final updated = existing
          .where((current) => current.id != ability.id)
          .toList(growable: false);
      _data = _data.copyWith(selectedAbilities: List.unmodifiable(updated));
      _abilityLimitMessage = null;
      _validateAndNotify();
      return;
    }

    if (existing.length >= race.maxRacialAbilities) {
      _abilityLimitMessage =
          'You can choose up to ${race.maxRacialAbilities} abilities.';
      _validation = _buildValidation();
      notifyListeners();
      return;
    }

    final updated = List<RacialAbility>.from(existing)..add(ability);
    _data = _data.copyWith(selectedAbilities: List.unmodifiable(updated));
    _abilityLimitMessage = null;
    _validateAndNotify();
  }

  void selectZone(WorldZone? zone) {
    if (_data.selectedZone == zone) {
      return;
    }
    final density = zone != null
        ? _densityByLevel[zone.magicDensityLevel]
        : null;
    _densityOverridden = false;
    _data = _data.copyWith(selectedZone: zone, selectedDensity: density);
    _validateAndNotify();
  }

  void selectDensity(MagicDensityDetails? density, {bool markOverride = true}) {
    if (_data.selectedDensity == density) {
      return;
    }
    final zone = _data.selectedZone;
    if (density == null) {
      _densityOverridden = false;
    } else if (markOverride && zone != null) {
      _densityOverridden = density.level != zone.magicDensityLevel;
    } else if (!markOverride) {
      _densityOverridden = false;
    }
    _data = _data.copyWith(selectedDensity: density);
    _validateAndNotify();
  }

  void selectRank(RankDetails? rank) {
    if (_data.selectedRank == rank) {
      return;
    }
    _data = _data.copyWith(selectedRank: rank);
    _validateAndNotify();
  }

  void setSubRank(int value) {
    final clamped = _clampSubRank(value);
    if (clamped == _data.subRank) {
      return;
    }
    _data = _data.copyWith(subRank: clamped);
    _validateAndNotify();
  }

  void setCenturiesLifespan(int value) {
    final sanitized = math.max(0, value);
    if (sanitized == _data.centuriesLifespan) {
      return;
    }
    _data = _data.copyWith(centuriesLifespan: sanitized);
    _validateAndNotify();
  }

  void setHasMagicPowers(bool value) {
    if (value == _data.hasMagicPowers) {
      return;
    }
    _data = _data.copyWith(hasMagicPowers: value);
    _validateAndNotify();
  }

  void _validateAndNotify() {
    if (_data.selectedRace != null &&
        _data.selectedAbilities.length <
            _data.selectedRace!.maxRacialAbilities) {
      _abilityLimitMessage = null;
    }
    final newValidation = _buildValidation();
    if (newValidation != _validation) {
      _validation = newValidation;
    }
    notifyListeners();
  }

  CharacterFormValidation _buildValidation() {
    String? displayNameError;
    String? pronounsError;
    String? lineageError;
    String? raceError;
    String? abilitiesError;
    String? combatStanceError;
    String? primaryWeaponError;
    String? secondaryWeaponError;
    String? techniqueTagsError;
    String? zoneError;
    String? densityError;
    String? rankError;
    String? subRankError;
    String? lifespanError;
    String? guildError;
    String? missionSummaryError;

    if (_data.displayName.trim().isEmpty) {
      displayNameError = 'Provide a dossier name.';
    }

    if (_data.pronouns == null) {
      pronounsError = 'Select a pronoun set.';
    }

    if (_data.lineage == null) {
      lineageError = 'Choose a cultural lineage.';
    }

    final race = _data.selectedRace;
    final abilities = _data.selectedAbilities;

    if (race == null) {
      raceError = 'Select a race to begin.';
      if (abilities.isNotEmpty) {
        abilitiesError = 'Select a race before choosing abilities.';
      }
    } else {
      final allowed = _abilityMap[race.id] ?? const <RacialAbility>[];
      final allowedIds = allowed.map((ability) => ability.id).toSet();
      if (abilities.any((ability) => !allowedIds.contains(ability.id))) {
        abilitiesError = 'Abilities must belong to .';
      } else if (abilities.length > race.maxRacialAbilities) {
        abilitiesError = 'Choose  abilities or fewer.';
      }
    }

    if (_data.combatStance == null) {
      combatStanceError = 'Choose a combat stance.';
    }

    if (_data.primaryWeapon == null) {
      primaryWeaponError = 'Select a primary weapon.';
    }

    if (_data.techniqueTags.isEmpty) {
      techniqueTagsError = 'Tag at least one signature technique.';
    }

    final zone = _data.selectedZone;
    if (zone == null) {
      zoneError = 'Select a world zone.';
    }

    final density = _data.selectedDensity;
    if (density == null) {
      densityError = 'Magic density is required.';
    } else if (zone != null &&
        density.level != zone.magicDensityLevel &&
        !_densityOverridden) {
      densityError = 'Select override to diverge from  default density.';
    }

    final rank = _data.selectedRank;
    if (rank == null) {
      rankError = 'Select a main rank.';
    }

    if (_data.subRank < subRankMin || _data.subRank > subRankMax) {
      subRankError = 'Sub rank must be between  and .';
    }

    if (_data.centuriesLifespan < 0) {
      lifespanError = 'Lifespan cannot be negative.';
    }

    if (_data.guild == null) {
      guildError = 'Assign a guild affiliation.';
    }

    if (_data.notes.trim().isEmpty) {
      missionSummaryError = 'Add mission dossier details.';
    }

    return CharacterFormValidation(
      displayNameError: displayNameError,
      pronounsError: pronounsError,
      lineageError: lineageError,
      raceError: raceError,
      abilitiesError: abilitiesError,
      combatStanceError: combatStanceError,
      primaryWeaponError: primaryWeaponError,
      secondaryWeaponError: secondaryWeaponError,
      techniqueTagsError: techniqueTagsError,
      zoneError: zoneError,
      densityError: densityError,
      rankError: rankError,
      subRankError: subRankError,
      lifespanError: lifespanError,
      guildError: guildError,
      missionSummaryError: missionSummaryError,
    );
  }

  static int _clampSubRank(int value) {
    if (value < subRankMin) return subRankMin;
    if (value > subRankMax) return subRankMax;
    return value;
  }

  static double _computeSpawnRate(double base, double modifier) {
    final effective = base * (1 + modifier);
    if (effective.isNaN || effective.isInfinite) {
      return 0;
    }
    if (effective < 0) {
      return 0;
    }
    if (effective > 1) {
      return 1;
    }
    return effective;
  }

  static UnmodifiableMapView<String, List<RacialAbility>> _buildAbilityMap(
    List<RacialAbility> abilities,
  ) {
    final map = <String, List<RacialAbility>>{};
    for (final ability in abilities) {
      map.putIfAbsent(ability.raceId, () => <RacialAbility>[]).add(ability);
    }

    return UnmodifiableMapView({
      for (final entry in map.entries)
        entry.key: List.unmodifiable(entry.value),
    });
  }
}
