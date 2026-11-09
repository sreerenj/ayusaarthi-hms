import type { ChipProps } from "@mui/material/Chip";
import type {
  AppointmentStatus,
  CarePlanStatus,
  IncidentStatus,
  Severity,
} from "@/types/dashboard";

type ChipColor = NonNullable<ChipProps["color"]>;

export const severityColor: Record<Severity, ChipColor> = {
  High: "error",
  Medium: "warning",
  Low: "info",
};

export const carePlanStatusColor: Record<CarePlanStatus, ChipColor> = {
  "On Track": "success",
  "Needs Review": "warning",
  Overdue: "error",
};

export const appointmentStatusColor: Record<AppointmentStatus, ChipColor> = {
  Scheduled: "default",
  "In Transit": "info",
  Completed: "success",
};

export const incidentStatusColor: Record<IncidentStatus, ChipColor> = {
  Open: "error",
  "Under Investigation": "warning",
  "Awaiting Review": "info",
};

export function initials(name: string): string {
  return name
    .split(" ")
    .map((part) => part[0])
    .slice(0, 2)
    .join("");
}
