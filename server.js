const { Sequelize, DataTypes, Op } = require('sequelize');
const express = require('express');
const cors = require('cors');

const app = express();
app.use(cors());
app.use(express.json());

// --- 1. CẤU HÌNH KẾT NỐI (Sửa thông tin theo máy của bạn) ---
const sequelize = new Sequelize('QL_BHXH', 'sa', '123456', {
    host: 'localhost',
    dialect: 'mssql',
    dialectOptions: {
        options: {
            encrypt: false, // Để false nếu chạy local
            trustServerCertificate: true
        }
    },
    logging: false
});

// --- 2. ĐỊNH NGHĨA CÁC MODEL (Tương ứng với file SQL của bạn) ---

const ChucVu = sequelize.define('ChucVu', {
    MaCV: { type: DataTypes.STRING(10), primaryKey: true },
    TenCV: DataTypes.NSTRING(100),
    LuongCoBan: DataTypes.DECIMAL(18, 2)
}, { tableName: 'ChucVu', timestamps: false });

const DoanhNghiep = sequelize.define('DoanhNghiep', {
    MaDN: { type: DataTypes.STRING(10), primaryKey: true },
    TenDN: DataTypes.NSTRING(255),
    DiaChi: DataTypes.NSTRING(255),
    SDT: DataTypes.STRING(20)
}, { tableName: 'DoanhNghiep', timestamps: false });

const NhanVien = sequelize.define('NhanVien', {
    MaNV: { type: DataTypes.STRING(10), primaryKey: true },
    TenNV: DataTypes.NSTRING(100),
    NgaySinh: DataTypes.DATEONLY,
    GioiTinh: DataTypes.NSTRING(10),
    CCCD: DataTypes.STRING(20),
    MaCV: DataTypes.STRING(10),
    MaDN: DataTypes.STRING(10)
}, { tableName: 'NhanVien', timestamps: false });

const SoBHXH = sequelize.define('SoBHXH', {
    MaSo: { type: DataTypes.STRING(20), primaryKey: true },
    NgayCap: DataTypes.DATEONLY,
    NoiCap: DataTypes.NSTRING(255),
    TrangThai: DataTypes.NSTRING(50),
    MaNV: DataTypes.STRING(10)
}, { tableName: 'SoBHXH', timestamps: false });

// Thiết lập quan hệ (Associations) - Giúp lấy dữ liệu kèm theo (Join)
NhanVien.belongsTo(ChucVu, { foreignKey: 'MaCV' });
NhanVien.belongsTo(DoanhNghiep, { foreignKey: 'MaDN' });

// --- 3. ĐỊNH CẤU HÌNH CÁC BẢNG ĐỂ API TỰ ĐỘNG XỬ LÝ ---
const models = {
    'chuc-vu': { model: ChucVu, pk: 'MaCV' },
    'doanh-nghiep': { model: DoanhNghiep, pk: 'MaDN' },
    'nhan-vien': { model: NhanVien, pk: 'MaNV', include: [ChucVu, DoanhNghiep] },
    'so-bhxh': { model: SoBHXH, pk: 'MaSo' }
    // Bạn có thể thêm các bảng khác như LuongNhanVien, QuaTrinhDong tương tự...
};

// --- 4. CÁC ROUTE API (Lưu thực sự vào DB) ---

// Lấy danh sách
app.get('/api/:table', async (req, res) => {
    try {
        const target = models[req.params.table];
        if (!target) return res.status(404).send("Bảng không tồn tại");

        const data = await target.model.findAll({
            include: target.include || []
        });
        res.json(data);
    } catch (err) {
        res.status(500).send(err.message);
    }
});

// THỰC HIỆN LƯU MỚI (INSERT)
app.post('/api/:table', async (req, res) => {
    try {
        const target = models[req.params.table];
        if (!target) return res.status(404).send("Bảng không tồn tại");

        const newData = await target.model.create(req.body);
        res.json({ message: "Lưu dữ liệu thành công!", data: newData });
    } catch (err) {
        res.status(400).send("Lỗi lưu dữ liệu: " + err.message);
    }
});

// THỰC HIỆN XÓA (DELETE)
app.delete('/api/:table/:id', async (req, res) => {
    try {
        const target = models[req.params.table];
        await target.model.destroy({ where: { [target.pk]: req.params.id } });
        res.json({ message: "Đã xóa thành công ID: " + req.params.id });
    } catch (err) {
        res.status(500).send(err.message);
    }
});

// THỰC HIỆN CẬP NHẬT (UPDATE)
app.put('/api/:table/:id', async (req, res) => {
    try {
        const target = models[req.params.table];
        await target.model.update(req.body, { where: { [target.pk]: req.params.id } });
        res.json({ message: "Cập nhật thành công!" });
    } catch (err) {
        res.status(500).send(err.message);
    }
});

// Chạy server
const PORT = 3000;
app.listen(PORT, () => {
    console.log(`🚀 Backend BHXH đang chạy tại: http://localhost:${PORT}`);
});
