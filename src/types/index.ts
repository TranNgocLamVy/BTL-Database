export const config = {
  user: "sa",
  password: "1234",
  server: "LAPTOP-TQUILUMP",
  databse: "Test all",
  options: {
    trustServerCertificate: true,
    trustedConnection: true,
  },
  port: 1433,
};

type ObjectValue<T> = T[keyof T];

export type ChiNhanh = {
  MaCN: number;
  TenCN: string;
  DiaChi: string;
};

export const NVTYPE = {
  NhanVien: "NhanVien",
  GiangVien: "GiangVien",
  TroGiang: "TroGiang",
  GiamSatVien: "GiamSatVien",
} as const;
export type NVType = ObjectValue<typeof NVTYPE>;

export type NhanVien = {
  MaNV: number;
  Ten: string;
  GioiTinh: boolean;
  Email: string;
  SDT: string;
  NamSinh: number;
  MaCN: number;
  QuanLy: number;
  DiaChi: string;
  TrangThai: string;
};

export type TaoNhanVien = {
  Ten: string;
  GioiTinh: boolean;
  Email: string;
  SDT: string;
  NamSinh: number;
  MaCN: number;
  QuanLy: number;
  DiaChi: string;
  TrangThai: string;
  NVType: NVType;
  KinhNghiem: number;
  TrinhDo: string;
};

export type SuaNhanVien = {
  MaNV: number;
  Ten: string;
  GioiTinh: boolean;
  Email: string;
  SDT: string;
  NamSinh: number;
  MaCN: number;
  QuanLy: number;
  DiaChi: string;
  TrangThai: string;
};

export type KhoaHoc = {
  MaLH: number;
  TenKhoaHoc: string;
  SiSo: number;
  GioiHanSiSo: number;
  NgayBatDau: string;
  NgayKetThuc: string;
  TenCN: string;
  DiaChi: string;
  BaoLoi: string | null;
};
