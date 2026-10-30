---
title: WhoHasMy — Epics and User Stories
created: 2026-10-27
updated: 2026-10-29
status: ready-for-dev
sources:
  - _bmad-output/prd-whohasmy/prd-whohasmy/prd-whohasmy.md
  - _bmad-output/ux-whohasmy/DESIGN.md
  - _bmad-output/ux-whohasmy/EXPERIENCE.md
  - _bmad-output/arch-whohasmy/ARCHITECTURE.md
---

# EPICS.md: WhoHasMy — Epics and User Stories

> **Source of truth**: PRD (`prd-whohasmy.md`) defines requirements. ARCHITECTURE.md defines implementation constraints. DESIGN.md + EXPERIENCE.md define UX behavior. This document slices those into epics and stories for development sprint planning.
>
> Story IDs are globally unique (STORY-001 through STORY-NNN). Each story references PRD FRs, UJs, or AD decisions it realizes.

---

## Epic Overview

| Epic | Title | Stories | Priority | Depends On |
|---|---|---|---|---|
| EPIC-01 | Cross-Platform Foundation | 4 | P0 — Must Have | None |
| EPIC-02 | Item Management | 6 | P0 — Must Have | EPIC-01 |
| EPIC-03 | Contact Management | 5 | P0 — Must Have | EPIC-01 |
| EPIC-04 | Loan Tracking | 7 | P0 — Must Have | EPIC-02, EPIC-03 |
| EPIC-05 | Dashboard & Risk Ranking | 4 | P0 — Must Have | EPIC-04 |
| EPIC-06 | Email Notifications | 6 | P1 — Should Have | EPIC-01, EPIC-04 |
| EPIC-07 | Settings & Configuration | 3 | P1 — Should Have | EPIC-01 |

**Total**: 7 epics, 35 stories

---

## EPIC-01: Cross-Platform Foundation

**Goal**: Establish the Flutter application shell with state management, local storage, theming, and navigation infrastructure. This epic enables all downstream work.

### STORY-001: Flutter Project Scaffolding with Clean Architecture
**Title**: Initialize Flutter project with domain/application/infrastructure/presentation package structure
**Priority**: P0 — Must Have
**Sources**: ARCHITECTURE.md AD-1, AD-2
**UX Reference**: EXPERIENCE.md Foundation

**Acceptance Criteria:**
- [ ] Flutter project created targeting Android (minSdk 21), iOS (deployment target 13.0), macOS (10.14), and Chrome webapp
- [ ] Package structure follows Clean Architecture: `lib/domain/`, `lib/application/`, `lib/infrastructure/`, `lib/presentation/`
- [ ] Dependencies declared in pubspec.yaml: riverpod, freezed, hive, flutter_email_sender, image_picker, workmanager (Android), flutter_local_notifications (iOS/macOS)
- [ ] Build runner configured for code generation (freezed adapters, hive adapters)
- [ ] Linter rules configured to enforce dependency direction (no outer-layer imports in inner layers)
- [ ] Project builds and runs on all four target platforms without errors

**Definition of Done**: All four platform targets build successfully; package structure verified by linter.

---

### STORY-002: Hive Storage Initialization and Repository Interfaces
**Title**: Set up Hive boxes, register adapters, implement repository interfaces with in-memory test doubles
**Priority**: P0 — Must Have
**Sources**: ARCHITECTURE.md AD-3, ARCHITECTURE.md Data Model section
**UX Reference**: None (infrastructure)

**Acceptance Criteria:**
- [ ] Five Hive boxes initialized: `items`, `contacts`, `loans`, `photos`, `settings`
- [ ] Entity adapters generated for Item, Contact, Loan, Category, ItemStatus, RiskLevel
- [ ] Repository interfaces defined in domain layer: `ItemRepository`, `LoanRepository`, `ContactRepository` (abstract classes with getAll, getById, insert, update, delete, watchAll methods)
- [ ] In-memory repository implementations exist for unit testing
- [ ] Hive initialization runs once at app startup before any UI renders
- [ ] All entity classes use Freezed with copyWith, when, and map methods

**Definition of Done**: Hive boxes open successfully; repository interfaces compile in domain layer with zero outer-layer dependencies.

---

### STORY-003: Riverpod State Management Setup
**Title**: Configure Riverpod providers for dashboard, items catalog, contacts list, registration form, and settings
**Priority**: P0 — Must Have
**Sources**: ARCHITECTURE.md State Management section
**UX Reference**: EXPERIENCE.md Component Patterns (RegistrationForm)

**Acceptance Criteria:**
- [ ] `AsyncNotifierProvider` providers created for DashboardState, ItemsCatalogState, ContactsState (all with autoDispose)
- [ ] `NotifierProvider` for RegistrationFormState (form state, not async data)
- [ ] Singleton `Provider` for SettingsProvider (ownerEmail, smtpConfig, notificationInterval)
- [ ] State classes defined with Freezed: DashboardState, ItemCardData, RegistrationFormState
- [ ] Provider hierarchy documented and tested with mock repositories
- [ ] All providers have corresponding unit tests in the application layer

