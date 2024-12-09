"use client";
import FlexBox from "@/components/Box/FlexBox";
import { H1, H2, H3 } from "@/components/Heading";
import { suaNhanVien } from "@/libs/serverAction";
import { ChiNhanh, NhanVien, SuaNhanVien } from "@/types";
import {
  Button,
  Input,
  Modal,
  ModalBody,
  ModalContent,
  ModalFooter,
  ModalHeader,
  Select,
  SelectItem,
  useDisclosure,
} from "@nextui-org/react";
import Image from "next/image";
import { useRouter } from "next/navigation";
import { Fragment, useState } from "react";
import { toast } from "sonner";

interface Props {
  chiNhanhList: ChiNhanh[];
  currentNhanVien: NhanVien | null;
  modalType: "view" | "edit";
  isOpen: boolean;
  onOpenChange: () => void;
}

export default function NhanVienModal({
  chiNhanhList,
  currentNhanVien,
  modalType,
  isOpen,
  onOpenChange,
}: Props) {
  if (!currentNhanVien) {
    return null;
  }

  return (
    <Fragment>
      <Modal
        disableAnimation
        size={modalType === "view" ? "xl" : "2xl"}
        radius="sm"
        placement="center"
        isOpen={isOpen}
        onOpenChange={onOpenChange}>
        <ModalContent>
          {modalType === "view" ? (
            <XemNhanVien
              currentNhanVien={currentNhanVien}
              chiNhanhList={chiNhanhList}
            />
          ) : (
            <SuaNhanVienForm
              currentNhanVien={currentNhanVien}
              chiNhanhList={chiNhanhList}
              onOpenChange={onOpenChange}
            />
          )}
        </ModalContent>
      </Modal>
    </Fragment>
  );
}

interface ModalProps {
  currentNhanVien: NhanVien;
  chiNhanhList: ChiNhanh[];
  onOpenChange?: () => void;
}

function XemNhanVien({ currentNhanVien }: ModalProps) {
  return (
    <Fragment>
      <ModalHeader>
        <H1 className="text-4xl">Thông tin nhân viên</H1>
      </ModalHeader>
      <ModalBody className="flex-col">
        <FlexBox className="gap-8 items-center">
          <Image
            src={"/user.svg"}
            alt="user"
            width={500}
            height={500}
            className="size-32 rounded-full"
          />
          <FlexBox className="flex-col gap-2">
            <FlexBox className="items-center gap-2">
              <H3 className="">Tên:</H3>
              <p>{currentNhanVien.Ten}</p>
            </FlexBox>
            <FlexBox className="items-center gap-2">
              <H3 className="">Mã nhân viên:</H3>
              <p>{currentNhanVien.MaNV}</p>
            </FlexBox>
            <FlexBox className="items-center gap-2">
              <H3 className="">Giới tính:</H3>
              <p>{currentNhanVien.GioiTinh ? "Nam" : "Nữ"}</p>
            </FlexBox>
          </FlexBox>
        </FlexBox>
        <FlexBox className="gap-20 px-4">
          <FlexBox className="flex-col gap-2">
            <FlexBox className="flex-col">
              <H3 className="">Email</H3>
              <p>{currentNhanVien.Email}</p>
            </FlexBox>
            <FlexBox className="flex-col">
              <H3 className="">Số điện thoại</H3>
              <p>{currentNhanVien.SDT}</p>
            </FlexBox>
            <FlexBox className="flex-col">
              <H3 className="">Năm sinh</H3>
              <p>{currentNhanVien.NamSinh}</p>
            </FlexBox>
          </FlexBox>

          <FlexBox className="flex-col gap-2">
            <FlexBox className="flex-col">
              <H3 className="">Mã CN</H3>
              <p>{currentNhanVien.MaCN}</p>
            </FlexBox>
            <FlexBox className="flex-col">
              <H3 className="">Địa chỉ</H3>
              <p>{currentNhanVien.DiaChi}</p>
            </FlexBox>
            <FlexBox className="flex-col">
              <H3 className="">Trạng thái</H3>
              <p>{currentNhanVien.TrangThai}</p>
            </FlexBox>
          </FlexBox>
        </FlexBox>
      </ModalBody>
      <ModalFooter></ModalFooter>
    </Fragment>
  );
}

