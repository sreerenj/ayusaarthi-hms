import Avatar from "@mui/material/Avatar";
import Box from "@mui/material/Box";
import Card from "@mui/material/Card";
import Typography from "@mui/material/Typography";

interface StatCardProps {
  label: string;
  value: string | number;
  caption: string;
  icon: React.ReactNode;
  color: "primary" | "secondary" | "warning" | "error";
}

export default function StatCard({ label, value, caption, icon, color }: StatCardProps) {
  return (
    <Card sx={{ p: 2.5, height: "100%" }}>
      <Box sx={{ display: "flex", justifyContent: "space-between", alignItems: "flex-start" }}>
        <Box>
          <Typography variant="body2" color="text.secondary" sx={{ fontWeight: 600 }}>
            {label}
          </Typography>
          <Typography variant="h4" component="p" sx={{ fontWeight: 700, mt: 0.5 }}>
            {value}
          </Typography>
        </Box>
        <Avatar
          variant="rounded"
          sx={{ bgcolor: `${color}.main`, color: `${color}.contrastText`, width: 44, height: 44 }}
        >
          {icon}
        </Avatar>
      </Box>
      <Typography variant="caption" color="text.secondary" sx={{ mt: 1.5, display: "block" }}>
        {caption}
      </Typography>
    </Card>
  );
}
