import { config, NhanVien } from "@/types";

let sql = require("mssql");

export async function countNhanVienWithParams(params: SearchParams) {
  let NVQuery = `
    SELECT COUNT(*) as count
    FROM NhanVien
  `;

  if (params.type && params.type !== "NhanVien") {
    NVQuery += `
    INNER JOIN ${params.type}
    ON NhanVien.MaNV = ${params.type}.MaNV
    `;
  }

  if (params.field && params.value) {
    NVQuery += `
    WHERE ${params.field} LIKE '%${params.value}%'
    `;
  }

  try {
    const pool = await sql.connect(config);
    const data = await pool.request().query(NVQuery);
    return data.recordset[0].count;
  } catch (error) {
    console.log(error);
    return 0;
  }
}

export async function fetchChiNhanh() {
  const CNQuery = `
  SELECT *
  FROM ChiNhanh
  `;
  try {
    const pool = await sql.connect(config);
    const data = await pool.request().query(CNQuery);
    return data.recordset;
  } catch (error) {
    console.log(error);
    return [];
  }
}

export async function fetchNhanVien(params: SearchParams) {
  let NVQuery = `
    SELECT NhanVien.*
    FROM NhanVien
  `;

  if (params.type && params.type !== "NhanVien") {
    NVQuery += `
    INNER JOIN ${params.type}
    ON NhanVien.MaNV = ${params.type}.MaNV
    `;
  }

  if (params.field && params.value) {
    NVQuery += `
    WHERE ${params.field} LIKE '%${params.value}%'
    `;
  }

  if (params.page) {
    NVQuery += `
    ORDER BY NhanVien.MaNV
    OFFSET ${(params.page - 1) * 10} ROWS
    FETCH NEXT 10 ROWS ONLY
    `;
  }

  try {
    const pool = await sql.connect(config);
    const data = await pool.request().query(NVQuery);
    return data.recordset as NhanVien[];
  } catch (error) {
    console.log(error);
    return [];
  }
}

export async function fetchKhoaHoc(date: string) {
  const KHQuery = `
  SELECT * FROM dbo.GetUnfullClass('${date}');
  `;
  try {
    const pool = await sql.connect(config);
    const data = await pool.request().query(KHQuery);
    console.log(data.recordset);
    return data.recordset;
  } catch (error) {
    console.log(error);
    return [];
  }
}
