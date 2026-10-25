# DT070 - Hàng đợi bằng danh sách liên kết có đầu và cuối

Bản mã nguồn hoàn chỉnh đồ án học phần Cấu trúc dữ liệu và giải thuật (INT13185 Nhóm 03).
Cài đặt cấu trúc dữ liệu Hàng đợi (Queue - FIFO) bằng Danh sách liên kết đơn có cả hai con trỏ `dau` (front/head) và `cuoi` (rear/tail).
Độ phức tạp thời gian: Thêm (Enqueue) đạt O(1), Lấy (Dequeue) đạt O(1), Xem đầu/cuối đạt O(1).

## Thông tin sinh viên và căn cứ đề tài

- Họ và tên sinh viên: **Phạm Đỗ Duy Thành**
- Mã số sinh viên (MSSV): **N24DCDT086**
- Lớp: **D24CQDT01-N** (INT13185 - Nhóm 03)
- Mã đề tài: **DT070**
- Tên đề tài: **Hàng đợi bằng danh sách liên kết có đầu và cuối**
- Giảng viên phụ trách: **Hồ Nhựt Minh**
- Giáo trình căn cứ: `Giao-trinh-Cau-truc-du-lieu-va-Giai-thuat-INT1306.pdf`
  - Chương 5, mục 5.2.3.3 (Thêm cuối), mục 5.4 (Hàng đợi), Bài 5.2.
  - Trang in: 118–119, 130, 132 (Trang PDF: 130–131, 142, 144).
- Kho lưu trữ GitHub: `https://github.com/Noname06-PTIT/DT070_LinkedQueue`
- Ngôn ngữ lập trình: **Julia 1.12.7** (chỉ sử dụng thư viện chuẩn `Test`, `Printf`).

## Cấu trúc mã nguồn đề tài

```text
N24DCDT086_DT070_PhamDoDuyThanh_MaNguon/
├── docs/
│   ├── anh_ket_qua/          # Chứa 11 ảnh minh chứng thực thi (01_vi_du_1.png -> 11_github_repo_commit.png)
│   └── logs/                 # Chứa toàn bộ nhật ký stdout thực chạy của 8 demo, test và khảo sát
├── scripts/
│   ├── test_catalog.jl       # Danh mục tra cứu kết quả test (26 ca kiểm thử độc lập)
│   └── trace_and_scales.jl   # Bảng trace chi tiết Ví dụ 1, Ví dụ 2 và khảo sát 3 quy mô (n=10, 50, 200)
├── src/
│   ├── LinkedQueue.jl        # Cài đặt cấu trúc HangDoi với 2 con trỏ dau và cuoi, độ phức tạp O(1)
│   └── DeTai.jl              # Module chuyển tiếp giao diện tương thích
├── test/
│   ├── runtests.jl           # Bộ kiểm thử tự động toàn diện (26 test cases, 244 asserts PASS 100%)
│   └── verify_exhaustive.jl  # Oracle đối chứng độc lập với Vector Queue (20.000 thao tác ngẫu nhiên)
├── .gitignore                # Cấu hình bỏ qua tệp rác, tệp tạm
├── demo.jl                   # Chương trình minh họa 8 ca chuẩn (A01 -> A08) và chế độ nhập bàn phím
├── Dong_goi_ZIP.ps1          # Kịch bản PowerShell đóng gói mã nguồn chuẩn Classroom
├── README.md                 # Tài liệu hướng dẫn sử dụng và thuyết minh kỹ thuật
└── Run_all.ps1               # Kịch bản thực thi toàn bộ quy trình kiểm thử và demo bằng một lệnh
```

## Hướng dẫn chạy chương trình

### 1. Thực thi toàn bộ kiểm thử và demo bằng 1 lệnh
Mở PowerShell trong thư mục này và chạy:
```powershell
powershell -ExecutionPolicy Bypass -File .\Run_all.ps1
```
hoặc nếu quyền thực thi đã được cấp:
```powershell
.\Run_all.ps1
```

