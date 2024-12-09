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

INSERT INTO KhoaHoc (Ten, HocPhiGoc, NoiDung, ThoiLuong, TrangThai, GioiHanSiSo, YeuCauTrinhDo)
VALUES 
    (N'Khóa Ôn Thi', 5000000, N'Khóa ôn thi Tiếng Anh cấp tốc', 3, 1, 40, N'Trung Bình'),
	(N'Khóa Kỹ Năng', 4000000, N'Khóa rèn luyện kỹ năng mềm', 3, 1, 40, N'Trung Bình'),
	(N'Khóa Thiếu Nhi', 2000000, N'Tham gia hoạt động ngoại khóa', 1, 1, 40, N'Trung Bình'),
	(N'Khóa Thiếu Niên', 3000000, N'Khóa học kỹ năng sống', 3, 1, 40, N'Trung Bình')


INSERT INTO HocVien (Ten, GioiTinh, Email, SDT, NamSinh, TrinhDo, DiaChi)
VALUES 
    (N'Nguyễn Văn A', 1, 'a.nguyen@example.com', '0912345678', 2000, N'Khá', N'Hà Nội'),
    (N'Trần Thị B', 0, 'b.tran@example.com', '0987654321', 2001, N'Giỏi', N'Hồ Chí Minh'),
    (N'Lê Hoàng C', 1, 'c.le@example.com', '0901234567', 2002, N'Trung Bình', N'Đà Nẵng'),
    (N'Phạm Thu D', 0, 'd.pham@example.com', '0934567890', 2003, N'Xuất Sắc', N'Hải Phòng'),
    (N'Hoàng Văn E', 1, 'e.hoang@example.com', '0923456789', 2004, N'Khá', N'Cần Thơ'),
    (N'Vũ Thị F', 0, 'f.vu@example.com', '0945678901', 2005, N'Giỏi', N'Quảng Ninh'),
    (N'Nguyễn Minh G', 1, 'g.nguyen@example.com', '0919876543', 2006, N'Trung Bình', N'Bắc Giang'),
    (N'Phạm Mai H', 0, 'h.pham@example.com', '0981239876', 2007, N'Xuất Sắc', N'Hà Tĩnh'),
    (N'Bùi Anh I', 1, 'i.bui@example.com', '0909871234', 2008, N'Khá', N'Nghệ An'),
    (N'Đặng Thùy J', 0, 'j.dang@example.com', '0932104567', 2009, N'Giỏi', N'Quảng Bình'),
    (N'Phan Thanh K', 1, 'k.phan@example.com', '0921098765', 2010, N'Trung Bình', N'Lâm Đồng'),
    (N'Trương Hà L', 0, 'l.truong@example.com', '0943216789', 2011, N'Xuất Sắc', N'Nha Trang'),
    (N'Nguyễn Văn M', 1, 'm.nguyen@example.com', '0902345678', 2012, N'Khá', N'Hải Dương'),
    (N'Trần Thị N', 0, 'n.tran@example.com', '0913456789', 2013, N'Giỏi', N'Hòa Bình'),
    (N'Lê Minh O', 1, 'o.le@example.com', '0934561234', 2014, N'Trung Bình', N'Bình Dương'),
    (N'Phạm Thị P', 0, 'p.pham@example.com', '0925678901', 2015, N'Xuất Sắc', N'Long An'),
    (N'Hoàng Anh Q', 1, 'q.hoang@example.com', '0916789012', 2016, N'Khá', N'Thái Nguyên'),
    (N'Vũ Thị R', 0, 'r.vu@example.com', '0947890123', 2017, N'Giỏi', N'Tây Ninh'),
    (N'Nguyễn Minh S', 1, 's.nguyen@example.com', '0908901234', 2018, N'Trung Bình', N'Lào Cai'),
    (N'Phạm Hà T', 0, 't.pham@example.com', '0989012345', 2000, N'Xuất Sắc', N'Bến Tre'), 
	(N'Trần Văn U', 1, 'u.tran@example.com', '0912348888', 2001, N'Khá', N'Hải Phòng'),
    (N'Ngô Thị V', 0, 'v.ngo@example.com', '0987658888', 2002, N'Giỏi', N'Hà Nội'),
    (N'Lê Văn W', 1, 'w.le@example.com', '0908881234', 2003, N'Trung Bình', N'Hồ Chí Minh'),
    (N'Phạm Thị X', 0, 'x.pham@example.com', '0938887890', 2004, N'Xuất Sắc', N'Đà Nẵng'),
    (N'Nguyễn Minh Y', 1, 'y.nguyen@example.com', '0928889999', 2005, N'Khá', N'Nghệ An'),
    (N'Hoàng Thị Z', 0, 'z.hoang@example.com', '0948880000', 2006, N'Giỏi', N'Thái Bình'),
    (N'Vũ Văn AA', 1, 'aa.vu@example.com', '0919878888', 2007, N'Trung Bình', N'Hưng Yên'),
    (N'Phạm Mai BB', 0, 'bb.pham@example.com', '0981238888', 2008, N'Xuất Sắc', N'Quảng Ninh'),
    (N'Bùi Văn CC', 1, 'cc.bui@example.com', '0909871111', 2009, N'Khá', N'Long An'),
    (N'Ngô Thị DD', 0, 'dd.ngo@example.com', '0932102222', 2010, N'Giỏi', N'Tây Ninh'),
    (N'Lê Văn EE', 1, 'ee.le@example.com', '0921093333', 2011, N'Trung Bình', N'Nha Trang'),
    (N'Nguyễn Thị FF', 0, 'ff.nguyen@example.com', '0943214444', 2012, N'Xuất Sắc', N'Lâm Đồng'),
    (N'Trần Văn GG', 1, 'gg.tran@example.com', '0902345555', 2013, N'Khá', N'Cần Thơ'),
    (N'Hoàng Thị HH', 0, 'hh.hoang@example.com', '0913456666', 2014, N'Giỏi', N'Bình Dương'),
    (N'Lê Văn II', 1, 'ii.le@example.com', '0934567777', 2015, N'Trung Bình', N'Hà Giang'),
    (N'Phạm Thị JJ', 0, 'jj.pham@example.com', '0925678888', 2016, N'Xuất Sắc', N'Hà Nam'),
    (N'Nguyễn Văn KK', 1, 'kk.nguyen@example.com', '0916789999', 2017, N'Khá', N'Bến Tre'),
    (N'Phạm Hà LL', 0, 'll.pham@example.com', '0947890000', 2018, N'Giỏi', N'Hậu Giang'),
    (N'Trương Văn MM', 1, 'mm.truong@example.com', '0908901111', 2000, N'Trung Bình', N'Vĩnh Long'),
    (N'Lê Thị NN', 0, 'nn.le@example.com', '0989012222', 2001, N'Xuất Sắc', N'Quảng Bình'),
	(N'Nguyễn Văn OO', 1, 'oo.nguyen@example.com', '0901234560', 2002, N'Khá', N'Hải Phòng'),
    (N'Trần Thị PP', 0, 'pp.tran@example.com', '0912345671', 2003, N'Giỏi', N'Hà Nội'),
    (N'Lê Văn QQ', 1, 'qq.le@example.com', '0923456782', 2004, N'Trung Bình', N'Hồ Chí Minh'),
    (N'Phạm Thị RR', 0, 'rr.pham@example.com', '0934567893', 2005, N'Xuất Sắc', N'Đà Nẵng'),
    (N'Nguyễn Văn SS', 1, 'ss.nguyen@example.com', '0945678904', 2006, N'Khá', N'Nghệ An'),
    (N'Hoàng Thị TT', 0, 'tt.hoang@example.com', '0956789015', 2007, N'Giỏi', N'Thái Bình'),
    (N'Vũ Văn UU', 1, 'uu.vu@example.com', '0967890126', 2008, N'Trung Bình', N'Hưng Yên'),
    (N'Phạm Mai VV', 0, 'vv.pham@example.com', '0978901237', 2009, N'Xuất Sắc', N'Quảng Ninh'),
    (N'Bùi Văn WW', 1, 'ww.bui@example.com', '0989012348', 2010, N'Khá', N'Long An'),
    (N'Ngô Thị XX', 0, 'xx.ngo@example.com', '0990123459', 2011, N'Giỏi', N'Tây Ninh'),
    (N'Lê Văn YY', 1, 'yy.le@example.com', '0901234567', 2012, N'Trung Bình', N'Nha Trang'),
    (N'Nguyễn Thị ZZ', 0, 'zz.nguyen@example.com', '0912345678', 2013, N'Xuất Sắc', N'Lâm Đồng'),
    (N'Trần Văn AAA', 1, 'aaa.tran@example.com', '0923456789', 2014, N'Khá', N'Cần Thơ'),
    (N'Hoàng Thị BBB', 0, 'bbb.hoang@example.com', '0934567890', 2015, N'Giỏi', N'Bình Dương'),
    (N'Lê Văn CCC', 1, 'ccc.le@example.com', '0945678901', 2016, N'Trung Bình', N'Hà Giang'),
    (N'Phạm Thị DDD', 0, 'ddd.pham@example.com', '0956789012', 2017, N'Xuất Sắc', N'Hà Nam'),
    (N'Nguyễn Văn EEE', 1, 'eee.nguyen@example.com', '0967890123', 2018, N'Khá', N'Bến Tre'),
    (N'Phạm Hà FFF', 0, 'fff.pham@example.com', '0978901234', 2000, N'Giỏi', N'Hậu Giang'),
    (N'Trương Văn GGG', 1, 'ggg.truong@example.com', '0989012345', 2001, N'Trung Bình', N'Vĩnh Long'),
    (N'Lê Thị HHH', 0, 'hhh.le@example.com', '0990123456', 2002, N'Xuất Sắc', N'Quảng Bình'),
    (N'Ngô Văn III', 1, 'iii.ngo@example.com', '0912123456', 2003, N'Khá', N'Hòa Bình'),
    (N'Nguyễn Thị JJJ', 0, 'jjj.nguyen@example.com', '0923234567', 2004, N'Giỏi', N'Ninh Bình'),
    (N'Lê Văn KKK', 1, 'kkk.le@example.com', '0934345678', 2005, N'Trung Bình', N'Hà Tĩnh'),
    (N'Hoàng Thị LLL', 0, 'lll.hoang@example.com', '0945456789', 2006, N'Xuất Sắc', N'Lào Cai'),
    (N'Trần Văn MMM', 1, 'mmm.tran@example.com', '0956567890', 2007, N'Khá', N'Bắc Ninh'),
    (N'Nguyễn Thị NNN', 0, 'nnn.nguyen@example.com', '0967678901', 2008, N'Giỏi', N'Bắc Giang'),
    (N'Bùi Văn OOO', 1, 'ooo.bui@example.com', '0978789012', 2009, N'Trung Bình', N'Quảng Nam'),
    (N'Lê Văn PPP', 0, 'ppp.le@example.com', '0989890123', 2010, N'Xuất Sắc', N'Bình Định'),
    (N'Trần Văn QQQ', 1, 'qqq.tran@example.com', '0990901234', 2011, N'Khá', N'Phú Yên'),
    (N'Nguyễn Thị RRR', 0, 'rrr.nguyen@example.com', '0911012345', 2012, N'Giỏi', N'Huế'),
    (N'Lê Văn SSS', 1, 'sss.le@example.com', '0922123456', 2013, N'Trung Bình', N'Vũng Tàu'),
    (N'Trần Thị TTT', 0, 'ttt.tran@example.com', '0933234567', 2014, N'Xuất Sắc', N'Tiền Giang'),
    (N'Hoàng Văn UUU', 1, 'uuu.hoang@example.com', '0944345678', 2015, N'Khá', N'Kiên Giang'),
    (N'Ngô Văn VVV', 0, 'vvv.ngo@example.com', '0955456789', 2016, N'Giỏi', N'An Giang'),
    (N'Lê Thị WWW', 1, 'www.le@example.com', '0966567890', 2017, N'Trung Bình', N'Cà Mau'),
    (N'Trần Văn XXX', 0, 'xxx.tran@example.com', '0977678901', 2018, N'Xuất Sắc', N'Sóc Trăng'),
    (N'Lê Văn YYY', 1, 'yyy.le@example.com', '0988789012', 2000, N'Khá', N'Kon Tum'),
    (N'Nguyễn Thị ZZZ', 0, 'zzz.nguyen@example.com', '0999890123', 2001, N'Giỏi', N'Gia Lai'),
    (N'Phạm Văn AAAA', 1, 'aaaa.pham@example.com', '0910901234', 2002, N'Trung Bình', N'Dak Lak'),
    (N'Lê Văn BBBB', 0, 'bbbb.le@example.com', '0921012345', 2003, N'Xuất Sắc', N'Bình Phước'),
    (N'Trần Thị CCCC', 0, 'cccc.tran@example.com', '0932123456', 2004, N'Khá', N'Dak Nong'),
    (N'Hoàng Văn DDDD', 1, 'dddd.hoang@example.com', '0943234567', 2005, N'Giỏi', N'Khánh Hòa'),
    (N'Lê Văn EEEE', 1, 'eeee.le@example.com', '0954345678', 2006, N'Trung Bình', N'Ninh Thuận'),
    (N'Ngô Văn FFFF', 1, 'ffff.ngo@example.com', '0965456789', 2007, N'Xuất Sắc', N'Thanh Hóa'),
    (N'Phạm Văn GGGG', 1, 'gggg.pham@example.com', '0976567890', 2008, N'Khá', N'Hải Dương'),
    (N'Lê Văn HHHH', 1, 'hhhh.le@example.com', '0987678901', 2009, N'Giỏi', N'Nam Định'),
    (N'Trần Văn IIII', 1, 'iiii.tran@example.com', '0998789012', 2010, N'Trung Bình', N'Sơn La'),
    (N'Nguyễn Thị JJJJ', 1, 'jjjj.nguyen@example.com', '0919890123', 2011, N'Xuất Sắc', N'Lai Châu'),
    (N'Lê Văn KKKK', 0, 'kkkk.le@example.com', '0920901234', 2012, N'Khá', N'Yên Bái'),
    (N'Trần Văn LLLL', 1, 'llll.tran@example.com', '0931012345', 2013, N'Giỏi', N'Cao Bằng'),
    (N'Hoàng Văn MMMM', 1, 'mmmm.hoang@example.com', '0942123456', 2014, N'Trung Bình', N'Hòa Bình'),
    (N'Nguyễn Văn NNNN', 1, 'nnnn.nguyen@example.com', '0953234567', 2015, N'Xuất Sắc', N'Lạng Sơn'),
    (N'Lê Thị OOOO', 0, 'oooo.le@example.com', '0964345678', 2016, N'Khá', N'Hà Nam'),
    (N'Trần Văn PPPP', 1, 'pppp.tran@example.com', '0975456789', 2017, N'Giỏi', N'Bắc Ninh'),
    (N'Hoàng Văn QQQQ', 1, 'qqqq.hoang@example.com', '0986567890', 2018, N'Trung Bình', N'Bắc Giang'),
    (N'Lê Văn RRRR', 1, 'rrrr.le@example.com', '0997678901', 2000, N'Xuất Sắc', N'Thái Nguyên'),
    (N'Trần Thị SSSS', 1, 'ssss.tran@example.com', '0918789012', 2001, N'Khá', N'Hà Nội'),
    (N'Lê Văn TTTT', 0, 'tttt.le@example.com', '0929890123', 2002, N'Giỏi', N'Quảng Ngãi'),
    (N'Ngô Văn UUUU', 1, 'uuuu.ngo@example.com', '0930901234', 2003, N'Trung Bình', N'Hà Giang'),
    (N'Trần Thị VVVV', 0, 'vvvv.tran@example.com', '0941012345', 2004, N'Xuất Sắc', N'Nghệ An');

