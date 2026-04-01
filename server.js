const express = require("express");
const cors = require("cors");
const mysql = require("mysql2");
const path = require("path");

const app = express();
app.use(cors());
app.use(express.json());

// Kết nối đến MySQL (Hãy chắc chắn bạn đã bật XAMPP MySQL và import file database.sql)
const db = mysql.createConnection({
  host: "localhost",
  user: "root", // user mặc định của XAMPP
  password: "", // password mặc định trống
  database: "QuanLy4TL",
});

db.connect((err) => {
  if (err) {
    console.error("Lỗi kết nối CSDL MySQL:", err);
  } else {
    console.log("✅ Đã kết nối thành công với MySQL (Database: QuanLy4TL)");
  }
});

// API 1: Lấy danh sách Sản phẩm
app.get("/api/sanpham", (req, res) => {
  const query = `
    SELECT 
      sp.MaSP,
      sp.TenSP,
      sp.GiaBan,
      sp.SoLuongTon,
      sp.MaLoai,
      lsp.TenLoai
    FROM SanPham sp
    LEFT JOIN LoaiSanPham lsp ON lsp.MaLoai = sp.MaLoai
    ORDER BY sp.MaSP ASC
  `;
  db.query(query, (err, results) => {
    if (err) return res.status(500).json({ error: err.message });
    res.json(results);
  });
});

// API 2: Lấy danh sách Khách hàng
app.get("/api/khachhang", (req, res) => {
  const query = "SELECT * FROM KhachHang";
  db.query(query, (err, results) => {
    if (err) return res.status(500).json({ error: err.message });
    res.json(results);
  });
});

// API 3: Đăng nhập hệ thống (demo)
app.post("/api/login", (req, res) => {
  const username = String(req.body?.username || "").trim();
  const password = String(req.body?.password || "").trim();

  if (!username || !password) {
    return res
      .status(400)
      .json({ error: "Thiếu tên đăng nhập hoặc mật khẩu." });
  }

  const query = `
    SELECT MaNV, TenNV, ChucVu, TenDangNhap
    FROM NhanVien
    WHERE TenDangNhap = ? AND MatKhau = ?
    LIMIT 1
  `;

  db.query(query, [username, password], (err, results) => {
    if (err) return res.status(500).json({ error: err.message });

    if (!results || results.length === 0) {
      return res.status(401).json({ error: "Sai tài khoản hoặc mật khẩu." });
    }

    res.json({
      message: "Đăng nhập thành công.",
      user: results[0],
    });
  });
});

// API 4: Danh sách hóa đơn gần đây
app.get("/api/hoadon", (req, res) => {
  const query = `
    SELECT 
      hd.MaHD,
      hd.NgayLap,
      hd.TongTien,
      hd.HinhThucThanhToan,
      kh.TenKH,
      GROUP_CONCAT(CONCAT(sp.TenSP, ' x', cthd.SoLuong) ORDER BY sp.TenSP SEPARATOR ', ') AS SanPham
    FROM HoaDon hd
    LEFT JOIN KhachHang kh ON kh.MaKH = hd.MaKH
    LEFT JOIN ChiTietHoaDon cthd ON cthd.MaHD = hd.MaHD
    LEFT JOIN SanPham sp ON sp.MaSP = cthd.MaSP
    GROUP BY hd.MaHD, hd.NgayLap, hd.TongTien, hd.HinhThucThanhToan, kh.TenKH
    ORDER BY hd.NgayLap DESC
    LIMIT 20
  `;

  db.query(query, (err, results) => {
    if (err) return res.status(500).json({ error: err.message });
    res.json(results);
  });
});

// Phục vụ các file HTML tĩnh (Frontend)
app.use(express.static(path.join(__dirname, "4TL")));

const PORT = 3000;
app.listen(PORT, () => {
  console.log(`🚀 Server đang chạy tại: http://localhost:${PORT}`);
  console.log(
    `👉 Mở trang Khách Hàng: http://localhost:3000/4TLkhachhang.html`,
  );
  console.log(`👉 Mở trang Nhân Viên:  http://localhost:3000/4TLnhanvien.html`);
});
