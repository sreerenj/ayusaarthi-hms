import Chip from "@mui/material/Chip";
import CheckCircleIcon from "@mui/icons-material/CheckCircleOutlined";
import ErrorIcon from "@mui/icons-material/ErrorOutlined";
import FolderOpenIcon from "@mui/icons-material/FolderOpenOutlined";
import SearchIcon from "@mui/icons-material/ManageSearchOutlined";
import DataTable, { type Column } from "@/components/DataTable";
import PageIntro from "@/components/PageIntro";
import SectionCard from "@/components/SectionCard";
import StatGrid from "@/components/StatGrid";
import { severityColor, type ChipColor } from "@/lib/status";
import { incidents, type IncidentRecord, type IncidentRecordStatus } from "@/data/incidents";

const statusColor: Record<IncidentRecordStatus, ChipColor> = {
  Open: "error",
  "Under Investigation": "warning",
  "Awaiting Review": "info",
  Closed: "success",
};

const columns: Column<IncidentRecord>[] = [
  { header: "Reference", render: (i) => i.reference },
  { header: "Date", render: (i) => i.occurredOn },
  { header: "Resident", minWidth: 160, render: (i) => i.residentName },
  { header: "Category", minWidth: 200, render: (i) => i.category },
  { header: "Location", render: (i) => i.location },
  { header: "Severity", render: (i) => <Chip size="small" color={severityColor[i.severity]} label={i.severity} /> },
  { header: "Status", render: (i) => <Chip size="small" variant="outlined" color={statusColor[i.status]} label={i.status} /> },
  { header: "Reported by", render: (i) => i.reportedBy },
];

export const metadata = { title: "Incidents" };

export default function IncidentsPage() {
  const count = (status: IncidentRecordStatus) => incidents.filter((i) => i.status === status).length;
  const outstanding = incidents.length - count("Closed");

  return (
    <>
      <PageIntro>Incident reports, their severity and where each one stands in the review process.</PageIntro>
      <StatGrid
        items={[
          { label: "Outstanding", value: outstanding, caption: "Not yet closed", icon: <ErrorIcon />, color: "error" },
          { label: "Open", value: count("Open"), caption: "Awaiting assignment", icon: <FolderOpenIcon />, color: "warning" },
          { label: "Under Investigation", value: count("Under Investigation"), caption: "Being investigated", icon: <SearchIcon />, color: "secondary" },
          { label: "Closed", value: count("Closed"), caption: "Resolved this month", icon: <CheckCircleIcon />, color: "primary" },
        ]}
      />
      <SectionCard title="Incident Reports" subtitle={`${incidents.length} reports`} disablePadding>
        <DataTable label="Incidents" columns={columns} rows={incidents} getKey={(i) => i.id} />
      </SectionCard>
    </>
  );
}
