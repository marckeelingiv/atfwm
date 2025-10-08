# Character Builder Stepper Migration (Proposal 2)

- [ ] Rework the scaffold to host the three-step layout and sticky summary bar; replace the current scroll column with a `Stepper`-driven body and narrow-screen fallbacks in `lib/src/ui/character_sheet_page.dart`.
- [ ] Introduce dedicated step widgets with internal validation and responsive layouts: create `lib/src/ui/steps/profile_step.dart`, `lib/src/ui/steps/power_suite_step.dart`, and `lib/src/ui/steps/history_step.dart`, then wire them into the updated page.
- [ ] Extend the form model with new identity, combat, and history fields plus setters/validation rules in `lib/src/state/character_form_controller.dart` and `lib/src/models/character_models.dart`; update `CharacterDTO` serialization to include the new data.
- [ ] Seed selectable data for the new controls (pronouns, cultural lineages, combat stances, weapon catalogs, technique tags, guilds, achievements) inside `lib/src/data/static_data.dart` for future localization.
- [ ] Refresh the summary experience to surface the new identity, role, and history data, plus per-step validation cues, in `lib/src/ui/sections/summary_sidebar.dart`; remove the legacy notes summary in favor of mission dossier details.
- [ ] Retire or refactor the legacy one-page section widgets (e.g., `lib/src/ui/sections/character_basics_section.dart`, `notes_section.dart`) so they only expose what the new step widgets need, and delete unused components after migration.
- [ ] Update `lib/src/ui/sections/action_bar.dart` to reflect the stepper flow with step-aware status text, save/export gating, and any external navigation or reset controls.
