|State|Path(s)|Can Vote?|Notes
| ----| ----- | ---- | ---- |
|UI_Submitted|UI only|No|Initial submission
|UI_PendingReview|UI|No|Full manual review
|UI_Approved|UI|Yes|→ EligibleVoter
|UI_Challenged|UI|No|Can resubmit
|UI_Incomplete|UI|No|Needs docs
|UI_Disallowed|UI|No|Terminal (can reapply)
|Feed_Received|DMV/Feed|No|Auto-ingested
|Feed_PendingVerification|Feed|No|Light validation
|Feed_Approved|Feed|Yes|→ EligibleVoter
|Feed_Disallowed|Feed|No|Terminal
|Bulk_Imported|Bulk upload|No|Post-cutoff allowed
|Bulk_PendingApproval|Bulk|No|Manual approval
|Bulk_Approved|Bulk|Yes|→ EligibleVoter
|Bulk_Disallowed|Bulk|No|Terminal
|EligibleVoter|All paths|Yes|Final — can cast ballot