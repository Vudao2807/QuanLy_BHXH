const express = require('express');
const fs = require('fs');
const app = express();
const PORT = 3000;

app.use(express.static('public'));
app.use(express.json());

// Hàm đọc database từ file JSON
const getData = () => JSON.parse(fs.readFileSync('./data/database.json', 'utf8'));

// API: Truy vấn danh sách nhân viên
app.get('/api/nhanvien', (req, res) => {
    const data = getData();
    res.json(data.nhanVien);
});

// API: Truy vấn quá trình đóng BHXH (Thay thế lệnh JOIN trong SQL)
app.get('/api/tra-cuu/:manv', (req, res) => {
    const data = getData();
    const result = data.quaTrinhDong.filter(qt => qt.MaNV === req.params.manv);
    
    if (result.length > 0) {
        res.json(result);
    } else {
        res.status(404).json({ message: "Không tìm thấy dữ liệu" });
    }
});

app.listen(PORT, () => console.log(`Server chạy tại http://localhost:${PORT}`));
