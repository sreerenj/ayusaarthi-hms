import Box from "@mui/material/Box";
import Chip from "@mui/material/Chip";
import LinearProgress from "@mui/material/LinearProgress";
import Typography from "@mui/material/Typography";
import AssignmentIcon from "@mui/icons-material/AssignmentOutlined";
import CheckCircleIcon from "@mui/icons-material/CheckCircleOutlined";
import RateReviewIcon from "@mui/icons-material/RateReviewOutlined";
import ScheduleIcon from "@mui/icons-material/ScheduleOutlined";
import DataTable, { type Column } from "@/components/DataTable";
import PageIntro from "@/components/PageIntro";
import SectionCard from "@/components/SectionCard";
import StatGrid from "@/components/StatGrid";
import { carePlanStatusColor } from "@/lib/status";
import { carePlans, type CarePlanRecord } from "@/data/care-plans";

const columns: Column<CarePlanRecord>[] = [
  {
    header: "Resident",
    minWidth: 190,
    render: (p) => (
      <>
        <Typography variant="body2" sx={{ fontWeight: 600 }}>
          {p.residentName}
        </Typography>
        <Typography variant="caption" color="text.secondary">
          Room {p.room}
        </Typography>
      </>
    ),
  },
  { header: "Focus", minWidth: 220, render: (p) => p.focus },
  { header: "Owner", render: (p) => p.owner },
  { header: "Goals", align: "right", render: (p) => p.goals },
  {
    header: "Progress",
    minWidth: 150,
    render: (p) => (
      <Box sx={{ display: "flex", alignItems: "center", gap: 1 }}>
        <LinearProgress
          variant="determinate"
          value={p.progress}
          aria-label={`${p.residentName} care plan progress`}
          sx={{ flexGrow: 1, height: 6, borderRadius: 3 }}
        />
        <Typography variant="caption" color="text.secondary">
          {p.progress}%
        </Typography>
      </Box>
    ),
  },
  { header: "Started", render: (p) => p.startedOn },
  { header: "Next review", render: (p) => p.nextReview },
  {
    header: "Status",
    render: (p) => <Chip size="small" color={carePlanStatusColor[p.status]} label={p.status} />,
  },
];

export const metadata = { title: "Care Plans" };

export default function CarePlansPage() {
  const count = (status: string) => carePlans.filter((p) => p.status === status).length;

  return (
    <>
      <PageIntro>Individualized care plans, their progress and upcoming reviews.</PageIntro>
      <StatGrid
        items={[
          { label: "Active Care Plans", value: carePlans.length, caption: "Across all residents", icon: <AssignmentIcon />, color: "primary" },
          { label: "On Track", value: count("On Track"), caption: "Progressing as planned", icon: <CheckCircleIcon />, color: "secondary" },
          { label: "Needs Review", value: count("Needs Review"), caption: "Review due within 2 days", icon: <RateReviewIcon />, color: "warning" },
          { label: "Overdue", value: count("Overdue"), caption: "Past their review date", icon: <ScheduleIcon />, color: "error" },
        ]}
      />
      <SectionCard title="Care Plans" subtitle={`${carePlans.length} active plans`} disablePadding>
        <DataTable label="Care plans" columns={columns} rows={carePlans} getKey={(p) => p.id} />
      </SectionCard>
    </>
  );
}
