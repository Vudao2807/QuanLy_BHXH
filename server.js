const express = require('express');
const sql = require('mssql');
const cors = require('cors');
require('dotenv').config();

const app = express();
app.use(cors());
app.use(express.json());

const config = {
    user: process.env.DB_USER,
    password: process.env.DB_PASSWORD,
    server: process.env.DB_SERVER,
    database: 'QL_BHXH',
    options: {
        encrypt: false, // true nếu dùng Azure
        trustServerCertificate: true
    }
};

// API Lấy danh sách nhân viên
app.get('/api/nhanvien', async (req, res) => {
    try {
        let pool = await sql.connect(config);
        let result = await pool.request().query("SELECT * FROM NhanVien");
        res.json(result.recordset);
    } catch (err) {
        res.status(500).send(err.message);
    }
});

// API Truy vấn quá trình đóng BHXH theo Mã NV
app.get('/api/quatrinh/:manv', async (req, res) => {
    try {
        let pool = await sql.connect(config);
        let result = await pool.request()
            .input('manv', sql.VarChar, req.params.manv)
            .query(`
                SELECT QT.* FROM QuaTrinhDongBHXH QT
                JOIN SoBHXH S ON QT.MaSo = S.MaSo
                WHERE S.MaNV = @manv
            `);
        res.json(result.recordset);
    } catch (err) {
        res.status(500).send(err.message);
    }
});

app.listen(3000, () => console.log('Server running on port 3000'));