insert into ChiNhanh (TenCN, DiaChi)
VALUES
		(N'Chi nhánh 1', N'Thủ Đức'),
		(N'Chi nhánh 2', N'Tân Bình'),
		(N'Chi nhánh 3', N'Tân Phú');


INSERT INTO GiaoTrinh (Ten, NamXB, TacGia, SoLuong, Gia)
VALUES 
    (N'Sách ôn thi TOEIC cơ bản', 2020, N'Nguyễn Văn A', 100, 150000),
    (N'Sách luyện thi IELTS nâng cao', 2021, N'Trần Thị B', 50, 200000),
    (N'Sách ôn thi tiếng Anh B1', 2019, N'Lê Văn C', 70, 120000),
    (N'Sách luyện đề TOEFL iBT', 2022, N'Hoàng Thị D', 60, 250000),
    (N'Grammar for TOEIC', 2023, N'Nguyễn Văn E', 90, 180000),
    
    (N'Kỹ năng giao tiếp tiếng Anh thực tế', 2018, N'Trần Thị F', 80, 130000),
    (N'Học kỹ năng quản lý thời gian tiếng Anh', 2019, N'Phạm Văn G', 100, 140000),
    (N'Kỹ năng tư duy tiếng Anh', 2020, N'Nguyễn Văn H', 70, 160000),
    (N'Làm việc nhóm hiệu quả bằng tiếng Anh', 2021, N'Lê Thị I', 50, 150000),
    (N'Kỹ năng đàm phán tiếng Anh chuyên nghiệp', 2023, N'Trần Văn J', 60, 170000),
    
    (N'Trò chơi tiếng Anh sáng tạo', 2022, N'Lê Thị K', 100, 190000),
    (N'Hoạt động ngoại khóa tiếng Anh trẻ em', 2019, N'Trần Văn L', 120, 110000),
    (N'Sách câu đố tiếng Anh thú vị', 2020, N'Hoàng Thị M', 80, 100000),
    (N'Sách hướng dẫn cắm trại tiếng Anh', 2021, N'Phạm Văn N', 60, 125000),
    (N'Bài tập nhóm tiếng Anh ngoại khóa', 2023, N'Nguyễn Văn O', 90, 135000),
    
    (N'Học từ vựng tiếng Anh qua hình ảnh', 2018, N'Lê Thị P', 70, 90000),
    (N'Phát âm tiếng Anh chuẩn bản ngữ', 2019, N'Trần Văn Q', 100, 120000),
    (N'Luyện nghe tiếng Anh cơ bản', 2020, N'Hoàng Văn R', 90, 110000),
    (N'Nâng cao kỹ năng viết tiếng Anh', 2022, N'Nguyễn Thị S', 80, 140000),
    (N'Giao tiếp tiếng Anh chuyên ngành IT', 2023, N'Lê Văn T', 60, 160000);


