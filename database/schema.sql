-- ============================================================
--  AyuSaarthi HMS  |  SQL Server Database Schema
--  Version  : 1.0
--  Date     : 2026-08-31
--  RDBMS    : SQL Server 2022 / Azure SQL Database
--  Encoding : NVARCHAR throughout (Unicode-safe)
--  Normal Form: 3NF
-- ============================================================
-- Execution order matters: tables are created in FK-dependency
-- order so every REFERENCES target already exists.
-- ============================================================

USE AyuSaarthiHMS;
GO

-- ============================================================
-- SECTION 1 : INFRASTRUCTURE  (Facilities → Units → Rooms → Beds)
-- ============================================================

CREATE TABLE Facilities (
    FacilityId          INT             NOT NULL IDENTITY(1,1),
    FacilityName        NVARCHAR(150)   NOT NULL,
    AddressLine1        NVARCHAR(200)   NOT NULL,
    AddressLine2        NVARCHAR(200)       NULL,
    City                NVARCHAR(100)   NOT NULL,
    StateCode           CHAR(2)         NOT NULL,
    ZipCode             NVARCHAR(10)    NOT NULL,
    PhoneNumber         NVARCHAR(20)        NULL,
    LicenseNumber       NVARCHAR(50)        NULL,
    MedicareProvNum     NVARCHAR(20)        NULL,
    MedicaidProvNum     NVARCHAR(20)        NULL,
    NPI                 NVARCHAR(10)        NULL,
    IsActive            BIT             NOT NULL DEFAULT 1,
    CreatedAt           DATETIME2       NOT NULL DEFAULT SYSUTCDATETIME(),
    CONSTRAINT PK_Facilities            PRIMARY KEY (FacilityId),
    CONSTRAINT UQ_Facilities_NPI        UNIQUE      (NPI)
);
GO

CREATE TABLE Units (
    UnitId              INT             NOT NULL IDENTITY(1,1),
    FacilityId          INT             NOT NULL,
    UnitName            NVARCHAR(100)   NOT NULL,
    -- SNF | LTC | Memory Care | Rehab | Assisted Living | Hospice
    UnitType            NVARCHAR(30)    NOT NULL,
    FloorNumber         SMALLINT            NULL,
    IsActive            BIT             NOT NULL DEFAULT 1,
    CONSTRAINT PK_Units                 PRIMARY KEY (UnitId),
    CONSTRAINT FK_Units_Facilities      FOREIGN KEY (FacilityId)  REFERENCES Facilities(FacilityId),
    CONSTRAINT CK_Units_UnitType        CHECK (UnitType IN (
        'SNF','LTC','Memory Care','Rehab','Assisted Living','Hospice'))
);
GO

CREATE TABLE Rooms (
    RoomId              INT             NOT NULL IDENTITY(1,1),
    UnitId              INT             NOT NULL,
    RoomNumber          NVARCHAR(10)    NOT NULL,
    -- Private | Semi-Private | Ward
    RoomType            NVARCHAR(20)    NOT NULL,
    Capacity            TINYINT         NOT NULL DEFAULT 1,
    IsADAAccessible     BIT             NOT NULL DEFAULT 0,
    IsBariatric         BIT             NOT NULL DEFAULT 0,
    IsActive            BIT             NOT NULL DEFAULT 1,
    CONSTRAINT PK_Rooms                 PRIMARY KEY (RoomId),
    CONSTRAINT FK_Rooms_Units           FOREIGN KEY (UnitId)      REFERENCES Units(UnitId),
    CONSTRAINT CK_Rooms_Capacity        CHECK (Capacity BETWEEN 1 AND 4),
    CONSTRAINT UQ_Rooms_Number          UNIQUE (UnitId, RoomNumber)
);
GO

CREATE TABLE Beds (
    BedId               INT             NOT NULL IDENTITY(1,1),
    RoomId              INT             NOT NULL,
    BedLabel            NVARCHAR(10)    NOT NULL,
    -- Vacant | Occupied | Reserved | Housekeeping | Offline
    BedStatus           NVARCHAR(20)    NOT NULL DEFAULT 'Vacant',
    IsActive            BIT             NOT NULL DEFAULT 1,
    CONSTRAINT PK_Beds                  PRIMARY KEY (BedId),
    CONSTRAINT FK_Beds_Rooms            FOREIGN KEY (RoomId)      REFERENCES Rooms(RoomId),
    CONSTRAINT CK_Beds_Status           CHECK (BedStatus IN (
        'Vacant','Occupied','Reserved','Housekeeping','Offline')),
    CONSTRAINT UQ_Beds_Label            UNIQUE (RoomId, BedLabel)
);
GO

-- ============================================================
-- SECTION 2 : STAFF
-- ============================================================

CREATE TABLE Departments (
    DepartmentId        INT             NOT NULL IDENTITY(1,1),
    FacilityId          INT             NOT NULL,
    DepartmentName      NVARCHAR(100)   NOT NULL,
    CONSTRAINT PK_Departments           PRIMARY KEY (DepartmentId),
    CONSTRAINT FK_Departments_Facility  FOREIGN KEY (FacilityId)  REFERENCES Facilities(FacilityId),
    CONSTRAINT UQ_Departments_Name      UNIQUE (FacilityId, DepartmentName)
);
GO

CREATE TABLE Staff (
    StaffId             INT             NOT NULL IDENTITY(1,1),
    FacilityId          INT             NOT NULL,
    DepartmentId        INT             NOT NULL,
    EmployeeId          NVARCHAR(20)    NOT NULL,
    FirstName           NVARCHAR(100)   NOT NULL,
    LastName            NVARCHAR(100)   NOT NULL,
    -- Role values match REQUIREMENTS.md §2.2 role list
    Role                NVARCHAR(50)    NOT NULL,
    -- Full-Time | Part-Time | Agency | PRN | Contract
    EmploymentType      NVARCHAR(20)    NOT NULL DEFAULT 'Full-Time',
    HireDate            DATE            NOT NULL,
    TerminationDate     DATE                NULL,
    Email               NVARCHAR(200)   NOT NULL,
    PhoneNumber         NVARCHAR(20)        NULL,
    IsActive            BIT             NOT NULL DEFAULT 1,
    CreatedAt           DATETIME2       NOT NULL DEFAULT SYSUTCDATETIME(),
    CONSTRAINT PK_Staff                 PRIMARY KEY (StaffId),
    CONSTRAINT FK_Staff_Facility        FOREIGN KEY (FacilityId)   REFERENCES Facilities(FacilityId),
    CONSTRAINT FK_Staff_Department      FOREIGN KEY (DepartmentId) REFERENCES Departments(DepartmentId),
    CONSTRAINT UQ_Staff_EmployeeId      UNIQUE (FacilityId, EmployeeId),
    CONSTRAINT UQ_Staff_Email           UNIQUE (Email),
    CONSTRAINT CK_Staff_EmploymentType  CHECK (EmploymentType IN (
        'Full-Time','Part-Time','Agency','PRN','Contract')),
    CONSTRAINT CK_Staff_Role            CHECK (Role IN (
        'Physician','RN','LPN','CNA','Administrator','DON',
        'Social Worker','Dietitian','Physical Therapist',
        'Occupational Therapist','Speech Language Pathologist',
        'Pharmacist','Billing Specialist','Admissions Coordinator',
        'Receptionist','MDS Coordinator','Super Admin'))
);
GO

CREATE TABLE StaffCredentials (
    CredentialId        INT             NOT NULL IDENTITY(1,1),
    StaffId             INT             NOT NULL,
    CredentialType      NVARCHAR(100)   NOT NULL,
    LicenseNumber       NVARCHAR(50)        NULL,
    IssuingState        CHAR(2)             NULL,
    IssueDate           DATE                NULL,
    ExpiryDate          DATE            NOT NULL,
    IsVerified          BIT             NOT NULL DEFAULT 0,
    VerifiedByStaffId   INT                 NULL,
    VerifiedAt          DATETIME2           NULL,
    Notes               NVARCHAR(500)       NULL,
    CONSTRAINT PK_StaffCredentials      PRIMARY KEY (CredentialId),
    CONSTRAINT FK_Creds_Staff           FOREIGN KEY (StaffId)          REFERENCES Staff(StaffId),
    CONSTRAINT FK_Creds_Verifier        FOREIGN KEY (VerifiedByStaffId) REFERENCES Staff(StaffId)
);
GO

-- ============================================================
-- SECTION 3 : RESIDENTS
-- ============================================================

