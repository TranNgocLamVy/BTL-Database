GO
CREATE OR ALTER PROCEDURE dbo.ThemNhanVien
    @Ten NVARCHAR(100),
    @GioiTinh BIT,
    @Email NVARCHAR(100),
    @SDT NVARCHAR(15),
    @NamSinh INT,
    @MaCN INT,
    @QuanLy INT = NULL,
    @DiaChi NVARCHAR(200),
    @TrangThai NVARCHAR(50) = N'Đang làm việc',
    @VaiTro NVARCHAR(50),
    @KinhNghiem INT = NULL,
    @TrinhDo NVARCHAR(100) = NULL
AS
BEGIN
    BEGIN TRY
        BEGIN TRANSACTION;

        -- Kiểm tra dữ liệu cơ bản
        IF @Ten IS NULL OR @Ten = ''
        BEGIN
            RAISERROR(N'Tên NhanVien không được để trống', 16, 1);
            RETURN;
        END

        IF @NamSinh > YEAR(GETDATE()) OR @NamSinh < 1900
        BEGIN
            RAISERROR(N'Năm sinh không hợp lệ', 16, 1);
            RETURN;
        END

        -- Kiểm tra email và số điện thoại
        IF EXISTS (SELECT 1 FROM NhanVien WHERE Email = @Email)
        BEGIN
            RAISERROR(N'Email đã tồn tại trong hệ thống', 16, 1);
            RETURN;
        END

        IF EXISTS (SELECT 1 FROM NhanVien WHERE SDT = @SDT)
        BEGIN
            RAISERROR(N'Số điện thoại đã tồn tại trong hệ thống', 16, 1);
            RETURN;
        END

        -- Kiểm tra chi nhánh và quản lý
        IF @MaCN IS NOT NULL AND NOT EXISTS (SELECT 1 FROM ChiNhanh WHERE MaCN = @MaCN)
        BEGIN
            RAISERROR(N'Chi nhánh không tồn tại', 16, 1);
            RETURN;
        END

        IF @QuanLy IS NULL
        BEGIN
            RAISERROR(N'Quản lý không tồn tại', 16, 1);
            RETURN;
        END

        -- Kiểm tra vai trò hợp lệ
        IF @VaiTro NOT IN (N'GiangVien', N'TroGiang', N'GiamSatVien', N'NhanVien')
        BEGIN
            RAISERROR(N'Vai trò không hợp lệ', 16, 1);
            RETURN;
        END

        -- Thêm NhanVien vào bảng NhanVien
        INSERT INTO NhanVien (
            Ten, GioiTinh, Email, SDT, NamSinh, 
            MaCN, QuanLy, DiaChi, TrangThai
        ) VALUES (
            @Ten, @GioiTinh, @Email, @SDT, @NamSinh, 
            @MaCN, @QuanLy, @DiaChi, @TrangThai
        );

        -- Lấy MaNV được sinh tự động
        DECLARE @GeneratedMaNV INT;
        SET @GeneratedMaNV = SCOPE_IDENTITY();

        -- Thêm vào bảng đặc trưng dựa trên vai trò
        IF @VaiTro = N'GiangVien'
        BEGIN
            IF @KinhNghiem IS NULL OR @TrinhDo IS NULL
            BEGIN
                RAISERROR(N'Cần cung cấp kinh nghiệm và trình độ cho GiangVien', 16, 1);
                ROLLBACK TRANSACTION;
                RETURN;
            END

            INSERT INTO GiangVien (MaNV, KinhNghiem, TrinhDo)
            VALUES (@GeneratedMaNV, @KinhNghiem, @TrinhDo);
        END
        ELSE IF @VaiTro = N'TroGiang'
        BEGIN
            IF @KinhNghiem IS NULL OR @TrinhDo IS NULL
            BEGIN
                RAISERROR(N'Cần cung cấp kinh nghiệm và trình độ cho TroGiang', 16, 1);
                ROLLBACK TRANSACTION;
                RETURN;
            END

            INSERT INTO TroGiang (MaNV, KinhNghiem, TrinhDo)
            VALUES (@GeneratedMaNV, @KinhNghiem, @TrinhDo);
        END
        ELSE IF @VaiTro = N'GiamSatVien'
        BEGIN
            INSERT INTO GiamSatVien (MaNV)
            VALUES (@GeneratedMaNV);
        END

        COMMIT TRANSACTION;

        SELECT N'Thêm NhanVien thành công' AS ThongBao, @GeneratedMaNV AS MaNhanVien;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;

        DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();
        SELECT N'Lỗi: ' + @ErrorMessage AS ThongBao, NULL AS MaNhanVien;
    END CATCH
