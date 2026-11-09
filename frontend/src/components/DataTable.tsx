import Table from "@mui/material/Table";
import TableBody from "@mui/material/TableBody";
import TableCell from "@mui/material/TableCell";
import TableContainer from "@mui/material/TableContainer";
import TableHead from "@mui/material/TableHead";
import TableRow from "@mui/material/TableRow";

export interface Column<T> {
  header: string;
  render: (row: T) => React.ReactNode;
  align?: "left" | "right" | "center";
  minWidth?: number;
}

interface DataTableProps<T> {
  label: string;
  columns: Column<T>[];
  rows: T[];
  getKey: (row: T) => string | number;
}

export default function DataTable<T>({ label, columns, rows, getKey }: DataTableProps<T>) {
  return (
    <TableContainer>
      <Table size="small" aria-label={label}>
        <TableHead>
          <TableRow>
            {columns.map((col) => (
              <TableCell key={col.header} align={col.align} sx={{ minWidth: col.minWidth }}>
                {col.header}
              </TableCell>
            ))}
          </TableRow>
        </TableHead>
        <TableBody>
          {rows.map((row) => (
            <TableRow key={getKey(row)} hover>
              {columns.map((col) => (
                <TableCell key={col.header} align={col.align}>
                  {col.render(row)}
                </TableCell>
              ))}
            </TableRow>
          ))}
        </TableBody>
      </Table>
    </TableContainer>
  );
}
