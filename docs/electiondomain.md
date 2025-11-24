 ```mermaid
 graph TB
    classDef external stroke:#f00, fill:#f92, color:#fffffff,font-size:20px
    classDef internal stroke:#f00, fill:lightgrey,  color:#2afff,font-size:20px
    classDef notify stroke:#00f, fill:#4D9900, color:#ffffff,font-size:20px
    classDef storage fill:#f96, color:#FFFccc,font-size:20px
    classDef ui fill:#f9ffff, stroke:#333, stroke-width:2px,font-size:20px
    classDef domain fill:#afcddd, stroke:#333, stroke-width:2px,font-size:30px


 
 subgraph ED [Election]
        VotingUserUI{{"Voting UI"}}-->
        VotingService["Vote Service"]-->VVS[Vote Validation Service]-->
        TS["Tallying Service"]
        EVS[External Voting Service]--ACL-->VVS
        RRUI{{"Realtime Results UI"}}-->TS
        RCS{{"Results Certification UI"}}-->TS
        ARUI{{"Audit & Reporting UI"}} -->
        ARS["Audit & Reporting"]
        EN["Election Notification Service"]



VotingUserUI:::ui
VotingService:::internal
VVS:::internal
EVS:::external
RRUI:::ui
RCS:::ui
ARUI:::ui
ARS:::internal
EN:::notify
  end
ED:::domain


```
