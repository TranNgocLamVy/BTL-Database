GO
CREATE OR ALTER PROCEDURE TinhKhoiLuongCongViec
    @MaNV INT  -- Tham số đầu vào là Mã Nhân Viên
AS
BEGIN
    -- Khai báo biến để lưu tổng khối lượng công việc
    DECLARE @KhoiLuongBuoiHoc INT;
    DECLARE @KhoiLuongLopHoc INT;

    -- Tính số lần xuất hiện của MaNV trong bảng BuoiHoc
    SELECT @KhoiLuongBuoiHoc = COUNT(*)
    FROM BuoiHoc
    WHERE MaGiangVien = @MaNV OR MaTroGiang = @MaNV;

    -- Tính số lần xuất hiện của MaNV trong bảng LopHoc
    SELECT @KhoiLuongLopHoc = COUNT(*)
    FROM LopHoc
    WHERE MaNV = @MaNV;

    -- Tính tổng khối lượng công việc
    DECLARE @TongKhoiLuong INT;
    SET @TongKhoiLuong = (@KhoiLuongBuoiHoc * 3) + (@KhoiLuongLopHoc * 30 * 3);

    -- Trả về khối lượng công việc
    SELECT @TongKhoiLuong AS KhoiLuongCongViec;
END;
GO

GO
CREATE OR ALTER PROCEDURE ThongKeDoanhSoGiaoTrinhVaKhoaHoc @MaKH INT
AS
BEGIN
    -- Truy vấn tổng số bán và tổng tiền gốc của giáo trình thuộc phiếu đăng ký
    SELECT 
		mgt.MaGT,
        gt.Ten AS TenGiaoTrinh,
		SUM(mgt.SoLuongMua) AS TongSoLuongBan,
        SUM(mgt.SoLuongMua * gt.Gia) AS TongTienGoc
    FROM MuaGT mgt
    INNER JOIN GiaoTrinh gt ON mgt.MaGT = gt.MaGT
    GROUP BY mgt.MaGT, gt.Ten
    HAVING SUM(mgt.SoLuongMua) > 0
    ORDER BY gt.Ten;
	

    -- Truy vấn các thông tin liên quan tổng hóa đơn của phiếu đăng ký 
    SELECT 
        pdk.MaDK,
		pdk.HocPhi,
        ISNULL(mgt.TongGia, ISNULL(SUM(mgt.SoLuongMua * gt.Gia), 0)) AS TongGiaMuaGT,
        CASE 
            WHEN u.PhanTramGiam IS NOT NULL THEN (ISNULL(mgt.TongGia, ISNULL(SUM(mgt.SoLuongMua * gt.Gia), 0)) + pdk.HocPhi) * u.PhanTramGiam / 100
            WHEN u.GiamTien IS NOT NULL THEN u.GiamTien
            ELSE 0
        END AS MucGiam,
        ISNULL(mgt.TongGia, ISNULL(SUM(mgt.SoLuongMua * gt.Gia), 0)) + pdk.HocPhi - 
        CASE 
            WHEN u.PhanTramGiam IS NOT NULL THEN (ISNULL(mgt.TongGia, ISNULL(SUM(mgt.SoLuongMua * gt.Gia), 0)) + pdk.HocPhi) * u.PhanTramGiam / 100
            WHEN u.GiamTien IS NOT NULL THEN u.GiamTien
            ELSE 0
        END AS TongHoaDon
    FROM PhieuDangKy pdk
    LEFT JOIN MuaGT mgt ON pdk.MaDK = mgt.MaDK
    LEFT JOIN GiaoTrinh gt ON mgt.MaGT = gt.MaGT
    LEFT JOIN UuDai u ON pdk.MaUuDai = u.MaUuDai
	INNER JOIN LopHoc l ON l.MaLH = pdk.MaLH
	INNER JOIN KhoaHoc k ON k.MaKhoaHoc = l.MaKhoaHoc
	WHERE k.MaKhoaHoc = @MaKH
    GROUP BY pdk.MaDK, pdk.HocPhi, u.PhanTramGiam, u.GiamTien, mgt.TongGia
	ORDER BY pdk.MaDK;
END;
GO