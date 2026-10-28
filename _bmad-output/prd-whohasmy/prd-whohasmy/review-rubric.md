# PRD Quality Review — WhoHasMy

## Overall verdict
This is a genuinely good solo-stakes PRD: a clear thesis (never forget who has your stuff, never re-buy), features that all serve it, a consistent glossary, and FRs that mostly carry real testable consequences. The risk is concentrated in one place — the notification subsystem, which is the product's core promise, rests on an unspecified email delivery mechanism and contains a contact-data contradiction (phone-only contacts can receive no v1 notifications). Fix the notification findings and this is buildable as written.

## Decision-readiness — adequate
Decisions are stated as decisions, and the memlog confirms they were actually made rather than defaulted: risk thresholds are pinned to concrete values (§4.5 FR-17: "Low: 2 days overdue… High: More than 5 days overdue"), SMS is explicitly deferred (§4.4 FR-15), and the local-only storage bet is made with eyes open (§5.2: "Local device storage only (no cloud, no accounts, no sync)"). Trade-offs name what was given up — the Out of Scope section (§7) surrenders cloud sync, multi-device, and borrower accounts explicitly.

What keeps this from *strong*: the PRD has no Open Questions section and no `[NOTE FOR PM]` callouts, and the one place where a real unresolved tension lives — how a local-only, account-free app actually sends email — is smoothed over as if settled. FR-13 references "the owner's configured email address," but no FR configures it, and no section names the delivery mechanism (SMTP? third-party service? in-app send?). A decision-maker reading this PRD would approve it without ever confronting the question that most shapes the architecture.

### Findings
- **high** Email delivery mechanism unspecified (§4.4, §5.2) — The borrower "simply receives email alerts" (§1) and FR-9/13/14 all send email, but the PRD never says *how*. A local-storage, no-account, no-backend app cannot send email without either user-supplied SMTP credentials or an external email service; §7 permits "email/SMS" integrations but names none. This is the PRD's single biggest silent decision. *Fix:* Add a short "Notification delivery" decision note: chosen mechanism, what the user must configure (e.g., SMTP settings screen), and fallback behavior when email fails.
- **medium** Owner email configuration has no FR (§4.4 FR-13) — "System sends an email to the owner's configured email address" implies a settings flow that doesn't exist anywhere in §4. *Fix:* Add an FR (owner notification preferences: email address, thresholds, intervals) or fold configuration into FR-13's consequences.

