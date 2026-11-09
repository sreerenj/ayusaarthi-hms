import Typography from "@mui/material/Typography";

export default function PageIntro({ children }: { children: React.ReactNode }) {
  return (
    <Typography color="text.secondary" sx={{ mb: 3 }}>
      {children}
    </Typography>
  );
}
