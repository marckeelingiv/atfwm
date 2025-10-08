# Essence Character Forge

A Flutter desktop-first form for configuring single characters within the **Artha** setting. The tool mirrors the Chapter II world data, exposing race/ability rosters, world zones, magic density effects, and rank progression with live derived metrics.

## Features

- Desktop layout with scrollable form content and live-updating summary sidebar.
- Static data sources for races, racial abilities, world zones, density profiles, and rank tiers aligned to the narrative schema.
- ChangeNotifier-based controller providing validation, derived stats, and JSON export scaffolding.
- Form widgets for race selection, ability curation with limits, zone and density pickers, rank/sub-rank controls, and notes.
- Computed metrics for power multiplier, mana regeneration, and spawn modifiers.
- Action bar with reset and JSON preview placeholder for downstream integrations.

## Running the app

```bash
flutter run -d windows   # or macos/linux depending on host
```

All desktop targets are enabled via `flutter config` for first-run convenience.

## Tests

A smoke test ensures the primary sections render:

```bash
flutter test
```

## Project structure highlights

- `lib/src/models/` – Data models and DTOs used throughout the form.
- `lib/src/data/static_data.dart` – Hard-coded Chapter II world data (races, abilities, zones, density, rank tables).
- `lib/src/state/character_form_controller.dart` – ChangeNotifier state, validation logic, and derived computations.
- `lib/src/ui/sections/` – Modular widgets composing the character sheet UI.
- `lib/src/utils/text_formatters.dart` – Shared formatting helpers for enum labels and display values.

Future integration hooks include controller methods for persistence, and the JSON export dialog placeholder for wiring up actual save/share flows.