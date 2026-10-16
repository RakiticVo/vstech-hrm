# VSTECH HRM Mobile — Phase 0 Demo Scope

**Focus areas:** Shifts · Check-in/out · Leave · Public holidays · Overtime · Extra hours & comp-off · Off-site work (On Duty / Business Trip)
**Platform:** Employee Mobile App (Flutter, Android & iOS)
**Roles in demo:** Employee (ESS) and Manager (MSS). The Executive (BGĐ) role is out of scope for Phase 0.
**Date:** 25/09/2026

---

## 1. Purpose

This document defines the feature set for the Phase 0 demo build. The demo shows the full time-and-attendance lifecycle end to end:

1. An employee sees their shift.
2. The employee checks in and out, including offline check-in.
3. The employee files leave, overtime, correction, shift-swap and off-site requests.
4. A manager approves or rejects those requests.
5. The results appear back on the employee's timesheet, shift calendar and notifications.

Scope was selected by reusing what is already built in the Flutter app as far as possible. New work is limited to the gaps that break the storyline.

## 2. Sources

| Code | Source |
|---|---|
| **Spec #** | *Danh sách chức năng HRM theo ưu tiên v2 (BGĐ)*: 71 functions, P0/P1/P2 |
| **App #** | *VSTECH HRM: Báo cáo danh sách chức năng ứng dụng* (22/09/2026): 38 functions built, 21/21 tests passed |
| **Flow** | Process-flow artifact *"Quy trình theo chức năng"* (V-STech HRM): Attendance, Calendar & holidays, Shifts & swap, Leave, Overtime, Correction, Manager approval, Device security |

## 3. Scope interpretation

| Term | Meaning in this document |
|---|---|
| **Overtime (Tăng ca)** | A request to work extra hours beyond, or outside, the scheduled shift. The pay rate is applied automatically. |
| **Extra hours (Làm thêm)** | The accumulated balance of approved overtime hours. The employee chooses to be paid for them or to convert them into compensatory leave (comp-off). |
| **Off-site work (Công đi)** | Work performed away from the assigned workplace: short client visits or errands (On Duty) and multi-day trips (Business Trip). Both are credited as worked time. |

## 4. Summary

| Group | Functions | Existing | Enhance | New |
|---|---|---|---|---|
| A. Shifts | 3 | 2 | 1 | – |
| B. Check-in/out | 4 | 3 | – | 1 |
| C. Timesheet & holidays | 3 | 3 | – | – |
| D. Leave | 3 | 2 | 1 | – |
| E. Overtime & extra hours | 3 | 2 | – | 1 |
| F. Off-site work | 2 | – | – | 2 |
| G. Shared framework | 4 | 4 | – | – |
| **Total** | **22** | **16** | **2** | **4** |

Status legend:

- **Existing:** already built. Only minor adjustments are needed for the demo.
- **Enhance:** partially built. The work needed is significant.
- **New:** not built yet.

---

## 5. Feature details

### A. Shifts

#### A1. Today's Shift Card (Home)
- **Source:** Spec 20 · App 06 · Flow *Shifts* (s1)
- **Status:** Existing
- **Description:** The Home screen shows today's shift name, start and end time, hours worked so far and a progress ring.
- **Demo work:** Tapping the card opens the Shift Calendar (A2).
- **Acceptance criteria:**
  - On a day with no shift, the card shows "Day off" and the check-in button is hidden.
  - The card updates immediately after a shift swap is approved.

#### A2. Shift Calendar (Week & Month)
- **Source:** Spec 8 · App 18, 20 · Flow *Shifts* (s2, s9–s11)
- **Status:** Existing
- **Description:**
  - A 7-day capsule strip plus a month-grid dialog.
  - Shift types: Morning, Afternoon, Split, Office hours, Night, Weekly off. Each type has its own color and a legend.
  - Shift detail shows name, start and end, break time and assigned branch.
- **Demo work:** Add three view states:
  - **Loading.**
  - **Network error**, with a Retry button.
  - **Month not yet published**, with the message "Next month's schedule is published on the 25th".

