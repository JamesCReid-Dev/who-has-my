---
title: WhoHasMy — Visual Design System
created: 2026-10-27
updated: 2026-10-27
status: draft
---

# DESIGN.md: WhoHasMy

## Brand & Style

### Brand Personality
WhoHasMy is **friendly, practical, and quietly reliable** — like a well-organized notebook that lives in your pocket. It should feel approachable enough to use without hesitation when you're handing something over on the spot, yet serious enough that users trust it with their most overdue reminders.

### Visual Tone
- **Approachable**: Warm accents soften the data-heavy dashboard
- **Calm under pressure**: Even high-risk items don't scream — they pulse gently and provide clear context
- **Efficient**: Every pixel serves a purpose; no decorative elements that don't aid comprehension
- **Trustworthy**: Consistent, predictable interactions build confidence over time

### Anti-patterns (what we are NOT)
- Not corporate or sterile — this is personal, not enterprise
- Not playful or gamified — items on loan matter to people, but the app doesn't treat it like a game
- Not cluttered — maximum 100 items means density must be earned, not assumed

---

## Colors

### Design Tokens

```yaml
color:
  primary:
    main: "#1565C0"       # Deep blue — trust, reliability
    light: "#42A5F5"      # Lighter blue for hover/focus states
    dark: "#0D47A1"       # Darker blue for active/pressed states
    contrast: "#FFFFFF"   # Text on primary backgrounds

  secondary:
    main: "#FFA726"       # Warm amber — approachable energy, CTAs
    light: "#FFB74D"      # Lighter amber for subtle highlights
    dark: "#F57C00"       # Darker amber for emphasis
    contrast: "#212121"   # Text on secondary backgrounds

  status:
    success:
      main: "#43A047"     # Green — available items, on-time loans
      light: "#66BB6A"
      dark: "#2E7D32"
      contrast: "#FFFFFF"
    warning:
      main: "#FB8C00"     # Amber — approaching due date (1-2 days)
      light: "#FFA726"
      dark: "#EF6C00"
      contrast: "#FFFFFF"
    danger:
      main: "#E53935"     # Red — overdue, high risk
      light: "#EF5350"
      dark: "#C62828"
      contrast: "#FFFFFF"
    neutral:
      main: "#757575"     # Gray — inactive items, maintenance
      light: "#9E9E9E"
      dark: "#616161"
      contrast: "#FFFFFF"

  semantic:
    risk_none: "#43A047"   # On time / not overdue (green)
    risk_low: "#FB8C00"    # 2-4 days overdue (amber)
    risk_medium: "#FF7043" # 5 days overdue (orange-red)
    risk_high: "#E53935"   # >5 days overdue (red)

  neutral:
    surface:
      light: "#F5F5F5"     # Light mode background
      dark: "#121212"      # Dark mode background
    on-surface:
      light: "#212121"     # Light mode text
      dark: "#EEEEEE"      # Dark mode text
    divider:
      light: "#E0E0E0"     # Light mode borders/dividers
      dark: "#333333"      # Dark mode borders/dividers
    overlay:
      light: "rgba(0, 0, 0, 0.5)"   # Light mode dialogs/backdrops
      dark: "rgba(0, 0, 0, 0.7)"    # Dark mode dialogs/backdrops

  support:
    primary_fixed: "#D3E3FD"
    on-primary-fixed: "#041E49"
    secondary-container: "#FFECDF"
    on-secondary-container: "#412E07"
    success-container: "#C8F6C5"
    on-success-container: "#053B0A"
    danger-container: "#FFDAD6"
    on-danger-container: "#690005"
```

### Color Usage Rules
1. **Status colors are never used alone** — always paired with an icon or text label for colorblind accessibility
2. **Risk levels use the semantic palette** (`risk_none`, `risk_low`, `risk_medium`, `risk_high`) exclusively on dashboard cards and loan indicators
3. **Primary color** is reserved for: FAB, primary buttons, active navigation items, link text
4. **Secondary color** is used for: secondary CTAs, accent highlights, empty state illustrations
5. **Dark mode**: All surface colors invert; semantic/status colors maintain the same hue but adjust lightness for contrast compliance

