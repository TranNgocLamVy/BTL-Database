"use client";
import FlexBox from "@/components/Box/FlexBox";
import { KhoaHoc } from "@/types";
import {
  DatePicker,
  Table,
  TableBody,
  TableCell,
  TableColumn,
  TableHeader,
  TableRow,
} from "@nextui-org/react";
import { useRouter } from "next/navigation";
import { useCallback } from "react";

interface Props {
  khoaHocList: KhoaHoc[];
  param: SearchParams;
}

export default function KhoaHocList({ khoaHocList, param }: Props) {
  const router = useRouter();

  const renderCell = useCallback((khoahoc: any, columnKey: ColumnKey) => {
    const cellValue = khoahoc[columnKey];

    switch (columnKey) {
      case "SiSo":
        return `${cellValue}/${khoahoc.GioiHanSiSo}`;
      case "TenCN":
        return `${khoahoc.TenCN} - ${khoahoc.DiaChi}`;
      case "NgayBatDau":
        return new Date(cellValue).toLocaleDateString();
      case "NgayKetThuc":
        return new Date(cellValue).toLocaleDateString();
      default:
        return cellValue;
    }
  }, []);

  const onChange = (value: string) => {
    router.push(
      `khoaHoc/?type=${value}&field=${param.field}&value=${param.value}`
    );
  };

  return (
    <FlexBox className="flex-col gap-4 w-full p-4 bg-neutral-100 shadow-md rounded-md">
      <FlexBox className="w-full">
        <DatePicker
          onChange={(value) => {
            const date = `${value.year}-${value.month}-${value.day}`;
            router.push(`khoahoc/?value=${date}`);
          }}
          radius="sm"
          className="w-60"
          label="Chọn ngày"
        />
      </FlexBox>
      <Table
        color="primary"
        removeWrapper
        aria-label="Example table with dynamic content">
        <TableHeader columns={columns}>
          {(column) => (
            <TableColumn align={column.align} key={column.key}>
              {column.label}
            </TableColumn>
          )}
        </TableHeader>
        <TableBody
          emptyContent={
            "Không có khóa học có thể đăng kí trong thời gian hiện tại"
          }
          items={khoaHocList}>
          {(khoaHoc) => (
            <TableRow
              className="cursor-pointer hover:bg-neutral-200"
              key={khoaHoc.MaLH}>
              {(columnKey) => (
                <TableCell>
                  {renderCell(khoaHoc, columnKey as ColumnKey)}
                </TableCell>
              )}
            </TableRow>
          )}
        </TableBody>
      </Table>
    </FlexBox>
  );
}

type ColumnKey =
  | "MaLH"
  | "TenKhoaHoc"
  | "SiSo"
  | "GioiHanSiSo"
  | "NgayBatDau"
  | "NgayKetThuc"
  | "TenCN"
  | "DiaChi"
  | "BaoLoi";

type Column = {
  key: ColumnKey;
  label: string;
  align: "start" | "center" | "end";
};

const columns: Column[] = [
  { key: "MaLH", label: "Mã lớp học", align: "start" },
  { key: "TenKhoaHoc", label: "Tên khóa học", align: "center" },
  { key: "SiSo", label: "Sĩ số", align: "center" },
  { key: "TenCN", label: "Chi nhánh", align: "center" },
  { key: "NgayBatDau", label: "Ngày bắt đầu", align: "center" },
  { key: "NgayKetThuc", label: "Ngày kết thúc", align: "center" },
];
