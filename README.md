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
- Kho lưu trữ GitHub: `https://github.com/Noname06-PTIT/DT070-N24DCDT086--PhamDoDuyThanh`
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
├── interactive_demo.html     # Giao diện Web mô phỏng trực quan tương tác (Dark/Light mode, 8 ca Demo, O(1))
├── N24DCDT086_DT070_PhamDoDuyThanh_ThongTinNop.txt # Phiếu thông tin nộp bài chính thức
├── README.md                 # Tài liệu hướng dẫn sử dụng và thuyết minh kỹ thuật
└── Run_all.ps1               # Kịch bản thực thi toàn bộ quy trình kiểm thử và demo bằng một lệnh
```

## Hướng dẫn thực thi (Lệnh chạy chương trình)

### ⚡ 1. Chạy tự động toàn bộ bằng 1 lệnh (Khuyên dùng)
Tự động chạy toàn bộ 26 ca kiểm thử, đối chứng oracle 20.000 thao tác và 8 ca demo:
```powershell
powershell -ExecutionPolicy Bypass -File .\Run_all.ps1
```

### 🎯 2. Chạy từng lệnh riêng biệt theo yêu cầu phiếu
Mở terminal/PowerShell tại thư mục dự án và chọn lệnh cần chạy:

```bash
# Chạy Ví dụ 1 trên phiếu – Các phép toán cơ bản (thêm 4, 7, lấy, thêm 9)
julia --startup-file=no demo.jl --ca=1

# Chạy Ví dụ 2 trên phiếu – Mô phỏng hàng đợi xóa sạch về rỗng (thêm 5, lấy, thêm 8)
julia --startup-file=no demo.jl --ca=2

# Nhập dữ liệu mới từ bàn phím (Chế độ tương tác tay)
julia --startup-file=no demo.jl --nhap

# Chạy toàn bộ bộ kiểm thử tự động (26 ca độc lập, 244 asserts PASS 100%)
julia --startup-file=no test/runtests.jl

# Chạy toàn bộ 8 ca demo liên tiếp (A01 -> A08)
julia --startup-file=no demo.jl
```

### 📋 Bảng tra cứu lệnh nhanh

| Mục tiêu kiểm tra | Lệnh thực thi trong PowerShell / Terminal | Kết quả mong đợi |
| :--- | :--- | :--- |
| **Chạy 1 lệnh tất cả** | `powershell -ExecutionPolicy Bypass -File .\Run_all.ps1` | Toàn bộ demo và test PASS 100% |
| **Ví dụ 1 (Ảnh A01)** | `julia --startup-file=no demo.jl --ca=1` | Lấy ra 4, hàng đợi còn `[7, 9]` |
| **Ví dụ 2 (Ảnh A02)** | `julia --startup-file=no demo.jl --ca=2` | Lấy ra 5, hàng đợi còn `[8]` |
| **Nhập tương tác tay** | `julia --startup-file=no demo.jl --nhap` | Nhập số tùy ý trong `[-1000, 1000]` |
| **Bộ kiểm thử tự động** | `julia --startup-file=no test/runtests.jl` | 26/26 ca PASS, 244/244 assert |
| **Oracle đối chứng** | `julia --startup-file=no test/verify_exhaustive.jl` | 20.000 thao tác ngẫu nhiên PASS |
| **Mô phỏng trực quan Web** | Mở tệp `interactive_demo.html` trên trình duyệt | Giao diện đồ họa trực quan, Dark/Light mode, 8 ca demo |

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

