import Box from "@mui/material/Box";
import Card from "@mui/material/Card";
import CardContent from "@mui/material/CardContent";
import Typography from "@mui/material/Typography";

interface SectionCardProps {
  title: string;
  subtitle?: string;
  action?: React.ReactNode;
  children: React.ReactNode;
  disablePadding?: boolean;
}

export default function SectionCard({
  title,
  subtitle,
  action,
  children,
  disablePadding = false,
}: SectionCardProps) {
  return (
    <Card sx={{ height: "100%", display: "flex", flexDirection: "column" }}>
      <Box
        sx={{
          display: "flex",
          alignItems: "center",
          justifyContent: "space-between",
          gap: 2,
          px: 2.5,
          pt: 2,
          pb: 1.5,
        }}
      >
        <Box>
          <Typography variant="h6" component="h2">
            {title}
          </Typography>
          {subtitle && (
            <Typography variant="body2" color="text.secondary">
              {subtitle}
            </Typography>
          )}
        </Box>
        {action}
      </Box>
      <CardContent sx={{ flexGrow: 1, p: disablePadding ? 0 : 2.5, pt: disablePadding ? 0 : 0.5, "&:last-child": { pb: disablePadding ? 0 : 2.5 } }}>
        {children}
      </CardContent>
    </Card>
  );
}
