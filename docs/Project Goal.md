Project Goal
Build “Electioneer” – a safe, secure, verifiable internet voting system that supports complex ballot rules (Ranked-Choice Voting, multi-seat contests, propositions, etc.) while providing perfect auditability and voter privacy.
Core Architectural Decisions (Locked In)
1. Domain Separation (Bounded Contexts)

Election Domain
Voter Domain
Ballot Domain
Registrar Domain
Districting/Precinct Domain
Jurisdiction Admin Domain
Infrastructure (Auth, API Gateway, Notification Gateway, Monitoring, CI/CD)

2. Ballot Submission Flow (MVP → Production)
Voter UI / External Voting Service (EVS) → API Gateway → Vote Service → Vote Validation Service (VVS)
VVS performs:

Voter eligibility check (sync call to Voter Service)
Single-vote enforcement
Cryptographic verification (ZK proofs or homomorphic encryption)
Ballot definition lookup + rule engine execution once rules are finalized
Decision: VALID | INVALID | PROVISIONAL

3. Ballot Persistence & Auditability
All ballots (regardless of status) are permanently preserved:








































StateStorage BucketCounts in Tally?Public Bulletin Board VisibilityRetentionVALIDBOBJ_VALIDYesTracker hashForeverINVALIDBOBJ_INVALIDNoFull rejection reason + timestampForeverPROVISIONALBOBJ_PROVISIONAL (escrow)No (until resolved)Marked “under review” + reasonForeverResolved → VALID/INVALIDMoved to respective bucketaccordinglyResolution trail publishedForever

Durable Ballot Box = immutable, append-only, WORM storage (e.g., S3 + Glacier Vault Lock or similar)
Tallying Service only ever consumes VALID ballots from BOBJ_VALID

4. Public Transparency

Public Bulletin Board (append-only, Merkle-ized cryptographic log)
Section: Accepted Ballots
Section: Rejected Ballots (with reason)
Section: Provisional Ballots (pending/under review)
Section: Resolutions & Final Commitments


5. Cryptographic Roadmap

Phase 1 (MVP): Additive homomorphic encryption (ElectionGuard-style) – fast tally, individual verifiability
Phase 2: zk-SNARKs (or equivalent) for complex rules (RCV, multi-seat, overvote detection, etc.)
Long-term: hybrid or full ZK for end-to-end verifiability without trusted tally ceremony

6. External Integration

Multiple External Voting Services (EVS) allowed
EVS connects via mTLS + ACL or future public batch ballot-submission API
Anonymization/mixing happens server-side after validation

7. Event Sourcing & Audit

Central event log (Kafka / Pulsar)
Every service publishes immutable events
Audit & Reporting Service can replay or reconstruct any election state at any time

8. Voter Registration (MVP Scope)

Voter Orchestration Service (VORCH) coordinates registration saga
MVP: basic validation only
Post-MVP: address changes that cross precincts/districts → coordination with Districting Service

9. Authentication (Still Open)

Central AUTH service shown (MFA, WebAuthn, future hardware-bound keys)
Final decision pending

10. Ballot State Machine (Canonical)
mermaidstateDiagram-v2
    [*] --> Received
    Received --> VALID
    Received --> INVALID
    Received --> PROVISIONAL
    PROVISIONAL --> VALID : Admin resolves valid
    PROVISIONAL --> INVALID : Admin resolves invalid
    VALID --> CERTIFIED
    VALID --> ARCHIVED : after certification
    INVALID --> ARCHIVED
    PROVISIONAL --> ARCHIVED : if unresolved by deadline
    CERTIFIED --> ARCHIVED
Current Diagrams (in project repo)

High-level domain diagram (domains.md – original + updates)
Vote Validation Service internal detail
Durable Ballot Box + three-state persistence flow
Full ballot state transition diagram (above)

This document is the living source of truth for Electioneer architecture. Update it as decisions evolve.Markdown please?Electioneer Architecture Summary
Living Document – Last Updated: November 21, 2025
Project Goal
Build Electioneer – an open-source, secure, verifiable internet voting system that supports complex ballot rules (Ranked-Choice Voting, multi-seat contests, propositions, etc.) while guaranteeing perfect privacy, auditability, and voter verifiability.
Core Architectural Decisions (Locked In)
1. Domain Separation (Bounded Contexts)

