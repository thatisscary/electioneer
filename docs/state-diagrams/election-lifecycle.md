# Election Lifecycle
```mermaid
stateDiagram-v2
    [*] --> Draft
    Draft --> PendingApproval  : Admin creates/joins election
    
    state is_approved <<choice>>  
    PendingApproval --> is_approved
    
    is_approved --> Approved 
    is_approved --> Rejected
    Rejected --> Draft : Admin updates document

    Approved --> ReadyForVoting : Election Starter clicks "Publish Election"
    
    state is_votingperiod <<choice>>
    is_voting_period 
    Active --> Closed : Voting end time reached
    Closed --> Archived : Retention period ends (auto)
    
    Active --> Active : Ballots accepted
    Closed --> Closed : No more changes
    Archived --> Archived : Read-only forever

    
 ```