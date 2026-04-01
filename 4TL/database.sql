-- Tạo Cơ sở dữ liệu
CREATE DATABASE IF NOT EXISTS QuanLy4TL;
USE QuanLy4TL;

-- ==========================================
-- 1. TẠO CÁC BẢNG ĐỘC LẬP
-- ==========================================

CREATE TABLE KhachHang (
    MaKH VARCHAR(20) PRIMARY KEY,
    TenKH NVARCHAR(100) NOT NULL,
    SDT VARCHAR(20),
    DiaChi NVARCHAR(255),
    Email VARCHAR(100),
    DiemTichLuy INT DEFAULT 0
);

CREATE TABLE KhuyenMai (
    MaKM VARCHAR(20) PRIMARY KEY,
    TenKM NVARCHAR(100) NOT NULL,
    PhanTramGiam DECIMAL(5,2),
    NgayBatDau DATE,
    NgayKetThuc DATE
);

CREATE TABLE NhanVien (
    MaNV VARCHAR(20) PRIMARY KEY,
    TenNV NVARCHAR(100) NOT NULL,
    SDT VARCHAR(20),
    ChucVu NVARCHAR(50),
    TenDangNhap VARCHAR(50) UNIQUE,
    MatKhau VARCHAR(255)
);

CREATE TABLE CaLamViec (
    MaCa VARCHAR(20) PRIMARY KEY,
    ThoiGianBatDau DATETIME,
    ThoiGianKetThuc DATETIME,
    DoanhThuCa DECIMAL(18,2) DEFAULT 0
);

CREATE TABLE Nha_Cung_Cap (
    MaNCC VARCHAR(20) PRIMARY KEY,
    TenNCC NVARCHAR(100) NOT NULL,
    SDT VARCHAR(20),
    DiaChi NVARCHAR(255),
    Email VARCHAR(100)
);

CREATE TABLE LoaiSanPham (
    MaLoai VARCHAR(20) PRIMARY KEY,
    TenLoai NVARCHAR(100) NOT NULL,
    MoTa NVARCHAR(255)
);

-- ==========================================
-- 2. TẠO CÁC BẢNG PHỤ THUỘC CẤP 1
-- ==========================================

CREATE TABLE SanPham (
    MaSP VARCHAR(20) PRIMARY KEY,
    TenSP NVARCHAR(100) NOT NULL,
    GiaBan DECIMAL(18,2) NOT NULL,
    SoLuongTon INT DEFAULT 0,
    HanSuDung DATE,
    NgaySX DATE,
    MaLoai VARCHAR(20),
    FOREIGN KEY (MaLoai) REFERENCES LoaiSanPham(MaLoai) ON UPDATE CASCADE ON DELETE SET NULL
);

CREATE TABLE PhieuNhap (
    MaPN VARCHAR(20) PRIMARY KEY,
    NgayNhap DATETIME,
    MaNV VARCHAR(20),
    MaNCC VARCHAR(20),
    FOREIGN KEY (MaNV) REFERENCES NhanVien(MaNV) ON UPDATE CASCADE ON DELETE SET NULL,
    FOREIGN KEY (MaNCC) REFERENCES Nha_Cung_Cap(MaNCC) ON UPDATE CASCADE ON DELETE SET NULL
);

CREATE TABLE HoaDon (
    MaHD VARCHAR(20) PRIMARY KEY,
    NgayLap DATETIME,
    TongTien DECIMAL(18,2) DEFAULT 0,
    HinhThucThanhToan NVARCHAR(50),
    MaKH VARCHAR(20),
    MaKM VARCHAR(20),
    MaNV VARCHAR(20),
    FOREIGN KEY (MaKH) REFERENCES KhachHang(MaKH) ON UPDATE CASCADE ON DELETE SET NULL,
    FOREIGN KEY (MaKM) REFERENCES KhuyenMai(MaKM) ON UPDATE CASCADE ON DELETE SET NULL,
    FOREIGN KEY (MaNV) REFERENCES NhanVien(MaNV) ON UPDATE CASCADE ON DELETE SET NULL
);

