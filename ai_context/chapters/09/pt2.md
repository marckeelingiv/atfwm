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
