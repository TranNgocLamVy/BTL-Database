CREATE TABLE KhoaHoc (
    MaKhoaHoc INT IDENTITY(1,1) PRIMARY KEY, 
    Ten NVARCHAR(100) NOT NULL, 
    HocPhiGoc DECIMAL(18, 2) NOT NULL, 
    NoiDung NVARCHAR(MAX),
    ThoiLuong INT NOT NULL,
		TrangThai BIT NOT NULL,
		GioiHanSiSO INT NOT NULL,
		YeuCauTrinhDo NVARCHAR(MAX)
);

CREATE TABLE KhoaKyNang (
    MaKhoaHoc INT NOT NULL, -- MaKhoaHoc, khóa ngoại từ bảng KhoaHoc
    KyNang NVARCHAR(100) NOT NULL, -- Kỹ năng liên quan đến khóa học
    PRIMARY KEY (MaKhoaHoc, KyNang), -- Khóa chính bao gồm MaKhoaHoc và KyNang
    CONSTRAINT FK_KhoaKyNang_KhoaHoc FOREIGN KEY (MaKhoaHoc) REFERENCES KhoaHoc(MaKhoaHoc) 
    ON DELETE CASCADE -- Tùy chọn: Xóa bản ghi nếu khóa học bị xóa
);

CREATE TABLE KhoaOnThi (
    MaKhoaHoc INT PRIMARY KEY NOT NULL, -- MaKhoaHoc, khóa ngoại từ bảng KhoaHoc
    MucTieu NVARCHAR(100) NOT NULL, -- Kỹ năng liên quan đến khóa học
		LoaiChungChi NVARCHAR(100) NOT NULL, 
    CONSTRAINT FK_KhoaOnThi_KhoaHoc FOREIGN KEY (MaKhoaHoc) REFERENCES KhoaHoc(MaKhoaHoc) 
    ON DELETE CASCADE -- Tùy chọn: Xóa bản ghi nếu khóa học bị xóa
);

CREATE TABLE KhoaThNhi (
    MaKhoaHoc INT NOT NULL, -- MaKhoaHoc, khóa ngoại từ bảng KhoaHoc
    NgoaiKhoa NVARCHAR(100) NOT NULL, -- Kỹ năng liên quan đến khóa học
    PRIMARY KEY (MaKhoaHoc, NgoaiKhoa), -- Khóa chính bao gồm MaKhoaHoc và KyNang
    CONSTRAINT FK_KhoaThNhi_KhoaHoc FOREIGN KEY (MaKhoaHoc) REFERENCES KhoaHoc(MaKhoaHoc) 
    ON DELETE CASCADE -- Tùy chọn: Xóa bản ghi nếu khóa học bị xóa
);

CREATE TABLE KhoaThNien (
    MaKhoaHoc INT NOT NULL, -- MaKhoaHoc, khóa ngoại từ bảng KhoaHoc
    KyNangSong NVARCHAR(100) NOT NULL, -- Kỹ năng liên quan đến khóa học
    PRIMARY KEY (MaKhoaHoc, KyNangSong), -- Khóa chính bao gồm MaKhoaHoc và KyNang
    CONSTRAINT FK_KhoaThNien_KhoaHoc FOREIGN KEY (MaKhoaHoc) REFERENCES KhoaHoc(MaKhoaHoc) 
    ON DELETE CASCADE -- Tùy chọn: Xóa bản ghi nếu khóa học bị xóa
);

CREATE TABLE GiaoTrinh (
    MaGT INT IDENTITY(1,1) PRIMARY KEY,         -- Mã giáo trình, khóa chính
    NamXB INT NOT NULL,           -- Năm xuất bản, kiểu số nguyên
    TacGia NVARCHAR(100) NOT NULL, -- Tác giả, kiểu chuỗi Unicode
    Ten NVARCHAR(200) NOT NULL,   -- Tên giáo trình, kiểu chuỗi Unicode
    SoLuong INT NOT NULL,         -- Số lượng, kiểu số nguyên
    Gia DECIMAL(18, 2) NOT NULL   -- Giá tiền, kiểu số thực với 2 chữ số thập phân
);