INSERT INTO PhuHuynh (MaHV, TenPH, NamSinh, GioiTinh, Email, SDT, QuanHe)
VALUES 
    (1, N'Nguyễn Văn A', 1980, 1, 'phuynh.a@example.com', '0987123456', N'Cha'),
    (2, N'Trần Thị B', 1985, 0, 'phuynh.b@example.com', '0987234567', N'Mẹ'),
    (3, N'Lê Văn C', 1982, 1, 'phuynh.c@example.com', '0987345678', N'Cha'),
    (4, N'Phạm Thị D', 1988, 0, 'phuynh.d@example.com', '0987456789', N'Mẹ'),
    (5, N'Nguyễn Văn E', 1983, 1, 'phuynh.e@example.com', '0987567890', N'Cha'),
    (6, N'Hoàng Thị F', 1987, 0, 'phuynh.f@example.com', '0987678901', N'Mẹ'),
    (7, N'Lê Văn G', 1981, 1, 'phuynh.g@example.com', '0987789012', N'Cha'),
    (8, N'Trần Thị H', 1986, 0, 'phuynh.h@example.com', '0987890123', N'Mẹ'),
    (9, N'Nguyễn Văn I', 1984, 1, 'phuynh.i@example.com', '0987901234', N'Cha'),
    (10, N'Phạm Thị J', 1989, 0, 'phuynh.j@example.com', '0988012345', N'Mẹ'),
    
    (11, N'Lê Văn K', 1981, 1, 'phuynh.k@example.com', '0988123456', N'Cha'),
    (12, N'Trần Thị L', 1984, 0, 'phuynh.l@example.com', '0988234567', N'Mẹ'),
    (13, N'Nguyễn Văn M', 1983, 1, 'phuynh.m@example.com', '0988345678', N'Cha'),
    (14, N'Phạm Thị N', 1986, 0, 'phuynh.n@example.com', '0988456789', N'Mẹ'),
    (15, N'Lê Văn O', 1982, 1, 'phuynh.o@example.com', '0988567890', N'Cha'),
    (16, N'Hoàng Thị P', 1988, 0, 'phuynh.p@example.com', '0988678901', N'Mẹ'),
    (17, N'Nguyễn Văn Q', 1980, 1, 'phuynh.q@example.com', '0988789012', N'Cha'),
    (18, N'Trần Thị R', 1985, 0, 'phuynh.r@example.com', '0988890123', N'Mẹ'),
    (19, N'Lê Văn S', 1987, 1, 'phuynh.s@example.com', '0988901234', N'Cha'),
    (20, N'Phạm Thị T', 1981, 0, 'phuynh.t@example.com', '0989012345', N'Mẹ'),
    
    (21, N'Nguyễn Văn U', 1984, 1, 'phuynh.u@example.com', '0989123456', N'Cha'),
    (22, N'Lê Thị V', 1982, 0, 'phuynh.v@example.com', '0989234567', N'Mẹ'),
    (23, N'Hoàng Văn W', 1983, 1, 'phuynh.w@example.com', '0989345678', N'Cha'),
    (24, N'Trần Thị X', 1986, 0, 'phuynh.x@example.com', '0989456789', N'Mẹ'),
    (25, N'Lê Văn Y', 1981, 1, 'phuynh.y@example.com', '0989567890', N'Cha'),
    (26, N'Nguyễn Thị Z', 1985, 0, 'phuynh.z@example.com', '0989678901', N'Mẹ'),
    (27, N'Lê Văn AA', 1983, 1, 'phuynh.aa@example.com', '0989789012', N'Cha'),
    (28, N'Trần Thị BB', 1982, 0, 'phuynh.bb@example.com', '0989890123', N'Mẹ'),
    (29, N'Nguyễn Văn CC', 1984, 1, 'phuynh.cc@example.com', '0989901234', N'Cha'),
    (30, N'Lê Thị DD', 1987, 0, 'phuynh.dd@example.com', '0990012345', N'Mẹ'),
	(31, N'Nguyễn Văn EE', 1980, 1, 'phuynh.ee@example.com', '0990123456', N'Cha'),
    (32, N'Lê Thị FF', 1983, 0, 'phuynh.ff@example.com', '0990234567', N'Mẹ'),
    (33, N'Trần Văn GG', 1982, 1, 'phuynh.gg@example.com', '0990345678', N'Cha'),
    (34, N'Hoàng Thị HH', 1985, 0, 'phuynh.hh@example.com', '0990456789', N'Mẹ'),
    (35, N'Lê Văn II', 1984, 1, 'phuynh.ii@example.com', '0990567890', N'Cha'),
    (36, N'Trần Thị JJ', 1987, 0, 'phuynh.jj@example.com', '0990678901', N'Mẹ'),
    (37, N'Nguyễn Văn KK', 1981, 1, 'phuynh.kk@example.com', '0990789012', N'Cha'),
    (38, N'Lê Thị LL', 1983, 0, 'phuynh.ll@example.com', '0990890123', N'Mẹ'),
    (39, N'Hoàng Văn MM', 1982, 1, 'phuynh.mm@example.com', '0990901234', N'Cha'),
    (40, N'Trần Thị NN', 1986, 0, 'phuynh.nn@example.com', '0991012345', N'Mẹ'),

    -- Mã học viên từ 41 đến 60 (Anh và Chị)
    (41, N'Nguyễn Văn OO', 1995, 1, 'phuynh.oo@example.com', '0991123456', N'Anh'),
    (42, N'Lê Thị PP', 1997, 0, 'phuynh.pp@example.com', '0991234567', N'Chị'),
    (43, N'Trần Văn QQ', 1993, 1, 'phuynh.qq@example.com', '0991345678', N'Anh'),
    (44, N'Hoàng Thị RR', 1994, 0, 'phuynh.rr@example.com', '0991456789', N'Chị'),
    (45, N'Lê Văn SS', 1996, 1, 'phuynh.ss@example.com', '0991567890', N'Anh'),
    (46, N'Trần Thị TT', 1998, 0, 'phuynh.tt@example.com', '0991678901', N'Chị'),
    (47, N'Nguyễn Văn UU', 1995, 1, 'phuynh.uu@example.com', '0991789012', N'Anh'),
    (48, N'Lê Thị VV', 1997, 0, 'phuynh.vv@example.com', '0991890123', N'Chị'),
    (49, N'Hoàng Văn WW', 1993, 1, 'phuynh.ww@example.com', '0991901234', N'Anh'),
    (50, N'Trần Thị XX', 1994, 0, 'phuynh.xx@example.com', '0992012345', N'Chị'),
    (51, N'Lê Văn YY', 1996, 1, 'phuynh.yy@example.com', '0992123456', N'Anh'),
    (52, N'Nguyễn Thị ZZ', 1998, 0, 'phuynh.zz@example.com', '0992234567', N'Chị'),
    (53, N'Trần Văn AAA', 1995, 1, 'phuynh.aaa@example.com', '0992345678', N'Anh'),
    (54, N'Hoàng Thị BBB', 1997, 0, 'phuynh.bbb@example.com', '0992456789', N'Chị'),
    (55, N'Lê Văn CCC', 1993, 1, 'phuynh.ccc@example.com', '0992567890', N'Anh'),
    (56, N'Trần Thị DDD', 1994, 0, 'phuynh.ddd@example.com', '0992678901', N'Chị'),
    (57, N'Nguyễn Văn EEE', 1996, 1, 'phuynh.eee@example.com', '0992789012', N'Anh'),
    (58, N'Lê Thị FFF', 1998, 0, 'phuynh.fff@example.com', '0992890123', N'Chị'),
    (59, N'Hoàng Văn GGG', 1995, 1, 'phuynh.ggg@example.com', '0992901234', N'Anh'),
    (60, N'Trần Thị HHH', 1997, 0, 'phuynh.hhh@example.com', '0993012345', N'Chị'),

    -- Mã học viên từ 61 đến 100 (Cha, Mẹ, Anh, Chị xen kẽ)
    (61, N'Nguyễn Văn III', 1980, 1, 'phuynh.iii@example.com', '0993123456', N'Cha'),
    (62, N'Lê Thị JJJ', 1995, 0, 'phuynh.jjj@example.com', '0993234567', N'Chị'),
    (63, N'Trần Văn KKK', 1994, 1, 'phuynh.kkk@example.com', '0993345678', N'Anh'),
    (64, N'Hoàng Thị LLL', 1983, 0, 'phuynh.lll@example.com', '0993456789', N'Mẹ'),
    (65, N'Lê Văn MMM', 1993, 1, 'phuynh.mmm@example.com', '0993567890', N'Anh'),
    (66, N'Trần Thị NNN', 1997, 0, 'phuynh.nnn@example.com', '0993678901', N'Chị'),
    (67, N'Nguyễn Văn OOO', 1982, 1, 'phuynh.ooo@example.com', '0993789012', N'Cha'),
    (68, N'Lê Thị PPP', 1995, 0, 'phuynh.ppp@example.com', '0993890123', N'Chị'),
    (69, N'Hoàng Văn QQQ', 1996, 1, 'phuynh.qqq@example.com', '0993901234', N'Anh'),
    (70, N'Trần Thị RRR', 1981, 0, 'phuynh.rrr@example.com', '0994012345', N'Mẹ'),
    (71, N'Lê Văn SSS', 1997, 1, 'phuynh.sss@example.com', '0994123456', N'Anh'),
    (72, N'Nguyễn Thị TTT', 1988, 0, 'phuynh.ttt@example.com', '0994234567', N'Mẹ'),
    (73, N'Trần Văn UUU', 1983, 1, 'phuynh.uuu@example.com', '0994345678', N'Cha'),
    (74, N'Hoàng Thị VVV', 1996, 0, 'phuynh.vvv@example.com', '0994456789', N'Chị'),
    (75, N'Lê Văn WWW', 1995, 1, 'phuynh.www@example.com', '0994567890', N'Anh'),
    (76, N'Trần Thị XXX', 1994, 0, 'phuynh.xxx@example.com', '0994678901', N'Chị'),
    (77, N'Nguyễn Văn YYY', 1989, 1, 'phuynh.yyy@example.com', '0994789012', N'Cha'),
    (78, N'Lê Thị ZZZ', 1997, 0, 'phuynh.zzz@example.com', '0994890123', N'Chị'),
    (79, N'Hoàng Văn AAAA', 1983, 1, 'phuynh.aaaa@example.com', '0994901234', N'Cha'),
    (80, N'Trần Thị BBBB', 1996, 0, 'phuynh.bbbb@example.com', '0995012345', N'Mẹ'),
	 (81, N'Lê Văn CCC', 1984, 1, 'phuynh.ccc@example.com', '0995123456', N'Cha'),
    (82, N'Trần Thị DDD', 1986, 0, 'phuynh.ddd@example.com', '0995234567', N'Mẹ'),
    (83, N'Nguyễn Văn EEE', 1993, 1, 'phuynh.eee@example.com', '0995345678', N'Anh'),
    (84, N'Lê Thị FFF', 1995, 0, 'phuynh.fff@example.com', '0995456789', N'Chị'),
    (85, N'Hoàng Văn GGG', 1982, 1, 'phuynh.ggg@example.com', '0995567890', N'Cha'),
    (86, N'Trần Thị HHH', 1987, 0, 'phuynh.hhh@example.com', '0995678901', N'Mẹ'),
    (87, N'Lê Văn III', 1994, 1, 'phuynh.iii@example.com', '0995789012', N'Anh'),
    (88, N'Nguyễn Thị JJJ', 1996, 0, 'phuynh.jjj@example.com', '0995890123', N'Chị'),
    (89, N'Trần Văn KKK', 1981, 1, 'phuynh.kkk@example.com', '0995901234', N'Cha'),
    (90, N'Hoàng Thị LLL', 1985, 0, 'phuynh.lll@example.com', '0996012345', N'Mẹ'),
    (91, N'Lê Văn MMM', 1993, 1, 'phuynh.mmm@example.com', '0996123456', N'Anh'),
    (92, N'Trần Thị NNN', 1995, 0, 'phuynh.nnn@example.com', '0996234567', N'Chị'),
    (93, N'Nguyễn Văn OOO', 1983, 1, 'phuynh.ooo@example.com', '0996345678', N'Cha'),
    (94, N'Lê Thị PPP', 1994, 0, 'phuynh.ppp@example.com', '0996456789', N'Mẹ'),
    (95, N'Trần Văn QQQ', 1997, 1, 'phuynh.qqq@example.com', '0996567890', N'Anh'),
    (96, N'Hoàng Thị RRR', 1995, 0, 'phuynh.rrr@example.com', '0996678901', N'Chị'),
    (97, N'Lê Văn SSS', 1989, 1, 'phuynh.sss@example.com', '0996789012', N'Cha'),
    (98, N'Trần Thị TTT', 1988, 0, 'phuynh.ttt@example.com', '0996890123', N'Mẹ'),
    (99, N'Nguyễn Văn UUU', 1996, 1, 'phuynh.uuu@example.com', '0996901234', N'Anh'),
    (100, N'Lê Thị VVV', 1997, 0, 'phuynh.vvv@example.com', '0997012345', N'Chị');
    
    
