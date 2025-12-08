EdgeCaseStores

Here is the complete, ready-to-use markdown file with **all 12 Epics broken into actionable User Stories**, following the standard format:

**As a {role}, I want {feature} so that {benefit}**

```markdown
# Voting System – Epics & User Stories

## Epic 1: Ballot Verification
**As a voter, when I have submitted my ballot I can verify that my vote matches the receipt or recover a lost receipt.**

- As a voter, I want to enter my receipt hash on a public page so that I can instantly see if my ballot is in the system
- As a voter, I want the verification page to show me a cryptographic proof (Merkle path) so that I trust the result without trusting the server
- As a voter who lost my receipt, I want to log in with MFA and see all my cast ballots linked to my identity so that I can still verify my vote
- As a voter, I want to re-download or re-send my signed receipt from the authenticated portal so that I have it for future verification
- As an observer, I want every encrypted ballot published to the bulletin board within 30 seconds of receipt so that the record is near-real-time

## Epic 2: Recount Request
**As a candidate or authorized organization, when results are disputed I can request and receive a verifiable recount.**

- As a jurisdiction admin, I want to trigger a recount for one or more contests via UI so that the process is auditable
- As an auditor, I want the system to re-tally using the exact same immutable ballot box and code version so that results are reproducible
- As a public observer, I want to download a signed proof bundle showing original vs recount Merkle roots
- As an election official, I want recount results to be cryptographically signed and timestamped
- As the system, I want to block new ballot submissions while a recount is in progress

## Epic 3: Provisional Ballot Curing
**As a voter, when my ballot is marked provisional I can submit or update information to move it to counted status.**

- As a voter, I want to receive an email/SMS with a secure cure link when my ballot is provisional
- As a voter, I want a dedicated curing portal where I can upload documents or correct my information before the deadline
- As the system, I want to automatically re-run validation when curing data is submitted
- As a voter, I want to receive confirmation when my ballot moves from PROVISIONAL → VALID_LATE
- As an auditor, I want to see the full curing trail (who, what, when) in the Observer log

## Epic 4: Duplicate Vote Detection
**As the system, when a voter attempts multiple submissions I can detect and reject duplicates.**

- As the system, I want to check the single-vote marker before persisting any ballot
- As a voter, I want to receive a clear 409 response with the receipt of my already-recorded ballot if I submit twice
- As an admin, I want to see duplicate attempt statistics in the dashboard

## Epic 5: System Outage Handling
**As an administrator, when a system outage occurs I can ensure no votes are lost.**

- As the system, I want to persist every ballot to Kafka + immutable storage before sending 202 Accepted
- As the system, I want to automatically resume processing from the last offset after a restart
- As an admin, I want to see replay lag metrics in monitoring
- As a tester, I want chaos tests that kill pods during load and prove zero data loss

## Epic 6: Ransomware Attack Mitigation
**As a system operator, when facing ransomware I can protect and recover data.**

- As the system, I want all ballot data stored in immutable, append-only WORM storage
- As an operator, I want daily air-gapped, immutable backups of databases and object storage
- As a security team, I want a tested recovery playbook restoring the full system in < 4 hours
- As the system, I want all admin actions to require hardware security keys

## Epic 7: Risk-Limiting Audit (RLA)
**As an election official, I can perform a statistical risk-limiting audit.**

- As an auditor, I want an API to draw a cryptographically seeded random sample of ballot IDs
- As the system, I want to re-tally the sample and produce a verifiable proof
- As a public observer, I want a public RLA dashboard showing progress and final risk limit achieved
- As an auditor, I want to export Cast Vote Records in standard format

## Epic 8: Overvote/Undervote Handling
**As a voter, I want to be prevented or warned about invalid vote selections.**

- As a voter, I want real-time client-side validation warning me of overvote/undervote
- As the system, I want to reject any ballot containing overvote/undervote at submission time
- As a voter, I want to be able to correct and resubmit before the cutoff

## Epic 9: Accessibility Compliance
**As a disabled voter, I can vote independently.**

- As a visually impaired voter, I want full screen-reader compatibility and logical focus order
- As a voter, I want high-contrast and scalable text modes
- As a motor-impaired voter, I want full keyboard navigation
- As a voter, I want audio ballot playback option
- As the team, we want automated WCAG 2.2 AA compliance checks in CI

## Epic 10: Tie or Runoff Management
**As an election official, when a contest ties I can trigger a runoff.**

- As the system, I want to detect exact ties and emit TieDetected event
- As an admin, I want to create a runoff election with one click from the original election
- As a voter, I want to be notified of the runoff and receive a new blank ballot
- As an observer, I want the original election marked “Tie – Runoff Scheduled”

## Epic 11: Voter Coercion Detection
**As an administrator, I can detect potential coercion patterns.**

- As the system, I want to flag > N ballots from the same IP/device fingerprint in < 5 minutes
- As an admin, I want real-time alerts on sudden geographic spikes
- As the system, I want to raise CoercionSuspected flag without disqualifying ballots
- As a public observer, I want anonymized coercion metrics published

## Epic 12: Hybrid Paper Integration
**As an election worker, I can import paper ballots digitally.**

- As an election worker, I want a secure batch upload endpoint for scanned ballots
- As the system, I want imported ballots to go through the exact same validation and tally pipeline
- As a voter whose paper ballot was scanned, I want to receive a system-generated receipt number
- As an observer, I want every imported ballot tagged “Source: Paper Import” on the bulletin board
- As an auditor, I want full chain-of-custody log from scan to tally
```