END;
GO

GO
CREATE OR ALTER PROCEDURE dbo.CapNhatNhanVien 
    @MaNV INT,
    @Ten NVARCHAR(100),
    @GioiTinh BIT,
    @Email NVARCHAR(100),
    @SDT NVARCHAR(15),
    @NamSinh INT,
    @MaCN INT,
    @QuanLy INT = NULL,
    @DiaChi NVARCHAR(200),
    @TrangThai NVARCHAR(50),
    @VaiTro NVARCHAR(50) = NULL,      -- Vai trò mới
    @KinhNghiem INT = NULL,           -- Số năm kinh nghiệm (nếu cần)
    @TrinhDo NVARCHAR(100) = NULL     -- Trình độ (nếu cần)
AS
BEGIN
    BEGIN TRY
        -- Bắt đầu giao dịch
        BEGIN TRANSACTION;

        -- Kiểm tra NhanVien có tồn tại không
        IF NOT EXISTS (SELECT 1 FROM NhanVien WHERE MaNV = @MaNV)
        BEGIN
            RAISERROR(N'NhanVien không tồn tại', 16, 1);
            RETURN;
        END

        -- Cập nhật thông tin cơ bản trong bảng NhanVien
        UPDATE NhanVien 
        SET 
            Ten = @Ten,
            GioiTinh = @GioiTinh,
            Email = @Email,
            SDT = @SDT,
            NamSinh = @NamSinh,
            MaCN = @MaCN,
            QuanLy = @QuanLy,
            DiaChi = @DiaChi,
            TrangThai = @TrangThai
        WHERE MaNV = @MaNV;

        -- Xử lý thay đổi vai trò
        DECLARE @VaiTroCu NVARCHAR(50);

        -- Kiểm tra vai trò hiện tại
        IF EXISTS (SELECT 1 FROM GiangVien WHERE MaNV = @MaNV)
            SET @VaiTroCu = N'GiangVien';
        ELSE IF EXISTS (SELECT 1 FROM TroGiang WHERE MaNV = @MaNV)
            SET @VaiTroCu = N'TroGiang';
        ELSE IF EXISTS (SELECT 1 FROM GiamSatVien WHERE MaNV = @MaNV)
            SET @VaiTroCu = N'GiamSatVien';
        ELSE
            SET @VaiTroCu = N'NhanVien';

        -- Nếu vai trò mới khác vai trò cũ, xử lý chuyển đổi
        IF @VaiTro != @VaiTroCu AND @VaiTro IS NOT NULL
        BEGIN
            -- Xóa vai trò cũ
            IF @VaiTroCu = N'GiangVien'
                DELETE FROM GiangVien WHERE MaNV = @MaNV;
            ELSE IF @VaiTroCu = N'TroGiang'
                DELETE FROM TroGiang WHERE MaNV = @MaNV;
            ELSE IF @VaiTroCu = N'GiamSatVien'
                DELETE FROM GiamSatVien WHERE MaNV = @MaNV;

            -- Thêm vai trò mới
            IF @VaiTro = N'GiangVien'
                INSERT INTO GiangVien (MaNV, KinhNghiem, TrinhDo)
                VALUES (@MaNV, @KinhNghiem, @TrinhDo);
            ELSE IF @VaiTro = N'TroGiang'
                INSERT INTO TroGiang (MaNV, KinhNghiem, TrinhDo)
                VALUES (@MaNV, @KinhNghiem, @TrinhDo);
            ELSE IF @VaiTro = N'GiamSatVien'
                INSERT INTO GiamSatVien (MaNV)
                VALUES (@MaNV);
        END
        ELSE
        BEGIN
            -- Nếu vai trò không đổi, cập nhật dữ liệu đặc trưng
            IF @VaiTro = N'GiangVien'
                UPDATE GiangVien
                SET KinhNghiem = @KinhNghiem, TrinhDo = @TrinhDo
                WHERE MaNV = @MaNV;
            ELSE IF @VaiTro = N'TroGiang'
                UPDATE TroGiang
                SET KinhNghiem = @KinhNghiem, TrinhDo = @TrinhDo
                WHERE MaNV = @MaNV;
        END

        -- Commit giao dịch
        COMMIT TRANSACTION;

        -- Trả về kết quả
        SELECT N'Cập nhật NhanVien thành công' AS ThongBao, @MaNV AS MaNhanVien;
    END TRY
    BEGIN CATCH
        -- Rollback giao dịch nếu có lỗi
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;

        -- Trả về thông báo lỗi
        DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();
        SELECT N'Lỗi: ' + @ErrorMessage AS ThongBao, NULL AS MaNhanVien;
    END CATCH
