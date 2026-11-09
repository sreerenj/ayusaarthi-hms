import Chip from "@mui/material/Chip";
import Grid from "@mui/material/Grid";
import TrendingDownIcon from "@mui/icons-material/TrendingDown";
import TrendingFlatIcon from "@mui/icons-material/TrendingFlat";
import TrendingUpIcon from "@mui/icons-material/TrendingUp";
import Card from "@mui/material/Card";
import Typography from "@mui/material/Typography";
import DataTable, { type Column } from "@/components/DataTable";
import PageIntro from "@/components/PageIntro";
import SectionCard from "@/components/SectionCard";
import type { ChipColor } from "@/lib/status";
import { qualityMeasures, reports, type QualityMeasure, type ReportDefinition } from "@/data/reports";

const categoryColor: Record<ReportDefinition["category"], ChipColor> = {
  Clinical: "primary",
  Financial: "secondary",
  Operations: "info",
  Compliance: "warning",
};

const trendColor: Record<QualityMeasure["trend"], "success" | "error" | "action"> = {
  improving: "success",
  worsening: "error",
  stable: "action",
};

const directionIcon = {
  up: TrendingUpIcon,
  down: TrendingDownIcon,
  flat: TrendingFlatIcon,
};

const columns: Column<ReportDefinition>[] = [
  { header: "Report", minWidth: 200, render: (r) => <Typography variant="body2" sx={{ fontWeight: 600 }}>{r.name}</Typography> },
  { header: "Category", render: (r) => <Chip size="small" variant="outlined" color={categoryColor[r.category]} label={r.category} /> },
  { header: "Description", minWidth: 320, render: (r) => r.description },
  { header: "Frequency", render: (r) => r.frequency },
  { header: "Last run", render: (r) => r.lastRun },
];

export const metadata = { title: "Reports" };

export default function ReportsPage() {
  return (
    <>
      <PageIntro>Quality measures and the catalog of operational, clinical and financial reports.</PageIntro>
      <Grid container spacing={3} sx={{ mb: 3 }}>
      {qualityMeasures.map((m) => {
          const Icon = directionIcon[m.direction];
          return (
          <Grid key={m.label} size={{ xs: 12, sm: 6, lg: 3 }}>
            <Card sx={{ p: 2.5, height: "100%" }}>
              <Typography variant="body2" color="text.secondary" sx={{ fontWeight: 600 }}>
                {m.label}
              </Typography>
              <Typography variant="h4" component="p" sx={{ fontWeight: 700, mt: 0.5, display: "flex", alignItems: "center", gap: 1 }}>
                {m.value}
                <Icon color={trendColor[m.trend]} fontSize="small" />
              </Typography>
              <Typography variant="caption" color="text.secondary" sx={{ mt: 1.5, display: "block" }}>
                {m.caption}
              </Typography>
            </Card>
          </Grid>
          );
        })}
      </Grid>
      <SectionCard title="Report Catalog" subtitle={`${reports.length} reports available`} disablePadding>
        <DataTable label="Reports" columns={columns} rows={reports} getKey={(r) => r.id} />
      </SectionCard>
    </>
  );
}
