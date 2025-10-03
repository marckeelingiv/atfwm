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