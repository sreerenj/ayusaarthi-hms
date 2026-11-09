import type { Severity } from "@/types/dashboard";

export type IncidentRecordStatus = "Open" | "Under Investigation" | "Awaiting Review" | "Closed";

export interface IncidentRecord {
  id: number;
  reference: string;
  occurredOn: string;
  residentName: string;
  category: string;
  location: string;
  severity: Severity;
  status: IncidentRecordStatus;
  reportedBy: string;
}

// Sample data only; replace with calls to the incidents API.
export const incidents: IncidentRecord[] = [
  {
    id: 1,
    reference: "INC-2041",
    occurredOn: "Nov 7, 2026",
    residentName: "Eleanor Whitfield",
    category: "Fall without injury",
    location: "Room A-102",
    severity: "Medium",
    status: "Under Investigation",
    reportedBy: "R. Patel, RN",
  },
  {
    id: 2,
    reference: "INC-2038",
    occurredOn: "Nov 5, 2026",
    residentName: "Harold Jensen",
    category: "Medication variance",
    location: "Med Cart 2",
    severity: "High",
    status: "Awaiting Review",
    reportedBy: "M. Okafor, RN",
  },
  {
    id: 3,
    reference: "INC-2035",
    occurredOn: "Nov 3, 2026",
    residentName: "Margaret Alvarez",
    category: "Resident-to-resident altercation",
    location: "Memory Care lounge",
    severity: "High",
    status: "Open",
    reportedBy: "S. Lindqvist, LPN",
  },
  {
    id: 4,
    reference: "INC-2029",
    occurredOn: "Oct 31, 2026",
    residentName: "Dorothy Nguyen",
    category: "Skin tear",
    location: "Room B-204",
    severity: "Low",
    status: "Awaiting Review",
    reportedBy: "A. Romero, RD",
  },
  {
    id: 5,
    reference: "INC-2024",
    occurredOn: "Oct 27, 2026",
    residentName: "Walter Chen",
    category: "Fall with minor injury",
    location: "Rehab Gym",
    severity: "Medium",
    status: "Closed",
    reportedBy: "T. Brooks, PT",
  },
  {
    id: 6,
    reference: "INC-2017",
    occurredOn: "Oct 22, 2026",
    residentName: "George Abara",
    category: "Choking episode",
    location: "Dining Room",
    severity: "High",
    status: "Closed",
    reportedBy: "L. Fischer, SLP",
  },
];
