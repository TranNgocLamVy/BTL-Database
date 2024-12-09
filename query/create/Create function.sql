GO
CREATE OR ALTER FUNCTION GetUnfullClass ( @startDate DATE )
RETURNS @ClassList TABLE (
    MaLH INT,
    TenKhoaHoc NVARCHAR(100),
	SiSo INT,
	GioiHanSiSo INT,
    NgayBatDau DATE,
    NgayKetThuc DATE,
    TenCN NVARCHAR(100),
  	DiaChi NVARCHAR(200),
	BaoLoi NVARCHAR(255)
)
AS
BEGIN
    -- Kiểm tra tham số đầu vào
    IF @startDate IS NULL
    BEGIN
        INSERT INTO @ClassList (MaLH, BaoLoi)
        VALUES (NULL, 'Tham so startDate khong đuoc null');
        RETURN;
    END

    -- Khai báo con trỏ
    DECLARE classCursor CURSOR FOR
    SELECT 
        l.MaLH, k.Ten AS TenKhoaHoc, l.SiSo, k.GioiHanSiSO,
        l.NgayBatDau, l.NgayKetThuc,
        cn.TenCN, cn.DiaChi
    FROM LopHoc l
    INNER JOIN KhoaHoc k ON l.MaKhoaHoc = k.MaKhoaHoc
    INNER JOIN ChiNhanh cn on cn.MaCN = l.MaCN
    WHERE l.SiSo < k.GioiHanSiSO AND l.NgayBatDau > @startDate;
    
    

    -- Biến lưu trữ dữ liệu từ con trỏ
    DECLARE 
        @MaLH INT, @TenKhoaHoc NVARCHAR(100), @SiSo INT, @GioiHanSiSo INT,
        @NgayBatDau DATE, @NgayKetThuc DATE, @TenCN NVARCHAR(100), @DiaChi NVARCHAR(200)

    -- Mở con trỏ
    OPEN classCursor;

    FETCH NEXT FROM classCursor INTO 
        @MaLH, @TenKhoaHoc, @SiSo, @GioiHanSiSo,
		@NgayBatDau, @NgayKetThuc, @TenCN, @DiaChi

    -- Sử dụng vòng lặp để xử lý dữ liệu
    WHILE @@FETCH_STATUS = 0
    BEGIN
         -- Thêm dữ liệu vào bảng trả về
         INSERT INTO @ClassList (
              MaLH, TenKhoaHoc, SiSo, GioiHanSiSo,
		      NgayBatDau, NgayKetThuc, TenCN, DiaChi
            )
         VALUES (
              @MaLH, @TenKhoaHoc, @SiSo, @GioiHanSiSo,
              @NgayBatDau, @NgayKetThuc, @TenCN, @DiaChi
         );

        -- Lấy dữ liệu tiếp theo
        FETCH NEXT FROM classCursor INTO 
            @MaLH, @TenKhoaHoc, @SiSo, @GioiHanSiSo,
            @NgayBatDau, @NgayKetThuc, @TenCN, @DiaChi
    END

    -- Đóng và giải phóng con trỏ
    CLOSE classCursor;
    DEALLOCATE classCursor;

    RETURN;
END;
GO

GO
CREATE OR ALTER FUNCTION GetUnderperformingStudents ( @CourseID INT )
RETURNS @StudentList TABLE (
    MaHV INT,
    TenHocVien NVARCHAR(100),
	GioiTinh BIT,
	NamSinh INT,
	TenKhoaHoc NVARCHAR(100),
	Diem INT,
	Email NVARCHAR(100),
    SDT NVARCHAR(15),
	BaoLoi NVARCHAR(255)
)
AS
BEGIN
    -- Kiểm tra tham số đầu vào
    IF @CourseID IS NULL
    BEGIN
        INSERT INTO @StudentList (MaHV, BaoLoi)
        VALUES (NULL, 'Tham so CourseID khong đuoc null');
        RETURN;
    END

    -- Khai báo con trỏ
    DECLARE studentCursor CURSOR FOR
    SELECT 
        pdk.MaHV, stu.Ten AS TenHocVien, stu.GioiTinh, stu.NamSinh,
		k.Ten AS TenKhoaHoc, pdk.Diem,
        stu.Email, stu.SDT
    FROM PhieuDangKy pdk
    INNER JOIN LopHoc l
	        INNER JOIN KhoaHoc k ON l.MaKhoaHoc = k.MaKhoaHoc
	  ON pdk.MaLH = l.MaLH
	INNER JOIN HocVien stu ON pdk.MaHV = stu.MaHV
	
    WHERE k.MaKhoaHoc = @CourseID AND pdk.Diem < 5;

    -- Biến lưu trữ dữ liệu từ con trỏ
    DECLARE 
        @MaHV INT, @TenHocVien NVARCHAR(100), @GioiTinh BIT, @NamSinh INT,
		@TenKhoaHoc NVARCHAR(100), @Diem INT,
		@Email NVARCHAR(100), @SDT NVARCHAR(15);

    -- Mở con trỏ
    OPEN studentCursor;

    FETCH NEXT FROM studentCursor INTO 
        @MaHV, @TenHocVien, @GioiTinh, @NamSinh,
		@TenKhoaHoc, @Diem,
		@Email, @SDT;

    -- Sử dụng vòng lặp để xử lý dữ liệu
    WHILE @@FETCH_STATUS = 0
    BEGIN
        -- Thêm dữ liệu vào bảng trả về
        INSERT INTO @StudentList (
            MaHV, TenHocVien, GioiTinh, NamSinh,
		    TenKhoaHoc, Diem,
		    Email, SDT
        )
        VALUES (
            @MaHV, @TenHocVien, @GioiTinh, @NamSinh,
		    @TenKhoaHoc, @Diem,
		    @Email, @SDT
        );

        -- Lấy dữ liệu tiếp theo
        FETCH NEXT FROM studentCursor INTO 
            @MaHV, @TenHocVien, @GioiTinh, @NamSinh,
		    @TenKhoaHoc, @Diem,
		    @Email, @SDT
    END

    -- Đóng và giải phóng con trỏ
    CLOSE studentCursor;
    DEALLOCATE studentCursor;

    RETURN;
END;
GO