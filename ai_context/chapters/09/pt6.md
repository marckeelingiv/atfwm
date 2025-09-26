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