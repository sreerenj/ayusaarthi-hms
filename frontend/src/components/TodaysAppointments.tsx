import Avatar from "@mui/material/Avatar";
import Box from "@mui/material/Box";
import Chip from "@mui/material/Chip";
import Divider from "@mui/material/Divider";
import Typography from "@mui/material/Typography";
import SectionCard from "@/components/SectionCard";
import { appointmentStatusColor, initials } from "@/lib/status";
import type { Appointment } from "@/types/dashboard";

export default function TodaysAppointments({ appointments }: { appointments: Appointment[] }) {
  const remaining = appointments.filter((a) => a.status !== "Completed").length;

  return (
    <SectionCard
      title="Today's Appointments"
      subtitle={`${appointments.length} scheduled · ${remaining} remaining`}
      disablePadding
    >
      <Box component="ul" sx={{ listStyle: "none", m: 0, p: 0 }}>
        {appointments.map((appt, index) => (
          <Box component="li" key={appt.id}>
            {index > 0 && <Divider />}
            <Box sx={{ display: "flex", alignItems: "center", gap: 2, px: 2.5, py: 1.5 }}>
              <Typography
                variant="body2"
                color="primary"
                sx={{ fontWeight: 700, width: 48, flexShrink: 0 }}
              >
                {appt.time}
              </Typography>
              <Avatar sx={{ width: 36, height: 36, fontSize: 13 }}>{initials(appt.residentName)}</Avatar>
              <Box sx={{ flexGrow: 1, minWidth: 0 }}>
                <Typography variant="body2" sx={{ fontWeight: 600 }}>
                  {appt.residentName} · {appt.type}
                </Typography>
                <Typography variant="body2" color="text.secondary" noWrap>
                  {appt.provider} · {appt.location}
                </Typography>
              </Box>
              <Chip size="small" label={appt.status} color={appointmentStatusColor[appt.status]} />
            </Box>
          </Box>
        ))}
      </Box>
    </SectionCard>
  );
}
