import '../state/character_form_controller.dart';

const List<String> kStepTitles = ['Profile', 'Power Suite', 'History'];

class StepProgress {
  const StepProgress({
    required this.title,
    required this.complete,
    required this.hasError,
  });

  final String title;
  final bool complete;
  final bool hasError;
}

List<StepProgress> buildStepProgress(CharacterFormValidation validation) {
  return List.generate(kStepTitles.length, (index) {
    final errors = stepErrors(index, validation);
    final complete = errors.every((error) => error == null);
    final hasError = errors.any((error) => error != null);
    return StepProgress(
      title: kStepTitles[index],
      complete: complete,
      hasError: hasError && !complete,
    );
  });
}

bool isStepComplete(int index, CharacterFormValidation validation) {
  return stepErrors(index, validation).every((error) => error == null);
}

bool stepHasError(int index, CharacterFormValidation validation) {
  return stepErrors(index, validation).any((error) => error != null);
}

List<String?> stepErrors(int index, CharacterFormValidation validation) {
  switch (index) {
    case 0:
      return [
        validation.displayNameError,
        validation.pronounsError,
        validation.lineageError,
        validation.raceError,
        validation.lifespanError,
      ];
    case 1:
      return [
        validation.abilitiesError,
        validation.combatStanceError,
        validation.primaryWeaponError,
        validation.techniqueTagsError,
        validation.rankError,
        validation.subRankError,
        validation.densityError,
      ];
    case 2:
      return [
        validation.zoneError,
        validation.guildError,
        validation.missionSummaryError,
      ];
    default:
      return const <String?>[];
  }
}
