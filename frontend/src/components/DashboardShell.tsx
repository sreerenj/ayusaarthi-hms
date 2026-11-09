"use client";

import { useState } from "react";
import Link from "next/link";
import Image from "next/image";
import { usePathname } from "next/navigation";
import AppBar from "@mui/material/AppBar";
import Avatar from "@mui/material/Avatar";
import Badge from "@mui/material/Badge";
import Box from "@mui/material/Box";
import Divider from "@mui/material/Divider";
import Drawer from "@mui/material/Drawer";
import IconButton from "@mui/material/IconButton";
import List from "@mui/material/List";
import ListItemButton from "@mui/material/ListItemButton";
import ListItemIcon from "@mui/material/ListItemIcon";
import ListItemText from "@mui/material/ListItemText";
import Toolbar from "@mui/material/Toolbar";
import Typography from "@mui/material/Typography";
import MenuIcon from "@mui/icons-material/Menu";
import NotificationsNoneIcon from "@mui/icons-material/NotificationsNone";
import DashboardIcon from "@mui/icons-material/SpaceDashboardOutlined";
import PeopleIcon from "@mui/icons-material/PeopleAltOutlined";
import AssignmentIcon from "@mui/icons-material/AssignmentOutlined";
import MedicationIcon from "@mui/icons-material/MedicationOutlined";
import ReportIcon from "@mui/icons-material/ReportGmailerrorredOutlined";
import ReceiptIcon from "@mui/icons-material/ReceiptLongOutlined";
import BadgeIcon from "@mui/icons-material/BadgeOutlined";
import AssessmentIcon from "@mui/icons-material/AssessmentOutlined";
import TodayLabel from "@/components/TodayLabel";

const DRAWER_WIDTH = 248;

const navItems = [
  { label: "Dashboard", href: "/dashboard", icon: <DashboardIcon /> },
  { label: "Residents", href: "/residents", icon: <PeopleIcon /> },
  { label: "Care Plans", href: "/careplans", icon: <AssignmentIcon /> },
  { label: "Medications", href: "/medications", icon: <MedicationIcon /> },
  { label: "Incidents", href: "/incidents", icon: <ReportIcon /> },
  { label: "Billing", href: "/billing", icon: <ReceiptIcon /> },
  { label: "Staff", href: "/staff", icon: <BadgeIcon /> },
  { label: "Reports", href: "/reports", icon: <AssessmentIcon /> },
];

function NavDrawerContent({
  facilityName,
  pathname,
  onNavigate,
}: {
  facilityName: string;
  pathname: string;
  onNavigate: () => void;
}) {
  return (
    <>
      <Box sx={{ bgcolor: "#09253d", px: 2, pt: 2, pb: 1.5 }}>
        <Image
          src="/logo.png"
          alt="AyuSaarthi nursing home management application"
          width={780}
          height={246}
          priority
          style={{ width: "100%", height: "auto" }}
        />
        <Typography
          variant="caption"
          sx={{ display: "block", mt: 0.5, color: "rgba(255,255,255,0.7)", textAlign: "center" }}
        >
          {facilityName}
        </Typography>
      </Box>
      <Divider />
      <List sx={{ px: 1.5, py: 2 }}>
        {navItems.map((item) => (
          <ListItemButton
            key={item.label}
            component={Link}
            href={item.href}
            selected={pathname.startsWith(item.href)}
            onClick={onNavigate}
            sx={{ borderRadius: 2, mb: 0.5 }}
          >
            <ListItemIcon sx={{ minWidth: 40 }}>{item.icon}</ListItemIcon>
            <ListItemText primary={item.label} />
          </ListItemButton>
        ))}
      </List>
    </>
  );
}

export default function DashboardShell({
  facilityName,
  children,
}: {
  facilityName: string;
  children: React.ReactNode;
}) {
  const [mobileOpen, setMobileOpen] = useState(false);
  const pathname = usePathname();
  const title = navItems.find((item) => pathname.startsWith(item.href))?.label ?? "AyuSaarthi";

  return (
    <Box sx={{ display: "flex", minHeight: "100vh" }}>
      <AppBar
        position="fixed"
        color="inherit"
        elevation={0}
        sx={{
          ml: { md: `${DRAWER_WIDTH}px` },
          width: { md: `calc(100% - ${DRAWER_WIDTH}px)` },
          borderBottom: 1,
          borderColor: "divider",
        }}
      >
        <Toolbar>
          <IconButton
            edge="start"
            aria-label="Open navigation"
            onClick={() => setMobileOpen(true)}
            sx={{ mr: 1, display: { md: "none" } }}
          >
            <MenuIcon />
          </IconButton>
          <Box sx={{ flexGrow: 1 }}>
            <Typography variant="h6" component="h1" sx={{ lineHeight: 1.2 }}>
              {title}
            </Typography>
            <TodayLabel />
          </Box>
          <IconButton aria-label="Notifications" sx={{ mr: 1 }}>
            <Badge color="error" variant="dot">
              <NotificationsNoneIcon />
            </Badge>
          </IconButton>
          <Avatar sx={{ bgcolor: "secondary.main", width: 36, height: 36, fontSize: 14 }}>NA</Avatar>
        </Toolbar>
      </AppBar>

      <Box component="nav" sx={{ width: { md: DRAWER_WIDTH }, flexShrink: { md: 0 } }}>
        <Drawer
          variant="temporary"
          open={mobileOpen}
          onClose={() => setMobileOpen(false)}
          ModalProps={{ keepMounted: true }}
          sx={{
            display: { xs: "block", md: "none" },
            "& .MuiDrawer-paper": { width: DRAWER_WIDTH },
          }}
        >
          <NavDrawerContent facilityName={facilityName} pathname={pathname} onNavigate={() => setMobileOpen(false)} />
        </Drawer>
        <Drawer
          variant="permanent"
          open
          sx={{
            display: { xs: "none", md: "block" },
            "& .MuiDrawer-paper": { width: DRAWER_WIDTH, borderRight: 1, borderColor: "divider" },
          }}
        >
          <NavDrawerContent facilityName={facilityName} pathname={pathname} onNavigate={() => setMobileOpen(false)} />
        </Drawer>
      </Box>

      <Box component="main" sx={{ flexGrow: 1, minWidth: 0, p: { xs: 2, md: 3 }, bgcolor: "background.default" }}>
        <Toolbar />
        {children}
      </Box>
    </Box>
  );
}