CREATE TABLE Residents (
    ResidentId          INT             NOT NULL IDENTITY(1,1),
    FacilityId          INT             NOT NULL,
    FirstName           NVARCHAR(100)   NOT NULL,
    MiddleName          NVARCHAR(100)       NULL,
    LastName            NVARCHAR(100)   NOT NULL,
    PreferredName       NVARCHAR(100)       NULL,
    DateOfBirth         DATE            NOT NULL,
    -- Male | Female | Non-Binary | Other | Unknown
    Gender              NVARCHAR(20)    NOT NULL,
    -- Stored encrypted at application layer (Always Encrypted / AES-256)
    SSN                 NVARCHAR(11)        NULL,
    MaritalStatus       NVARCHAR(20)        NULL,
    PrimaryLanguage     NVARCHAR(50)    NOT NULL DEFAULT 'English',
    Religion            NVARCHAR(50)        NULL,
    NationalOrigin      NVARCHAR(50)        NULL,
    PhotoPath           NVARCHAR(500)       NULL,   -- Azure Blob Storage path
    IsActive            BIT             NOT NULL DEFAULT 1,
    CreatedAt           DATETIME2       NOT NULL DEFAULT SYSUTCDATETIME(),
    CreatedByStaffId    INT             NOT NULL,
    CONSTRAINT PK_Residents             PRIMARY KEY (ResidentId),
    CONSTRAINT FK_Residents_Facility    FOREIGN KEY (FacilityId)      REFERENCES Facilities(FacilityId),
    CONSTRAINT FK_Residents_CreatedBy   FOREIGN KEY (CreatedByStaffId) REFERENCES Staff(StaffId),
    CONSTRAINT CK_Residents_Gender      CHECK (Gender IN (
        'Male','Female','Non-Binary','Other','Unknown'))
);
GO

CREATE TABLE ResidentContacts (
    ContactId           INT             NOT NULL IDENTITY(1,1),
    ResidentId          INT             NOT NULL,
    FullName            NVARCHAR(200)   NOT NULL,
    Relationship        NVARCHAR(50)    NOT NULL,
    Phone               NVARCHAR(20)        NULL,
    AltPhone            NVARCHAR(20)        NULL,
    Email               NVARCHAR(200)       NULL,
    AddressLine1        NVARCHAR(200)       NULL,
    City                NVARCHAR(100)       NULL,
    StateCode           CHAR(2)             NULL,
    ZipCode             NVARCHAR(10)        NULL,
    IsPrimary           BIT             NOT NULL DEFAULT 0,
    IsEmergency         BIT             NOT NULL DEFAULT 0,
    IsLegalRep          BIT             NOT NULL DEFAULT 0,   -- POA / Guardian
    IsBillingContact    BIT             NOT NULL DEFAULT 0,
    PreferredContactMethod NVARCHAR(20)     NULL,
    CONSTRAINT PK_ResidentContacts      PRIMARY KEY (ContactId),
    CONSTRAINT FK_Contacts_Resident     FOREIGN KEY (ResidentId) REFERENCES Residents(ResidentId)
);
GO

CREATE TABLE Allergies (
    AllergyId           INT             NOT NULL IDENTITY(1,1),
    ResidentId          INT             NOT NULL,
    Allergen            NVARCHAR(200)   NOT NULL,
    -- Drug | Food | Environmental | Latex | Contrast | Other
    AllergyType         NVARCHAR(30)    NOT NULL,
    -- Mild | Moderate | Severe | Life-Threatening | Unknown
    Severity            NVARCHAR(20)    NOT NULL,
    Reaction            NVARCHAR(500)       NULL,
    OnsetDate           DATE                NULL,
    DocumentedAt        DATETIME2       NOT NULL DEFAULT SYSUTCDATETIME(),
    DocumentedByStaffId INT             NOT NULL,
    IsActive            BIT             NOT NULL DEFAULT 1,
    CONSTRAINT PK_Allergies             PRIMARY KEY (AllergyId),
    CONSTRAINT FK_Allergies_Resident    FOREIGN KEY (ResidentId)          REFERENCES Residents(ResidentId),
    CONSTRAINT FK_Allergies_Staff       FOREIGN KEY (DocumentedByStaffId) REFERENCES Staff(StaffId),
    CONSTRAINT CK_Allergies_Type        CHECK (AllergyType IN (
        'Drug','Food','Environmental','Latex','Contrast','Other')),
    CONSTRAINT CK_Allergies_Severity    CHECK (Severity IN (
        'Mild','Moderate','Severe','Life-Threatening','Unknown'))
);
GO

CREATE TABLE AdvanceDirectives (
    DirectiveId             INT             NOT NULL IDENTITY(1,1),
    ResidentId              INT             NOT NULL,
    -- Full Code | DNR | DNR-CCA | Comfort Care Only
    DNRStatus               NVARCHAR(20)    NOT NULL DEFAULT 'Full Code',
    HasLivingWill           BIT             NOT NULL DEFAULT 0,
    HasPOLST                BIT             NOT NULL DEFAULT 0,
    HasHealthcareProxy      BIT             NOT NULL DEFAULT 0,
    HospiceCare             BIT             NOT NULL DEFAULT 0,
    ArtificialNutrition     NVARCHAR(20)        NULL,
    DocumentPath            NVARCHAR(500)       NULL,   -- Azure Blob Storage
    EffectiveDate           DATE            NOT NULL,
    WitnessedByStaffId      INT             NOT NULL,
    PhysicianSignedByStaffId INT                NULL,
    -- Previous version superseded when new directive is created
    IsSuperseded            BIT             NOT NULL DEFAULT 0,
    CreatedAt               DATETIME2       NOT NULL DEFAULT SYSUTCDATETIME(),
    CONSTRAINT PK_AdvanceDirectives     PRIMARY KEY (DirectiveId),
    CONSTRAINT FK_AdvDir_Resident       FOREIGN KEY (ResidentId)               REFERENCES Residents(ResidentId),
    CONSTRAINT FK_AdvDir_Witness        FOREIGN KEY (WitnessedByStaffId)       REFERENCES Staff(StaffId),
    CONSTRAINT FK_AdvDir_Physician      FOREIGN KEY (PhysicianSignedByStaffId) REFERENCES Staff(StaffId),
    CONSTRAINT CK_AdvDir_DNRStatus      CHECK (DNRStatus IN (
        'Full Code','DNR','DNR-CCA','Comfort Care Only'))
);
GO

-- ============================================================
-- SECTION 4 : PAYERS & INSURANCE
-- ============================================================

CREATE TABLE Payers (
    PayerId             INT             NOT NULL IDENTITY(1,1),
    PayerName           NVARCHAR(200)   NOT NULL,
    -- Medicare Part A | Medicare Part B | Medicaid | Private Insurance
    -- Managed Care | VA | Self-Pay | Other
    PayerType           NVARCHAR(30)    NOT NULL,
    NPI                 NVARCHAR(10)        NULL,
    PayerID_EDI         NVARCHAR(20)        NULL,   -- EDI 837 payer identifier
    Phone               NVARCHAR(20)        NULL,
    Website             NVARCHAR(300)       NULL,
    IsActive            BIT             NOT NULL DEFAULT 1,
    CONSTRAINT PK_Payers                PRIMARY KEY (PayerId),
    CONSTRAINT CK_Payers_Type           CHECK (PayerType IN (
        'Medicare Part A','Medicare Part B','Medicaid',
        'Private Insurance','Managed Care','VA','Self-Pay','Other'))
);
GO

CREATE TABLE ResidentInsurance (
    InsuranceId         INT             NOT NULL IDENTITY(1,1),
    ResidentId          INT             NOT NULL,
    PayerId             INT             NOT NULL,
    PolicyNumber        NVARCHAR(50)    NOT NULL,
    GroupNumber         NVARCHAR(50)        NULL,
    SubscriberName      NVARCHAR(200)       NULL,
    CoverageStartDate   DATE            NOT NULL,
    CoverageEndDate     DATE                NULL,
    -- 1 = Primary, 2 = Secondary, etc.
    Priority            TINYINT         NOT NULL DEFAULT 1,
    BenefitDaysUsed     SMALLINT            NULL,   -- Medicare SNF benefit tracking
    IsActive            BIT             NOT NULL DEFAULT 1,
    Notes               NVARCHAR(500)       NULL,
    CONSTRAINT PK_ResidentInsurance     PRIMARY KEY (InsuranceId),
    CONSTRAINT FK_ResIns_Resident       FOREIGN KEY (ResidentId) REFERENCES Residents(ResidentId),
    CONSTRAINT FK_ResIns_Payer          FOREIGN KEY (PayerId)    REFERENCES Payers(PayerId)
);
GO

-- ============================================================
-- SECTION 5 : DIAGNOSES (ICD-10 code reference)
-- ============================================================