CREATE TABLE NhanVien_Ca (
    MaNV VARCHAR(20),
    MaCa VARCHAR(20),
    Ban NVARCHAR(50),
    PRIMARY KEY (MaNV, MaCa),
    FOREIGN KEY (MaNV) REFERENCES NhanVien(MaNV) ON UPDATE CASCADE ON DELETE CASCADE,
    FOREIGN KEY (MaCa) REFERENCES CaLamViec(MaCa) ON UPDATE CASCADE ON DELETE CASCADE
);

-- ==========================================
-- 3. TẠO CÁC BẢNG PHỤ THUỘC CẤP 2 (CHI TIẾT)
-- ==========================================

CREATE TABLE ChiTietHoaDon (
    MaHD VARCHAR(20),
    MaSP VARCHAR(20),
    SoLuong INT NOT NULL,
    DonGia DECIMAL(18,2) NOT NULL,
    ThanhTien DECIMAL(18,2) NOT NULL,
    PRIMARY KEY (MaHD, MaSP),
    FOREIGN KEY (MaHD) REFERENCES HoaDon(MaHD) ON UPDATE CASCADE ON DELETE CASCADE,
    FOREIGN KEY (MaSP) REFERENCES SanPham(MaSP) ON UPDATE CASCADE ON DELETE CASCADE
);

CREATE TABLE ChiTietPhieuNhap (
    MaPN VARCHAR(20),
    MaSP VARCHAR(20),
    SoLuong INT NOT NULL,
    GiaNhap DECIMAL(18,2) NOT NULL,
    PRIMARY KEY (MaPN, MaSP),
    FOREIGN KEY (MaPN) REFERENCES PhieuNhap(MaPN) ON UPDATE CASCADE ON DELETE CASCADE,
    FOREIGN KEY (MaSP) REFERENCES SanPham(MaSP) ON UPDATE CASCADE ON DELETE CASCADE
);

-- ==========================================
-- 4. THÊM DỮ LIỆU MẪU (DEMO DATA)
-- ==========================================

-- Khách Hàng
INSERT INTO KhachHang (MaKH, TenKH, SDT, DiaChi, Email, DiemTichLuy) VALUES 
('KH001', N'Nguyễn Văn A', '0901234567', N'123 Lê Lợi, Q1, HCM', 'nva@email.com', 150),
('KH002', N'Trần Thị B', '0912345678', N'456 Nguyễn Trãi, Q5, HCM', 'ttb@email.com', 50),
('KH003', N'Lê Minh Cường', '0923456789', N'19 Nguyễn Huệ, Q1, HCM', 'lmc@email.com', 820),
('KH004', N'Phạm Thu Dung', '0934567890', N'88 Võ Văn Tần, Q3, HCM', 'ptd@email.com', 1450),
('KH005', N'Đặng Quốc Huy', '0945678901', N'12 Trần Hưng Đạo, Q5, HCM', 'dqh@email.com', 3120),
('KH006', N'Bùi Gia Linh', '0956789012', N'41 CMT8, Q10, HCM', 'bgl@email.com', 2300),
('KH007', N'Trương Khánh An', '0967890123', N'9 Hoàng Văn Thụ, Tân Bình, HCM', 'tka@email.com', 560);

-- Khuyến Mãi
INSERT INTO KhuyenMai (MaKM, TenKM, PhanTramGiam, NgayBatDau, NgayKetThuc) VALUES 
('KM01', N'Khuyến mãi Hè', 10.00, '2026-06-01', '2026-08-31'),
('KM02', N'Khách hàng thân thiết', 5.00, '2026-01-01', '2026-12-31'),
('KM03', N'Giờ vàng nước giải khát', 15.00, '2026-03-01', '2026-06-30'),
('KM04', N'Combo đồ dùng cá nhân', 8.00, '2026-02-15', '2026-12-31');

