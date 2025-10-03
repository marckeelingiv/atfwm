Chapter III - Essences
ER Diagram
mermaid
Copy Code
erDiagram
    essences {
        string essence_id PK
        string name
        enum rarity_level
        enum bound_attribute
        string description
        number base_abilities_unlocked
        number max_abilities_total
    }
    
    essence_combinations {
        string combination_id PK
        string essence_1_id FK
        string essence_2_id FK
        string essence_3_id FK
        string confluence_essence_id FK
        string combination_name
    }
    
    awakening_stones {
        string stone_id PK
        string name
        enum stone_type
        enum rarity_level
        string effect_description
        string compatible_ability_types
    }
    
    character_essences {
        string character_essence_id PK
        string character_id FK
        string essence_id FK
        number slot_number
        boolean is_confluence
        number abilities_unlocked
    }
    
    essence_abilities {
        string ability_id PK
        string essence_id FK
        string name
        enum ability_category
        enum ability_type
        boolean is_awakened
        number unlock_order
        string description
        string awakening_stone_type_required
    }
    
    character_abilities {
        string char_ability_id PK
        string character_id FK
        string ability_id FK
        boolean is_unlocked
        number current_rank
        string awakening_stone_used_id FK
        string custom_modifications
    }
    
    ability_categories {
        string category_id PK
        string name
        string description
        enum bound_attribute
    }
    
    ability_types {
        string type_id PK
        string name
        string description
        boolean requires_mana
        boolean has_cooldown
        boolean has_casting_time
    }
    
    essences ||--o{ character_essences : "selected_by"
    essences ||--o{ essence_abilities : "grants"
    essence_combinations ||--|| essences : "essence_1"
    essence_combinations ||--|| essences : "essence_2" 
    essence_combinations ||--|| essences : "essence_3"
    essence_combinations ||--|| essences : "confluence"
    awakening_stones ||--o{ character_abilities : "used_to_unlock"
    essence_abilities ||--o{ character_abilities : "instance_of"
    ability_categories ||--o{ essence_abilities : "categorized_as"
    ability_types ||--o{ essence_abilities : "typed_as"
Gameplay Flowchart
mermaid
Copy Code
flowchart TD
    A[Character Creation] --> B[Select First Essence]
    B --> C[Select Second Essence]
    C --> D[Select Third Essence]
    D --> E[Calculate Confluence Essence]
    E --> F[Receive Starting Abilities]
    F --> G[1 Unlocked per Essence + Confluence]
    G --> H[Adventure/Exploration]
    H --> I{Find Awakening Stone?}
    I -->|Yes| J[Identify Stone Type]
    I -->|No| K[Continue Adventure]
    J --> L{Compatible with Locked Ability?}
    L -->|Yes| M[Choose Ability to Unlock]
    L -->|No| N[Store for Later/Trade]
    M --> O[Use Stone on Ability]
    O --> P[Ability Unlocked & Customized]
    P --> Q{All Abilities Unlocked?}
    Q -->|No| R[Continue Seeking Stones]
    Q -->|Yes| S[Focus on Rank Advancement]
    R --> H
    S --> T[Enhance Existing Abilities]
    K --> H
    N --> H
    T --> U{Rank Up Event?}
    U -->|Yes| V[All Abilities Gain Power]
    U -->|No| W[Continue Using Abilities]
    V --> W
    W --> H
TypeScript Enums & Constants
typescript
Copy Code
enum EssenceRarity {
  COMMON = "common",
  UNCOMMON = "uncommon", 
  RARE = "rare",
  EPIC = "epic",
  LEGENDARY = "legendary"
}

enum BoundAttribute {
  POWER = "power",
  SPEED = "speed",
  SPIRIT = "spirit", 
  RECOVERY = "recovery"
}

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
  SPECIAL_ABILITY = "special_ability",
  WEAPON_SUMMONING = "weapon_summoning",
  AMMUNITION = "ammunition",
  ARMOR = "armor",
  BUFF = "buff",
  DEBUFF = "debuff",
  TELEPORTATION = "teleportation",
  EXTREME_SPEED = "extreme_speed",
  FLYING_POWER = "flying_power",
  AURA = "aura",
  ILLUSION = "illusion",
  PERCEPTION = "perception",
  SUMMON = "summon",
  FAMILIAR = "familiar"
}

enum AwakeningStoneType {
  MIGHT = "might",
  SWIFT = "swift",
  MYSTIC = "mystic",
  RENEWAL = "renewal",
  BALANCE = "balance",
  DESTRUCTION = "destruction",
  CREATION = "creation",
  TRANSFORMATION = "transformation"
}

const KNOWN_ESSENCES = [
  "adept", "cold", "feeble", "heidel", "monkey", "sceptre", "swift", "wing",
  "ape", "coral", "fire", "hook", "moon", "serene", "sword", "wolf", "wood",
  "armor", "corrupt", "fish", "horse", "mouse", "shark", "technology",
  "axe", "crocodile", "flea", "hunger", "myriad", "shield", "tentacle", "zeal",
  "balance", "crystal", "flesh", "hunt", "needle", "shimmer", "thread",
  "bat", "dance", "foot", "ice", "net", "ship", "trap",
  "bear", "dark", "fork", "iron", "octopus", "shovel", "tree",
  "bee", "death", "fox", "knife", "omen", "sickle", "trowel",
  "bird", "deep", "frog", "knowledge", "pangolin", "sin", "turtle",
  "blight", "deer", "fungus", "life", "paper", "skunk", "vast",
  "blood", "dimension", "gathering", "light", "plant", "sloth", "vehicle",
  "bone", "discord", "glass", "lightning", "potent", "smoke", "venom",
  "bow", "dog", "goat", "lizard", "pure", "snake", "visage",
  "cage", "duck", "grazen", "locust", "rabbit", "song", "void",
  "cat", "dust", "growth", "lurker", "rake", "spear", "wall",
  "cattle", "earth", "gun", "magic", "rat", "spider", "wasp",
  "chain", "echo", "hair", "malign", "renewal", "spike", "water",
  "claw", "elemental", "hammer", "manatee", "resolute", "staff", "whale",
  "cloth", "eye", "hand", "might", "rune", "star", "whip",
  "cloud", "feast", "harmonic", "mirror", "sand", "sun", "wind"
] as const;

const ESSENCE_SLOTS = {
  TOTAL: 4,
  SELECTABLE: 3,
  CONFLUENCE: 1
} as const;

const ABILITIES_PER_ESSENCE = {
  STARTING_UNLOCKED: 1,
  TOTAL_POSSIBLE: 5,
  LOCKED_AT_START: 4
} as const;
Explanatory Notes
• Each character selects 3 essences which automatically generate a 4th confluence essence
• Each essence grants 1 unlocked ability at start and 4 locked abilities requiring awakening stones
• Awakening stones have specific types that determine which abilities they can unlock
• Each essence is bound to one of four attributes (Power, Speed, Spirit, Recovery)
• Leveling essence abilities also increases the bound attribute's rank and potency
• 144 known essences provide millions of possible combinations
• Each essence can provide a free effect modifier to all its abilities (like electro damage for lightning essence)
• Ideally each essence set contains one aura power and one perception power
• Players can customize abilities when unlocking them with awakening stones

Let me continue with Chapter IV - How to Play:

Chapter IV - How to Play
ER Diagram
mermaid
Copy Code
erDiagram
    characters {
        string character_id PK
        string name
        number health_points
        number stamina_points
        number mana_points
        number action_points
        enum current_rank
        number sub_rank
        boolean is_conscious
        boolean is_alive
    }
    
    combat_encounters {
        string encounter_id PK
        string location_id FK
        number round_number
        enum encounter_status
        number total_participants
        datetime start_time
        datetime end_time
    }
    
    combat_participants {
        string participant_id PK
        string encounter_id FK
        string character_id FK
        enum participant_type
        number initiative_order
        boolean is_active
        number current_hp
        number current_stamina
        number current_mana
    }
    
    combat_actions {
        string action_id PK
        string encounter_id FK
        string participant_id FK
        number round_number
        number action_sequence
        enum action_type
        string target_id FK
        number action_points_cost
        number stamina_cost
        number mana_cost
        string description
        boolean is_trigger_action
        string trigger_condition
    }
    
    attack_rolls {
        string roll_id PK
        string action_id FK
        number dice_rolled
        number target_number
        boolean hit_success
        number damage_dealt
        enum damage_type
        string weapon_or_spell_used
    }
    
    defensive_actions {
        string defense_id PK
        string action_id FK
        string defending_participant_id FK
        enum defense_type
        number dice_rolled
        boolean defense_success
        number damage_reduced
    }
    
    status_effects {
        string effect_id PK
        string participant_id FK
        string effect_name
        enum effect_type
        number duration_rounds
        number intensity
        string description
        boolean is_active
    }
    
    combat_encounters ||--o{ combat_participants : "includes"
    combat_participants ||--o{ combat_actions : "performs"
    combat_actions ||--o{ attack_rolls : "results_in"
    combat_actions ||--o{ defensive_actions : "triggers"
    combat_participants ||--o{ status_effects : "affected_by"
    characters ||--o{ combat_participants : "participates_as"
Gameplay Flowchart
mermaid
Copy Code
flowchart TD
    A[Combat Initiated] --> B[Roll Initiative/Determine Order]
    B --> C[Start Round]
    C --> D[Player Phase Begins]
    D --> E[Player Declares Actions]
    E --> F{Has Action Points?}
    F -->|Yes| G[Choose Action Type]
    F -->|No| H[End Player Phase]
    G --> I{Action Type?}
    I -->|Attack| J[Roll Attack Dice]
    I -->|Move| K[Move to New Position]
    I -->|Cast Spell| L[Check Mana Cost]
    I -->|Block/Dodge| M[Set Defensive Stance]
    I -->|Trigger Action| N[Set Trigger Condition]
    J --> O{Hit Target Number?}
    O -->|Yes| P[Deal Damage]
    O -->|No| Q[Attack Misses]
    L --> R{Sufficient Mana?}
    R -->|Yes| S[Cast Spell Successfully]
    R -->|No| T{Use HP for Mana?}
    T -->|Yes| U[Sacrifice HP for Mana]
    T -->|No| V[Spell Fails]
    U --> S
    S --> W[Apply Spell Effects]
    P --> X[Reduce Target HP]
    K --> Y[Update Position]
    M --> Z[Prepare Defense]
    N --> AA[Store Trigger]
    Q --> BB[Continue Actions]
    W --> BB
    X --> CC{Target HP <= 0?}
    CC -->|Yes| DD[Target Unconscious/Dead]
    CC -->|No| BB
    Y --> BB
    Z --> BB
    AA --> BB
    V --> BB
    BB --> F
    H --> EE[Enemy Phase Begins]
    EE --> FF[Enemies Attack Automatically]
    FF --> GG[Players Roll Defense]
    GG --> HH{Defense Successful?}
    HH -->|Yes| II[Reduce/Negate Damage]
    HH -->|No| JJ[Take Full Damage]
    II --> KK[Check Trigger Actions]
    JJ --> LL{Player HP <= 0?}
    LL -->|Yes| MM[Player Unconscious]
    LL -->|No| KK
    KK --> NN{Triggers Activated?}
    NN -->|Yes| OO[Execute Trigger Actions]
    NN -->|No| PP[End Round]
    OO --> PP
    PP --> QQ{Combat Continues?}
    QQ -->|Yes| RR[Increment Round]
    QQ -->|No| SS[Combat Ends]
    RR --> C
    MM --> TT{Below -HP Threshold?}
    TT -->|Yes| UU[Character Dies]
    TT -->|No| VV[Character Unconscious]
    DD --> QQ
    UU --> SS
    VV --> QQ
    SS --> WW[Resolve Combat Results]
TypeScript Enums & Constants
typescript
Copy Code
enum ActionType {
  ATTACK = "attack",
  MOVE = "move", 
  CAST_SPELL = "cast_spell",
  BLOCK = "block",
  DODGE = "dodge",
  FLEE = "flee",
  USE_ITEM = "use_item",
  TRADE = "trade",
  TRIGGER_ACTION = "trigger_action",
  CLIMB = "climb",
  OPEN_DOOR = "open_door"
}

enum DefenseType {
  BLOCK = "block",
  DODGE = "dodge",
  PARRY = "parry",
  MAGICAL_RESISTANCE = "magical_resistance"
}

enum EncounterStatus {
  INITIATED = "initiated",
  IN_PROGRESS = "in_progress",
  PLAYER_VICTORY = "player_victory",
  PLAYER_DEFEAT = "player_defeat",
  FLED = "fled",
  DRAW = "draw"
}

enum ParticipantType {
  PLAYER_CHARACTER = "player_character",
  ENEMY_MONSTER = "enemy_monster",
  ALLY_NPC = "ally_npc",
  NEUTRAL = "neutral"
}

enum DamageType {
  PHYSICAL = "physical",
  MAGICAL = "magical",
  FIRE = "fire",
  ICE = "ice",
  LIGHTNING = "lightning",
  POISON = "poison",
  NECROTIC = "necrotic",
  HOLY = "holy"
}

enum StatusEffectType {
  BUFF = "buff",
  DEBUFF = "debuff",
  DOT = "damage_over_time",
  HOT = "heal_over_time",
  STUN = "stun",
  PARALYSIS = "paralysis",
  CHARM = "charm",
  FEAR = "fear"
}

const STARTING_STATS = {
  HEALTH_POINTS: 3,
  STAMINA_POINTS: 3,
  MANA_POINTS: 10,
  ACTION_POINTS: 3
} as const;

const COMBAT_MECHANICS = {
  ROUND_DURATION_SECONDS: 6,
  ACTION_DURATION_SECONDS: 2,
  HIT_TARGET_NUMBER: 5,
  DICE_SIDES: 6,
  DEATH_THRESHOLD_MULTIPLIER: -1,
  EXTRA_MOVEMENT_STAMINA_COST: 1,
  FLEE_ACTION_COST: 1
} as const;

const BRONZE_RANK_CHANGES = {
  USE_TIME_SYSTEM: true,
  BASE_CAST_TIMES: {
    LOW_INTENSITY: 1,
    MEDIUM_INTENSITY: 2, 
    HIGH_INTENSITY: 3,
    EXTREME_INTENSITY: 4
  },
  TIME_REDUCTION_FORMULA: "i * (1 - L/75)" // i = base time, L = (main_level * 10) + sub_level
} as const;
Explanatory Notes
• Combat uses simultaneous phases - players act first, then enemies respond automatically
• Each character starts with 3 HP, 3 Stamina, 10 Mana, and 3 Action Points per round
• Players must roll to hit (5+ on d6), enemies hit automatically but players can defend
• Each action takes 1 Action Point and roughly 2 seconds of in-game time
• Characters can sacrifice HP for mana in dire situations (1:1 ratio)
• Trigger actions allow setting conditional responses that activate during enemy phase
• At Bronze rank, the system transitions from Action Points to time-based casting
• Fleeing requires avoiding attacks from all enemies in your zone
• Death occurs when HP drops significantly below 0, unconsciousness at 0 HP
• Movement between zones costs extra stamina when no enemies are present

Let me continue with Chapter V - Attributes:

Chapter V - Attributes
ER Diagram
mermaid
Copy Code
erDiagram
    attributes {
        string attribute_id PK
        string name
        string description
        enum attribute_type
        number base_value
        number rank_multiplier
    }
    
    character_attributes {
        string char_attr_id PK
        string character_id FK
        string attribute_id FK
        number current_rank
        number base_value
        number total_value
        number essence_bonus
        number item_bonus
        number temporary_bonus
    }
    
    attribute_effects {
        string effect_id PK
        string attribute_id FK
        string effect_name
        string description
        number threshold_value
        string mechanical_effect
    }
    
    power_effects {
        string power_effect_id PK
        string character_id FK
        enum effect_type
        number damage_bonus
        number health_bonus
        number carrying_capacity
        boolean enhanced_strength
    }
    
    speed_effects {
        string speed_effect_id PK
        string character_id FK
        number movement_bonus
        number initiative_bonus
        number attack_speed_bonus
        number dodge_bonus
        boolean enhanced_reflexes
    }
    
    spirit_effects {
        string spirit_effect_id PK
        string character_id FK
        number mana_bonus
        number spell_accuracy_bonus
        number magical_resistance
        number essence_detection_range
        boolean enhanced_magical_senses
    }
    
    recovery_effects {
        string recovery_effect_id PK
        string character_id FK
        number health_regeneration
        number stamina_regeneration
        number mana_regeneration
        number healing_bonus
        boolean enhanced_recovery_rate
    }
    
    resistance_values {
        string resistance_id PK
        string character_id FK
        enum rank_level
        number physical_resistance
        number magical_resistance
        string description
    }
    
    attributes ||--o{ character_attributes : "instance_of"
    attributes ||--o{ attribute_effects : "provides"
    character_attributes ||--o{ power_effects : "grants_power"
    character_attributes ||--o{ speed_effects : "grants_speed"
    character_attributes ||--o{ spirit_effects : "grants_spirit"
    character_attributes ||--o{ recovery_effects : "grants_recovery"
    character_attributes ||--o{ resistance_values : "determines"
Gameplay Flowchart
mermaid
Copy Code
flowchart TD
    A[Character Creation] --> B[Set Base Attributes]
    B --> C[Power = 0, Speed = 0, Spirit = 0, Recovery = 0]
    C --> D[Select Essences]
    D --> E[Each Essence Bound to Attribute]
    E --> F[Unlock Essence Abilities]
    F --> G[Ability Rank Increases Bound Attribute]
    G --> H{Attribute Threshold Reached?}
    H -->|Yes| I[Unlock Attribute Effects]
    H -->|No| J[Continue Progression]
    I --> K{Which Attribute?}
    K -->|Power| L[Increase Damage/Health/Strength]
    K -->|Speed| M[Increase Movement/Initiative/Dodge]
    K -->|Spirit| N[Increase Mana/Spell Accuracy/Magic Resist]
    K -->|Recovery| O[Increase Regeneration/Healing]
    L --> P[Apply Power Bonuses]
    M --> Q[Apply Speed Bonuses]
    N --> R[Apply Spirit Bonuses]
    O --> S[Apply Recovery Bonuses]
    P --> T[Update Combat Stats]
    Q --> T
    R --> T
    S --> T
    T --> U{Rank Advancement?}
    U -->|Yes| V[Increase Resistance Values]
    U -->|No| W[Continue Using Enhanced Abilities]
    V --> X{New Rank Level?}
    X -->|Iron| Y[+1 Resistance]
    X -->|Bronze| Z[+10 Resistance]
    X -->|Silver| AA[+20 Resistance]
    X -->|Gold| BB[+30 Resistance]
    X -->|Diamond| CC[+40 Resistance]
    Y --> DD[Update Character Sheet]
    Z --> DD
    AA --> DD
    BB --> DD
    CC --> DD
    DD --> W
    W --> J
    J --> EE{New Ability Unlocked?}
    EE -->|Yes| F
    EE -->|No| FF[Continue Adventure]
    FF --> GG{Attribute Bonus Items Found?}
    GG -->|Yes| HH[Apply Item Bonuses]
    GG -->|No| II[Regular Gameplay]
    HH --> T
    II --> FF
TypeScript Enums & Constants
typescript
Copy Code
enum AttributeType {
  POWER = "power",
  SPEED = "speed", 
  SPIRIT = "spirit",
  RECOVERY = "recovery"
}

enum PowerEffectType {
  DAMAGE_BONUS = "damage_bonus",
  HEALTH_BONUS = "health_bonus",
  CARRYING_CAPACITY = "carrying_capacity",
  STRENGTH_ENHANCEMENT = "strength_enhancement",
  PHYSICAL_PROWESS = "physical_prowess"
}

enum SpeedEffectType {
  MOVEMENT_BONUS = "movement_bonus",
  INITIATIVE_BONUS = "initiative_bonus",
  ATTACK_SPEED = "attack_speed",
  DODGE_BONUS = "dodge_bonus",
  REFLEX_ENHANCEMENT = "reflex_enhancement"
}

enum SpiritEffectType {
  MANA_BONUS = "mana_bonus",
  SPELL_ACCURACY = "spell_accuracy",
  MAGICAL_RESISTANCE = "magical_resistance",
  ESSENCE_DETECTION = "essence_detection",
  MAGICAL_SENSE_ENHANCEMENT = "magical_sense_enhancement"
}

enum RecoveryEffectType {
  HEALTH_REGENERATION = "health_regeneration",
  STAMINA_REGENERATION = "stamina_regeneration",
  MANA_REGENERATION = "mana_regeneration",
  HEALING_BONUS = "healing_bonus",
  RECOVERY_RATE_ENHANCEMENT = "recovery_rate_enhancement"
}

enum RankResistanceLevel {
  LESSER = "lesser",
  IRON = "iron",
  BRONZE = "bronze",
  SILVER = "silver", 
  GOLD = "gold",
  DIAMOND = "diamond"
}

const ATTRIBUTE_BASE_VALUES = {
  [AttributeType.POWER]: 0,
  [AttributeType.SPEED]: 0,
  [AttributeType.SPIRIT]: 0,
  [AttributeType.RECOVERY]: 0
} as const;

const RESISTANCE_BY_RANK = {
  [RankResistanceLevel.LESSER]: 0,
  [RankResistanceLevel.IRON]: 1,
  [RankResistanceLevel.BRONZE]: 10,
  [RankResistanceLevel.SILVER]: 20,
  [RankResistanceLevel.GOLD]: 30,
  [RankResistanceLevel.DIAMOND]: 40
} as const;

const ATTRIBUTE_PROGRESSION = {
  ESSENCE_BINDING: "Each essence bound to one attribute",
  ABILITY_RANK_BONUS: "Ability advancement increases bound attribute",
  EXPONENTIAL_GROWTH: "Higher ranks provide exponentially more benefit",
  THRESHOLD_EFFECTS: "Certain values unlock special effects"
} as const;
Explanatory Notes
• Four core attributes: Power, Speed, Spirit, and Recovery, all starting at 0
• Each essence is bound to one specific attribute type
• Advancing abilities within an essence increases that essence's bound attribute rank
• Power affects damage output, health points, carrying capacity, and physical strength
• Speed influences movement, initiative, attack speed, dodge chance, and reflexes
• Spirit governs mana pool, spell accuracy, magical resistance, and essence detection
• Recovery determines health/stamina/mana regeneration rates and healing effectiveness
• Characters gain natural resistance to damage based on their overall rank
• Resistance values: Lesser (0), Iron (+1), Bronze (+10), Silver (+20), Gold (+30), Diamond (+40)
• Attacks below resistance threshold deal minimal damage but effects still apply
• Attribute bonuses can come from essence progression, items, and temporary effects

Now let me continue with Chapter VI - Advancing Your Rank:

Chapter VI - Advancing Your Rank
ER Diagram
mermaid
Copy Code
erDiagram
    character_progression {
        string progression_id PK
        string character_id FK
        enum current_main_rank
        number current_sub_rank
        number total_experience_points
        number essence_1_rank
        number essence_2_rank
        number essence_3_rank
        number confluence_rank
        number overall_rank_value
    }
    
    rank_advancement_requirements {
        string requirement_id PK
        enum target_main_rank
        number target_sub_rank
        number required_overall_rank
        number required_essence_ranks_sum
        string advancement_conditions
        boolean requires_ritual
        string ritual_description
    }
    
    essence_rank_progression {
        string essence_prog_id PK
        string character_id FK
        string essence_id FK
        number current_rank
        number abilities_unlocked
        number abilities_advanced
        number experience_in_rank
    }
    
    ability_advancement {
        string advancement_id PK
        string character_ability_id FK
        number current_level
        number experience_points
        string advancement_effects
        datetime last_advancement
        string advancement_method
    }
    
    aura_abilities {
        string aura_id PK
        string character_id FK
        string ability_name
        number detection_range
        enum aura_type
        string passive_effects
        boolean is_active
        number mana_cost_per_second
    }
    
    perception_abilities {
        string perception_id PK
        string character_id FK
        string ability_name
        enum perception_type
        number range_meters
        string detection_capabilities
        boolean requires_concentration
        number mana_cost
    }
    
    non_combat_powers {
        string power_id PK
        string character_id FK
        string power_name
        enum power_category
        string description
        string usage_conditions
        number cooldown_hours
        boolean is_ritual
    }
    
    character_progression ||--o{ essence_rank_progression : "tracks"
    essence_rank_progression ||--o{ ability_advancement : "contains"
    character_progression ||--o{ aura_abilities : "unlocks"
    character_progression ||--o{ perception_abilities : "unlocks"
    character_progression ||--o{ non_combat_powers : "grants"
    rank_advancement_requirements ||--o{ character_progression : "governs"
Gameplay Flowchart
mermaid
Copy Code
flowchart TD
    A[Character Starts at Iron 0] --> B[Use Abilities in Combat/Scenarios]
    B --> C[Gain Experience for Abilities]
    C --> D[Ability Ranks Increase]
    D --> E[Calculate Essence Rank]
    E --> F[Sum All Essence Ranks]
    F --> G[Determine Overall Rank]
    G --> H{Overall Rank Threshold Met?}
    H -->|No| I[Continue Using Abilities]
    H -->|Yes| J{Check Sub-Rank Advancement}
    J --> K{Sub-Rank < 9?}
    K -->|Yes| L[Advance Sub-Rank]
    K -->|No| M{Ready for Main Rank?}
    M -->|Yes| N[Advance Main Rank]
    M -->|No| O[Remain at Current Level]
    L --> P[Increase Power Level]
    N --> Q[Major Power Increase]
    P --> R[All Abilities Enhanced]
    Q --> S[Unlock New Capabilities]
    R --> T{Aura/Perception Unlocked?}
    S --> T
    T -->|Yes| U[Gain Special Abilities]
    T -->|No| V[Continue Progression]
    U --> W[Aura: Passive Detection]
    U --> X[Perception: Active Scanning]
    U --> Y[Non-Combat Powers]
    W --> Z[Enhanced Awareness]
    X --> AA[Detailed Information Gathering]
    Y --> BB[Utility/Social Powers]
    Z --> CC[Update Character Capabilities]
    AA --> CC
    BB --> CC
    CC --> V
    V --> I
    O --> I
    I --> DD{New Awakening Stone?}
    DD -->|Yes| EE[Unlock New Ability]
    DD -->|No| FF[Continue Adventure]
    EE --> B
    FF --> GG{Use Existing Abilities?}
    GG -->|Yes| B
    GG -->|No| HH[Non-Combat Activities]
    HH --> II{Gain Experience?}
    II -->|Yes| C
    II -->|No| FF
TypeScript Enums & Constants
typescript
Copy Code
enum MainRankProgression {
  IRON = "iron",
  BRONZE = "bronze",
  SILVER = "silver", 
  GOLD = "gold",
  DIAMOND = "diamond"
}

enum AuraType {
  DETECTION = "detection",
  INTIMIDATION = "intimidation",
  INSPIRATION = "inspiration",
  ELEMENTAL = "elemental",
  MAGICAL_SUPPRESSION = "magical_suppression",
  HEALING = "healing",
  PROTECTION = "protection"
}

enum PerceptionType {
  MAGICAL_DETECTION = "magical_detection",
  LIFE_SENSE = "life_sense",
  THREAT_ASSESSMENT = "threat_assessment",
  ESSENCE_ANALYSIS = "essence_analysis",
  DIMENSIONAL_AWARENESS = "dimensional_awareness",
  EMOTIONAL_READING = "emotional_reading"
}

enum NonCombatPowerCategory {
  UTILITY = "utility",
  SOCIAL = "social",
  CRAFTING = "crafting",
  TRANSPORTATION = "transportation",
  COMMUNICATION = "communication",
  INVESTIGATION = "investigation",
  SURVIVAL = "survival"
}

enum AdvancementMethod {
  COMBAT_USAGE = "combat_usage",
  TRAINING = "training",
  MEDITATION = "meditation",
  EXPERIMENTATION = "experimentation",
  INSTRUCTION = "instruction",
  NATURAL_PROGRESSION = "natural_progression"
}

const RANK_PROGRESSION_RULES = {
  SUB_RANK_RANGE: { MIN: 0, MAX: 9 },
  ESSENCE_RANK_CALCULATION: "Sum of all ability ranks in essence / number of abilities",
  OVERALL_RANK_CALCULATION: "Sum of all essence ranks / 4",
  ADVANCEMENT_THRESHOLD: "Overall rank must exceed current rank threshold",
  EXPONENTIAL_POWER_GROWTH: "Each rank exponentially more powerful than previous"
} as const;

const SPECIAL_ABILITY_REQUIREMENTS = {
  AURA_UNLOCK: "Typically unlocked with first essence progression",
  PERCEPTION_UNLOCK: "Usually unlocked with second or third essence",
  ONE_AURA_PER_SET: "Ideally one aura ability per essence set",
  ONE_PERCEPTION_PER_SET: "Ideally one perception ability per essence set"
} as const;

const ADVANCEMENT_EXAMPLES = {
  EXAMPLE_1: {
    essences: ["Swift", "Sword", "Might"],
    confluence: "Hero",
    progression_path: "Combat-focused advancement through battle experience"
  },
  EXAMPLE_2: {
    essences: ["Magic", "Knowledge", "Dimension"],
    confluence: "Mystic",
    progression_path: "Study and experimentation-based advancement"
  }
} as const;
Explanatory Notes
• Overall rank calculated by summing all essence ranks and dividing by 4
• Each essence rank determined by average of all ability ranks within that essence
• Sub-ranks range from 0-9, with 10 sub-ranks per main rank level
• Advancement requires using abilities in meaningful situations (combat, challenges, etc.)
• Power growth is exponential - higher ranks dramatically more powerful than lower ones
• Each essence set should ideally contain one aura and one perception ability
• Aura abilities provide passive environmental awareness and effects
• Perception abilities allow active scanning and information gathering
• Non-combat powers unlock utility, social, and specialized capabilities
• Advancement can occur through combat, training, meditation, or experimentation
• All abilities within an essence benefit when that essence's rank increases

Let me continue with Chapter VII - Items:

Chapter VII - Items
ER Diagram
mermaid
Copy Code
erDiagram
    items {
        string item_id PK
        string name
        enum item_type
        enum rarity_level
        enum rank_requirement
        string description
        number weight
        number value_spirit_coins
        boolean is_magical
        boolean is_consumable
    }
    
    armor_items {
        string armor_id PK
        string item_id FK
        enum armor_type
        number defense_rating
        number magical_resistance
        string special_properties
        enum material_type
        boolean covers_full_body
        number durability
    }
    
    weapon_items {
        string weapon_id PK
        string item_id FK
        enum weapon_category
        enum weapon_type
        number damage_rating
        number accuracy_bonus
        number range_meters
        string damage_type
        string special_abilities
        boolean is_summoned
        number durability
    }
    
    spirit_coins {
        string coin_id PK
        enum coin_type
        number denomination
        string description
        boolean is_currency
        boolean has_magical_properties
    }
    
    character_inventory {
        string inventory_id PK
        string character_id FK
        string item_id FK
        number quantity
        boolean is_equipped
        enum equipment_slot
        string customizations
        number condition_percentage
    }
    
    equipment_slots {
        string slot_id PK
        string slot_name
        enum slot_type
        boolean allows_multiple
        string restrictions
    }
    
    weapon_categories {
        string category_id PK
        string name
        string description
        enum required_attribute
        string usage_style
    }
    
    armor_types {
        string type_id PK
        string name
        number base_protection
        number mobility_penalty
        string coverage_areas
    }
    
    items ||--o{ armor_items : "armor_details"
    items ||--o{ weapon_items : "weapon_details"
    items ||--o{ character_inventory : "owned_by"
    equipment_slots ||--o{ character_inventory : "equipped_in"
    weapon_categories ||--o{ weapon_items : "categorized_as"
    armor_types ||--o{ armor_items : "typed_as"
Gameplay Flowchart
mermaid
Copy Code
flowchart TD
    A[Character Creation/Adventure] --> B{Find/Purchase Item?}
    B -->|Yes| C[Identify Item Type]
    B -->|No| D[Continue Adventure]
    C --> E{Item Type?}
    E -->|Armor| F[Check Armor Properties]
    E -->|Weapon| G[Check Weapon Properties]
    E -->|Spirit Coins| H[Add to Currency]
    E -->|Other| I[Add to Inventory]
    F --> J{Better than Current Armor?}
    J -->|Yes| K[Equip New Armor]
    J -->|No| L[Store in Inventory]
    G --> M{Weapon Category?}
    M -->|Melee| N[Check Damage/Accuracy]
    M -->|Ranged| O[Check Range/Damage]
    M -->|Magical| P[Check Special Abilities]
    N --> Q{Better than Current Weapon?}
    O --> Q
    P --> Q
    Q -->|Yes| R[Equip New Weapon]
    Q -->|No| S[Store in Inventory]
    K --> T[Update Defense Stats]
    R --> U[Update Attack Stats]
    T --> V[Apply Armor Bonuses]
    U --> W[Apply Weapon Bonuses]
    V --> X[Check Equipment Synergies]
    W --> X
    X --> Y{Magical Properties?}
    Y -->|Yes| Z[Activate Special Effects]
    Y -->|No| AA[Standard Equipment]
    Z --> BB[Apply Magical Bonuses]
    AA --> CC[Apply Base Stats]
    BB --> DD[Update Character Sheet]
    CC --> DD
    DD --> EE{Item Durability Check}
    EE -->|Damaged| FF[Repair or Replace]
    EE -->|Good Condition| GG[Continue Using]
    FF --> HH[Find Repair Services]
    HH --> II[Pay Repair Costs]
    II --> GG
    GG --> JJ[Combat/Adventure Usage]
    JJ --> KK{Item Breaks/Degrades?}
    KK -->|Yes| LL[Remove from Equipment]
    KK -->|No| MM[Continue Adventure]
    LL --> NN[Need Replacement]
    NN --> B
    MM --> D
    H --> OO[Update Currency Total]
    I --> PP[Manage Inventory Space]
    L --> PP
    S --> PP
    PP --> D
    OO --> D
    D --> QQ{Need Equipment?}
    QQ -->|Yes| B
    QQ -->|No| RR[End Equipment Phase]
TypeScript Enums & Constants
typescript
Copy Code
enum ItemType {
  ARMOR = "armor",
  WEAPON = "weapon",
  CONSUMABLE = "consumable",
  TOOL = "tool",
  CURRENCY = "currency",
  MATERIAL = "material",
  ACCESSORY = "accessory",
  MAGICAL_ITEM = "magical_item"
}

enum ArmorType {
  LIGHT_ARMOR = "light_armor",
  MEDIUM_ARMOR = "medium_armor", 
  HEAVY_ARMOR = "heavy_armor",
  ROBES = "robes",
  NATURAL_ARMOR = "natural_armor",
  MAGICAL_PROTECTION = "magical_protection"
}

enum WeaponCategory {
  MELEE = "melee",
  RANGED = "ranged",
  MAGICAL = "magical",
  SUMMONED = "summoned",
  IMPROVISED = "improvised"
}

enum WeaponType {
  SWORD = "sword",
  AXE = "axe",
  SPEAR = "spear",
  BOW = "bow",
  CROSSBOW = "crossbow",
  STAFF = "staff",
  WAND = "wand",
  DAGGER = "dagger",
  HAMMER = "hammer",
  WHIP = "whip",
  CLAW = "claw",
  FIST = "fist"
}

enum SpiritCoinType {
  IRON_SPIRIT_COIN = "iron_spirit_coin",
  BRONZE_SPIRIT_COIN = "bronze_spirit_coin",
  SILVER_SPIRIT_COIN = "silver_spirit_coin",
  GOLD_SPIRIT_COIN = "gold_spirit_coin",
  DIAMOND_SPIRIT_COIN = "diamond_spirit_coin"
}

enum EquipmentSlot {
  HEAD = "head",
  CHEST = "chest",
  LEGS = "legs",
  FEET = "feet",
  HANDS = "hands",
  MAIN_HAND = "main_hand",
  OFF_HAND = "off_hand",
  RING_1 = "ring_1",
  RING_2 = "ring_2",
  NECK = "neck",
  BACK = "back"
}

enum MaterialType {
  LEATHER = "leather",
  CLOTH = "cloth",
  CHAIN_MAIL = "chain_mail",
  PLATE = "plate",
  SCALE = "scale",
  MAGICAL_FABRIC = "magical_fabric",
  NATURAL = "natural",
  CRYSTALLINE = "crystalline"
}

const WEAPON_SKILL_CATEGORIES = {
  UNSKILLED: { accuracy: -2, damage: -1, description: "No training with weapon type" },
  BASIC: { accuracy: 0, damage: 0, description: "Basic competency" },
  SKILLED: { accuracy: +1, damage: +1, description: "Trained proficiency" },
  EXPERT: { accuracy: +2, damage: +2, description: "Master-level skill" },
  LEGENDARY: { accuracy: +3, damage: +3, description: "Legendary expertise" }
} as const;

const SPIRIT_COIN_VALUES = {
  [SpiritCoinType.IRON_SPIRIT_COIN]: 1,
  [SpiritCoinType.BRONZE_SPIRIT_COIN]: 100,
  [SpiritCoinType.SILVER_SPIRIT_COIN]: 10000,
  [SpiritCoinType.GOLD_SPIRIT_COIN]: 1000000,
  [SpiritCoinType.DIAMOND_SPIRIT_COIN]: 100000000
} as const;

const DURABILITY_SYSTEM = {
  MAX_DURABILITY: 100,
  REPAIR_THRESHOLD: 25,
  BREAK_THRESHOLD: 0,
  DEGRADATION_RATE: "Varies by usage and item quality"
} as const;
Explanatory Notes
• Armor provides defense rating and magical resistance, with different types offering varying protection levels
• Weapons are categorized by type and skill level, with accuracy and damage bonuses based on proficiency
• Four weapon skill categories: Unskilled (-2 accuracy, -1 damage) to Expert (+2 accuracy, +2 damage)
• Spirit coins serve as currency with exponential value increases between ranks
• Equipment has durability that degrades with use and can be repaired or replaced
• Magical items may have special properties beyond basic stat bonuses
• Characters have multiple equipment slots for different types of gear
• Weight and inventory management affects character mobility and carrying capacity
• Items can be customized or enhanced through various means
• Equipment synergies may provide additional bonuses when items work together

Now let me continue with Chapter VIII - Contracts:

Chapter VIII - Contracts
ER Diagram
mermaid
Copy Code
erDiagram
    contracts {
        string contract_id PK
        string contract_name
        enum contract_type
        string client_name
        string description
        enum difficulty_rating
        number reward_amount
        enum reward_currency
        string location
        number estimated_duration_days
        enum contract_status
        datetime posted_date
        datetime deadline_date
    }
    
    monster_hunting_contracts {
        string hunt_contract_id PK
        string contract_id FK
        string target_monster_species
        enum target_rank
        number target_quantity
        string last_known_location
        string special_requirements
        boolean requires_proof_of_kill
        string proof_type_required
    }
    
    contract_participants {
        string participant_id PK
        string contract_id FK
        string character_id FK
        enum participation_role
        number reward_share_percentage
        boolean is_contract_leader
        datetime joined_date
    }
    
    monsters {
        string monster_id PK
        string species_name
        enum monster_rank
        number sub_rank
        string habitat_type
        string behavioral_patterns
        string known_abilities
        enum threat_level
        string weaknesses
        string resistances
        number typical_group_size
    }
    
    monster_encounters {
        string encounter_id PK
        string monster_id FK
        string location_id FK
        number quantity_encountered
        enum encounter_outcome
        datetime encounter_date
        string participants_involved
        string loot_obtained
    }
    
    contract_rewards {
        string reward_id PK
        string contract_id FK
        enum reward_type
        number amount
        string item_description
        boolean is_distributed
        datetime distribution_date
    }
    
    monster_design_templates {
        string template_id PK
        string template_name
        enum base_rank
        string core_abilities
        string suggested_modifications
        string encounter_tactics
        string environmental_preferences
    }
    
    contracts ||--o{ monster_hunting_contracts : "specialized_as"
    contracts ||--o{ contract_participants : "involves"
    contracts ||--o{ contract_rewards : "offers"
    monsters ||--o{ monster_hunting_contracts : "targeted_by"
    monsters ||--o{ monster_encounters : "appears_in"
    monster_design_templates ||--o{ monsters : "based_on"
Gameplay Flowchart
mermaid
Copy Code
flowchart TD
    A[Visit Contract Board/Agency] --> B[Browse Available Contracts]
    B --> C{Contract Type?}
    C -->|Monster Hunting| D[Review Hunt Details]
    C -->|Other| E[Review General Contract]
    D --> F[Check Target Monster Info]
    F --> G[Assess Difficulty vs Reward]
    G --> H{Accept Contract?}
    E --> I[Review Requirements]
    I --> G
    H -->|No| J[Continue Browsing]
    H -->|Yes| K[Form/Join Party]
    K --> L[Plan Approach Strategy]
    L --> M{Monster Hunt?}
    M -->|Yes| N[Research Target Location]
    M -->|No| O[Prepare for Contract Type]
    N --> P[Travel to Hunt Area]
    P --> Q[Track Monster]
    Q --> R{Monster Found?}
    R -->|No| S[Continue Searching]
    R -->|Yes| T[Assess Monster Strength]
    T --> U{Engage Combat?}
    U -->|No| V[Retreat/Replan]
    U -->|Yes| W[Initiate Combat]
    W --> X[Execute Combat]
    X --> Y{Combat Outcome?}
    Y -->|Victory| Z[Collect Proof/Loot]
    Y -->|Defeat| AA[Retreat/Regroup]
    Z --> BB[Return to Client]
    BB --> CC[Submit Proof]
    CC --> DD[Receive Reward]
    DD --> EE[Distribute Among Party]
    EE --> FF[Contract Complete]
    AA --> GG{Retry Contract?}
    GG -->|Yes| HH[Heal/Reequip]
    GG -->|No| II[Abandon Contract]
    HH --> V
    II --> JJ[Contract Failed]
    V --> KK{New Strategy?}
    KK -->|Yes| L
    KK -->|No| II
    S --> LL{Time Limit Exceeded?}
    LL -->|Yes| II
    LL -->|No| Q
    O --> MM[Execute Contract Tasks]
    MM --> NN{Tasks Complete?}
    NN -->|Yes| BB
    NN -->|No| OO[Continue Working]
    OO --> MM
    J --> PP{More Contracts Available?}
    PP -->|Yes| B
    PP -->|No| QQ[Wait for New Contracts]
    QQ --> B
    FF --> RR[Gain Reputation]
    JJ --> SS[Lose Reputation]
    RR --> TT[Access Better Contracts]
    SS --> UU[Limited Contract Access]
    TT --> A
    UU --> A
TypeScript Enums & Constants
typescript
Copy Code
enum ContractType {
  MONSTER_HUNTING = "monster_hunting",
  ESCORT_MISSION = "escort_mission",
  ITEM_RETRIEVAL = "item_retrieval",
  INVESTIGATION = "investigation",
  PROTECTION_DETAIL = "protection_detail",
  EXPLORATION = "exploration",
  DIPLOMATIC_MISSION = "diplomatic_mission",
  CONSTRUCTION = "construction",
  RESEARCH_ASSISTANCE = "research_assistance"
}

enum DifficultyRating {
  TRIVIAL = "trivial",
  EASY = "easy",
  MODERATE = "moderate",
  HARD = "hard",
  EXTREME = "extreme",
  LEGENDARY = "legendary"
}

enum ContractStatus {
  POSTED = "posted",
  ACCEPTED = "accepted",
  IN_PROGRESS = "in_progress",
  COMPLETED = "completed",
  FAILED = "failed",
  CANCELLED = "cancelled",
  EXPIRED = "expired"
}

enum MonsterRank {
  LESSER = "lesser",
  IRON = "iron",
  BRONZE = "bronze",
  SILVER = "silver",
  GOLD = "gold",
  DIAMOND = "diamond"
}

enum ThreatLevel {
  MINIMAL = "minimal",
  LOW = "low",
  MODERATE = "moderate",
  HIGH = "high",
  EXTREME = "extreme",
  CATASTROPHIC = "catastrophic"
}

enum ParticipationRole {
  CONTRACT_LEADER = "contract_leader",
  COMBATANT = "combatant",
  SUPPORT = "support",
  SPECIALIST = "specialist",
  OBSERVER = "observer"
}

enum RewardType {
  SPIRIT_COINS = "spirit_coins",
  EQUIPMENT = "equipment",
  MATERIALS = "materials",
  INFORMATION = "information",
  REPUTATION = "reputation",
  ESSENCE = "essence",
  AWAKENING_STONE = "awakening_stone"
}

enum EncounterOutcome {
  PLAYER_VICTORY = "player_victory",
  MONSTER_VICTORY = "monster_victory",
  MUTUAL_RETREAT = "mutual_retreat",
  MONSTER_FLED = "monster_fled",
  PLAYER_FLED = "player_fled",
  NEGOTIATED_RESOLUTION = "negotiated_resolution"
}

const MONSTER_DESIGN_PRINCIPLES = {
  RANK_SCALING: "Monsters scale with player rank for appropriate challenge",
  UNIQUE_ABILITIES: "Each monster species has distinctive capabilities",
  ENVIRONMENTAL_ADAPTATION: "Monsters suited to their habitat",
  BEHAVIORAL_PATTERNS: "Consistent behavior based on intelligence and nature",
  WEAKNESS_EXPLOITATION: "All monsters have exploitable weaknesses"
} as const;

const CONTRACT_MECHANICS = {
  PARTY_FORMATION: "Multiple players can join single contract",
  REWARD_SHARING: "Rewards distributed based on contribution/agreement",
  TIME_LIMITS: "Most contracts have deadlines",
  REPUTATION_SYSTEM: "Success/failure affects future contract availability",
  PROOF_REQUIREMENTS: "Monster hunts typically require proof of completion"
} as const;
Explanatory Notes
• Contracts serve as structured adventure hooks with clear objectives and rewards
• Monster hunting contracts are the most common type, requiring specific targets to be eliminated
• Contract difficulty scales with monster rank and special requirements
• Parties can form to tackle contracts together with shared rewards
• Proof of completion is typically required (monster parts, witness testimony, etc.)
• Monster design follows templates but allows for customization and variation
• Each monster species has unique abilities, weaknesses, and behavioral patterns
• Contract success/failure affects character reputation and access to future contracts
• Rewards can include spirit coins, equipment, materials, essences, or awakening stones
• Time limits and deadlines add urgency to contract completion
• Environmental factors and monster habitats affect encounter difficulty

Now let me process Chapter IX - Abilities. Given the size and complexity of this chapter, I'll break it down into logical chunks as requested:

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

Chapter IX - Abilities (Part 2: Item-Focused Abilities)
ER Diagram
mermaid
Copy Code
erDiagram
    item_focused_abilities {
        string item_ability_id PK
        string ability_id FK
        enum item_focus_type
        string item_description
        number duration_seconds
        boolean is_permanent_until_dismissed
        string special_properties
        number item_rank
    }
    
    weapon_summoning {
        string weapon_summon_id PK
        string item_ability_id FK
        enum weapon_type
        number damage_rating
        string weapon_properties
        number summoning_time_seconds
        boolean requires_materials
        string material_requirements
        number weapon_durability
    }
    
    ammunition_summoning {
        string ammo_summon_id PK
        string item_ability_id FK
        enum ammunition_type
        number quantity_per_cast
        string special_effects
        boolean is_magical
        number damage_bonus
        string target_restrictions
    }
    
    armor_summoning {
        string armor_summon_id PK
        string item_ability_id FK
        enum armor_type
        number defense_rating
        string armor_properties
        number coverage_percentage
        boolean replaces_existing_armor
        string appearance_description
    }
    
    summoned_item_properties {
        string property_id PK
        string item_ability_id FK
        string property_name
        string property_description
        enum property_type
        number property_value
        string activation_condition
    }
    
    item_customization_options {
        string customization_id PK
        string item_ability_id FK
        string customization_name
        string description
        number rank_requirement
        string mechanical_effect
    }
    
    item_focused_abilities ||--o{ weapon_summoning : "summons_weapon"
    item_focused_abilities ||--o{ ammunition_summoning : "summons_ammo"
    item_focused_abilities ||--o{ armor_summoning : "summons_armor"
    item_focused_abilities ||--o{ summoned_item_properties : "has_properties"
    item_focused_abilities ||--o{ item_customization_options : "allows_customization"
Gameplay Flowchart
mermaid
Copy Code
flowchart TD
    A[Activate Item-Focused Ability] --> B{Item Focus Type?}
    B -->|Weapon Summoning| C[Summon Weapon]
    B -->|Ammunition| D[Create Ammunition]
    B -->|Armor| E[Summon Armor]
    C --> F{Materials Required?}
    F -->|Yes| G[Check Material Availability]
    F -->|No| H[Begin Summoning]
    G --> I{Materials Available?}
    I -->|No| J[Ability Fails]
    I -->|Yes| H
    H --> K[Complete Summoning Time]
    K --> L[Weapon Appears]
    L --> M[Equip Weapon]
    M --> N{Existing Weapon?}
    N -->|Yes| O[Dismiss/Store Old Weapon]
    N -->|No| P[Ready for Combat]
    O --> P
    D --> Q[Generate Ammunition]
    Q --> R{Ammunition Type?}
    R -->|Standard| S[Create Basic Ammo]
    R -->|Special| T[Create Enhanced Ammo]
    S --> U[Add to Inventory]
    T --> V[Apply Special Effects]
    V --> U
    U --> W[Ready for Use]
    E --> X{Armor Summoning Type?}
    X -->|Replacement| Y[Dismiss Current Armor]
    X -->|Additional| Z[Layer Over Existing]
    Y --> AA[Summon New Armor]
    Z --> AA
    AA --> BB[Apply Armor Properties]
    BB --> CC[Update Defense Stats]
    CC --> DD[Armor Active]
    P --> EE[Use Summoned Weapon]
    W --> FF[Use Ammunition]
    DD --> GG[Benefit from Armor]
    EE --> HH{Weapon Durability?}
    HH -->|Damaged| II[Repair or Resummon]
    HH -->|Good| JJ[Continue Using]
    FF --> KK{Ammo Depleted?}
    KK -->|Yes| LL[Resummon Ammunition]
    KK -->|No| MM[Continue Using]
    GG --> NN{Armor Duration?}
    NN -->|Expired| OO[Armor Dissipates]
    NN -->|Permanent| PP[Maintain Until Dismissed]
    II --> QQ{Repair or Replace?}
    QQ -->|Repair| RR[Use Repair Ability/Service]
    QQ -->|Replace| SS[Resummon Weapon]
    RR --> JJ
    SS --> C
    LL --> D
    OO --> TT[Return to Normal Armor]
    PP --> UU[Manual Dismissal Option]
    UU --> TT
    JJ --> VV[Continue Adventure]
    MM --> VV
    TT --> VV
    J --> WW[Try Again Later]
TypeScript Enums & Constants
typescript
Copy Code
enum ItemFocusType {
  WEAPON_SUMMONING = "weapon_summoning",
  AMMUNITION = "ammunition",
  ARMOR = "armor"
}

enum SummonedWeaponType {
  SWORD = "sword",
  BOW = "bow",
  STAFF = "staff",
  SPEAR = "spear",
  AXE = "axe",
  HAMMER = "hammer",
  DAGGER = "dagger",
  WHIP = "whip",
  CROSSBOW = "crossbow",
  WAND = "wand",
  SHIELD = "shield",
  EXOTIC = "exotic"
}

enum AmmunitionType {
  ARROWS = "arrows",
  BOLTS = "bolts",
  BULLETS = "bullets",
  THROWING_KNIVES = "throwing_knives",
  MAGICAL_PROJECTILES = "magical_projectiles",
  ENERGY_BLASTS = "energy_blasts",
  ELEMENTAL_SHOTS = "elemental_shots"
}

enum SummonedArmorType {
  LIGHT_ARMOR = "light_armor",
  MEDIUM_ARMOR = "medium_armor",
  HEAVY_ARMOR = "heavy_armor",
  MAGICAL_BARRIER = "magical_barrier",
  ELEMENTAL_PROTECTION = "elemental_protection",
  PARTIAL_COVERAGE = "partial_coverage",
  FULL_BODY = "full_body"
}

enum PropertyType {
  DAMAGE_BONUS = "damage_bonus",
  ACCURACY_BONUS = "accuracy_bonus",
  SPECIAL_EFFECT = "special_effect",
  ELEMENTAL_DAMAGE = "elemental_damage",
  ARMOR_PENETRATION = "armor_penetration",
  LIFE_STEAL = "life_steal",
  MANA_EFFICIENCY = "mana_efficiency",
  DURABILITY_BONUS = "durability_bonus"
}

const WEAPON_SUMMONING_MECHANICS = {
  BASE_SUMMONING_TIME: 2, // seconds
  MATERIAL_REQUIREMENTS: "Some weapons require specific materials",
  DURABILITY_SYSTEM: "Summoned weapons can be damaged and need repair/resummon",
  CUSTOMIZATION: "Properties can be modified based on rank and awakening stone",
  DISMISSAL: "Can be dismissed at will to summon different weapon"
} as const;

const AMMUNITION_MECHANICS = {
  QUANTITY_SCALING: "Higher ranks produce more ammunition per cast",
  SPECIAL_EFFECTS: "Can have elemental damage, tracking, or other properties",
  STORAGE: "Created ammunition goes to inventory for later use",
  MAGICAL_TYPES: "Some ammunition types are purely magical energy",
  COST_EFFICIENCY: "Higher ranks reduce mana cost per projectile"
} as const;

const ARMOR_MECHANICS = {
  REPLACEMENT_VS_ADDITION: "Can replace existing armor or layer over it",
  COVERAGE_OPTIONS: "Partial or full body coverage available",
  DURATION_TYPES: "Can be permanent until dismissed or time-limited",
  APPEARANCE_CUSTOMIZATION: "Visual appearance can be customized",
  PROPERTY_STACKING: "Multiple armor pieces may stack benefits"
} as const;
Explanatory Notes
• Item-focused abilities create temporary or permanent equipment for the character
• Weapon summoning can require specific materials and has customizable properties
• Summoned weapons have durability and can be repaired or re-summoned as needed
• Ammunition abilities create projectiles with potential special effects or elemental damage
• Armor summoning can replace existing armor or provide additional protection layers
• All summoned items can be customized based on character rank and awakening stone used
• Higher ranks typically improve quantity, quality, duration, and reduce mana costs
• Summoned items can be dismissed at will to make room for different equipment
• Some abilities create permanent items until manually dismissed, others have time limits

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

Chapter IX - Abilities (Part 4: Mobility Abilities)
ER Diagram
mermaid
Copy Code
erDiagram
    mobility_abilities {
        string mobility_id PK
        string ability_id FK
        enum mobility_type
        number range_meters
        string movement_restrictions
        boolean requires_line_of_sight
        boolean can_carry_others
        number passenger_capacity
    }
    
    teleportation_abilities {
        string teleport_id PK
        string mobility_id FK
        enum teleport_type
        number max_distance
        boolean requires_target_location
        boolean can_teleport_through_barriers
        string teleport_restrictions
        number accuracy_range
        string failure_consequences
    }
    
    extreme_speed_abilities {
        string speed_id PK
        string mobility_id FK
        number speed_multiplier
        number duration_seconds
        boolean affects_combat_actions
        boolean allows_wall_running
        boolean allows_water_walking
        string speed_limitations
    }
    
    flying_abilities {
        string flying_id PK
        string mobility_id FK
        enum flight_type
        number max_altitude_meters
        number flight_speed
        boolean requires_concentration
        string flight_restrictions
        boolean can_hover
        number maneuverability_rating
    }
    
    mobility_enhancements {
        string enhancement_id PK
        string mobility_id FK
        string enhancement_name
        string description
        number rank_requirement
        string mechanical_benefit
    }
    
    movement_costs {
        string cost_id PK
        string mobility_id FK
        number mana_cost_base
        number stamina_cost_base
        enum cost_scaling
        string cost_modifiers
    }
    
    mobility_abilities ||--o{ teleportation_abilities : "teleport_type"
    mobility_abilities ||--o{ extreme_speed_abilities : "speed_type"
    mobility_abilities ||--o{ flying_abilities : "flight_type"
    mobility_abilities ||--o{ mobility_enhancements : "enhanced_by"
    mobility_abilities ||--o{ movement_costs : "costs"
Gameplay Flowchart
mermaid
Copy Code
flowchart TD
    A[Activate Mobility Ability] --> B{Mobility Type?}
    B -->|Teleportation| C[Select Teleport Destination]
    B -->|Extreme Speed| D[Activate Speed Enhancement]
    B -->|Flying| E[Begin Flight Mode]
    C --> F{Valid Destination?}
    F -->|No| G[Ability Fails]
    F -->|Yes| H{Line of Sight Required?}
    H -->|Yes| I{Can See Destination?}
    H -->|No| J[Proceed with Teleport]
    I -->|No| G
    I -->|Yes| J
    J --> K{Carrying Others?}
    K -->|Yes| L[Check Passenger Capacity]
    K -->|No| M[Solo Teleport]
    L --> N{Within Capacity?}
    N -->|No| O[Reduce Passengers or Fail]
    N -->|Yes| P[Group Teleport]
    M --> Q[Execute Teleportation]
    P --> Q
    Q --> R{Teleport Successful?}
    R -->|No| S[Teleport Failure Effects]
    R -->|Yes| T[Arrive at Destination]
    D --> U[Apply Speed Multiplier]
    U --> V{Duration Type?}
    V -->|Fixed Duration| W[Set Timer]
    V -->|Concentration| X[Maintain Focus]
    W --> Y[Enhanced Movement Active]
    X --> Y
    Y --> Z{Special Movement?}
    Z -->|Wall Running| AA[Enable Wall Movement]
    Z -->|Water Walking| BB[Enable Water Surface]
    Z -->|Normal| CC[Standard Enhanced Speed]
    AA --> DD[Move on Vertical Surfaces]
    BB --> EE[Move on Water]
    CC --> FF[Move at High Speed]
    E --> GG{Flight Type?}
    GG -->|Powered Flight| HH[Continuous Flight]
    GG -->|Gliding| II[Gliding Mode]
    GG -->|Hovering| JJ[Stationary Flight]
    HH --> KK[Set Altitude and Speed]
    II --> LL[Descending Flight Path]
    JJ --> MM[Maintain Position]
    KK --> NN{Concentration Required?}
    NN -->|Yes| OO[Maintain Focus]
    NN -->|No| PP[Automatic Flight]
    OO --> QQ{Concentration Broken?}
    QQ -->|Yes| RR[Begin Falling]
    QQ -->|No| SS[Continue Flying]
    PP --> SS
    SS --> TT{Duration Expired?}
    TT -->|Yes| UU[End Flight]
    TT -->|No| VV[Continue Flight]
    UU --> WW[Land/Fall]
    VV --> XX{Change Altitude/Direction?}
    XX -->|Yes| YY[Adjust Flight Path]
    XX -->|No| SS
    YY --> SS
    DD --> ZZ[Check Duration/Stamina]
    EE --> ZZ
    FF --> ZZ
    ZZ --> AAA{Effect Continues?}
    AAA -->|Yes| BBB[Maintain Enhancement]
    AAA -->|No| CCC[Return to Normal Speed]
    BBB --> DDD{New Movement Action?}
    DDD -->|Yes| Z
    DDD -->|No| EEE[Wait/Other Actions]
    CCC --> FFF[Speed Enhancement Ends]
    T --> GGG[Teleportation Complete]
    S --> HHH[Handle Failure]
    RR --> III[Fall Damage Check]
    WW --> JJJ[Landing Resolution]
    G --> KKK[Ability Wasted]
    O --> KKK
    GGG --> LLL[Continue Adventure]
    FFF --> LLL
    JJJ --> LLL
    III --> LLL
    HHH --> LLL
    KKK --> LLL
    EEE --> LLL
TypeScript Enums & Constants
typescript
Copy Code
enum MobilityType {
  TELEPORTATION = "teleportation",
  EXTREME_SPEED = "extreme_speed",
  FLYING_POWER = "flying_power"
}

enum TeleportType {
  INSTANT_TELEPORT = "instant_teleport",
  SHORT_RANGE_BLINK = "short_range_blink",
  LONG_RANGE_TELEPORT = "long_range_teleport",
  DIMENSIONAL_STEP = "dimensional_step",
  SHADOW_STEP = "shadow_step",
  PORTAL_CREATION = "portal_creation"
}

enum FlightType {
  POWERED_FLIGHT = "powered_flight",
  GLIDING = "gliding",
  HOVERING = "hovering",
  LEVITATION = "levitation",
  WING_MANIFESTATION = "wing_manifestation",
  MAGICAL_FLIGHT = "magical_flight"
}

enum CostScaling {
  FIXED = "fixed",
  DISTANCE_BASED = "distance_based",
  DURATION_BASED = "duration_based",
  PASSENGER_BASED = "passenger_based",
  ALTITUDE_BASED = "altitude_based"
}

const TELEPORTATION_MECHANICS = {
  LINE_OF_SIGHT: "Many teleports require visual confirmation of destination",
  ACCURACY: "Long-range teleports may have accuracy variance",
  BARRIERS: "Some teleports blocked by magical or physical barriers",
  FAILURE_CONSEQUENCES: "Failed teleports may cause damage or displacement",
  PASSENGER_LIMITS: "Carrying capacity affects mana cost and success chance"
} as const;

const EXTREME_SPEED_MECHANICS = {
  SPEED_MULTIPLIERS: "Typically 2x to 10x normal movement speed",
  SPECIAL_MOVEMENT: "May enable wall-running, water-walking, or ceiling movement",
  COMBAT_INTEGRATION: "Enhanced speed affects initiative and dodge chances",
  DURATION_LIMITS: "Most speed enhancements have time limits or stamina costs",
  CONCENTRATION: "Some abilities require focus to maintain"
} as const;

const FLYING_MECHANICS = {
  ALTITUDE_LIMITS: "Maximum height varies by ability and rank",
  MANEUVERABILITY: "Flight agility affects combat and navigation",
  CONCENTRATION_REQUIREMENTS: "Some flight requires continuous focus",
  LANDING_SAFETY: "Controlled vs uncontrolled landings",
  WEATHER_EFFECTS: "Environmental conditions may affect flight"
} as const;

const MOBILITY_ENHANCEMENTS = [
  "Increased range/distance",
  "Reduced mana/stamina costs", 
  "Faster activation time",
  "Additional passengers",
  "Improved accuracy",
  "Barrier penetration",
  "Silent movement",
  "Combat maneuvers while moving"
] as const;
Explanatory Notes
• Teleportation abilities provide instant movement with varying range, accuracy, and restrictions
• Line of sight requirements and barrier penetration vary by teleportation type
• Extreme speed abilities multiply movement rate and may enable special movement types
• Flying abilities range from simple hovering to full three-dimensional flight with altitude limits
• Passenger capacity allows transporting others but increases mana costs and complexity
• Concentration-based abilities can be interrupted, potentially causing dangerous failures
• Distance, duration, and passenger count all affect the mana and stamina costs
• Higher ranks typically increase range, reduce costs, and add special capabilities
• Failed mobility attempts may have consequences like damage, displacement, or being stuck
• Combat applications include enhanced initiative, dodge bonuses, and tactical positioning

Chapter IX - Abilities (Part 5: Perception Abilities)
ER Diagram
mermaid
Copy Code
erDiagram
    perception_abilities {
        string perception_id PK
        string ability_id FK
        enum perception_category
        number detection_range_meters
        boolean requires_concentration
        boolean is_passive
        string detection_capabilities
        number accuracy_rating
    }
    
    aura_abilities {
        string aura_id PK
        string perception_id FK
        enum aura_type
        number aura_radius_meters
        boolean always_active
        string passive_effects
        string detection_types
        boolean affects_others
        string aura_interactions
    }
    
    illusion_abilities {
        string illusion_id PK
        string perception_id FK
        enum illusion_type
        number illusion_complexity
        number duration_seconds
        boolean affects_multiple_senses
        string illusion_limitations
        number detection_difficulty
    }
    
    active_perception {
        string active_perc_id PK
        string perception_id FK
        enum scan_type
        number scan_duration_seconds
        string information_provided
        boolean penetrates_concealment
        string scan_limitations
    }
    
    perception_enhancements {
        string enhancement_id PK
        string perception_id FK
        string enhancement_name
        string description
        number rank_requirement
        string mechanical_benefit
    }
    
    detection_results {
        string result_id PK
        string perception_id FK
        string target_detected
        enum detection_level
        string information_gained
        datetime detection_time
        number confidence_rating
    }
    
    perception_abilities ||--o{ aura_abilities : "aura_type"
    perception_abilities ||--o{ illusion_abilities : "illusion_type"
    perception_abilities ||--o{ active_perception : "active_type"
    perception_abilities ||--o{ perception_enhancements : "enhanced_by"
    perception_abilities ||--o{ detection_results : "produces"
Gameplay Flowchart
mermaid
Copy Code
flowchart TD
    A[Use Perception Ability] --> B{Perception Category?}
    B -->|Aura| C[Activate/Check Aura]
    B -->|Illusion| D[Create Illusion]
    B -->|Active Perception| E[Begin Active Scan]
    C --> F{Aura Type?}
    F -->|Detection| G[Scan for Targets in Range]
    F -->|Intimidation| H[Apply Fear Effects]
    F -->|Inspiration| I[Apply Morale Boosts]
    F -->|Other| J[Apply Aura Effects]
    G --> K{Targets in Range?}
    K -->|Yes| L[Detect Targets]
    K -->|No| M[No Detection]
    L --> N[Determine Detection Level]
    N --> O{Detection Quality?}
    O -->|Basic| P[General Presence/Direction]
    O -->|Detailed| Q[Specific Information]
    O -->|Complete| R[Full Analysis]
    D --> S{Illusion Type?}
    S -->|Visual| T[Create Visual Deception]
    S -->|Auditory| U[Create Sound Illusion]
    S -->|Multi-Sensory| V[Complex Illusion]
    S -->|Mental| W[Direct Mind Illusion]
    T --> X[Set Illusion Parameters]
    U --> X
    V --> X
    W --> X
    X --> Y{Target Awareness Check?}
    Y -->|Aware| Z[Illusion Detected/Resisted]
    Y -->|Unaware| AA[Illusion Successful]
    AA --> BB[Maintain Illusion]
    BB --> CC{Duration Expired?}
    CC -->|No| DD{Concentration Required?}
    CC -->|Yes| EE[Illusion Ends]
    DD -->|Yes| FF{Concentration Maintained?}
    DD -->|No| GG[Illusion Continues]
    FF -->|No| EE
    FF -->|Yes| GG
    GG --> CC
    E --> HH{Scan Type?}
    HH -->|Life Detection| II[Scan for Living Beings]
    HH -->|Magic Detection| JJ[Scan for Magical Auras]
    HH -->|Threat Assessment| KK[Evaluate Danger Levels]
    HH -->|Essence Analysis| LL[Analyze Essence Types]
    II --> MM[Process Life Signatures]
    JJ --> NN[Process Magical Signatures]
    KK --> OO[Process Threat Levels]
    LL --> PP[Process Essence Information]
    MM --> QQ[Compile Scan Results]
    NN --> QQ
    OO --> QQ
    PP --> QQ
    QQ --> RR{Information Quality?}
    RR -->|Basic| SS[General Information]
    RR -->|Detailed| TT[Specific Details]
    RR -->|Comprehensive| UU[Complete Analysis]
    SS --> VV[Present Results to User]
    TT --> VV
    UU --> VV
    H --> WW[Apply Intimidation Effects]
    I --> XX[Apply Inspiration Effects]
    J --> YY[Apply Special Aura Effects]
    WW --> ZZ[Check Target Resistance]
    XX --> AAA[Check Target Receptivity]
    YY --> BBB[Apply Effect Mechanics]
    ZZ --> CCC{Resistance Successful?}
    CCC -->|Yes| DDD[Reduced/No Effect]
    CCC -->|No| EEE[Full Intimidation Effect]
    AAA --> FFF{Receptive to Inspiration?}
    FFF -->|Yes| GGG[Full Inspiration Effect]
    FFF -->|No| HHH[Reduced Effect]
    P --> III[Basic Detection Information]
    Q --> JJJ[Detailed Detection Information]
    R --> KKK[Complete Detection Information]
    M --> LLL[No Information Gained]
    Z --> MMM[Illusion Compromised]
    EE --> NNN[Illusion Effect Ends]
    VV --> OOO[Perception Complete]
    III --> OOO
    JJJ --> OOO
    KKK --> OOO
    LLL --> OOO
    DDD --> OOO
    EEE --> OOO
    GGG --> OOO
    HHH --> OOO
    BBB --> OOO
    MMM --> OOO
    NNN --> OOO
TypeScript Enums & Constants
typescript
Copy Code
enum PerceptionCategory {
  AURA = "aura",
  ILLUSION = "illusion", 
  ACTIVE_PERCEPTION = "active_perception"
}

enum AuraType {
  DETECTION = "detection",
  INTIMIDATION = "intimidation",
  INSPIRATION = "inspiration",
  MAGICAL_SUPPRESSION = "magical_suppression",
  HEALING = "healing",
  PROTECTION = "protection",
  ELEMENTAL = "elemental"
}

enum IllusionType {
  VISUAL = "visual",
  AUDITORY = "auditory",
  MULTI_SENSORY = "multi_sensory",
  MENTAL = "mental",
  ENVIRONMENTAL = "environmental",
  OBJECT_DISGUISE = "object_disguise"
}

enum ScanType {
  LIFE_DETECTION = "life_detection",
  MAGIC_DETECTION = "magic_detection",
  THREAT_ASSESSMENT = "threat_assessment",
  ESSENCE_ANALYSIS = "essence_analysis",
  DIMENSIONAL_AWARENESS = "dimensional_awareness",
  EMOTIONAL_READING = "emotional_reading"
}

enum DetectionLevel {
  NONE = "none",
  BASIC = "basic",
  DETAILED = "detailed",
  COMPLETE = "complete",
  OVERWHELMING = "overwhelming"
}

const AURA_MECHANICS = {
  PASSIVE_DETECTION: "Always-on awareness within aura radius",
  AUTOMATIC_EFFECTS: "Auras apply effects without conscious activation",
  INTERACTION_RULES: "Multiple auras can interact or interfere",
  CONCEALMENT_PENETRATION: "Some auras pierce stealth and illusions",
  RANGE_SCALING: "Aura radius increases with rank advancement"
} as const;

const ILLUSION_MECHANICS = {
  COMPLEXITY_SCALING: "More complex illusions require higher rank",
  SENSORY_COVERAGE: "Can affect sight, sound, touch, smell, taste",
  DETECTION_RESISTANCE: "Higher rank illusions harder to detect",
  CONCENTRATION_REQUIREMENTS: "Complex illusions may require focus",
  INTERACTION_LIMITS: "Illusions may break if interacted with physically"
} as const;

const ACTIVE_PERCEPTION_MECHANICS = {
  SCAN_DURATION: "Active scans take time to complete",
  INFORMATION_DEPTH: "Longer scans provide more detailed information",
  CONCEALMENT_PENETRATION: "Can pierce various forms of hiding",
  RANGE_LIMITATIONS: "Effectiveness decreases with distance",
  INTERFERENCE_FACTORS: "Magical interference can reduce accuracy"
} as const;

const PERCEPTION_ENHANCEMENTS = [
  "Increased detection range",
  "Improved information quality",
  "Faster scan completion",
  "Penetration of stronger concealment",
  "Multiple simultaneous targets",
  "Passive background scanning",
  "Resistance to counter-detection",
  "Integration with other abilities"
] as const;
Explanatory Notes
• Aura abilities provide passive environmental awareness and can affect others within range
• Detection auras automatically sense targets, threats, or magical phenomena nearby
• Illusion abilities create false sensory information to deceive observers
• Active perception requires conscious use but provides detailed, targeted information
• Scan types include life detection, magic sensing, threat assessment, and essence analysis
• Detection quality ranges from basic awareness to complete detailed analysis
• Illusion complexity affects both effectiveness and the difficulty of maintaining them
• Concentration-based abilities can be interrupted, breaking the effect
• Higher ranks improve range, accuracy, information depth, and resistance to countermeasures
• Perception abilities often work together, with auras providing background awareness while active scans give specific details

Chapter IX - Abilities (Part 6: Summoning Abilities)
ER Diagram
mermaid
Copy Code
erDiagram
    summoning_abilities {
        string summoning_id PK
        string ability_id FK
        enum summoning_category
        number max_summons_active
        number summoning_time_seconds
        number maintenance_cost_per_second
        boolean requires_materials
        string material_requirements
    }
    
    summon_creatures {
        string summon_id PK
        string summoning_id FK
        string creature_name
        enum creature_type
        enum creature_rank
        number health_points
        number combat_effectiveness
        string special_abilities
        number duration_seconds
        boolean is_permanent
        string dismissal_conditions
    }
    
    familiar_bonds {
        string familiar_id PK
        string summoning_id FK
        string familiar_name
        enum familiar_type
        boolean is_permanent_bond
        string bond_benefits
        string shared_abilities
        number intelligence_level
        string communication_method
        string growth_potential
    }
    
    summon_commands {
        string command_id PK
        string summon_id FK
        enum command_type
        string command_description
        boolean requires_action_point
        number range_meters
        string execution_conditions
    }
    
    summon_upgrades {
        string upgrade_id PK
        string summoning_id FK
        string upgrade_name
        string description
        number rank_requirement
        string mechanical_improvement
        string visual_changes
    }
    
    summoning_rituals {
        string ritual_id PK
        string summoning_id FK
        number ritual_duration_minutes
        string ritual_requirements
        string ritual_components
        boolean can_be_interrupted
        string interruption_consequences
    }
    
    summoning_abilities ||--o{ summon_creatures : "creates"
    summoning_abilities ||--o{ familiar_bonds : "bonds_with"
    summon_creatures ||--o{ summon_commands : "responds_to"
    summoning_abilities ||--o{ summon_upgrades : "enhanced_by"
    summoning_abilities ||--o{ summoning_rituals : "requires_ritual"
Gameplay Flowchart
mermaid
Copy Code
flowchart TD
    A[Activate Summoning Ability] --> B{Summoning Category?}
    B -->|Summon Creature| C[Begin Creature Summoning]
    B -->|Familiar Bond| D[Initiate Familiar Bonding]
    C --> E{Ritual Required?}
    E -->|Yes| F[Begin Summoning Ritual]
    E -->|No| G[Direct Summoning]
    F --> H[Gather Ritual Components]
    H --> I{Components Available?}
    I -->|No| J[Summoning Fails]
    I -->|Yes| K[Begin Ritual Casting]
    K --> L{Ritual Interrupted?}
    L -->|Yes| M[Ritual Fails/Consequences]
    L -->|No| N[Complete Ritual]
    N --> O[Summon Appears]
    G --> P{Materials Required?}
    P -->|Yes| Q[Check Material Availability]
    P -->|No| R[Begin Summoning]
    Q --> S{Materials Available?}
    S -->|No| J
    S -->|Yes| R
    R --> T[Complete Summoning Time]
    T --> O
    O --> U{Max Summons Reached?}
    U -->|Yes| V[Dismiss Existing or Fail]
    U -->|No| W[Add to Active Summons]
    V --> X{Dismiss Existing?}
    X -->|Yes| Y[Select Summon to Dismiss]
    X -->|No| J
    Y --> Z[Dismiss Selected Summon]
    Z --> W
    W --> AA[Summon Under Control]
    AA --> BB{Give Commands?}
    BB -->|Yes| CC[Issue Command]
    BB -->|No| DD[Summon Acts Independently]
    CC --> EE{Command Type?}
    EE -->|Attack| FF[Target Enemy]
    EE -->|Defend| GG[Protect Ally/Area]
    EE -->|Move| HH[Relocate Summon]
    EE -->|Special| II[Use Special Ability]
    FF --> JJ[Execute Attack Command]
    GG --> KK[Execute Defense Command]
    HH --> LL[Execute Movement]
    II --> MM[Execute Special Action]
    JJ --> NN[Check Command Success]
    KK --> NN
    LL --> NN
    MM --> NN
    DD --> OO[Summon AI Behavior]
    OO --> PP[Summon Acts on Instinct]
    NN --> QQ{Summon Still Active?}
    PP --> QQ
    QQ -->|Yes| RR[Continue Summon Control]
    QQ -->|No| SS[Summon Dismissed/Destroyed]
    RR --> TT{Duration Expired?}
    TT -->|Yes| UU[Natural Dismissal]
    TT -->|No| VV{Maintenance Cost?}
    VV -->|Yes| WW[Pay Mana Cost]
    VV -->|No| XX[Free Maintenance]
    WW --> YY{Sufficient Mana?}
    YY -->|No| ZZ[Forced Dismissal]
    YY -->|Yes| XX
    XX --> AAA[Summon Continues]
    AAA --> BB
    D --> BBB[Select Familiar Type]
    BBB --> CCC{Bonding Ritual Required?}
    CCC -->|Yes| DDD[Perform Bonding Ritual]
    CCC -->|No| EEE[Direct Bonding]
    DDD --> FFF[Complete Bonding Process]
    EEE --> FFF
    FFF --> GGG[Familiar Bond Established]
    GGG --> HHH[Gain Bond Benefits]
    HHH --> III{Shared Abilities?}
    III -->|Yes| JJJ[Access Familiar Abilities]
    III -->|No| KKK[Standard Familiar Benefits]
    JJJ --> LLL[Familiar Available]
    KKK --> LLL
    LLL --> MMM{Familiar Growth?}
    MMM -->|Yes| NNN[Familiar Advances]
    MMM -->|No| OOO[Maintain Current Level]
    NNN --> PPP[Enhanced Familiar Capabilities]
    PPP --> QQQ[Continue Adventure]
    OOO --> QQQ
    UU --> RRR[Summon Duration Ended]
    ZZ --> SSS[Summon Mana Depleted]
    SS --> TTT[Summon No Longer Available]
    J --> UUU[Summoning Failed]
    M --> VVV[Ritual Consequences]
    RRR --> QQQ
    SSS --> QQQ
    TTT --> QQQ
    UUU --> QQQ
    VVV --> QQQ
TypeScript Enums & Constants
typescript
Copy Code
enum SummoningCategory {
  SUMMON_CREATURE = "summon_creature",
  FAMILIAR_BOND = "familiar_bond"
}

enum CreatureType {
  ELEMENTAL = "elemental",
  BEAST = "beast",
  CONSTRUCT = "construct",
  UNDEAD = "undead",
  SPIRIT = "spirit",
  DEMON = "demon",
  ANGEL = "angel",
  NATURE_SPIRIT = "nature_spirit",
  MAGICAL_CREATURE = "magical_creature"
}

enum FamiliarType {
  ANIMAL_COMPANION = "animal_companion",
  MAGICAL_FAMILIAR = "magical_familiar",
  ELEMENTAL_SPIRIT = "elemental_spirit",
  CONSTRUCT_SERVANT = "construct_servant",
  SHADOW_COMPANION = "shadow_companion",
  NATURE_BOND = "nature_bond"
}

enum CommandType {
  ATTACK = "attack",
  DEFEND = "defend",
  MOVE = "move",
  GUARD = "guard",
  SCOUT = "scout",
  RETRIEVE = "retrieve",
  SPECIAL_ABILITY = "special_ability",
  RETURN = "return",
  DISMISS = "dismiss"
}

enum CreatureRank {
  LESSER = "lesser",
  IRON = "iron",
  BRONZE = "bronze",
  SILVER = "silver",
  GOLD = "gold",
  DIAMOND = "diamond"
}

const SUMMONING_MECHANICS = {
  MAX_ACTIVE_LIMITS: "Number of simultaneous summons limited by rank",
  MAINTENANCE_COSTS: "Ongoing mana cost to keep summons active",
  COMMAND_STRUCTURE: "Summons follow orders or act on basic instincts",
  DURATION_LIMITS: "Most summons have time limits before auto-dismissal",
  MATERIAL_REQUIREMENTS: "Some summons require specific components"
} as const;

const FAMILIAR_MECHANICS = {
  PERMANENT_BONDS: "Familiars typically permanent until dismissed or killed",
  SHARED_ABILITIES: "Some familiars grant access to their special abilities",
  INTELLIGENCE_SCALING: "Familiar intelligence affects autonomy and capabilities",
  GROWTH_POTENTIAL: "Familiars can advance alongside their summoner",
  COMMUNICATION: "Methods range from empathic to full telepathic"
} as const;

const SUMMON_UPGRADES = [
  "Increased health and combat effectiveness",
  "Additional special abilities",
  "Longer duration or reduced maintenance cost",
  "Enhanced intelligence and autonomy",
  "Resistance to dispelling",
  "Ability to use summoner's equipment",
  "Elemental or magical enhancements",
  "Pack tactics with other summons"
] as const;

const COMMAND_LIMITATIONS = {
  RANGE_RESTRICTIONS: "Commands have maximum effective range",
  INTELLIGENCE_REQUIREMENTS: "Complex commands need intelligent summons",
  ACTION_POINT_COSTS: "Some commands require summoner's action points",
  COMMUNICATION_BARRIERS: "Language or telepathic connection needed",
  AUTONOMOUS_BEHAVIOR: "Summons may act independently if not commanded"
} as const;
Explanatory Notes
• Summoning abilities create temporary creatures or establish permanent familiar bonds
• Creature summons have time limits and maintenance costs, while familiars are typically permanent
• Command structure allows direct control or autonomous behavior based on summon intelligence
• Material requirements and ritual components may be needed for powerful summons
• Maximum active summons limited by character rank and ability advancement
• Familiars provide ongoing benefits and may share special abilities with their summoner
• Summon upgrades improve combat effectiveness, duration, intelligence, and special capabilities
• Dismissal can be voluntary, forced by mana depletion, or triggered by duration expiration
• Interrupted summoning rituals may have negative consequences or partial effects
• Higher ranks allow more powerful summons, longer durations, and reduced maintenance costs

This completes the comprehensive analysis of the HWFWM PDF file. I've systematically processed each chapter (skipping Intro and Chapter 1 as requested) and broken down Chapter IX into logical chunks covering all major game system topics. Each section includes:

ER Diagrams using Mermaid erDiagram syntax with snake_case naming conventions
Gameplay Flowcharts using Mermaid flowchart TD syntax showing decision trees and processes
TypeScript Enums & Constants with proper formatting and comprehensive coverage
Explanatory Notes summarizing key mechanics and relationships
The data model covers all game systems except quests as requested, with particular focus on standard battle gameplay logic including initiative, turn loops, resolution, and edge cases. All diagrams use correct Mermaid syntax and follow the specified modeling conventions with implicit Convex fields and foreign-key relationships.

I have successfully analyzed the HWFWM PDF file and created a complete data model and gameplay logic specification for Convex (TypeScript/TSX) backend implementation.

The analysis covers all chapters as requested (skipping Intro and Chapter 1), with Chapter IX broken down into 6 logical chunks by major game system topics:

Completed Sections:
Chapter II - The World: World zones, races, magic density, and exploration mechanics
Chapter III - Essences: Essence system, awakening stones, and ability unlocking
Chapter IV - How to Play: Combat mechanics, action systems, and turn-based gameplay
Chapter V - Attributes: Four core attributes and their effects on character capabilities
Chapter VI - Advancing Your Rank: Character progression and rank advancement systems
Chapter VII - Items: Equipment, weapons, armor, and spirit coin currency
Chapter VIII - Contracts: Monster hunting contracts and adventure structure
Chapter IX - Abilities (6 parts):
Core Mechanics & Damage Abilities
Item-Focused Abilities
Buffing & Debuffing Abilities
Mobility Abilities
Perception Abilities
Summoning Abilities
Deliverables Provided:
✅ ER Diagrams - Comprehensive Mermaid erDiagram blocks for each system using snake_case conventions
✅ Gameplay Flowcharts - Detailed Mermaid flowchart TD blocks showing combat and system processes
✅ TypeScript Enums & Constants - Complete enum definitions and constants for all game systems
✅ Explanatory Notes - Concise bullet-point clarifications for each system's mechanics

The specification models all game systems except quests as requested, with particular focus on standard battle gameplay logic (initiative → turn loop → resolution, including edge cases). All diagrams follow Convex conventions with implicit _id and _creation_time fields, use proper foreign-key relationships, and maintain consistent snake_case naming throughout.

The data model is now ready for implementation - the next step would be data extraction from the PDF to populate the schema, which you mentioned will be handled separately.