CREATE DATABASE QL_BHXH;
GO
USE QL_BHXH;
GO

-----------------------------------------------------------
-- 2. TẠO CẤU TRÚC CÁC BẢNG
-----------------------------------------------------------

CREATE TABLE ChucVu (
    MaCV VARCHAR(10) PRIMARY KEY,
    TenCV NVARCHAR(100) NOT NULL,
    LuongCoBan DECIMAL(18, 2) NOT NULL
);

CREATE TABLE DoanhNghiep (
    MaDN VARCHAR(10) PRIMARY KEY,
    TenDN NVARCHAR(255) NOT NULL,
    DiaChi NVARCHAR(255) NOT NULL,
    SDT VARCHAR(20) NOT NULL
);

CREATE TABLE NhanVien (
    MaNV VARCHAR(10) PRIMARY KEY,
    TenNV NVARCHAR(100) NOT NULL,
    NgaySinh DATE NOT NULL,
    GioiTinh NVARCHAR(10) NOT NULL,
    CCCD VARCHAR(20) UNIQUE NOT NULL,
    DiaChi NVARCHAR(255) NOT NULL,
    SDT VARCHAR(20) NOT NULL,
    MaCV VARCHAR(10) NOT NULL,
    MaDN VARCHAR(10) NOT NULL,
    FOREIGN KEY (MaCV) REFERENCES ChucVu(MaCV),
    FOREIGN KEY (MaDN) REFERENCES DoanhNghiep(MaDN)
);

CREATE TABLE HopDong (
    MaHD VARCHAR(10) PRIMARY KEY,
    NgayBatDau DATE NOT NULL,
    NgayKetThuc DATE NOT NULL,
    MaNV VARCHAR(10) NOT NULL,
    FOREIGN KEY (MaNV) REFERENCES NhanVien(MaNV)
);

CREATE TABLE SoBHXH (
    MaSo VARCHAR(10) PRIMARY KEY,
    NgayCap DATE NOT NULL,
    NoiCap NVARCHAR(100) NOT NULL,
    TrangThai NVARCHAR(50) NOT NULL,
    MaNV VARCHAR(10) NOT NULL,
    FOREIGN KEY (MaNV) REFERENCES NhanVien(MaNV)
);

CREATE TABLE HoaDon (
    MaHoaDon VARCHAR(20) PRIMARY KEY,
    Thang INT NOT NULL,
    Nam INT NOT NULL,
    TongTien DECIMAL(18, 2) NOT NULL,
    MaDN VARCHAR(10) NOT NULL,
    FOREIGN KEY (MaDN) REFERENCES DoanhNghiep(MaDN)
);

CREATE TABLE QuaTrinhDongBHXH (
    MaQT VARCHAR(20) PRIMARY KEY,
    Thang INT NOT NULL,
    Nam INT NOT NULL,
    MucDongTran DECIMAL(18, 2) DEFAULT 46800000,
    MucLuongDong DECIMAL(18, 2) NOT NULL, 
    SoTienDong AS (CASE 
                        WHEN (MucLuongDong * 0.32) >= 46800000 THEN 46800000 
                        ELSE (MucLuongDong * 0.32) 
                   END), 
    TrangThaiDong NVARCHAR(50),
    MaSo VARCHAR(10),
    MaHD VARCHAR(10),
    FOREIGN KEY (MaSo) REFERENCES SoBHXH(MaSo),
    FOREIGN KEY (MaHD) REFERENCES HopDong(MaHD)
);

CREATE TABLE LuongNhanVien (
    MaLuong VARCHAR(20) PRIMARY KEY,
    Thang INT NOT NULL,
    Nam INT NOT NULL,
    TongLuong DECIMAL(18, 2) NOT NULL,
    Thuong DECIMAL(18, 2) NOT NULL,
    MaNV VARCHAR(10) NOT NULL,
    FOREIGN KEY (MaNV) REFERENCES NhanVien(MaNV)
);
CREATE TABLE CheDoHuong (
    MaCheDo VARCHAR(10) PRIMARY KEY, -- 
    TenCheDo NVARCHAR(100) NOT NULL,
    MoTa NVARCHAR(255) -- 
);

