import Avatar from "@mui/material/Avatar";
import Box from "@mui/material/Box";
import Chip from "@mui/material/Chip";
import Divider from "@mui/material/Divider";
import List from "@mui/material/List";
import ListItem from "@mui/material/ListItem";
import ListItemAvatar from "@mui/material/ListItemAvatar";
import ListItemText from "@mui/material/ListItemText";
import Typography from "@mui/material/Typography";
import MedicationIcon from "@mui/icons-material/MedicationOutlined";
import SectionCard from "@/components/SectionCard";
import { severityColor } from "@/lib/status";
import type { MedicationAlert } from "@/types/dashboard";

export default function MedicationAlerts({ alerts }: { alerts: MedicationAlert[] }) {
  const highCount = alerts.filter((a) => a.severity === "High").length;

  return (
    <SectionCard
      title="Medication Alerts"
      subtitle={`${alerts.length} open · ${highCount} high priority`}
      disablePadding
    >
      <List disablePadding>
        {alerts.map((alert, index) => (
          <Box key={alert.id}>
            {index > 0 && <Divider component="li" />}
            <ListItem alignItems="flex-start" sx={{ px: 2.5, py: 1.5 }}>
              <ListItemAvatar>
                <Avatar
                  sx={{
                    bgcolor: `${severityColor[alert.severity]}.light`,
                    color: `${severityColor[alert.severity]}.contrastText`,
                  }}
                >
                  <MedicationIcon />
                </Avatar>
              </ListItemAvatar>
              <ListItemText
                disableTypography
                primary={
                  <Box sx={{ display: "flex", justifyContent: "space-between", gap: 1, flexWrap: "wrap" }}>
                    <Typography variant="body2" sx={{ fontWeight: 600 }}>
                      {alert.medication}
                    </Typography>
                    <Box sx={{ display: "flex", gap: 0.75 }}>
                      <Chip size="small" variant="outlined" label={alert.type} />
                      <Chip size="small" label={alert.severity} color={severityColor[alert.severity]} />
                    </Box>
                  </Box>
                }
                secondary={
                  <>
                    <Typography variant="body2" color="text.secondary">
                      {alert.residentName} · {alert.room}
                    </Typography>
                    <Typography variant="body2" color="text.secondary">
                      {alert.detail}
                    </Typography>
                  </>
                }
              />
            </ListItem>
          </Box>
        ))}
      </List>
    </SectionCard>
  );
}