CREATE TABLE ChiNhanh (
    MaCN INT IDENTITY(1,1) PRIMARY KEY,         -- Mã chi nhánh, khóa chính
    TenCN NVARCHAR(100) NOT NULL, -- Tên chi nhánh
    DiaChi NVARCHAR(200)          -- Địa chỉ chi nhánh
);

CREATE TABLE LopHoc (
    MaLH INT IDENTITY(1,1) PRIMARY KEY,          -- Mã lớp học, khóa chính
    NgayBatDau DATE NOT NULL,      -- Ngày bắt đầu
    NgayKetThuc DATE NOT NULL,     -- Ngày kết thúc
    SiSo INT NOT NULL,             -- Sĩ số học viên
    MaKhoaHoc INT NOT NULL,        -- Mã khóa học (liên kết với bảng KhoaHoc)
    MaCN INT NOT NULL,             -- Mã chi nhánh (liên kết với bảng ChiNhanh)
    MaNV INT NOT NULL,             -- Mã nhân viên phụ trách
    CONSTRAINT FK_LopHoc_ChiNhanh FOREIGN KEY (MaCN) REFERENCES ChiNhanh(MaCN),
		CONSTRAINT FK_LopHoc_KhoaHoc FOREIGN KEY (MaKhoaHoc) REFERENCES KhoaHoc(MaKhoaHoc)
    ON DELETE CASCADE -- Xóa lớp học nếu chi nhánh bị xóa
);

CREATE TABLE BuoiHoc (
    MaBH INT IDENTITY(1,1) PRIMARY KEY,          -- Mã buổi học, khóa chính
    MaLH INT NOT NULL,             -- Mã lớp học (liên kết với bảng LopHoc)
    HocSinhVang INT NOT NULL,      -- Số lượng học sinh vắng
    ThoiGian DATETIME NOT NULL,    -- Thời gian buổi học
    MaGiangVien INT NOT NULL,      -- Mã giảng viên
    MaTroGiang INT,                -- Mã trợ giảng (có thể NULL)
    CONSTRAINT FK_BuoiHoc_LopHoc FOREIGN KEY (MaLH) REFERENCES LopHoc(MaLH)
    ON DELETE CASCADE -- Xóa buổi học nếu lớp học bị xóa
);


CREATE TABLE HocVien (
    MaHV INT IDENTITY(1,1) PRIMARY KEY,          -- Mã học viên, khóa chính
    Ten NVARCHAR(100) NOT NULL,    -- Tên học viên
    GioiTinh BIT,         -- Giới tính (Nam/Nữ)
    Email NVARCHAR(100),           -- Email
    SDT NVARCHAR(15),              -- Số điện thoại
    NamSinh INT,                   -- Năm sinh
    TrinhDo NVARCHAR(50),          -- Trình độ
    DiaChi NVARCHAR(200)           -- Địa chỉ
);

CREATE TABLE PhuHuynh (
    MaHV INT NOT NULL,             -- Mã học viên (liên kết với bảng HocVien)
    TenPH NVARCHAR(100) NOT NULL,  -- Tên phụ huynh
    NamSinh INT,                   -- Năm sinh của phụ huynh
    GioiTinh BIT,         -- Giới tính (Nam/Nữ)
    Email NVARCHAR(100),           -- Email của phụ huynh
    SDT NVARCHAR(15),              -- Số điện thoại của phụ huynh
    QuanHe NVARCHAR(50),           -- Quan hệ (cha, mẹ, anh, chị, v.v.)
    PRIMARY KEY (MaHV, TenPH),     -- Khóa chính bao gồm MaHV và TenPH
    CONSTRAINT FK_PhuHuynh_HocVien FOREIGN KEY (MaHV) REFERENCES HocVien(MaHV)
    ON DELETE CASCADE -- Xóa phụ huynh nếu học viên bị xóa
);


