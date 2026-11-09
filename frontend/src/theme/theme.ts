"use client";

import { createTheme, responsiveFontSizes } from "@mui/material/styles";

export const theme = responsiveFontSizes(
  createTheme({
    palette: {
      primary: { main: "#0f766e" },
      secondary: { main: "#3949ab" },
      error: { main: "#c62828" },
      warning: { main: "#ed8b00" },
      success: { main: "#2e7d32" },
      background: { default: "#f4f7f9", paper: "#ffffff" },
      text: { primary: "#1f2933", secondary: "#52606d" },
    },
    shape: { borderRadius: 10 },
    typography: {
      fontFamily: 'var(--font-geist-sans), "Helvetica Neue", Arial, sans-serif',
      h5: { fontWeight: 700 },
      h6: { fontWeight: 600 },
      subtitle2: { fontWeight: 600 },
    },
    components: {
      MuiCard: {
        defaultProps: { variant: "outlined" },
        styleOverrides: { root: { borderColor: "#e4e9ee" } },
      },
      MuiChip: { styleOverrides: { root: { fontWeight: 600 } } },
      MuiTableCell: {
        styleOverrides: {
          head: { fontWeight: 600, color: "#52606d", whiteSpace: "nowrap" },
        },
      },
    },
  }),
);