INSERT INTO NhanVien (Ten, GioiTinh, Email, SDT, NamSinh, MaCN, QuanLy, DiaChi, TrangThai)
VALUES
    -- Nhân viên thuộc Chi nhánh 1 (MaCN = 1)
    (N'Lê Văn A', 1, 'nv.a@example.com', '0901234561', 1985, 1, 1, N'TP.HCM', N'Đang làm việc'), -- Quản lý
    (N'Trần Thị B', 0, 'nv.b@example.com', '0901234562', 1990, 1, 0, N'TP.HCM', N'Đang làm việc'),
    (N'Nguyễn Văn C', 1, 'nv.c@example.com', '0901234563', 1992, 1, 0, N'TP.HCM', N'Đang làm việc'),
    (N'Hoàng Thị D', 0, 'nv.d@example.com', '0901234564', 1995, 1, 0, N'TP.HCM', N'Đang làm việc'),
    (N'Phạm Văn E', 1, 'nv.e@example.com', '0901234565', 1993, 1, 0, N'TP.HCM', N'Đang làm việc'),
    (N'Bùi Thị F', 0, 'nv.f@example.com', '0901234566', 1994, 1, 0, N'TP.HCM', N'Đang làm việc'),
    (N'Ngô Văn G', 1, 'nv.g@example.com', '0901234567', 1988, 1, 0, N'TP.HCM', N'Đang làm việc'),
    (N'Vũ Thị H', 0, 'nv.h@example.com', '0901234568', 1991, 1, 0, N'TP.HCM', N'Đang làm việc'),
    (N'Lý Văn I', 1, 'nv.i@example.com', '0901234569', 1996, 1, 0, N'TP.HCM', N'Đang làm việc'),
    (N'Trương Thị J', 0, 'nv.j@example.com', '0901234570', 1997, 1, 0, N'TP.HCM', N'Đang làm việc'),

    --nhan viên thuộc Chi nhánh 2 (MaCN = 2)
    (N'Phạm Văn K', 1, 'nv.k@example.com', '0902234561', 1987, 2, 1, N'TP.HCM', N'Đang làm việc'), -- Quản lý
    (N'Lê Thị L', 0, 'nv.l@example.com', '0902234562', 1990, 2, 0, N'TP.HCM', N'Đang làm việc'),
    (N'Trần Văn M', 1, 'nv.m@example.com', '0902234563', 1991, 2, 0, N'TP.HCM', N'Đang làm việc'),
    (N'Nguyễn Thị N', 0, 'nv.n@example.com', '0902234564', 1993, 2, 0, N'TP.HCM', N'Đang làm việc'),
    (N'Hoàng Văn O', 1, 'nv.o@example.com', '0902234565', 1994, 2, 0, N'TP.HCM', N'Đang làm việc'),
    (N'Phan Thị P', 0, 'nv.p@example.com', '0902234566', 1992, 2, 0, N'TP.HCM', N'Đang làm việc'),
    (N'Bùi Văn Q', 1, 'nv.q@example.com', '0902234567', 1989, 2, 0, N'TP.HCM', N'Đang làm việc'),
    (N'Vũ Thị R', 0, 'nv.r@example.com', '0902234568', 1991, 2, 0, N'TP.HCM', N'Đang làm việc'),
    (N'Ngô Văn S', 1, 'nv.s@example.com', '0902234569', 1996, 2, 0, N'TP.HCM', N'Đang làm việc'),
    (N'Trương Thị T', 0, 'nv.t@example.com', '0902234570', 1997, 2, 0, N'TP.HCM', N'Đang làm việc'),

    --nhan viên thuộc Chi nhánh 3 (MaCN = 3)
    (N'Nguyễn Văn U', 1, 'nv.u@example.com', '0903234561', 1986, 3, 1, N'TP.HCM', N'Đang làm việc'), -- Quản lý
    (N'Lê Thị V', 0, 'nv.v@example.com', '0903234562', 1990, 3, 0, N'TP.HCM', N'Đang làm việc'),
    (N'Trần Văn W', 1, 'nv.w@example.com', '0903234563', 1992, 3, 0, N'TP.HCM', N'Đang làm việc'),
    (N'Nguyễn Thị X', 0, 'nv.x@example.com', '0903234564', 1995, 3, 0, N'TP.HCM', N'Đang làm việc'),
    (N'Hoàng Văn Y', 1, 'nv.y@example.com', '0903234565', 1993, 3, 0, N'TP.HCM', N'Đang làm việc'),
    (N'Phan Thị Z', 0, 'nv.z@example.com', '0903234566', 1994, 3, 0, N'TP.HCM', N'Đang làm việc'),
    (N'Bùi Văn AA', 1, 'nv.aa@example.com', '0903234567', 1988, 3, 0, N'TP.HCM', N'Đang làm việc'),
    (N'Vũ Thị BB', 0, 'nv.bb@example.com', '0903234568', 1991, 3, 0, N'TP.HCM', N'Đang làm việc'),
    (N'Ngô Văn CC', 1, 'nv.cc@example.com', '0903234569', 1996, 3, 0, N'TP.HCM', N'Đang làm việc'),
    (N'Trương Thị DD', 0, 'nv.dd@example.com', '0903234570', 1997, 3, 0, N'TP.HCM', N'Đang làm việc');