CREATE TABLE DiagnosisCodes (
    DiagnosisCodeId     INT             NOT NULL IDENTITY(1,1),
    ICD10Code           NVARCHAR(10)    NOT NULL,
    Description         NVARCHAR(300)   NOT NULL,
    Category            NVARCHAR(100)       NULL,
    IsActive            BIT             NOT NULL DEFAULT 1,
    CONSTRAINT PK_DiagnosisCodes        PRIMARY KEY (DiagnosisCodeId),
    CONSTRAINT UQ_DiagnosisCodes_ICD10  UNIQUE (ICD10Code)
);
GO

-- ============================================================
-- SECTION 6 : ADMISSIONS, DISCHARGES, TRANSFERS
-- ============================================================

CREATE TABLE Admissions (
    AdmissionId                 INT             NOT NULL IDENTITY(1,1),
    ResidentId                  INT             NOT NULL,
    FacilityId                  INT             NOT NULL,
    BedId                       INT             NOT NULL,
    AdmittingPhysicianId        INT             NOT NULL,
    AdmissionsCoordinatorId     INT             NOT NULL,
    PrimaryInsuranceId          INT                 NULL,
    PrimaryDiagnosisCodeId      INT                 NULL,
    AdmissionDate               DATETIME2       NOT NULL,
    -- SNF Short-Term | Long-Term Care | Respite | Hospice | Assisted Living
    AdmissionType               NVARCHAR(30)    NOT NULL,
    LevelOfCare                 NVARCHAR(50)        NULL,
    ReferralSource              NVARCHAR(200)       NULL,
    ReferralFacility            NVARCHAR(200)       NULL,
    -- Active | Discharged | Transferred | Deceased | Pending
    Status                      NVARCHAR(20)    NOT NULL DEFAULT 'Active',
    CreatedAt                   DATETIME2       NOT NULL DEFAULT SYSUTCDATETIME(),
    CONSTRAINT PK_Admissions                    PRIMARY KEY (AdmissionId),
    CONSTRAINT FK_Adm_Resident                  FOREIGN KEY (ResidentId)              REFERENCES Residents(ResidentId),
    CONSTRAINT FK_Adm_Facility                  FOREIGN KEY (FacilityId)              REFERENCES Facilities(FacilityId),
    CONSTRAINT FK_Adm_Bed                       FOREIGN KEY (BedId)                   REFERENCES Beds(BedId),
    CONSTRAINT FK_Adm_Physician                 FOREIGN KEY (AdmittingPhysicianId)    REFERENCES Staff(StaffId),
    CONSTRAINT FK_Adm_Coordinator               FOREIGN KEY (AdmissionsCoordinatorId) REFERENCES Staff(StaffId),
    CONSTRAINT FK_Adm_Insurance                 FOREIGN KEY (PrimaryInsuranceId)      REFERENCES ResidentInsurance(InsuranceId),
    CONSTRAINT FK_Adm_Diagnosis                 FOREIGN KEY (PrimaryDiagnosisCodeId)  REFERENCES DiagnosisCodes(DiagnosisCodeId),
    CONSTRAINT CK_Admissions_Type               CHECK (AdmissionType IN (
        'SNF Short-Term','Long-Term Care','Respite','Hospice','Assisted Living')),
    CONSTRAINT CK_Admissions_Status             CHECK (Status IN (
        'Active','Discharged','Transferred','Deceased','Pending'))
);
GO

CREATE TABLE Discharges (
    DischargeId             INT             NOT NULL IDENTITY(1,1),
    AdmissionId             INT             NOT NULL,
    DischargedByStaffId     INT             NOT NULL,
    DischargeDate           DATETIME2       NOT NULL,
    -- Home | Hospital | Another Facility | Deceased | AMA | Hospice | Other
    DischargeReason         NVARCHAR(50)    NOT NULL,
    DischargeDestination    NVARCHAR(200)       NULL,
    FollowUpProvider        NVARCHAR(200)       NULL,
    -- Azure Blob path to discharge summary PDF
    SummaryDocPath          NVARCHAR(500)       NULL,
    Notes                   NVARCHAR(1000)      NULL,
    CreatedAt               DATETIME2       NOT NULL DEFAULT SYSUTCDATETIME(),
    CONSTRAINT PK_Discharges                PRIMARY KEY (DischargeId),
    CONSTRAINT FK_Discharge_Admission       FOREIGN KEY (AdmissionId)         REFERENCES Admissions(AdmissionId),
    CONSTRAINT FK_Discharge_Staff           FOREIGN KEY (DischargedByStaffId) REFERENCES Staff(StaffId),
    -- One admission yields exactly one discharge record
    CONSTRAINT UQ_Discharges_Admission      UNIQUE (AdmissionId),
    CONSTRAINT CK_Discharges_Reason         CHECK (DischargeReason IN (
        'Home','Hospital','Another Facility','Deceased','AMA',
        'Hospice','Assisted Living','Other'))
);
GO

CREATE TABLE Transfers (
    TransferId              INT             NOT NULL IDENTITY(1,1),
    AdmissionId             INT             NOT NULL,
    -- Internal | External - Hospital | External - Specialist | External - Other
    TransferType            NVARCHAR(40)    NOT NULL,
    TransferDate            DATETIME2       NOT NULL,
    FromBedId               INT                 NULL,
    ToBedId                 INT                 NULL,   -- NULL for external transfers
    ExternalFacilityName    NVARCHAR(200)       NULL,
    Reason                  NVARCHAR(500)   NOT NULL,
    TransportMethod         NVARCHAR(50)        NULL,
    InitiatedByStaffId      INT             NOT NULL,
    ReturnExpected          BIT             NOT NULL DEFAULT 0,
    ReturnDate              DATETIME2           NULL,
    CreatedAt               DATETIME2       NOT NULL DEFAULT SYSUTCDATETIME(),
    CONSTRAINT PK_Transfers                 PRIMARY KEY (TransferId),
    CONSTRAINT FK_Transfer_Admission        FOREIGN KEY (AdmissionId)        REFERENCES Admissions(AdmissionId),
    CONSTRAINT FK_Transfer_FromBed          FOREIGN KEY (FromBedId)          REFERENCES Beds(BedId),
    CONSTRAINT FK_Transfer_ToBed            FOREIGN KEY (ToBedId)            REFERENCES Beds(BedId),
    CONSTRAINT FK_Transfer_Staff            FOREIGN KEY (InitiatedByStaffId) REFERENCES Staff(StaffId),
    CONSTRAINT CK_Transfer_Type             CHECK (TransferType IN (
        'Internal','External - Hospital','External - Specialist','External - Other'))
);
GO

CREATE TABLE ResidentDiagnoses (
    ResidentDiagnosisId     INT             NOT NULL IDENTITY(1,1),
    ResidentId              INT             NOT NULL,
    AdmissionId             INT             NOT NULL,
    DiagnosisCodeId         INT             NOT NULL,
    DiagnosedByStaffId      INT             NOT NULL,
    -- Primary | Secondary | Comorbidity | History
    DiagnosisType           NVARCHAR(20)    NOT NULL DEFAULT 'Secondary',
    OnsetDate               DATE                NULL,
    ResolvedDate            DATE                NULL,
    DiagnosedAt             DATETIME2       NOT NULL DEFAULT SYSUTCDATETIME(),
    Notes                   NVARCHAR(500)       NULL,
    IsActive                BIT             NOT NULL DEFAULT 1,
    CONSTRAINT PK_ResidentDiagnoses         PRIMARY KEY (ResidentDiagnosisId),
    CONSTRAINT FK_ResDx_Resident            FOREIGN KEY (ResidentId)         REFERENCES Residents(ResidentId),
    CONSTRAINT FK_ResDx_Admission           FOREIGN KEY (AdmissionId)        REFERENCES Admissions(AdmissionId),
    CONSTRAINT FK_ResDx_DiagCode            FOREIGN KEY (DiagnosisCodeId)    REFERENCES DiagnosisCodes(DiagnosisCodeId),
    CONSTRAINT FK_ResDx_Staff               FOREIGN KEY (DiagnosedByStaffId) REFERENCES Staff(StaffId),
    CONSTRAINT CK_ResDx_Type                CHECK (DiagnosisType IN (
        'Primary','Secondary','Comorbidity','History'))
);
GO

-- ============================================================
-- SECTION 7 : CLINICAL — VITALS & ASSESSMENTS
-- ============================================================

