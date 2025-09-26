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