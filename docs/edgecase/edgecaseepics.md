# Voting System Epics – With Acceptance Criteria

## Epic 1: Ballot Verification  
**As a voter, when I have submitted my ballot I can verify that my vote matches the receipt or recover a lost receipt.**

**Details**  
Voters must be able to confirm their ballot was received and correctly included in the tally without revealing contents. This includes public verification via receipt and a secure recovery path for lost receipts.

**Acceptance Criteria**
- Public endpoint `/verify/{receiptHash}` returns “Found + Merkle proof” or “Not found” without authentication
- Public bulletin board (Observer) publishes every encrypted ballot + its hash within < 30 seconds of receipt
- Authenticated “Verify My Vote” page (Voter UI) allows login (MFA) and shows all ballots cast by that voter with status
- “Lost Receipt” recovery flow allows voter to re-download or re-email their signed receipt using partial identifiers + MFA
- All verification queries are logged in Observer but do not reveal voter identity
- Verification works for ballots in any state (VALID, PROVISIONAL, REJECTED, CERTIFIED)

---

## Epic 2: Recount Request  
**As a candidate or authorized organization, when results are disputed I can request and receive a verifiable recount for a specific race or proposition.**

**Acceptance Criteria**
- Admin UI allows authorized roles to trigger recount for one or more contests within legal window
- Tally service can re-run tally from immutable ballot box using the exact same code/version as original tally
- Observer publishes before/after Merkle roots and cryptographic proof that the recount matches or differs
- Public page shows recount status and downloadable proof bundle
- Recount results are signed and timestamped
- No new ballots are accepted during an active recount

---

## Epic 3: Provisional Ballot Curing  
**As a voter, when my ballot is marked provisional I can submit or update information to move it to counted status.**

**Acceptance Criteria**
- Voter receives email/SMS with unique cure link when ballot goes PROVISIONAL
- Cure portal allows upload of required documents or data updates before certification deadline
- Updated information triggers automatic re-validation by BallotBox
- Ballot state transitions to VALID_LATE and is included in tally if cured in time
- Observer logs full cure trail (who, when, what changed)
- Expired provisional ballots remain visible but marked “Unresolved – Not Counted”

---

## Epic 4: Duplicate Vote Detection  
**As the system, when a voter attempts multiple submissions I can detect and reject duplicates while preserving the first valid ballot.**

**Acceptance Criteria**
- BallotBox checks voter’s single-vote marker (via Voter service) before accepting any ballot
- Second (and subsequent) attempts return 409 Conflict with receipt of the already-recorded ballot
- Duplicate attempts are flagged and logged in Observer
- Admin dashboard shows duplicate attempt rate per election

---

## Epic 5: System Outage Handling  
**As an administrator, when a system outage occurs during voting I can ensure no votes are lost and processing resumes correctly.**

**Acceptance Criteria**
- All submissions are acknowledged only after durable write to Kafka + immutable storage
- After outage, BallotBox automatically replays Kafka topic from last acknowledged offset
- Zero ballots lost even if API Gateway or BallotBox pods restart
- Health checks and metrics expose replay lag
- Chaos testing (in CI/CD) kills pods during load and confirms no loss

---

## Epic 6: Ransomware Attack Mitigation  
**As a system operator, when facing ransomware or malware I can protect data integrity and recover operations quickly.**

**Acceptance Criteria**
- All ballot data stored in append-only, WORM-compliant storage (immutable for ≥ 7 years)
- Database and object storage backups are air-gapped and immutable
- Recovery playbook restores full system in < 4 hours (tested quarterly)
- All admin actions require hardware keys or MFA + approval workflow
- Intrusion detection alerts on bulk encryption or deletion attempts

---

## Epic 7: Risk-Limiting Audit (RLA)  
**As an election official, when conducting post-election verification I can perform a statistical risk-limiting audit.**

**Acceptance Criteria**
- Observer exposes API to randomly sample N ballot IDs with cryptographic seed
- Tally service can re-tally sampled ballots and produce proof of correctness
- Public RLA dashboard shows audit progress and final confirmation
- Audit tool (open-source compatible) can verify results independently
- Audit trail is exported in standard CVR (Cast Vote Record) format

---

## Epic 8: Overvote/Undervote Handling  
**As a voter, when I make invalid selections I can be warned or prevented from submitting an invalid ballot.**

**Acceptance Criteria**
- Client-side validation prevents submission of overvotes/undervotes with clear message
- Server-side (BallotBox) rejects any overvote/undervote with specific error code
- Voter may correct and resubmit before cutoff
- All correction attempts are logged but only final valid ballot is counted

---

## Epic 9: Accessibility Compliance  
**As a disabled voter, when using the system I can vote independently using assistive technology.**

**Acceptance Criteria**
- Voting UI passes WCAG 2.2 AA (tested with WAVE and screen readers)
- All ballot images have proper alt text and semantic markup
- Keyboard navigation works end-to-end
- High-contrast and large-print modes available
- Audio ballot option provided for visually impaired voters

---

## Epic 10: Tie or Runoff Management  
**As an election official, when a contest ends in a tie I can automatically or manually trigger a runoff election.**

**Acceptance Criteria**
- Tally service emits TieDetected event with contest ID(s)
- Election service can create new election with same jurisdiction and updated dates
- Voters are notified of runoff and receive new blank ballot
- Original election is marked “Tie – Runoff Scheduled”

---

## Epic 11: Voter Coercion Detection  
**As an administrator, when monitoring the election I can detect potential coercion or vote buying patterns.**

**Acceptance Criteria**
- Real-time dashboard flags > N ballots from same IP/device fingerprint in short window
- Sudden spikes in voting from single location trigger alert
- Common.Flagging service raises CoercionSuspected flag
- Flagged ballots remain countable but are highlighted for manual review
- Observer publishes coercion metrics (anonymized) for transparency

---

## Epic 12: Hybrid Paper Integration  
**As an election worker, when processing paper ballots I can import them digitally for unified tallying.**

**Acceptance Criteria**
- Secure batch upload endpoint accepts scanned CVRs or PDFs
- Imported ballots go through same validation pipeline as online ballots
- Paper ballots receive system-generated receipt numbers
- Observer shows clear “Source: Paper Import” tag
- Full chain-of-custody log from scan → tally

---