CREATE TABLE VitalSigns (
    VitalId             INT             NOT NULL IDENTITY(1,1),
    ResidentId          INT             NOT NULL,
    AdmissionId         INT             NOT NULL,
    RecordedByStaffId   INT             NOT NULL,
    RecordedAt          DATETIME2       NOT NULL DEFAULT SYSUTCDATETIME(),
    SystolicBP          SMALLINT            NULL,
    DiastolicBP         SMALLINT            NULL,
    HeartRate           SMALLINT            NULL,
    RespiratoryRate     SMALLINT            NULL,
    TemperatureF        DECIMAL(4,1)        NULL,
    SpO2                TINYINT             NULL,   -- %
    WeightLbs           DECIMAL(5,1)        NULL,
    BloodGlucose        SMALLINT            NULL,   -- mg/dL
    PainScore           TINYINT             NULL,   -- 0-10
    Notes               NVARCHAR(500)       NULL,
    CONSTRAINT PK_VitalSigns            PRIMARY KEY (VitalId),
    CONSTRAINT FK_Vitals_Resident       FOREIGN KEY (ResidentId)        REFERENCES Residents(ResidentId),
    CONSTRAINT FK_Vitals_Admission      FOREIGN KEY (AdmissionId)       REFERENCES Admissions(AdmissionId),
    CONSTRAINT FK_Vitals_Staff          FOREIGN KEY (RecordedByStaffId) REFERENCES Staff(StaffId),
    CONSTRAINT CK_Vitals_PainScore      CHECK (PainScore BETWEEN 0 AND 10),
    CONSTRAINT CK_Vitals_SpO2           CHECK (SpO2 BETWEEN 0 AND 100)
);
GO

CREATE TABLE ClinicalAssessments (
    AssessmentId            INT             NOT NULL IDENTITY(1,1),
    ResidentId              INT             NOT NULL,
    AdmissionId             INT             NOT NULL,
    AssessedByStaffId       INT             NOT NULL,
    -- MDS 3.0 | Braden Scale | Falls Risk (MFS) | MMSE | BIMS
    -- PHQ-9 | GDS | PAINAD | MNA | Nutritional | ADL Baseline | Other
    AssessmentType          NVARCHAR(50)    NOT NULL,
    AssessedAt              DATETIME2       NOT NULL DEFAULT SYSUTCDATETIME(),
    Score                   DECIMAL(5,2)        NULL,
    -- Low | Moderate | High
    RiskLevel               NVARCHAR(20)        NULL,
    -- Semi-structured JSON for variable assessment fields
    AssessmentData          NVARCHAR(MAX)       NULL,
    NextAssessmentDate      DATE                NULL,
    IsSubmittedToRegulator  BIT             NOT NULL DEFAULT 0,
    Notes                   NVARCHAR(1000)      NULL,
    CONSTRAINT PK_Assessments           PRIMARY KEY (AssessmentId),
    CONSTRAINT FK_Assess_Resident       FOREIGN KEY (ResidentId)        REFERENCES Residents(ResidentId),
    CONSTRAINT FK_Assess_Admission      FOREIGN KEY (AdmissionId)       REFERENCES Admissions(AdmissionId),
    CONSTRAINT FK_Assess_Staff          FOREIGN KEY (AssessedByStaffId) REFERENCES Staff(StaffId),
    CONSTRAINT CK_Assess_Type           CHECK (AssessmentType IN (
        'MDS 3.0','Braden Scale','Falls Risk (MFS)','MMSE','BIMS',
        'PHQ-9','GDS','PAINAD','MNA','Nutritional','ADL Baseline','Other'))
);
GO

-- ============================================================
-- SECTION 8 : MEDICATIONS
-- ============================================================

CREATE TABLE DrugMaster (
    DrugId              INT             NOT NULL IDENTITY(1,1),
    GenericName         NVARCHAR(200)   NOT NULL,
    BrandName           NVARCHAR(200)       NULL,
    DrugClass           NVARCHAR(100)       NULL,
    -- II | III | IV | V | Non-Controlled
    DEASchedule         NVARCHAR(15)        NULL,
    IsControlled        BIT             NOT NULL DEFAULT 0,
    DefaultDoseUnit     NVARCHAR(20)        NULL,   -- mg | mcg | mL | units
    RouteOptions        NVARCHAR(200)       NULL,   -- CSV: PO,IV,IM,SubQ
    MinDose             DECIMAL(10,3)       NULL,
    MaxDose             DECIMAL(10,3)       NULL,
    IsActive            BIT             NOT NULL DEFAULT 1,
    CONSTRAINT PK_DrugMaster            PRIMARY KEY (DrugId)
);
GO

CREATE TABLE MedicationOrders (
    OrderId                     INT             NOT NULL IDENTITY(1,1),
    ResidentId                  INT             NOT NULL,
    AdmissionId                 INT             NOT NULL,
    DrugId                      INT             NOT NULL,
    OrderedByStaffId            INT             NOT NULL,
    VerifiedByPharmacistId      INT                 NULL,
    PharmacistVerifiedAt        DATETIME2           NULL,
    Dose                        NVARCHAR(50)    NOT NULL,
    DoseUnit                    NVARCHAR(20)    NOT NULL,
    Route                       NVARCHAR(50)    NOT NULL,
    Frequency                   NVARCHAR(100)   NOT NULL,
    Indication                  NVARCHAR(300)       NULL,
    SpecialInstructions         NVARCHAR(500)       NULL,
    StartDate                   DATE            NOT NULL,
    StopDate                    DATE                NULL,
    IsPRN                       BIT             NOT NULL DEFAULT 0,
    PRNIndication               NVARCHAR(300)       NULL,
    MaxDailyDose                NVARCHAR(50)        NULL,
    -- Active | Discontinued | On Hold | Completed | Pending Verification
    OrderStatus                 NVARCHAR(30)    NOT NULL DEFAULT 'Active',
    OrderedAt                   DATETIME2       NOT NULL DEFAULT SYSUTCDATETIME(),
    DiscontinuedAt              DATETIME2           NULL,
    DiscontinuedByStaffId       INT                 NULL,
    DiscontinuedReason          NVARCHAR(300)       NULL,
    CONSTRAINT PK_MedOrders                 PRIMARY KEY (OrderId),
    CONSTRAINT FK_MedOrd_Resident           FOREIGN KEY (ResidentId)            REFERENCES Residents(ResidentId),
    CONSTRAINT FK_MedOrd_Admission          FOREIGN KEY (AdmissionId)           REFERENCES Admissions(AdmissionId),
    CONSTRAINT FK_MedOrd_Drug               FOREIGN KEY (DrugId)                REFERENCES DrugMaster(DrugId),
    CONSTRAINT FK_MedOrd_Physician          FOREIGN KEY (OrderedByStaffId)      REFERENCES Staff(StaffId),
    CONSTRAINT FK_MedOrd_Pharmacist         FOREIGN KEY (VerifiedByPharmacistId) REFERENCES Staff(StaffId),
    CONSTRAINT FK_MedOrd_Discontinuer       FOREIGN KEY (DiscontinuedByStaffId) REFERENCES Staff(StaffId),
    CONSTRAINT CK_MedOrd_Status             CHECK (OrderStatus IN (
        'Active','Discontinued','On Hold','Completed','Pending Verification'))
);
GO

CREATE TABLE MedicationSchedules (
    ScheduleId          INT             NOT NULL IDENTITY(1,1),
    OrderId             INT             NOT NULL,
    ScheduledTime       TIME            NOT NULL,
    -- NULL = every day; otherwise CSV: 'Mon,Wed,Fri'
    DayOfWeek           NVARCHAR(50)        NULL,
    IsActive            BIT             NOT NULL DEFAULT 1,
    CONSTRAINT PK_MedSchedules          PRIMARY KEY (ScheduleId),
    CONSTRAINT FK_MedSched_Order        FOREIGN KEY (OrderId) REFERENCES MedicationOrders(OrderId)
);
GO

