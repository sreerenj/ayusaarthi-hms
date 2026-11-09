"use client";

import { useSyncExternalStore } from "react";
import Typography from "@mui/material/Typography";

const subscribe = () => () => {};

const formatToday = () =>
  new Date().toLocaleDateString("en-US", {
    weekday: "long",
    month: "long",
    day: "numeric",
    year: "numeric",
  });

// Rendered client-side only so the server output never depends on the current date.
export default function TodayLabel() {
  const today = useSyncExternalStore(subscribe, formatToday, () => "");

  return (
    <Typography variant="caption" color="text.secondary" component="p" sx={{ minHeight: "1.4em" }}>
      {today}
    </Typography>
  );
}
