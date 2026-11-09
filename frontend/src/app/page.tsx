import Grid from "@mui/material/Grid";
import AssignmentIcon from "@mui/icons-material/AssignmentOutlined";
import MedicationIcon from "@mui/icons-material/MedicationOutlined";
import PeopleIcon from "@mui/icons-material/PeopleAltOutlined";
import ReportIcon from "@mui/icons-material/ReportGmailerrorredOutlined";
import ActiveCarePlans from "@/components/ActiveCarePlans";
import DashboardShell from "@/components/DashboardShell";
import MedicationAlerts from "@/components/MedicationAlerts";
import OutstandingIncidents from "@/components/OutstandingIncidents";
import ResidentSummary from "@/components/ResidentSummary";
import StatCard from "@/components/StatCard";
import TodaysAppointments from "@/components/TodaysAppointments";
import { getDashboardData } from "@/lib/dashboard-service";

export default async function DashboardPage() {
  const data = await getDashboardData();
  const { residentSummary, medicationAlerts, incidents } = data;
  const highAlerts = medicationAlerts.filter((a) => a.severity === "High").length;
  const highIncidents = incidents.filter((i) => i.severity === "High").length;

  return (
    <DashboardShell facilityName={data.facilityName}>
      <Grid container spacing={3}>
        <Grid size={{ xs: 12, sm: 6, lg: 3 }}>
          <StatCard
            label="Total Residents"
            value={residentSummary.totalResidents}
            caption={`${residentSummary.totalBeds - residentSummary.totalResidents} beds available`}
            icon={<PeopleIcon />}
            color="primary"
          />
        </Grid>
        <Grid size={{ xs: 12, sm: 6, lg: 3 }}>
          <StatCard
            label="Active Care Plans"
            value={data.activeCarePlanCount}
            caption={`${data.carePlans.filter((p) => p.status !== "On Track").length} need attention`}
            icon={<AssignmentIcon />}
            color="secondary"
          />
        </Grid>
        <Grid size={{ xs: 12, sm: 6, lg: 3 }}>
          <StatCard
            label="Medication Alerts"
            value={medicationAlerts.length}
            caption={`${highAlerts} high priority`}
            icon={<MedicationIcon />}
            color="warning"
          />
        </Grid>
        <Grid size={{ xs: 12, sm: 6, lg: 3 }}>
          <StatCard
            label="Outstanding Incidents"
            value={incidents.length}
            caption={`${highIncidents} high severity`}
            icon={<ReportIcon />}
            color="error"
          />
        </Grid>

        <Grid size={{ xs: 12, lg: 4 }}>
          <ResidentSummary data={residentSummary} />
        </Grid>
        <Grid size={{ xs: 12, lg: 8 }}>
          <ActiveCarePlans plans={data.carePlans} total={data.activeCarePlanCount} />
        </Grid>

        <Grid size={{ xs: 12, lg: 6 }}>
          <MedicationAlerts alerts={medicationAlerts} />
        </Grid>
        <Grid size={{ xs: 12, lg: 6 }}>
          <TodaysAppointments appointments={data.appointments} />
        </Grid>

        <Grid size={12}>
          <OutstandingIncidents incidents={incidents} />
        </Grid>
      </Grid>
    </DashboardShell>
  );
}