CREATE TABLE MedicationAdministrations (
    AdministrationId        INT             NOT NULL IDENTITY(1,1),
    OrderId                 INT             NOT NULL,
    ScheduleId              INT                 NULL,
    ResidentId              INT             NOT NULL,
    DrugId                  INT             NOT NULL,
    AdministeredByStaffId   INT             NOT NULL,
    -- Required witness signature for controlled substances
    WitnessStaffId          INT                 NULL,
    AdministeredAt          DATETIME2       NOT NULL,
    DoseGiven               NVARCHAR(50)    NOT NULL,
    DoseUnit                NVARCHAR(20)    NOT NULL,
    Route                   NVARCHAR(50)    NOT NULL,
    AdministrationSite      NVARCHAR(100)       NULL,   -- For injectables
    -- Given | Refused | Held | Not Available | Omitted | Self-Administered | Wasted
    AdminStatus             NVARCHAR(30)    NOT NULL DEFAULT 'Given',
    RefusalReason           NVARCHAR(300)       NULL,
    HoldReason              NVARCHAR(300)       NULL,
    ResidentScanVerified    BIT             NOT NULL DEFAULT 0,
    MedScanVerified         BIT             NOT NULL DEFAULT 0,
    Notes                   NVARCHAR(500)       NULL,
    CreatedAt               DATETIME2       NOT NULL DEFAULT SYSUTCDATETIME(),
    CONSTRAINT PK_MedAdmin              PRIMARY KEY (AdministrationId),
    CONSTRAINT FK_MedAdm_Order          FOREIGN KEY (OrderId)                REFERENCES MedicationOrders(OrderId),
    CONSTRAINT FK_MedAdm_Schedule       FOREIGN KEY (ScheduleId)             REFERENCES MedicationSchedules(ScheduleId),
    CONSTRAINT FK_MedAdm_Resident       FOREIGN KEY (ResidentId)             REFERENCES Residents(ResidentId),
    CONSTRAINT FK_MedAdm_Drug           FOREIGN KEY (DrugId)                 REFERENCES DrugMaster(DrugId),
    CONSTRAINT FK_MedAdm_Staff          FOREIGN KEY (AdministeredByStaffId)  REFERENCES Staff(StaffId),
    CONSTRAINT FK_MedAdm_Witness        FOREIGN KEY (WitnessStaffId)         REFERENCES Staff(StaffId),
    CONSTRAINT CK_MedAdm_Status         CHECK (AdminStatus IN (
        'Given','Refused','Held','Not Available','Omitted','Self-Administered','Wasted'))
);
GO

CREATE TABLE PRNEffectiveness (
    EffectivenessId     INT             NOT NULL IDENTITY(1,1),
    AdministrationId    INT             NOT NULL,
    AssessedByStaffId   INT             NOT NULL,
    AssessedAt          DATETIME2       NOT NULL DEFAULT SYSUTCDATETIME(),
    SymptomScorePre     TINYINT             NULL,
    SymptomScorePost    TINYINT             NULL,
    EffectivenessNote   NVARCHAR(500)       NULL,
    CONSTRAINT PK_PRNEffectiveness      PRIMARY KEY (EffectivenessId),
    CONSTRAINT FK_PRN_Admin             FOREIGN KEY (AdministrationId) REFERENCES MedicationAdministrations(AdministrationId),
    CONSTRAINT FK_PRN_Staff             FOREIGN KEY (AssessedByStaffId) REFERENCES Staff(StaffId),
    -- One effectiveness assessment per administration
    CONSTRAINT UQ_PRN_Admin             UNIQUE (AdministrationId)
);
GO

CREATE TABLE DrugInteractionLog (
    InteractionLogId        INT             NOT NULL IDENTITY(1,1),
    NewOrderId              INT             NOT NULL,
    ConflictingOrderId      INT                 NULL,
    Drug1Id                 INT             NOT NULL,
    Drug2Id                 INT                 NULL,
    AllergyId               INT                 NULL,
    -- DDI | Drug-Allergy | Dose-Range
    InteractionType         NVARCHAR(20)    NOT NULL,
    -- Critical | Serious | Moderate | Minor
    SeverityLevel           NVARCHAR(20)    NOT NULL,
    AlertText               NVARCHAR(1000)  NOT NULL,
    IsOverridden            BIT             NOT NULL DEFAULT 0,
    OverriddenByStaffId     INT                 NULL,
    OverrideReason          NVARCHAR(500)       NULL,
    OverriddenAt            DATETIME2           NULL,
    LoggedAt                DATETIME2       NOT NULL DEFAULT SYSUTCDATETIME(),
    CONSTRAINT PK_DDILog                PRIMARY KEY (InteractionLogId),
    CONSTRAINT FK_DDI_NewOrder          FOREIGN KEY (NewOrderId)           REFERENCES MedicationOrders(OrderId),
    CONSTRAINT FK_DDI_Drug1             FOREIGN KEY (Drug1Id)              REFERENCES DrugMaster(DrugId),
    CONSTRAINT FK_DDI_Drug2             FOREIGN KEY (Drug2Id)              REFERENCES DrugMaster(DrugId),
    CONSTRAINT FK_DDI_Allergy           FOREIGN KEY (AllergyId)            REFERENCES Allergies(AllergyId),
    CONSTRAINT FK_DDI_Override          FOREIGN KEY (OverriddenByStaffId)  REFERENCES Staff(StaffId),
    CONSTRAINT CK_DDI_Severity          CHECK (SeverityLevel IN ('Critical','Serious','Moderate','Minor'))
);
GO

-- ============================================================
-- SECTION 9 : CARE PLANS
-- ============================================================

CREATE TABLE CarePlans (
    CarePlanId          INT             NOT NULL IDENTITY(1,1),
    ResidentId          INT             NOT NULL,
    AdmissionId         INT             NOT NULL,
    CreatedByStaffId    INT             NOT NULL,
    CreatedAt           DATETIME2       NOT NULL DEFAULT SYSUTCDATETIME(),
    -- Weekly | Monthly | Quarterly | Annually | As Needed
    ReviewFrequency     NVARCHAR(20)    NOT NULL DEFAULT 'Quarterly',
    NextReviewDate      DATE                NULL,
    -- Draft | Active | Reviewed | Superseded | Archived
    Status              NVARCHAR(20)    NOT NULL DEFAULT 'Active',
    Version             SMALLINT        NOT NULL DEFAULT 1,
    CONSTRAINT PK_CarePlans             PRIMARY KEY (CarePlanId),
    CONSTRAINT FK_CP_Resident           FOREIGN KEY (ResidentId)       REFERENCES Residents(ResidentId),
    CONSTRAINT FK_CP_Admission          FOREIGN KEY (AdmissionId)      REFERENCES Admissions(AdmissionId),
    CONSTRAINT FK_CP_Staff              FOREIGN KEY (CreatedByStaffId) REFERENCES Staff(StaffId),
    CONSTRAINT CK_CP_Status             CHECK (Status IN (
        'Draft','Active','Reviewed','Superseded','Archived')),
    CONSTRAINT CK_CP_ReviewFreq         CHECK (ReviewFrequency IN (
        'Weekly','Monthly','Quarterly','Annually','As Needed'))
);
GO

CREATE TABLE CarePlanProblems (
    ProblemId               INT             NOT NULL IDENTITY(1,1),
    CarePlanId              INT             NOT NULL,
    AddedByStaffId          INT             NOT NULL,
    ProblemDescription      NVARCHAR(500)   NOT NULL,
    NANDACode               NVARCHAR(20)        NULL,
    OnsetDate               DATE                NULL,
    TargetResolutionDate    DATE                NULL,
    ResolvedDate            DATE                NULL,
    -- Active | Resolved | Monitored | On Hold
    Status                  NVARCHAR(20)    NOT NULL DEFAULT 'Active',
    -- 1 = High | 2 = Medium | 3 = Low
    Priority                TINYINT         NOT NULL DEFAULT 2,
    AddedAt                 DATETIME2       NOT NULL DEFAULT SYSUTCDATETIME(),
    CONSTRAINT PK_CPProblems            PRIMARY KEY (ProblemId),
    CONSTRAINT FK_CPProb_CarePlan       FOREIGN KEY (CarePlanId)      REFERENCES CarePlans(CarePlanId),
    CONSTRAINT FK_CPProb_Staff          FOREIGN KEY (AddedByStaffId)  REFERENCES Staff(StaffId),
    CONSTRAINT CK_CPProb_Status         CHECK (Status IN (
        'Active','Resolved','Monitored','On Hold'))
);
GO

CREATE TABLE CarePlanGoals (
    GoalId              INT             NOT NULL IDENTITY(1,1),
    ProblemId           INT             NOT NULL,
    AddedByStaffId      INT             NOT NULL,
    GoalDescription     NVARCHAR(500)   NOT NULL,
    -- Short-Term | Long-Term
    GoalType            NVARCHAR(20)    NOT NULL,
    TargetDate          DATE                NULL,
    AchievedDate        DATE                NULL,
    -- In Progress | Achieved | Not Met | Revised | Discontinued
    Status              NVARCHAR(20)    NOT NULL DEFAULT 'In Progress',
    AddedAt             DATETIME2       NOT NULL DEFAULT SYSUTCDATETIME(),
    CONSTRAINT PK_CPGoals               PRIMARY KEY (GoalId),
    CONSTRAINT FK_CPGoal_Problem        FOREIGN KEY (ProblemId)      REFERENCES CarePlanProblems(ProblemId),
    CONSTRAINT FK_CPGoal_Staff          FOREIGN KEY (AddedByStaffId) REFERENCES Staff(StaffId),
    CONSTRAINT CK_CPGoal_Type           CHECK (GoalType IN ('Short-Term','Long-Term')),
    CONSTRAINT CK_CPGoal_Status         CHECK (Status IN (
        'In Progress','Achieved','Not Met','Revised','Discontinued'))
);
GO

