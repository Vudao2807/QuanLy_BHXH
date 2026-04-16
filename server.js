const express = require('express');
const sql = require('mssql');
const cors = require('cors');
require('dotenv').config();

const app = express();
app.use(express.json());
app.use(cors());

// Cấu hình kết nối SQL Server
const dbConfig = {
    user: process.env.DB_USER,
    password: process.env.DB_PASSWORD,
    server: process.env.DB_SERVER,
    database: process.env.DB_DATABASE,
    options: {
        encrypt: true, // Cho Azure
        trustServerCertificate: true // Cho localhost
    }
};

// Kết nối Database
sql.connect(dbConfig).then(pool => {
    if (pool.connected) console.log("✅ Đã kết nối SQL Server thành công!");
}).catch(err => console.log("❌ Lỗi kết nối: ", err));

// --- API LẤY DỮ LIỆU (READ) ---
app.get('/api/:table', async (req, res) => {
    try {
        const { table } = req.params;
        const result = await sql.query(`SELECT * FROM ${table}`);
        res.json(result.recordset);
    } catch (err) {
        res.status(500).send(err.message);
    }
});

// --- API THÊM MỚI (CREATE) ---
// Ví dụ cho bảng DoanhNghiep
app.post('/api/DoanhNghiep', async (req, res) => {
    try {
        const { MaDN, TenDN, DiaChi, SDT } = req.body;
        const pool = await sql.connect(dbConfig);
        await pool.request()
            .input('MaDN', sql.VarChar, MaDN)
            .input('TenDN', sql.NVarChar, TenDN)
            .input('DiaChi', sql.NVarChar, DiaChi)
            .input('SDT', sql.VarChar, SDT)
            .query('INSERT INTO DoanhNghiep (MaDN, TenDN, DiaChi, SDT) VALUES (@MaDN, @TenDN, @DiaChi, @SDT)');
        res.status(201).json({ message: "Thêm thành công!" });
    } catch (err) {
        res.status(500).send(err.message);
    }
});

// --- API XÓA (DELETE) ---
app.delete('/api/:table/:id', async (req, res) => {
    try {
        const { table, id } = req.params;
        let pkColumn = '';
        
        // Xác định khóa chính tùy theo bảng
        if (table === 'DoanhNghiep') pkColumn = 'MaDN';
        else if (table === 'NhanVien') pkColumn = 'MaNV';
        // Thêm các bảng khác vào đây...

        const pool = await sql.connect(dbConfig);
        await pool.request()
            .input('id', sql.VarChar, id)
            .query(`DELETE FROM ${table} WHERE ${pkColumn} = @id`);
        res.json({ message: "Xóa thành công!" });
    } catch (err) {
        res.status(500).send(err.message);
    }
});

const PORT = process.env.PORT || 3000;
app.listen(PORT, () => console.log(`🚀 Server đang chạy tại http://localhost:${PORT}`));
