import Chip from "@mui/material/Chip";
import AccountBalanceIcon from "@mui/icons-material/AccountBalanceWalletOutlined";
import GppBadIcon from "@mui/icons-material/GppBadOutlined";
import PaymentsIcon from "@mui/icons-material/PaymentsOutlined";
import SendIcon from "@mui/icons-material/SendOutlined";
import DataTable, { type Column } from "@/components/DataTable";
import PageIntro from "@/components/PageIntro";
import SectionCard from "@/components/SectionCard";
import StatGrid from "@/components/StatGrid";
import type { ChipColor } from "@/lib/status";
import { claims, type Claim, type ClaimStatus } from "@/data/billing";

const currency = new Intl.NumberFormat("en-US", { style: "currency", currency: "USD", maximumFractionDigits: 0 });

const statusColor: Record<ClaimStatus, ChipColor> = {
  Draft: "default",
  Submitted: "info",
  Paid: "success",
  "Partially Paid": "warning",
  Denied: "error",
};

const columns: Column<Claim>[] = [
  { header: "Claim #", render: (c) => c.claimNumber },
  { header: "Resident", minWidth: 160, render: (c) => c.residentName },
  { header: "Payer", minWidth: 170, render: (c) => c.payer },
  { header: "Service period", minWidth: 180, render: (c) => c.servicePeriod },
  { header: "Amount", align: "right", render: (c) => currency.format(c.amount) },
  { header: "Days outstanding", align: "right", render: (c) => c.daysOutstanding },
  { header: "Status", render: (c) => <Chip size="small" color={statusColor[c.status]} label={c.status} /> },
];

export const metadata = { title: "Billing" };

export default function BillingPage() {
  const sum = (predicate: (c: Claim) => boolean) =>
    claims.filter(predicate).reduce((total, c) => total + c.amount, 0);

  const outstanding = sum((c) => c.status === "Submitted" || c.status === "Partially Paid" || c.status === "Denied");
  const denied = claims.filter((c) => c.status === "Denied");

  return (
    <>
      <PageIntro>Claims, payer status and accounts receivable for resident billing.</PageIntro>
      <StatGrid
        items={[
          { label: "Outstanding A/R", value: currency.format(outstanding), caption: "Submitted, partial and denied claims", icon: <AccountBalanceIcon />, color: "primary" },
          { label: "Collected", value: currency.format(sum((c) => c.status === "Paid")), caption: "Paid claims", icon: <PaymentsIcon />, color: "secondary" },
          { label: "Awaiting Submission", value: claims.filter((c) => c.status === "Draft").length, caption: "Draft claims", icon: <SendIcon />, color: "warning" },
          { label: "Denied Claims", value: denied.length, caption: `${currency.format(sum((c) => c.status === "Denied"))} at risk`, icon: <GppBadIcon />, color: "error" },
        ]}
      />
      <SectionCard title="Claims" subtitle={`${claims.length} claims`} disablePadding>
        <DataTable label="Claims" columns={columns} rows={claims} getKey={(c) => c.id} />
      </SectionCard>
    </>
  );
}