INSERT INTO QuanLyNV (MaNV, NVCapDuoi)
VALUES
    -- Nhân viên 1 quản lý từ 2 đến 10
	(1, 1),
    (1, 2),
    (1, 3),
    (1, 4),
    (1, 5),
    (1, 6),
    (1, 7),
    (1, 8),
    (1, 9),
    (1, 10),

    -- Nhân viên 2 quản lý từ 11 đến 20
    (11, 11),
    (11, 12),
    (11, 13),
    (11, 14),
    (11, 15),
    (11, 16),
    (11, 17),
    (11, 18),
    (11, 19),
    (11, 20),

    -- Nhân viên 3 quản lý từ 21 đến 30
    (21, 21),
    (21, 22),
    (21, 23),
    (21, 24),
    (21, 25),
    (21, 26),
    (21, 27),
    (21, 28),
    (21, 29),
    (21, 30);


	
INSERT INTO GiamSatVien (MaNV)
VALUES
	(1),
	(2),
	(3),
	(11),
	(12),
	(13),
	(21),
	(22),
	(23);


INSERT INTO TroGiang(MaNV, KinhNghiem, TrinhDo)
VALUES
    -- Giảng viên từ MaNV 4 đến 10
    (7, 1, N'IELTS 7.5'),
    (8, 2, N'IELTS 7.5'),
    (9, 2, N'TOEIC 800'),
	(10, 1, N'TOEIC 800'),


    -- Giảng viên từ MaNV 14 đến 20
    (17, 1, N'IELTS 7.0'),
    (18, 1, N'IELTS 7.5'),
    (19, 2, N'TOEIC 850'),
	(20, 1, N'TOEIC 800'),

    -- Giảng viên từ MaNV 24 đến 30
    (27, 2, N'IELTS 7.5'),
    (28, 2, N'IELTS 7.5'),
    (29, 2, N'TOEIC 750'),
	(30, 1, N'TOEIC 800');

INSERT INTO GiangVien (MaNV, KinhNghiem, TrinhDo)
VALUES
    -- Giảng viên từ MaNV 4 đến 10
    (4, 5, N'IELTS 8.5'),
    (5, 5, N'IELTS 8.5'),
    (6, 7, N'TOEIC 950'),


    -- Giảng viên từ MaNV 14 đến 20
    (14, 8, N'TOEIC 990'),
    (15, 6, N'IELTS 8.5'),
    (16, 5, N'IELTS 8.5'),

    -- Giảng viên từ MaNV 24 đến 30
    (24, 6, N'IELTS 8.5'),
    (25, 6, N'IELTS 8.5'),
    (26, 6, N'IELTS 8.5');



INSERT INTO UuDai (NgayApDung, NgayKetThuc, PhanTramGiam, MaKhoaHoc, GiamTien)
VALUES
    ('2024-01-01', '2024-12-31', 10, 1, 200000),  -- Giảm 10% cho khóa học 1, giảm tiền 200,000
    ('2024-01-01', '2024-12-31', 15, 2, 150000),  -- Giảm 15% cho khóa học 2, giảm tiền 150,000
    ('2024-01-01', '2024-12-31', 20, 3, 300000),  -- Giảm 20% cho khóa học 3, giảm tiền 300,000
    ('2024-01-01', '2024-12-31', 5, 4, 100000);   -- Giảm 5% cho khóa học 4, giảm tiền 100,000


INSERT INTO LopHoc (NgayBatDau, NgayKetThuc, SiSo, MaKhoaHoc, MaCN, MaNV)
VALUES
	('2024-2-1','2024-5-1',20,1,1,1),
	('2024-2-1','2024-5-1',30,2,2,2),
	('2024-2-1','2024-3-1',20,3,3,3),
	('2024-2-1','2024-5-1',20,1,1,11),
	('2024-2-1','2024-3-1',20,3,2,12),
	('2024-2-1','2024-5-1',20,4,3,13),
	('2024-2-1','2024-5-1',20,1,1,21),
	('2024-2-1','2024-5-1',30,2,2,22),
	('2024-2-1','2024-5-1',20,4,3,23);

ALTER TABLE PhieuDangKy
ALTER COLUMN TongHoaDon DECIMAL(18, 2) NULL;

INSERT INTO PhieuDangKy (NgayDangKy, NgayThi, Diem, MaHV, MaUuDai, HocPhi, MaLH, TongHoaDon)
VALUES
-- Lớp 1: 12 học viên
('2024-1-1', '2024-5-1', NULL, 1, 1, (SELECT HocPhiGoc FROM KhoaHoc WHERE MaKhoaHoc = 1), 1, NULL),
('2024-1-1', '2024-5-1', NULL, 2, 1, (SELECT HocPhiGoc FROM KhoaHoc WHERE MaKhoaHoc = 1), 1, NULL),
('2024-1-1', '2024-5-1', NULL, 3, 1, (SELECT HocPhiGoc FROM KhoaHoc WHERE MaKhoaHoc = 1), 1, NULL),
('2024-1-1', '2024-5-1', NULL, 4, 1, (SELECT HocPhiGoc FROM KhoaHoc WHERE MaKhoaHoc = 1), 1, NULL),
('2024-1-1', '2024-5-1', NULL, 5, 1, (SELECT HocPhiGoc FROM KhoaHoc WHERE MaKhoaHoc = 1), 1, NULL),
('2024-1-1', '2024-5-1', NULL, 6, 1, (SELECT HocPhiGoc FROM KhoaHoc WHERE MaKhoaHoc = 1), 1, NULL),
('2024-1-1', '2024-5-1', NULL, 7, 1, (SELECT HocPhiGoc FROM KhoaHoc WHERE MaKhoaHoc = 1), 1, NULL),
('2024-1-1', '2024-5-1', NULL, 8, 1, (SELECT HocPhiGoc FROM KhoaHoc WHERE MaKhoaHoc = 1), 1, NULL),
('2024-1-1', '2024-5-1', NULL, 9, 1, (SELECT HocPhiGoc FROM KhoaHoc WHERE MaKhoaHoc = 1), 1, NULL),
('2024-1-1', '2024-5-1', NULL, 10, 1, (SELECT HocPhiGoc FROM KhoaHoc WHERE MaKhoaHoc = 1), 1, NULL),
('2024-1-1', '2024-5-1', NULL, 11, 1, (SELECT HocPhiGoc FROM KhoaHoc WHERE MaKhoaHoc = 1), 1, NULL),
('2024-1-1', '2024-5-1', NULL, 12, 1, (SELECT HocPhiGoc FROM KhoaHoc WHERE MaKhoaHoc = 1), 1, NULL),

-- Lớp 2: 11 học viên
('2024-1-1', '2024-5-1', NULL, 13, 2, (SELECT HocPhiGoc FROM KhoaHoc WHERE MaKhoaHoc = 2), 2, NULL),
('2024-1-1', '2024-5-1', NULL, 14, 2, (SELECT HocPhiGoc FROM KhoaHoc WHERE MaKhoaHoc = 2), 2, NULL),
('2024-1-1', '2024-5-1', NULL, 15, 2, (SELECT HocPhiGoc FROM KhoaHoc WHERE MaKhoaHoc = 2), 2, NULL),
('2024-1-1', '2024-5-1', NULL, 16, 2, (SELECT HocPhiGoc FROM KhoaHoc WHERE MaKhoaHoc = 2), 2, NULL),
('2024-1-1', '2024-5-1', NULL, 17, 2, (SELECT HocPhiGoc FROM KhoaHoc WHERE MaKhoaHoc = 2), 2, NULL),
('2024-1-1', '2024-5-1', NULL, 18, 2, (SELECT HocPhiGoc FROM KhoaHoc WHERE MaKhoaHoc = 2), 2, NULL),
('2024-1-1', '2024-5-1', NULL, 19, 2, (SELECT HocPhiGoc FROM KhoaHoc WHERE MaKhoaHoc = 2), 2, NULL),
('2024-1-1', '2024-5-1', NULL, 20, 2, (SELECT HocPhiGoc FROM KhoaHoc WHERE MaKhoaHoc = 2), 2, NULL),
('2024-1-1', '2024-5-1', NULL, 21, 2, (SELECT HocPhiGoc FROM KhoaHoc WHERE MaKhoaHoc = 2), 2, NULL),
('2024-1-1', '2024-5-1', NULL, 22, 2, (SELECT HocPhiGoc FROM KhoaHoc WHERE MaKhoaHoc = 2), 2, NULL),
('2024-1-1', '2024-5-1', NULL, 23, 2, (SELECT HocPhiGoc FROM KhoaHoc WHERE MaKhoaHoc = 2), 2, NULL),

