```mermaid
graph LR
    Jurisdiction --> Boundary
    Boundary --> Ballot
    Boundary --> Voter
    Boundary --> Election
    Boundary -.->|split logic & versions| VVS[Vote Validation Service]
```