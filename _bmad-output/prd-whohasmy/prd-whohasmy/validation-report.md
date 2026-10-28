# Validation Report — WhoHasMy

- **PRD:** `_bmad-output/prd-whohasmy/prd-whohasmy/prd-whohasmy.md`
- **Rubric:** `.agents/skills/bmad-prd/assets/prd-validation-checklist.md`
- **Run at:** 2026-10-27T21:31:31-05:00
- **Grade:** Good

## Overall verdict
This is a genuinely good solo-stakes PRD: a clear thesis (never forget who has your stuff, never re-buy), features that all serve it, a consistent glossary, and FRs that mostly carry real testable consequences. The risk is concentrated in one place — the notification subsystem, which is the product's core promise, rests on an unspecified email delivery mechanism and contains a contact-data contradiction (phone-only contacts can receive no v1 notifications). Fix the notification findings and this is buildable as written.

## Dimension verdicts
- Decision-readiness — adequate
- Substance over theater — strong
- Strategic coherence — strong
- Done-ness clarity — adequate
- Scope honesty — adequate
- Downstream usability — strong
- Shape fit — strong

## Findings by severity

### Critical (0)

None.

### High (2)

**[Decision-readiness]** Email delivery mechanism unspecified (§4.4, §5.2)
The borrower "simply receives email alerts" (§1) and FR-9/13/14 all send email, but the PRD never says *how*. A local-storage, no-account, no-backend app cannot send email without either user-supplied SMTP credentials or an external email service; §7 permits "email/SMS" integrations but names none. This is the PRD's single biggest silent decision.
Fix: Add a short "Notification delivery" decision note: chosen mechanism, what the user must configure (e.g., SMTP settings screen), and fallback behavior when email fails.

**[Done-ness clarity]** Phone-only contacts can't receive any v1 notification (§4.2 FR-7 vs §4.4)
FR-7 requires "at least an email or phone number," but every notification FR (FR-9, 13, 14) sends email only and FR-15 defers SMS. A phone-only contact silently gets nothing — the loan is created, the borrower is never reminded, and Mary has no indication why.
Fix: Either require email for contacts used in loans, or add a consequence to FR-9 ("System warns when loaning to a contact with no email address").

### Medium (7)

**[Decision-readiness]** Owner email configuration has no FR (§4.4 FR-13)
"System sends an email to the owner's configured email address" implies a settings flow that doesn't exist anywhere in §4.
Fix: Add an FR (owner notification preferences: email address, thresholds, intervals) or fold configuration into FR-13's consequences.

**[Substance over theater]** "Reliably" is an adjective, not a bound (§5.4)
"Notifications must be sent reliably when due dates are reached" is exactly the copied-boilerplate pattern the rest of §5 avoids. No retry policy, no delivery window, no failure surfacing.
Fix: Replace with a bound, e.g., "Overdue notifications are attempted within 1 hour of the due date passing and retried daily; failed sends are visible on the dashboard."

**[Strategic coherence]** Primary success metric is unmeasurable (§6)
"Mary remembers who has her stuff" has no measurement method; you can't tell at the end of v1 whether the thesis validated.
Fix: Make it checkable, e.g., "Mary can name who holds any loaned item within 10 seconds of opening the dashboard" or "zero re-purchases of loaned items in the first 3 months."

**[Done-ness clarity]** "Stronger/more urgent" and "possibly with additional follow-up" are not testable (§4.4 FR-14)
The escalation ladder's consequence says "Email content and urgency scale with risk level," but nothing defines what changes: subject line, wording, frequency? "Possibly" is unbuildable.
Fix: Define the scaling concretely — e.g., distinct subject-line prefixes per risk level and a stated send frequency per tier — and delete "possibly."

**[Done-ness clarity]** Configurability claimed with no configuration surface (§4.4 FR-13, FR-14)
Both FRs say thresholds/intervals are "configurable," but no FR or section describes where Mary configures them.
Fix: Add the settings FR from the Decision-readiness finding and have FR-13/14 reference it.

**[Done-ness clarity]** Orphaned loan behavior after item deletion is ambiguous (§4.1 FR-4)
"The active loan is preserved but the item is removed from the catalog" leaves the loan pointing at a deleted item: does it still appear on the dashboard? Can it be returned?
Fix: Add a consequence, e.g., "Active loans for deleted items remain on the dashboard until returned; the item shows as '[deleted]'."

**[Scope honesty]** Load-bearing assumptions untagged (§4.4, §5.2)
The email-mechanism assumption and the single-device assumption (what happens when Mary switches phones? no export/backup is scoped) are never marked as assumptions a reviewer could push back on.
Fix: Tag them inline (`[ASSUMPTION: …]`) and index at the end, per the PRD's own conventions.

### Low (2)

**[Downstream usability]** Success Metrics have no IDs (§6)
FRs and UJs are ID'd but metrics aren't, so downstream docs can't reference them precisely.
Fix: Add SM-1/SM-2/CM-1 labels.

**[Downstream usability]** FR-15 is a scope note wearing an FR id (§4.4)
It has no consequences block and describes a non-feature; a naive story generator would create a ticket for it.
Fix: Move it to §7 Out of Scope with a pointer, or keep the id but mark it clearly as deferred-scope.

## Mechanical notes
- **Glossary drift (minor):** §2.1 says "phone, tablet, desktop, or browser" while §5.1 names "Android, iOS, macOS, and Chrome webapp" — "desktop" vs macOS-only, and "browser" vs Chrome-only. Harmless but worth aligning.
- **ID continuity:** FR-1–17 and UJ-1–5 contiguous and unique; no broken cross-references. SMs unnumbered (see finding above).
- **Assumptions Index:** No `[ASSUMPTION]` tags appear inline and no index exists — trivially consistent, but the mechanism is entirely unused (see Scope honesty).
- **Risk threshold boundaries (§4.5 FR-17):** "Low: 2 days overdue" reads as a point value; days 3–4 are unassigned by the letter of the text. Presumably Low spans 2–4 days, but state the ranges.
- **FR shape consistency:** FR-15 is the only FR without a Consequences block.
- **Required sections:** Vision, Target User, Glossary, Features, NFRs, Success Metrics, Out of Scope all present — appropriate set for the stakes.

## Reviewer files
- `review-rubric.md`