END;
GO

GO
CREATE OR ALTER PROCEDURE dbo.XoaNhanVien
    @MaNV INT
AS
BEGIN
    BEGIN TRY
        -- Bắt đầu giao dịch
        BEGIN TRANSACTION;

        -- Kiểm tra NhanVien có tồn tại không
        IF NOT EXISTS (SELECT 1 FROM NhanVien WHERE MaNV = @MaNV)
        BEGIN
            RAISERROR(N'NhanVien không tồn tại', 16, 1);
            RETURN;
        END

        -- Kiểm tra các ràng buộc công việc
        IF EXISTS (SELECT 1 FROM NhanVien WHERE @MaNV = MaNV AND QuanLy = 1)
        BEGIN
            RAISERROR(N'Không thể xóa NhanVien vì đang là quản lý của NhanVien khác', 16, 1);
            RETURN;
        END

        IF EXISTS (SELECT 1 FROM LopHoc WHERE MaNV = @MaNV)
        BEGIN
            RAISERROR(N'Không thể xóa NhanVien vì đã vướng bận công việc', 16, 1);
            RETURN;
        END

		IF EXISTS (SELECT 1 FROM BuoiHoc WHERE MaGiangVien = @MaNV)
        BEGIN
            RAISERROR(N'Không thể xóa NhanVien vì đã vướng bận công việc', 16, 1);
            RETURN;
        END

		IF EXISTS (SELECT 1 FROM BuoiHoc WHERE MaTroGiang = @MaNV)
        BEGIN
            RAISERROR(N'Không thể xóa NhanVien vì đã vướng bận công việc', 16, 1);
            RETURN;
        END

		IF EXISTS (SELECT 1 FROM Hotro WHERE MaNV = @MaNV)
        BEGIN
            RAISERROR(N'Không thể xóa NhanVien vì đã vướng bận công việc', 16, 1);
            RETURN;
        END

		IF EXISTS (SELECT 1 FROM QuanLyNV WHERE NVCapDuoi = @MaNV)
        BEGIN
            RAISERROR(N'Không thể xóa NhanVien vì đã vướng bận công việc', 16, 1);
            RETURN;
        END

        -- Xóa vai trò trong các bảng đặc trưng
        DELETE FROM GiangVien WHERE MaNV = @MaNV;
        DELETE FROM TroGiang WHERE MaNV = @MaNV;
        DELETE FROM GiamSatVien WHERE MaNV = @MaNV;

        -- Xóa NhanVien
        DELETE FROM NhanVien WHERE MaNV = @MaNV

        -- Commit giao dịch
        COMMIT TRANSACTION;

        -- Trả về kết quả
        SELECT N'Xóa NhanVien thành công' AS ThongBao, @MaNV AS MaNhanVien;
    END TRY
    BEGIN CATCH
        -- Rollback giao dịch nếu có lỗi
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;

        -- Trả về thông báo lỗi
        DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();
        SELECT N'Lỗi: ' + @ErrorMessage AS ThongBao, NULL AS MaNhanVien;
    END CATCH
END;
GO