---
title: WhoHasMy
created: 2026-10-21
updated: 2026-10-27
status: draft
---

# PRD: WhoHasMy

## 0. Document Purpose

This PRD defines the requirements for **WhoHasMy**, a cross-platform lending tracker that helps a single user track items they've loaned to friends, family, or colleagues. It is scoped for a hobby/solo product with no monetization. Downstream workflows (architecture, development, UX) should reference this document as the source of truth for functional and non-functional requirements.

## 1. Vision

**WhoHasMy** solves a simple but frustrating problem: you loan something out and forget who has it, only to discover it when you need it — or worse, when you've already re-purchased a replacement.

The app lets you register items, loan them to contacts, set due dates, and receive proactive notifications when items are approaching or past their due date. A risk-ranked dashboard surfaces the most urgent loans at a glance. The borrower never installs anything — they simply receive email alerts from the app.

This is a personal tool, built for one user, on one device. No accounts, no cloud sync, no complexity. Just a reliable way to remember who has your stuff.

## 2. Target User

### 2.1 Jobs To Be Done

- **Functional:** Track what I've loaned, to whom, and when it's due.
- **Emotional:** Stop the frustration of forgetting and having to re-buy things.
- **Contextual:** Works on whatever device I'm using — phone, tablet, desktop, or browser.

### 2.2 Key User Journeys

**UJ-1. Mary registers an item and loans it out.**
Mary picks up a power drill she wants to lend to a neighbor. She opens WhoHasMy, registers the drill (name, description, photo, category: Tools), adds the neighbor as a contact, sets a due date, and loans it. The neighbor receives an email with loan details.

**UJ-2. Mary checks her loan dashboard.**
Mary opens the app and sees a ranked list of all items currently on loan, sorted by risk (highest risk first). She sees which items are overdue, which are approaching their due date, and which are fine.

**UJ-3. Mary receives a notification about an approaching or overdue loan.**
The app sends an email to both Mary and the borrower when a loan is approaching or past its due date. Higher-risk loans trigger stronger/more urgent emails.