CREATE TABLE CarePlanInterventions (
    InterventionId              INT             NOT NULL IDENTITY(1,1),
    ProblemId                   INT             NOT NULL,
    AddedByStaffId              INT             NOT NULL,
    AssignedStaffId             INT                 NULL,
    InterventionDescription     NVARCHAR(500)   NOT NULL,
    FrequencyNotes              NVARCHAR(200)       NULL,
    ResponsibleDiscipline       NVARCHAR(50)    NOT NULL,
    StartDate                   DATE            NOT NULL,
    EndDate                     DATE                NULL,
    -- Active | Discontinued | Completed
    Status                      NVARCHAR(20)    NOT NULL DEFAULT 'Active',
    AddedAt                     DATETIME2       NOT NULL DEFAULT SYSUTCDATETIME(),
    CONSTRAINT PK_CPInterv              PRIMARY KEY (InterventionId),
    CONSTRAINT FK_CPInterv_Problem      FOREIGN KEY (ProblemId)       REFERENCES CarePlanProblems(ProblemId),
    CONSTRAINT FK_CPInterv_AddedBy      FOREIGN KEY (AddedByStaffId)  REFERENCES Staff(StaffId),
    CONSTRAINT FK_CPInterv_Assigned     FOREIGN KEY (AssignedStaffId) REFERENCES Staff(StaffId),
    CONSTRAINT CK_CPInterv_Status       CHECK (Status IN (
        'Active','Discontinued','Completed'))
);
GO

CREATE TABLE CarePlanReviews (
    ReviewId            INT             NOT NULL IDENTITY(1,1),
    CarePlanId          INT             NOT NULL,
    ReviewedByStaffId   INT             NOT NULL,
    ReviewDate          DATETIME2       NOT NULL DEFAULT SYSUTCDATETIME(),
    -- Scheduled | Quarterly | Annual | Triggered | Admission | Discharge | Clinical Change
    ReviewType          NVARCHAR(30)    NOT NULL DEFAULT 'Scheduled',
    ReviewNotes         NVARCHAR(2000)      NULL,
    NextReviewDate      DATE            NOT NULL,
    IsSignedOff         BIT             NOT NULL DEFAULT 0,
    SignedOffAt         DATETIME2           NULL,
    CONSTRAINT PK_CPReviews             PRIMARY KEY (ReviewId),
    CONSTRAINT FK_CPReview_CarePlan     FOREIGN KEY (CarePlanId)        REFERENCES CarePlans(CarePlanId),
    CONSTRAINT FK_CPReview_Staff        FOREIGN KEY (ReviewedByStaffId) REFERENCES Staff(StaffId),
    CONSTRAINT CK_CPReview_Type         CHECK (ReviewType IN (
        'Scheduled','Quarterly','Annual','Triggered',
        'Admission','Discharge','Clinical Change'))
);
GO

-- ============================================================
-- SECTION 10 : INCIDENTS
-- ============================================================

CREATE TABLE IncidentCategories (
    CategoryId              INT             NOT NULL IDENTITY(1,1),
    CategoryName            NVARCHAR(100)   NOT NULL,
    IsStateReportable       BIT             NOT NULL DEFAULT 0,
    -- Hours from discovery to required state report; NULL if not reportable
    ReportingWindowHours    SMALLINT            NULL,
    CONSTRAINT PK_IncidentCategories    PRIMARY KEY (CategoryId),
    CONSTRAINT UQ_IncidentCat_Name      UNIQUE (CategoryName)
);
GO

CREATE TABLE IncidentReports (
    IncidentId                      INT             NOT NULL IDENTITY(1,1),
    ResidentId                      INT             NOT NULL,
    FacilityId                      INT             NOT NULL,
    ReportedByStaffId               INT             NOT NULL,
    CategoryId                      INT             NOT NULL,
    PhysicianNotifiedByStaffId      INT                 NULL,
    FamilyNotifiedByStaffId         INT                 NULL,
    IncidentDate                    DATETIME2       NOT NULL,
    ReportedAt                      DATETIME2       NOT NULL DEFAULT SYSUTCDATETIME(),
    Location                        NVARCHAR(200)       NULL,
    NarrativeDescription            NVARCHAR(2000)  NOT NULL,
    ImmediateActionsTaken           NVARCHAR(1000)      NULL,
    -- Minor | Moderate | Major | Critical | Sentinel
    Severity                        NVARCHAR(20)    NOT NULL DEFAULT 'Minor',
    PhysicianNotifiedAt             DATETIME2           NULL,
    FamilyNotifiedAt                DATETIME2           NULL,
    StateReportedAt                 DATETIME2           NULL,
    StateReportRef                  NVARCHAR(100)       NULL,
    -- Open | Under Investigation | Pending Review | Closed | Reported to State
    Status                          NVARCHAR(30)    NOT NULL DEFAULT 'Open',
    CONSTRAINT PK_IncidentReports                   PRIMARY KEY (IncidentId),
    CONSTRAINT FK_Inc_Resident                      FOREIGN KEY (ResidentId)                   REFERENCES Residents(ResidentId),
    CONSTRAINT FK_Inc_Facility                      FOREIGN KEY (FacilityId)                   REFERENCES Facilities(FacilityId),
    CONSTRAINT FK_Inc_Reporter                      FOREIGN KEY (ReportedByStaffId)            REFERENCES Staff(StaffId),
    CONSTRAINT FK_Inc_Category                      FOREIGN KEY (CategoryId)                   REFERENCES IncidentCategories(CategoryId),
    CONSTRAINT FK_Inc_PhysNotif                     FOREIGN KEY (PhysicianNotifiedByStaffId)   REFERENCES Staff(StaffId),
    CONSTRAINT FK_Inc_FamNotif                      FOREIGN KEY (FamilyNotifiedByStaffId)      REFERENCES Staff(StaffId),
    CONSTRAINT CK_Inc_Severity                      CHECK (Severity IN (
        'Minor','Moderate','Major','Critical','Sentinel')),
    CONSTRAINT CK_Inc_Status                        CHECK (Status IN (
        'Open','Under Investigation','Pending Review',
        'Closed','Reported to State'))
);
GO

CREATE TABLE IncidentWitnesses (
    WitnessId           INT             NOT NULL IDENTITY(1,1),
    IncidentId          INT             NOT NULL,
    StaffId             INT                 NULL,   -- FK if witness is staff
    WitnessName         NVARCHAR(200)   NOT NULL,
    -- Staff | Resident | Family | Visitor
    WitnessType         NVARCHAR(20)    NOT NULL,
    StatementText       NVARCHAR(2000)      NULL,
    StatementTakenAt    DATETIME2           NULL,
    CONSTRAINT PK_IncWitnesses          PRIMARY KEY (WitnessId),
    CONSTRAINT FK_IncWit_Incident       FOREIGN KEY (IncidentId) REFERENCES IncidentReports(IncidentId),
    CONSTRAINT FK_IncWit_Staff          FOREIGN KEY (StaffId)    REFERENCES Staff(StaffId),
    CONSTRAINT CK_IncWit_Type           CHECK (WitnessType IN ('Staff','Resident','Family','Visitor'))
);
GO

CREATE TABLE IncidentInvestigations (
    InvestigationId         INT             NOT NULL IDENTITY(1,1),
    IncidentId              INT             NOT NULL,
    InvestigatedByStaffId   INT             NOT NULL,
    ClosedByStaffId         INT                 NULL,
    OpenedAt                DATETIME2       NOT NULL DEFAULT SYSUTCDATETIME(),
    CompletedAt             DATETIME2           NULL,
    RootCause               NVARCHAR(2000)      NULL,
    ContributingFactors     NVARCHAR(2000)      NULL,
    PreventabilityRating    NVARCHAR(200)       NULL,
    IsComplete              BIT             NOT NULL DEFAULT 0,
    ClosedAt                DATETIME2           NULL,
    CONSTRAINT PK_IncInvestigations         PRIMARY KEY (InvestigationId),
    CONSTRAINT FK_IncInv_Incident           FOREIGN KEY (IncidentId)            REFERENCES IncidentReports(IncidentId),
    CONSTRAINT FK_IncInv_Staff              FOREIGN KEY (InvestigatedByStaffId) REFERENCES Staff(StaffId),
    CONSTRAINT FK_IncInv_Closer             FOREIGN KEY (ClosedByStaffId)       REFERENCES Staff(StaffId),
    -- One investigation record per incident
    CONSTRAINT UQ_IncInv_Incident           UNIQUE (IncidentId)
);
GO

