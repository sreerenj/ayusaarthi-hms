# AyuSaarthi HMS — Database Schema

**Version:** 1.0  
**Date:** 2026-08-31  
**RDBMS:** SQL Server 2022 / Azure SQL Database  
**Normal Form:** Third Normal Form (3NF)

---

## Table of Contents

1. [Schema Overview](#1-schema-overview)
2. [ER Diagrams](#2-er-diagrams)
   - 2.1 Infrastructure & Staff
   - 2.2 Residents & Admissions
   - 2.3 Medications
   - 2.4 Care Plans
   - 2.5 Incidents
   - 2.6 Billing & Finance
3. [SQL Create Scripts](#3-sql-create-scripts)
4. [Reference Data (Seed SQL)](#4-reference-data-seed-sql)
5. [Index Strategy](#5-index-strategy)
6. [Design Decisions](#6-design-decisions)

---

## 1. Schema Overview

| Module | Tables | Description |
|--------|--------|-------------|
| Infrastructure & Staff | 7 | Facilities, units, rooms, beds, departments, staff, credentials |
| Residents | 6 | Resident profiles, contacts, allergies, insurance, diagnoses, advance directives |
| Admissions | 6 | Admissions, discharges, transfers, vitals, clinical assessments, diagnosis codes |
| Medications | 6 | Drug master, orders, schedules, administrations, PRN effectiveness, DDI log |
| Care Plans | 5 | Care plans, problems, goals, interventions, reviews |
| Incidents | 5 | Incident categories, reports, witnesses, investigations, corrective actions |
| Billing & Finance | 8 | Charge items, charges, claims, claim-charges, payments, denials, trust fund |
| Payers | 1 | Payer master (shared by Residents and Billing modules) |
| Audit | 1 | Immutable append-only audit log |
| **Total** | **45** | |

---

## 2. ER Diagrams

### 2.1 Infrastructure & Staff

```mermaid
erDiagram
    Facilities {
        int FacilityId PK
        nvarchar FacilityName
        char StateCode
        nvarchar LicenseNumber
        nvarchar MedicareProvNum
        nvarchar NPI
        bit IsActive
    }
    Units {
        int UnitId PK
        int FacilityId FK
        nvarchar UnitName
        nvarchar UnitType
        smallint FloorNumber
    }
    Rooms {
        int RoomId PK
        int UnitId FK
        nvarchar RoomNumber
        nvarchar RoomType
        tinyint Capacity
        bit IsADAAccessible
    }
    Beds {
        int BedId PK
        int RoomId FK
        nvarchar BedLabel
        nvarchar BedStatus
    }
    Departments {
        int DepartmentId PK
        int FacilityId FK
        nvarchar DepartmentName
    }
    Staff {
        int StaffId PK
        int FacilityId FK
        int DepartmentId FK
        nvarchar EmployeeId
        nvarchar FirstName
        nvarchar LastName
        nvarchar Role
        nvarchar EmploymentType
        date HireDate
        date TerminationDate
        nvarchar Email
        bit IsActive
    }
    StaffCredentials {
        int CredentialId PK
        int StaffId FK
        int VerifiedByStaffId FK
        nvarchar CredentialType
        nvarchar LicenseNumber
        char IssuingState
        date IssueDate
        date ExpiryDate
        bit IsVerified
    }

    Facilities   ||--o{ Units            : "contains"
    Units        ||--o{ Rooms            : "has"
    Rooms        ||--o{ Beds             : "has"
    Facilities   ||--o{ Departments      : "organizes"
    Facilities   ||--o{ Staff            : "employs"
    Departments  ||--o{ Staff            : "classifies"
    Staff        ||--o{ StaffCredentials : "holds"
```

---

### 2.2 Residents & Admissions

```mermaid
erDiagram
    Facilities {
        int FacilityId PK
    }
    Beds {
        int BedId PK
    }
    Staff {
        int StaffId PK
    }
    Payers {
        int PayerId PK
        nvarchar PayerName
        nvarchar PayerType
        nvarchar PayerID_EDI
    }
    Residents {
        int ResidentId PK
        int FacilityId FK
        int CreatedByStaffId FK
        nvarchar FirstName
        nvarchar LastName
        date DateOfBirth
        nvarchar Gender
        nvarchar SSN
        nvarchar PrimaryLanguage
    }
    ResidentContacts {
        int ContactId PK
        int ResidentId FK
        nvarchar FullName
        nvarchar Relationship
        nvarchar Phone
        nvarchar Email
        bit IsPrimary
        bit IsEmergency
        bit IsLegalRep
        bit IsBillingContact
    }
    Allergies {
        int AllergyId PK
        int ResidentId FK
        int DocumentedByStaffId FK
        nvarchar Allergen
        nvarchar AllergyType
        nvarchar Severity
        nvarchar Reaction
    }
    AdvanceDirectives {
        int DirectiveId PK
        int ResidentId FK
        int WitnessedByStaffId FK
        int PhysicianSignedByStaffId FK
        nvarchar DNRStatus
        bit HasLivingWill
        bit HasPOLST
        date EffectiveDate
        bit IsSuperseded
    }
    ResidentInsurance {
        int InsuranceId PK
        int ResidentId FK
        int PayerId FK
        nvarchar PolicyNumber
        date CoverageStartDate
        date CoverageEndDate
        tinyint Priority
        smallint BenefitDaysUsed
    }
    DiagnosisCodes {
        int DiagnosisCodeId PK
        nvarchar ICD10Code
        nvarchar Description
        nvarchar Category
    }
    Admissions {
        int AdmissionId PK
        int ResidentId FK
        int FacilityId FK
        int BedId FK
        int AdmittingPhysicianId FK
        int AdmissionsCoordinatorId FK
        int PrimaryInsuranceId FK
        int PrimaryDiagnosisCodeId FK
        datetime AdmissionDate
        nvarchar AdmissionType
        nvarchar LevelOfCare
        nvarchar Status
    }
    Discharges {
        int DischargeId PK
        int AdmissionId FK
        int DischargedByStaffId FK
        datetime DischargeDate
        nvarchar DischargeReason
        nvarchar DischargeDestination
    }
    Transfers {
        int TransferId PK
        int AdmissionId FK
        int FromBedId FK
        int ToBedId FK
        int InitiatedByStaffId FK
        nvarchar TransferType
        datetime TransferDate
        nvarchar ExternalFacilityName
        bit ReturnExpected
    }
    ResidentDiagnoses {
        int ResidentDiagnosisId PK
        int ResidentId FK
        int AdmissionId FK
        int DiagnosisCodeId FK
        int DiagnosedByStaffId FK
        nvarchar DiagnosisType
        date OnsetDate
        date ResolvedDate
    }
    VitalSigns {
        int VitalId PK
        int ResidentId FK
        int AdmissionId FK
        int RecordedByStaffId FK
        datetime RecordedAt
        smallint SystolicBP
        smallint DiastolicBP
        smallint HeartRate
        decimal TemperatureF
        decimal Weight
        tinyint SpO2
        tinyint PainScore
    }
    ClinicalAssessments {
        int AssessmentId PK
        int ResidentId FK
        int AdmissionId FK
        int AssessedByStaffId FK
        nvarchar AssessmentType
        decimal Score
        nvarchar RiskLevel
        nvarchar AssessmentData
        date NextAssessmentDate
    }

    Facilities       ||--o{ Residents          : "registers"
    Residents        ||--o{ ResidentContacts    : "has"
    Residents        ||--o{ Allergies           : "has"
    Residents        ||--o{ AdvanceDirectives   : "has"
    Residents        ||--o{ ResidentInsurance   : "insured by"
    Payers           ||--o{ ResidentInsurance   : "provides"
    Residents        ||--o{ Admissions          : "undergoes"
    Beds             ||--o{ Admissions          : "assigned in"
    DiagnosisCodes   ||--o{ Admissions          : "primary dx"
    Admissions       ||--o| Discharges          : "ends with"
    Admissions       ||--o{ Transfers           : "generates"
    Admissions       ||--o{ ResidentDiagnoses   : "includes"
    DiagnosisCodes   ||--o{ ResidentDiagnoses   : "classifies"
    Admissions       ||--o{ VitalSigns          : "records"
    Admissions       ||--o{ ClinicalAssessments : "includes"
```

---

### 2.3 Medications

```mermaid
erDiagram
    Residents {
        int ResidentId PK
    }
    Admissions {
        int AdmissionId PK
    }
    Staff {
        int StaffId PK
    }
    Allergies {
        int AllergyId PK
    }
    DrugMaster {
        int DrugId PK
        nvarchar GenericName
        nvarchar BrandName
        nvarchar DrugClass
        nvarchar DEASchedule
        bit IsControlled
        nvarchar DefaultDoseUnit
        nvarchar RouteOptions
        decimal MinDose
        decimal MaxDose
    }
    MedicationOrders {
        int OrderId PK
        int ResidentId FK
        int AdmissionId FK
        int DrugId FK
        int OrderedByStaffId FK
        int VerifiedByPharmacistId FK
        int DiscontinuedByStaffId FK
        nvarchar Dose
        nvarchar DoseUnit
        nvarchar Route
        nvarchar Frequency
        date StartDate
        date StopDate
        bit IsPRN
        nvarchar PRNIndication
        nvarchar OrderStatus
    }
    MedicationSchedules {
        int ScheduleId PK
        int OrderId FK
        time ScheduledTime
        nvarchar DayOfWeek
        bit IsActive
    }
    MedicationAdministrations {
        int AdministrationId PK
        int OrderId FK
        int ScheduleId FK
        int ResidentId FK
        int DrugId FK
        int AdministeredByStaffId FK
        int WitnessStaffId FK
        datetime AdministeredAt
        nvarchar DoseGiven
        nvarchar Route
        nvarchar AdministrationSite
        nvarchar AdminStatus
        nvarchar RefusalReason
        bit ResidentScanVerified
        bit MedScanVerified
    }
    PRNEffectiveness {
        int EffectivenessId PK
        int AdministrationId FK
        int AssessedByStaffId FK
        datetime AssessedAt
        tinyint SymptomScorePre
        tinyint SymptomScorePost
        nvarchar EffectivenessNote
    }
    DrugInteractionLog {
        int InteractionLogId PK
        int NewOrderId FK
        int Drug1Id FK
        int Drug2Id FK
        int AllergyId FK
        int OverriddenByStaffId FK
        nvarchar InteractionType
        nvarchar SeverityLevel
        nvarchar AlertText
        bit IsOverridden
        nvarchar OverrideReason
    }

    DrugMaster               ||--o{ MedicationOrders         : "ordered as"
    MedicationOrders         ||--o{ MedicationSchedules      : "scheduled via"
    MedicationOrders         ||--o{ MedicationAdministrations : "administered via"
    MedicationAdministrations ||--o| PRNEffectiveness         : "followed by"
    MedicationOrders         ||--o{ DrugInteractionLog        : "triggers"
    DrugMaster               ||--o{ DrugInteractionLog        : "involved in"
    Allergies                |o--o{ DrugInteractionLog        : "flagged in"
```

---

### 2.4 Care Plans

```mermaid
erDiagram
    Residents {
        int ResidentId PK
    }
    Admissions {
        int AdmissionId PK
    }
    Staff {
        int StaffId PK
    }
    CarePlans {
        int CarePlanId PK
        int ResidentId FK
        int AdmissionId FK
        int CreatedByStaffId FK
        datetime CreatedAt
        nvarchar ReviewFrequency
        date NextReviewDate
        nvarchar Status
        smallint Version
    }
    CarePlanProblems {
        int ProblemId PK
        int CarePlanId FK
        int AddedByStaffId FK
        nvarchar ProblemDescription
        nvarchar NANDACode
        date OnsetDate
        date TargetResolutionDate
        date ResolvedDate
        nvarchar Status
        tinyint Priority
    }
    CarePlanGoals {
        int GoalId PK
        int ProblemId FK
        int AddedByStaffId FK
        nvarchar GoalDescription
        nvarchar GoalType
        date TargetDate
        date AchievedDate
        nvarchar Status
    }
    CarePlanInterventions {
        int InterventionId PK
        int ProblemId FK
        int AssignedStaffId FK
        int AddedByStaffId FK
        nvarchar InterventionDescription
        nvarchar FrequencyNotes
        nvarchar ResponsibleDiscipline
        date StartDate
        date EndDate
        nvarchar Status
    }
    CarePlanReviews {
        int ReviewId PK
        int CarePlanId FK
        int ReviewedByStaffId FK
        datetime ReviewDate
        nvarchar ReviewType
        nvarchar ReviewNotes
        date NextReviewDate
        bit IsSignedOff
    }

    Admissions           ||--o{ CarePlans              : "has"
    CarePlans            ||--o{ CarePlanProblems        : "identifies"
    CarePlanProblems     ||--o{ CarePlanGoals           : "targets"
    CarePlanProblems     ||--o{ CarePlanInterventions   : "addressed by"
    CarePlans            ||--o{ CarePlanReviews         : "reviewed in"
```

---

### 2.5 Incidents

```mermaid
erDiagram
    Residents {
        int ResidentId PK
    }
    Facilities {
        int FacilityId PK
    }
    Staff {
        int StaffId PK
    }
    IncidentCategories {
        int CategoryId PK
        nvarchar CategoryName
        bit IsStateReportable
        smallint ReportingWindowHours
    }
    IncidentReports {
        int IncidentId PK
        int ResidentId FK
        int FacilityId FK
        int ReportedByStaffId FK
        int CategoryId FK
        int PhysicianNotifiedByStaffId FK
        int FamilyNotifiedByStaffId FK
        datetime IncidentDate
        datetime ReportedAt
        nvarchar Location
        nvarchar NarrativeDescription
        nvarchar ImmediateActionsTaken
        nvarchar Severity
        datetime PhysicianNotifiedAt
        datetime FamilyNotifiedAt
        nvarchar Status
    }
    IncidentWitnesses {
        int WitnessId PK
        int IncidentId FK
        int StaffId FK
        nvarchar WitnessName
        nvarchar WitnessType
        nvarchar StatementText
    }
    IncidentInvestigations {
        int InvestigationId PK
        int IncidentId FK
        int InvestigatedByStaffId FK
        int ClosedByStaffId FK
        datetime OpenedAt
        datetime CompletedAt
        nvarchar RootCause
        nvarchar ContributingFactors
        bit IsComplete
    }
    CorrectiveActions {
        int ActionId PK
        int IncidentId FK
        int InvestigationId FK
        int AssignedToStaffId FK
        int AssignedByStaffId FK
        nvarchar ActionDescription
        date DueDate
        date CompletedDate
        nvarchar Status
        nvarchar CompletionNotes
    }

    IncidentCategories     ||--o{ IncidentReports       : "classifies"
    Residents              ||--o{ IncidentReports       : "involved in"
    Facilities             ||--o{ IncidentReports       : "occurs at"
    IncidentReports        ||--o{ IncidentWitnesses     : "witnessed by"
    IncidentReports        ||--o| IncidentInvestigations : "investigated in"
    IncidentReports        ||--o{ CorrectiveActions     : "requires"
    IncidentInvestigations |o--o{ CorrectiveActions     : "generates"
```

---

### 2.6 Billing & Finance

```mermaid
erDiagram
    Residents {
        int ResidentId PK
    }
    Admissions {
        int AdmissionId PK
    }
    Facilities {
        int FacilityId PK
    }
    Staff {
        int StaffId PK
    }
    Payers {
        int PayerId PK
        nvarchar PayerName
        nvarchar PayerType
        nvarchar PayerID_EDI
    }
    ResidentInsurance {
        int InsuranceId PK
        int ResidentId FK
        int PayerId FK
    }
    ChargeItems {
        int ChargeItemId PK
        int FacilityId FK
        nvarchar ServiceCode
        nvarchar ServiceDescription
        nvarchar RevenueCode
        nvarchar CPTCode
        nvarchar HCPCSCode
        decimal DefaultAmount
        nvarchar UnitOfMeasure
    }
    Charges {
        int ChargeId PK
        int ResidentId FK
        int AdmissionId FK
        int ChargeItemId FK
        int CreatedByStaffId FK
        date ServiceDate
        decimal Quantity
        decimal UnitAmount
        decimal TotalAmount
        date BillingPeriodStart
        date BillingPeriodEnd
        nvarchar ChargeStatus
    }
    Claims {
        int ClaimId PK
        int ResidentId FK
        int AdmissionId FK
        int PayerId FK
        int InsuranceId FK
        int CreatedByStaffId FK
        nvarchar ClaimType
        date ClaimPeriodStart
        date ClaimPeriodEnd
        decimal TotalBilledAmount
        datetime SubmittedAt
        nvarchar ClearinghouseRef
        nvarchar Status
    }
    ClaimCharges {
        int ClaimChargeId PK
        int ClaimId FK
        int ChargeId FK
    }
    Payments {
        int PaymentId PK
        int ClaimId FK
        int PostedByStaffId FK
        date PaymentDate
        decimal AmountPaid
        decimal ContractualAdj
        decimal PatientBalance
        nvarchar PaymentMethod
        nvarchar ERAReference
    }
    ClaimDenials {
        int DenialId PK
        int ClaimId FK
        date DenialDate
        nvarchar DenialCode
        nvarchar DenialReason
        date AppealDeadline
        nvarchar AppealStatus
    }
    TrustFundAccounts {
        int AccountId PK
        int ResidentId FK
        decimal Balance
        datetime LastUpdatedAt
    }
    TrustFundTransactions {
        int TransactionId PK
        int AccountId FK
        int ProcessedByStaffId FK
        datetime TransactionDate
        nvarchar TransactionType
        decimal Amount
        decimal RunningBalance
        nvarchar ReceiptNumber
    }

    Facilities           ||--o{ ChargeItems          : "defines"
    ChargeItems          ||--o{ Charges              : "billed as"
    Residents            ||--o{ Charges              : "incurs"
    Admissions           ||--o{ Charges              : "during"
    Payers               ||--o{ Claims               : "receives"
    Residents            ||--o{ Claims               : "subject of"
    ResidentInsurance    ||--o{ Claims               : "billed to"
    Claims               ||--o{ ClaimCharges         : "includes"
    Charges              ||--o{ ClaimCharges         : "grouped in"
    Claims               ||--o{ Payments             : "settled by"
    Claims               ||--o{ ClaimDenials         : "denied via"
    Residents            ||--|| TrustFundAccounts    : "holds"
    TrustFundAccounts    ||--o{ TrustFundTransactions : "records"
```

---

## 3. SQL Create Scripts

> Full runnable scripts are in [database/schema.sql](database/schema.sql).  
> Reference / seed data is in [database/seed_data.sql](database/seed_data.sql).

---

## 4. Index Strategy

| Table | Index | Columns | Rationale |
|-------|-------|---------|-----------|
| Residents | IX_Residents_Name | LastName, FirstName | Resident search by name |
| Residents | IX_Residents_Facility | FacilityId | Census and reporting queries |
| Admissions | IX_Admissions_Status | FacilityId, Status | Active census board queries |
| Admissions | IX_Admissions_Resident | ResidentId | Resident history lookups |
| MedicationOrders | IX_MedOrders_ActiveRes | ResidentId, OrderStatus | eMAR schedule generation |
| MedicationAdministrations | IX_MedAdmin_ResDate | ResidentId, AdministeredAt DESC | MAR history lookups |
| VitalSigns | IX_Vitals_ResDate | ResidentId, RecordedAt DESC | Clinical trending |
| IncidentReports | IX_Incidents_FacDate | FacilityId, IncidentDate | QAPI reporting |
| Charges | IX_Charges_ResStatus | AdmissionId, ChargeStatus | Unbilled charge sweep |
| Claims | IX_Claims_PayerStatus | PayerId, Status | A/R aging queries |
| StaffCredentials | IX_Creds_Expiry | ExpiryDate, StaffId | Expiry alert queries |
| AuditLog | IX_Audit_Table | TableName, RecordId, ChangedAt DESC | PHI access lookups |
| AuditLog | IX_Audit_User | ChangedByUserId, ChangedAt DESC | User activity audit |

---

## 5. Design Decisions

| Decision | Rationale |
|----------|-----------|
| `DATETIME2` over `DATETIME` | More precise, larger range, ISO 8601 compliant — recommended for SQL Server 2008+ |
| `NVARCHAR` for all string fields | Full Unicode support for resident names, multilingual facilities |
| `DECIMAL(10,2)` over `MONEY` | MONEY type has known rounding errors with division; DECIMAL is predictable |
| `BIGINT` PK on AuditLog | High-volume table; INT (max ~2.1B rows) would overflow in large deployments |
| Computed `TotalAmount` column on Charges | `AS (Quantity * UnitAmount) PERSISTED` — always in sync, indexed, no app logic needed |
| Soft deletes (`IsActive BIT`) on clinical entities | Preserves data lineage; discharged resident records retained read-only per 7-year CMS rule |
| `IsSuperseded` on AdvanceDirectives | Tracks the full history of directive changes without deleting old versions |
| `AuditLog` has no FK on `ChangedByUserId` | Prevents cascade deletes from corrupting the immutable audit trail |
| Separate `ClaimCharges` junction table | Charges can be re-billed across multiple claims (e.g., correction claims) |
| `AssessmentData NVARCHAR(MAX)` on ClinicalAssessments | Semi-structured JSON field stores variable assessment forms without schema changes |
| `SSN NVARCHAR(11)` — application-layer encryption | SQL Server Always Encrypted or app-level AES-256 encryption before persistence |
| `CHECK` constraints on all status/enum columns | Database-enforced domain integrity; eliminates invalid states at the storage layer |
