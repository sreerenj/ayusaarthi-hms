# AyuSaarthi HMS — System Architecture

**Version:** 1.0  
**Date:** 2026-08-31  
**Stack:** Angular · ASP.NET Core Web API (.NET 8) · SQL Server · Azure Blob Storage · Azure AD / ASP.NET Core Identity + JWT · Azure Service Bus · Power BI Embedded

---

## Table of Contents

1. [Technology Stack](#1-technology-stack)
2. [High-Level System Architecture](#2-high-level-system-architecture)
3. [Authentication & Authorization Flow](#3-authentication--authorization-flow)
4. [Async Event Flow — Azure Service Bus](#4-async-event-flow--azure-service-bus)
5. [Key Clinical Flow: Medication Administration](#5-key-clinical-flow-medication-administration)
6. [Azure Deployment Topology](#6-azure-deployment-topology)
7. [Security Architecture](#7-security-architecture)
8. [Data Architecture](#8-data-architecture)
9. [API Design Conventions](#9-api-design-conventions)

---

## 1. Technology Stack

| Layer | Technology | Version | Role |
|-------|-----------|---------|------|
| Frontend | Angular | 18 | SPA — clinical workflows, admin console, family portal |
| Auth — Option A | Azure Active Directory (Microsoft Entra ID) | — | Cloud-managed identity, OIDC / OAuth 2.0, MFA, RBAC Groups |
| Auth — Option B | ASP.NET Core Identity + JWT Bearer | .NET 8 | Self-hosted identity, role-based JWT claims, refresh tokens |
| Backend | ASP.NET Core Web API | .NET 8 | RESTful API, domain logic, integrations, background workers |
| ORM | Entity Framework Core | 8 | SQL Server data access, migrations, auditing interceptors |
| Database | SQL Server / Azure SQL Database | 2022 | OLTP — all resident, clinical, operational, and billing data |
| File Storage | Azure Blob Storage | — | Consent docs, scanned forms, EDI files, exported PDF reports |
| Messaging | Azure Service Bus | Premium | Async, durable event-driven communication between services |
| Analytics | Power BI Embedded | — | Quality measure dashboards, billing analytics, ad-hoc reports |
| Logging | Serilog → Azure Log Analytics | — | Structured, centralized application and audit logs |
| Monitoring | Azure Application Insights | — | Distributed tracing, performance monitoring, alerting |

---

## 2. High-Level System Architecture

The system follows a **layered, event-driven architecture**. Angular SPAs consume a modular ASP.NET Core Web API secured by JWT Bearer tokens issued by either Azure AD (Option A) or ASP.NET Core Identity (Option B). Domain services communicate asynchronously via Azure Service Bus topics and queues. Power BI Embedded surfaces analytics directly within the Angular shell.

```mermaid
flowchart TB
    classDef client   fill:#DD0031,stroke:#AA0024,color:#fff
    classDef auth     fill:#0078D4,stroke:#005A9E,color:#fff
    classDef api      fill:#512BD4,stroke:#3A20A0,color:#fff
    classDef db       fill:#CC2927,stroke:#9A1E1E,color:#fff
    classDef blob     fill:#1E88E5,stroke:#1565C0,color:#fff
    classDef bus      fill:#E65100,stroke:#BF360C,color:#fff
    classDef analytics fill:#F9A825,stroke:#F57F17,color:#000
    classDef ext      fill:#424242,stroke:#212121,color:#fff

    subgraph CLT["  CLIENT LAYER  "]
        direction LR
        cWeb["Angular SPA\nClinical Staff / Administrator"]
        cTab["Angular SPA\nCNA / RN — Tablet / POC"]
        cFam["Angular Family Portal\nResident Guardians"]
    end

    subgraph IAM["  IDENTITY & ACCESS MANAGEMENT  "]
        direction LR
        iAAD["Azure Active Directory\nOAuth 2.0 · OIDC · MFA\nConditional Access · RBAC Groups"]
        iJWT["ASP.NET Core Identity\nJWT Bearer Tokens\nRefresh Tokens · Role Claims"]
        iAAD -. "or" .- iJWT
    end

    subgraph APISG["  ASP.NET CORE WEB API  —  .NET 8  "]
        direction TB
        apiMW["Auth Middleware  ·  Rate Limiter  ·  CORS  ·  Global Exception Handler  ·  Serilog"]
        subgraph MODS["Domain Service Modules"]
            direction LR
            sRes[Resident]
            sAdm[Admission]
            sMed[Medication]
            sCrPl[Care Plan]
            sInc[Incident]
            sStf[Staff]
            sBill[Billing]
            sAppt[Appointment]
            sNotf[Notification]
            sRpt[Report]
        end
        apiMW --> MODS
    end

    subgraph SBG["  AZURE SERVICE BUS  —  PREMIUM NAMESPACE  "]
        direction LR
        tClin["Topic\nclinical-events"]
        tBill["Topic\nbilling-events"]
        tAlrt["Topic\nalert-events"]
        qNotf["Queue\nnotification"]
        qAudt["Queue\naudit-log"]
        qPhrm["Queue\npharmacy-orders"]
    end

    subgraph DLSG["  DATA LAYER  "]
        direction LR
        dSQL[("SQL Server\nAzure SQL Database\nOLTP — All PHI")]
        dBlob["Azure Blob Storage\nConsent Docs · Scans\nEDI Files · PDF Reports"]
    end

    subgraph ANSG["  ANALYTICS  "]
        dPBI["Power BI Embedded\nQM Dashboards · Census\nA/R · Incident Trends"]
    end

    subgraph EXTSG["  EXTERNAL INTEGRATIONS  "]
        direction LR
        xPhrm["Pharmacy System\nNCPDP Script 10.6"]
        xClrh["Billing Clearinghouse\nEDI 837 / EDI 835"]
        xHie["Hospital / HIE\nHL7 FHIR R4"]
    end

    cWeb & cTab & cFam  -->|"HTTPS — MSAL.js / Bearer Token"| IAM
    IAM                 -->|"JWT Access Token"| apiMW
    MODS                -->|"Entity Framework Core"| dSQL
    sAdm & sMed & sInc & sBill -->|"Azure SDK"| dBlob
    sMed & sInc & sRes  -->|publish| tClin
    sBill               -->|publish| tBill
    sAppt & sStf        -->|publish| tAlrt
    tClin               --> qNotf & qAudt & qPhrm
    tBill               --> qNotf & qAudt
    tAlrt               --> qNotf & qAudt
    qNotf               -->|consume| sNotf
    qPhrm               -->|"NCPDP Script 10.6"| xPhrm
    sBill               -->|"EDI 837"| xClrh
    xClrh               -->|"EDI 835"| sBill
    sAdm               <-->|"HL7 FHIR R4"| xHie
    sRpt                -->|"Push Dataset / DirectQuery"| dPBI
    dPBI                -->|"Embedded SDK"| cWeb

    class cWeb,cTab,cFam client
    class iAAD,iJWT auth
    class apiMW,sRes,sAdm,sMed,sCrPl,sInc,sStf,sBill,sAppt,sNotf,sRpt api
    class dSQL db
    class dBlob blob
    class tClin,tBill,tAlrt,qNotf,qAudt,qPhrm bus
    class dPBI analytics
    class xPhrm,xClrh,xHie ext
```

### 2.1 Layer Responsibilities

| Layer | Technology | Responsibility |
|-------|-----------|----------------|
| Client | Angular 18 | SPA rendering, MSAL.js token management, reactive state (NgRx), offline-capable eMAR via Service Worker |
| Identity | Azure AD / ASP.NET Core Identity | Token issuance, MFA enforcement, role/claim injection, token refresh |
| API | ASP.NET Core Web API | Domain logic, RBAC policy enforcement, EF Core ORM, background jobs (Hosted Services) |
| Messaging | Azure Service Bus | Durable async decoupling of clinical events, audit events, pharmacy orders, and notifications |
| Database | SQL Server / Azure SQL | OLTP for all PHI; auditing via EF Core interceptors; row-level security for multi-tenant isolation |
| Blob Storage | Azure Blob Storage | Binary file storage with private endpoints; SAS URL generation for time-limited secure access |
| Analytics | Power BI Embedded | Embedded reports rendered in Angular iFrame; row-level security (RLS) enforced per facility |
| External | FHIR / NCPDP / EDI | Standard protocol adapters — not direct SQL access to external systems |

---

## 3. Authentication & Authorization Flow

Two mutually exclusive identity strategies are supported. The API's middleware stack and Angular MSAL.js configuration are the only components that change between options.

| | Option A — Azure AD | Option B — ASP.NET Core Identity |
|--|--|--|
| **Token Issuer** | Microsoft Entra ID (cloud) | Local ASP.NET Core API (`/api/auth/token`) |
| **Protocol** | OAuth 2.0 + OIDC + PKCE | OAuth 2.0 Resource Owner (internal) |
| **MFA** | Azure AD Conditional Access (built-in) | TOTP via ASP.NET Core Identity + Authenticator app |
| **RBAC** | Azure AD Security Groups → API scope claims | ASP.NET Core Identity Roles → JWT role claims |
| **Token Storage** | MSAL.js in-memory cache | In-memory; refresh token in HttpOnly cookie |
| **Best For** | Enterprise facilities with Microsoft 365 | Self-hosted / on-premises deployment |

```mermaid
sequenceDiagram
    autonumber
    actor User as Clinical Staff
    participant SPA  as Angular SPA (MSAL.js)
    participant IDP  as Azure AD / ASP.NET Core Identity
    participant API  as ASP.NET Core Web API
    participant DB   as SQL Server

    User  ->> SPA  : Navigate to protected route
    SPA   ->> IDP  : Authorization Request (OAuth 2.0 + PKCE)
    IDP  -->> User : Login prompt + MFA challenge
    User  ->> IDP  : Credentials + MFA one-time code
    IDP  -->> SPA  : Authorization Code
    SPA   ->> IDP  : Token Request (code + PKCE verifier)
    IDP  -->> SPA  : Access Token (JWT) + Refresh Token + ID Token
    Note over SPA   : MSAL.js stores Access Token in memory only
    SPA   ->> API  : HTTP Request — Authorization: Bearer {JWT}
    API   ->> API  : Validate JWT: signature · issuer · audience · expiry
    API   ->> API  : Extract role claims → enforce [Authorize(Policy)] attributes
    API   ->> DB   : Execute EF Core query scoped to authorized data
    DB   -->> API  : Result set
    API  -->> SPA  : HTTP 200 + JSON response
    SPA  -->> User : Render protected view
    Note over SPA,API: Silent token refresh via Refresh Token before expiry (default: 60 min Access Token TTL)
```

---

## 4. Async Event Flow — Azure Service Bus

Azure Service Bus decouples domain services from side-effect consumers (notifications, audit logging, pharmacy integration). Publishers emit events to **topics**; consumers receive messages via **queue subscriptions**, enabling independent scaling and retry without coupling.

```mermaid
flowchart LR
    classDef pub      fill:#512BD4,stroke:#3A20A0,color:#fff
    classDef topic    fill:#E65100,stroke:#BF360C,color:#fff
    classDef queue    fill:#BF360C,stroke:#7F2410,color:#fff
    classDef consumer fill:#0078D4,stroke:#005A9E,color:#fff
    classDef ext      fill:#424242,stroke:#212121,color:#fff

    subgraph PUB["Publishers — ASP.NET Core Domain Services"]
        direction TB
        pMed["Medication Service\n(administered · refused · PRN due)"]
        pInc["Incident Service\n(created · escalated)"]
        pRes["Resident Service\n(vitals alert · assessment due)"]
        pBill["Billing Service\n(charge captured · claim status)"]
        pAppt["Appointment Service\n(upcoming reminder)"]
        pStf["Staff Service\n(credential expiry)"]
    end

    subgraph SBN["Azure Service Bus Namespace — Premium"]
        subgraph TOPS["Topics"]
            tC["clinical-events"]
            tB["billing-events"]
            tA["alert-events"]
        end
        subgraph QUES["Queues (Topic Subscriptions)"]
            qN["notification-queue\n(TTL: 7 days · 3 retries)"]
            qAu["audit-log-queue\n(TTL: 30 days · 5 retries)"]
            qPh["pharmacy-orders-queue\n(TTL: 1 day · 3 retries)"]
        end
    end

    subgraph CONS["Consumers — ASP.NET Core Hosted Services"]
        cN["Notification Worker\npush alert · email · SMS"]
        cA["Audit Worker\nEF Core → Audit Log table"]
        cPh["Pharmacy Integration Worker\nNCPDP Script 10.6 → Pharmacy"]
    end

    pMed & pInc & pRes  --> tC
    pBill               --> tB
    pAppt & pStf        --> tA

    tC --> qN & qAu & qPh
    tB --> qN & qAu
    tA --> qN & qAu

    qN  --> cN
    qAu --> cA
    qPh --> cPh

    class pMed,pInc,pRes,pBill,pAppt,pStf pub
    class tC,tB,tA topic
    class qN,qAu,qPh queue
    class cN,cA consumer
    class cPh ext
```

### 4.1 Topic & Queue Catalog

| Topic | Published By | Event Examples | Subscribers |
|-------|-------------|----------------|-------------|
| `clinical-events` | Medication, Incident, Resident services | `medication-administered`, `incident-created`, `vitals-alert` | notification-queue, audit-log-queue, pharmacy-orders-queue |
| `billing-events` | Billing Service | `charge-captured`, `claim-submitted`, `payment-posted` | notification-queue, audit-log-queue |
| `alert-events` | Appointment, Staff services | `appointment-reminder`, `credential-expiry-warning`, `assessment-due` | notification-queue, audit-log-queue |

| Queue | Consumer | DLQ Handling |
|-------|---------|--------------|
| `notification-queue` | Notification Worker (push/email/SMS) | Undeliverable alerts logged and surfaced in Admin dashboard |
| `audit-log-queue` | Audit Worker | Failures retried with exponential back-off; critical audit failures alert Super Admin |
| `pharmacy-orders-queue` | Pharmacy Integration Worker | NCPDP transmission failures trigger in-app alert to Pharmacist for manual review |

---

## 5. Key Clinical Flow: Medication Administration

This sequence illustrates point-of-care eMAR administration with barcode verification, immutable record creation, and asynchronous audit/notification via Service Bus.

```mermaid
sequenceDiagram
    autonumber
    actor CNA
    participant Tab  as Angular SPA (Tablet)
    participant API  as ASP.NET Core Web API
    participant DB   as SQL Server
    participant SB   as Azure Service Bus
    participant NW   as Notification Worker
    actor RN

    CNA  ->> Tab  : Open eMAR for assigned residents
    Tab  ->> API  : GET /api/emar/{residentId}/schedule
    API  ->> DB   : Query active medication orders + due-time windows
    DB  -->> API  : Scheduled medication list
    API -->> Tab  : eMAR schedule (color-coded: due · given · late · held)
    CNA  ->> Tab  : Scan resident wristband (QR / barcode)
    CNA  ->> Tab  : Scan medication package barcode
    Tab  ->> API  : POST /api/medications/verify-scan {residentId, medicationId, barcodeData}
    Note over API : 5-Rights check — resident · drug · dose · route · time window
    API  ->> DB   : Validate resident-medication-dose match against active order
    DB  -->> API  : Verification result
    API -->> Tab  : Verified — proceed with administration
    CNA  ->> Tab  : Confirm: dose given, route, site, time
    Tab  ->> API  : POST /api/medications/administrations {payload}
    API  ->> DB   : INSERT MarRecord (immutable after correction window)
    API  ->> SB   : Publish clinical-events → medication-administered
    Note over SB  : Routes to notification-queue and audit-log-queue
    SB  -->> NW   : notification-queue message consumed
    NW  -->> RN   : In-app notification — MAR updated / controlled substance alert
    API -->> Tab  : 201 Created — administration recorded
    Tab -->> CNA  : eMAR refreshed — next due medication highlighted
```

---

## 6. Azure Deployment Topology

All production resources are deployed in a single Azure Subscription within a primary region (e.g., East US 2) with geo-redundant data replication to a paired region (e.g., Central US). Azure Front Door provides global entry point, WAF, and DDoS protection.

```mermaid
flowchart TB
    classDef compute  fill:#512BD4,stroke:#3A20A0,color:#fff
    classDef data     fill:#CC2927,stroke:#9A1E1E,color:#fff
    classDef security fill:#107C10,stroke:#0A5C0A,color:#fff
    classDef observe  fill:#F9A825,stroke:#F57F17,color:#000
    classDef identity fill:#0078D4,stroke:#005A9E,color:#fff
    classDef integ    fill:#E65100,stroke:#BF360C,color:#fff
    classDef analytics fill:#F9A825,stroke:#F57F17,color:#000

    Internet(("Internet\nUsers / External"))

    subgraph AzTenant["Azure Tenant — ayusaarthi.onmicrosoft.com"]

        subgraph IDTier["Identity Tier"]
            AADr["Azure Active Directory\nMicrosoft Entra ID\nApp Registration · RBAC Groups\nMFA · Conditional Access Policies"]
        end

        subgraph RG["Resource Group: ayusaarthi-prod-rg  (East US 2)"]

            subgraph AppTier["Application Tier"]
                FD["Azure Front Door + WAF\nGlobal Load Balancing\nOWASP Rule Sets · DDoS Protection\nTLS Termination"]
                SWA["Azure Static Web Apps\nAngular SPA + Family Portal\nBuilt-in Global CDN\nEdge-cached static assets"]
                AppSvc["Azure App Service — P3v3\nASP.NET Core Web API\nAuto-Scale (2–10 instances)\nManaged Identity enabled"]
            end

            subgraph DataTier["Data Tier"]
                AzSQLr[("Azure SQL Database\nBusiness Critical Tier\nZone-Redundant · Active Geo-Replication\nTransparent Data Encryption (TDE)")]
                AzBlobr["Azure Blob Storage\nRA-GRS Redundancy\nPrivate Endpoint · No Public Access\nImmutability Policies for PHI docs"]
            end

            subgraph SecTier["Security & Configuration"]
                KVr["Azure Key Vault\nConnection Strings · API Keys\nTLS Certificates\nAccess via Managed Identity only"]
            end

            subgraph IntTier["Integration Tier"]
                SBr["Azure Service Bus\nPremium Namespace\nPrivate Endpoint\nGeo-Disaster Recovery Pairing"]
            end

            subgraph ObsTier["Observability"]
                AppIns["Application Insights\nDistributed Tracing\nLive Metrics · Availability Tests"]
                LogAna["Log Analytics Workspace\nCentralized Structured Logs\nAlert Rules · 90-Day Retention"]
            end

        end

        subgraph PBITier["Analytics Tier"]
            PBIr["Power BI Premium Workspace\nEmbedded Capacity (A-SKU)\nRow-Level Security per Facility\nScheduled Dataset Refresh"]
        end

    end

    Internet        -->|"HTTPS"| FD
    FD              -->|"Static Assets"| SWA
    FD              -->|"API Requests"| AppSvc
    SWA            <-->|"REST + JWT"| AppSvc
    AppSvc          -->|"EF Core / TLS 1.3"| AzSQLr
    AppSvc          -->|"Azure SDK / Private Link"| AzBlobr
    AppSvc          -->|"AMQP 1.0 / Private Endpoint"| SBr
    AppSvc          -->|"Managed Identity"| KVr
    AppSvc          -->|"Push Dataset"| PBIr
    PBIr            -->|"Embedded Token API"| SWA
    AppSvc & SWA   -.->|"OIDC / MSAL"| AADr
    AADr           -.->|"Token Validation"| AppSvc
    AppSvc          -.->|"App Insights SDK"| AppIns
    AzSQLr & SBr & AzBlobr -.->|"Diagnostic Logs"| LogAna
    AppIns          -.-> LogAna

    class FD,SWA,AppSvc compute
    class AzSQLr,AzBlobr data
    class KVr security
    class AppIns,LogAna observe
    class AADr identity
    class SBr integ
    class PBIr analytics
```

### 6.1 Azure Resource Catalog

| Azure Resource | SKU / Tier | Purpose |
|---------------|-----------|---------|
| Azure Active Directory | P2 | MFA, Conditional Access, RBAC Groups |
| Azure Front Door + WAF | Premium | Global entry point, DDoS, OWASP WAF rules |
| Azure Static Web Apps | Standard | Angular SPA hosting with global CDN |
| Azure App Service | P3v3 (auto-scale 2–10) | ASP.NET Core Web API hosting |
| Azure SQL Database | Business Critical | Primary OLTP database, zone-redundant |
| Azure Blob Storage | RA-GRS + Private Endpoint | Unstructured file and document storage |
| Azure Key Vault | Standard | Secrets, certificates, connection strings |
| Azure Service Bus | Premium + Private Endpoint | Async messaging, geo-DR pairing |
| Application Insights | — | Distributed tracing, performance |
| Log Analytics Workspace | — | Centralized logging, alert rules |
| Power BI Premium Workspace | A-SKU (Embedded) | Embedded analytics with RLS |

---

## 7. Security Architecture

| Concern | Control |
|---------|---------|
| **Transport Security** | TLS 1.3 enforced end-to-end; HSTS headers set; all HTTP redirected to HTTPS at Front Door |
| **Data at Rest** | AES-256 on Azure SQL (TDE), Azure Blob Storage (SSE), and Azure Key Vault-managed keys |
| **Authentication** | JWT Bearer validation on every API request: signature, issuer (`iss`), audience (`aud`), expiry (`exp`) |
| **Authorization** | Attribute-based RBAC via `[Authorize(Policy = "...")]`; role claims mapped from Azure AD Groups or ASP.NET Core Identity Roles |
| **MFA** | Azure AD Conditional Access (Option A); TOTP via ASP.NET Core Identity (Option B) — mandatory for Admin, Physician, Pharmacist roles |
| **Session Management** | Access Token TTL: 60 minutes; Refresh Token TTL: 8 hours; silent renewal via MSAL.js; idle session timeout: 15 minutes (configurable) |
| **Account Lockout** | Locked after 5 failed login attempts; unlocked via admin action or email-verified self-service |
| **PHI Access Logging** | Every GET/POST/PUT/DELETE on PHI entities recorded in Audit Log via EF Core `SaveChanges` interceptor; immutable append-only table |
| **Blob Storage Access** | No public access; time-limited SAS URLs (default: 5 minutes) generated by API for each file download; all access logged |
| **Service Bus** | Private endpoint; AMQP with Managed Identity (no connection string in code); messages encrypted in transit and at rest |
| **API Security** | OWASP Top 10 mitigated at WAF; rate limiting (per-IP + per-user) via ASP.NET Core middleware; CORS policy restricted to known origins |
| **Secrets Management** | No secrets in code or config files; all loaded at runtime from Azure Key Vault via Managed Identity |
| **Dependency Scanning** | Automated OWASP Dependency-Check in CI pipeline; critical CVEs block deployment |
| **Penetration Testing** | Annual third-party pentest; findings remediated: Critical ≤ 24 h, High ≤ 7 days, Medium ≤ 30 days |

---

## 8. Data Architecture

SQL Server hosts all OLTP data organized into functional schema groups, with row-level security (RLS) enforcing facility-level data isolation in multi-tenant deployments. Azure Blob Storage holds only binary files; all metadata and references are stored in SQL Server.

### 8.1 Database Schema Groups

```mermaid
flowchart LR
    subgraph Core["Core Schema"]
        Residents["Residents\nResidentContacts\nInsurancePolicies\nAdvanceDirectives\nBedAssignments"]
        Facilities["Facilities\nUnits\nRooms\nBeds"]
        Users["Users\nRoles\nUserFacilities"]
    end

    subgraph Clinical["Clinical Schema"]
        Assessments["ClinicalAssessments\nMDSAssessments\nVitalSigns\nADLRecords"]
        Medications["MedicationOrders\nMARRecords\nDrugInteractionLogs\nPharmacyOrders"]
        CarePlans["CarePlans\nCarePlanProblems\nCarePlanInterventions\nCarePlanReviews"]
        Incidents["IncidentReports\nIncidentInvestigations\nCorrectiveActions"]
    end

    subgraph Operations["Operations Schema"]
        Admissions["Admissions\nDischarges\nTransfers"]
        Staff["StaffProfiles\nCredentials\nShiftSchedules\nAttendance"]
        Appointments["Appointments\nTransportRequests"]
    end

    subgraph Finance["Finance Schema"]
        Billing["BillingCensus\nCharges\nClaims\nPayments\nDenials\nTrustFundAccounts"]
    end

    subgraph Audit["Audit Schema"]
        AuditLog["AuditLog\n(append-only · immutable)"]
        ComplianceLog["ComplianceTasks\nSurveyDeficiencies\nPlansOfCorrection"]
    end

    Core --> Clinical
    Core --> Operations
    Core --> Finance
    Clinical & Operations & Finance --> Audit
```

### 8.2 Key Design Decisions

| Decision | Rationale |
|----------|-----------|
| Audit log is append-only with no UPDATE/DELETE grants | Satisfies HIPAA, 21 CFR Part 11 audit defensibility |
| MAR records are immutable after a configurable correction window (default: 24 h) | Prevents backdating; corrections created as addenda |
| Soft deletes for all clinical entities | Preserves data lineage; discharged resident records retained in read-only archive for 7 years |
| Azure Blob Storage for documents with metadata in SQL | Avoids bloating the relational DB; enables efficient indexing and querying of document metadata |
| Multi-tenant row-level security via `FacilityId` column | Ensures facility-level data isolation without separate databases per tenant |
| EF Core `SaveChangesInterceptor` for change tracking | Captures old/new values for audit log without application-layer boilerplate |

---

## 9. API Design Conventions

- **Versioning:** URI versioning — `/api/v1/...`; breaking changes increment the major version.
- **Authentication:** Every endpoint requires `[Authorize]`; no anonymous endpoints expose PHI.
- **Authorization:** Fine-grained control via named policies, e.g., `[Authorize(Policy = "CanAdministerMedications")]`.
- **Response envelope:** Consistent JSON structure — `{ data, meta, errors }`.
- **Pagination:** Cursor-based pagination for large collections via `?cursor=&pageSize=`.
- **Error responses:** RFC 9457 Problem Details (`application/problem+json`) for all 4xx/5xx responses.
- **Idempotency:** `Idempotency-Key` header supported on POST endpoints for safe client retries.
- **File downloads:** API generates a short-lived SAS URL (5-minute TTL) and returns it to the client; client fetches directly from Azure Blob Storage.
- **Health checks:** `/api/health` (liveness) and `/api/health/ready` (readiness) exposed for App Service and Azure Monitor.
- **Rate limiting:** 1,000 requests/minute per authenticated user; 100/minute per unauthenticated IP (login endpoint only).
- **FHIR integration:** A dedicated `FhirAdapter` service translates internal domain models to/from HL7 FHIR R4 resources; no FHIR types leak into the core domain layer.

---

*Document Owner: AyuSaarthi HMS Architecture Team*  
*Review Cycle: Per major release or on infrastructure change*  
*Next Review Date: 2026-11-30*