CREATE TABLE HuongCheDo (
    MaHuong VARCHAR(10) PRIMARY KEY,
    MaNV VARCHAR(10) NOT NULL,
    MaCheDo VARCHAR(10) NOT NULL,
    NgayBatDau DATE NOT NULL, -- [cite: 412]
    NgayKetThuc DATE NOT NULL, -- [cite: 412]
    SoTienHuong DECIMAL(18, 2) NOT NULL, -- [cite: 412]
    FOREIGN KEY (MaNV) REFERENCES NhanVien(MaNV),
    FOREIGN KEY (MaCheDo) REFERENCES CheDoHuong(MaCheDo)
);

INSERT INTO ChucVu (MaCV, TenCV, LuongCoBan) VALUES
('CV01', N'Giám đốc', 50000000),
('CV02', N'Phó Giám đốc', 35000000),
('CV03', N'Quản lý', 20000000),
('CV04', N'Kế toán', 15000000),
('CV05', N'Nhân viên', 10000000);
SELECT * FROM ChucVu;

INSERT INTO DoanhNghiep (MaDN, TenDN, DiaChi, SDT) VALUES
('DN01', N'Công ty Công nghệ Việt', N'Quận 1, TP.HCM', '0281234567'),
('DN02', N'Tập đoàn Xây dựng Nam', N'Quận Cầu Giấy, Hà Nội', '0249876543'),
('DN03', N'Cửa hàng Bán lẻ Minh', N'Quận Hải Châu, Đà Nẵng', '0236112233');
SELECT * FROM DoanhNghiep;

INSERT INTO NhanVien VALUES 
('NV01', N'Nguyễn Văn An', '1985-05-20', N'Nam', '001085001234', N'Quận 1, HCM', '0901', 'CV01', 'DN01'),
('NV02', N'Lê Thị Bình', '1992-10-15', N'Nữ', '001092005678', N'Quận 3, HCM', '0902', 'CV04', 'DN01'),
('NV03', N'Trần Văn Cường', '1990-01-10', N'Nam', '001090004321', N'Quận Bình Thạnh, HCM', '0903', 'CV05', 'DN01'),
('NV04', N'Phạm Minh Đức', '1988-12-30', N'Nam', '001088009988', N'Quận Cầu Giấy, Hà Nội', '0904', 'CV02', 'DN02'),
('NV05', N'Hoàng Thu Thủy', '1995-07-22', N'Nữ', '001095007766', N'Quận Thanh Xuân, Hà Nội', '0905', 'CV04', 'DN02'),
('NV06', N'Vũ Hoàng Nam', '1993-03-14', N'Nam', '001093005544', N'Quận Nam Từ Liêm, Hà Nội', '0906', 'CV05', 'DN02'),
('NV07', N'Đỗ Kim Liên', '1991-09-05', N'Nữ', '001091003322', N'Quận Hải Châu, Đà Nẵng', '0907', 'CV03', 'DN03'),
('NV08', N'Bùi Quang Vinh', '1987-11-11', N'Nam', '001087001111', N'Quận Sơn Trà, Đà Nẵng', '0908', 'CV05', 'DN03'),
('NV09', N'Đặng Phương Mai', '1994-06-18', N'Nữ', '001094002233', N'Quận Liên Chiểu, Đà Nẵng', '0909', 'CV05', 'DN03'),
('NV10', N'Lý Quốc Việt', '1990-02-28', N'Nam', '001090004455', N'Quận 1, HCM', '0910', 'CV05', 'DN01');
SELECT * FROM NhanVien;

INSERT INTO HopDong VALUES
('HD01', '2024-01-01', '2027-01-01', 'NV01'), 
('HD02', '2024-01-01', '2027-01-01', 'NV02'),
('HD03', '2024-01-01', '2027-01-01', 'NV03'), 
('HD04', '2024-01-01', '2027-01-01', 'NV04'),
('HD05', '2024-01-01', '2027-01-01', 'NV05'), 
('HD06', '2024-01-01', '2027-01-01', 'NV06'),
('HD07', '2024-01-01', '2027-01-01', 'NV07'), 
('HD08', '2024-01-01', '2027-01-01', 'NV08'),
('HD09', '2024-01-01', '2027-01-01', 'NV09'), 
('HD10', '2024-01-01', '2027-01-01', 'NV10');
SELECT * FROM HopDong;

