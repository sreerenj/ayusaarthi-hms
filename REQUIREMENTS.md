# Nursing Home Management System (NHMS)
## Software Requirements Specification

**Project:** AyuSaarthi HMS  
**Version:** 1.0  
**Date:** 2026-08-19  
**Status:** Draft

---

## Table of Contents

1. [Introduction](#1-introduction)
2. [User Roles](#2-user-roles)
3. [Functional Requirements](#3-functional-requirements)
   - 3.1 Resident Management
   - 3.2 Admissions and Discharge
   - 3.3 Staff Management
   - 3.4 Medication Management
   - 3.5 Care Plans
   - 3.6 Incident Management
   - 3.7 Billing
   - 3.8 Appointment Scheduling
   - 3.9 Reporting and Analytics
   - 3.10 Compliance and Audit Logs
4. [Non-Functional Requirements](#4-non-functional-requirements)
5. [User Stories](#5-user-stories)

---

## 1. Introduction

### 1.1 Purpose
This document specifies the complete software requirements for the AyuSaarthi Nursing Home Management System (NHMS). It serves as the authoritative reference for design, development, testing, and regulatory compliance activities.

### 1.2 Scope
AyuSaarthi HMS is a web-based, role-driven platform designed to digitize and streamline the end-to-end operations of nursing homes and long-term care facilities. The system manages resident lifecycle, clinical care, staffing, billing, compliance, and analytics.

### 1.3 Definitions

| Term | Definition |
|------|------------|
| Resident | A person formally admitted and living in the nursing home facility |
| ADL | Activities of Daily Living — bathing, dressing, feeding, etc. |
| MAR | Medication Administration Record |
| eMAR | Electronic Medication Administration Record |
| Care Plan | An individualized, documented plan of care for each resident |
| POC | Point of Care — clinical activities performed at the bedside |
| HIPAA | Health Insurance Portability and Accountability Act |
| MDS | Minimum Data Set — standardized assessment instrument for nursing home residents |
| PRN | Pro Re Nata — medication administered "as needed" |
| DNR | Do Not Resuscitate order |
| EMR | Electronic Medical Record |
| RBAC | Role-Based Access Control |
| SLA | Service Level Agreement |
| 2FA | Two-Factor Authentication |

### 1.4 Regulatory Context
The system must support compliance with:
- HIPAA / HITECH (data privacy and security)
- CMS Conditions of Participation (42 CFR Part 483)
- State-level nursing home licensing regulations
- OSHA workplace safety requirements for staff
- HL7 FHIR R4 interoperability standards

---

## 2. User Roles

### 2.1 Role Hierarchy

```
Super Admin
  └── Facility Administrator
        ├── Clinical Staff
        │     ├── Physician / Medical Director
        │     ├── Registered Nurse (RN)
        │     ├── Licensed Practical Nurse (LPN)
        │     ├── Certified Nursing Assistant (CNA)
        │     └── Therapist (PT / OT / SLP)
        ├── Administrative Staff
        │     ├── Admissions Coordinator
        │     ├── Billing Specialist
        │     └── Receptionist
        ├── Pharmacy Staff
        │     └── Pharmacist / Pharmacy Technician
        ├── Social Services
        │     └── Social Worker / Case Manager
        ├── Dietary Staff
        │     └── Dietitian / Dietary Aide
        └── External / Restricted
              ├── Family / Guardian (Portal Access)
              └── External Auditor (Read-Only)
```

### 2.2 Role Descriptions and Permissions

| Role | Description | Key Permissions |
|------|-------------|-----------------|
| **Super Admin** | System-level administrator | Full system access, tenant management, global configuration, audit log access |
| **Facility Administrator** | Manages day-to-day facility operations | All facility data, staff management, reports, billing approval, compliance dashboard |
| **Physician / Medical Director** | Oversees medical care for residents | Order medications, update diagnoses, sign care plans, review labs, override clinical alerts |
| **Registered Nurse (RN)** | Provides and supervises nursing care | eMAR, care plan management, incident reports, vital signs, assessments, delegate tasks to LPN/CNA |
| **Licensed Practical Nurse (LPN)** | Executes nursing care under RN supervision | eMAR (non-controlled), care delivery tasks, vital signs, wound care documentation |
| **Certified Nursing Assistant (CNA)** | Assists with ADLs and basic care | ADL documentation, vital signs entry, meal tracking, POC charting |
| **Admissions Coordinator** | Manages resident intake and discharge | Admission/discharge workflows, bed management, payer source setup, consent forms |
| **Billing Specialist** | Handles financial operations | Invoice generation, claim submission, payer management, payment posting, billing reports |
| **Pharmacist** | Manages medication dispensing and reviews | Medication reconciliation, drug interaction review, formulary management |
| **Social Worker** | Supports resident psychosocial wellbeing | Care conferences, family communication logs, social assessments, advance directive tracking |
| **Dietitian** | Manages nutritional care | Nutritional assessments, dietary plans, food allergy management |
| **Therapist (PT/OT/SLP)** | Provides rehabilitative therapy | Therapy assessments, treatment plans, session documentation, progress notes |
| **Receptionist** | Front-desk operations | Visitor log, appointment scheduling, basic resident directory lookup |
| **Family / Guardian** | Resident's authorized family member | View care plan, medication schedule, appointment schedule, send messages, receive alerts |
| **External Auditor** | State/CMS auditor or internal QA | Read-only access to resident records, incident logs, compliance reports |

---

## 3. Functional Requirements

### 3.1 Resident Management

#### 3.1.1 Resident Profile
- **FR-RM-001:** The system shall create and maintain a comprehensive resident profile containing: full legal name, date of birth, gender, SSN (masked), photograph, primary language, religion, national origin, and contact details.
- **FR-RM-002:** The system shall record and display emergency contacts with relationship type, contact priority, and communication preferences.
- **FR-RM-003:** The system shall store legal representative / Power of Attorney (POA) and healthcare proxy details with scanned document attachments.
- **FR-RM-004:** The system shall maintain a complete medical history including: primary diagnosis, secondary diagnoses (ICD-10 coded), allergies (drug, food, environmental), past surgeries, immunization records, and family medical history.
- **FR-RM-005:** The system shall capture advance directives (DNR status, living will, POLST/MOLST) with version-controlled document storage and physician co-signature workflow.
- **FR-RM-006:** The system shall track insurance and payer information including Medicare, Medicaid, private insurance, and self-pay with coverage period management.
- **FR-RM-007:** The system shall assign each resident a unique, facility-wide Resident ID.
- **FR-RM-008:** The system shall maintain a resident photograph with the ability to update it and log change history.

#### 3.1.2 Clinical Assessments
- **FR-RM-009:** The system shall support MDS 3.0 assessments with scheduling, completion tracking, and electronic submission to the CMS QIES/iQIES system.
- **FR-RM-010:** The system shall support standardized clinical assessment tools: Braden Scale (pressure ulcer risk), Falls Risk Assessment (Morse/MFS), Cognitive assessments (MMSE, BIMS), Pain assessment (PAINAD, Numeric), Nutritional screening (MNA), and Depression screening (PHQ-9, GDS).
- **FR-RM-011:** The system shall automatically schedule required assessments based on admission date, clinical triggers, and CMS mandated intervals.
- **FR-RM-012:** The system shall alert the responsible RN when an assessment is due within 48 hours or overdue.

#### 3.1.3 Daily Clinical Charting
- **FR-RM-013:** The system shall support structured flow sheets for: vital signs (BP, HR, RR, SpO2, Temperature, Weight, Blood Glucose), ADL tracking (bathing, dressing, feeding, toileting, ambulation, transfer), intake and output (I&O), bowel and bladder monitoring, and pain monitoring.
- **FR-RM-014:** The system shall support narrative nursing notes (SOAP format) with date/time stamps and co-signing workflows.
- **FR-RM-015:** The system shall issue clinical alerts when documented vital signs fall outside configurable thresholds per resident or per facility-wide defaults.
- **FR-RM-016:** The system shall maintain a 24-hour summary / shift report that consolidates key events, charting, and alerts for incoming nursing staff.

#### 3.1.4 Bed and Room Management
- **FR-RM-017:** The system shall provide a real-time, visual bed management board showing room/bed occupancy status (occupied, vacant, reserved, in-housekeeping).
- **FR-RM-018:** The system shall support room transfers (intra-facility) with a complete audit trail of move history.
- **FR-RM-019:** The system shall track and enforce room-level attributes: shared/private, isolation precautions (airborne, droplet, contact), ADA accessibility, and bariatric equipment availability.

---

### 3.2 Admissions and Discharge

#### 3.2.1 Pre-Admission
- **FR-AD-001:** The system shall support a pre-admission inquiry workflow to capture referral source, anticipated admission date, required level of care, and payer information before bed assignment.
- **FR-AD-002:** The system shall provide a pre-admission checklist ensuring required documents (physician orders, insurance cards, ID, advance directives) are collected before admission is finalized.
- **FR-AD-003:** The system shall allow bed reservations during the pre-admission phase with a configurable hold expiry period.
- **FR-AD-004:** The system shall support a pre-admission clinical assessment to determine level of care requirements and staffing implications.

#### 3.2.2 Admission
- **FR-AD-005:** The system shall guide the Admissions Coordinator through a structured step-by-step admission workflow with mandatory and optional field validation.
- **FR-AD-006:** The system shall generate a facility-branded Admission Agreement, financial responsibility agreement, and required HIPAA notices for digital signature or print.
- **FR-AD-007:** The system shall automatically trigger creation of an initial Care Plan, eMAR profile, and assessment schedule upon admission completion.
- **FR-AD-008:** The system shall record admission type: short-term rehab (SNF), long-term care (LTC), respite care, hospice, or assisted living.
- **FR-AD-009:** The system shall send automated notifications to nursing staff, social services, dietary, and pharmacy upon a new admission.

#### 3.2.3 Transfers
- **FR-AD-010:** The system shall manage external transfers (to hospital, specialist) with transfer documentation: reason, receiving facility, transport method, accompanying medications, and clinical summary.
- **FR-AD-011:** The system shall support return-from-hospital re-admission with a reconciliation workflow for medication changes and updated physician orders.
- **FR-AD-012:** The system shall generate a transfer summary / continuity of care document (CCD) compliant with HL7 FHIR R4.

#### 3.2.4 Discharge
- **FR-AD-013:** The system shall support planned and unplanned discharge workflows with discharge reason codes (home, hospital, deceased, AMA, transfer to another facility).
- **FR-AD-014:** The system shall generate a discharge summary including final diagnoses, medication reconciliation, follow-up appointments, and discharge instructions.
- **FR-AD-015:** The system shall update bed status to vacant/housekeeping upon discharge completion.
- **FR-AD-016:** The system shall retain discharged resident records in read-only archive mode, accessible to authorized roles, for a minimum of 7 years.
- **FR-AD-017:** The system shall process death in facility with documentation: date/time, attending physician, cause of death, family notification log, and coroner referral if applicable.

---

### 3.3 Staff Management

#### 3.3.1 Staff Profiles
- **FR-SM-001:** The system shall maintain individual staff profiles with: full name, employee ID, role, department, contact information, hire date, employment type (full-time, part-time, agency/contract), and photograph.
- **FR-SM-002:** The system shall store and track professional credentials: license type, license number, issuing state, expiration date, and renewal reminders (90, 60, 30 days before expiry).
- **FR-SM-003:** The system shall maintain a training and certification record per staff member including: mandatory in-service training, CPR/BLS, dementia care, infection control, HIPAA, and abuse prevention.
- **FR-SM-004:** The system shall track background check status and TB test results with expiry management.

#### 3.3.2 Scheduling
- **FR-SM-005:** The system shall provide a drag-and-drop shift scheduling interface organized by unit, floor, and shift (day, evening, night).
- **FR-SM-006:** The system shall enforce configurable staffing ratio rules (e.g., 1 CNA : 8 residents) and alert schedulers when proposed schedules fall below minimum staffing levels.
- **FR-SM-007:** The system shall support recurring schedule templates with the ability to publish schedules for staff notification.
- **FR-SM-008:** The system shall manage shift-swap and time-off requests with an approval workflow routed to the charge nurse or supervisor.
- **FR-SM-009:** The system shall display open-shift alerts and support voluntary sign-up for open shifts by eligible staff.
- **FR-SM-010:** The system shall integrate with electronic time and attendance, capturing actual clock-in/clock-out times against the scheduled shift.
- **FR-SM-011:** The system shall flag overtime risks and generate a daily staffing summary for the Facility Administrator.

#### 3.3.3 Performance and Incidents
- **FR-SM-012:** The system shall allow supervisors to document staff performance notes and link them to incident reports where applicable.
- **FR-SM-013:** The system shall track disciplinary actions with configurable escalation steps and required acknowledgment signatures.
- **FR-SM-014:** The system shall generate a staff competency matrix showing current training status across all required competency areas.

---

### 3.4 Medication Management

#### 3.4.1 Medication Orders
- **FR-MM-001:** The system shall support electronic physician medication orders with drug name (generic/brand), dose, route, frequency, start/stop dates, indication, and ordering provider signature.
- **FR-MM-002:** The system shall provide a drug database (integrated with a clinical drug reference, e.g., First Databank or Multum) for drug lookup with auto-complete, dose range guidance, and formulary checking.
- **FR-MM-003:** The system shall perform automated clinical decision support checks on order entry: drug-drug interactions (DDI), drug-allergy contraindications, dose range validation, and duplicate therapy alerts with severity classification (critical, serious, moderate).
- **FR-MM-004:** The system shall enforce a physician co-signature (or verbal/telephone order authentication within 24 hours) workflow for all medication orders.
- **FR-MM-005:** The system shall support PRN orders with a defined indication, maximum dose parameters, and required PRN effectiveness documentation post-administration.
- **FR-MM-006:** The system shall support controlled substance orders with DEA schedule tracking, 2-nurse witness documentation, and waste recording.

#### 3.4.2 Electronic Medication Administration Record (eMAR)
- **FR-MM-007:** The system shall present the eMAR as a visual grid of scheduled medications per resident per shift with clear due-time windows.
- **FR-MM-008:** The system shall require bedside barcode or QR-code verification (resident wristband + medication package) before recording an administration.
- **FR-MM-009:** The system shall record each administration event with: administered by, administered time, dose given, route used, site (for injectables), and resident response.
- **FR-MM-010:** The system shall capture medication refusals, holds, not-available, and omissions with a mandatory reason code.
- **FR-MM-011:** The system shall send real-time alerts for missed or overdue medications exceeding a configurable threshold (default: 30 minutes past due).
- **FR-MM-012:** The system shall generate a Medication Error report capturing near-misses and actual errors for quality improvement.

#### 3.4.3 Pharmacy Integration
- **FR-MM-013:** The system shall support bi-directional integration with the facility's contracted pharmacy via HL7 FHIR R4 / NCPDP Script 10.6 for order transmission and dispensing verification.
- **FR-MM-014:** The system shall manage medication inventory at the unit level including cycle fill counts, controlled substance counts, and automated reorder alerts.
- **FR-MM-015:** The system shall support medication reconciliation workflows at admission, transfer, and discharge.

---

### 3.5 Care Plans

#### 3.5.1 Care Plan Creation
- **FR-CP-001:** The system shall auto-generate an initial care plan template populated from the admission assessment, MDS data, physician orders, and active diagnoses.
- **FR-CP-002:** The system shall support a problem-goal-intervention (PGI) care plan structure with: identified problem, measurable short-term and long-term goals, planned interventions, responsible disciplines, target dates, and evaluation frequency.
- **FR-CP-003:** The system shall include NANDA-I nursing diagnoses with SNOMED CT coding for clinical problems.
- **FR-CP-004:** The system shall support interdisciplinary care plan contributions from Nursing, Social Services, Dietary, Therapy, Activities, and Pharmacy.

#### 3.5.2 Care Plan Management
- **FR-CP-005:** The system shall enforce an initial care plan completion deadline of 7 days post-admission and track compliance.
- **FR-CP-006:** The system shall support scheduled care plan reviews at defined intervals (e.g., quarterly, annually, or on clinical change) with an automated reminder workflow.
- **FR-CP-007:** The system shall support care plan updates triggered by: physician order changes, clinical status changes, MDS assessment results, incident reports, and family requests.
- **FR-CP-008:** The system shall maintain a full version history of the care plan with author, timestamp, and change summary for every modification.

#### 3.5.3 Care Plan Delivery and Communication
- **FR-CP-009:** The system shall surface active care plan interventions on the CNA/nurse workflow dashboard at point of care.
- **FR-CP-010:** The system shall generate a printable care plan summary for care conferences with family and interdisciplinary team members.
- **FR-CP-011:** The system shall record care conference outcomes including attendees, family concerns, decisions made, and updated goal targets.
- **FR-CP-012:** The system shall allow family portal users to view the current approved care plan (read-only) and submit feedback to the care team.

---

### 3.6 Incident Management

#### 3.6.1 Incident Reporting
- **FR-IM-001:** The system shall support electronic incident report creation for categories including: fall, fall with injury, elopement, medication error, skin breakdown / pressure ulcer, physical altercation, abuse/neglect allegation, choking/aspiration, adverse drug event, wandering, and theft/property loss.
- **FR-IM-002:** The system shall capture for each incident: date, time, location, involved resident(s), witness(es), brief narrative description, immediate actions taken, and reporting staff identity.
- **FR-IM-003:** The system shall enforce a reporting timeline rule: staff must initiate the incident report within a configurable window (default: 2 hours of discovery).
- **FR-IM-004:** The system shall trigger role-specific notifications upon incident creation: RN (immediate), Charge Nurse (immediate), Facility Administrator (within 1 hour), On-call Physician (as indicated), and family/guardian notification log.
- **FR-IM-005:** The system shall require physician notification documentation within 24 hours for any incident involving injury, significant clinical change, or potential abuse.

#### 3.6.2 Investigation and Follow-Up
- **FR-IM-006:** The system shall support a multi-step investigation workflow with: root cause analysis (RCA) section, contributing factors checklist, corrective actions assigned to responsible staff with due dates, and closure sign-off by Facility Administrator.
- **FR-IM-007:** The system shall track all state-reportable incidents (e.g., serious injury, abuse allegations, elopements) with mandatory fields for regulatory submission and a submission confirmation record.
- **FR-IM-008:** The system shall link incident reports to the involved resident's clinical record and the responsible staff member's profile.
- **FR-IM-009:** The system shall generate recurring incident trend reports by type, location, shift, and resident to support Quality Assurance and Performance Improvement (QAPI) activities.

---

### 3.7 Billing

#### 3.7.1 Payer and Census Management
- **FR-BL-001:** The system shall maintain a daily census automatically updated from admissions, discharges, and transfers, serving as the basis for all billing calculations.
- **FR-BL-002:** The system shall support multiple concurrent payer types per resident (Medicare A/B, Medicaid, private insurance, VA, managed care, private pay) with defined coverage priority and benefit period tracking.
- **FR-BL-003:** The system shall manage Medicare SNF benefit periods including tracking of qualifying hospital stay (3-day rule), benefit days used (1–20, 21–100), and automatic alert when benefit days are near exhaustion.
- **FR-BL-004:** The system shall support Medicaid prior authorization tracking with expiry alerts and renewal workflow.

#### 3.7.2 Charge Capture
- **FR-BL-005:** The system shall capture charges from clinical documentation automatically: room and board (daily rate by level of care), therapy minutes (mapped to Medicare RUG / PDPM categories), medication charges, medical supplies, and ancillary services.
- **FR-BL-006:** The system shall support a facility charge master (CDM) with configurable procedure and service codes (CPT, HCPCS, revenue codes).
- **FR-BL-007:** The system shall support PDPM (Patient Driven Payment Model) rate calculation for Medicare Part A billing based on clinical classification components (PT, OT, SLP, NTA, Nursing).

#### 3.7.3 Claims and Invoicing
- **FR-BL-008:** The system shall generate UB-04 (CMS-1450) institutional claims for Medicare and Medicaid payers.
- **FR-BL-009:** The system shall generate CMS-1500 claims for Medicare Part B physician/therapy professional billing.
- **FR-BL-010:** The system shall support electronic claim submission (EDI 837I/P) to clearinghouses and direct payers with batch processing.
- **FR-BL-011:** The system shall process Electronic Remittance Advice (ERA / EDI 835) for automated payment posting and adjustment recording.
- **FR-BL-012:** The system shall generate itemized monthly invoices for private-pay residents with a resident-accessible digital copy.
- **FR-BL-013:** The system shall manage the claim lifecycle: submitted, acknowledged, pending, paid, denied, and appealed.
- **FR-BL-014:** The system shall support claim denial management with denial reason code capture, root cause categorization, and appeal document tracking.

#### 3.7.4 Accounts and Reporting
- **FR-BL-015:** The system shall provide an Accounts Receivable (A/R) aging report by payer, segmented by 0–30, 31–60, 61–90, and 90+ day buckets.
- **FR-BL-016:** The system shall support trust fund / personal needs account management for residents with an itemized ledger, deposit/withdrawal tracking, and monthly statement generation.
- **FR-BL-017:** The system shall support integration with third-party accounting software (e.g., QuickBooks, Sage) via standard export (CSV, IIF, or direct API).

---

### 3.8 Appointment Scheduling

#### 3.8.1 Internal Appointments
- **FR-AS-001:** The system shall schedule and manage internal therapy sessions (PT, OT, SLP) with therapist assignment, duration, treatment location, and therapy goals linkage.
- **FR-AS-002:** The system shall schedule routine nursing assessments, wound care treatments, lab draws, and care conferences as recurring or one-time appointments.
- **FR-AS-003:** The system shall provide a master appointment calendar with filterable views by resident, staff member, room, and appointment type.
- **FR-AS-004:** The system shall detect and alert on scheduling conflicts (room double-booking, staff double-assignment).

#### 3.8.2 External Appointments
- **FR-AS-005:** The system shall manage external medical appointments with: specialty, referring physician, receiving provider, facility address, scheduled date/time, and transport requirements.
- **FR-AS-006:** The system shall generate a transport request linked to the external appointment with transport type (facility van, ambulance, family), accessibility requirements, and escort needs.
- **FR-AS-007:** The system shall generate an appointment packet for external visits including: resident summary, current medication list, relevant labs, and insurance cards.
- **FR-AS-008:** The system shall record the outcome of external appointments and allow attachment of external visit notes or specialist reports.

#### 3.8.3 Reminders and Communication
- **FR-AS-009:** The system shall send automated reminders to responsible staff and family/guardian (via portal, email, or SMS) 24 hours and 1 hour before scheduled appointments.
- **FR-AS-010:** The system shall allow appointment cancellation and rescheduling with a mandatory reason and notification to affected parties.
- **FR-AS-011:** The system shall track appointment adherence and generate a missed appointment report.

---

### 3.9 Reporting and Analytics

#### 3.9.1 Standard Operational Reports
- **FR-RA-001:** The system shall provide the following pre-built standard reports:

| Report | Audience | Frequency |
|--------|----------|-----------|
| Daily Census Report | Administrator, Billing | Daily |
| Staff Scheduling & Attendance Summary | Administrator, HR | Daily / Weekly |
| Medication Administration Rate (MAR Compliance) | DON, Pharmacist | Daily |
| Incident Summary by Type and Unit | DON, QA | Weekly / Monthly |
| Skin Integrity / Wound Tracking Report | DON, RN | Weekly |
| Fall Rate Report (per 1,000 resident days) | Administrator, QA | Monthly |
| MDS Assessment Completion Status | MDS Coordinator | Weekly |
| Resident A/R Aging Report | Billing, Administrator | Monthly |
| Accounts Receivable Summary by Payer | Billing | Monthly |
| Therapy Utilization Report | Therapy Director | Monthly |
| Staff Credential Expiry Report | HR, Administrator | Monthly |
| Dietary Compliance Report | Dietitian | Weekly |
| Care Plan Completion Rate | DON | Monthly |
| Discharge Destination Summary | Social Worker | Monthly |

#### 3.9.2 Quality Indicators (QI / QM)
- **FR-RA-002:** The system shall calculate and display CMS Quality Measures (QMs) as derived from MDS data, including: percentage of residents with a fall, percentage with a new pressure ulcer, percentage on antipsychotics, percentage with pain, and percentage with worsening ADL function.
- **FR-RA-003:** The system shall provide a facility-level Quality Indicator dashboard with trend lines comparing current performance to prior periods and national/state benchmarks where available.

#### 3.9.3 Ad-Hoc Reporting and Analytics
- **FR-RA-004:** The system shall provide an ad-hoc report builder allowing authorized users to select data fields, apply filters, group, sort, and export results in PDF, Excel, and CSV formats.
- **FR-RA-005:** The system shall provide interactive charts and dashboards with drill-down capability for Administrator and DON roles.
- **FR-RA-006:** The system shall support report scheduling: automated generation and email delivery of reports on a defined daily, weekly, or monthly schedule.
- **FR-RA-007:** The system shall track report access in the audit log (who generated which report and when).

---

### 3.10 Compliance and Audit Logs

#### 3.10.1 Audit Logging
- **FR-CL-001:** The system shall maintain an immutable, tamper-evident audit log for every data access, creation, modification, and deletion event across all modules.
- **FR-CL-002:** Each audit log entry shall capture: event timestamp (UTC), user ID and role, user display name, action performed, affected entity type and ID, old value (for modifications), new value (for modifications), and client IP address.
- **FR-CL-003:** Audit logs shall be retained for a minimum of 7 years and must not be modifiable or deletable by any application user, including Super Admin.
- **FR-CL-004:** The system shall provide a searchable audit log viewer for Super Admin and External Auditor roles with filtering by user, date range, event type, and affected record.

#### 3.10.2 Compliance Management
- **FR-CL-005:** The system shall provide a Compliance Dashboard displaying: overdue MDS assessments, expiring staff credentials, unresolved incident reports, incomplete care plans, overdue care plan reviews, and open corrective actions.
- **FR-CL-006:** The system shall generate a QAPI (Quality Assurance and Performance Improvement) summary report consolidating quality measures, incident trends, and corrective action status.
- **FR-CL-007:** The system shall support documentation of state survey / CMS inspection findings with a deficiency tracking workflow: citation entry, plan of correction (POC) authoring, POC submission date, and POC resolution tracking.
- **FR-CL-008:** The system shall track and enforce documentation of required regulatory notifications (e.g., 24-hour abuse reports to state, coroner notifications) with timestamp and confirmation record.
- **FR-CL-009:** The system shall support HIPAA Breach Incident tracking with required notification timelines to HHS and affected individuals (60-day rule).
- **FR-CL-010:** The system shall provide an electronic signature solution that meets 21 CFR Part 11 requirements for audit-defensible records.

---

## 4. Non-Functional Requirements

### 4.1 Performance

| ID | Requirement |
|----|-------------|
| NFR-P-001 | Page load time for any standard screen shall be ≤ 2 seconds under normal load (up to 200 concurrent users). |
| NFR-P-002 | The eMAR and medication administration screens shall respond within 1 second to prevent clinical workflow delay. |
| NFR-P-003 | Report generation for standard pre-built reports shall complete within 10 seconds for data sets up to 12 months. |
| NFR-P-004 | The system shall support at least 500 concurrent users facility-wide without degradation below SLA thresholds. |
| NFR-P-005 | Database queries underlying clinical screens shall execute within 500 ms at the 95th percentile. |

### 4.2 Availability and Reliability

| ID | Requirement |
|----|-------------|
| NFR-A-001 | The system shall achieve ≥ 99.9% uptime (≤ 8.7 hours downtime per year), excluding scheduled maintenance windows. |
| NFR-A-002 | Scheduled maintenance windows shall not occur between 06:00–22:00 local facility time and shall be communicated at least 72 hours in advance. |
| NFR-A-003 | The system shall support a Recovery Time Objective (RTO) of ≤ 4 hours and a Recovery Point Objective (RPO) of ≤ 1 hour. |
| NFR-A-004 | The system shall support an offline/degraded mode for eMAR access that queues changes and syncs upon connectivity restoration. |
| NFR-A-005 | Automated database backups shall run every 4 hours with daily full backups retained for 30 days, monthly backups retained for 12 months. |

### 4.3 Security

| ID | Requirement |
|----|-------------|
| NFR-S-001 | All data in transit shall be encrypted using TLS 1.3 or higher. |
| NFR-S-002 | All data at rest (database, backups, file storage) shall be encrypted using AES-256. |
| NFR-S-003 | The system shall enforce Role-Based Access Control (RBAC) ensuring users can only access data required for their role (least privilege principle). |
| NFR-S-004 | The system shall support Multi-Factor Authentication (MFA/2FA) for all users, mandatory for Administrator, Physician, and Pharmacist roles. |
| NFR-S-005 | User sessions shall automatically time out after 15 minutes of inactivity on shared/clinical workstations and 30 minutes on private devices (configurable per facility). |
| NFR-S-006 | Passwords shall meet complexity requirements: minimum 12 characters, mix of uppercase, lowercase, numeric, and special characters, and shall not be reused for the last 12 cycles. |
| NFR-S-007 | The system shall lock a user account after 5 consecutive failed login attempts and require administrator unlock or self-service via email verification. |
| NFR-S-008 | All PHI access shall be logged and the system shall support HIPAA-compliant access reports for Breach Assessment. |
| NFR-S-009 | The system shall undergo annual third-party penetration testing and OWASP Top 10 vulnerability assessments with findings remediated per severity SLA. |
| NFR-S-010 | API endpoints shall require OAuth 2.0 / JWT-based authentication; no unauthenticated endpoints shall expose PHI. |

### 4.4 Scalability

| ID | Requirement |
|----|-------------|
| NFR-SC-001 | The system shall support a multi-tenant architecture enabling management of up to 50 facilities under a single platform instance. |
| NFR-SC-002 | The system shall horizontally scale application and database tiers independently to handle increased load without architectural changes. |
| NFR-SC-003 | The system shall support resident records for facilities with up to 500 beds per facility. |

### 4.5 Interoperability

| ID | Requirement |
|----|-------------|
| NFR-I-001 | The system shall expose and consume HL7 FHIR R4 APIs for interoperability with hospitals, HIEs, and EHR systems. |
| NFR-I-002 | The system shall support CCD/C-CDA document generation for care transitions. |
| NFR-I-003 | The system shall support NCPDP Script 10.6 for pharmacy e-prescribing and medication dispensing. |
| NFR-I-004 | The system shall provide EDI 837/835 support for insurance claim submission and remittance. |
| NFR-I-005 | The system shall provide a documented REST API for third-party integrations with rate limiting and API key management. |

### 4.6 Usability

| ID | Requirement |
|----|-------------|
| NFR-U-001 | The system shall be operable on modern web browsers (Chrome, Firefox, Edge, Safari — latest 2 major versions) without browser plugins. |
| NFR-U-002 | The system shall be fully responsive and usable on tablets (iPad or equivalent) for POC clinical use. |
| NFR-U-003 | Clinical workflows (eMAR, vital signs entry, ADL charting) shall be completable within 3 clicks or taps from the main dashboard. |
| NFR-U-004 | The system shall conform to WCAG 2.1 AA accessibility standards. |
| NFR-U-005 | The system shall support English as the primary language with architecture capable of localization (i18n). |
| NFR-U-006 | New clinical staff shall be able to complete core clinical tasks (eMAR, charting) after a maximum of 4 hours of system training. |

### 4.7 Maintainability and Supportability

| ID | Requirement |
|----|-------------|
| NFR-M-001 | The system shall provide structured application logging (JSON format) integrated with centralized log management (e.g., ELK Stack, Splunk). |
| NFR-M-002 | The system shall expose a health-check endpoint for infrastructure monitoring integration. |
| NFR-M-003 | Application deployments shall follow a CI/CD pipeline with automated regression testing achieving ≥ 80% code coverage on critical clinical modules. |
| NFR-M-004 | Configuration changes (thresholds, roles, workflows) shall be manageable through the Admin UI without code deployment. |

### 4.8 Data Integrity

| ID | Requirement |
|----|-------------|
| NFR-DI-001 | The system shall enforce referential integrity across all related entities (resident – care plan, resident – medication order, etc.). |
| NFR-DI-002 | Clinical records (medication administrations, incident reports, clinical notes) shall be immutable after the close of a configurable correction window (default: 24 hours); corrections shall be tracked as addenda, not overwrites. |
| NFR-DI-003 | The system shall validate all structured data inputs at both client and server layers. |

---

## 5. User Stories

### 5.1 Resident Management

| ID | Role | Story | Acceptance Criteria |
|----|------|-------|---------------------|
| US-RM-001 | RN | As an RN, I want to view a single resident's complete clinical profile on one screen so that I can quickly orient to their care needs at the start of my shift. | Profile screen loads in ≤ 2 sec; displays demographics, diagnoses, allergies, active medications, current care plan, and recent vitals. |
| US-RM-002 | CNA | As a CNA, I want to document ADL assistance provided for each resident during my shift so that care delivery is accurately recorded. | ADL flowsheet accepts structured input per resident; saves with CNA identity and timestamp; visible to RN in shift report. |
| US-RM-003 | RN | As an RN, I want to receive an automatic alert when a resident's blood pressure exceeds the defined threshold so that I can respond promptly. | Alert fires within 60 seconds of out-of-range vital sign entry; displays in notification bell and sends in-app message to on-duty RN. |
| US-RM-004 | MDS Coordinator | As the MDS Coordinator, I want the system to remind me 7 days before an MDS assessment is due so that I never miss a CMS submission deadline. | Reminder appears in dashboard and is sent via email; includes resident name, assessment type, and due date. |
| US-RM-005 | Facility Admin | As the Facility Administrator, I want to see a real-time bed board so that I can instantly know which beds are available when a new admission call comes in. | Bed board updates within 30 seconds of discharge/admission action; color-codes: green (vacant), red (occupied), yellow (reserved), gray (housekeeping). |

### 5.2 Admissions and Discharge

| ID | Role | Story | Acceptance Criteria |
|----|------|-------|---------------------|
| US-AD-001 | Admissions Coordinator | As the Admissions Coordinator, I want a guided admission workflow so that I collect all required information without missing mandatory regulatory fields. | Workflow displays a progress indicator; required fields are clearly marked; submission is blocked until mandatory fields are complete. |
| US-AD-002 | RN | As the charge RN, I want to receive an immediate notification when a new resident is admitted so that I can prepare their initial nursing assessment. | In-app notification and optional SMS sent within 2 minutes of admission completion; includes resident name, room assignment, and primary diagnosis. |
| US-AD-003 | Social Worker | As the Social Worker, I want to generate a discharge summary document so that the receiving care provider has all relevant clinical and social information. | Discharge summary auto-populates from existing record; editable prior to finalization; exportable as PDF and FHIR CCD. |
| US-AD-004 | Admissions Coordinator | As the Admissions Coordinator, I want to track the Medicare SNF benefit days used so that I can alert the family before day 20 when cost-sharing begins. | System displays benefit days consumed vs. available; automatic alert sent to coordinator and family portal at day 15 and day 19. |

### 5.3 Staff Management

| ID | Role | Story | Acceptance Criteria |
|----|------|-------|---------------------|
| US-SM-001 | HR Manager | As the HR Manager, I want to be alerted 60 days before a staff member's nursing license expires so that renewals are completed before the deadline. | Email notification sent to HR Manager and the staff member at 90, 60, and 30 days before expiry; expired credentials flagged red on staff profile. |
| US-SM-002 | Charge Nurse | As the Charge Nurse, I want to create a weekly shift schedule and publish it to staff so that everyone knows their upcoming assignments. | Schedule builder allows drag-and-drop assignment; enforces minimum staffing ratios; published schedule pushes notification to affected staff's accounts. |
| US-SM-003 | Staff Member | As a staff member, I want to submit a shift swap request to my supervisor so that I can arrange coverage without calling the facility directly. | Swap request form captures date, shift, reason, and proposed swap partner (optional); routed to Charge Nurse for approval; both parties notified of decision. |
| US-SM-004 | Facility Admin | As the Facility Administrator, I want a daily staffing summary showing actual vs. scheduled hours so that I can identify overtime exposure early. | Dashboard widget and printable report show scheduled vs. clocked hours per role; flags staff approaching 40-hour OT threshold. |

### 5.4 Medication Management

| ID | Role | Story | Acceptance Criteria |
|----|------|-------|---------------------|
| US-MM-001 | Physician | As the attending Physician, I want to enter a medication order with a drug interaction check so that I am alerted to dangerous combinations before the order is active. | DDI check runs within 2 seconds of order entry; critical interactions display a modal block requiring explicit override justification; serious interactions show a soft alert. |
| US-MM-002 | RN | As an RN, I want to scan a resident's wristband and the medication package before administering so that I verify the 5 Rights at the bedside. | Barcode/QR scan validates correct resident and medication; mismatches display a red alert with audio warning; system does not allow administration recording until match is confirmed. |
| US-MM-003 | RN | As an RN, I want to document a PRN medication administration and record the resident's response 30 minutes later so that effectiveness is tracked per CMS requirements. | PRN administration opens a follow-up prompt at the configured interval (default: 30 min); follow-up captures pain/symptom score change; incomplete follow-ups flagged in supervisor dashboard. |
| US-MM-004 | Pharmacist | As the Pharmacist, I want to review all new medication orders for residents before dispensing so that I catch clinical errors before they reach the bedside. | New orders appear in pharmacist review queue; pharmacist can approve, modify with note, or reject with reason; physician notified of pharmacist action immediately. |
| US-MM-005 | LPN | As an LPN, I want to document a medication refused by the resident so that the refusal is recorded and the prescriber is informed if refusals recur. | Refusal reason captured from dropdown + free text; refusal logged in eMAR; three consecutive refusals within 7 days trigger automatic alert to prescribing physician. |

### 5.5 Care Plans

| ID | Role | Story | Acceptance Criteria |
|----|------|-------|---------------------|
| US-CP-001 | RN | As an RN, I want the system to auto-populate an initial care plan template from the admission assessment so that I spend time on clinical judgment, not data re-entry. | Initial care plan pre-populates within 1 hour of admission completion using assessment, MDS, and physician order data; RN reviews and approves. |
| US-CP-002 | Dietitian | As the Dietitian, I want to contribute a nutritional care plan intervention so that the resident's dietary needs are integrated into the interdisciplinary care plan. | Dietitian can add/edit nutrition-domain problems and interventions; changes are versioned and visible to all care team members; Dietitian receives notification when physician modifies diet orders. |
| US-CP-003 | Family Member | As a family member, I want to view my parent's care plan through the family portal so that I understand their daily care and goals. | Family portal displays current approved care plan in plain-language format; medications, interventions, and goals visible; no edit access; message button available to send question to care team. |
| US-CP-004 | DON | As the Director of Nursing, I want a report showing all care plans overdue for quarterly review so that the facility remains compliant. | Report lists residents with care plan review overdue by >7 days; sortable by days overdue, unit, and primary nurse; exportable as PDF. |

### 5.6 Incident Management

| ID | Role | Story | Acceptance Criteria |
|----|------|-------|---------------------|
| US-IM-001 | CNA | As a CNA, I want to quickly report a resident fall from my tablet so that I document the event while the details are fresh. | Incident report accessible from resident profile in ≤ 2 taps; fall-specific form fields pre-populate resident name and location; submission confirmed with timestamp. |
| US-IM-002 | Facility Admin | As the Facility Administrator, I want to receive an immediate alert for any high-severity incident (fall with injury, elopement, or abuse allegation) so that I can initiate the required regulatory response. | Push notification and email sent to Administrator within 5 minutes of high-severity incident report submission; alert includes resident name, incident type, and reporting staff. |
| US-IM-003 | DON | As the Director of Nursing, I want to view a monthly incident trend report by unit and incident type so that I can target QAPI interventions to areas with the highest risk. | Report displays incident counts by type, unit, shift, and month; compares to prior 3-month rolling average; exportable as PDF and Excel. |
| US-IM-004 | Charge Nurse | As the Charge Nurse, I want to complete a root cause analysis for each fall and assign corrective actions so that fall prevention measures are formally tracked. | RCA form embedded in incident report; corrective actions assigned to named staff with due dates; incomplete corrective actions surface in Facility Admin compliance dashboard. |

### 5.7 Billing

| ID | Role | Story | Acceptance Criteria |
|----|------|-------|---------------------|
| US-BL-001 | Billing Specialist | As the Billing Specialist, I want therapy minutes to automatically flow into the billing module from therapy session documentation so that PDPM claims are accurate without manual data entry. | Therapy documentation auto-creates billable charges in billing module; charges display therapy type, minutes, HIPPS code, and revenue code; Billing Specialist reviews and approves before claim generation. |
| US-BL-002 | Billing Specialist | As the Billing Specialist, I want to generate and submit an 837I claim batch for Medicare Part A at month-end so that claims are submitted on time. | Claim batch generation includes all eligible resident stays for the billing period; validates against payer-specific edits; submits to clearinghouse with batch confirmation receipt stored. |
| US-BL-003 | Billing Specialist | As the Billing Specialist, I want to see all denied claims with denial reason codes so that I can prioritize and work claim appeals efficiently. | Denial queue displays all denied claims with: claim ID, resident name, payer, denial code, denial reason description, amount, and days since denial; sortable and filterable. |
| US-BL-004 | Family Member | As a family member responsible for private-pay billing, I want to receive an itemized monthly invoice by email so that I can review and pay my loved one's bill. | Monthly invoice auto-generated on the first business day of the month; emailed to billing contact; itemizes daily room rate, ancillary charges, and payments received; accessible in family portal. |
| US-BL-005 | Facility Admin | As the Facility Administrator, I want an A/R aging dashboard so that I can monitor outstanding balances and cash flow at a glance. | Dashboard displays total A/R by payer type in aging buckets (0–30, 31–60, 61–90, 90+ days); drill-down to individual claims; compares current month to prior 3-month average. |

### 5.8 Appointment Scheduling

| ID | Role | Story | Acceptance Criteria |
|----|------|-------|---------------------|
| US-AS-001 | Physical Therapist | As the Physical Therapist, I want to schedule a resident's daily PT sessions for the week so that the therapy calendar reflects planned treatment. | Therapist creates recurring session series linked to the resident's therapy orders; sessions appear on the master facility calendar and resident's appointment list. |
| US-AS-002 | Receptionist | As the Receptionist, I want to schedule an external specialist appointment and generate the transport request simultaneously so that logistics are arranged with one workflow. | External appointment form includes transport request section; submitting the appointment auto-creates a linked transport request routed to the transport coordinator. |
| US-AS-003 | Family Member | As a family member, I want to receive a reminder 24 hours before my relative's external specialist appointment so that I can arrange to accompany them if desired. | Automated email/SMS reminder sent to resident's designated family contact 24 hours prior; includes appointment date, time, specialty, and transport details. |

### 5.9 Reporting and Analytics

| ID | Role | Story | Acceptance Criteria |
|----|------|-------|---------------------|
| US-RA-001 | Facility Admin | As the Facility Administrator, I want a daily census report automatically emailed to me at 07:00 each morning so that I begin the day with an accurate occupancy snapshot. | Report auto-generates and delivers by 07:00 local time; includes total census, SNF/LTC/respite breakdown, admissions and discharges in the past 24 hours, and pending admissions. |
| US-RA-002 | DON | As the Director of Nursing, I want an interactive quality measures dashboard so that I can identify which metrics are below target and drill into the underlying resident data. | Dashboard displays all CMS QMs with current rate, facility target, state average, and national average; clicking a metric shows the list of contributing residents. |
| US-RA-003 | Billing Specialist | As the Billing Specialist, I want to build a custom report selecting residents by payer, date range, and charge type so that I can answer ad-hoc financial queries. | Report builder provides multi-select filters for payer, date range, charge category, and unit; supports export to Excel and PDF; saved reports available for reuse. |

### 5.10 Compliance and Audit Logs

| ID | Role | Story | Acceptance Criteria |
|----|------|-------|---------------------|
| US-CL-001 | Facility Admin | As the Facility Administrator, I want a compliance dashboard that highlights all outstanding regulatory tasks so that I can prioritize compliance activities daily. | Dashboard displays: overdue MDS count, expiring credentials count, open incident corrective actions, incomplete care plans, and unresolved survey deficiencies; each item links to the relevant record. |
| US-CL-002 | External Auditor | As a State Surveyor, I want read-only access to resident records, incident logs, and medication administration records for a defined date range so that I can conduct an audit without facility staff mediation. | Auditor role has view-only access to all required records; cannot modify any data; all auditor access events are logged; session is time-limited (configurable, default 8 hours). |
| US-CL-003 | Super Admin | As the Super Admin, I want to search the audit log by user, date, and event type so that I can investigate a suspected unauthorized data access event. | Audit log search returns results within 5 seconds; supports filtering by user, date range, event type, and affected record ID; results exportable as CSV. |
| US-CL-004 | Facility Admin | As the Facility Administrator, I want to document a survey deficiency and create a Plan of Correction so that the response is tracked and completed within the required 10-day window. | Deficiency entry captures tag number, scope/severity, description, and surveyor name; POC editor supports rich text with submit date; system alerts Admin 2 days before POC submission deadline. |

---

## Appendix A: Glossary of Clinical Terms

| Term | Definition |
|------|------------|
| ADL | Activities of Daily Living (bathing, dressing, eating, transferring, continence, toileting) |
| BIMS | Brief Interview for Mental Status |
| CMS | Centers for Medicare & Medicaid Services |
| DON | Director of Nursing |
| HIPPS | Health Insurance Prospective Payment System — rate code used for Medicare SNF billing |
| I&O | Intake and Output (fluid measurement) |
| MMSE | Mini-Mental State Examination |
| MNA | Mini Nutritional Assessment |
| NANDA-I | North American Nursing Diagnosis Association International |
| PAINAD | Pain Assessment in Advanced Dementia scale |
| PDPM | Patient Driven Payment Model (Medicare SNF reimbursement model) |
| PHQ-9 | Patient Health Questionnaire-9 (depression screening) |
| POLST/MOLST | Physician Orders for Life-Sustaining Treatment / Medical Orders for Life-Sustaining Treatment |
| QAPI | Quality Assurance and Performance Improvement |
| RUG | Resource Utilization Groups (predecessor SNF payment model) |
| SNOMED CT | Systematized Nomenclature of Medicine — Clinical Terms |
| SNF | Skilled Nursing Facility |

## Appendix B: Compliance Standards Reference

| Standard | Description | Applicable Modules |
|----------|-------------|-------------------|
| HIPAA / HITECH | PHI privacy and security | All modules |
| 42 CFR Part 483 | CMS Conditions of Participation for LTC | Resident Mgmt, Care Plans, Admissions, Compliance |
| 21 CFR Part 11 | Electronic records and signatures | All clinical documentation |
| HL7 FHIR R4 | Interoperability standard | Admissions (CCD), Pharmacy, Lab, API |
| NCPDP Script 10.6 | E-prescribing / pharmacy messaging | Medication Management |
| EDI 837I/835 | Electronic claim submission / remittance | Billing |
| WCAG 2.1 AA | Web accessibility | All UI modules |
| OWASP Top 10 | Web application security | All modules |

---

*Document Owner: AyuSaarthi HMS Product Team*  
*Review Cycle: Quarterly or upon regulatory change*  
*Next Review Date: 2026-11-19*
