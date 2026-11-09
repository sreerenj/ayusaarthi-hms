export type StaffStatus = "On Duty" | "Off Duty" | "On Leave";
export type CredentialState = "Valid" | "Expiring Soon" | "Expired";

export interface StaffMember {
  id: number;
  name: string;
  role: string;
  department: string;
  shift: string;
  status: StaffStatus;
  credential: string;
  credentialExpiry: string;
  credentialState: CredentialState;
}

// Sample data only; replace with calls to the staff API.
export const staff: StaffMember[] = [
  {
    id: 1,
    name: "Rhea Patel",
    role: "Registered Nurse",
    department: "Nursing",
    shift: "Day (07:00–15:00)",
    status: "On Duty",
    credential: "RN License",
    credentialExpiry: "Aug 31, 2027",
    credentialState: "Valid",
  },
  {
    id: 2,
    name: "Michael Okafor",
    role: "Registered Nurse",
    department: "Nursing",
    shift: "Day (07:00–15:00)",
    status: "On Duty",
    credential: "RN License",
    credentialExpiry: "Nov 28, 2026",
    credentialState: "Expiring Soon",
  },
  {
    id: 3,
    name: "Sofia Lindqvist",
    role: "Licensed Practical Nurse",
    department: "Memory Care",
    shift: "Evening (15:00–23:00)",
    status: "Off Duty",
    credential: "LPN License",
    credentialExpiry: "Mar 15, 2027",
    credentialState: "Valid",
  },
  {
    id: 4,
    name: "Thomas Brooks",
    role: "Physical Therapist",
    department: "Rehabilitation",
    shift: "Day (08:00–16:00)",
    status: "On Duty",
    credential: "PT License",
    credentialExpiry: "Jan 10, 2027",
    credentialState: "Valid",
  },
  {
    id: 5,
    name: "Ana Romero",
    role: "Registered Dietitian",
    department: "Dietary",
    shift: "Day (08:00–16:00)",
    status: "On Duty",
    credential: "RD Registration",
    credentialExpiry: "Oct 30, 2026",
    credentialState: "Expired",
  },
  {
    id: 6,
    name: "Jamal Whitaker",
    role: "Registered Nurse",
    department: "Hospice",
    shift: "Night (23:00–07:00)",
    status: "Off Duty",
    credential: "RN License",
    credentialExpiry: "Dec 12, 2026",
    credentialState: "Expiring Soon",
  },
  {
    id: 7,
    name: "Lena Fischer",
    role: "Speech-Language Pathologist",
    department: "Rehabilitation",
    shift: "Day (08:00–16:00)",
    status: "On Leave",
    credential: "SLP License",
    credentialExpiry: "Jun 5, 2027",
    credentialState: "Valid",
  },
  {
    id: 8,
    name: "Priya Haddad",
    role: "Licensed Practical Nurse",
    department: "Nursing",
    shift: "Evening (15:00–23:00)",
    status: "Off Duty",
    credential: "LPN License",
    credentialExpiry: "Sep 22, 2027",
    credentialState: "Valid",
  },
];