**UJ-4. Mary returns an item.**
The borrower brings the drill back. Mary taps "Returned," verifies the condition (photos stay with the item's history), and the item goes back to "Available."

**UJ-5. Mary registers an item on the spot when a borrower asks.**
A friend asks to borrow Mary's leaf blower. Mary opens the app, quickly registers the item and the friend (address book import or manual entry), sets a due date, and loans it — all in one session.

## 3. Glossary

- **Item** — A physical object registered in the app. Has a name, description, optional image, category, and condition. Can be in one of three statuses: *Available*, *Loaned*, or *In-Maintenance*.
- **Contact** — A person who can receive items. Created via address book import or manual entry. Has a name and contact info (email, phone) for notifications.
- **Loan** — A record linking an Item to a Contact with a due date. A loan is active from the moment it is created until the owner confirms the item has been returned.
- **Status** — One of three states for any Item: *Available* (not loaned), *Loaned* (currently out), or *In-Maintenance* (being repaired or serviced).
- **Risk Level** — A derived state for active loans: *None* (not overdue), *Low* (2 days overdue), *Medium* (5 days overdue), or *High* (more than 5 days overdue). Risk drives notification intensity.
- **Dashboard** — A list view of all items currently on loan, ranked by risk from highest to lowest.

## 4. Features

### 4.1 Item Management

**Description:** Mary can register, view, edit, and manage physical items. Each item has a name, description, optional image, category, and condition. Default categories are provided (Tools, Books, Electronics, Clothing, Sports Equipment, etc.) but Mary can add custom categories.

**Functional Requirements:**

#### FR-1: Register an Item

Mary can register a new item by providing a name, description, category, and optionally a photo. The item is created with status *Available*.

**Consequences (testable):**
- System creates a new Item record with status = *Available*.
- System assigns one of the default categories or a user-defined custom category.
- System stores an optional photo with the item record.

#### FR-2: View Item Details

Mary can view the full details of any registered item, including its current status, loan history, and any photos.

**Consequences (testable):**
- System displays all item fields: name, description, category, condition, photo(s).
- System shows the complete loan history for the item (all past and active loans).

#### FR-3: Edit Item Details

Mary can update an item's name, description, category, condition, or photo at any time.

**Consequences (testable):**
- System updates the item record in local storage.
- Changes to an item while it is on loan do not affect the loan record.

#### FR-4: Delete an Item

Mary can delete a registered item. If the item is currently on loan, Mary must confirm deletion (the active loan is preserved but the item is removed from the catalog).

**Consequences (testable):**
- System removes the item from the catalog if it has no active loans.
- System preserves active loan records when deleting an item that is currently loaned.
- Active loans for deleted items remain on the dashboard until returned, displayed with the item name captured at loan-creation time and marked "[deleted item]".
- Active loans for deleted items are excluded from borrower notifications (the item no longer exists to reference); owner notifications continue.

#### FR-5: Default Categories

The app ships with a set of default categories based on typical household inventory items (Tools, Books, Electronics, Clothing, Sports Equipment, Furniture, Kitchen, Outdoor/Garden, Music, Other).

**Consequences (testable):**
- System provides exactly the 10 default categories listed above on first launch.
- Mary can create additional custom categories.

### 4.2 Contact Management

**Description:** Mary can manage contacts — people to whom she loans items. Contacts are created via address book import or manual entry. Each contact has a name and contact information (email, phone number) used for notifications.

**Functional Requirements:**

#### FR-6: Import Contacts from Address Book

Mary can import contacts from her device's address book. On the Chrome webapp target, which has no device address book API, this action is hidden and manual entry is the only path.

**Consequences (testable):**
- System requests permission to access the device address book (Android, iOS, macOS only).
- System imports available contacts with name and contact information.
- On permission denial, the system shows a manual-entry fallback and a path to re-request permission.
- On the web target, the import action is not shown.

#### FR-7: Manually Add a Contact

Mary can manually create a new contact with a name, email address, and/or phone number.

**Consequences (testable):**
- System creates a new Contact record.
- System validates that at least an email or phone number is provided.
- System warns when a contact has no email address that the contact cannot receive borrower notifications in v1 (email-only delivery; see FR-15).

#### FR-8: Edit and Delete Contacts

Mary can edit a contact's details or delete a contact.

**Consequences (testable):**
- System updates or removes the contact from local storage.
- Deleting a contact does not delete associated loan records (loans are preserved for history).
- Deleting a contact with active loans requires confirmation.
- Active loans retain a snapshot of borrower name and email captured at loan-creation time, so notifications and history survive contact deletion.

### 4.3 Loan Management

**Description:** Mary can loan an available item to a contact, set a due date, and track the loan's status. When the item is returned, Mary confirms the return and the item goes back to *Available*.

**Functional Requirements:**

#### FR-9: Create a Loan

Mary can loan an available item to a contact by selecting the item, selecting (or creating) a contact, and setting a due date.

**Consequences (testable):**
- System changes the item's status to *Loaned*.
- System creates a Loan record linking the Item, Contact, and due date.
- System sends a notification email to the contact with loan details.
- System blocks loan creation for items that are not in *Available* status (i.e., *Loaned* or *In-Maintenance*).
- System rejects due dates in the past (or requires explicit confirmation for past dates).
- System creates the loan only after item and contact validate; on failure the flow aborts without persisting a partial item.
- System optionally attaches condition photos to the loan at creation.
- System records the email send status on the loan (sent/failed).

#### FR-9b: Edit a Loan

Mary can edit the due date of an active loan, or cancel an active loan (returning the item to *Available* without a return date).

**Consequences (testable):**
- System updates the loan's due date and recomputes risk level.
- System sends a borrower notification email with the new due date.
- System cancels the loan and restores the item's status to *Available*.

#### FR-9c: Cancel a Loan

Mary can cancel an active loan without a return, restoring the item to *Available*.

**Consequences (testable):**
- System marks the loan as cancelled and restores the item status to *Available*.
- System does not record a return date for a cancelled loan.

#### FR-10: Confirm a Return

Mary can mark a loan as returned. She verifies the item's condition (photos from the loan stay with the item's history), and the item's status changes to *Available*.

**Consequences (testable):**
- System marks the loan as completed with a return date.
- System changes the item's status to *Available*.
- System retains the loan record and photos in the item's loan history.
- System allows Mary to optionally attach condition photos when confirming a return; both loan-out and return photos are stored on the loan record.

#### FR-11: Set Item to In-Maintenance