CREATE TABLE CorrectiveActions (
    ActionId            INT             NOT NULL IDENTITY(1,1),
    IncidentId          INT             NOT NULL,
    InvestigationId     INT                 NULL,
    AssignedToStaffId   INT             NOT NULL,
    AssignedByStaffId   INT             NOT NULL,
    ActionDescription   NVARCHAR(500)   NOT NULL,
    DueDate             DATE            NOT NULL,
    CompletedDate       DATE                NULL,
    -- Pending | In Progress | Completed | Overdue | Cancelled
    Status              NVARCHAR(20)    NOT NULL DEFAULT 'Pending',
    CompletionNotes     NVARCHAR(500)       NULL,
    CONSTRAINT PK_CorrectiveActions     PRIMARY KEY (ActionId),
    CONSTRAINT FK_CA_Incident           FOREIGN KEY (IncidentId)         REFERENCES IncidentReports(IncidentId),
    CONSTRAINT FK_CA_Investigation      FOREIGN KEY (InvestigationId)    REFERENCES IncidentInvestigations(InvestigationId),
    CONSTRAINT FK_CA_AssignedTo         FOREIGN KEY (AssignedToStaffId)  REFERENCES Staff(StaffId),
    CONSTRAINT FK_CA_AssignedBy         FOREIGN KEY (AssignedByStaffId)  REFERENCES Staff(StaffId),
    CONSTRAINT CK_CA_Status             CHECK (Status IN (
        'Pending','In Progress','Completed','Overdue','Cancelled'))
);
GO

-- ============================================================
-- SECTION 11 : BILLING & FINANCE
-- ============================================================

CREATE TABLE ChargeItems (
    ChargeItemId        INT             NOT NULL IDENTITY(1,1),
    FacilityId          INT             NOT NULL,
    ServiceCode         NVARCHAR(20)    NOT NULL,
    ServiceDescription  NVARCHAR(200)   NOT NULL,
    RevenueCode         NVARCHAR(10)        NULL,
    CPTCode             NVARCHAR(10)        NULL,
    HCPCSCode           NVARCHAR(10)        NULL,
    DefaultAmount       DECIMAL(10,2)   NOT NULL,
    -- Day | Visit | Unit | Minute | Hour
    UnitOfMeasure       NVARCHAR(20)        NULL,
    IsActive            BIT             NOT NULL DEFAULT 1,
    CONSTRAINT PK_ChargeItems           PRIMARY KEY (ChargeItemId),
    CONSTRAINT FK_ChargeItems_Facility  FOREIGN KEY (FacilityId) REFERENCES Facilities(FacilityId),
    CONSTRAINT UQ_ChargeItems_Code      UNIQUE (FacilityId, ServiceCode)
);
GO

CREATE TABLE Charges (
    ChargeId            INT             NOT NULL IDENTITY(1,1),
    ResidentId          INT             NOT NULL,
    AdmissionId         INT             NOT NULL,
    ChargeItemId        INT             NOT NULL,
    CreatedByStaffId    INT             NOT NULL,
    ServiceDate         DATE            NOT NULL,
    Quantity            DECIMAL(8,2)    NOT NULL DEFAULT 1,
    UnitAmount          DECIMAL(10,2)   NOT NULL,
    -- Persisted computed column; always equals Quantity * UnitAmount
    TotalAmount         AS (Quantity * UnitAmount) PERSISTED,
    BillingPeriodStart  DATE                NULL,
    BillingPeriodEnd    DATE                NULL,
    -- Unbilled | Billed | Paid | Adjusted | Void
    ChargeStatus        NVARCHAR(20)    NOT NULL DEFAULT 'Unbilled',
    CreatedAt           DATETIME2       NOT NULL DEFAULT SYSUTCDATETIME(),
    Notes               NVARCHAR(500)       NULL,
    CONSTRAINT PK_Charges               PRIMARY KEY (ChargeId),
    CONSTRAINT FK_Charges_Resident      FOREIGN KEY (ResidentId)     REFERENCES Residents(ResidentId),
    CONSTRAINT FK_Charges_Admission     FOREIGN KEY (AdmissionId)    REFERENCES Admissions(AdmissionId),
    CONSTRAINT FK_Charges_ChargeItem    FOREIGN KEY (ChargeItemId)   REFERENCES ChargeItems(ChargeItemId),
    CONSTRAINT FK_Charges_Staff         FOREIGN KEY (CreatedByStaffId) REFERENCES Staff(StaffId),
    CONSTRAINT CK_Charges_Status        CHECK (ChargeStatus IN (
        'Unbilled','Billed','Paid','Adjusted','Void'))
);
GO

CREATE TABLE Claims (
    ClaimId             INT             NOT NULL IDENTITY(1,1),
    ResidentId          INT             NOT NULL,
    AdmissionId         INT             NOT NULL,
    PayerId             INT             NOT NULL,
    InsuranceId         INT             NOT NULL,
    CreatedByStaffId    INT             NOT NULL,
    -- UB04 | CMS1500
    ClaimType           NVARCHAR(10)    NOT NULL,
    ClaimPeriodStart    DATE            NOT NULL,
    ClaimPeriodEnd      DATE            NOT NULL,
    TotalBilledAmount   DECIMAL(12,2)   NOT NULL DEFAULT 0,
    SubmittedAt         DATETIME2           NULL,
    ClearinghouseRef    NVARCHAR(100)       NULL,
    -- Draft | Submitted | Acknowledged | Pending | Paid | Denied | Appealed | Void
    Status              NVARCHAR(20)    NOT NULL DEFAULT 'Draft',
    CreatedAt           DATETIME2       NOT NULL DEFAULT SYSUTCDATETIME(),
    CONSTRAINT PK_Claims                PRIMARY KEY (ClaimId),
    CONSTRAINT FK_Claims_Resident       FOREIGN KEY (ResidentId)       REFERENCES Residents(ResidentId),
    CONSTRAINT FK_Claims_Admission      FOREIGN KEY (AdmissionId)      REFERENCES Admissions(AdmissionId),
    CONSTRAINT FK_Claims_Payer          FOREIGN KEY (PayerId)          REFERENCES Payers(PayerId),
    CONSTRAINT FK_Claims_Insurance      FOREIGN KEY (InsuranceId)      REFERENCES ResidentInsurance(InsuranceId),
    CONSTRAINT FK_Claims_Staff          FOREIGN KEY (CreatedByStaffId) REFERENCES Staff(StaffId),
    CONSTRAINT CK_Claims_Type           CHECK (ClaimType IN ('UB04','CMS1500')),
    CONSTRAINT CK_Claims_Status         CHECK (Status IN (
        'Draft','Submitted','Acknowledged','Pending',
        'Paid','Denied','Appealed','Void'))
);
GO

CREATE TABLE ClaimCharges (
    ClaimChargeId       INT             NOT NULL IDENTITY(1,1),
    ClaimId             INT             NOT NULL,
    ChargeId            INT             NOT NULL,
    CONSTRAINT PK_ClaimCharges          PRIMARY KEY (ClaimChargeId),
    CONSTRAINT FK_CC_Claim              FOREIGN KEY (ClaimId)  REFERENCES Claims(ClaimId),
    CONSTRAINT FK_CC_Charge             FOREIGN KEY (ChargeId) REFERENCES Charges(ChargeId),
    CONSTRAINT UQ_CC_ClaimCharge        UNIQUE (ClaimId, ChargeId)
);
GO

CREATE TABLE Payments (
    PaymentId           INT             NOT NULL IDENTITY(1,1),
    ClaimId             INT             NOT NULL,
    PostedByStaffId     INT             NOT NULL,
    PaymentDate         DATE            NOT NULL,
    AmountPaid          DECIMAL(12,2)   NOT NULL,
    ContractualAdj      DECIMAL(12,2)   NOT NULL DEFAULT 0,
    PatientBalance      DECIMAL(12,2)   NOT NULL DEFAULT 0,
    -- EFT | Check | Credit Card | Cash | ERA | Other
    PaymentMethod       NVARCHAR(20)    NOT NULL,
    CheckNumber         NVARCHAR(50)        NULL,
    ERAReference        NVARCHAR(100)       NULL,
    PostedAt            DATETIME2       NOT NULL DEFAULT SYSUTCDATETIME(),
    Notes               NVARCHAR(500)       NULL,
    CONSTRAINT PK_Payments              PRIMARY KEY (PaymentId),
    CONSTRAINT FK_Pay_Claim             FOREIGN KEY (ClaimId)        REFERENCES Claims(ClaimId),
    CONSTRAINT FK_Pay_Staff             FOREIGN KEY (PostedByStaffId) REFERENCES Staff(StaffId),
    CONSTRAINT CK_Pay_Method            CHECK (PaymentMethod IN (
        'EFT','Check','Credit Card','Cash','ERA','Other'))
);
GO

