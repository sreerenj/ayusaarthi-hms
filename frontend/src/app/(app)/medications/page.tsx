import Chip from "@mui/material/Chip";
import Grid from "@mui/material/Grid";
import Typography from "@mui/material/Typography";
import CheckCircleIcon from "@mui/icons-material/CheckCircleOutlined";
import PendingIcon from "@mui/icons-material/PendingActionsOutlined";
import WarningIcon from "@mui/icons-material/WarningAmberOutlined";
import BlockIcon from "@mui/icons-material/BlockOutlined";
import DataTable, { type Column } from "@/components/DataTable";
import MedicationAlerts from "@/components/MedicationAlerts";
import PageIntro from "@/components/PageIntro";
import SectionCard from "@/components/SectionCard";
import StatGrid from "@/components/StatGrid";
import type { ChipColor } from "@/lib/status";
import { mockDashboardData } from "@/data/mock-dashboard";
import { administrations, type Administration, type AdministrationStatus } from "@/data/medications";

const statusColor: Record<AdministrationStatus, ChipColor> = {
  Given: "success",
  Due: "info",
  Overdue: "error",
  Refused: "warning",
  Held: "default",
};

const columns: Column<Administration>[] = [
  { header: "Time", render: (a) => a.time },
  {
    header: "Resident",
    minWidth: 170,
    render: (a) => (
      <>
        <Typography variant="body2" sx={{ fontWeight: 600 }}>
          {a.residentName}
        </Typography>
        <Typography variant="caption" color="text.secondary">
          Room {a.room}
        </Typography>
      </>
    ),
  },
  {
    header: "Medication",
    minWidth: 170,
    render: (a) => (
      <>
        {a.medication}
        {a.controlled && <Chip size="small" variant="outlined" label="Controlled" sx={{ ml: 1 }} />}
      </>
    ),
  },
  { header: "Dose · Route", render: (a) => a.doseRoute },
  { header: "Status", render: (a) => <Chip size="small" color={statusColor[a.status]} label={a.status} /> },
];

export const metadata = { title: "Medications" };

export default function MedicationsPage() {
  const count = (status: AdministrationStatus) => administrations.filter((a) => a.status === status).length;

  return (
    <>
      <PageIntro>Today&apos;s medication administration record and open medication alerts.</PageIntro>
      <StatGrid
        items={[
          { label: "Given", value: count("Given"), caption: "Documented on time", icon: <CheckCircleIcon />, color: "primary" },
          { label: "Due", value: count("Due"), caption: "Upcoming this shift", icon: <PendingIcon />, color: "secondary" },
          { label: "Overdue", value: count("Overdue"), caption: "Past the administration window", icon: <WarningIcon />, color: "error" },
          { label: "Refused / Held", value: count("Refused") + count("Held"), caption: "Needs prescriber follow-up", icon: <BlockIcon />, color: "warning" },
        ]}
      />
      <Grid container spacing={3}>
        <Grid size={{ xs: 12, xl: 7 }}>
          <SectionCard title="eMAR — Today" subtitle={`${administrations.length} scheduled administrations`} disablePadding>
            <DataTable label="Medication administration record" columns={columns} rows={administrations} getKey={(a) => a.id} />
          </SectionCard>
        </Grid>
        <Grid size={{ xs: 12, xl: 5 }}>
          <MedicationAlerts alerts={mockDashboardData.medicationAlerts} />
        </Grid>
      </Grid>
    </>
  );
}
