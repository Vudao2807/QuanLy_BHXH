const { Sequelize, DataTypes } = require('sequelize');
const express = require('express');
const cors = require('cors');

const app = express();
app.use(cors());
app.use(express.json());

const sequelize = new Sequelize('QL_BHXH', 'sa', '123456', {
    host: 'localhost',
    dialect: 'mssql',
    dialectOptions: { options: { encrypt: false, trustServerCertificate: true } },
    logging: false
});

// Định nghĩa Models
const ChucVu = sequelize.define('ChucVu', {
    MaCV: { type: DataTypes.STRING, primaryKey: true },
    TenCV: DataTypes.STRING,
    LuongCoBan: DataTypes.DECIMAL
}, { tableName: 'ChucVu', timestamps: false });

const NhanVien = sequelize.define('NhanVien', {
    MaNV: { type: DataTypes.STRING, primaryKey: true },
    TenNV: DataTypes.STRING,
    MaCV: DataTypes.STRING,
    MaDN: DataTypes.STRING
}, { tableName: 'NhanVien', timestamps: false });

const models = {
    'chuc-vu': { model: ChucVu, pk: 'MaCV' },
    'nhan-vien': { model: NhanVien, pk: 'MaNV' }
};

// API Generic
app.get('/api/:table', async (req, res) => {
    try {
        const target = models[req.params.table];
        const data = await target.model.findAll();
        res.json(data);
    } catch (err) { res.status(500).send(err.message); }
});

app.post('/api/:table', async (req, res) => {
    try {
        const target = models[req.params.table];
        await target.model.create(req.body);
        res.json({ message: "Thêm thành công!" });
    } catch (err) { res.status(400).send(err.message); }
});

app.listen(3000, () => console.log('Server BHXH chạy tại http://localhost:3000'));
