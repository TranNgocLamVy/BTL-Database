"use client";
import FlexBox from "@/components/Box/FlexBox";
import { xoaNhanVien } from "@/libs/serverAction";
import { ChiNhanh, NhanVien } from "@/types";
import {
  Button,
  Dropdown,
  DropdownItem,
  DropdownMenu,
  DropdownTrigger,
  Select,
  SelectItem,
  Table,
  TableBody,
  TableCell,
  TableColumn,
  TableHeader,
  TableRow,
  useDisclosure,
  User,
} from "@nextui-org/react";
import { DotsThreeVertical } from "@phosphor-icons/react";
import { useRouter } from "next/navigation";
import { useCallback, useState } from "react";
import { toast } from "sonner";
import NhanVienModal from "./NhanVIenModal";

interface Props {
  nhanVienList: NhanVien[];
  chiNhanhList: ChiNhanh[];
  param: SearchParams;
}

export default function NhanVienList({
  nhanVienList,
  chiNhanhList,
  param,
}: Props) {
  const router = useRouter();

  const [currentUser, setCurrentUser] = useState<NhanVien | null>(null);
  const [modalType, setModalType] = useState<"view" | "edit">("view");
  const { isOpen, onOpenChange } = useDisclosure();

  const renderCell = useCallback((staff: NhanVien, columnKey: ColumnKey) => {
    const cellValue = staff[columnKey as keyof NhanVien];

    switch (columnKey) {
      case "Ten":
        return (
          <User
            avatarProps={{ radius: "full", src: "/user.svg" }}
            description={staff.Email}
            name={cellValue}>
            {staff.Email}
          </User>
        );
      case "MaCN":
        const chiNhanh = chiNhanhList.find((cn) => cn.MaCN === cellValue);
        return `${chiNhanh?.TenCN} - ${chiNhanh?.DiaChi}`;
      case "GioiTinh":
        return cellValue ? "Nam" : "Nữ";
      case "Action":
        return (
          <div className="relative flex justify-end items-center gap-2">
            <Dropdown className="bg-background border-1 border-default-200">
              <DropdownTrigger>
                <Button isIconOnly radius="full" size="sm" variant="light">
                  <DotsThreeVertical size={20} />
                </Button>
              </DropdownTrigger>
              <DropdownMenu
                onAction={async (key) => {
                  if (key === "view") {
                    setModalType("view");
                    setCurrentUser(staff);
                    onOpenChange();
                  } else if (key === "edit") {
                    setModalType("edit");
                    setCurrentUser(staff);
                    onOpenChange();
                  } else if (key === "delete") {
                    const res = await xoaNhanVien(staff.MaNV);
                    if (res.success) {
                      router.refresh();
                      toast.success(res.message);
                    } else {
                      toast.error(res.message);
                    }
                  }
                }}>
                <DropdownItem key="view">Xem thông tin</DropdownItem>
                <DropdownItem key="edit">Chỉnh sửa thông tin</DropdownItem>
                <DropdownItem
                  color="danger"
                  key="delete"
                  className="text-danger-500">
                  Xóa nhân viên
                </DropdownItem>
              </DropdownMenu>
            </Dropdown>
          </div>
        );
      default:
        return cellValue;
    }
  }, []);

  const onChange = (value: string) => {
    router.push(
      `nhanvien/?type=${value}&field=${param.field}&value=${param.value}`
    );
  };

  return (
    <FlexBox className="flex-col gap-4 w-full p-4 bg-neutral-100 shadow-md rounded-md">
      <NhanVienModal
        chiNhanhList={chiNhanhList}
        currentNhanVien={currentUser}
        modalType={modalType}
        isOpen={isOpen}
        onOpenChange={onOpenChange}
      />
      <FlexBox className="w-full">
        <Select
          onChange={(e) => onChange(e.target.value)}
          placeholder="Loại nhân viên"
          radius="sm"
          variant="bordered"
          defaultSelectedKeys={[param.type]}
          className="w-48 bg-white rounded-md">
          <SelectItem key="NhanVien" value="NhanVien">
            Nhân viên
          </SelectItem>
          <SelectItem key="GiangVien" value="GiangVien">
            Giảng viên
          </SelectItem>
          <SelectItem key="TroGiang" value="TroGiang">
            Trợ giảng
          </SelectItem>
          <SelectItem key="GiamSatVien" value="GiamSatVien">
            Giám sát viên
          </SelectItem>
        </Select>
      </FlexBox>
      <Table
        color="primary"
        removeWrapper
        aria-label="Example table with dynamic content">
        <TableHeader columns={columns}>
          {(column) => (
            <TableColumn
              align={column.align}
              key={column.key}
              width={column.width as any}>
              {column.label}
            </TableColumn>
          )}
        </TableHeader>
        <TableBody
          emptyContent={"Không có người dùng nào."}
          items={nhanVienList}>
          {(staff) => (
            <TableRow
              onClick={() => {
                setCurrentUser(staff);
              }}
              className="cursor-pointer hover:bg-neutral-200"
              key={staff.MaNV}>
              {(columnKey) => (
                <TableCell>
                  {renderCell(staff, columnKey as ColumnKey)}
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
  | "MaNV"
  | "Ten"
  | "GioiTinh"
  | "Email"
  | "SDT"
  | "NamSinh"
  | "MaCN"
  | "TrangThai"
  | "Action";

type Column = {
  key: ColumnKey;
  label: string;
  align: "start" | "center" | "end";
  width: string;
};

const columns: Column[] = [
  { key: "Ten", label: "Tên", align: "start", width: "20%" },
  { key: "MaNV", label: "Mã nhân viên", align: "center", width: "5%" },
  { key: "MaCN", label: "Chi nhánh", align: "center", width: "20%" },
  { key: "SDT", label: "Số điện thoại", align: "center", width: "15%" },
  { key: "GioiTinh", label: "Giới tính", align: "center", width: "10%" },
  { key: "NamSinh", label: "Năm sinh", align: "center", width: "15%" },
  { key: "TrangThai", label: "Trạng thái", align: "center", width: "10%" },
  { key: "Action", label: "", align: "center", width: "5%" },
];