CREATE TABLE ClaimDenials (
    DenialId            INT             NOT NULL IDENTITY(1,1),
    ClaimId             INT             NOT NULL,
    DenialDate          DATE            NOT NULL,
    DenialCode          NVARCHAR(10)    NOT NULL,
    DenialReason        NVARCHAR(500)   NOT NULL,
    AppealDeadline      DATE                NULL,
    -- Not Appealed | In Appeal | Appeal Won | Appeal Lost | Withdrawn
    AppealStatus        NVARCHAR(20)    NOT NULL DEFAULT 'Not Appealed',
    AppealNotes         NVARCHAR(1000)      NULL,
    AppealSubmittedAt   DATETIME2           NULL,
    ResolvedAt          DATETIME2           NULL,
    CONSTRAINT PK_ClaimDenials          PRIMARY KEY (DenialId),
    CONSTRAINT FK_Den_Claim             FOREIGN KEY (ClaimId) REFERENCES Claims(ClaimId),
    CONSTRAINT CK_Den_AppealStatus      CHECK (AppealStatus IN (
        'Not Appealed','In Appeal','Appeal Won','Appeal Lost','Withdrawn'))
);
GO

CREATE TABLE TrustFundAccounts (
    AccountId           INT             NOT NULL IDENTITY(1,1),
    ResidentId          INT             NOT NULL,
    Balance             DECIMAL(10,2)   NOT NULL DEFAULT 0,
    LastUpdatedAt       DATETIME2       NOT NULL DEFAULT SYSUTCDATETIME(),
    IsActive            BIT             NOT NULL DEFAULT 1,
    CONSTRAINT PK_TrustFundAccounts     PRIMARY KEY (AccountId),
    CONSTRAINT FK_TFA_Resident          FOREIGN KEY (ResidentId) REFERENCES Residents(ResidentId),
    -- One trust fund account per resident
    CONSTRAINT UQ_TFA_Resident          UNIQUE (ResidentId)
);
GO

CREATE TABLE TrustFundTransactions (
    TransactionId       INT             NOT NULL IDENTITY(1,1),
    AccountId           INT             NOT NULL,
    ProcessedByStaffId  INT             NOT NULL,
    TransactionDate     DATETIME2       NOT NULL DEFAULT SYSUTCDATETIME(),
    -- Deposit | Withdrawal | Adjustment | Transfer | Refund
    TransactionType     NVARCHAR(20)    NOT NULL,
    Amount              DECIMAL(10,2)   NOT NULL,
    RunningBalance      DECIMAL(10,2)   NOT NULL,
    Description         NVARCHAR(300)   NOT NULL,
    ReceiptNumber       NVARCHAR(50)        NULL,
    CONSTRAINT PK_TrustFundTx           PRIMARY KEY (TransactionId),
    CONSTRAINT FK_TFT_Account           FOREIGN KEY (AccountId)          REFERENCES TrustFundAccounts(AccountId),
    CONSTRAINT FK_TFT_Staff             FOREIGN KEY (ProcessedByStaffId) REFERENCES Staff(StaffId),
    CONSTRAINT CK_TFT_Type              CHECK (TransactionType IN (
        'Deposit','Withdrawal','Adjustment','Transfer','Refund'))
);
GO

-- ============================================================
-- SECTION 12 : AUDIT LOG
-- ============================================================

CREATE TABLE AuditLog (
    -- BIGINT prevents overflow on this high-volume, append-only table
    AuditId             BIGINT          NOT NULL IDENTITY(1,1),
    TableName           NVARCHAR(100)   NOT NULL,
    RecordId            NVARCHAR(50)    NOT NULL,
    -- INSERT | UPDATE | DELETE | SELECT
    Action              NVARCHAR(10)    NOT NULL,
    -- JSON snapshots of the row before and after the change
    OldValues           NVARCHAR(MAX)       NULL,
    NewValues           NVARCHAR(MAX)       NULL,
    -- No FK constraint; must never cascade-delete audit entries
    ChangedByUserId     INT                 NULL,
    ChangedByUserName   NVARCHAR(200)   NOT NULL,
    ChangedAt           DATETIME2       NOT NULL DEFAULT SYSUTCDATETIME(),
    IPAddress           NVARCHAR(45)        NULL,
    SessionId           NVARCHAR(100)       NULL,
    CONSTRAINT PK_AuditLog              PRIMARY KEY (AuditId),
    CONSTRAINT CK_AuditLog_Action       CHECK (Action IN ('INSERT','UPDATE','DELETE','SELECT'))
);
GO

-- ============================================================
-- SECTION 13 : INDEXES
-- ============================================================

-- Residents
CREATE NONCLUSTERED INDEX IX_Residents_Facility     ON Residents (FacilityId);
CREATE NONCLUSTERED INDEX IX_Residents_Name         ON Residents (LastName, FirstName);
CREATE NONCLUSTERED INDEX IX_Residents_DOB          ON Residents (DateOfBirth);

-- Staff
CREATE NONCLUSTERED INDEX IX_Staff_Facility         ON Staff (FacilityId, IsActive);

-- StaffCredentials  — expiry sweep for reminder alerts
CREATE NONCLUSTERED INDEX IX_Creds_Expiry           ON StaffCredentials (ExpiryDate, StaffId);

-- Admissions
CREATE NONCLUSTERED INDEX IX_Adm_Resident           ON Admissions (ResidentId);
CREATE NONCLUSTERED INDEX IX_Adm_Bed                ON Admissions (BedId);
CREATE NONCLUSTERED INDEX IX_Adm_FacilityStatus     ON Admissions (FacilityId, Status) INCLUDE (ResidentId, AdmissionDate);

-- VitalSigns — clinical trending queries
CREATE NONCLUSTERED INDEX IX_Vitals_ResDate         ON VitalSigns (ResidentId, RecordedAt DESC);

-- ClinicalAssessments
CREATE NONCLUSTERED INDEX IX_Assess_NextDate        ON ClinicalAssessments (NextAssessmentDate, ResidentId);

-- MedicationOrders — eMAR schedule generation
CREATE NONCLUSTERED INDEX IX_MedOrd_ActiveRes       ON MedicationOrders (ResidentId, OrderStatus) INCLUDE (DrugId, Dose, Route, Frequency);
CREATE NONCLUSTERED INDEX IX_MedOrd_Admission       ON MedicationOrders (AdmissionId, OrderStatus);

-- MedicationAdministrations — MAR history
CREATE NONCLUSTERED INDEX IX_MedAdm_Order           ON MedicationAdministrations (OrderId);
CREATE NONCLUSTERED INDEX IX_MedAdm_ResDate         ON MedicationAdministrations (ResidentId, AdministeredAt DESC);

-- CarePlans
CREATE NONCLUSTERED INDEX IX_CP_ResidentStatus      ON CarePlans (ResidentId, Status);
CREATE NONCLUSTERED INDEX IX_CP_NextReview          ON CarePlans (NextReviewDate) INCLUDE (ResidentId, AdmissionId);

-- IncidentReports — QAPI analytics
CREATE NONCLUSTERED INDEX IX_Inc_ResidentId         ON IncidentReports (ResidentId);
CREATE NONCLUSTERED INDEX IX_Inc_FacilityDate       ON IncidentReports (FacilityId, IncidentDate DESC);
CREATE NONCLUSTERED INDEX IX_Inc_Status             ON IncidentReports (Status, Severity);

-- Charges — unbilled charge sweep
CREATE NONCLUSTERED INDEX IX_Charges_ResDate        ON Charges (ResidentId, ServiceDate DESC);
CREATE NONCLUSTERED INDEX IX_Charges_AdmStatus      ON Charges (AdmissionId, ChargeStatus);

-- Claims — A/R aging
CREATE NONCLUSTERED INDEX IX_Claims_ResidentStatus  ON Claims (ResidentId, Status);
CREATE NONCLUSTERED INDEX IX_Claims_PayerStatus     ON Claims (PayerId, Status) INCLUDE (TotalBilledAmount, ClaimPeriodEnd);

-- AuditLog — PHI access audit + user activity
CREATE NONCLUSTERED INDEX IX_Audit_TableRecord      ON AuditLog (TableName, RecordId, ChangedAt DESC);
CREATE NONCLUSTERED INDEX IX_Audit_UserId           ON AuditLog (ChangedByUserId, ChangedAt DESC);
CREATE NONCLUSTERED INDEX IX_Audit_Date             ON AuditLog (ChangedAt DESC);
GO
