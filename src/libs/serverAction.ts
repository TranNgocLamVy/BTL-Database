"use server";

import { config, SuaNhanVien, TaoNhanVien } from "@/types";

const sql = require("mssql");

export const test = async () => {
  const testQuery = `
  SELECT * FROM dbo.GetUnfullClass('2024-01-31');
  `;

  try {
    const pool = await sql.connect(config);
    const data = await pool.request().query(testQuery);
    return data.recordset;
  } catch (error) {
    console.log(error);
    return null;
  }
};

export async function taoNhanVien(payload: TaoNhanVien) {
  const query = `
  EXEC dbo.ThemNhanVien @Ten = N'${payload.Ten}', @GioiTinh = ${
    payload.GioiTinh ? 1 : 0
  }, @Email = N'${payload.Email}', @SDT = '${payload.SDT}', @NamSinh = ${
    payload.NamSinh
  }, @MaCN = ${payload.MaCN}, @QuanLy = ${payload.QuanLy}, @DiaChi = N'${
    payload.DiaChi
  }', @TrangThai = N'${payload.TrangThai}', @VaiTro = N'${
    payload.NVType
  }', @KinhNghiem = ${payload.KinhNghiem}, @TrinhDo = N'${payload.TrinhDo}'
  `;

  try {
    const pool = await sql.connect(config);
    const res = await pool.request().query(query);
    const data = res.recordset[0];
    return {
      success: data.MaNhanVien != null,
      message: data.ThongBao,
    };
  } catch (error) {
    console.log(error);
    return {
      success: false,
      message: "Thêm nhân viên thất bại",
    };
  }
}

export async function suaNhanVien(payload: SuaNhanVien) {
  const suaNhanVienQuery = `
  EXEC dbo.CapNhatNhanVien @MaNV = ${payload.MaNV}, @Ten = N'${
    payload.Ten
  }', @GioiTinh = ${payload.GioiTinh ? 1 : 0}, @Email = N'${
    payload.Email
  }', @SDT = '${payload.SDT}', @NamSinh = ${payload.NamSinh}, @MaCN = ${
    payload.MaCN
  }, @DiaChi = N'${payload.DiaChi}', @TrangThai = N'${payload.TrangThai}'`;

  console.log(suaNhanVienQuery);

  try {
    const pool = await sql.connect(config);
    const res = await pool.request().query(suaNhanVienQuery);
    const data = res.recordset[0];
    return {
      success: data.MaNhanVien != null,
      message: data.ThongBao,
    };
  } catch (error) {
    console.log(error);
    return {
      success: false,
      message: "Sửa nhân viên thất bại",
    };
  }
}

export async function xoaNhanVien(MaNV: number) {
  const xoaNhanVienQuery = `
  EXEC dbo.XoaNhanVien @MaNV = ${MaNV}
  `;

  try {
    const pool = await sql.connect(config);
    const res = await pool.request().query(xoaNhanVienQuery);
    const data = res.recordset[0];
    return {
      success: data.MaNhanVien != null,
      message: data.ThongBao,
    };
  } catch (error) {
    console.log(error);
    return {
      success: false,
      message: "Xóa nhân viên thất bại",
    };
  }
}

export async function layThoiLuongGiangDay(MaNV: number) {
  const query = `
  SELECT dbo.LayThoiLuongGiangDay(${MaNV}) as ThoiLuongGiangDay
  `;

  try {
    const pool = await sql.connect(config);
    const res = await pool.request().query(query);
    return res.recordset[0].ThoiLuongGiangDay;
  } catch (error) {
    console.log(error);
    return null;
  }
}
