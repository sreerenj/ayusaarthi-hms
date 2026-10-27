-- ============================================================
--  AyuSaarthi HMS  |  Reference / Seed Data
--  Version  : 1.0
--  Date     : 2026-08-31
--  Run AFTER schema.sql has been executed successfully.
-- ============================================================

USE AyuSaarthiHMS;
GO

-- ============================================================
-- IncidentCategories  (CMS / state-reportable categories)
-- ============================================================
INSERT INTO IncidentCategories (CategoryName, IsStateReportable, ReportingWindowHours)
VALUES
    ('Fall - No Injury',               0,   NULL),
    ('Fall - Minor Injury',            0,   NULL),
    ('Fall - Major Injury',            1,   24),
    ('Elopement',                      1,   24),
    ('Medication Error - Near Miss',   0,   NULL),
    ('Medication Error - Actual',      1,   24),
    ('Pressure Ulcer - New',           1,   72),
    ('Pressure Ulcer - Worsening',     0,   NULL),
    ('Physical Altercation',           1,   24),
    ('Abuse Allegation - Physical',    1,   2),
    ('Abuse Allegation - Verbal',      1,   2),
    ('Abuse Allegation - Sexual',      1,   2),
    ('Neglect Allegation',             1,   2),
    ('Choking / Aspiration',           1,   24),
    ('Adverse Drug Event',             1,   24),
    ('Wandering',                      0,   NULL),
    ('Theft / Property Loss',          0,   NULL),
    ('Unexpected Death',               1,   24),
    ('Injury of Unknown Origin',       1,   24),
    ('Other',                          0,   NULL);
GO

-- ============================================================
-- Payers  (standard national payers)
-- ============================================================
INSERT INTO Payers (PayerName, PayerType, NPI, PayerID_EDI)
VALUES
    ('Medicare Part A (CMS)',               'Medicare Part A',    NULL,   '01192'),
    ('Medicare Part B (CMS)',               'Medicare Part B',    NULL,   '01192'),
    ('Medicaid - State Program',            'Medicaid',           NULL,   NULL),
    ('UnitedHealthcare',                    'Private Insurance',  NULL,   '87726'),
    ('Aetna',                               'Private Insurance',  NULL,   '60054'),
    ('Humana',                              'Private Insurance',  NULL,   '61101'),
    ('Blue Cross Blue Shield',              'Private Insurance',  NULL,   '00050'),
    ('Cigna',                               'Private Insurance',  NULL,   '62308'),
    ('Veterans Affairs (VA)',               'VA',                 NULL,   'VA001'),
    ('UnitedHealthcare Community Plan',     'Managed Care',       NULL,   '87726'),
    ('Self-Pay',                            'Self-Pay',           NULL,   NULL);
GO

-- ============================================================
-- DiagnosisCodes  (common nursing home ICD-10 codes — sample)
-- ============================================================
INSERT INTO DiagnosisCodes (ICD10Code, Description, Category)
VALUES
    ('Z74.01', 'Bed confinement status',                                                    'Activity Limitation'),
    ('I10',    'Essential (primary) hypertension',                                          'Cardiovascular'),
    ('E11.9',  'Type 2 diabetes mellitus without complications',                            'Endocrine'),
    ('I50.9',  'Heart failure, unspecified',                                                'Cardiovascular'),
    ('J44.1',  'Chronic obstructive pulmonary disease with (acute) exacerbation',          'Respiratory'),
    ('N39.0',  'Urinary tract infection, site not specified',                               'Genitourinary'),
    ('F01.50', 'Vascular dementia without behavioral disturbance',                          'Neurocognitive'),
    ('F03.90', 'Unspecified dementia without behavioral disturbance',                       'Neurocognitive'),
    ('F03.91', 'Unspecified dementia with behavioral disturbance',                          'Neurocognitive'),
    ('G30.9',  'Alzheimers disease, unspecified',                                           'Neurocognitive'),
    ('M54.5',  'Low back pain',                                                             'Musculoskeletal'),
    ('M81.0',  'Age-related osteoporosis without current pathological fracture',            'Musculoskeletal'),
    ('S72.001A','Fracture of unspecified part of neck of right femur, initial encounter',   'Injury'),
    ('L89.90', 'Pressure ulcer of unspecified site, unspecified stage',                    'Skin'),
    ('L89.313','Pressure ulcer of right buttock, stage 3',                                 'Skin'),
    ('Z87.39', 'Personal history of other musculoskeletal disorders',                       'History'),
    ('R41.3',  'Other amnesia',                                                             'Symptoms'),
    ('R26.9',  'Unspecified abnormalities of gait and mobility',                            'Symptoms'),
    ('R55',    'Syncope and collapse',                                                      'Symptoms'),
    ('Z96.641','Presence of right artificial hip joint',                                    'Prosthetic'),
    ('Z79.01', 'Long-term (current) use of anticoagulants',                                'Medication Status'),
    ('Z79.4',  'Long-term (current) use of insulin',                                       'Medication Status'),
    ('C50.919','Malignant neoplasm of unspecified site of unspecified female breast',       'Oncology'),
    ('Z51.11', 'Encounter for antineoplastic chemotherapy',                                 'Oncology'),
    ('I69.354','Hemiplegia and hemiparesis following cerebral infarction',                  'Neurological');
GO

-- ============================================================
-- Sample Facility  (for development / test environments only)
-- ============================================================
INSERT INTO Facilities (FacilityName, AddressLine1, City, StateCode, ZipCode,
                        PhoneNumber, LicenseNumber, MedicareProvNum, MedicaidProvNum, NPI)
VALUES ('AyuSaarthi Care Center - Demo',
        '100 Wellness Drive', 'Springfield', 'IL', '62701',
        '(217) 555-0100', 'IL-NF-00001', '145000', 'IL145000', '1234567890');
GO

-- ============================================================
-- Sample Departments  (FacilityId = 1)
-- ============================================================
INSERT INTO Departments (FacilityId, DepartmentName)
VALUES
    (1, 'Nursing'),
    (1, 'Administration'),
    (1, 'Social Services'),
    (1, 'Rehabilitation Therapy'),
    (1, 'Dietary'),
    (1, 'Pharmacy'),
    (1, 'Billing'),
    (1, 'Human Resources');
GO

-- ============================================================
-- Sample Units  (FacilityId = 1)
-- ============================================================
INSERT INTO Units (FacilityId, UnitName, UnitType, FloorNumber)
VALUES
    (1, 'Skilled Nursing Unit A',   'SNF',          1),
    (1, 'Long-Term Care Unit B',    'LTC',          1),
    (1, 'Memory Care Unit C',       'Memory Care',  2),
    (1, 'Rehabilitation Unit D',    'Rehab',        2);
GO