CREATE TABLE NhanVien (
    MaNV INT IDENTITY(1,1) PRIMARY KEY,           -- Mã nhân viên, khóa chính
    Ten NVARCHAR(100) NOT NULL,     -- Tên nhân viên
    GioiTinh BIT,                   -- Giới tính (0: Nam, 1: Nữ)
    Email NVARCHAR(100),            -- Email nhân viên
    SDT NVARCHAR(15),               -- Số điện thoại
    NamSinh INT,                    -- Năm sinh
    MaCN INT,              -- Mã chi nhánh (liên kết với ChiNhanh)
    QuanLy INT,                     -- Mã quản lý (là một nhân viên khác)
    DiaChi NVARCHAR(200),           -- Địa chỉ
    TrangThai NVARCHAR(50),         -- Trạng thái nhân viên (đang làm việc, nghỉ việc, v.v.)
    CONSTRAINT FK_NhanVien_ChiNhanh FOREIGN KEY (MaCN) REFERENCES ChiNhanh(MaCN)
    ON DELETE SET NULL -- Nếu quản lý bị xóa, giá trị sẽ NULL
);


CREATE TABLE GiangVien (
    MaNV INT PRIMARY KEY,            -- Mã nhân viên, khóa chính
    KinhNghiem INT,                  -- Số năm kinh nghiệm
    TrinhDo NVARCHAR(100),           -- Trình độ giảng viên
    CONSTRAINT FK_GiangVien_NhanVien FOREIGN KEY (MaNV) REFERENCES NhanVien(MaNV)
    ON DELETE CASCADE -- Xóa giảng viên nếu nhân viên bị xóa
);
	
CREATE TABLE TroGiang (
    MaNV INT PRIMARY KEY,            -- Mã nhân viên, khóa chính
    KinhNghiem INT,                  -- Số năm kinh nghiệm
    TrinhDo NVARCHAR(100),           -- Trình độ trợ giảng
    CONSTRAINT FK_TroGiang_NhanVien FOREIGN KEY (MaNV) REFERENCES NhanVien(MaNV)
    ON DELETE CASCADE -- Xóa trợ giảng nếu nhân viên bị xóa
);

CREATE TABLE GiamSatVien (
    MaNV INT PRIMARY KEY,            -- Mã nhân viên, khóa chính
    CONSTRAINT FK_GiamSatVien_NhanVien FOREIGN KEY (MaNV) REFERENCES NhanVien(MaNV)
    ON DELETE CASCADE -- Xóa giám sát viên nếu nhân viên bị xóa
);

CREATE TABLE QuanLyNV (
    MaNV INT NOT NULL,               -- Mã nhân viên quản lý
    NVCapDuoi INT NOT NULL,          -- Mã nhân viên cấp dưới
    PRIMARY KEY (MaNV, NVCapDuoi),   -- Khóa chính gồm MaNV và NVCapDuoi
    CONSTRAINT FK_QuanLyNV_MaNV FOREIGN KEY (MaNV) REFERENCES NhanVien(MaNV),
    CONSTRAINT FK_QuanLyNV_NVCapDuoi FOREIGN KEY (NVCapDuoi) REFERENCES NhanVien(MaNV)
);

CREATE TABLE UuDai (
    MaUuDai INT IDENTITY(1,1) PRIMARY KEY,           -- Mã ưu đãi, khóa chính
    NgayApDung DATE NOT NULL,          -- Ngày bắt đầu áp dụng
    NgayKetThuc DATE NOT NULL,         -- Ngày kết thúc
    PhanTramGiam FLOAT,                -- Phần trăm giảm giá
    MaKhoaHoc INT NOT NULL,            -- Mã khóa học (liên kết với KhoaHoc)
    GiamTien DECIMAL(18, 2),           -- Số tiền giảm giá
    CONSTRAINT FK_UuDai_KhoaHoc FOREIGN KEY (MaKhoaHoc) REFERENCES KhoaHoc(MaKhoaHoc)
    ON DELETE CASCADE -- Xóa ưu đãi nếu khóa học bị xóa
);


