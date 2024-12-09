GO
CREATE OR ALTER TRIGGER dbo.MuaGiaoTrinh ON MuaGT AFTER INSERT AS
BEGIN
    -- Bảo vệ giao tác, đảm bảo tính toàn vẹn dữ liệu
    BEGIN TRANSACTION;

    BEGIN TRY
        -- Cập nhật số lượng giáo trình còn lại trong kho
        UPDATE GiaoTrinh
        SET SoLuong = SoLuong - i.SoLuongMua
        FROM GiaoTrinh g
        INNER JOIN Inserted i ON g.MaGT = i.MaGT
        WHERE i.SoLuongMua IS NOT NULL;

        -- Kiểm tra nếu số lượng giáo trình trong kho bị âm
        IF EXISTS (
            SELECT 1
            FROM GiaoTrinh
            WHERE SoLuong < 0
        )
        BEGIN
            -- Rollback nếu số lượng giáo trình âm
            ROLLBACK TRANSACTION;
            THROW 50000, 'Số lượng giáo trình trong kho không đủ để thực hiện giao dịch.', 1;
        END

        -- Commit giao tác
        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        -- Rollback nếu có lỗi xảy ra
        ROLLBACK TRANSACTION;
        THROW;
    END CATCH;
END;
GO

GO
CREATE OR ALTER TRIGGER dbo.InSoSaoTrungBinh ON DanhGia AFTER INSERT AS
BEGIN
   -- Khai báo biến
    DECLARE @MaKH INT;
	DECLARE @TenKhoaHoc NVARCHAR(100);
    DECLARE @SaoTrungBinh DECIMAL(5, 2);

    -- Lấy 1 Mã Khóa Học từ bảng Inserted
    SELECT TOP 1 @MaKH = MaKH FROM Inserted;

	-- Lấy Tên Khóa Học từ bảng KhoaHoc
    SELECT @TenKhoaHoc = Ten
    FROM KhoaHoc
    WHERE MaKhoaHoc = @MaKH;

	-- Tính số sao trung bình
    SELECT @SaoTrungBinh = AVG(CAST(SoSao AS DECIMAL(5, 2)))
    FROM DanhGia
    WHERE MaKH = @MaKH AND SoSao IS NOT NULL;

    -- In ra kết quả
    PRINT 'Số sao trung bình của khóa học "' + @TenKhoaHoc + 
          '" là: ' + CAST(@SaoTrungBinh AS NVARCHAR)
END;
GO