**Definition of Done**: All five provider types compile; state update flow (User Action → Widget → Notifier → UseCase → Repository → Hive → UI) verified with integration test.

---

### STORY-004: Material 3 Theme from DESIGN.md Tokens
**Title**: Implement Flutter theme using DESIGN.md color, typography, spacing, and shape tokens
**Priority**: P0 — Must Have
**Sources**: DESIGN.md (all sections), EXPERIENCE.md Foundation
**UX Reference**: DESIGN.md Brand & Style, Colors, Typography, Shapes

**Acceptance Criteria:**
- [ ] ThemeData configured with primary (#1565C0), secondary (#FFA726), status colors (success #43A047, warning #FB8C00, danger #E53935)
- [ ] Inter font family applied as primary typeface with Material 3 type scale
- [ ] Spacing scale implemented: xs(4px), sm(8px), md(12px), lg(16px), xl(20px), xxl(24px), xxxl(32px)
- [ ] Corner radius system applied: sm(4px badges), md(8px buttons/inputs), lg(12px cards), xl(16px dialogs), full (circular FAB)
- [ ] Light and dark mode themes both functional; system dark mode respected
- [ ] Elevation system configured per DESIGN.md (level0 through level3 shadows/tints)

**Definition of Done**: App renders with correct colors, typography, spacing, and shapes on all four platforms in both light and dark modes.

---

## EPIC-02: Item Management

**Goal**: Enable Mary to register, view, edit, and delete items — the core catalog of physical objects she owns.

### STORY-005: Register a New Item (FR-1)
**Title**: Create item registration form with name, description, category, photo, and status=Available
**Priority**: P0 — Must Have
**Sources**: PRD FR-1, EXPERIENCE.md Component Patterns (RegistrationForm), UX Flow A Step 1-2
**UX Reference**: DESIGN.md RegistrationForm component, EXPERIENCE.md Flow A

**Acceptance Criteria:**
- [ ] Multi-step registration form: Step 1 (item basics: name required, category optional) → Step 2 (details: description textarea, photo picker) → Step 3 (borrower + due date — handled in EPIC-04 loan flow)
- [ ] Item name field: text input, required, max 200 chars, placeholder "e.g., DeWalt 20V Drill"
- [ ] Category selector: segmented button group with default options (Tools, Electronics, Books, Sports, Other) plus ability to add custom categories
- [ ] Description field: optional textarea, max 500 chars
- [ ] Photo picker: optional, up to 3 photos per item, compressed to JPEG at 70% quality before storage as byte arrays in Hive `photos` box
- [ ] Item created with status = Available and stored in Hive `items` box with key pattern "item:{uuid}"
- [ ] Form auto-saves draft if user exits mid-flow; restored on return within same session
- [ ] Inline validation on field blur; errors displayed below field in danger color

**Definition of Done**: User can register an item through all form steps; item persists in Hive with correct status, category, and optional photo.

---

### STORY-006: View Item Details (FR-2)
**Title**: Display full item details including name, description, category, photos, loan history timeline
**Priority**: P0 — Must Have
**Sources**: PRD FR-2, EXPERIENCE.md Component Patterns (LoanDetailSheet), UX Flow B Step 3-4
**UX Reference**: DESIGN.md ItemCard tap → LoanDetailSheet

**Acceptance Criteria:**
- [ ] Tapping an ItemCard on Dashboard or Items catalog opens a bottom sheet (covers ~70% screen height) with drag-to-dismiss gesture
- [ ] Sheet displays: item name (title.large), description, category badge, photo gallery (horizontal scroll if photos exist)
- [ ] Loan history section shows all past and active loans as a timeline with borrower name, due date, return date (if returned), and condition notes
- [ ] If item has an active loan, risk badge and days overdue displayed prominently
- [ ] Action buttons at bottom: "Edit Item" (outlined) and "Delete Item" (text, danger color)
- [ ] Photo gallery supports tap-to-fullscreen-viewer with swipe navigation

**Definition of Done**: User can view complete item details including loan history; all fields from the Item entity are displayed.

---

### STORY-007: Edit Item Details (FR-3)
**Title**: Update item name, description, category, condition, or photo at any time without affecting active loans
**Priority**: P0 — Must Have
**Sources**: PRD FR-3
**UX Reference**: EXPERIENCE.md Component Patterns (RegistrationForm edit mode)

**Acceptance Criteria:**
- [ ] "Edit Item" button opens pre-populated form with current item values
- [ ] User can update: name, description, category, photos (add/remove/replace), condition notes
- [ ] Changes persist to Hive `items` box; existing loans for this item are NOT affected by field changes
- [ ] If item is currently on loan, a banner appears at top of edit form: "This item is currently loaned. Changes will not affect the active loan record."
- [ ] Form validation same as registration (name required, max lengths enforced)
- [ ] Save button shows success toast; cancel returns to item detail without saving

**Definition of Done**: User can modify any editable field on an item; active loans remain intact after edits.

---

### STORY-008: Delete Item with Loan Preservation (FR-4)
**Title**: Delete item with confirmation dialog; preserve active loan records when deleting a loaned item
**Priority**: P0 — Must Have
**Sources**: PRD FR-4, ARCHITECTURE.md OQ-1
**UX Reference**: EXPERIENCE.md State Patterns (Error States — Item deletion)

**Acceptance Criteria:**
- [ ] "Delete Item" button opens confirmation dialog with message: "Delete [Item Name]? Active loans for this item will be preserved but the item will show as '[deleted]' on the dashboard."
- [ ] Two buttons in dialog: Cancel (outlined) and Delete (filled, danger color)
- [ ] If item has NO active loans: item is removed from Hive `items` box immediately; loan records remain in Hive `loans` box with itemId set to "[deleted]"
- [ ] If item HAS active loans: item is removed from catalog but active loan records are preserved; dashboard shows the loan with item name as "[deleted]" and borrower info intact
- [ ] Active loans for deleted items continue to appear on Dashboard until returned
- [ ] Delete action shows success toast: "[Item Name] removed from catalog"

**Definition of Done**: Item deletion works correctly in both scenarios (with and without active loans); loan records preserved; dashboard reflects deleted items as "[deleted]".

---

### STORY-009: Default and Custom Categories
**Title**: Provide default categories with ability to add custom categories
**Priority**: P1 — Should Have
**Sources**: PRD FR-5 (implied), DESIGN.md RegistrationForm category field
**UX Reference**: EXPERIENCE.md Component Patterns (RegistrationForm Step 1)

**Acceptance Criteria:**
- [ ] Default categories available: Tools, Electronics, Books, Sports, Other
- [ ] User can add custom categories via text input when "Other" is selected
- [ ] Custom categories persist in Hive `settings` box as a list of category strings
- [ ] Categories displayed consistently across registration form, item detail, and items catalog

**Definition of Done**: User can select from default categories or create custom ones; categories persist.

---

### STORY-010: Items Catalog with Status Filtering
**Title**: Browse all registered items in list view with filter by status (Available / Loaned / In-Maintenance)
**Priority**: P1 — Should Have
**Sources**: PRD Feature 4.1, EXPERIENCE.md Information Architecture (Items Catalog surface)
**UX Reference**: DESIGN.md ItemCard, StatusPill

**Acceptance Criteria:**
- [ ] Items catalog screen accessible via bottom nav [Items] tab
- [ ] Default view: all items in list format, sorted alphabetically by name
- [ ] Filter chips at top: All, Available, Loaned, In-Maintenance (tap to toggle filter)
- [ ] Each item displayed as an ItemCard with StatusPill showing current status color
- [ ] Empty state when no items exist: "No items registered" + CTA button "Register an Item"
- [ ] Swipe left on card reveals quick actions; tap card opens Item Detail bottom sheet

**Definition of Done**: User can browse, filter, and interact with all registered items in the catalog.

---

## EPIC-03: Contact Management

**Goal**: Enable Mary to manage contacts — people who borrow items from her. Contacts store email (required for notifications) and phone (stored for future SMS).

### STORY-011: Create a New Contact
**Title**: Add contact with name, email (optional but warned if missing), and phone number
**Priority**: P0 — Must Have
**Sources**: PRD FR-7, EXPERIENCE.md Component Patterns (ContactChip in forms)
**UX Reference**: DESIGN.md ContactChip

**Acceptance Criteria:**
- [ ] "Add Contact" button opens form with fields: name (required, max 100 chars), email (optional), phone (optional)
- [ ] Name field: text input, required, placeholder "e.g., Tom (Neighbor)"
- [ ] Email field: email-type keyboard, optional but displays warning if left empty when loaning an item
- [ ] Phone field: phone-type keyboard, optional — stored for future SMS (v2+), no v1 notifications
- [ ] Contact saved to Hive `contacts` box with key pattern "contact:{uuid}"
- [ ] Avatar circle generated from contact name initials (colored background based on first letter)
- [ ] Success toast: "[Name] added as contact"

**Definition of Done**: User can create a contact with name, optional email, and optional phone; contact persists in Hive.

---

### STORY-012: View and Edit Contact Details
**Title**: View full contact details including name, email, phone, active loan count, and edit/delete options
**Priority**: P0 — Must Have
**Sources**: PRD FR-7 (implied), EXPERIENCE.md Information Architecture (Contact Detail surface)
**UX Reference**: DESIGN.md ContactChip tap → ContactDetailSheet

**Acceptance Criteria:**
- [ ] Tapping a ContactChip on Contacts list opens detail sheet with: name, email, phone, active loan count badge
- [ ] Active loans section shows cards for each current loan (item name, due date, risk badge) — tappable to open Loan Detail
- [ ] "Edit Contact" button opens pre-populated form (same fields as creation)
- [ ] "Delete Contact" button opens confirmation dialog with warning: "[Name] has [N] active loan(s). Deleting this contact will preserve loan records but remove their contact info."
- [ ] If contact has active loans, deletion preserves loan records in Hive `loans` box; borrower name shown as "[deleted]" on dashboard

**Definition of Done**: User can view and edit any contact's details; deleting a contact with active loans preserves loan data.

---

### STORY-013: Contact List with Search
**Title**: Browse contacts alphabetically with real-time search by name or email
**Priority**: P0 — Must Have
**Sources**: EXPERIENCE.md Component Patterns (ContactChip in forms), UX Flow A Step 8
**UX Reference**: DESIGN.md ContactChip

**Acceptance Criteria:**
- [ ] Contacts list sorted alphabetically by name, displayed as ContactChips with avatar + name + email preview (truncated)
- [ ] Search field at top filters contacts in real-time as user types (name and email matching)
- [ ] Recent contacts (most recently loaned-to, up to 5) shown at top of search results when search is empty or has no matches
- [ ] Empty state: "No contacts saved" + CTA "Add Contact" → opens new contact form

**Definition of Done**: User can browse, search, and interact with all contacts in the list.

---

### STORY-014: Contact Selection During Loan Registration
**Title**: Select existing contact or add new inline during loan registration flow
**Priority**: P0 — Must Have
**Sources**: PRD FR-8 (loan creation), EXPERIENCE.md Flow A Step 8-9, EXPERIENCE.md Component Patterns (ContactChip in forms)
**UX Reference**: DESIGN.md RegistrationForm borrower field

**Acceptance Criteria:**
- [ ] In RegistrationForm Step 3 (Borrower + Due Date), borrower selector shows search field with type-ahead filtering
- [ ] Recent contacts displayed above search field when no query entered
- [ ] If no contact matches the search, "Add [name]" option appears — tapping opens minimal new-contact form without leaving registration flow
- [ ] Selected contact shown as a ContactChip in the form
- [ ] If selected contact has NO email address, warning banner appears: "[Name] has no email. They won't receive the loan notification." User can proceed but sees warning until they add an email or choose different contact
- [ ] Contact selection is required to proceed to Confirm Loan

**Definition of Done**: User can select a contact during loan registration; inline contact creation works without leaving the flow; email warning displays appropriately.

---

### STORY-015: Contact Deletion with Active Loan Warning
**Title**: Prevent accidental deletion of contacts with active loans; preserve data integrity
**Priority**: P1 — Should Have
**Sources**: ARCHITECTURE.md OQ-1, PRD FR-4 (parallel to item deletion logic)
**UX Reference**: EXPERIENCE.md State Patterns (Error States)


## EPIC-04: Loan Tracking

**Goal**: Enable Mary to create loans (linking an item to a contact with a due date), track their status, and mark items as returned.

### STORY-016: Create a New Loan (FR-8 + FR-9)
**Title**: Link an available item to a contact with a due date; set item status to Loaned; send initial notification email
**Priority**: P0 — Must Have
**Sources**: PRD FR-8, FR-9, EXPERIENCE.md Flow A Step 3-11
**UX Reference**: DESIGN.md RegistrationForm Step 3, UX Flow A

**Acceptance Criteria:**
- [ ] Loan created from RegistrationForm Step 3: borrower selected + due date set (default today + 14 days)
- [ ] Due date picker with quick-select chips: "3 days", "1 week", "2 weeks", "1 month"; custom date available
- [ ] Confirming loan creates a Loan record in Hive `loans` box with itemId, contactId, dueDate, isReturned=false
- [ ] Item status changes from Available to Loaned; item card appears on Dashboard with risk badge (None — not overdue)
- [ ] Initial notification email sent to borrower's email address via SMTP (if configured); email uses loanCreatedTemplate with item name, borrower name, due date
- [ ] If borrower has no email: warning shown but user can still create the loan; loan appears on Dashboard without email notification
- [ ] Success toast: "[Item] loaned to [Name] — email sent" (or "email not sent — no address configured")

**Definition of Done**: Loan record created, item status updated, borrower notified via email (if email available), dashboard reflects new active loan.

---

### STORY-017: Mark Item as Returned (FR-10)
**Title**: Confirm return with condition notes and photo history; set item status back to Available
**Priority**: P0 — Must Have
**Sources**: PRD FR-10, EXPERIENCE.md Flow C Step 3-5
**UX Reference**: DESIGN.md ItemCard swipe-left → Mark Returned, UX Flow C

**Acceptance Criteria:**
- [ ] Swipe left on Dashboard card reveals "Mark Returned" button (green success color)
- [ ] Tapping "Mark Returned" opens confirmation dialog: "Confirm return of [Item Name]?" with photo history preview below
- [ ] User can optionally add condition notes before confirming (text area, max 500 chars)
- [ ] Confirming sets Loan.isReturned=true, Loan.returnedAt=now, Loan.returnConditionNotes=value
- [ ] Item status changes from Loaned to Available; item card moves down in Dashboard list (no longer active loan)
- [ ] Haptic double-tap confirms return; success toast: "[Item Name] marked as returned"

**Definition of Done**: User can mark an item as returned with optional condition notes; item status updates correctly; loan record preserved with return metadata.

---

### STORY-018: View Active Loans on Dashboard (FR-16)
**Title**: Display all active loans sorted by risk level (High → Medium → Low → None) with days overdue
**Priority**: P0 — Must Have
**Sources**: PRD FR-16, EXPERIENCE.md Flow B Step 2
**UX Reference**: DESIGN.md ItemCard, RiskBadge

**Acceptance Criteria:**
- [ ] Dashboard shows list of all active loans (isReturned=false) as ItemCards
- [ ] Cards sorted by risk level descending: High first, then Medium, Low, None; within same risk tier, sorted by days overdue descending
- [ ] Each card displays: item name (title.large), borrower name (body.medium), due date (label.medium with status color), RiskBadge (right-aligned)
- [ ] StatusPill on left of card shows "Loaned" (blue) for active loans
- [ ] Empty state when no active loans: "No items on loan yet" + CTA to register first item
- [ ] Dashboard loads in under 2 seconds with 100 items (per PRD NFR §5.2)

**Definition of Done**: Dashboard displays all active loans correctly sorted by risk; performance meets NFR requirement.

---
**Acceptance Criteria:**
- [ ] Deleting a contact with zero active loans: proceeds immediately after confirmation dialog
- [ ] Deleting a contact with one or more active loans: shows enhanced warning dialog listing each affected loan (item name, due date)
- [ ] User must explicitly confirm deletion despite active loans
- [ ] After deletion, all preserved loan records show borrower as "[deleted]" on dashboard and item detail screens

**Definition of Done**: Contact deletion handles both scenarios correctly; data integrity maintained across loans.

---

### STORY-019: Calculate Risk Level from Days Overdue (FR-17)
**Title**: Implement pure function RiskCalculator.calculate(daysOverdue) with explicit thresholds per PRD FR-17
**Priority**: P0 — Must Have
**Sources**: PRD FR-17, ARCHITECTURE.md AD-5, ARCHITECTURE.md Value Objects section
**UX Reference**: DESIGN.md RiskBadge variants

**Acceptance Criteria:**
- [ ] `RiskCalculator.calculate(int daysOverdue)` is a pure function in domain layer with no side effects
- [ ] Thresholds implemented exactly as specified: None (<2 days), Low (2-4 days), Medium (5 days), High (>5 days)
- [ ] Risk level displayed on Dashboard card via RiskBadge with appropriate color and icon
- [ ] All risk references in codebase call `RiskCalculator.calculate()` — no hardcoded comparisons
- [ ] Unit tests cover all boundary conditions (daysOverdue = -1, 0, 1, 2, 3, 4, 5, 6)
- [ ] Risk badge animation: High risk badges pulse gently at 2-second intervals; color transitions smooth (300ms ease-in-out)

**Definition of Done**: Risk calculation is a pure function with comprehensive unit tests; Dashboard displays correct risk levels for all boundary conditions.

---

### STORY-020: In-Maintenance Status (FR-11)
**Title**: Set item status to In-Maintenance when being repaired or serviced; exclude from loan dashboard
**Priority**: P1 — Should Have
**Sources**: PRD FR-11, Glossary definition of In-Maintenance
**UX Reference**: DESIGN.md StatusPill in-maintenance variant

**Acceptance Criteria:**
- [ ] Item status can be set to In-Maintenance from Item Detail screen (via dropdown or toggle)
- [ ] Items with status In-Maintenance are excluded from the Dashboard loan list
- [ ] In-Maintenance items appear in Items Catalog with StatusPill showing "In Maintenance" (gray color)
- [ ] An item cannot be loaned while in In-Maintenance status; attempting to create a loan shows warning

**Definition of Done**: User can set and view In-Maintenance status; items correctly excluded from dashboard while in maintenance.

---

### STORY-021: Loan History Timeline
**Title**: Display chronological loan history for each item including past loans, return dates, and condition notes
**Priority**: P1 — Should Have
**Sources**: PRD FR-2 (loan history), EXPERIENCE.md Component Patterns (LoanDetailSheet)
**UX Reference**: DESIGN.md LoanDetailSheet structure

**Acceptance Criteria:**
- [ ] Item Detail bottom sheet includes a "Loan History" section below item photos
- [ ] Loans displayed chronologically (most recent first) as timeline entries
- [ ] Each entry shows: borrower name, due date, return date (if returned), condition notes (if provided), and risk badge at time of loan

**Definition of Done**: User can view complete chronological loan history for any item.

---

### STORY-022: Quick Register via Long-Press FAB (UJ-5)
**Title**: Long-press FAB to choose "Item only" or "Item + Loan"; support on-the-spot registration in under 10 taps
**Priority**: P0 — Must Have
**Sources**: PRD UJ-5, EXPERIENCE.md Flow D Step 2-7
**UX Reference**: DESIGN.md FAB long-press behavior

**Acceptance Criteria:**
- [ ] Single-tap FAB opens RegistrationForm Step 1 (full multi-step flow)
- [ ] Long-press FAB shows popup menu with two options: "Item only" and "Item + Loan"
- [ ] "Item only": registers item without loaning it; skips borrower/due date steps; item created as Available
- [ ] "Item + Loan": opens RegistrationForm Step 1 directly (same as single-tap but pre-selected path)
- [ ] Total taps from app launch to confirmed loan: approximately 8 taps (meets UJ-5 speed requirement)

**Definition of Done**: Long-press FAB menu works; both paths complete successfully within target tap count.

---

## EPIC-05: Dashboard & Risk Ranking

**Goal**: Provide Mary with an at-a-glance view of all active loans ranked by risk, enabling quick identification of urgent items.

### STORY-023: Dashboard Card Swipe Actions
**Title**: Swipe left on dashboard cards to reveal "Send Reminder" and "Mark Returned" quick actions
**Priority**: P0 — Must Have
**Sources**: EXPERIENCE.md Component Patterns (ItemCard swipe), UX Flow B Step 5, Flow C Step 3-4
**UX Reference**: DESIGN.md ItemCard interactions

**Acceptance Criteria:**
- [ ] Swipe left on any Dashboard card reveals two action buttons: "Send Reminder" (outlined, secondary color) and "Mark Returned" (filled, success color)
- [ ] Swipe right dismisses actions and returns card to normal state
- [ ] "Send Reminder" sends a single reminder email to borrower; shows toast "Reminder sent to [Name]" on success
- [ ] "Mark Returned" opens confirmation dialog (same as STORY-017); confirms with haptic double-tap
- [ ] Swipe gesture area is the rightmost 120px of the card

**Definition of Done**: Swipe gestures work correctly on all Dashboard cards; quick actions execute and provide feedback.

---

### STORY-024: High-Risk Urgency Visual Indicators
**Title**: Add subtle red border glow, pulsing risk badge, and FAB pulse for high-risk loans (>5 days overdue)
**Priority**: P1 — Should Have
**Sources**: EXPERIENCE.md State Patterns (High-Risk Urgency), DESIGN.md RiskBadge risk-high animation
**UX Reference**: DESIGN.md RiskBadge pulse-slow animation

**Acceptance Criteria:**
- [ ] Dashboard cards with High risk status get a subtle red border glow ({color.status.danger.main} at 20% opacity)
- [ ] Risk badge on high-risk cards pulses gently every 2 seconds (pulse-slow animation)
- [ ] FAB pulses gently (subtle scale animation, 1s interval) when any loan is High risk — draws attention to action capability
- [ ] All animations are gentle and non-distracting; respect system "reduce motion" preferences

**Definition of Done**: High-risk visual indicators appear correctly; animations respect accessibility preferences.

---

### STORY-025: Dashboard Empty State and Initial Load
**Title**: Display empty state illustration with CTA when no active loans exist; skeleton loading during initial load
**Priority**: P1 — Should Have
**Sources**: EXPERIENCE.md State Patterns (Empty States, Loading States), DESIGN.md EmptyState component
**UX Reference**: DESIGN.md EmptyState

**Acceptance Criteria:**
- [ ] When Dashboard has zero active loans: display EmptyState with simple line-art illustration, title "No items on loan yet", description "Tap the + button to register your first item.", and filled primary CTA button
- [ ] During initial dashboard load (first app launch): show skeleton cards matching ItemCard layout with shimmer effect; no spinner
- [ ] Skeleton cards disappear as data loads from Hive (in-memory cache after first load)
- [ ] Dashboard loads in under 200ms for up to 100 items (exceeds PRD NFR of 2 seconds)

**Definition of Done**: Empty state and loading states render correctly; dashboard performance meets/exceeds NFR.

---

### STORY-026: Dashboard Tab Badge for High Risk
**Title**: Show red dot badge on Dashboard tab when any high-risk loans exist
**Priority**: P1 — Should Have
**Sources**: EXPERIENCE.md Tab Bar Behavior table
**UX Reference**: None (UI convention)

**Acceptance Criteria:**
- [ ] Bottom navigation bar Dashboard tab shows a small red dot badge when one or more active loans have risk level High
- [ ] Badge disappears automatically when all high-risk loans are resolved (returned or risk drops below High)
- [ ] Badge does not appear for Medium or Low risk items — only High triggers the indicator

**Definition of Done**: Red dot badge appears/disappears correctly based on high-risk loan count.

---

## EPIC-06: Email Notifications

**Goal**: Implement email notification subsystem with SMTP configuration, initial loan emails, and overdue reminder scheduling.

### STORY-027: Configure Owner SMTP Settings
**Title**: Set up owner email address and SMTP server credentials in Settings screen
**Priority**: P0 — Must Have
**Sources**: ARCHITECTURE.md AD-4, PRD FR-13 (implied settings), EXPERIENCE.md Information Architecture (Settings surface)
**UX Reference**: DESIGN.md RegistrationForm (settings form pattern)

**Acceptance Criteria:**
- [ ] Settings screen accessible via profile drawer or dedicated nav entry
- [ ] Owner email field: text input with email keyboard, required for notifications to work
- [ ] SMTP configuration section with fields: host (e.g., smtp.gmail.com), port (465 SSL or 587 TLS), username (email address), password (app-specific password)
- [ ] Password stored encrypted using flutter_secure_storage on mobile platforms; plain text in Hive for webapp (IndexedDB limitation)
- [ ] "Test Connection" button attempts to send a test email to owner's configured address
- [ ] Settings saved to Hive `settings` box and flutter_secure_storage

**Definition of Done**: User can configure SMTP settings; connection test succeeds; credentials stored securely.

---

### STORY-028: Send Initial Loan Notification Email
**Title**: Send email to borrower when a new loan is created using loanCreatedTemplate
**Priority**: P0 — Must Have
**Sources**: PRD FR-9, ARCHITECTURE.md Notification Subsystem section, EXPERIENCE.md Flow A Step 10
**UX Reference**: DESIGN.md RegistrationForm confirm action

**Acceptance Criteria:**
- [ ] When a loan is confirmed in RegistrationForm, email sent to borrower's configured address using SmtpEmailSender
- [ ] Email subject: "You have an item on loan from [Owner Name]" (or similar friendly subject)
- [ ] Email body uses loanCreatedTemplate with item name, borrower name, due date formatted as YYYY-MM-DD
- [ ] If SMTP not configured or send fails: error toast shown ("Couldn't send reminder. Check your email settings."); loan still created successfully
- [ ] Failed sends are logged and visible in Settings > Notifications section for retry

**Definition of Done**: Initial loan notification emails send successfully when SMTP configured; graceful degradation when not.

---

### STORY-029: Schedule Daily Overdue Reminder Checks
**Title**: Implement platform-specific scheduler for daily overdue email checks with risk-based escalation
**Priority**: P0 — Must Have
**Sources**: PRD FR-13, FR-14, ARCHITECTURE.md Scheduler Platform Matrix, EXPERIENCE.md Flow E
**UX Reference**: DESIGN.md RiskBadge variants (subject prefixes per risk level)

**Acceptance Criteria:**
- [ ] Android: workmanager plugin schedules daily background task at configurable time (default 9:00 AM local)
- [ ] iOS/macOS: flutter_local_notifications with periodic trigger; in-app banner fallback on next launch if background execution limited
- [ ] Chrome webapp: service worker polling (requires tab open); emails queue in Hive and send when user opens app on device with email capability
- [ ] Daily check queries LoanRepository.getOverdue() for all active loans (isReturned=false, daysOverdue > 0)
- [ ] For each overdue loan, RiskCalculator.calculate(daysOverdue) determines risk level
- [ ] Email subject prefix varies by risk: Low → "Reminder:", Medium → "Overdue:", High → "Urgent:"

**Definition of Done**: Scheduler runs on all platforms with appropriate reliability; overdue emails sent with correct risk-based subject prefixes.

---

### STORY-030: Send Overdue Reminder Emails with Risk Escalation (FR-14)
**Title**: Send escalating reminder emails based on risk level using overdueReminderTemplate
**Priority**: P0 — Must Have
**Sources**: PRD FR-14, ARCHITECTURE.md Email Templates section
**UX Reference**: DESIGN.md RiskBadge variants

**Acceptance Criteria:**
- [ ] Low Risk (2-4 days overdue): email subject "Reminder: [Item] is due [X] days ago"; standard reminder body
- [ ] Medium Risk (5 days overdue): email subject "Overdue: [Item] is 5 days past due"; stronger, more urgent wording
- [ ] High Risk (>5 days overdue): email subject "Urgent: [Item] is [X] days overdue!"; most urgent email with clear call-to-action
- [ ] Both owner and borrower receive the reminder email (owner gets CC or separate notification)
- [ ] Email body uses overdueReminderTemplate with prefix, item name, days overdue
- [ ] Escalation is cumulative: if a loan was Low yesterday and becomes Medium today, only one Medium email sent (no duplicate for previous Low)

**Definition of Done**: Overdue reminder emails send with correct risk-based content; escalation logic prevents duplicates.

---

### STORY-031: Email Send Failure Handling and Retry
**Title**: Queue failed email sends in Hive; display failures in Settings; allow manual retry
**Priority**: P1 — Should Have
**Sources**: ARCHITECTURE.md State Patterns (Offline / Connectivity States), PRD FR-13/14 consequences

**Acceptance Criteria:**
- [ ] Failed email sends logged in Hive `settings` box with timestamp, borrower email, and error message
- [ ] Settings > Notifications section displays pending/failed emails with status indicator
- [ ] Each failed email has a "Retry" button that attempts to resend immediately
- [ ] On next app launch, queued emails are automatically retried (up to 3 attempts per email)

**Definition of Done**: Failed emails queue correctly; retry mechanism works; Settings displays failure status.

---

### STORY-032: Owner Notification Preferences
**Title**: Configure notification interval and choose which risk levels trigger owner notifications
**Priority**: P1 — Should Have
**Sources**: PRD FR-13 (configurable thresholds), ARCHITECTURE.md OQ-3

**Acceptance Criteria:**
- [ ] Settings screen includes "Notification Preferences" section
- [ ] Notification interval selector: Daily (default), Every 2 days, Every 3 days
- [ ] Risk level toggles: Enable notifications for Low risk, Medium risk, High risk (all enabled by default)
- [ ] Changes persist to Hive `settings` box and affect next scheduler run

**Definition of Done**: User can customize notification frequency and risk level triggers; preferences persist.

---

## EPIC-07: Settings & Configuration

### STORY-033: Owner Email Configuration
**Title**: Set and manage the owner's email address used as sender identity in all notifications
**Priority**: P1 — Should Have
**Sources**: ARCHITECTURE.md AD-4, PRD FR-13 (owner notification preferences)

**Acceptance Criteria:**
- [ ] Settings screen includes "Owner Email" field at top; valid email format required before saving
- [ ] Owner email is used as the sender identity in all outgoing emails (From: header)
- [ ] Changing owner email affects only future notifications; past sent emails are not retroactively updated

**Definition of Done**: Owner email configured and used correctly as sender identity.

---

### STORY-034: App Information and About Screen
**Title**: Display app version, privacy statement (local-only, no cloud), and help documentation
**Priority**: P2 — Nice to Have

**Acceptance Criteria:**
- [ ] Settings screen includes "About WhoHasMy" section at bottom with version number and privacy statement
- [ ] Privacy statement: "Your data stays on this device. No accounts, no cloud sync, no tracking."
- [ ] "Help" button opens in-app FAQ covering common questions

**Definition of Done**: About screen displays correctly; help content accessible.

---

### STORY-035: Offline Mode Banner and Behavior
**Title**: Display offline indicator when network unavailable; queue email sends for later delivery
**Priority**: P1 — Should Have
**Sources**: EXPERIENCE.md State Patterns (Offline / Connectivity States), PRD NFR §5.4

**Acceptance Criteria:**
- [ ] Subtle banner at top of screen when device is offline: "Working offline — changes saved locally"
- [ ] All local operations work normally while offline; email sends queue in Hive `settings` box

## Sprint Planning Summary

| Sprint | Epics | Stories | Focus |
|---|---|---|---|
| **Sprint 1** (2 weeks) | EPIC-01 | STORY-001 through STORY-004 | Foundation: Flutter setup, Hive, Riverpod, Theme |
| **Sprint 2** (2 weeks) | EPIC-02 + EPIC-03 | STORY-005 through STORY-015 | Item Management + Contact Management core |
| **Sprint 3** (2 weeks) | EPIC-04 | STORY-016 through STORY-022 | Loan Tracking: create loans, mark returns, dashboard display |
| **Sprint 4** (2 weeks) | EPIC-05 + EPIC-07 | STORY-023 through STORY-026, STORY-033 through STORY-035 | Dashboard polish + Settings |
| **Sprint 5** (2 weeks) | EPIC-06 | STORY-027 through STORY-032 | Email Notifications: SMTP config, initial emails, overdue reminders |

**Total**: 5 sprints for v1 MVP. STORY-034 (P2) can be deferred to post-v1.

---

## Open Questions — Resolved

| # | Question | Impacted Stories | Resolution | Status |
|---|----------|------------------|------------|--------|
| OQ-1 | Should the default due date be 14 days or configurable per-item? | STORY-016 | **Resolved:** Default is today + 14 days (confirmed by UX spec, EXPERIENCE.md §RegistrationForm). Quick-select chips for "3 days", "1 week", "2 weeks", "1 month" are provided. Custom date always available. Per-item default configurability deferred to Settings in a future iteration. | ✅ Resolved |
| OQ-2 | What happens when a borrower's email bounces? | STORY-028, STORY-031 | **Resolved:** Email send status is recorded on the loan record (per PRD FR-9). Failed sends are logged; owner sees a warning banner on dashboard load if any active loans have failed. Owner can retry or update borrower's email. No complex retry queue needed in v1 — simple log-and-warn approach. | ✅ Resolved |
| OQ-3 | Should borrowers receive a "loan created" confirmation vs. just the reminder? | STORY-028 | **Resolved:** Yes — the initial loan email serves as both notification AND confirmation (per PRD FR-9: "System sends a notification email to the contact with loan details"). Email includes item name, borrower name, and due date, which confirms the loan was created. This is the current design. | ✅ Resolved |

---

*This document slices PRD requirements, UX flows, and architecture decisions into actionable user stories organized by epic. Each story references its source FR/UJ/AD for traceability. Stories are ready for development sprint planning.*