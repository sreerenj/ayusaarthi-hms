import Chip from "@mui/material/Chip";
import Table from "@mui/material/Table";
import TableBody from "@mui/material/TableBody";
import TableCell from "@mui/material/TableCell";
import TableContainer from "@mui/material/TableContainer";
import TableHead from "@mui/material/TableHead";
import TableRow from "@mui/material/TableRow";
import SectionCard from "@/components/SectionCard";
import { incidentStatusColor, severityColor } from "@/lib/status";
import type { Incident } from "@/types/dashboard";

export default function OutstandingIncidents({ incidents }: { incidents: Incident[] }) {
  return (
    <SectionCard
      title="Outstanding Incidents"
      subtitle={`${incidents.length} awaiting investigation or sign-off`}
      disablePadding
    >
      <TableContainer>
        <Table size="small" aria-label="Outstanding incidents">
          <TableHead>
            <TableRow>
              <TableCell>Reference</TableCell>
              <TableCell>Resident</TableCell>
              <TableCell>Category</TableCell>
              <TableCell>Severity</TableCell>
              <TableCell>Status</TableCell>
              <TableCell align="right">Days open</TableCell>
            </TableRow>
          </TableHead>
          <TableBody>
            {incidents.map((incident) => (
              <TableRow key={incident.id} hover>
                <TableCell sx={{ fontWeight: 600 }}>{incident.reference}</TableCell>
                <TableCell>{incident.residentName}</TableCell>
                <TableCell>{incident.category}</TableCell>
                <TableCell>
                  <Chip size="small" label={incident.severity} color={severityColor[incident.severity]} />
                </TableCell>
                <TableCell>
                  <Chip
                    size="small"
                    variant="outlined"
                    label={incident.status}
                    color={incidentStatusColor[incident.status]}
                  />
                </TableCell>
                <TableCell align="right">{incident.daysOpen}</TableCell>
              </TableRow>
            ))}
          </TableBody>
        </Table>
      </TableContainer>
    </SectionCard>
  );
}