## Substance over theater — strong
No persona theater — Mary is the single user and she drives every FR and UJ. No innovation theater — the Vision is earned and specific ("or worse, when you've already re-purchased a replacement," §1) rather than a category-generic statement. NFRs are mostly product-specific with real numbers: "~100 items," "Dashboard loads in under 2 seconds with 100 items," four named Flutter targets (§5.1–5.2). The UJs carry actual decision content (UJ-5's on-the-spot registration became FR-12), which is the opposite of furniture.

One boilerplate survivor:

### Findings
- **medium** "Reliably" is an adjective, not a bound (§5.4) — "Notifications must be sent reliably when due dates are reached" is exactly the copied-boilerplate pattern the rest of §5 avoids. No retry policy, no delivery window, no failure surfacing. *Fix:* Replace with a bound, e.g., "Overdue notifications are attempted within 1 hour of the due date passing and retried daily; failed sends are visible on the dashboard."

## Strategic coherence — strong
The PRD has a thesis and every feature serves it: register → loan → get reminded → risk-ranked dashboard → return. Nothing in §4 is a capability someone just wanted; even In-Maintenance (FR-11) supports the "is it available?" question the thesis poses. Prioritization follows the thesis — the dashboard and escalation emails are the product, and they're specified most fully. MVP scope kind is problem-solving and the scope logic matches.

The Success Metrics (§6) are the weak joint: the primary metric ("Mary remembers who has her stuff without having to re-purchase items") states the thesis but names no measurement. The counter-metric ("No user complaints about notification delivery") is fine at solo stakes.

### Findings
- **medium** Primary success metric is unmeasurable (§6) — "Mary remembers who has her stuff" has no measurement method; you can't tell at the end of v1 whether the thesis validated. *Fix:* Make it checkable, e.g., "Mary can name who holds any loaned item within 10 seconds of opening the dashboard" or "zero re-purchases of loaned items in the first 3 months."

## Done-ness clarity — adequate
This is the PRD's best structural habit: every FR (except FR-15) carries a "Consequences (testable)" block, and most are genuinely testable ("System does not allow creating a new loan for an item in *In-Maintenance* status," FR-11). An engineer could write stories from §4.1–4.3 and §4.5 almost as-is.

The notification FRs are where "done" gets fuzzy, and one data-model contradiction will bite immediately:

### Findings
- **high** Phone-only contacts can't receive any v1 notification (§4.2 FR-7 vs §4.4) — FR-7 requires "at least an email or phone number," but every notification FR (FR-9, 13, 14) sends email only and FR-15 defers SMS. A phone-only contact silently gets nothing — the loan is created, the borrower is never reminded, and Mary has no indication why. *Fix:* Either require email for contacts used in loans, or add a consequence to FR-9 ("System warns when loaning to a contact with no email address").
- **medium** "Stronger/more urgent" and "possibly with additional follow-up" are not testable (§4.4 FR-14) — The escalation ladder's consequence says "Email content and urgency scale with risk level," but nothing defines what changes: subject line, wording, frequency? "Possibly" is unbuildable. *Fix:* Define the scaling concretely — e.g., distinct subject-line prefixes per risk level and a stated send frequency per tier — and delete "possibly."
- **medium** Configurability claimed with no configuration surface (§4.4 FR-13, FR-14) — Both FRs say thresholds/intervals are "configurable," but no FR or section describes where Mary configures them. *Fix:* Add the settings FR from the Decision-readiness finding and have FR-13/14 reference it.
- **medium** Orphaned loan behavior after item deletion is ambiguous (§4.1 FR-4) — "The active loan is preserved but the item is removed from the catalog" leaves the loan pointing at a deleted item: does it still appear on the dashboard? Can it be returned? *Fix:* Add a consequence, e.g., "Active loans for deleted items remain on the dashboard until returned; the item shows as '[deleted]'."

## Scope honesty — adequate
The Out of Scope section (§7) does real work — borrower app, cloud sync, accounts, monetization, barcode scanning are all named, so nothing important is left to inference. De-scoping is honest and explicit (FR-15 marks SMS as *Deferred* rather than silently dropping it). Open-item density is low, which is right for solo stakes.

The gap: the PRD uses no `[ASSUMPTION]` tags and no Open Questions section, and the assumptions it does make are load-bearing and invisible — chiefly that email delivery "just works" from a local-only app (see Decision-readiness), and that ~100 items is the right scale ceiling. For a green-light-to-build document, the email assumption is the one that deserved to be surfaced rather than implied.

### Findings
- **medium** Load-bearing assumptions untagged (§4.4, §5.2) — The email-mechanism assumption and the single-device assumption (what happens when Mary switches phones? no export/backup is scoped) are never marked as assumptions a reviewer could push back on. *Fix:* Tag them inline (`[ASSUMPTION: …]`) and index at the end, per the PRD's own conventions.

## Downstream usability — strong
This PRD is clean to source-extract from. The Glossary (§3) defines every domain noun and the FRs use those terms verbatim and consistently — *Available/Loaned/In-Maintenance*, *Risk Level*, *Dashboard* all match across §3, §4, and the UJs. FR-1 through FR-17 are contiguous and unique; UJ-1 through UJ-5 are contiguous; every UJ has Mary as a named protagonist carrying context inline. Each FR section reads sensibly pulled out alone. Sofia can cite FR ids as sources without ambiguity.

### Findings
- **low** Success Metrics have no IDs (§6) — FRs and UJs are ID'd but metrics aren't, so downstream docs can't reference them precisely. *Fix:* Add SM-1/SM-2/CM-1 labels.
- **low** FR-15 is a scope note wearing an FR id (§4.4) — It has no consequences block and describes a non-feature; a naive story generator would create a ticket for it. *Fix:* Move it to §7 Out of Scope with a pointer, or keep the id but mark it clearly as deferred-scope.

## Shape fit — strong
Right-sized for a hobby/solo product. The rubric says solo means "rigor light, substance bar still applies," and this PRD hits that: no enterprise formality, no multi-stakeholder machinery, but the substance (testable consequences, explicit thresholds, honest Out of Scope) is all there. Five UJs for a single-operator tool is at the formal end, but each one maps to a real flow and two of them (UJ-3, UJ-5) drove actual FRs, so they earn their place rather than decorating the template. The four-platform Flutter target (§5.1) is ambitious for a solo build, but it's a stated decision, not shape drift.

## Mechanical notes
- **Glossary drift (minor):** §2.1 says "phone, tablet, desktop, or browser" while §5.1 names "Android, iOS, macOS, and Chrome webapp" — "desktop" vs macOS-only, and "browser" vs Chrome-only. Harmless but worth aligning.
- **ID continuity:** FR-1–17 and UJ-1–5 contiguous and unique; no broken cross-references. SMs unnumbered (see finding above).
- **Assumptions Index:** No `[ASSUMPTION]` tags appear inline and no index exists — trivially consistent, but the mechanism is entirely unused (see Scope honesty).
- **Risk threshold boundaries (§4.5 FR-17):** "Low: 2 days overdue" reads as a point value; days 3–4 are unassigned by the letter of the text. Presumably Low spans 2–4 days, but state the ranges.
- **FR shape consistency:** FR-15 is the only FR without a Consequences block.
- **Required sections:** Vision, Target User, Glossary, Features, NFRs, Success Metrics, Out of Scope all present — appropriate set for the stakes.