-- Nhân Viên
INSERT INTO NhanVien (MaNV, TenNV, SDT, ChucVu, TenDangNhap, MatKhau) VALUES 
('NV01', N'Lê Quản Lý', '0988777666', N'Quản Lý', 'admin', '123456'),
('NV02', N'Phạm Nhân Viên', '0977666555', N'Nhân Viên', 'nv01', '123456'),
('NV03', N'Nguyễn Thu Ngân', '0966111222', N'Thu Ngân', 'ngan01', '123456'),
('NV04', N'Trần Kho', '0955222333', N'Quản Kho', 'kho01', '123456'),
('NV05', N'Hoàng Giao Ca', '0944333444', N'Nhân Viên', 'ca01', '123456');

-- Ca Làm Việc
INSERT INTO CaLamViec (MaCa, ThoiGianBatDau, ThoiGianKetThuc, DoanhThuCa) VALUES 
('CA01', '2026-03-12 06:00:00', '2026-03-12 14:00:00', 4200000.00),
('CA02', '2026-03-12 14:00:00', '2026-03-12 22:00:00', 6950000.00),
('CA03', '2026-03-13 06:00:00', '2026-03-13 14:00:00', 4880000.00),
('CA04', '2026-03-13 14:00:00', '2026-03-13 22:00:00', 7310000.00);

-- Phân Công NhanVien_Ca
INSERT INTO NhanVien_Ca (MaNV, MaCa, Ban) VALUES 
('NV01', 'CA01', N'Bàn Quản Lý'),
('NV02', 'CA02', N'Quầy Thu Ngân 1'),
('NV03', 'CA03', N'Quầy Thu Ngân 2'),
('NV04', 'CA04', N'Kho Tổng'),
('NV05', 'CA03', N'Khu Trưng Bày');

-- Nhà Cung Cấp
INSERT INTO Nha_Cung_Cap (MaNCC, TenNCC, SDT, DiaChi, Email) VALUES 
('NCC01', N'Công ty Nước Giải Khát', '0811222333', N'KCN Tân Bình', 'coca@ncc.com'),
('NCC02', N'Cơ sở Bánh Ngọt', '0822333444', N'Bình Thạnh', 'banhngot@ncc.com'),
('NCC03', N'Thực phẩm An Khang', '0833444555', N'Q.12, HCM', 'ankhang@ncc.com'),
('NCC04', N'Vina Fresh', '0844555666', N'Thủ Đức, HCM', 'vinafresh@ncc.com'),
('NCC05', N'HomeCare VN', '0855666777', N'Biên Hòa, Đồng Nai', 'homecare@ncc.com');

-- Loại Sản Phẩm
INSERT INTO LoaiSanPham (MaLoai, TenLoai, MoTa) VALUES 
('LSP01', N'Nước uống đóng chai', N'Các loại đồ uống đóng chai'),
('LSP02', N'Bánh ăn vặt', N'Bánh ngọt, snack'),
('LSP03', N'Thực phẩm tiện lợi', N'Mì, đồ ăn nhanh, đóng gói'),
('LSP04', N'Đồ dùng cá nhân', N'Khăn giấy, dầu gội, vật dụng hằng ngày');

-- Sản Phẩm
INSERT INTO SanPham (MaSP, TenSP, GiaBan, SoLuongTon, HanSuDung, NgaySX, MaLoai) VALUES 
('SP001', N'Nước Cam Ép 1L', 15000.00, 100, '2026-12-31', '2026-01-01', 'LSP01'),
('SP002', N'Bánh Mì Ngọt', 25000.00, 50, '2026-11-01', '2026-03-01', 'LSP02'),
('SP003', N'Nước Suối 500ml', 7000.00, 180, '2026-12-31', '2026-01-01', 'LSP01'),
('SP004', N'Mì Ly Hải Sản', 12000.00, 220, '2027-02-28', '2026-02-20', 'LSP03'),
('SP005', N'Sữa Tươi Không Đường 1L', 33000.00, 95, '2026-09-30', '2026-03-05', 'LSP03'),
('SP006', N'Nước Tăng Lực', 18000.00, 130, '2027-01-15', '2026-02-18', 'LSP01'),
('SP007', N'Khăn Giấy Bỏ Túi', 11000.00, 160, '2028-03-31', '2026-01-15', 'LSP04'),
('SP008', N'Dầu Gội Mini 80ml', 28000.00, 75, '2027-06-30', '2026-01-20', 'LSP04'),
('SP009', N'Bánh Quy Bơ 200g', 22000.00, 90, '2027-05-31', '2026-02-01', 'LSP02');

