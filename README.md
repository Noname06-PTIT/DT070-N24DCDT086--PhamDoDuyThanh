# Algorithm Visualizer App (DT070)

> **Do an mon hoc Cau truc Du lieu va Giai thuat (INT13185)**  
> Hoc vien Cong nghe Buu chinh Vien thong (PTIT)  
> Ung dung truc quan hoa thuat toan chuan Production.

![Python](https://img.shields.io/badge/Python-3.11-blue)
![Flask](https://img.shields.io/badge/Flask-3.x-lightgrey)
![Pytest](https://img.shields.io/badge/Tests-Pytest-brightgreen)

---

## THONG TIN DO AN & HUONG DAN DOI CHIEU (Theo Rubric)

### 1. Nhan dien

- **Ho va ten:** Pham Do Duy Thanh
- **MSSV:** N24DCDT086
- **Lop:** [Dien ten lop cua ban - VD: D24CQDT01-N]
- **Ma de:** DT070
- **Ten de:** [Dien ten de tai DT070 trong phieu]
- **Duong dan phieu:** `05_Minh_chung_cu_the_91_de_tai.docx` (Muc DT070)
- **Can cu giao trinh:** [Dien so chuong, muc, trang trong giao trinh CTDL&GT PTIT]

### 2. Moi truong

- **Ngon ngu:** Python 3.11
- **Thu vien su dung:** `Flask>=3.0.0`, `pytest>=7.4.0`, `gunicorn>=21.2.0`
- **Lenh cai dat:** `pip install -r requirements.txt`

### 3. Lenh

- **Chay Vi du 1 (theo phieu de):**  
  `python -c "from logic import liet_ke; print(liet_ke(3))"`
- **Chay Vi du 2 (theo phieu de):**  
  `python -c "from logic import liet_ke; print(liet_ke(4))"`
- **Khoi chay giao dien Web:**  
  `python app.py` (Truy cap `http://localhost:5000`)
- **Chay toan bo kiem thu (hien thi chi tiet):**  
  `pytest tests/test_logic.py -v -s`
- **Chay do dac hieu nang (Benchmark):**  
  `python benchmark.py`

### 4. Quy uoc

- **Input:** Gia tri nguyen n >= 0, thoa man rang buoc cua de tai DT070.
- **Thu tu chi so:** 1-based (bat dau tu 1) dong bo voi gia ma trong giao trinh.
- **Output:** Danh sach cac ket qua, sap xep theo thu tu tu dien.
- **Xu ly loi:** Nem `ValueError` va hien thi thong bao mau do khi nhap sai.

### 5. Minh chung

- **Thu muc anh:** `docs/anh_ket_qua/` (Chua anh chup man hinh A01 den A11)
- **Ma ca kiem thu & Ket qua:** Chi tiet tai Chuong 4 trong BaoCao.docx
- **CI/CD tu dong:** GitHub Actions tu dong chay pytest moi lan push code

---

## Cau truc thu muc

```text
DT070-N24DCDT086--PhamDoDuyThanh/
├── .github/workflows/python-app.yml  # CI/CD tu dong
├── docs/anh_ket_qua/                 # Anh minh chung A01-A11
├── templates/index.html              # Giao dien Web Visualizer
├── tests/test_logic.py               # Bo kiem thu 8 ca
├── .gitignore
├── app.py                            # Flask server & REST API
├── logic.py                          # Thuat toan loi DT070
├── benchmark.py                      # Do luong hieu nang
└── requirements.txt
```

## Huong dan cai dat & Chay

```bash
# Cai dat thu vien
pip install -r requirements.txt

# Chay ung dung web
python app.py

# Chay kiem thu
pytest tests/test_logic.py -v -s

# Chay benchmark
python benchmark.py
```