#### A3. Shift Swap
- **Source:** Spec 31 (P1) · App 19 · Flow *Shifts* (s3–s8, s12, s13)
- **Status:** Enhance. The employee side exists; the manager side and validation are missing.
- **Description:** The employee picks an upcoming day and a colleague to swap with, adds a reason and submits.
- **Demo work:**
  - **Eligibility checks before submit:**
    - The colleague is at the same branch and the same grade.
    - Neither person is on leave that day.
    - The two people are not on the same shift.
    - The minimum rest period between shifts is respected (see §8).
    - The swap does not push either person over 48 normal hours per week.
  - **Conflict state:** if a check fails, show the reason and block submission.
  - **Approval:** the request appears in the Manager Approval Inbox (G3) as type *Shift Swap*. The manager's approval is final; no HR or Executive step follows.
  - **After approval:** both employees' calendars update, and the swapped day is labelled "Swapped".
- **Acceptance criteria:**
  - A rejection must include a reason.
  - The employee is notified of the result.

---

### B. Check-in / Check-out

#### B1. AI Face Check-in with Triple-Layer Verification
- **Source:** Spec 3 · App 12 · Flow *Attendance* (a3–a8)
- **Status:** Existing
- **Description:** The three verification layers are:
  1. Face recognition with liveness detection.
  2. GPS geofence around the workplace.
  3. The office Wi-Fi BSSID.

  An oval camera frame and a step-by-step progress bar are shown during verification.
- **Demo work:** The result screen must classify each punch:
  - **On time:** check-in at or before the grace threshold, e.g. 08:05.
  - **Late:** check-in after the threshold, e.g. 08:12.
  - **Early leave:** check-out before the shift end.
  - Include sound and haptic feedback on the result.

#### B2. Offline Check-in Queue & Sync
- **Source:** Spec 4 · App 13, 14 · Flow *Attendance* (a10–a12)
- **Status:** Existing
- **Description:**
  - When there is no network, the face is matched on the device: a 128-D vector compared by cosine similarity, at 85% or higher.
  - The punch is stored in a secure local queue with a timestamp hash and a device ID.
  - A banner shows how many punches are unsynced, with a "Sync now" button.
  - The queue also syncs automatically when the connection returns.
- **Demo work:** No change needed. Confirm the maximum offline retention period (the Flow says 72 hours).

#### B3. Device Binding & Anti-fraud Block
- **Source:** Spec 25 · Flow *Device security* (d1–d8), *Attendance* (a9)
- **Status:** **New.** The app currently has only Face ID / fingerprint login.
- **Description:**
  - One account may check in only from one registered device.
  - Check-in is blocked on rooted or jailbroken devices and when mock GPS is detected.
- **Demo work:**
  - **"Registered device" screen** in Settings: device name, registration date, and the status of 4 checks (registered device, not rooted, no mock GPS, app integrity).
  - **Block screens:**
    - "Root detected: contact HR".
    - "Mock location detected: turn off the location spoofing app, then Re-check".
  - **Empty state:** "This device is not registered", with a "Register this device" button.
  - For the demo, these states can be triggered by a hidden demo toggle. Real root and mock-GPS detection can follow later.
- **Acceptance criteria:** Every blocked attempt is logged, including time, device and reason.

#### B4. Daily Attendance Log & Monthly Summary
- **Source:** Spec 5 · App 15, 16
- **Status:** Existing
- **Description:**
  - A donut chart shows On time / Late / Early leave / Leave for the month.
  - A daily list shows check-in and check-out times, late or early minutes and verification status.
- **Demo work:** Add two fields from Spec 5:
  - A thumbnail of the face photo captured at check-in.
  - The reason for any irregular record.

---

### C. Timesheet & Public Holidays

