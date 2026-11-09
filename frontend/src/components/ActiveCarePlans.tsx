import Box from "@mui/material/Box";
import Chip from "@mui/material/Chip";
import LinearProgress from "@mui/material/LinearProgress";
import Table from "@mui/material/Table";
import TableBody from "@mui/material/TableBody";
import TableCell from "@mui/material/TableCell";
import TableContainer from "@mui/material/TableContainer";
import TableHead from "@mui/material/TableHead";
import TableRow from "@mui/material/TableRow";
import Typography from "@mui/material/Typography";
import SectionCard from "@/components/SectionCard";
import { carePlanStatusColor } from "@/lib/status";
import type { CarePlan } from "@/types/dashboard";

export default function ActiveCarePlans({
  plans,
  total,
}: {
  plans: CarePlan[];
  total: number;
}) {
  return (
    <SectionCard
      title="Active Care Plans"
      subtitle={`${total} active · showing plans needing attention first`}
      disablePadding
    >
      <TableContainer>
        <Table size="small" aria-label="Active care plans">
          <TableHead>
            <TableRow>
              <TableCell sx={{ minWidth: 190 }}>Resident</TableCell>
              <TableCell>Focus</TableCell>
              <TableCell sx={{ minWidth: 140 }}>Progress</TableCell>
              <TableCell>Next review</TableCell>
              <TableCell>Status</TableCell>
            </TableRow>
          </TableHead>
          <TableBody>
            {plans.map((plan) => (
              <TableRow key={plan.id} hover>
                <TableCell>
                  <Typography variant="body2" sx={{ fontWeight: 600 }}>
                    {plan.residentName}
                  </Typography>
                  <Typography variant="caption" color="text.secondary">
                    Room {plan.room} · {plan.owner}
                  </Typography>
                </TableCell>
                <TableCell>{plan.focus}</TableCell>
                <TableCell>
                  <Box sx={{ display: "flex", alignItems: "center", gap: 1 }}>
                    <LinearProgress
                      variant="determinate"
                      value={plan.progress}
                      aria-label={`${plan.residentName} care plan progress`}
                      sx={{ flexGrow: 1, height: 6, borderRadius: 3 }}
                    />
                    <Typography variant="caption" color="text.secondary">
                      {plan.progress}%
                    </Typography>
                  </Box>
                </TableCell>
                <TableCell sx={{ whiteSpace: "nowrap" }}>{plan.nextReview}</TableCell>
                <TableCell>
                  <Chip size="small" label={plan.status} color={carePlanStatusColor[plan.status]} />
                </TableCell>
              </TableRow>
            ))}
          </TableBody>
        </Table>
      </TableContainer>
    </SectionCard>
  );
}