-- Lớp 3: 11 học viên
('2024-1-1', '2024-5-1', NULL, 24, 3, (SELECT HocPhiGoc FROM KhoaHoc WHERE MaKhoaHoc = 3), 3, NULL),
('2024-1-1', '2024-5-1', NULL, 25, 3, (SELECT HocPhiGoc FROM KhoaHoc WHERE MaKhoaHoc = 3), 3, NULL),
('2024-1-1', '2024-5-1', NULL, 26, 3, (SELECT HocPhiGoc FROM KhoaHoc WHERE MaKhoaHoc = 3), 3, NULL),
('2024-1-1', '2024-5-1', NULL, 27, 3, (SELECT HocPhiGoc FROM KhoaHoc WHERE MaKhoaHoc = 3), 3, NULL),
('2024-1-1', '2024-5-1', NULL, 28, 3, (SELECT HocPhiGoc FROM KhoaHoc WHERE MaKhoaHoc = 3), 3, NULL),
('2024-1-1', '2024-5-1', NULL, 29, 3, (SELECT HocPhiGoc FROM KhoaHoc WHERE MaKhoaHoc = 3), 3, NULL),
('2024-1-1', '2024-5-1', NULL, 30, 3, (SELECT HocPhiGoc FROM KhoaHoc WHERE MaKhoaHoc = 3), 3, NULL),
('2024-1-1', '2024-5-1', NULL, 31, 3, (SELECT HocPhiGoc FROM KhoaHoc WHERE MaKhoaHoc = 3), 3, NULL),
('2024-1-1', '2024-5-1', NULL, 32, 3, (SELECT HocPhiGoc FROM KhoaHoc WHERE MaKhoaHoc = 3), 3, NULL),
('2024-1-1', '2024-5-1', NULL, 33, 3, (SELECT HocPhiGoc FROM KhoaHoc WHERE MaKhoaHoc = 3), 3, NULL),
('2024-1-1', '2024-5-1', NULL, 34, 3, (SELECT HocPhiGoc FROM KhoaHoc WHERE MaKhoaHoc = 3), 3, NULL),

-- Lớp 4: 11 học viên
('2024-1-1', '2024-5-1', NULL, 35, 1, (SELECT HocPhiGoc FROM KhoaHoc WHERE MaKhoaHoc = 1), 4, NULL),
('2024-1-1', '2024-5-1', NULL, 36, 1, (SELECT HocPhiGoc FROM KhoaHoc WHERE MaKhoaHoc = 1), 4, NULL),
('2024-1-1', '2024-5-1', NULL, 37, 1, (SELECT HocPhiGoc FROM KhoaHoc WHERE MaKhoaHoc = 1), 4, NULL),
('2024-1-1', '2024-5-1', NULL, 38, 1, (SELECT HocPhiGoc FROM KhoaHoc WHERE MaKhoaHoc = 1), 4, NULL),
('2024-1-1', '2024-5-1', NULL, 39, 1, (SELECT HocPhiGoc FROM KhoaHoc WHERE MaKhoaHoc = 1), 4, NULL),
('2024-1-1', '2024-5-1', NULL, 40, 1, (SELECT HocPhiGoc FROM KhoaHoc WHERE MaKhoaHoc = 1), 4, NULL),
('2024-1-1', '2024-5-1', NULL, 41, 1, (SELECT HocPhiGoc FROM KhoaHoc WHERE MaKhoaHoc = 1), 4, NULL),
('2024-1-1', '2024-5-1', NULL, 42, 1, (SELECT HocPhiGoc FROM KhoaHoc WHERE MaKhoaHoc = 1), 4, NULL),
('2024-1-1', '2024-5-1', NULL, 43, 1, (SELECT HocPhiGoc FROM KhoaHoc WHERE MaKhoaHoc = 1), 4, NULL),
('2024-1-1', '2024-5-1', NULL, 44, 1, (SELECT HocPhiGoc FROM KhoaHoc WHERE MaKhoaHoc = 1), 4, NULL),
('2024-1-1', '2024-5-1', NULL, 45, 1, (SELECT HocPhiGoc FROM KhoaHoc WHERE MaKhoaHoc = 1), 4, NULL),

-- Lớp 5: 11 học viên
('2024-1-1', '2024-5-1', NULL, 46, 3, (SELECT HocPhiGoc FROM KhoaHoc WHERE MaKhoaHoc = 3), 5, NULL),
('2024-1-1', '2024-5-1', NULL, 47, 3, (SELECT HocPhiGoc FROM KhoaHoc WHERE MaKhoaHoc = 3), 5, NULL),
('2024-1-1', '2024-5-1', NULL, 48, 3, (SELECT HocPhiGoc FROM KhoaHoc WHERE MaKhoaHoc = 3), 5, NULL),
('2024-1-1', '2024-5-1', NULL, 49, 3, (SELECT HocPhiGoc FROM KhoaHoc WHERE MaKhoaHoc = 3), 5, NULL),
('2024-1-1', '2024-5-1', NULL, 50, 3, (SELECT HocPhiGoc FROM KhoaHoc WHERE MaKhoaHoc = 3), 5, NULL),
('2024-1-1', '2024-5-1', NULL, 51, 3, (SELECT HocPhiGoc FROM KhoaHoc WHERE MaKhoaHoc = 3), 5, NULL),
('2024-1-1', '2024-5-1', NULL, 52, 3, (SELECT HocPhiGoc FROM KhoaHoc WHERE MaKhoaHoc = 3), 5, NULL),
('2024-1-1', '2024-5-1', NULL, 53, 3, (SELECT HocPhiGoc FROM KhoaHoc WHERE MaKhoaHoc = 3), 5, NULL),
('2024-1-1', '2024-5-1', NULL, 54, 3, (SELECT HocPhiGoc FROM KhoaHoc WHERE MaKhoaHoc = 3), 5, NULL),
('2024-1-1', '2024-5-1', NULL, 55, 3, (SELECT HocPhiGoc FROM KhoaHoc WHERE MaKhoaHoc = 3), 5, NULL),
('2024-1-1', '2024-5-1', NULL, 56, 3, (SELECT HocPhiGoc FROM KhoaHoc WHERE MaKhoaHoc = 3), 5, NULL),

-- Lớp 6: 11 học viên
('2024-1-1', '2024-5-1', NULL, 57, 4, (SELECT HocPhiGoc FROM KhoaHoc WHERE MaKhoaHoc = 4), 6, NULL),
('2024-1-1', '2024-5-1', NULL, 58, 4, (SELECT HocPhiGoc FROM KhoaHoc WHERE MaKhoaHoc = 4), 6, NULL),
('2024-1-1', '2024-5-1', NULL, 59, 4, (SELECT HocPhiGoc FROM KhoaHoc WHERE MaKhoaHoc = 4), 6, NULL),
('2024-1-1', '2024-5-1', NULL, 60, 4, (SELECT HocPhiGoc FROM KhoaHoc WHERE MaKhoaHoc = 4), 6, NULL),
('2024-1-1', '2024-5-1', NULL, 61, 4, (SELECT HocPhiGoc FROM KhoaHoc WHERE MaKhoaHoc = 4), 6, NULL),
('2024-1-1', '2024-5-1', NULL, 62, 4, (SELECT HocPhiGoc FROM KhoaHoc WHERE MaKhoaHoc = 4), 6, NULL),
('2024-1-1', '2024-5-1', NULL, 63, 4, (SELECT HocPhiGoc FROM KhoaHoc WHERE MaKhoaHoc = 4), 6, NULL),
('2024-1-1', '2024-5-1', NULL, 64, 4, (SELECT HocPhiGoc FROM KhoaHoc WHERE MaKhoaHoc = 4), 6, NULL),
('2024-1-1', '2024-5-1', NULL, 65, 4, (SELECT HocPhiGoc FROM KhoaHoc WHERE MaKhoaHoc = 4), 6, NULL),
('2024-1-1', '2024-5-1', NULL, 66, 4, (SELECT HocPhiGoc FROM KhoaHoc WHERE MaKhoaHoc = 4), 6, NULL),
('2024-1-1', '2024-5-1', NULL, 67, 4, (SELECT HocPhiGoc FROM KhoaHoc WHERE MaKhoaHoc = 4), 6, NULL),

