export type AdministrationStatus = "Given" | "Due" | "Overdue" | "Refused" | "Held";

export interface Administration {
  id: number;
  time: string;
  residentName: string;
  room: string;
  medication: string;
  doseRoute: string;
  controlled: boolean;
  status: AdministrationStatus;
}

// Sample data only; replace with calls to the eMAR schedule API.
export const administrations: Administration[] = [
  {
    id: 1,
    time: "08:00",
    residentName: "Eleanor Whitfield",
    room: "A-102",
    medication: "Metoprolol",
    doseRoute: "50 mg · PO",
    controlled: false,
    status: "Overdue",
  },
  {
    id: 2,
    time: "08:00",
    residentName: "Margaret Alvarez",
    room: "C-008",
    medication: "Donepezil",
    doseRoute: "10 mg · PO",
    controlled: false,
    status: "Refused",
  },
  {
    id: 3,
    time: "08:30",
    residentName: "Dorothy Nguyen",
    room: "B-204",
    medication: "Metformin",
    doseRoute: "500 mg · PO",
    controlled: false,
    status: "Given",
  },
  {
    id: 4,
    time: "09:00",
    residentName: "Harold Jensen",
    room: "B-215",
    medication: "Warfarin",
    doseRoute: "5 mg · PO",
    controlled: false,
    status: "Held",
  },
  {
    id: 5,
    time: "09:00",
    residentName: "Frank Delgado",
    room: "A-114",
    medication: "Morphine sulfate",
    doseRoute: "5 mg · SL",
    controlled: true,
    status: "Given",
  },
  {
    id: 6,
    time: "10:00",
    residentName: "Walter Chen",
    room: "A-110",
    medication: "Oxycodone",
    doseRoute: "5 mg · PO",
    controlled: true,
    status: "Due",
  },
  {
    id: 7,
    time: "12:00",
    residentName: "George Abara",
    room: "B-209",
    medication: "Atorvastatin",
    doseRoute: "20 mg · PO",
    controlled: false,
    status: "Due",
  },
  {
    id: 8,
    time: "12:00",
    residentName: "Dorothy Nguyen",
    room: "B-204",
    medication: "Insulin glargine",
    doseRoute: "14 units · SC",
    controlled: false,
    status: "Due",
  },
];
