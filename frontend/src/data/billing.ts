export type ClaimStatus = "Draft" | "Submitted" | "Paid" | "Partially Paid" | "Denied";

export interface Claim {
  id: number;
  claimNumber: string;
  residentName: string;
  payer: string;
  servicePeriod: string;
  amount: number;
  status: ClaimStatus;
  daysOutstanding: number;
}

// Sample data only; replace with calls to the billing API.
export const claims: Claim[] = [
  {
    id: 1,
    claimNumber: "CLM-10482",
    residentName: "Eleanor Whitfield",
    payer: "Medicare Part A",
    servicePeriod: "Oct 1 – Oct 31, 2026",
    amount: 18450,
    status: "Submitted",
    daysOutstanding: 9,
  },
  {
    id: 2,
    claimNumber: "CLM-10479",
    residentName: "Harold Jensen",
    payer: "Medicare Part A",
    servicePeriod: "Oct 2 – Oct 31, 2026",
    amount: 15720,
    status: "Submitted",
    daysOutstanding: 9,
  },
  {
    id: 3,
    claimNumber: "CLM-10471",
    residentName: "Margaret Alvarez",
    payer: "Medicaid",
    servicePeriod: "Oct 1 – Oct 31, 2026",
    amount: 9860,
    status: "Denied",
    daysOutstanding: 22,
  },
  {
    id: 4,
    claimNumber: "CLM-10466",
    residentName: "Walter Chen",
    payer: "Blue Cross PPO",
    servicePeriod: "Oct 28 – Oct 31, 2026",
    amount: 4310,
    status: "Draft",
    daysOutstanding: 0,
  },
  {
    id: 5,
    claimNumber: "CLM-10452",
    residentName: "Dorothy Nguyen",
    payer: "Medicaid",
    servicePeriod: "Sep 1 – Sep 30, 2026",
    amount: 9860,
    status: "Paid",
    daysOutstanding: 0,
  },
  {
    id: 6,
    claimNumber: "CLM-10447",
    residentName: "Frank Delgado",
    payer: "Medicare Hospice",
    servicePeriod: "Sep 17 – Sep 30, 2026",
    amount: 7280,
    status: "Partially Paid",
    daysOutstanding: 41,
  },
  {
    id: 7,
    claimNumber: "CLM-10439",
    residentName: "George Abara",
    payer: "Aetna Medicare Advantage",
    servicePeriod: "Sep 1 – Sep 30, 2026",
    amount: 14100,
    status: "Paid",
    daysOutstanding: 0,
  },
];