### 2. Chạy riêng từng ca demo (tương ứng ảnh minh chứng A01 - A08)
```powershell
# Chạy toàn bộ 8 ca demo
julia --startup-file=no demo.jl

# Chạy riêng từng ca:
julia --startup-file=no demo.jl --ca=1   # A01: Ví dụ 1 trên phiếu (them(4); them(7); lay(); them(9))
julia --startup-file=no demo.jl --ca=2   # A02: Ví dụ 2 trên phiếu (them(5); lay(); them(8))
julia --startup-file=no demo.jl --ca=3   # A03: Ca tự thiết kế 1 (Buffer hàng đợi đa chu kỳ)
julia --startup-file=no demo.jl --ca=4   # A04: Ca tự thiết kế 2 (Giá trị âm, số 0 trong [-1000, 1000])
julia --startup-file=no demo.jl --ca=5   # A05: Ca biên 1 (Hàng đợi rỗng, Underflow an toàn)
julia --startup-file=no demo.jl --ca=6   # A06: Ca biên 2 (Phần tử trùng lặp giá trị)
julia --startup-file=no demo.jl --ca=7   # A07: Ca biên 3 (Chuyển trạng thái rỗng và xem đầu hai lần)
julia --startup-file=no demo.jl --ca=8   # A08: Xử lý dữ liệu không hợp lệ / ngoài hợp đồng
```

### 3. Chế độ nhập bàn phím tương tác
```powershell
julia --startup-file=no demo.jl --nhap
```

### 4. Chạy bộ kiểm thử tự động
```powershell
# Chạy 26 ca kiểm thử với 244 phép kiểm
julia --startup-file=no test/runtests.jl

# Chạy oracle đối chứng độc lập 20.000 thao tác
julia --startup-file=no test/verify_exhaustive.jl

# Xuất danh mục bảng test catalog
julia --startup-file=no scripts/test_catalog.jl

# Xuất bảng trace chi tiết và khảo sát quy mô
julia --startup-file=no scripts/trace_and_scales.jl
```

## Kết quả kiểm chứng kỹ thuật

1. **Bộ kiểm thử tự động**:
   - Gồm **26 ca kiểm thử độc lập** (17 ca chức năng T01..T17, 9 ca validator V01..V09).
   - Tổng cộng **244 phép assert `@test`**, kết quả **100% PASS** với mã thoát 0.
2. **Oracle đối chứng độc lập**:
   - Mô hình tham chiếu `Vector Queue` đối chiếu qua **20.000 thao tác ngẫu nhiên**.
   - Mọi trạng thái, giá trị phần tử, độ dài, con trỏ và bất biến đều trùng khớp tuyệt đối.
3. **Bất biến cấu trúc được bảo toàn**:
   - `so_luong == 0` $\iff$ `dau === nothing` và `cuoi === nothing`.
   - `so_luong > 0` $\iff$ `dau !== nothing` và `cuoi !== nothing`, đồng thời `cuoi.tiep === nothing`.
   - Số nút duyệt thực tế từ `dau` qua các liên kết luôn bằng biến đếm `so_luong`.
4. **Khảo sát hiệu năng (Khảo sát 3 quy mô n = 10, 50, 200)**:
   - Với con trỏ `cuoi`: Thao tác thêm luôn đạt $O(1)$ với đúng 3 phép toán con trỏ, $m$ lệnh thêm chỉ mất $3m$ phép toán ($O(m)$).
   - Nếu bỏ con trỏ `cuoi`: Thao tác thêm phải duyệt từ đầu mất $rac{m(m-1)}{2} + 2m$ phép toán ($O(m^2)$).
   - Tại quy mô $m = 200$, cấu trúc có con trỏ cuối tiết kiệm tới **33.8 lần** chi phí liên kết.

## Đóng gói nộp bài Classroom

Để tạo tệp nén ZIP mã nguồn nộp bài, chạy script:
```powershell
powershell -ExecutionPolicy Bypass -File .\Dong_goi_ZIP.ps1
```
Tệp ZIP tạo ra sẽ mang tên: `N24DCDT086_DT070_PhamDoDuyThanh_MaNguon.zip`.