Mary can set an item to *In-Maintenance* status (e.g., being repaired, serviced, or otherwise unavailable).

**Consequences (testable):**
- System changes the item's status to *In-Maintenance*.
- System does not allow creating a new loan for an item in *In-Maintenance* status.
- System does not allow setting an item to *In-Maintenance* while it has an active loan (the loan must be returned or cancelled first).
- System provides a return-to-*Available* action from *In-Maintenance*, restoring the status to *Available*.

#### FR-12: Register Item On-the-Spot

When a borrower asks to borrow something, Mary can quickly register a new item and loan it in a single flow without first registering the item separately.

**Consequences (testable):**
- System provides a combined "Register & Loan" flow.
- System creates the item and loan record in one session.

### 4.4 Notifications

**Description:** The app sends proactive notifications to both Mary (the owner) and the borrower via email when a loan is approaching or past its due date. Higher risk levels trigger stronger/more urgent emails. SMS notifications are deferred to a future iteration.

**Functional Requirements:**

#### FR-13: Approaching-Due Notification

The system sends a notification email to both the owner and the borrower when a loan is approaching its due date (configurable threshold, default: 2 days before due date).

**Consequences (testable):**
- System sends an email to the owner's configured email address.
- System sends an email to the borrower's email address (from the contact record).
- Email includes item name, borrower name, and due date.

#### FR-14: Overdue Notification with Risk Escalation

The system sends escalating notifications based on risk level:

- **Low Risk (2 days overdue):** Standard reminder email to both parties.
- **Medium Risk (5 days overdue):** Stronger/more urgent email to both parties.
- **High Risk (>5 days overdue):** Most urgent email to both parties, possibly with additional follow-up.

**Consequences (testable):**
- System sends the appropriate email based on the loan's current risk level.
- Email content and urgency scale with risk level (Low < Medium < High).
- System sends notifications at configurable intervals (default: daily for overdue loans).

#### FR-15: Optional SMS Notifications — *Deferred*

SMS notifications are deferred to a future iteration. Email-only delivery is the v1 default. Phone numbers may be stored on contacts for future use but trigger no notifications in v1.

### 4.5 Dashboard

**Description:** Mary sees a list of all items currently on loan, ranked by risk from highest to lowest. This gives her an at-a-glance view of which loans need attention.

**Functional Requirements:**

#### FR-16: Risk-Ranked Loan Dashboard

The dashboard displays all active loans sorted by risk level (High → Medium → Low → None).

**Consequences (testable):**
- System calculates risk level for each active loan based on days overdue.
- System displays loans in descending risk order.
- System shows item name, borrower name, due date, and risk level for each loan.

#### FR-17: Risk Thresholds

Risk levels are determined by days overdue:

- **None:** Not overdue (due date is in the future or today).
- **Low:** 2 days overdue.
- **Medium:** 5 days overdue.
- **High:** More than 5 days overdue.

**Consequences (testable):**
- System correctly calculates and assigns risk levels based on current date vs. due date.
- System updates risk levels in real time as loans age.

## 5. Non-Functional Requirements

### 5.1 Platform

- **Cross-platform:** Single Flutter codebase targeting Android, iOS, macOS, and Chrome webapp.
- **Form factor:** Mobile-first design, responsive for tablet and desktop views.

### 5.2 Data

- **Storage:** Local device storage only (no cloud, no accounts, no sync).
- **Scale:** Supports up to ~100 items per user with associated loans and contacts.
- **Performance:** Dashboard loads in under 2 seconds with 100 items.

### 5.3 Privacy

- **No privacy constraints:** Single-user, local storage. No data leaves the device except notification emails/SMS.

### 5.4 Reliability

- Notifications must be sent reliably when due dates are reached.
- Local data must persist across app restarts.

## 6. Success Metrics

- **Primary:** Mary remembers who has her stuff without having to re-purchase items.
- **Secondary:** Mary uses the app within 3 taps of opening it for common actions (register, loan, check dashboard).
- **Counter-metric:** No user complaints about notification delivery (email).

## 7. Out of Scope (v1)

- Borrower mobile app or borrower account.
- Cloud sync or multi-device support.
- User accounts or authentication.
- Monetization (subscription, ads, in-app purchases).
- Social features (sharing catalogs, public listings).
- Barcode/QR scanning for item registration.
- Integration with external services beyond email/SMS.
