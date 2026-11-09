import Chip from "@mui/material/Chip";
import Typography from "@mui/material/Typography";
import BadgeIcon from "@mui/icons-material/BadgeOutlined";
import EventBusyIcon from "@mui/icons-material/EventBusyOutlined";
import VerifiedIcon from "@mui/icons-material/VerifiedOutlined";
import WorkIcon from "@mui/icons-material/WorkOutlined";
import DataTable, { type Column } from "@/components/DataTable";
import PageIntro from "@/components/PageIntro";
import SectionCard from "@/components/SectionCard";
import StatGrid from "@/components/StatGrid";
import type { ChipColor } from "@/lib/status";
import { staff, type CredentialState, type StaffMember, type StaffStatus } from "@/data/staff";

const statusColor: Record<StaffStatus, ChipColor> = {
  "On Duty": "success",
  "Off Duty": "default",
  "On Leave": "info",
};

const credentialColor: Record<CredentialState, ChipColor> = {
  Valid: "success",
  "Expiring Soon": "warning",
  Expired: "error",
};

const columns: Column<StaffMember>[] = [
  {
    header: "Name",
    minWidth: 180,
    render: (s) => (
      <>
        <Typography variant="body2" sx={{ fontWeight: 600 }}>
          {s.name}
        </Typography>
        <Typography variant="caption" color="text.secondary">
          {s.role}
        </Typography>
      </>
    ),
  },
  { header: "Department", render: (s) => s.department },
  { header: "Shift", render: (s) => s.shift },
  { header: "Status", render: (s) => <Chip size="small" color={statusColor[s.status]} label={s.status} /> },
  {
    header: "Credential",
    minWidth: 190,
    render: (s) => (
      <>
        {s.credential}
        <Typography variant="caption" color="text.secondary" component="span" sx={{ display: "block" }}>
          Expires {s.credentialExpiry}
        </Typography>
      </>
    ),
  },
  {
    header: "Credential status",
    render: (s) => <Chip size="small" variant="outlined" color={credentialColor[s.credentialState]} label={s.credentialState} />,
  },
];

export const metadata = { title: "Staff" };

export default function StaffPage() {
  const onDuty = staff.filter((s) => s.status === "On Duty").length;
  const attention = staff.filter((s) => s.credentialState !== "Valid").length;

  return (
    <>
      <PageIntro>Staff roster, shifts and license or certification status.</PageIntro>
      <StatGrid
        items={[
          { label: "Total Staff", value: staff.length, caption: "Active employees", icon: <BadgeIcon />, color: "primary" },
          { label: "On Duty", value: onDuty, caption: "Currently working", icon: <WorkIcon />, color: "secondary" },
          { label: "Credentials Valid", value: staff.length - attention, caption: "Licenses in good standing", icon: <VerifiedIcon />, color: "primary" },
          { label: "Credential Attention", value: attention, caption: "Expiring soon or expired", icon: <EventBusyIcon />, color: "error" },
        ]}
      />
      <SectionCard title="Staff Directory" subtitle={`${staff.length} staff members`} disablePadding>
        <DataTable label="Staff" columns={columns} rows={staff} getKey={(s) => s.id} />
      </SectionCard>
    </>
  );
}
