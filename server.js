const express = require('express');
const fs = require('fs');
const path = require('path');
const app = express();
const PORT = process.env.PORT || 3000;

app.use(express.json());

// Giao diện người dùng (phục vụ file index.html ở cùng thư mục)
app.get('/', (req, res) => {
    res.sendFile(path.join(__dirname, 'index.html'));
});

// API lấy dữ liệu từ database.json
const getDB = () => JSON.parse(fs.readFileSync('./database.json', 'utf8'));

// API Tra cứu theo Mã Nhân Viên
app.get('/api/search/:manv', (req, res) => {
    const db = getDB();
    const maNV = req.params.manv.toUpperCase();
    
    // Tìm nhân viên
    const nv = db.nhanVien.find(n => n.MaNV === maNV);
    if (!nv) return res.status(404).json({ message: "Không tìm thấy nhân viên!" });

    // Lấy quá trình đóng BHXH
    const quaTrinh = db.quaTrinhDong.filter(qt => qt.MaNV === maNV);
    
    res.json({ nhanVien: nv, lichSu: quaTrinh });
});

app.listen(PORT, () => console.log(`Server is running at http://localhost:${PORT}`));