### Contrast Compliance
All color combinations meet WCAG 2.1 AA minimums (4.5:1 for normal text, 3:1 for large text and UI components). Support tokens provide fixed-contrast pairs for critical information surfaces.

---

## Typography

### Font Family
```yaml
typography:
  font-family:
    primary: "Inter"           # Google Fonts — clean, highly legible at small sizes
    fallback:
      - system-ui

## Layout & Spacing

### Spacing Scale
```yaml
spacing:
  base-unit: 4px              # All spacing is a multiple of this
  xs: 4px                     # Tightest gaps (between icon and text)
  sm: 8px                     # Standard small gap (list item padding)
  md: 12px                    # Medium gap (card internal padding)
  lg: 16px                    # Standard padding (screen edge, card margins)
  xl: 20px                    # Large gaps (section separators)
  xxl: 24px                   # Very large gaps (modal content padding)
  xxxl: 32px                  # Maximum spacing (hero sections, onboarding)
```

### Layout Principles
1. **Mobile-first**: Default layout targets 375×812pt (iPhone 13/14 size); all wider layouts are expansions
2. **Edge padding**: 16px on phone screens; increases to 24px on tablet, 32px on desktop
3. **Card margins**: 8px between cards in lists; 16px from screen edges
4. **Content density**: Prioritize readability over information density — users scan the dashboard quickly under mild stress

### Responsive Breakpoints
```yaml
breakpoints:
  phone:    { min: 0,    max: 599,  label: "Mobile" }
  tablet:   { min: 600, max: 1023, label: "Tablet" }
  desktop:  { min: 1024, max: null, label: "Desktop" }
```

---

## Elevation & Depth

### Material 3 Elevation (Light Mode)

| Level | Shadow | Usage |
|---|---|---|
| `elevation.level0` | None | Default surface background |
| `elevation.level1` | `0px 1px 2px rgba(0,0,0,0.1), 0px 1px 3px 1px rgba(0,0,0,0.08)` | Bottom sheets, simple cards |
| `elevation.level2` | `0px 1px 2px rgba(0,0,0,0.1), 0px 2px 6px 2px rgba(0,0,0,0.08)` | Dialogs, FAB |
| `elevation.level3` | `0px 4px 8px 3px rgba(0,0,0,0.08), 0px 1px 3px 0px rgba(0,0,0,0.1)` | High-priority overlays |

### Dark Mode Elevation
Dark mode uses surface tint overlay instead of (or in addition to) shadow for elevation indication:
- Level 1: `rgba(255,255,255,0.04)` tint on surface
- Level 2: `rgba(255,255,255,0.08)` tint on surface
- Level 3: `rgba(255,255,255,0.12)` tint on surface

---

## Shapes

### Corner Radius
```yaml
rounded:
  none: 0px           # Rarely used; only for specific data table cells
  sm: 4px             # Small badges, tight input fields
  md: 8px             # Buttons, text inputs, chips
  lg: 12px            # Cards, list items, dropdown menus
  xl: 16px            # Dialogs, bottom sheets, modals
  full: 9999px        # Circular elements (avatars, FAB, progress indicators)
```

### Shape Rules
1. **Dashboard cards**: `rounded.lg` (12px) — distinct but not overly soft
2. **Buttons and inputs**: `rounded.md` (8px) — standard Material 3 feel
3. **FAB**: `rounded.full` (circular) — iconic, recognizable primary action
4. **Dialogs and sheets**: `rounded.xl` (16px) — softer edges for overlay surfaces
5. **Risk badges**: `rounded.sm` (4px) with `label.medium` text — compact, scannable

---
      - "-apple-system"
      - "BlinkMacSystemFont"
      - "'Segoe UI'"
      - "Roboto"
      - "'Helvetica Neue'"
      - "Arial"
      - "sans-serif"
```

### Type Scale (Material 3 aligned)