-- Lớp 7: 11 học viên
('2024-1-1', '2024-5-1', NULL, 68, 1, (SELECT HocPhiGoc FROM KhoaHoc WHERE MaKhoaHoc = 1), 7, NULL),
('2024-1-1', '2024-5-1', NULL, 69, 1, (SELECT HocPhiGoc FROM KhoaHoc WHERE MaKhoaHoc = 1), 7, NULL),
('2024-1-1', '2024-5-1', NULL, 70, 1, (SELECT HocPhiGoc FROM KhoaHoc WHERE MaKhoaHoc = 1), 7, NULL),
('2024-1-1', '2024-5-1', NULL, 71, 1, (SELECT HocPhiGoc FROM KhoaHoc WHERE MaKhoaHoc = 1), 7, NULL),
('2024-1-1', '2024-5-1', NULL, 72, 1, (SELECT HocPhiGoc FROM KhoaHoc WHERE MaKhoaHoc = 1), 7, NULL),
('2024-1-1', '2024-5-1', NULL, 73, 1, (SELECT HocPhiGoc FROM KhoaHoc WHERE MaKhoaHoc = 1), 7, NULL),
('2024-1-1', '2024-5-1', NULL, 74, 1, (SELECT HocPhiGoc FROM KhoaHoc WHERE MaKhoaHoc = 1), 7, NULL),
('2024-1-1', '2024-5-1', NULL, 75, 1, (SELECT HocPhiGoc FROM KhoaHoc WHERE MaKhoaHoc = 1), 7, NULL),
('2024-1-1', '2024-5-1', NULL, 76, 1, (SELECT HocPhiGoc FROM KhoaHoc WHERE MaKhoaHoc = 1), 7, NULL),
('2024-1-1', '2024-5-1', NULL, 77, 1, (SELECT HocPhiGoc FROM KhoaHoc WHERE MaKhoaHoc = 1), 7, NULL),
('2024-1-1', '2024-5-1', NULL, 78, 1, (SELECT HocPhiGoc FROM KhoaHoc WHERE MaKhoaHoc = 1), 7, NULL),

-- Lớp 8: 11 học viên
('2024-1-1', '2024-5-1', NULL, 79, 2, (SELECT HocPhiGoc FROM KhoaHoc WHERE MaKhoaHoc = 2), 8, NULL),
('2024-1-1', '2024-5-1', NULL, 80, 2, (SELECT HocPhiGoc FROM KhoaHoc WHERE MaKhoaHoc = 2), 8, NULL),
('2024-1-1', '2024-5-1', NULL, 81, 2, (SELECT HocPhiGoc FROM KhoaHoc WHERE MaKhoaHoc = 2), 8, NULL),
('2024-1-1', '2024-5-1', NULL, 82, 2, (SELECT HocPhiGoc FROM KhoaHoc WHERE MaKhoaHoc = 2), 8, NULL),
('2024-1-1', '2024-5-1', NULL, 83, 2, (SELECT HocPhiGoc FROM KhoaHoc WHERE MaKhoaHoc = 2), 8, NULL),
('2024-1-1', '2024-5-1', NULL, 84, 2, (SELECT HocPhiGoc FROM KhoaHoc WHERE MaKhoaHoc = 2), 8, NULL),
('2024-1-1', '2024-5-1', NULL, 85, 2, (SELECT HocPhiGoc FROM KhoaHoc WHERE MaKhoaHoc = 2), 8, NULL),
('2024-1-1', '2024-5-1', NULL, 86, 2, (SELECT HocPhiGoc FROM KhoaHoc WHERE MaKhoaHoc = 2), 8, NULL),
('2024-1-1', '2024-5-1', NULL, 87, 2, (SELECT HocPhiGoc FROM KhoaHoc WHERE MaKhoaHoc = 2), 8, NULL),
('2024-1-1', '2024-5-1', NULL, 88, 2, (SELECT HocPhiGoc FROM KhoaHoc WHERE MaKhoaHoc = 2), 8, NULL),
('2024-1-1', '2024-5-1', NULL, 89, 2, (SELECT HocPhiGoc FROM KhoaHoc WHERE MaKhoaHoc = 2), 8, NULL),

-- Lớp 9: 11 học viên
('2024-1-1', '2024-5-1', NULL, 90, 4, (SELECT HocPhiGoc FROM KhoaHoc WHERE MaKhoaHoc = 4), 9, NULL),
('2024-1-1', '2024-5-1', NULL, 91, 4, (SELECT HocPhiGoc FROM KhoaHoc WHERE MaKhoaHoc = 4), 9, NULL),
('2024-1-1', '2024-5-1', NULL, 92, 4, (SELECT HocPhiGoc FROM KhoaHoc WHERE MaKhoaHoc = 4), 9, NULL),
('2024-1-1', '2024-5-1', NULL, 93, 4, (SELECT HocPhiGoc FROM KhoaHoc WHERE MaKhoaHoc = 4), 9, NULL),
('2024-1-1', '2024-5-1', NULL, 94, 4, (SELECT HocPhiGoc FROM KhoaHoc WHERE MaKhoaHoc = 4), 9, NULL),
('2024-1-1', '2024-5-1', NULL, 95, 4, (SELECT HocPhiGoc FROM KhoaHoc WHERE MaKhoaHoc = 4), 9, NULL),
('2024-1-1', '2024-5-1', NULL, 96, 4, (SELECT HocPhiGoc FROM KhoaHoc WHERE MaKhoaHoc = 4), 9, NULL),
('2024-1-1', '2024-5-1', NULL, 97, 4, (SELECT HocPhiGoc FROM KhoaHoc WHERE MaKhoaHoc = 4), 9, NULL),
('2024-1-1', '2024-5-1', NULL, 98, 4, (SELECT HocPhiGoc FROM KhoaHoc WHERE MaKhoaHoc = 4), 9, NULL),
('2024-1-1', '2024-5-1', NULL, 99, 4, (SELECT HocPhiGoc FROM KhoaHoc WHERE MaKhoaHoc = 4), 9, NULL),
('2024-1-1', '2024-5-1', NULL, 100, 4, (SELECT HocPhiGoc FROM KhoaHoc WHERE MaKhoaHoc = 4), 9, NULL);


INSERT INTO DanhGia (MaKH, MaHV, SoSao, DanhGia)
VALUES
    -- KhoaHoc 1
    (1, 1, 5, N'Rất tốt'),
    (1, 2, 4, N'Tốt'),
    (1, 3, 3, N'Bình thường'),
    (1, 4, 5, N'Rất tốt'),
    (1, 5, 2, N'Không hài lòng'),
    (1, 6, 4, N'Tốt'),
    (1, 7, 3, N'Bình thường'),
    (1, 8, 5, N'Rất tốt'),
    (1, 9, 1, N'Không hài lòng'),
    (1, 10, 4, N'Tốt'),
    
    -- KhoaHoc 2
    (2, 11, 5, N'Rất tốt'),
    (2, 12, 4, N'Tốt'),
    (2, 13, 3, N'Bình thường'),
    (2, 14, 2, N'Không hài lòng'),
    (2, 15, 5, N'Rất tốt'),
    (2, 16, 4, N'Tốt'),
    (2, 17, 3, N'Bình thường'),
    (2, 18, 5, N'Rất tốt'),
    (2, 19, 1, N'Không hài lòng'),
    (2, 20, 4, N'Tốt'),

    -- KhoaHoc 3
    (3, 21, 5, N'Rất tốt'),
    (3, 22, 4, N'Tốt'),
    (3, 23, 3, N'Bình thường'),
    (3, 24, 2, N'Không hài lòng'),
    (3, 25, 5, N'Rất tốt'),
    (3, 26, 4, N'Tốt'),
    (3, 27, 3, N'Bình thường'),
    (3, 28, 5, N'Rất tốt'),
    (3, 29, 1, N'Không hài lòng'),
    (3, 30, 4, N'Tốt'),

    -- KhoaHoc 4
    (4, 31, 5, N'Rất tốt'),
    (4, 32, 4, N'Tốt'),
    (4, 33, 3, N'Bình thường'),
    (4, 34, 2, N'Không hài lòng'),
    (4, 35, 5, N'Rất tốt'),
    (4, 36, 4, N'Tốt'),
    (4, 37, 3, N'Bình thường'),
    (4, 38, 5, N'Rất tốt'),
    (4, 39, 1, N'Không hài lòng'),
    (4, 40, 4, N'Tốt'),
    
 		-- KhoaHoc 1
    (1, 41, 4, N'Tốt'),
    (1, 42, 5, N'Rất tốt'),
    (1, 43, 3, N'Bình thường'),
    (1, 44, 2, N'Không hài lòng'),
    (1, 45, 4, N'Tốt'),
    (1, 46, 5, N'Rất tốt'),
    (1, 47, 3, N'Bình thường'),
    (1, 48, 1, N'Không hài lòng'),
    (1, 49, 4, N'Tốt'),
    (1, 50, 5, N'Rất tốt'),

    -- KhoaHoc 2
    (2, 51, 3, N'Bình thường'),
    (2, 52, 4, N'Tốt'),
    (2, 53, 5, N'Rất tốt'),
    (2, 54, 2, N'Không hài lòng'),
    (2, 55, 4, N'Tốt'),
    (2, 56, 5, N'Rất tốt'),
    (2, 57, 3, N'Bình thường'),
    (2, 58, 1, N'Không hài lòng'),
    (2, 59, 5, N'Rất tốt'),
    (2, 60, 4, N'Tốt'),

    -- KhoaHoc 3
    (3, 61, 4, N'Tốt'),
    (3, 62, 3, N'Bình thường'),
    (3, 63, 2, N'Không hài lòng'),
    (3, 64, 5, N'Rất tốt'),
    (3, 65, 4, N'Tốt'),
    (3, 66, 3, N'Bình thường'),
    (3, 67, 5, N'Rất tốt'),
    (3, 68, 1, N'Không hài lòng'),
    (3, 69, 4, N'Tốt'),
    (3, 70, 5, N'Rất tốt'),

    -- KhoaHoc 4
    (4, 71, 5, N'Rất tốt'),
    (4, 72, 4, N'Tốt'),
    (4, 73, 3, N'Bình thường'),
    (4, 74, 1, N'Không hài lòng'),
    (4, 75, 5, N'Rất tốt'),
    (4, 76, 4, N'Tốt'),
    (4, 77, 3, N'Bình thường'),
    (4, 78, 5, N'Rất tốt'),
    (4, 79, 4, N'Tốt'),
    (4, 80, 2, N'Không hài lòng'),

    -- KhoaHoc 1 
    (1, 81, 5, N'Rất tốt'),
    (1, 82, 4, N'Tốt'),
    (1, 83, 3, N'Bình thường'),
    (1, 84, 2, N'Không hài lòng'),
    (1, 85, 4, N'Tốt'),
    (1, 86, 5, N'Rất tốt'),
    (1, 87, 3, N'Bình thường'),
    (1, 88, 1, N'Không hài lòng'),
    (1, 89, 5, N'Rất tốt'),
    (1, 90, 4, N'Tốt'),

    -- KhoaHoc 2 
    (2, 91, 3, N'Bình thường'),
    (2, 92, 4, N'Tốt'),
    (2, 93, 5, N'Rất tốt'),
    (2, 94, 2, N'Không hài lòng'),
    (2, 95, 4, N'Tốt'),
    (2, 96, 5, N'Rất tốt'),
    (2, 97, 3, N'Bình thường'),
    (2, 98, 1, N'Không hài lòng'),
    (2, 99, 4, N'Tốt'),
    (2, 100, 5, N'Rất tốt');
    
    
    
