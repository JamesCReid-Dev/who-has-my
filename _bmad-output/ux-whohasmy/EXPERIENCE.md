---
title: WhoHasMy — Experience Design
created: 2026-10-27
updated: 2026-10-27
status: draft
---

# EXPERIENCE.md: WhoHasMy

## Foundation

### Form Factor Strategy
WhoHasMy is **mobile-first** with responsive expansion for tablet and desktop. The primary interaction surface is a phone held in one hand, used in brief sessions (typically 5–15 seconds) when the user needs to quickly check or update loan status. Secondary surfaces are tablets (used at home/work desk) and desktop/laptop (used during more deliberate inventory checks).

| Form Factor | Target Size | Primary Use Case | Navigation Pattern |
|---|---|---|---|
| Phone (portrait) | 375×812pt | Quick checks, on-the-spot registration | Bottom nav bar + FAB |
| Tablet | 768×1024pt | Detailed inventory review, contact management | Bottom nav bar + wider content area |
| Desktop / Chrome webapp | 1024px+ | Batch operations, catalog browsing | Side rail navigation + main content |

### UI System
WhoHasMy uses **Material 3** (Flutter's native theming) as its base UI system. DESIGN.md defines custom tokens that extend Material 3 defaults — colors, spacing, shapes, and typography are all aligned with Material 3 conventions but customized to the WhoHasMy brand identity.

> **Reference**: All visual specifications (colors, typography, spacing, shapes, component visuals) live in `DESIGN.md`. This EXPERIENCE.md specifies behavioral deltas only. Cross-reference tokens using `{path.to.token}` syntax (e.g., `{color.primary.main}`, `{spacing.lg}`).

### Design Principles
1. **One-thumb reachable**: Primary actions within thumb zone on phone screens
2. **Scan, don't read**: Dashboard cards communicate status at a glance; details are one tap away
3. **Progressive disclosure**: Simple by default, complex only when needed
4. **Offline-first**: Every interaction works without network; no loading spinners for local operations
5. **Calm urgency**: High-risk items draw attention without inducing anxiety

---

## Information Architecture

### Top-Level Surfaces
```
┌───────────────────────────────────────┐
│       Bottom Navigation Bar            │
│  [Dashboard]   [Items]   [Contacts]    │
├───────────────────────────────────────┤
│                                       │
│  ┌───────────┬───────────┬──────────┐ │
│  │ Dashboard │   Items   │ Contacts │ │
│  │ (default) │ (catalog) │ (people) │ │
│  │           │           │          │ │
│  │ Risk-ranked│ Grid/    │ List of  │ │
│  │ active    │ list view │ contacts │ │
│  │ loan cards│ of all   │ + email  │ │
│  │ sorted by │ items    │ + phone  │ │
│  └───────────┴───────────┴──────────┘ │
│                                       │
│  FAB: "Register" (always visible on   │
│       Dashboard and Items screens)     │
└───────────────────────────────────────┘
```

### Surface Inventory

| Surface | Entry Point | Purpose | Key Components |
|---|---|---|---|
| **Dashboard** | Bottom nav (default), app launch | Risk-ranked active loans at a glance | ItemCard list, FAB, EmptyState |
| **Items Catalog** | Bottom nav [Items] tab | Browse/filter all items by status | ItemCard grid/list, filter chips |
| **Contacts List** | Bottom nav [Contacts] tab | Manage people who borrow from you | ContactChip list, FAB (add contact) |
| **Item Detail** | Tap ItemCard on Dashboard or Items | Full item info, loan history, actions | Item header, photo gallery, loan timeline, action buttons |
| **Loan Detail** | Tap ItemCard risk badge area | Borrower info, due date, loan actions | ContactChip, due date display, reminder/return buttons |
| **Registration Flow** | FAB tap, or Quick Register long-press | New item + loan in one session | RegistrationForm (multi-step) |
| **Contact Detail** | Tap ContactChip on Contacts list | View/edit contact, see their active loans | Contact header, edit button, their loan cards |
| **Settings** | Profile drawer / Settings nav entry | Owner email, notification preferences | Form fields, toggle switches |

### Navigation Map
```
App Launch
    │
    └──► Dashboard (default)
            │
            ├── FAB tap ──────────────► RegistrationForm Step 1
            │       long-press ────────► Quick Register Menu
            │                                ├─ Item only
            │                                └─ Item + Loan
            │
            ├── Bottom nav [Items] ────► Items Catalog
            │           │
            │           └── Tap item ──► Item Detail
            │                        └── Back ──► Dashboard or Items
            │
            ├── Bottom nav [Contacts] ─► Contacts List
            │         │
            │         └── Tap contact ─► Contact Detail
            │                       └── FAB tap ─► New Contact Form
            │
            └── Swipe left on card ──► Quick Actions
                                         ├─ Send Reminder
                                         └─ Mark Returned

Item Detail (from any entry)
    │
    ├── Loan history section ──► Timeline view
    ├── "Edit item" button ────► Edit Item Form
    └── "Delete item" button ──► Confirmation dialog

Contact Detail (from any entry)
    │
    ├── "Edit contact" button ──► Edit Contact Form
    ├── Active loans section ───► Their loan cards (tappable)
    └── "Delete contact" button ─► Confirmation dialog (+ warning about active loans)

Settings
    │
    ├── Owner email configuration
    ├── Notification thresholds (configurable per FR-13/14)
    ├── Email send interval settings
    └── About / Help
```

### Tab Bar Behavior
| Tab | Default State | Empty State | Badge |
|---|---|---|---|
| Dashboard | Risk-ranked loan cards (High → None) | EmptyState with CTA to register first item | Red dot if any High risk loans exist |
| Items | All items in list view, sorted by name | "No items registered yet" + CTA | — |
| Contacts | Alphabetical contact list | "No contacts saved" + CTA to add one | — |

---

## Voice and Tone (Microcopy)

### Brand Voice in Microcopy
- **Direct but warm**: "The leaf blower is due back tomorrow" not "Notification: Item approaching due date"
- **Action-oriented**: "Send reminder" not "Notify borrower"
- **Risk language**: Use plain English alongside badges — "2 days overdue" not just "HIGH"
- **Empty states**: Encouraging, not apologetic — "No items on loan yet. Tap + to register your first one."

### Microcopy Conventions
| Context | Pattern | Example |
|---|---|---|
| Success toast | Action completed + what changed | "Drill loaned to Tom — email sent" |
| Error toast | What failed + simple next step | "Couldn't send reminder. Check your email settings." |
| Confirmation dialog | Clear action + consequence | "Mark Leaf Blower as returned? This will update its status to Available." |
| Empty state title | Neutral, descriptive | "No items on loan yet" / "No contacts saved" |
| Button labels | Verb-first, specific | "Send Reminder", "Mark Returned", "Add Borrower" |
| Form placeholders | Concrete examples | "e.g., DeWalt 20V Drill" not just "Enter name" |
| Due date display | Relative + absolute | "Due in 3 days (Nov 1, 2026)" or "7 days overdue (Oct 20, 2026)" |

### Pluralization Rules
Always match grammar: "1 day overdue" vs "2 days overdue". Never use bare numbers without context — always pair with the risk badge and plain English description.

---

## Component Patterns (Behavioral)

### Dashboard Cards (`ItemCard`)
| Aspect | Behavior |
|---|---|
| **Tap** | Opens `LoanDetailSheet` bottom sheet with full loan info + actions |
| **Swipe left** | Reveals quick action buttons: "Send Reminder" and "Mark Returned"; swipe back to dismiss |
| **Long press** | Opens context menu: Edit item, Delete loan, View item history |
| **Risk badge animation** | `risk-high` badges pulse gently at 2-second intervals; color transitions are smooth (300ms ease-in-out) when risk level changes |
| **Card ordering** | Sorted by risk descending (High → Medium → Low → None); within same tier, sorted by days overdue descending |

### Registration Form (`RegistrationForm`)
| Aspect | Behavior |
|---|---|
| **Step progression** | Three steps: (1) Item basics → (2) Details/photos → (3) Borrower + due date. Each step has Back/Next; last step has Confirm Loan |
| **Auto-save draft** | If user exits mid-flow, form data is preserved and restored on return within the same session |
| **Validation** | Inline validation on field blur; required fields highlighted in `{color.status.danger.main}` when invalid |
| **Contact search** | Type-ahead search with recent contacts shown first (up to 5); fuzzy matching for name typos |
| **Due date picker** | Default is today + 14 days; quick-select chips for "3 days", "1 week", "2 weeks", "1 month"; custom date available |
| **Confirm Loan action** | Creates item + loan record, sends email to borrower (if email configured), shows success toast, returns to Dashboard |

### Contact Selection (`ContactChip` in forms)
| Aspect | Behavior |
|---|---|
| **Search behavior** | Real-time filtering as user types; shows matching contacts by name or email |
| **Recent contacts** | Up to 5 most recently loaned-to contacts shown at top of search results, above the search field |
| **New contact inline** | If no match found, "Add [name]" option appears; tapping it opens a minimal new-contact form without leaving the registration flow |
| **Validation warning** | If selected contact has no email address, a warning banner appears: "[Name] has no email. They won't receive the loan notification." User can proceed but sees the warning until they add an email or choose a different contact |

### Loan Detail Sheet (`LoanDetailSheet`)
| Aspect | Behavior |
|---|---|
| **Open** | Slides up from bottom, covers ~70% of screen height; dimmed backdrop (use `{color.neutral.overlay}`) |
| **Drag to dismiss** | User can drag sheet down to close; closes if dragged more than 40px downward without triggering an action |
| **"Send Reminder" button** | Outlined style using `{color.secondary.main}` border; sends a single reminder email to borrower; shows toast "Reminder sent to [Name]" on success |
| **"Mark Returned" button** | Filled style using `{color.status.success.main}` background; opens confirmation dialog before executing |

### FAB (Floating Action Button)
| Aspect | Behavior |
|---|---|
| **Tap** | Opens RegistrationForm Step 1 (full registration flow) |
| **Long press** | Shows popup menu: "Item only" or "Item + Loan". Supports UJ-5's on-the-spot registration need. |
| **Position** | Fixed at bottom-right, 16px from edges on phone; adjusts for keyboard presence in form screens |
| **Visibility** | Always visible on Dashboard and Items tabs; hidden on detail sheets and forms |

---

## State Patterns

### Loading States
| Surface | Pattern |
|---|---|
| Dashboard initial load | Skeleton cards matching the layout of `ItemCard` components (shimmer effect); no spinner — the list area is populated as data loads from local storage |
| Registration form step transition | No loading state needed; transitions are instant (local data) |
| Contact search | Show recent contacts immediately; filter results as user types (no loading indicator for local search) |

### Empty States
| Surface | Pattern |
|---|---|
| Dashboard (no active loans) | `EmptyState` component with illustration, title "No items on loan yet", description "Tap the + button to register your first item.", and a filled primary CTA button |
| Items catalog (no items) | Same empty state pattern but title: "No items registered" — CTA opens RegistrationForm Step 1 |
| Contacts list (no contacts) | Title: "No contacts saved", description: "Add contacts so you can track who borrows from you.", CTA: "Add Contact" |

### Offline / Connectivity States
| State | Visual Treatment | Behavior |
|---|---|---|
| **Online** | No indicator shown | All operations execute normally |
| **Offline** | Subtle banner at top of screen: "Working offline — changes saved locally" with a small disconnected icon | All local operations work; email sends queue and attempt when connection is restored; toast on next launch: "Sent 2 queued reminder emails" |
| **Email send failed** | Inline warning on the affected loan card (small red exclamation icon + "Email failed to send") visible in Settings > Notifications section | User can retry from the loan detail sheet or settings |

### Error States
| Context | Pattern |
|---|---|
| Form validation error | Field border turns `{color.status.danger.main}`; error message appears below field in `{color.status.danger.main}` text |
| Confirmation dialog cancellation | Dialog dismisses with no action taken; user returns to previous screen unchanged |
| Item deletion confirmation | "Delete [Item Name]? Active loans for this item will be preserved but the item will show as '[deleted]' on the dashboard." — two buttons: Cancel (outlined) and Delete (filled, danger color) |

### High-Risk Urgency State
When any loan reaches `risk-high` status (>5 days overdue):
- Dashboard card gets a subtle red border glow (`{color.status.danger.main}` at 20% opacity)
- Risk badge pulses gently every 2 seconds
- FAB pulses gently (subtle scale animation, 1s interval) to draw attention to the ability to take action
- These animations are **gentle** — they should be noticeable on a quick glance but not distracting or anxiety-inducing

---

## Interaction Primitives

### Primary Actions
| Action | Trigger | Feedback |
|---|---|---|
| Register new item/loan | FAB tap (or long-press for quick menu) | Screen transitions to RegistrationForm Step 1; haptic light tap on entry |
| Send reminder | Swipe left on card → "Send Reminder" button, or LoanDetailSheet button | Toast: "Reminder sent to [Name]"; haptic light tap on success |
| Mark item returned | Swipe left on card → "Mark Returned" button, or LoanDetailSheet button | Confirmation dialog → success toast with checkmark; haptic double-tap on confirmation |
| Open detail sheet | Tap any ItemCard on Dashboard or Items catalog | Shared element transition from card to bottom sheet; haptic light tap on open |

### Gestures
| Gesture | Surface | Action |
|---|---|---|
| Swipe left | Dashboard card, Item card in catalog | Reveal quick actions (Send Reminder / Mark Returned) |
| Swipe right (to dismiss) | Any swipe-revealed action row | Dismiss quick actions, return to normal card state |
| Long press | Dashboard card, Item card | Open context menu (Edit, Delete loan, View history) |
| Drag down | LoanDetailSheet bottom sheet | Dismiss sheet if dragged >40px without triggering an action |
| Pinch / double-tap | Photo gallery in Item Detail or Loan Detail | Zoom in/out of photos |

### Haptic Feedback
| Event | Pattern |
|---|---|
| Screen entry (form open) | Light tap (subtle, barely perceptible) |
| Successful action confirmation | Light tap |
| "Mark Returned" confirmed | Double-tap (two quick pulses — signals completion) |
| Error / validation failure | None (visual feedback only to avoid frustration amplification) |
| Swipe-to-reveal actions | Very light tap when swipe threshold is reached |

### Transitions
| Transition | Duration | Easing |
|---|---|---|
| Screen push/pop (navigation) | 350ms | ease-in-out |
| Bottom sheet slide up/down | 300ms | ease-out (up), ease-in (down) |
| Card swipe reveal | 200ms | ease-out |
| Risk badge color change | 300ms | ease-in-out |
| FAB pulse animation | Continuous loop, 1s per cycle | ease-in-out |
| Skeleton shimmer | Continuous loop, 1.5s per cycle | linear |

---

## Accessibility Floor

### WCAG 2.1 AA Compliance
All visual elements meet or exceed WCAG 2.1 AA minimum contrast ratios:
- **Normal text** (< 18pt / 24px): 4.5:1 minimum contrast ratio
- **Large text** (≥ 18pt / 24px or ≥ 14pt bold): 3:1 minimum contrast ratio
- **UI components and graphics**: 3:1 minimum contrast ratio against adjacent colors

### Dynamic Type Support
- All typography scales proportionally with system font settings up to 200% maximum
- Layouts reflow gracefully at all supported text sizes — no horizontal scrolling required
- Touch targets maintain minimum 44×44pt (iOS) / 48×48px (Android) even at large text sizes

### Screen Reader Support
- All risk badges have accessible labels that include both the status and context: "High risk, 7 days overdue" — not just "High risk"
- Status pills are announced with their full label: "Available", "Loaned", or "In Maintenance"
- Form fields have associated labels and error messages that are programmatically linked
- Empty states include descriptive text that is screen-reader accessible

### Touch Target Sizing
| Element | Minimum Size | Notes |
|---|---|---|
| Navigation bar items | 48×48px (Android) / 44×44pt (iOS) | Standard Material 3 tab bar sizing |
| FAB | 56×56px diameter | Per Material 3 FAB specification |
| List item cards | Full width tappable area | Entire ItemCard is a touch target |
| Buttons | 48×48px minimum | Including padding around text/icon |
| Form inputs | Full-width, 48px height minimum | With adequate internal padding |
| Swipe gesture area | Rightmost 120px of card | Clearly indicated by visual affordance |

### Color Independence
- Risk level is never conveyed by color alone — always paired with: (a) icon, (b) text label ("7 days overdue"), and (c) badge shape/position
- Status colors are supplemented with icons: check-circle for on-time, alert-outline for warning, alert-octagon for high risk
- All interactive elements have visible focus/hover states that do not rely solely on color change

### Motion Preferences
- Respects system-level "reduce motion" preferences
- When reduce motion is enabled: pulse animations are disabled; transitions use instant or 100ms fade instead of slide
- Skeleton shimmer continues (it does not convey information, only indicates loading)

---

## Key Flows (Named Journeys)

### Flow A: "Mary loans her drill to a neighbor" (UJ-1)
**Protagonist**: Mary, homeowner, handing a tool to a neighbor at their driveway.
**Context**: Standing outside, one-handed phone use, daylight visibility.
**Goal**: Register the drill and loan it to Tom in under 30 seconds.

| Step | Action | Screen / Component | Climax Beat |
|---|---|---|---|
| 1 | Opens app on phone | Dashboard loads (risk-ranked cards) | — |
| 2 | Taps FAB ("+") | RegistrationForm opens at Step 1: Item Basics | — |
| 3 | Types "DeWalt 20V Drill" | Text input field with placeholder | — |
| 4 | Selects category "Tools" | Segmented button group | — |
| 5 | Taps "Next" | Transitions to Step 2: Details/Photos | — |
| 6 | Takes a photo (or skips) | Image picker with camera/gallery options | — |
| 7 | Taps "Next" | Transitions to Step 3: Borrower + Due Date | — |
| 8 | Searches for "Tom" in contacts | Contact selector with type-ahead search. Tom appears in recent contacts if previously loaned. | — |
| 9 | Selects "Tom (Neighbor)" | ContactChip selected, shown as borrower | — |
| 10 | Due date defaults to +14 days; taps "Confirm Loan" | Form submits | **Climax**: Success toast: "Drill loaned to Tom — email sent." Haptic double-tap confirms. Dashboard shows the drill card with risk badge ("On time"). |
| 11 | App returns to Dashboard | Mary sees her new loan card at the top of the list | **Resolution**: Item is tracked, borrower notified, Mary can relax. |

**Edge case**: If Tom has no email address configured, Step 3 shows a warning banner: "Tom has no email. He won't receive the loan notification." Mary can add his email in-line or confirm anyway.

---

### Flow B: "Mary checks what's overdue" (UJ-2)
**Protagonist**: Mary, sitting at her kitchen table with morning coffee.
**Context**: Relaxed but curious — wants a quick status check.
**Goal**: Identify which items are overdue and how urgently she needs to follow up.

| Step | Action | Screen / Component | Climax Beat |
|---|---|---|---|
| 1 | Opens app on phone | Dashboard loads (risk-ranked cards) | — |
| 2 | Scans card badges at a glance | Cards sorted High → Medium → Low → None | **Climax**: Within 2 seconds, Mary identifies: one red badge ("7 days overdue"), two amber badges ("3 days overdue"). Visual hierarchy makes urgency obvious without reading any text. |
| 3 | Taps the highest-risk card (red badge) | LoanDetailSheet slides up from bottom | — |
| 4 | Sees borrower info, due date, loan history | ContactChip + key-value details in sheet | Mary reads: "Leaf blower — due Oct 20 — 7 days overdue" |
| 5 | Taps "Send Reminder" (outlined button) | Email sent to borrower; toast appears | **Resolution**: "Reminder sent to Tom." Mary closes the sheet, taps the next amber card. |

**Design note**: The dashboard's risk-ranked sorting ensures the most urgent items are always at the top — no scrolling required for the first few cards if there are only a handful of active loans.

---

### Flow C: "Mary returns the leaf blower" (UJ-4)
**Protagonist**: Mary, neighbor has just knocked on her door with the leaf blower.
**Context**: Standing at her front door, item is physically present.
**Goal**: Mark the item as returned quickly and accurately.

| Step | Action | Screen / Component | Climax Beat |
|---|---|---|---|
| 1 | Opens app on phone | Dashboard loads | — |
| 2 | Finds the leaf blower card (still showing as Loaned with a risk badge) | Card visible in list | — |
| 3 | Swipes left on the card | Quick action buttons slide into view: "Send Reminder" and "Mark Returned" | — |
| 4 | Taps "Mark Returned" | Confirmation dialog appears: "Confirm return of Leaf Blower?" with photo history preview below | **Climax**: Mary sees the photos she took when registering, confirming it's the right item. She taps "Yes, it's back." |
| 5 | Haptic double-tap confirms | Card animates: risk badge disappears, StatusPill changes from "Loaned" (blue) to "Available" (green), checkmark animation plays | **Resolution**: Success toast: "Leaf blower marked as returned." The card moves down in the list. Mary feels satisfied — her tracking worked. |

**Edge case**: If the item was damaged on return, Mary can add a condition note and photos from the Item Detail screen after marking it returned. Photos of the condition stay with the item's history for future reference.

---

### Flow D: "Friend asks to borrow — quick register on the spot" (UJ-5)
**Protagonist**: Mary, friend calls asking to borrow her leaf blower right now.
**Context**: Standing in the garage, needs to register quickly before handing it over.
**Goal**: Register item + loan in one session, under 10 taps.

| Step | Action | Screen / Component | Climax Beat |
|---|---|---|---|
| 1 | Opens app on phone | Dashboard loads | — |
| 2 | Long-presses FAB (instead of single tap) | Quick Register Menu appears: "Item only" / "Item + Loan" | — |
| 3 | Taps "Item + Loan" | RegistrationForm opens at Step 1 | **Climax**: Mary is already in the flow — no extra navigation needed. |
| 4 | Types "Leaf blower", selects "Tools", taps Next | Step 2: Details/Photos (skipped) | — |
| 5 | Taps "Next" again (skips photos) | Step 3: Borrower + Due Date | — |
| 6 | Searches for friend's name; if not in contacts, taps "Add [Name]" inline | Minimal new-contact form appears without leaving the flow | Friend is added and selected as borrower |
| 7 | Due date defaults to +14 days; taps "Confirm Loan" | Form submits, item + loan created | **Resolution**: Success toast: "[Item] loaned to [Name] — email sent." Mary returns to Dashboard with the new card visible. Total taps from app launch: ~8. |

**Design note**: The long-press FAB menu is critical for UJ-5's speed requirement. A single-tap FAB always opens the full multi-step form; a long-press gives the option to skip directly to "Item + Loan" mode, which pre-selects the most common path.

---

### Flow E: "Mary receives a notification about an approaching or overdue loan" (UJ-3)
**Protagonist**: Mary, receiving an email alert from WhoHasMy.
**Context**: Checking her inbox on her phone during a commute.
**Goal**: Understand the urgency at a glance and take action when she opens the app.

| Step | Action | Screen / Component | Climax Beat |
|---|---|---|---|
| 1 | Receives email notification (system-level, not in-app) | Email subject line varies by risk level: "Reminder: [Item] is due tomorrow" (Low), "Overdue: [Item] is 3 days past due" (Medium), "Urgent: [Item] is 7 days overdue!" (High) | — |
| 2 | Opens app on phone | Dashboard loads, showing the affected loan card with appropriate risk badge color | **Climax**: The email's urgency matches what Mary sees in-app. If deep-linking were implemented, the app would open directly to that loan's detail sheet. |
| 3 | Takes action from Dashboard: swipe → "Send Reminder" or tap card → LoanDetailSheet → "Send Reminder" | Same as Flow B, Step 5 | **Resolution**: Mary has acknowledged and acted on the notification. The risk level will update when the borrower responds (or when the due date passes further). |

**Design note**: Email content and urgency scale with risk level per FR-14:
- **Low Risk (2 days overdue)**: Subject prefix "Reminder:" — standard reminder email to both parties
- **Medium Risk (5 days overdue)**: Subject prefix "Overdue:" — stronger, more urgent wording
- **High Risk (>5 days overdue)**: Subject prefix "Urgent:" — most urgent email with clear call-to-action

---

*Both DESIGN.md and EXPERIENCE.md are peer contracts for WhoHasMy. In case of conflict between visual specifications (DESIGN.md) and behavioral specifications (EXPERIENCE.md), both take precedence over any external mock, wireframe, or import document.*