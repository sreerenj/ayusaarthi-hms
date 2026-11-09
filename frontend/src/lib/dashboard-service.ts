import { mockDashboardData } from "@/data/mock-dashboard";
import type { DashboardData } from "@/types/dashboard";

export async function getDashboardData(): Promise<DashboardData> {
  return mockDashboardData;
}
