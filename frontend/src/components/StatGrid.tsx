import Grid from "@mui/material/Grid";
import StatCard from "@/components/StatCard";

type StatCardProps = React.ComponentProps<typeof StatCard>;

export default function StatGrid({ items }: { items: StatCardProps[] }) {
  return (
    <Grid container spacing={3} sx={{ mb: 3 }}>
      {items.map((item) => (
        <Grid key={item.label} size={{ xs: 12, sm: 6, lg: 3 }}>
          <StatCard {...item} />
        </Grid>
      ))}
    </Grid>
  );
}
