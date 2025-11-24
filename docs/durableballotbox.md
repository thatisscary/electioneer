# Durable Ballot Box

```mermaid
graph TB
    %% Entry & validation
    VS[Vote Service] --> VVS[Vote Validation Service<br/>Stateless, rule + crypto check]

    %% VVS now produces THREE outcomes
    VVS -->|VALID| ValidPath
    VVS -->|INVALID| InvalidPath  
    VVS -->|PROVISIONAL| ProvisionalPath

    %% VALID path – the happy path
    ValidPath --> BOBJ_VALID[(Durable Ballot Box – VALID<br/>Encrypted ballots<br/>Append-only, WORM, Merkle-rooted)]:::valid
    BOBJ_VALID --> TS_VALID[Tallying Service<br/>Only consumes VALID ballots]

    %% INVALID path – must be preserved forever for audit
    InvalidPath --> BOBJ_INVALID[(Durable Ballot Box – INVALID<br/>Encrypted ballot + full rejection details<br/>Reason codes, timestamps, rule violated)]:::invalid
    BOBJ_INVALID --> PublicBB_Invalid[Public Bulletin Board<br/>Section: Rejected Ballots<br/>Hash + Reason + Timestamp]

    %% PROVISIONAL path – human in the loop
    ProvisionalPath --> BOBJ_PROV[(Durable Ballot Box – PROVISIONAL<br/>Encrypted ballot + provisional metadata<br/>Held in escrow until resolved)]:::provisional
    BOBJ_PROV --> AdminQueue[Administrator Work Queue<br/>Election Admin UI]
    AdminQueue -->|Resolve → VALID| MoveToValid[Move to VALID box<br/>+ publish resolution event]
    AdminQueue -->|Resolve → INVALID| MoveToInvalid[Move to INVALID box<br/>+ publish resolution event]

    %% Public transparency – everything is visible
    BOBJ_VALID --> PublicBB_Valid[Public Bulletin Board<br/>Section: Accepted Ballots<br/>Tracker hashes]
    BOBJ_INVALID --> PublicBB_Invalid
    BOBJ_PROV --> PublicBB_Prov[Public Bulletin Board<br/>Section: Provisional Ballots<br/>Pending resolution]

    %% Tallying only ever touches VALID
    TS_VALID --> FinalTally[Final Certified Results]
    FinalTally --> PublicBB_Final[Public Bulletin Board<br/>Final Commitments & Proofs]

    %% Event sourcing still captures everything
    VVS --> EventStore[(Central Event Log)]
    AdminQueue --> EventStore
    MoveToValid --> EventStore
    MoveToInvalid --> EventStore

    %% Styling
    classDef valid fill:#d4edda,stroke:#28a745,stroke-width:3px,color:#000
    classDef invalid fill:#f8d7da,stroke:#dc3545,stroke-width:3px,color:#000
    classDef provisional fill:#fff3cd,stroke:#ffc107,stroke-width:3px,color:#000
    classDef storage fill:#f96,stroke:#333,color:#fff
    
    ```