-- Chèn dữ liệu vào bảng MuaGT
INSERT INTO MuaGT (MaGT, MaDK, SoLuongMua, TongGia)
VALUES
    (1, 1, 1, (SELECT Gia FROM GiaoTrinh WHERE MaGT = 1)),  -- Giáo trình MaGT = 1, MaDK = 1
    (2, 2, 1, (SELECT Gia FROM GiaoTrinh WHERE MaGT = 2)),  -- Giáo trình MaGT = 2, MaDK = 2
    (3, 3, 1, (SELECT Gia FROM GiaoTrinh WHERE MaGT = 3)),  -- Giáo trình MaGT = 3, MaDK = 3
    (4, 4, 1, (SELECT Gia FROM GiaoTrinh WHERE MaGT = 4)),  -- Giáo trình MaGT = 4, MaDK = 4
    (5, 5, 1, (SELECT Gia FROM GiaoTrinh WHERE MaGT = 5)),  -- Giáo trình MaGT = 5, MaDK = 5

    (6, 6, 1, (SELECT Gia FROM GiaoTrinh WHERE MaGT = 6)),  -- Giáo trình MaGT = 6, MaDK = 6
    (7, 7, 1, (SELECT Gia FROM GiaoTrinh WHERE MaGT = 7)),  -- Giáo trình MaGT = 7, MaDK = 7
    (8, 8, 1, (SELECT Gia FROM GiaoTrinh WHERE MaGT = 8)),  -- Giáo trình MaGT = 8, MaDK = 8
    (9, 9, 1, (SELECT Gia FROM GiaoTrinh WHERE MaGT = 9)),  -- Giáo trình MaGT = 9, MaDK = 9
    (10, 10, 1, (SELECT Gia FROM GiaoTrinh WHERE MaGT = 10)), -- Giáo trình MaGT = 10, MaDK = 10

    (11, 11, 1, (SELECT Gia FROM GiaoTrinh WHERE MaGT = 11)), -- Giáo trình MaGT = 11, MaDK = 11
    (12, 12, 1, (SELECT Gia FROM GiaoTrinh WHERE MaGT = 12)), -- Giáo trình MaGT = 12, MaDK = 12
    (13, 13, 1, (SELECT Gia FROM GiaoTrinh WHERE MaGT = 13)), -- Giáo trình MaGT = 13, MaDK = 13
    (14, 14, 1, (SELECT Gia FROM GiaoTrinh WHERE MaGT = 14)), -- Giáo trình MaGT = 14, MaDK = 14
    (15, 15, 1, (SELECT Gia FROM GiaoTrinh WHERE MaGT = 15)), -- Giáo trình MaGT = 15, MaDK = 15

    (16, 16, 1, (SELECT Gia FROM GiaoTrinh WHERE MaGT = 16)), -- Giáo trình MaGT = 16, MaDK = 16
    (17, 17, 1, (SELECT Gia FROM GiaoTrinh WHERE MaGT = 17)), -- Giáo trình MaGT = 17, MaDK = 17
    (18, 18, 1, (SELECT Gia FROM GiaoTrinh WHERE MaGT = 18)), -- Giáo trình MaGT = 18, MaDK = 18
    (19, 19, 1, (SELECT Gia FROM GiaoTrinh WHERE MaGT = 19)), -- Giáo trình MaGT = 19, MaDK = 19
    (20, 20, 1, (SELECT Gia FROM GiaoTrinh WHERE MaGT = 20)); -- Giáo trình MaGT = 20, MaDK = 20


-- Xóa dữ liệu cũ trong bảng BuoiHoc
DELETE FROM BuoiHoc;

-- Đặt lại IDENTITY của MaBH về 1
DBCC CHECKIDENT ('BuoiHoc', RESEED, 0);

-- Chèn dữ liệu mới
WITH BuoiHocData AS (
    SELECT 
        MaLH,
        DATEADD(MINUTE, 480, DATEADD(DAY, (ROW_NUMBER() OVER (PARTITION BY MaLH ORDER BY MaLH) - 1) * 3, '2024-02-01')) AS ThoiGian,
        (ROW_NUMBER() OVER (PARTITION BY MaLH ORDER BY MaLH) % 10) + 1 AS HocSinhVang,
        -- Gán MaGiangVien theo MaLH
        CASE 
            WHEN MaLH = 1 THEN 4
            WHEN MaLH = 4 THEN 5
            WHEN MaLH = 7 THEN 6
        END AS MaGiangVien,
        -- Phân bổ MaTroGiang xen kẽ giữa 7, 8, 9, 10
        CASE 
            WHEN (ROW_NUMBER() OVER (PARTITION BY MaLH ORDER BY MaLH) % 4) = 1 THEN 7
            WHEN (ROW_NUMBER() OVER (PARTITION BY MaLH ORDER BY MaLH) % 4) = 2 THEN 8
            WHEN (ROW_NUMBER() OVER (PARTITION BY MaLH ORDER BY MaLH) % 4) = 3 THEN 9
            ELSE 10
        END AS MaTroGiang
    FROM 
        (VALUES (1), (4), (7)) AS Classes(MaLH) -- Chỉ lấy MaLH = 1, 4, 7
    CROSS APPLY (SELECT TOP 30 ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) AS RowNum FROM master.dbo.spt_values) AS Rows
)
INSERT INTO BuoiHoc (MaLH, ThoiGian, HocSinhVang, MaGiangVien, MaTroGiang)
SELECT MaLH, ThoiGian, HocSinhVang, MaGiangVien, MaTroGiang
FROM BuoiHocData;

DECLARE @MaDK INT = 1;
DECLARE @Diem INT;

WHILE @MaDK <= 100
BEGIN
    -- Sinh điểm ngẫu nhiên từ 3 đến 10
    SET @Diem = FLOOR(3 + (RAND() * 8));

    -- Cập nhật điểm cho học viên tương ứng với MaDK
    UPDATE PhieuDangKy
    SET Diem = @Diem
    WHERE MaDK = @MaDK;

    -- Tăng MaDK lên 1 để tiếp tục vòng lặp
    SET @MaDK = @MaDK + 1;
END

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

CREATE OR ALTER PROCEDURE ThongKeDoanhSoGiaoTrinhVaKhoaHoc @MaKH INT
AS
BEGIN
    -- Truy vấn tổng số bán và tổng tiền gốc của giáo trình thuộc phiếu đăng ký
    SELECT 
		mgt.MaGT,
        gt.Ten AS TenGiaoTrinh,
		SUM(mgt.SoLuongMua) AS TongSoLuong,
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