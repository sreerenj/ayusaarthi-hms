export type Severity = "High" | "Medium" | "Low";

export interface ResidentSummaryData {
  totalResidents: number;
  totalBeds: number;
  admissionsThisMonth: number;
  dischargesThisMonth: number;
  highFallRisk: number;
  dnrOnFile: number;
  byLevelOfCare: { label: string; count: number }[];
}

export type CarePlanStatus = "On Track" | "Needs Review" | "Overdue";

export interface CarePlan {
  id: number;
  residentName: string;
  room: string;
  focus: string;
  status: CarePlanStatus;
  progress: number;
  nextReview: string;
  owner: string;
}

export type MedicationAlertType =
  | "Overdue Dose"
  | "Refused"
  | "Interaction Warning"
  | "Controlled Count"
  | "PRN Follow-up";

export interface MedicationAlert {
  id: number;
  residentName: string;
  room: string;
  medication: string;
  type: MedicationAlertType;
  severity: Severity;
  detail: string;
}

export type AppointmentStatus = "Scheduled" | "In Transit" | "Completed";

export interface Appointment {
  id: number;
  time: string;
  residentName: string;
  type: string;
  provider: string;
  location: string;
  status: AppointmentStatus;
}

export type IncidentStatus = "Open" | "Under Investigation" | "Awaiting Review";

export interface Incident {
  id: number;
  reference: string;
  residentName: string;
  category: string;
  severity: Severity;
  status: IncidentStatus;
  daysOpen: number;
}

export interface DashboardData {
  facilityName: string;
  residentSummary: ResidentSummaryData;
  carePlans: CarePlan[];
  activeCarePlanCount: number;
  medicationAlerts: MedicationAlert[];
  appointments: Appointment[];
  incidents: Incident[];
}
