 ```mermaid
 graph TB
    classDef external stroke:#f00, fill:#f92, color:#fffffff,font-size:20px
    classDef internal stroke:#f00, fill:lightgrey,  color:#2afff,font-size:20px
    classDef notify stroke:#00f, fill:#4D9900, color:#ffffff,font-size:20px
    classDef storage fill:#f96, color:#FFFccc,font-size:20px
    classDef ui fill:#f9ffff, stroke:#333, stroke-width:2px,font-size:20px
    classDef domain fill:#afcddd, stroke:#333, stroke-width:2px,font-size:30px


 subgraph VoterDomain[Voter Domain]
        PRS["External Registration Service"]--ACL-->VRS
        VRUI{{"Voter Registration UI"}}-->
        VORCH[[Voter Orchestration Service]]-->VRS
        RUI{{"Registration UI"}}-->RASUI
        VRS[Voter Service]-->Voters
        VRS-->ValS
        VRS-->VRN
        ValS["Voter Validation Service"]-->VRS
        VRN["Voter Notifiction Service"]
        Voters[("Voter Db<br>PostgreSql")]
  end


 VoterDomain:::domain
 VRN:::notify
 PRS:::external
 RS:::internal
 ValS:::internal
 Voters:::storage
```