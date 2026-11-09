import DashboardShell from "@/components/DashboardShell";
import { FACILITY_NAME } from "@/data/mock-dashboard";

export default function AppLayout({ children }: { children: React.ReactNode }) {
  return <DashboardShell facilityName={FACILITY_NAME}>{children}</DashboardShell>;
}