function SuaNhanVienForm({
  currentNhanVien,
  chiNhanhList,
  onOpenChange,
}: ModalProps) {
  const router = useRouter();
  const [suaNhanVienForm, setSuaNhanVienForm] = useState<SuaNhanVien>({
    MaNV: currentNhanVien.MaNV,
    Ten: currentNhanVien.Ten,
    GioiTinh: currentNhanVien.GioiTinh,
    Email: currentNhanVien.Email,
    SDT: currentNhanVien.SDT,
    NamSinh: currentNhanVien.NamSinh,
    MaCN: currentNhanVien.MaCN,
    QuanLy: currentNhanVien.QuanLy,
    DiaChi: currentNhanVien.DiaChi,
    TrangThai: currentNhanVien.TrangThai,
  });

  const onChangeForm = (newForm: Partial<SuaNhanVien>) => {
    setSuaNhanVienForm({ ...suaNhanVienForm, ...newForm });
  };

  const onReset = () => {
    setSuaNhanVienForm({
      MaNV: currentNhanVien.MaNV,
      Ten: currentNhanVien.Ten,
      GioiTinh: currentNhanVien.GioiTinh,
      Email: currentNhanVien.Email,
      SDT: currentNhanVien.SDT,
      NamSinh: currentNhanVien.NamSinh,
      MaCN: currentNhanVien.MaCN,
      QuanLy: currentNhanVien.QuanLy,
      DiaChi: currentNhanVien.DiaChi,
      TrangThai: currentNhanVien.TrangThai,
    });
  };

  const onSubmit = async () => {
    if (
      suaNhanVienForm.Ten == "" ||
      suaNhanVienForm.Email == "" ||
      suaNhanVienForm.SDT == "" ||
      suaNhanVienForm.DiaChi == "" ||
      suaNhanVienForm.MaCN == 0 ||
      isNaN(suaNhanVienForm.NamSinh)
    ) {
      toast.error("Vui lòng điền đầy đủ thông tin");
      return;
    }

    const res = await suaNhanVien(suaNhanVienForm);

    if (res.success) {
      toast.success(res.message);
      if (onOpenChange) onOpenChange();
      router.refresh();
    } else {
      toast.error(res.message);
    }
  };

  return (
    <Fragment>
      <ModalHeader>
        <H1 className="text-4xl">Sửa thông tin nhân viên</H1>
      </ModalHeader>
      <ModalBody className="flex flex-col gap-4">
        <FlexBox className="gap-4">
          <Input
            value={suaNhanVienForm.Ten}
            onChange={(e) => onChangeForm({ Ten: e.target.value })}
            type="text"
            radius="sm"
            size="sm"
            id="ten"
            label="Họ và tên"
          />
          <Input
            value={suaNhanVienForm.Email}
            onChange={(e) => onChangeForm({ Email: e.target.value })}
            type="text"
            radius="sm"
            size="sm"
            id="email"
            label="Email"
          />
        </FlexBox>
        <FlexBox className="gap-4">
          <Input
            value={suaNhanVienForm.SDT}
            onChange={(e) => onChangeForm({ SDT: e.target.value })}
            type="text"
            radius="sm"
            size="sm"
            id="sdt"
            label="Số điện thoại"
          />
          <Input
            value={suaNhanVienForm.DiaChi}
            onChange={(e) => onChangeForm({ DiaChi: e.target.value })}
            type="text"
            radius="sm"
            size="sm"
            id="address"
            label="Địa chỉ"
          />
        </FlexBox>
        <FlexBox className="gap-4">
          <Select
            label="Giới tính"
            radius="sm"
            size="sm"
            defaultSelectedKeys={["nam"]}
            disableAnimation
            value={suaNhanVienForm.GioiTinh ? "nam" : "nu"}
            onChange={(e) => {
              onChangeForm({
                GioiTinh: e.target.value == "nam" ? true : false,
              });
            }}>
            <SelectItem key="nam" value="nam">
              Nam
            </SelectItem>
            <SelectItem key="nu" value="nu">
              Nữ
            </SelectItem>
          </Select>
          <Select
            label="Năm sinh"
            radius="sm"
            size="sm"
            defaultSelectedKeys={[new Date().getFullYear().toString()]}
            disableAnimation
            onChange={(e) => {
              onChangeForm({ NamSinh: parseInt(e.target.value) });
            }}>
            {Array.from({ length: 100 }, (_, i) => (
              <SelectItem
                key={(new Date().getFullYear() - i).toString()}
                value={(new Date().getFullYear() - i).toString()}>
                {(new Date().getFullYear() - i).toString()}
              </SelectItem>
            ))}
          </Select>
        </FlexBox>
        <FlexBox className="gap-4">
          <Select
            label="Chi nhánh"
            radius="sm"
            size="sm"
            disableAnimation
            defaultSelectedKeys={[suaNhanVienForm.MaCN.toString()]}
            onChange={(e) => {
              onChangeForm({ MaCN: parseInt(e.target.value) });
            }}>
            {chiNhanhList.map((cn) => (
              <SelectItem key={cn.MaCN} value={cn.MaCN.toString()}>
                {`${cn.TenCN} - ${cn.DiaChi}`}
              </SelectItem>
            ))}
          </Select>
          <Select
            label="Trạng thái"
            radius="sm"
            size="sm"
            disableAnimation
            defaultSelectedKeys={[suaNhanVienForm.TrangThai]}
            onChange={(e) => {
              onChangeForm({ TrangThai: e.target.value });
            }}>
            <SelectItem key="Đang làm việc" value="Đang làm việc">
              Đang làm việc
            </SelectItem>
            <SelectItem key="Nghỉ việc" value="Nghỉ việc">
              Nghỉ việc
            </SelectItem>
          </Select>
        </FlexBox>
      </ModalBody>
      <ModalFooter>
        <FlexBox className="gap-4 w-full justify-between">
          <Button radius="sm" onClick={onReset} color="default">
            Xóa
          </Button>
          <Button radius="sm" onClick={onSubmit} color="primary">
            Chỉnh sửa
          </Button>
        </FlexBox>
      </ModalFooter>
    </Fragment>
  );
}
