Chapter IX - Abilities (Part 1: Core Mechanics & Damage Abilities)
ER Diagram
mermaid
Copy Code
erDiagram
    abilities {
        string ability_id PK
        string name
        enum ability_category
        enum ability_type
        string essence_id FK
        number casting_time_seconds
        number cooldown_seconds
        number mana_cost
        enum mana_cost_type
        number range_meters
        string description
        boolean is_unlocked
        number current_rank
    }
    
    casting_mechanics {
        string mechanic_id PK
        string ability_id FK
        enum casting_time_category
        number base_casting_time
        boolean requires_concentration
        boolean can_be_interrupted
        string casting_requirements
        string verbal_components
        string somatic_components
    }
    
    cooldown_systems {
        string cooldown_id PK
        string ability_id FK
        number base_cooldown_seconds
        enum cooldown_type
        boolean affected_by_rank
        string cooldown_modifiers
        datetime last_used
        datetime available_again
    }
    
    mana_costs {
        string cost_id PK
        string ability_id FK
        number base_mana_cost
        enum cost_structure
        number cost_per_second
        number cost_per_use
        boolean scales_with_rank
        string cost_modifiers
    }
    
    damage_abilities {
        string damage_ability_id PK
        string ability_id FK
        enum damage_type
        number base_damage
        number damage_dice_count
        number damage_dice_sides
        enum damage_scaling
        string additional_effects
        boolean has_area_effect
        number area_radius_meters
    }
    
    spell_abilities {
        string spell_id PK
        string ability_id FK
        enum spell_category
        string spell_effects
        number duration_seconds
        boolean requires_line_of_sight
        boolean affects_multiple_targets
        string target_restrictions
    }
    
    ongoing_effects {
        string ongoing_id PK
        string ability_id FK
        number duration_seconds
        enum effect_type
        string effect_description
        boolean stacks_with_self
        number maximum_stacks
        string dispel_conditions
    }
    
    special_attacks {
        string special_attack_id PK
        string ability_id FK
        enum attack_type
        number accuracy_modifier
        string special_properties
        boolean replaces_normal_attack
        string trigger_conditions
    }
    
    abilities ||--o{ casting_mechanics : "has_casting"
    abilities ||--o{ cooldown_systems : "has_cooldown"
    abilities ||--o{ mana_costs : "has_cost"
    abilities ||--o{ damage_abilities : "damage_type"
    abilities ||--o{ spell_abilities : "spell_type"
    abilities ||--o{ ongoing_effects : "creates_effects"
    abilities ||--o{ special_attacks : "special_type"
Gameplay Flowchart
mermaid
Copy Code
flowchart TD
    A[Player Wants to Use Ability] --> B{Ability Available?}
    B -->|No| C[Check Cooldown Timer]
    B -->|Yes| D[Check Mana Cost]
    C --> E{Cooldown Expired?}
    E -->|No| F[Wait or Use Different Ability]
    E -->|Yes| D
    D --> G{Sufficient Mana?}
    G -->|No| H[Use HP for Mana or Cancel]
    G -->|Yes| I[Begin Casting]
    H --> J{Sacrifice HP?}
    J -->|No| K[Ability Cancelled]
    J -->|Yes| L[Convert HP to Mana]
    L --> I
    I --> M{Casting Time?}
    M -->|Instant| N[Ability Activates]
    M -->|Has Cast Time| O[Begin Casting Sequence]
    O --> P{Interrupted?}
    P -->|Yes| Q[Casting Fails]
    P -->|No| R[Complete Casting]
    R --> N
    N --> S{Ability Type?}
    S -->|Damage| T[Roll Attack/Damage]
    S -->|Spell| U[Apply Spell Effects]
    S -->|Ongoing| V[Create Ongoing Effect]
    S -->|Special Attack| W[Execute Special Attack]
    T --> X[Calculate Final Damage]
    X --> Y[Apply to Target]
    U --> Z[Apply to Target/Area]
    V --> AA[Track Effect Duration]
    W --> BB[Resolve Special Properties]
    Y --> CC[Start Cooldown Timer]
    Z --> CC
    AA --> CC
    BB --> CC
    CC --> DD[Deduct Mana Cost]
    DD --> EE{Ongoing Effect?}
    EE -->|Yes| FF[Continue Effect Tracking]
    EE -->|No| GG[Ability Complete]
    FF --> HH{Effect Duration Expired?}
    HH -->|No| II[Maintain Effect]
    HH -->|Yes| JJ[Remove Effect]
    II --> KK[Apply Per-Turn Effects]
    KK --> HH
    JJ --> GG
    GG --> LL[Ready for Next Action]
    Q --> MM[Ability on Cooldown]
    K --> NN[No Effect]
    F --> NN
    MM --> LL
    NN --> LL
TypeScript Enums & Constants
typescript
Copy Code
enum AbilityCategory {
  DAMAGE = "damage",
  ITEM_FOCUSED = "item_focused",
  BUFFING_DEBUFFING = "buffing_debuffing",
  MOBILITY = "mobility",
  PERCEPTION = "perception",
  SUMMONING = "summoning"
}

enum AbilityType {
  SPELL = "spell",
  ONGOING_EFFECT = "ongoing_effect",
  SPECIAL_ATTACK = "special_attack",
  RITUAL = "ritual",
  SPECIAL_ABILITY = "special_ability"
}

enum CastingTimeCategory {
  INSTANT = "instant",
  LOW_INTENSITY = "low_intensity",
  MEDIUM_INTENSITY = "medium_intensity",
  HIGH_INTENSITY = "high_intensity",
  EXTREME_INTENSITY = "extreme_intensity"
}

enum CooldownType {
  FIXED = "fixed",
  SCALING = "scaling",
  USAGE_BASED = "usage_based",
  ENCOUNTER_BASED = "encounter_based"
}

enum ManaCostType {
  PER_CAST = "per_cast",
  PER_SECOND = "per_second",
  CHANNELED = "channeled",
  VARIABLE = "variable"
}

enum DamageType {
  PHYSICAL = "physical",
  FIRE = "fire",
  ICE = "ice",
  LIGHTNING = "lightning",
  POISON = "poison",
  NECROTIC = "necrotic",
  HOLY = "holy",
  FORCE = "force",
  PSYCHIC = "psychic"
}

enum DamageScaling {
  FIXED = "fixed",
  RANK_BASED = "rank_based",
  ATTRIBUTE_BASED = "attribute_based",
  MANA_BASED = "mana_based"
}

enum SpellCategory {
  PROJECTILE = "projectile",
  AREA_EFFECT = "area_effect",
  TARGET_EFFECT = "target_effect",
  SELF_EFFECT = "self_effect",
  ENVIRONMENTAL = "environmental"
}

const CASTING_TIME_BASE_VALUES = {
  [CastingTimeCategory.INSTANT]: 0,
  [CastingTimeCategory.LOW_INTENSITY]: 1,
  [CastingTimeCategory.MEDIUM_INTENSITY]: 2,
  [CastingTimeCategory.HIGH_INTENSITY]: 3,
  [CastingTimeCategory.EXTREME_INTENSITY]: 4
} as const;

const BRONZE_RANK_CASTING_FORMULA = {
  FORMULA: "i * (1 - L/75)",
  DESCRIPTION: "i = base time, L = (main_level * 10) + sub_level",
  EXAMPLE: "Bronze 5 = L = 15, so 25% reduction in cast time"
} as const;

const ABILITY_ADVANCEMENT_EFFECTS = [
  "Increased damage/effectiveness",
  "Reduced mana cost",
  "Reduced cooldown",
  "Increased range",
  "Additional targets",
  "New secondary effects",
  "Improved accuracy",
  "Enhanced duration"
] as const;
Explanatory Notes
• All abilities have casting time, cooldown, and mana cost parameters that can be customized
• Casting times range from instant to extreme intensity (4 seconds base at Iron rank)
• At Bronze rank, casting transitions to time-based system with reduction formula
• Mana costs can be per-cast, per-second, or channeled depending on ability type
• Damage abilities roll dice for damage and can have area effects
• Spells can be projectiles, area effects, or targeted effects
• Ongoing effects have duration tracking and can stack with themselves
• Special attacks modify or replace normal attack mechanics
• All abilities improve with rank advancement, gaining multiple enhancement options
• Players can sacrifice HP for mana in dire situations (1:1 ratio)