Election Domain
Voter Domain
Ballot Domain
Registrar Domain
Districting/Precinct Domain
Jurisdiction Admin Domain
Infrastructure (Auth, API Gateway, Notification Gateway, Monitoring, CI/CD)

2. Ballot Submission Flow
textVoter UI / External Voting Service (EVS)
    → API Gateway (mTLS + ACL)
    → Vote Service
    → Vote Validation Service (VVS)
Vote Validation Service (VVS) performs:

Voter eligibility (sync call to Voter Service)
Single-vote enforcement
Cryptographic verification (ZK proofs or homomorphic encryption)
Ballot definition + rule engine execution
Decision → VALID | INVALID | PROVISIONAL

3. Ballot Persistence & Auditability
All ballots are preserved forever in immutable, append-only storage.








































StateStorage BucketCounts in Tally?Public Bulletin Board VisibilityRetentionVALIDBOBJ_VALIDYesTracker hashForeverINVALIDBOBJ_INVALIDNoFull rejection reason + timestampForeverPROVISIONALBOBJ_PROVISIONAL (escrow)No (until resolved)Marked “under review” + reasonForeverResolved → VALID/INVALIDMoved to respective bucketaccordinglyFull resolution trail publishedForever

Durable Ballot Box = WORM storage (e.g., S3 + Glacier Vault Lock, QuartzBlock, etc.)
Tallying Service only consumes VALID ballots

4. Public Transparency
Public Bulletin Board (append-only, Merkle-rooted):

Accepted Ballots (tracker hashes)
Rejected Ballots (with reason codes)
Provisional Ballots (pending resolution)
Resolution Log
Final Commitments & Proofs

5. Cryptographic Roadmap

| Phase|Technology|Scope
|---|---|---|
MVP|Additive homomorphic encryption (ElectionGuard-style)|"Simple contests| fast tally| individual verifiability"
Phase 2|zk-SNARKs (or equivalent)|"Full RCV| multi-seat| complex rules"
Long-term|Hybrid or pure ZK end-to-end|No trusted tally ceremony


6. External Integration

Multiple External Voting Services (EVS) supported (county portals, state apps, etc.)
Connect via mTLS + ACL or future public batch ballot-submission API
Anonymization/mixing performed server-side after validation

7. Event Sourcing & Audit

Central event log (Kafka or Pulsar)
Every service publishes immutable events
Audit & Reporting Service can replay any election state at any time

8. Voter Registration

Voter Orchestration Service (VORCH) coordinates registration saga
MVP scope: basic validation only
Post-MVP: address changes that cross precincts → coordination with Districting Service

9. Authentication (Decision Pending)

Currently modeled as central AUTH service (MFA, WebAuthn, future hardware-bound keys)
Open question: centralized vs per-UI WebAuthn

10. Official Ballot State Machine

```mermaid
stateDiagram-v2
    [*] --> Received : Ballot submitted\n(Vote Service → VVS)

    state "Received\n(encrypted + proof)" as REC
    state "VALID" as VALID
    state "INVALID" as INVALID
    state "PROVISIONAL" as PROV
    state "VALID (Late Resolved)" as VALID_LATE
    state "INVALID (Late Resolved)" as INVALID_LATE
    state "CERTIFIED" as CERTIFIED
    state "ARCHIVED" as ARCHIVED

    REC --> VALID      : Automatic checks pass\n(ZK/HE proof OK + rules OK)
    REC --> INVALID    : Automatic checks fail\n(rejection reason recorded)
    REC --> PROV       : Eligibility uncertain\n(voter not found, signature mismatch, etc.)

    %% Provisional resolution (human in the loop)
    PROV --> VALID_LATE     : Admin resolves as valid\n(e.g. manual eligibility confirmation)
    PROV --> INVALID_LATE   : Admin resolves as invalid\n(e.g. confirmed duplicate or fraud)

    %% Final tally only includes these two
    VALID     --> CERTIFIED : Election closed\n→ included in official tally
    VALID_LATE --> CERTIFIED : Resolved before certification deadline

    %% These never count
    INVALID       --> ARCHIVED
    INVALID_LATE  --> ARCHIVED
    PROV          --> ARCHIVED : Unresolved by certification deadline\n(still preserved forever)

    %% Final states
    CERTIFIED --> ARCHIVED : Election fully certified\nall buckets immutable forever

    %% Styling
    state VALID        #d4edda,#28a745
    state VALID_LATE   #d4edda,#28a745
    state INVALID      #f8d7da,#dc3545
    state INVALID_LATE #f8d7da,#dc3545
    state PROV         #fff3cd,#ffc107
    state CERTIFIED    #d1ecf1,#17a2b8
    state ARCHIVED     #e2e3e5,#6c757d
    state REC          #f8f9fa,#495057
```

