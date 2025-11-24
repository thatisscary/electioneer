# Ballot State Transitions
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