| Token | Size (sp) | Weight | Line Height | Usage |
|---|---|---|---|---|
| `headline.large` | 32sp | 400 | 40px | Screen titles (rare in this app) |
| `title.large` | 22sp | 500 | 28px | Dialog titles, sheet headers, item names on cards |
| `title.medium` | 16sp | 500 | 24px | Card titles (item names), section headers |
| `body.large` | 16sp | 400 | 24px | Body text, descriptions, borrower names |
| `body.medium` | 14sp | 400 | 20px | Secondary text, metadata, email previews |
| `label.large` | 14sp | 500 | 20px | Button text, form labels |
| `label.medium` | 12sp | 500 | 16px | Badge text, timestamps, small labels |

### Typography Rules
1. **Item names** use `title.large` (22sp/500) on dashboard cards — they are the primary identifier
2. **Borrower names** use `body.large` (16sp/400) — secondary but still important
3. **Due dates and risk text** use `label.medium` (12sp/500) with status color
4. **Dynamic type**: All sizes scale proportionally with system font settings up to 200% maximum
5. **Never use more than two weights on a single screen** — hierarchy through size, not weight stacking

---

## Components

### RiskBadge
```yaml
component: RiskBadge
variants:
  - name: risk-none
    background: color.status.success.main
    foreground: color.status.success.contrast
    icon: check-circle-outline
    label: "On time"
  - name: risk-low
    background: color.status.warning.main
    foreground: color.status.warning.contrast
    icon: alert-outline
    label: "{days}d overdue"
  - name: risk-medium
    background: color.semantic.risk_medium
    foreground: "#FFFFFF"
    icon: alert-circle-outline
    label: "{days}d overdue"
  - name: risk-high
    background: color.status.danger.main
    foreground: color.status.danger.contrast
    icon: alert-octagon-outline
    label: "{days}d overdue"
    animation: pulse-slow (2s interval)
size:
  default: { width: auto, height: 24px, padding: { horizontal: 8px, vertical: 0 } }
  compact: { width: auto, height: 20px, padding: { horizontal: 6px, vertical: 0 } }
```

### StatusPill
```yaml
component: StatusPill
variants:
  - name: available
    background: color.status.success.main
    foreground: color.status.success.contrast
    label: "Available"
  - name: loaned
    background: color.primary.main
    foreground: color.primary.contrast
    label: "Loaned"
  - name: in-maintenance
    background: color.status.neutral.main
    foreground: color.status.neutral.contrast
    label: "In Maintenance"
size: { height: 20px, padding: { horizontal: 8px }, border-radius: rounded.full }
```

### ContactChip
```yaml
component: ContactChip
layout: horizontal-row
structure:
  - child: AvatarCircle            # Initials or photo thumbnail
    size: 36px
    margin-right: spacing.sm
  - child: ContactName             # title.medium weight
    flex: 1
  - child: ContactEmailPreview     # body.medium, truncated with ellipsis
    max-lines: 1
interactions:
  tap: open ContactDetailSheet
```

### ItemCard (Dashboard)
```yaml
component: ItemCard
layout: vertical-stack
padding: spacing.md
border-radius: rounded.lg
elevation: elevation.level1
structure:
  - row:
      - child: StatusPill          # Left-aligned, small
        flex: 0
      - child: Spacer              # Pushes right content to edge
      - child: RiskBadge           # Right-aligned
        flex: 0
    height: auto
  - child: ItemName                # title.large weight
    margin-top: spacing.sm
  - child: BorrowerName            # body.medium color
    margin-top: spacing.xs
  - child: DueDate                 # label.medium + status color
    margin-top: spacing.xs
    alignment: right
interactions:
  tap: open LoanDetailSheet
  swipe-left: quick-actions (Send reminder, Mark returned)
  long-press: context-menu (Edit, Delete loan, View item history)
```

### EmptyState
```yaml
component: EmptyState
illustration: simple-line-art            # Placeholder icon (e.g., open box or clipboard)
title: "No items on loan yet"            # headline.medium weight, neutral color
description: "Tap the + button to register your first item."  # body.medium
primary-action:
  label: "Register an Item"
  style: filled-button                   # primary color background
  icon: plus-circle
```

