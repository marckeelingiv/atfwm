Chapter IX - Abilities (Part 3: Buffing & Debuffing Abilities)
ER Diagram
mermaid
Copy Code
erDiagram
    buffing_debuffing_abilities {
        string buff_debuff_id PK
        string ability_id FK
        enum effect_category
        enum target_type
        number duration_seconds
        number effect_magnitude
        boolean stacks_with_self
        number maximum_stacks
        string dispel_conditions
    }
    
    buff_abilities {
        string buff_id PK
        string buff_debuff_id FK
        enum buff_type
        string beneficial_effects
        number attribute_bonus
        string special_capabilities
        boolean affects_abilities
        string ability_modifications
    }
    
    debuff_abilities {
        string debuff_id PK
        string buff_debuff_id FK
        enum debuff_type
        string detrimental_effects
        number attribute_penalty
        string restrictions_imposed
        boolean affects_abilities
        string ability_hindrances
    }
    
    effect_stacking {
        string stack_id PK
        string buff_debuff_id FK
        number current_stacks
        number stack_value
        string stacking_rules
        datetime last_applied
        string stack_source
    }
    
    dispel_mechanics {
        string dispel_id PK
        string buff_debuff_id FK
        enum dispel_type
        string dispel_conditions
        number dispel_difficulty
        boolean can_be_resisted
        string resistance_method
    }
    
    area_effects {
        string area_id PK
        string buff_debuff_id FK
        number radius_meters
        enum area_shape
        boolean affects_allies
        boolean affects_enemies
        boolean requires_line_of_sight
        string area_restrictions
    }
    
    buffing_debuffing_abilities ||--o{ buff_abilities : "buff_type"
    buffing_debuffing_abilities ||--o{ debuff_abilities : "debuff_type"
    buffing_debuffing_abilities ||--o{ effect_stacking : "can_stack"
    buffing_debuffing_abilities ||--o{ dispel_mechanics : "can_be_dispelled"
    buffing_debuffing_abilities ||--o{ area_effects : "has_area"
Gameplay Flowchart
mermaid
Copy Code
flowchart TD
    A[Cast Buff/Debuff Ability] --> B{Target Type?}
    B -->|Self| C[Apply to Caster]
    B -->|Single Target| D[Select Target]
    B -->|Area Effect| E[Select Area Center]
    D --> F{Target Valid?}
    F -->|No| G[Ability Fails]
    F -->|Yes| H[Apply Effect]
    E --> I[Determine Affected Targets]
    I --> J{Targets in Area?}
    J -->|No| K[No Effect]
    J -->|Yes| L[Apply to All Valid Targets]
    C --> H
    H --> M{Effect Type?}
    L --> M
    M -->|Buff| N[Apply Beneficial Effects]
    M -->|Debuff| O[Apply Detrimental Effects]
    N --> P{Existing Buff?}
    O --> Q{Target Resists?}
    Q -->|Yes| R[Reduced/No Effect]
    Q -->|No| S[Full Effect Applied]
    P -->|Yes| T{Stacks with Self?}
    P -->|No| U[Replace/Enhance Existing]
    T -->|Yes| V[Add Stack]
    T -->|No| W[Refresh Duration]
    V --> X{Maximum Stacks Reached?}
    X -->|Yes| Y[Maintain Max Stacks]
    X -->|No| Z[Increase Stack Count]
    U --> AA[Update Buff Effects]
    W --> AA
    Y --> AA
    Z --> AA
    S --> BB{Existing Debuff?}
    BB -->|Yes| CC{Stacks with Self?}
    BB -->|No| DD[Apply New Debuff]
    CC -->|Yes| EE[Add Debuff Stack]
    CC -->|No| FF[Refresh/Replace]
    EE --> GG{Max Stacks?}
    GG -->|Yes| HH[Maintain Max]
    GG -->|No| II[Increase Stacks]
    DD --> JJ[Track Debuff Duration]
    FF --> JJ
    HH --> JJ
    II --> JJ
    AA --> KK[Track Buff Duration]
    JJ --> LL[Effect Active]
    KK --> LL
    LL --> MM{Duration Expired?}
    MM -->|No| NN[Continue Effect]
    MM -->|Yes| OO[Remove Effect]
    NN --> PP{Dispel Attempt?}
    PP -->|No| QQ[Maintain Effect]
    PP -->|Yes| RR[Roll Dispel Check]
    RR --> SS{Dispel Successful?}
    SS -->|Yes| OO
    SS -->|No| QQ
    QQ --> TT[Apply Per-Turn Effects]
    TT --> MM
    OO --> UU[Effect Removed]
    UU --> VV[Update Character Stats]
    R --> WW[Partial/No Effect]
    G --> XX[Ability Wasted]
    K --> XX
    VV --> YY[Continue Gameplay]
    WW --> YY
    XX --> YY
TypeScript Enums & Constants
typescript
Copy Code
enum EffectCategory {
  BUFF = "buff",
  DEBUFF = "debuff"
}

enum BuffType {
  ATTRIBUTE_ENHANCEMENT = "attribute_enhancement",
  DAMAGE_BOOST = "damage_boost",
  DEFENSE_BOOST = "defense_boost",
  SPEED_ENHANCEMENT = "speed_enhancement",
  MAGICAL_ENHANCEMENT = "magical_enhancement",
  REGENERATION = "regeneration",
  RESISTANCE = "resistance",
  SPECIAL_ABILITY = "special_ability"
}

enum DebuffType {
  ATTRIBUTE_REDUCTION = "attribute_reduction",
  DAMAGE_VULNERABILITY = "damage_vulnerability",
  MOVEMENT_IMPAIRMENT = "movement_impairment",
  ACCURACY_REDUCTION = "accuracy_reduction",
  MAGICAL_INTERFERENCE = "magical_interference",
  DAMAGE_OVER_TIME = "damage_over_time",
  ABILITY_RESTRICTION = "ability_restriction",
  SENSORY_IMPAIRMENT = "sensory_impairment"
}

enum TargetType {
  SELF = "self",
  SINGLE_TARGET = "single_target",
  MULTIPLE_TARGETS = "multiple_targets",
  AREA_EFFECT = "area_effect",
  ALL_ALLIES = "all_allies",
  ALL_ENEMIES = "all_enemies"
}

enum DispelType {
  MAGICAL_DISPEL = "magical_dispel",
  NATURAL_EXPIRATION = "natural_expiration",
  COUNTER_EFFECT = "counter_effect",
  DAMAGE_THRESHOLD = "damage_threshold",
  CONDITION_BASED = "condition_based"
}

enum AreaShape {
  CIRCLE = "circle",
  CONE = "cone",
  LINE = "line",
  SQUARE = "square",
  AURA = "aura"
}

const STACKING_RULES = {
  SAME_SOURCE: "Multiple applications from same caster",
  DIFFERENT_SOURCE: "Applications from different casters",
  SAME_TYPE: "Same buff/debuff type from any source",
  ENHANCEMENT_VS_REPLACEMENT: "Whether new application enhances or replaces"
} as const;

const BUFF_EXAMPLES = {
  ATTRIBUTE_BOOST: "Increase Power, Speed, Spirit, or Recovery",
  DAMAGE_ENHANCEMENT: "Bonus damage to attacks or spells",
  DEFENSIVE_BOOST: "Increased armor, resistance, or damage reduction",
  SPECIAL_CAPABILITIES: "Temporary abilities like flight or invisibility",
  REGENERATION_EFFECTS: "Health, mana, or stamina recovery over time"
} as const;

const DEBUFF_EXAMPLES = {
  STAT_PENALTIES: "Reduced attributes or capabilities",
  MOVEMENT_RESTRICTIONS: "Slowed, rooted, or movement penalties",
  ACCURACY_PROBLEMS: "Reduced hit chance or spell accuracy",
  DAMAGE_VULNERABILITY: "Increased damage taken from specific sources",
  ABILITY_INTERFERENCE: "Increased mana costs, cooldowns, or casting times"
} as const;

const DISPEL_MECHANICS = {
  MAGICAL_DISPEL: "Targeted removal of magical effects",
  RESISTANCE_CHECKS: "Target may resist dispel attempts",
  PARTIAL_DISPEL: "May remove only some stacks or reduce duration",
  IMMUNITY_EFFECTS: "Some effects cannot be dispelled",
  COUNTER_BUFFS: "Opposite effects may cancel each other"
} as const;
Explanatory Notes
• Buffing abilities provide beneficial effects like attribute bonuses, damage boosts, or special capabilities
• Debuffing abilities impose penalties such as reduced stats, movement restrictions, or ability interference
• Effects can target self, single targets, multiple targets, or areas with various shapes
• Stacking rules determine whether multiple applications enhance, replace, or refresh existing effects
• Duration tracking is essential for temporary effects with natural expiration
• Dispel mechanics allow for removal of effects through magical means or specific conditions
• Area effects can selectively target allies, enemies, or both depending on ability design
• Some effects provide ongoing benefits/penalties while others trigger on specific conditions
• Resistance checks may reduce or negate debuff applications
• Higher ranks typically increase effect magnitude, duration, and reduce dispel vulnerability