#### C1. Monthly Timesheet Calendar
- **Source:** Spec 6 · App 17 · Flow *Calendar* (c1–c2, c4)
- **Status:** Existing
- **Description:** A month grid with color-coded days and monthly totals: standard workdays, actual workdays and accumulated hours.
- **Demo work:**
  - Standardise the 5 colors to match the spec:

    | Color | Meaning |
    |---|---|
    | Green | Full workday |
    | Yellow / Orange | Late or early leave |
    | Red | Missing punch or unauthorised absence |
    | Purple | Approved leave |
    | Grey | Weekly off or public holiday |

  - Tapping a red day opens a pre-filled Attendance Correction form (C3).
  - Approved On Duty or Business Trip days (F1, F2) show a "Off-site" label and count as worked.

#### C2. Public Holidays
- **Source:** App 21 · Flow *Calendar* (c3)
- **Status:** Existing
- **Description:** The year's statutory public holidays, which are paid days off.
- **Demo work:**
  - Holidays show in grey on the Timesheet (C1) and Shift (A2) calendars.
  - Choosing a holiday date in the Overtime form (E1) auto-applies the 300% rate.

#### C3. Attendance Correction (Regularization)
- **Source:** Spec 7 · App 25 · Flow *Correction* (k1–k10)
- **Status:** Existing
- **Description:** Used when a punch is missing, a device fails, or the employee had urgent field work. The form has date, issue type, corrected times, reason and a photo attachment.
- **Demo work:**
  - Full lifecycle: Draft → Pending → Approved / Rejected / Cancelled. Cancelling is allowed only while Pending.
  - Configurable limits: for example, at most 3 requests per month, submitted before the 20th.
  - After approval, the timesheet day is updated and changes color.

---

### D. Leave

#### D1. Leave Balance by Type
- **Source:** Spec 9
- **Status:** **Enhance.** The app currently shows a single "leave remaining" number on Home.
- **Description:** A dedicated balance screen. For each leave type it shows entitlement, used, pending and available.
- **Leave types:**
  - Annual leave.
  - Sick leave (social insurance).
  - Paid personal leave.
  - Unpaid leave.
  - Maternity leave.
  - **Comp-off**, fed by E3.
- **Demo work:**
  - A balance card at the top of the Leave list screen.
  - A tap opens the breakdown by type.
- **Acceptance criteria:** The "pending" figure includes all submitted requests that are not yet approved.

#### D2. Apply Leave
- **Source:** Spec 10 · App 23 · Flow *Leave* (l1–l4, l13)
- **Status:** Existing
- **Description:** The form has leave type, from and to dates, reason and approver.
- **Demo work:**
  - Add a full-day / half-day choice (first half or second half of the shift).
  - Add a substitute (handover) person and a document attachment, e.g. a medical certificate.
  - Weekends and holidays are excluded from the day count.
  - Block submission if the request exceeds the available balance.
  - Save as draft.

#### D3. Leave History
- **Source:** Spec 11 · App 22, 23 · Flow *Leave* (l5, l11, l12, l15)
- **Status:** Existing
- **Description:**
  - A list with a month filter.
  - Each item shows submitted date, period, type, number of days, status and the manager's comment.
- **Demo work:**
  - An empty-month state.
  - A Cancel action while the request is Pending.
  - After approval, the timesheet shows the leave day in purple.

---

### E. Overtime & Extra Hours

#### E1. Apply Overtime with Auto Pay Rate
- **Source:** Spec 12 · App 24 · Flow *Overtime* (o1–o4)
- **Status:** Existing
- **Description:** The form has date, start and end time, OT category (production, holiday duty, peak project, stock-take), reason and attachment. Total hours are calculated automatically.
- **Demo work:**
  - **Auto-detect the day type** from the shift calendar and holiday list:

    | Day type | Pay rate |
    |---|---|
    | Weekday | 150% |
    | Weekly off | 200% |
    | Public holiday | 300% |

  - **OT cap warning:** show a warning as the employee approaches the monthly cap (40 hours per month), and block submission above it.
  - **Compensation choice:** Paid, or Convert to comp-off (links to E3).

#### E2. Overtime History
- **Source:** Spec 13 · App 24 · Flow *Overtime* (o8–o10)
- **Status:** Existing
- **Description:** Each entry shows date, hours, OT type (weekday, weekly off or holiday), rate and approval status.
- **Demo work:** Show the monthly total of approved OT hours at the top of the list.