INSERT INTO SoBHXH VALUES 
('SB01', '2024-01-10', N'BHXH TP.HCM', N'Đã đóng', 'NV01'), 
('SB02', '2024-01-10', N'BHXH TP.HCM', N'Đã đóng', 'NV02'),
('SB03', '2024-01-10', N'BHXH TP.HCM', N'Đã đóng', 'NV03'), 
('SB04', '2024-01-10', N'BHXH Hà Nội', N'Đã đóng', 'NV04'),
('SB05', '2024-01-10', N'BHXH Hà Nội', N'Đã đóng', 'NV05'), 
('SB06', '2024-01-10', N'BHXH Hà Nội', N'Đã đóng', 'NV06'),
('SB07', '2024-01-10', N'BHXH Đà Nẵng', N'Đã đóng', 'NV07'), 
('SB08', '2024-01-10', N'BHXH Đà Nẵng', N'Đã đóng', 'NV08'),
('SB09', '2024-01-10', N'BHXH Đà Nẵng', N'Đã đóng', 'NV09'), 
('SB10', '2024-01-10', N'BHXH TP.HCM', N'Đã đóng', 'NV10');
SELECT * FROM SoBHXH;

INSERT INTO LuongNhanVien (MaLuong, Thang, Nam, Thuong, MaNV, TongLuong)
SELECT 
    'L-' + N.MaNV + '-0426', 4, 2026, 
    T.TienThuong, N.MaNV, (C.LuongCoBan + T.TienThuong)
FROM NhanVien N
JOIN ChucVu C ON N.MaCV = C.MaCV
CROSS APPLY (
    SELECT CASE 
        WHEN C.MaCV = 'CV01' THEN 10000000 -- Sếp thưởng to
        WHEN C.MaCV = 'CV02' THEN 5000000   -- Phó sếp thưởng vừa
        WHEN C.MaCV = 'CV04' THEN 2000000  -- Kế toán thưởng vừa
        ELSE 1000000                      -- Các vị trí khác
    END AS TienThuong
) T;
SELECT * FROM LuongNhanVien;

INSERT INTO QuaTrinhDongBHXH (MaQT, Thang, Nam, MucLuongDong, TrangThaiDong, MaSo, MaHD)
SELECT 
    'QT-' + L.MaNV + '-0426', L.Thang, L.Nam, L.TongLuong, N'Đã đóng', S.MaSo, H.MaHD
FROM LuongNhanVien L
JOIN SoBHXH S ON L.MaNV = S.MaNV
JOIN HopDong H ON L.MaNV = H.MaNV;
SELECT * FROM QuaTrinhDongBHXH;

INSERT INTO HoaDon (MaHoaDon, Thang, Nam, MaDN, TongTien)
SELECT 
    'HD-' + N.MaDN + '-0426', 4, 2026, N.MaDN, SUM(QT.SoTienDong) 
FROM QuaTrinhDongBHXH QT
JOIN SoBHXH S ON QT.MaSo = S.MaSo
JOIN NhanVien N ON S.MaNV = N.MaNV
GROUP BY N.MaDN;
SELECT * FROM HoaDon;

INSERT INTO CheDoHuong VALUES 
('CD01', N'Ốm đau', N'Hưởng khi có xác nhận của bệnh viện'),
('CD02', N'Thai sản', N'Hưởng 6 tháng nghỉ thai sản'),
('CD03', N'Hưu trí', N'Hưởng sau khi đủ tuổi lao động'),
('CD04', N'Tử tuất', N'Hưởng cho thân nhân'),
('CD05', N'Tai nạn lao động, bệnh nghề nghiệp', N'Hưởng khi bị tai nạn lao động hoặc mắc bệnh nghề nghiệp');
SELECT * FROM CheDoHuong;

INSERT INTO HuongCheDo (MaHuong, MaNV, MaCheDo, NgayBatDau, NgayKetThuc, SoTienHuong) VALUES 
('H01', 'NV02', 'CD02', '2026-01-01', '2026-06-01', 90000000), -- Kế toán hưởng thai sản 6 tháng
('H02', 'NV03', 'CD01', '2026-04-10', '2026-04-15', 2500000),   -- Nhân viên nghỉ ốm 5 ngày
('H03', 'NV04', 'CD05', '2026-02-01', '2026-02-28', 15000000), -- Phó giám đốc bị tai nạn lao động
('H04', 'NV05', 'CD03', '2026-03-01', '2026-03-31', 30000000), -- Kế toán hưởng hưu trí 1 tháng
('H05', 'NV06', 'CD04', '2026-04-01', '2026-04-30', 20000000); -- Nhân viên tử tuất hưởng 1 tháng
SELECT * FROM HuongCheDo;
