import Box from "@mui/material/Box";
import Chip from "@mui/material/Chip";
import Typography from "@mui/material/Typography";
import GroupsIcon from "@mui/icons-material/GroupsOutlined";
import PersonAddIcon from "@mui/icons-material/WarningAmberOutlined";
import ElderlyIcon from "@mui/icons-material/ElderlyOutlined";
import LocalHospitalIcon from "@mui/icons-material/LocalHospitalOutlined";
import DataTable, { type Column } from "@/components/DataTable";
import PageIntro from "@/components/PageIntro";
import SectionCard from "@/components/SectionCard";
import StatGrid from "@/components/StatGrid";
import type { ChipColor } from "@/lib/status";
import { residents, type ResidentRecord, type ResidentStatus } from "@/data/residents";

const statusColor: Record<ResidentStatus, ChipColor> = {
  Active: "success",
  "Hospital Leave": "warning",
  "Discharge Pending": "info",
};

const columns: Column<ResidentRecord>[] = [
  {
    header: "Resident",
    minWidth: 200,
    render: (r) => (
      <>
        <Typography variant="body2" sx={{ fontWeight: 600 }}>
          {r.name}
        </Typography>
        <Typography variant="caption" color="text.secondary">
          {r.age} yrs · {r.gender}
        </Typography>
      </>
    ),
  },
  { header: "Room", render: (r) => r.room },
  { header: "Level of care", render: (r) => r.levelOfCare },
  { header: "Primary diagnosis", minWidth: 200, render: (r) => r.primaryDiagnosis },
  { header: "Admitted", render: (r) => r.admittedOn },
  {
    header: "Flags",
    render: (r) => (
      <Box sx={{ display: "flex", gap: 0.5 }}>
        {r.fallRisk && <Chip size="small" color="warning" variant="outlined" label="Fall risk" />}
        {r.dnr && <Chip size="small" variant="outlined" label="DNR" />}
      </Box>
    ),
  },
  {
    header: "Status",
    render: (r) => <Chip size="small" color={statusColor[r.status]} label={r.status} />,
  },
];

export const metadata = { title: "Residents" };

export default function ResidentsPage() {
  const active = residents.filter((r) => r.status === "Active").length;
  const fallRisk = residents.filter((r) => r.fallRisk).length;

  return (
    <>
      <PageIntro>Census, clinical flags and current status for every resident in the facility.</PageIntro>
      <StatGrid
        items={[
          { label: "Total Residents", value: residents.length, caption: "On the current census", icon: <GroupsIcon />, color: "primary" },
          { label: "Active In-House", value: active, caption: "Currently in the facility", icon: <ElderlyIcon />, color: "secondary" },
          { label: "High Fall Risk", value: fallRisk, caption: "Fall precautions in place", icon: <PersonAddIcon />, color: "warning" },
          { label: "Away / Pending", value: residents.length - active, caption: "Hospital leave or discharge pending", icon: <LocalHospitalIcon />, color: "error" },
        ]}
      />
      <SectionCard title="Resident Directory" subtitle={`${residents.length} residents`} disablePadding>
        <DataTable label="Residents" columns={columns} rows={residents} getKey={(r) => r.id} />
      </SectionCard>
    </>
  );
}