#### E3. Extra Hours Balance & Comp-off
- **Source:** Spec 33 (P1)
- **Status:** **New**
- **Description:**
  - Tracks accumulated approved overtime hours for the month and quarter.
  - Depending on company policy, each OT request is either paid in the next payroll or converted into compensatory leave.
- **Demo work:**
  - **Balance card** showing hours this month, hours this quarter, hours to be paid and hours converted to comp-off.
  - **Conversion rule** is configurable, for example 8 OT hours = 1 comp-off day.
  - **Comp-off as a leave type:** converted hours appear as a Comp-off balance in D1 and can be used in D2.
- **Acceptance criteria:** Once hours are converted to comp-off, they are no longer shown as payable.

---

### F. Off-site Work

#### F1. On Duty (Short Off-site Work)
- **Source:** Spec 34 (P1)
- **Status:** **New**
- **Description:** For short work away from the workplace: client meetings, government offices, market checks, urgent errands.
- **Form fields:**
  - Date.
  - From and to time.
  - Location, as free text or picked on a map.
  - Work description.
  - Optional attachment.
- **Demo work:**
  - Reuse the Overtime pattern: a list screen, then a create screen.
  - The request goes to the Manager Approval Inbox as type *On Duty*.
  - After approval, the hours are credited on the timesheet with a "Off-site" label. They are not counted as missing or late.
- **Acceptance criteria:** The On Duty time range must fall within the employee's shift on that date.

#### F2. Business Trip (Simplified)
- **Source:** Spec 35 (P1)
- **Status:** **New**
- **Description:** A multi-day trip, either domestic or overseas.
- **Form fields:**
  - Destination.
  - Departure and return dates.
  - Purpose.
  - Accompanying colleagues.
  - Plan attachment.
- **Demo work:**
  - Single-step approval by the Manager.
  - After approval, every trip day is credited as worked on the timesheet ("Off-site").
  - Budget estimation, cash advance and executive escalation are **excluded** from Phase 0 (see §9).

---

### G. Shared Framework

These functions are required for the flows above to work end to end.

#### G1. Personal Dashboard (Home)
- **Source:** Spec 20 · App 05–10
- **Status:** Existing
- **Description:**
  - Greeting and today's shift card.
  - A 2×2 metrics grid: actual workdays, leave remaining, OT hours this month, pending requests.
  - Quick actions.
- **Demo work:**
  - Add an "Off-site" quick action, or place it under All Services.
  - The metrics must refresh after each approval.

#### G2. Unified Request Center
- **Source:** Spec 21 · App 22, 26
- **Status:** Existing
- **Description:** A single list for all requests, with a month filter and an approval progress bar.
- **Demo work:**
  - Add Shift Swap and On Duty / Business Trip to the list and to the type filter.
  - The progress bar shows **only the steps that apply to that request type** (see §8).

#### G3. Manager Approval Inbox (MSS)
- **Source:** Spec 22 · App 07, 27–29 · Flow *Manager approval* (p1–p9)
- **Status:** Existing
- **Description:**
  - A pending-approvals strip on Home and an Approvals tab with a badge.
  - Filters by type and status.
  - One-tap Approve, or Reject with a mandatory reason.
- **Demo work:**
  - Add Shift Swap, On Duty and Business Trip to the type filter. It currently covers only Leave, OT and Correction.
  - In the request detail, show the employee's attendance for the relevant date(s).
  - For a swap, show both employees' schedules.
  - Add an internal note that is not visible to the employee.
  - The badge and Home strip decrease right after each action.
  - Show an empty state when all requests are processed.

#### G4. Notifications
- **Source:** Spec 23 · App 37
- **Status:** Existing
- **Description:** Approval results, check-in and check-out reminders, and company announcements, with a read/unread state.
- **Demo work:**
  - Tapping a notification opens the related request.
  - Local notifications are enough for the demo; FCM can come later.
  - Required triggers:
    - Request approved or rejected.
    - Swap approved, sent to both employees.
    - Reminder before shift start and before shift end.