Current Reference Diagrams (in repo)

High-level domain diagram (domains.md)
```mermaid
graph TB
    %% External world
    EVS[External Voting Service<br/>Third-party apps / County portals]:::external
    VoterPhone[VotingUserUI<br/>Official mobile/web app]:::ui

    %% Entry points
    subgraph API_GW["API Gateway + Reverse Proxy"]
        APIG[API Gateway<br/>Rate-limit, WAF, mTLS]
        RP[Reverse Proxy]
    end

    %% Authentication (still TBD – shown as central for now)
    AUTH[AUTH Service<br/>MFA / WebAuthn / Future hardware keys]:::infra

    %% Core voting flow
    VoterPhone -->|JWT| AUTH
    EVS -->|mTLS + ACL| APIG
    VoterPhone -->|HTTPS| APIG

    APIG --> VS[Vote Service<br/>Orchestrates submission]:::internal
    VS --> VVS[Vote Validation Service<br/>Stateless, ZK/HE proof verify]:::internal

    %% Services VVS depends on
    VVS --> VoterService[Voter Service<br/>Eligibility + single-vote marker]:::internal
    VVS --> BallotService[Ballot Service<br/>Current ballot definition + rules]:::internal
    VVS --> Crypto[Crypto Module<br/>ZK-SNARK / HE verify]:::internal

    %% Durable storage after validation
    VVS -->|ACCEPT| BOBJ[(Durable Encrypted Ballot Box<br/>S3 + Immutable Append-Only Log<br/>Write-once, WORM)]:::storage
    VVS -->|REJECT| RejectLog[(Rejection Log<br/>+ Reason Code)]:::storage
    VVS -->|ACCEPT| NG[Notification Gateway] --> VRN[Voter Notification Service]

    %% Tallying pulls from the durable box
    BOBJ -->|immutable feed| TS[Tallying Service<br/>Consumes encrypted ballots<br/>Per-jurisdiction decomposition<br/>Mix-net / HE / ZK tally]:::internal
    TS --> PublicBB[(Public Bulletin Board<br/>Append-only cryptographic log<br/>Merkle-ized commitments)]:::storage

    %% Certification & Audit
    RCS{Results Certification UI} --> TS
    RCS --> PublicBB
    ARUI{Audit & Reporting UI} --> ARS[Audit & Reporting Service<br/>Event Sourcing replay]:::internal
    ARS --> EventStore[(Central Event Log<br/>Kafka / Pulsar)]:::storage

    %% Event sourcing backbone
    VS --> EventStore
    VVS --> EventStore
    TS --> EventStore
    VoterService --> EventStore

    %% Districting integration (post-MVP)
    VORCH[[Voter Orchestration Service<br/>Saga coordinator]] --> JDPS[Districting/Precinct Service]:::internal
    VORCH --> VoterService

    %% Styling
    classDef external fill:#f92,stroke:#f00,color:#fff
    classDef ui fill:#e3fcef,stroke:#333
    classDef internal fill:#ddd,stroke:#333
    classDef storage fill:#f96,stroke:#333,color:#fff
    classDef infra fill:#ccf,stroke:#00f,color:#000
    classDef domain fill:#afcddd,stroke:#333,stroke-width:3px
```

Vote Validation Service internal detail

Durable Ballot Box + three-state persistence flow
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


Full ballot state transition diagram (above)