-- Phiếu Nhập
INSERT INTO PhieuNhap (MaPN, NgayNhap, MaNV, MaNCC) VALUES 
('PN001', '2026-03-08 09:00:00', 'NV01', 'NCC01'),
('PN002', '2026-03-09 15:30:00', 'NV04', 'NCC02'),
('PN003', '2026-03-10 11:20:00', 'NV04', 'NCC03'),
('PN004', '2026-03-11 08:45:00', 'NV01', 'NCC04'),
('PN005', '2026-03-12 17:10:00', 'NV04', 'NCC05');

-- Chi Tiết Phiếu Nhập
INSERT INTO ChiTietPhieuNhap (MaPN, MaSP, SoLuong, GiaNhap) VALUES 
('PN001', 'SP001', 120, 10000.00),
('PN001', 'SP003', 150, 4500.00),
('PN002', 'SP002', 60, 16000.00),
('PN002', 'SP009', 70, 14000.00),
('PN003', 'SP004', 180, 7500.00),
('PN003', 'SP005', 100, 24000.00),
('PN004', 'SP006', 130, 10500.00),
('PN005', 'SP007', 200, 6000.00),
('PN005', 'SP008', 90, 18000.00);

-- Hóa Đơn
INSERT INTO HoaDon (MaHD, NgayLap, TongTien, HinhThucThanhToan, MaKH, MaKM, MaNV) VALUES 
('HD001', '2026-03-12 08:15:00', 52000.00, N'Tiền mặt', 'KH001', NULL, 'NV02'),
('HD002', '2026-03-12 10:40:00', 76000.00, N'Chuyển khoản', 'KH003', 'KM02', 'NV03'),
('HD003', '2026-03-12 13:05:00', 115000.00, N'Tiền mặt', 'KH005', 'KM03', 'NV02'),
('HD004', '2026-03-12 18:20:00', 48000.00, N'Ví điện tử', 'KH002', NULL, 'NV03'),
('HD005', '2026-03-13 09:25:00', 149000.00, N'Tiền mặt', 'KH006', 'KM01', 'NV03'),
('HD006', '2026-03-13 20:10:00', 67000.00, N'Chuyển khoản', 'KH004', NULL, 'NV02');

-- Chi Tiết Hóa Đơn
INSERT INTO ChiTietHoaDon (MaHD, MaSP, SoLuong, DonGia, ThanhTien) VALUES 
('HD001', 'SP001', 2, 15000.00, 30000.00),
('HD001', 'SP003', 2, 7000.00, 14000.00),
('HD001', 'SP007', 1, 11000.00, 11000.00),
('HD002', 'SP005', 1, 33000.00, 33000.00),
('HD002', 'SP004', 2, 12000.00, 24000.00),
('HD002', 'SP003', 3, 7000.00, 21000.00),
('HD003', 'SP006', 3, 18000.00, 54000.00),
('HD003', 'SP008', 1, 28000.00, 28000.00),
('HD003', 'SP002', 1, 25000.00, 25000.00),
('HD004', 'SP004', 4, 12000.00, 48000.00),
('HD005', 'SP005', 2, 33000.00, 66000.00),
('HD005', 'SP009', 2, 22000.00, 44000.00),
('HD005', 'SP007', 1, 11000.00, 11000.00),
('HD006', 'SP001', 1, 15000.00, 15000.00),
('HD006', 'SP004', 2, 12000.00, 24000.00),
('HD006', 'SP002', 1, 25000.00, 25000.00);