---

## 6. Demo script (about 10 minutes)

Use the built-in role switch (App 03: Employee NV0089 ↔ Manager QL0012).

| Step | Role | Action | What it shows |
|---|---|---|---|
| 1 | Employee | Open app. Home shows today's shift. Check in at 08:12 | A1, B1: result "Late" |
| 2 | Employee | Turn on airplane mode and check out. Turn it off and tap Sync | B2 |
| 3 | Employee | Turn on the demo mock-GPS toggle and try to check in | B3 block screen |
| 4 | Employee | Open the Timesheet, tap a red day and submit a correction | C1 → C3 |
| 5 | Employee | Open Holidays, then apply OT on the next holiday and choose comp-off | C2 → E1 (300% auto) → E3 |
| 6 | Employee | View the leave balance and apply a half-day of annual leave | D1 → D2 |
| 7 | Employee | Request a shift swap with a colleague. Try an invalid colleague first to show the conflict | A3 |
| 8 | Employee | Submit an On Duty request for a client visit | F1 |
| 9 | Manager | Home strip shows the pending count. Filter by type, approve most requests and reject one with a reason | G3 |
| 10 | Employee | Open notifications and check the results | G4, C1 (purple leave day, "Off-site" label), A2 ("Swapped"), E3 (comp-off balance) |

## 7. Suggested delivery order

1. **Framework updates:** G2, G3, G4. New request types plug into these, so they come first.
2. **New request types:** F1 On Duty, then A3 manager-side approval. Both reuse the OT form and approval pattern.
3. **Balances:** D1 Leave balance, then E3 Extra hours & comp-off. These depend on each other through the comp-off leave type.
4. **Rules and cross-links:** E1 auto rate and cap, C2 → E1 link, C1 colors and "Off-site" label.
5. **Security block screens:** B3, using the demo toggle.
6. **F2 Business Trip (simplified).**
7. **Polish:** view states (loading, empty, error) and demo data seeding.

## 8. Business rules to align before the demo

1. **Minimum rest between shifts.** The flow artifact uses "11 hours" in the swap check. As far as I know, the Vietnamese Labour Code 2019 (Article 109) requires at least **12 hours** of rest before a shift worker moves to another shift. Please verify this and update the swap validation.
2. **Approval chain per request type.** The app currently shows a fixed 4-step bar (Employee → Manager → HR → Director) for every request. The flow artifact and the spec imply different chains per type. Recommended for Phase 0:

   | Request type | Approval chain |
   |---|---|
   | Shift Swap | Manager (final) |
   | Correction | Manager → HR (timesheet update) |
   | Leave | Manager → HR (balance deduction). Director only if more than 10 days, shown as a note in the demo |
   | Overtime | Manager → HR (cap check). Director only if over budget, shown as a note in the demo |
   | On Duty / Business Trip | Manager |

3. **Configurable parameters.** Present these as settings, not hard-coded rules:
   - Late grace threshold (08:05).
   - Offline retention (72 hours).
   - Face-match threshold (85%).
   - OT cap (40 hours per month).
   - Correction limit (3 per month, submitted before the 20th).
   - Comp-off conversion ratio.
   - Schedule publication day (the 25th).

## 9. Out of scope for Phase 0

| Item | Source | Reason / Phase |
|---|---|---|
| Team Attendance Overview (Manager) | Spec 53 | Optional stretch goal; otherwise P1 |
| Team Leave Calendar | Spec 32 | Optional stretch goal; otherwise P1 |
| Work From Home | Spec 37 | P1 |
| Workday Confirmation (temporary transfer) | Spec 38 | P1 |
| Project / Job Order Timesheet | Spec 39 | P1 |
| Business trip budget, cash advance & expense claim | Spec 35–36 | P1, requires the Executive role |
| Executive approval inbox & delegation | Spec 60, 63 | P1 |
| Lockscreen / Home widget check-in | Spec 30 | P1 |
| Payroll, rewards, recruitment, onboarding | Various | Outside the time & attendance focus |