### FAB (Floating Action Button)
```yaml
component: FAB
size: standard                           # 56px diameter
shape: rounded.full                      # circular
icon: plus-circle                        # primary color foreground
background: color.primary.main           # with elevation.level2 shadow
position: bottom-right                   # 16px from each edge on phone
behavior:
  tap: open RegistrationForm (step 1)
  long-press: quick-register-menu        # "Item only" / "Item + Loan" options
```

---

### RegistrationForm
```yaml
component: RegistrationForm
type: multi-step progressive
steps:
  - name: item-basic
    fields:
      - name: itemName
        type: text-input
        label: "Item name"
        required: true
        placeholder: "e.g., DeWalt 20V Drill"
      - name: category
        type: segmented-button-group
        options: [Tools, Electronics, Books, Sports, Other]
        required: false
    actions: [Cancel, Next]
  - name: item-details
    fields:
      - name: description
        type: text-area
        label: "Description (optional)"
        max-length: 500
      - name: photo
        type: image-picker
        label: "Photo (optional)"
        max-images: 3
    actions: [Back, Next]
  - name: loan-info
    fields:
      - name: borrower
        type: contact-selector
        label: "Borrower"
        required: true
        search-enabled: true
        recent-first: true
      - name: dueDate
        type: date-picker
        label: "Due date"
        required: true
        default: today + 14 days
        min-date: today
    actions: [Back, Confirm Loan]
behavior:
  auto-save-draft: true
  validation: inline (on field blur)
  error-display: inline below field in color.status.danger.main
```

### LoanDetailSheet (Bottom Sheet)
```yaml
component: LoanDetailSheet
type: modal-bottom-sheet
border-radius-top: rounded.xl
elevation: elevation.level2
structure:
  - child: DragHandle                    # Centered, sm width
    margin-vertical: spacing.sm
  - child: ItemName                      # title.large weight
  - child: BorrowerInfo                  # ContactChip style
    margin-top: spacing.md
  - child: Divider                       # neutral.divider
    margin-vertical: spacing.md
  - child: LoanDetails                   # Two-column key-value list
      - key: "Due date"
        value: formatted-date            # status color if overdue
      - key: "Days overdue"
        value: numeric + risk badge
      - key: "Loan created"
        value: relative-time             # "3 days ago"
  - child: Divider
    margin-vertical: spacing.md
  - child: PhotoGallery                  # Horizontal scroll, if photos exist
  - child: Divider
    margin-vertical: spacing.md
  - child: ActionButtons                 # Stacked full-width buttons
      - label: "Send Reminder"           # outlined-button (secondary)
      - label: "Mark Returned"           # filled-button (success color)
```

---

## Do's and Don'ts

### Do
- **Use status color consistently** — green = good, amber = caution, red = urgent. Never deviate from this mapping.
- **Show risk context in plain text** — "7 days overdue" is more actionable than a red badge alone.
- **Keep the dashboard scannable** — users should identify high-risk items within 2 seconds of opening the app.
- **Provide haptic feedback on confirmations** — subtle tap for success, double-tap for "Mark Returned."
- **Use progressive disclosure in forms** — show only what's needed at each step; photos and descriptions are optional.
- **Animate risk changes gently** — when a loan escalates from Low to Medium, the badge color should transition smoothly (300ms ease).

### Don't
- **Don't use red for anything other than overdue/high-risk** — reserving red for its semantic meaning preserves urgency signaling.
- **Don't bury primary actions** — "Mark Returned" and "Send Reminder" must be one tap away from the dashboard card.
- **Don't overload cards with information** — show item name, borrower, due date, risk badge. Everything else is in the detail sheet.
- **Don't use decorative animations** — every animation should communicate state change or provide feedback; no purely aesthetic motion.
- **Don't assume perfect network connectivity** — the app works fully offline; never show a "network error" for local operations.
- **Don't use plural/singular inconsistently** — always match grammar: "1 day overdue" vs "2 days overdue."

---

*This DESIGN.md defines the visual identity tokens and component specifications for WhoHasMy. EXPERIENCE.md (cross-referenced by `{path.to.token}` syntax) defines how these components behave, interact, and flow through the application.*