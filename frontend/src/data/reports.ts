export interface QualityMeasure {
  label: string;
  value: string;
  caption: string;
  direction: "up" | "down" | "flat";
  trend: "improving" | "worsening" | "stable";
}

export interface ReportDefinition {
  id: number;
  name: string;
  category: "Clinical" | "Financial" | "Operations" | "Compliance";
  description: string;
  frequency: "Daily" | "Weekly" | "Monthly" | "Quarterly";
  lastRun: string;
}

// Sample data only; replace with calls to the reporting API / Power BI embedded reports.
export const qualityMeasures: QualityMeasure[] = [
  {
    label: "Falls per 1,000 resident days",
    value: "3.2",
    caption: "Down from 3.8 last quarter",
    direction: "down",
    trend: "improving",
  },
  {
    label: "Pressure injuries (long-stay)",
    value: "2.1%",
    caption: "Up from 1.7% last quarter",
    direction: "up",
    trend: "worsening",
  },
  { label: "eMAR on-time administration", value: "96.4%", caption: "Target 95%", direction: "flat", trend: "stable" },
  {
    label: "Care plans reviewed on time",
    value: "91%",
    caption: "Down from 94% last quarter; target 98%",
    direction: "down",
    trend: "worsening",
  },
];

export const reports: ReportDefinition[] = [
  {
    id: 1,
    name: "Daily Census",
    category: "Operations",
    description: "Occupancy, admissions, discharges and transfers by unit.",
    frequency: "Daily",
    lastRun: "Nov 9, 2026",
  },
  {
    id: 2,
    name: "MDS Quality Measures",
    category: "Clinical",
    description: "Falls, pressure injuries, weight loss and antipsychotic use.",
    frequency: "Quarterly",
    lastRun: "Oct 1, 2026",
  },
  {
    id: 3,
    name: "eMAR Compliance",
    category: "Clinical",
    description: "On-time, late, missed and refused medication administrations.",
    frequency: "Weekly",
    lastRun: "Nov 8, 2026",
  },
  {
    id: 4,
    name: "Incident Trends",
    category: "Compliance",
    description: "Incident volume by category, severity, shift and location.",
    frequency: "Monthly",
    lastRun: "Nov 1, 2026",
  },
  {
    id: 5,
    name: "A/R Aging",
    category: "Financial",
    description: "Outstanding claims bucketed by days since submission.",
    frequency: "Weekly",
    lastRun: "Nov 8, 2026",
  },
  {
    id: 6,
    name: "Denials Analysis",
    category: "Financial",
    description: "Claim denials by payer, reason code and recovery status.",
    frequency: "Monthly",
    lastRun: "Nov 1, 2026",
  },
  {
    id: 7,
    name: "Staff Credential Expiry",
    category: "Compliance",
    description: "Licenses and certifications expiring in the next 90 days.",
    frequency: "Weekly",
    lastRun: "Nov 8, 2026",
  },
  {
    id: 8,
    name: "Staffing Hours per Resident Day",
    category: "Operations",
    description: "Direct-care hours by role against regulatory targets.",
    frequency: "Monthly",
    lastRun: "Nov 1, 2026",
  },
];
