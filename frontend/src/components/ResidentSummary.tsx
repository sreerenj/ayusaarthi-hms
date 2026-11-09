import Box from "@mui/material/Box";
import Divider from "@mui/material/Divider";
import LinearProgress from "@mui/material/LinearProgress";
import Typography from "@mui/material/Typography";
import SectionCard from "@/components/SectionCard";
import type { ResidentSummaryData } from "@/types/dashboard";

function Metric({ label, value }: { label: string; value: number }) {
  return (
    <Box sx={{ flex: 1, textAlign: "center" }}>
      <Typography variant="h6" component="p">
        {value}
      </Typography>
      <Typography variant="caption" color="text.secondary">
        {label}
      </Typography>
    </Box>
  );
}

export default function ResidentSummary({ data }: { data: ResidentSummaryData }) {
  const occupancy = Math.round((data.totalResidents / data.totalBeds) * 100);

  return (
    <SectionCard
      title="Resident Summary"
      subtitle={`${data.totalResidents} of ${data.totalBeds} beds occupied`}
    >
      <Box sx={{ mb: 2.5 }}>
        <Box sx={{ display: "flex", justifyContent: "space-between", mb: 0.5 }}>
          <Typography variant="body2" sx={{ fontWeight: 600 }}>
            Occupancy
          </Typography>
          <Typography variant="body2" sx={{ fontWeight: 600 }}>
            {occupancy}%
          </Typography>
        </Box>
        <LinearProgress
          variant="determinate"
          value={occupancy}
          aria-label="Bed occupancy"
          sx={{ height: 8, borderRadius: 4 }}
        />
      </Box>

      <Box sx={{ display: "flex", mb: 2.5 }}>
        <Metric label="Admissions (MTD)" value={data.admissionsThisMonth} />
        <Metric label="Discharges (MTD)" value={data.dischargesThisMonth} />
        <Metric label="High fall risk" value={data.highFallRisk} />
        <Metric label="DNR on file" value={data.dnrOnFile} />
      </Box>

      <Divider sx={{ mb: 2 }} />

      <Typography variant="subtitle2" sx={{ mb: 1.5 }}>
        By level of care
      </Typography>
      {data.byLevelOfCare.map(({ label, count }) => (
        <Box key={label} sx={{ mb: 1.25 }}>
          <Box sx={{ display: "flex", justifyContent: "space-between" }}>
            <Typography variant="body2">{label}</Typography>
            <Typography variant="body2" color="text.secondary">
              {count}
            </Typography>
          </Box>
          <LinearProgress
            variant="determinate"
            color="secondary"
            value={(count / data.totalResidents) * 100}
            aria-label={`${label} residents`}
            sx={{ height: 6, borderRadius: 3 }}
          />
        </Box>
      ))}
    </SectionCard>
  );
}
