"use client";
import FlexBox from "@/components/Box/FlexBox";
import { H1 } from "@/components/Heading";
import { taoNhanVien } from "@/libs/serverAction";
import { ChiNhanh, NVTYPE, NVType, TaoNhanVien } from "@/types";
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
import { useRouter } from "next/navigation";
import { Fragment, useState } from "react";
import { toast } from "sonner";

interface Props {
  chiNhanhList: ChiNhanh[];
}

export default function AddNhanVienModal({ chiNhanhList }: Props) {
  const { isOpen, onOpenChange } = useDisclosure();

  const router = useRouter();
  const [taoNhanVienForm, setTaoNhanVienForm] = useState<TaoNhanVien>({
    Ten: "",
    GioiTinh: true,
    Email: "",
    SDT: "",
    NamSinh: new Date().getFullYear(),
    MaCN: 0,
    QuanLy: 0,
    DiaChi: "",
    TrangThai: "Đang làm việc",
    NVType: NVTYPE.NhanVien,
    KinhNghiem: 0,
    TrinhDo: "",
  });

  const onChangeForm = (change: Partial<TaoNhanVien>) => {
    setTaoNhanVienForm({ ...taoNhanVienForm, ...change });
  };

  const onSubmit = async () => {
    if (
      taoNhanVienForm.Ten == "" ||
      taoNhanVienForm.Email == "" ||
      taoNhanVienForm.SDT == "" ||
      taoNhanVienForm.DiaChi == "" ||
      taoNhanVienForm.MaCN == 0 ||
      (taoNhanVienForm.NVType as string) == "" ||
      isNaN(taoNhanVienForm.NamSinh)
    ) {
      toast.error("Vui lòng điền đầy đủ thông tin");
      return;
    }

    const res = await taoNhanVien(taoNhanVienForm);
    if (res.success) {
      toast.success(res.message);
      onOpenChange();
      router.refresh();
    } else {
      toast.error(res.message);
    }
  };

  const onReset = () => {
    setTaoNhanVienForm({
      Ten: "",
      GioiTinh: true,
      Email: "",
      SDT: "",
      NamSinh: new Date().getFullYear(),
      MaCN: 0,
      QuanLy: 0,
      DiaChi: "",
      TrangThai: "Đang làm việd",
      NVType: NVTYPE.NhanVien,
      KinhNghiem: 0,
      TrinhDo: "",
    });
  };

  return (
    <Fragment>
      <Button onClick={onOpenChange} radius="sm" color="primary">
        Thêm nhân viên
      </Button>
      <Modal
        disableAnimation
        size="2xl"
        radius="sm"
        placement="center"
        isOpen={isOpen}
        onOpenChange={onOpenChange}>
        <ModalContent>
          <ModalHeader className="flex flex-col gap-1 text-2xl">
            <H1>Thêm nhân viên mới</H1>
          </ModalHeader>
          <ModalBody className="flex flex-col gap-4">
            <FlexBox className="gap-4">
              <Input
                value={taoNhanVienForm.Ten}
                onChange={(e) => onChangeForm({ Ten: e.target.value })}
                type="text"
                radius="sm"
                size="sm"
                id="ten"
                label="Họ và tên"
              />
              <Input
                value={taoNhanVienForm.Email}
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
                value={taoNhanVienForm.SDT}
                onChange={(e) => onChangeForm({ SDT: e.target.value })}
                type="text"
                radius="sm"
                size="sm"
                id="sdt"
                label="Số điện thoại"
              />
              <Input
                value={taoNhanVienForm.DiaChi}
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
                value={taoNhanVienForm.GioiTinh ? "nam" : "nu"}
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
                label="Loại nhân viên"
                radius="sm"
                size="sm"
                defaultSelectedKeys={["NhanVien"]}
                disableAnimation
                value={taoNhanVienForm.NVType}
                onChange={(e) => {
                  onChangeForm({
                    NVType: e.target.value as NVType,
                  });
                }}>
                <SelectItem key={NVTYPE.NhanVien} value={NVTYPE.NhanVien}>
                  Nhân viên
                </SelectItem>
                <SelectItem key={NVTYPE.GiangVien} value={NVTYPE.GiangVien}>
                  Giảng viên
                </SelectItem>
                <SelectItem key={NVTYPE.TroGiang} value={NVTYPE.TroGiang}>
                  Trợ giảng
                </SelectItem>
                <SelectItem key={NVTYPE.GiamSatVien} value={NVTYPE.GiamSatVien}>
                  Giám sát viên
                </SelectItem>
              </Select>
            </FlexBox>
            {(taoNhanVienForm.NVType === NVTYPE.GiangVien ||
              taoNhanVienForm.NVType === NVTYPE.TroGiang) && (
              <FlexBox className="gap-4">
                <Input
                  value={taoNhanVienForm.KinhNghiem.toString()}
                  onChange={(e) => {
                    if (e.target.value === "") {
                      onChangeForm({ KinhNghiem: 0 });
                      return;
                    }
                    if (isNaN(parseInt(e.target.value))) {
                      return;
                    }
                    onChangeForm({ KinhNghiem: parseInt(e.target.value) });
                  }}
                  type="text"
                  radius="sm"
                  size="sm"
                  id="kinh nghiem"
                  label="Kinh nghiem"
                />
                <Input
                  value={taoNhanVienForm.TrinhDo}
                  onChange={(e) => onChangeForm({ TrinhDo: e.target.value })}
                  type="text"
                  radius="sm"
                  size="sm"
                  id="trinh do"
                  label="Trình độ"
                />
              </FlexBox>
            )}
          </ModalBody>
          <ModalFooter>
            <FlexBox className="gap-4 w-full justify-between">
              <Button radius="sm" onClick={onReset} color="default">
                Xóa
              </Button>
              <Button radius="sm" onClick={onSubmit} color="primary">
                Thêm
              </Button>
            </FlexBox>
          </ModalFooter>
        </ModalContent>
      </Modal>
    </Fragment>
  );
}
