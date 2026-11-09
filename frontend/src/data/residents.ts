export type ResidentStatus = "Active" | "Hospital Leave" | "Discharge Pending";

export interface ResidentRecord {
  id: number;
  name: string;
  age: number;
  gender: string;
  room: string;
  levelOfCare: string;
  admittedOn: string;
  primaryDiagnosis: string;
  fallRisk: boolean;
  dnr: boolean;
  status: ResidentStatus;
}

// Sample data only; replace with calls to GET /api/v1/residents.
export const residents: ResidentRecord[] = [
  {
    id: 1,
    name: "Eleanor Whitfield",
    age: 86,
    gender: "Female",
    room: "A-102",
    levelOfCare: "LTC",
    admittedOn: "Mar 14, 2025",
    primaryDiagnosis: "Congestive heart failure",
    fallRisk: true,
    dnr: false,
    status: "Active",
  },
  {
    id: 2,
    name: "Harold Jensen",
    age: 79,
    gender: "Male",
    room: "B-215",
    levelOfCare: "SNF",
    admittedOn: "Oct 2, 2026",
    primaryDiagnosis: "Stage 3 pressure injury",
    fallRisk: false,
    dnr: true,
    status: "Active",
  },
  {
    id: 3,
    name: "Margaret Alvarez",
    age: 91,
    gender: "Female",
    room: "C-008",
    levelOfCare: "Memory Care",
    admittedOn: "Jan 22, 2024",
    primaryDiagnosis: "Alzheimer's disease",
    fallRisk: true,
    dnr: true,
    status: "Active",
  },
  {
    id: 4,
    name: "Walter Chen",
    age: 74,
    gender: "Male",
    room: "A-110",
    levelOfCare: "Rehab",
    admittedOn: "Oct 28, 2026",
    primaryDiagnosis: "Hip fracture, post-surgical",
    fallRisk: true,
    dnr: false,
    status: "Active",
  },
  {
    id: 5,
    name: "Dorothy Nguyen",
    age: 83,
    gender: "Female",
    room: "B-204",
    levelOfCare: "LTC",
    admittedOn: "Jun 9, 2025",
    primaryDiagnosis: "Type 2 diabetes mellitus",
    fallRisk: false,
    dnr: false,
    status: "Active",
  },
  {
    id: 6,
    name: "Frank Delgado",
    age: 88,
    gender: "Male",
    room: "A-114",
    levelOfCare: "Hospice",
    admittedOn: "Sep 17, 2026",
    primaryDiagnosis: "End-stage COPD",
    fallRisk: false,
    dnr: true,
    status: "Active",
  },
  {
    id: 7,
    name: "Ruth Kowalski",
    age: 81,
    gender: "Female",
    room: "C-012",
    levelOfCare: "Assisted Living",
    admittedOn: "Feb 3, 2026",
    primaryDiagnosis: "Osteoarthritis",
    fallRisk: false,
    dnr: false,
    status: "Hospital Leave",
  },
  {
    id: 8,
    name: "George Abara",
    age: 77,
    gender: "Male",
    room: "B-209",
    levelOfCare: "SNF",
    admittedOn: "Aug 30, 2026",
    primaryDiagnosis: "Stroke recovery",
    fallRisk: true,
    dnr: false,
    status: "Discharge Pending",
  },
];