CREATE TABLE PhieuDangKy (
    MaDK INT IDENTITY(1,1) PRIMARY KEY,              -- Mã phiếu đăng ký, khóa chính
    NgayDangKy DATE NOT NULL,          -- Ngày đăng ký
    NgayThi DATE,                      -- Ngày thi
    Diem FLOAT,                        -- Điểm số (nếu có)
    MaHV INT NOT NULL,                 -- Mã học viên (liên kết với HocVien)
    MaUuDai INT,                       -- Mã ưu đãi (liên kết với UuDai)
    HocPhi DECIMAL(18, 2) NOT NULL,    -- Học phí (lấy từ bảng KhoaHoc)
    MaLH INT NOT NULL,                 -- Mã lớp học (liên kết với LopHoc)
    TongHoaDon DECIMAL(18, 2), 	        -- Tổng hóa đơn (sau khi áp dụng ưu đãi)
    CONSTRAINT FK_PhieuDK_HocVien FOREIGN KEY (MaHV) REFERENCES HocVien(MaHV)
    ON DELETE CASCADE,
    CONSTRAINT FK_PhieuDK_UuDai FOREIGN KEY (MaUuDai) REFERENCES UuDai(MaUuDai)
    ON DELETE No Action, -- Nếu ưu đãi bị xóa, để NULL
    CONSTRAINT FK_PhieuDK_LopHoc FOREIGN KEY (MaLH) REFERENCES LopHoc(MaLH)
    ON DELETE No Action
);

CREATE TABLE SuDung (
    MaGT INT,
    MaKhoaHoc INT,
    PRIMARY KEY (MaGT, MaKhoaHoc),
    FOREIGN KEY (MaGT) REFERENCES GiaoTrinh(MaGT),
    FOREIGN KEY (MaKhoaHoc) REFERENCES KhoaHoc(MaKhoaHoc)
);

CREATE TABLE DiHoc (
    MaHV INT,
    MaBH INT,
    KQ_DiemDanh BIT, -- Giả sử kết quả điểm danh là kiểu BIT (1 cho có mặt, 0 cho vắng)
    PRIMARY KEY (MaHV, MaBH),
    FOREIGN KEY (MaHV) REFERENCES HocVien(MaHV),
    FOREIGN KEY (MaBH) REFERENCES BuoiHoc(MaBH)
);

CREATE TABLE DanhGia (
    MaKH INT,
    MaHV INT,
    SoSao INT, -- Số sao đánh giá
    DanhGia NVARCHAR(500), -- Mô tả đánh giá
    PRIMARY KEY (MaKH, MaHV),
    FOREIGN KEY (MaKH) REFERENCES KhoaHoc(MaKhoaHoc),
    FOREIGN KEY (MaHV) REFERENCES HocVien(MaHV)
);

CREATE TABLE MuaGT (
    MaGT INT,
    MaDK INT,
    SoLuongMua INT, -- Số lượng mua
    TongGia DECIMAL(18, 2), -- Tổng giá trị (Giả sử giá trị tổng là kiểu DECIMAL)
    PRIMARY KEY (MaGT, MaDK),
    FOREIGN KEY (MaGT) REFERENCES GiaoTrinh(MaGT),
    FOREIGN KEY (MaDK) REFERENCES PhieuDangKy(MaDK)
);

CREATE TABLE GiangDay (
    MaBH INT,
    MaNV INT,
    PRIMARY KEY (MaBH, MaNV),
    FOREIGN KEY (MaBH) REFERENCES BuoiHoc(MaBH),
    FOREIGN KEY (MaNV) REFERENCES GiangVien(MaNV)
);

CREATE TABLE HoTro (
    MaBH INT,
    MaNV INT,
    PRIMARY KEY (MaBH, MaNV),
    FOREIGN KEY (MaBH) REFERENCES BuoiHoc(MaBH),
    FOREIGN KEY (MaNV) REFERENCES TroGiang(MaNV)
);

ALTER TABLE LopHoc
ADD CONSTRAINT FK_LopHoc_GiamSatVien
FOREIGN KEY (MaNV) REFERENCES GiamSatVien(MaNV);

ALTER TABLE BuoiHoc
ADD CONSTRAINT FK_LopHoc_GiangVien
FOREIGN KEY (MaGiangVien) REFERENCES GiangVien(MaNV);


ALTER TABLE BuoiHoc
ADD CONSTRAINT FK_LopHoc_TroGiang
FOREIGN KEY (MaTroGiang) REFERENCES TroGiang(MaNV);