# Hang doi DSLK co dau va cuoi (DT070)

> **Do an mon hoc Cau truc Du lieu va Giai thuat (INT13185) – Nhom 03**
> Hoc vien Cong nghe Buu chinh Vien thong (PTIT)

![Julia](https://img.shields.io/badge/Julia-1.12-purple)
![Tests](https://img.shields.io/badge/Tests-22%20ca%20%7C%20PASS-brightgreen)
![CI](https://github.com/Noname06-PTIT/DT070-N24DCDT086--PhamDoDuyThanh/actions/workflows/julia.yml/badge.svg)

---

## THONG TIN DO AN & HUONG DAN DOI CHIEU (Theo Rubric)

### 1. Nhan dien

| Truong | Noi dung |
|---|---|
| **Ho va ten** | Pham Do Duy Thanh |
| **MSSV** | N24DCDT086 |
| **Lop** | D24CQDT... (INT13185 – Nhom 03) |
| **Ma de** | DT070 |
| **Ten de** | Hang doi bang danh sach lien ket co dau va cuoi |
| **Duong dan phieu** | `05_Minh_chung_cu_the_91_de_tai.docx` (Muc DT070) |
| **Can cu giao trinh** | Giao trinh CTDL&GT PTIT – Chuong 2: Cau truc du lieu tuyen tinh (Hang doi – Queue), muc cai dat DSLK don co hai con tro head va tail |

### 2. Moi truong

| Thanh phan | Chi tiet |
|---|---|
| **Ngon ngu** | Julia 1.12.7 |
| **Thu vien** | Chi dung thu vien chuan `Test` (tich hop san) |
| **Cai dat Julia** | https://julialang.org/downloads/ |
| **Kiem tra phien ban** | `julia --version` |

### 3. Lenh

```bash
# Chay Vi du 1 – Cac phep toan co ban
julia --startup-file=no demo.jl --ca=1

# Chay Vi du 2 – Mo phong hang cho xep hang
julia --startup-file=no demo.jl --ca=2

# Nhap du lieu moi (tuong tac tay)
julia --startup-file=no demo.jl --nhap

# Chay toan bo bo kiem thu (hien thi chi tiet)
julia --startup-file=no test/runtests.jl

# Hoac chay mot lenh chay tat ca (Windows)
powershell -ExecutionPolicy Bypass -File .\Run_all.ps1
```

### 4. Quy uoc

- **Input:** Phan tu bat ky kieu T (mac dinh `Int` trong demo).
- **Enqueue (them):** Them vao CUOI hang – cap nhat con tro `tail` – O(1).
- **Dequeue (lay):** Lay tu DAU hang – cap nhat con tro `head` – O(1).
- **Xu ly loi:** Nem `ArgumentError` khi `dequeue!`, `peek`, `rear` tren hang rong.
- **Thu tu chay:** FIFO (First In – First Out); ca kiem tra V08 chay 1000 phan tu.

### 5. Minh chung

- **Thu muc anh:** `docs/anh_ket_qua/` (chua anh chup man hinh A01 – A11)
- **So ca kiem thu:** 22 ca (T01–T14 chuc nang, V01–V08 ngoai le)
- **Tong phep kiem:** 127 / 127 dat (100%)
- **SHA C (chay va chup anh):** 614c07b14fc431a1c808b9764b5a30b72112aa98
- **CI tu dong:** GitHub Actions tu dong chay `test/runtests.jl` moi lan push

---

## Cau truc thu muc

```text
DT070-N24DCDT086--PhamDoDuyThanh/
├── .github/
│   └── workflows/
│       └── julia.yml            # CI/CD tu dong – GitHub Actions
├── docs/
│   └── anh_ket_qua/             # Anh minh chung A01 – A11
├── src/
│   └── LinkedQueue.jl           # Thuat toan loi: hang doi DSLK co dau & cuoi
├── test/
│   └── runtests.jl              # 22 ca kiem thu, 127 phep kiem – dat 100%
├── .gitignore
├── demo.jl                      # File chay minh hoa (--ca=1, --ca=2, --nhap)
├── Run_all.ps1                  # Script Windows chay tat ca mot lenh
└── README.md
```

## Thuat toan

Hang doi (Queue) duoc cai dat bang **danh sach lien ket don** voi **hai con tro**:

```
  HEAD (dau)                       TAIL (cuoi)
    |                                  |
    v                                  v
  [A] --> [B] --> [C] --> [D] --> [E] --> nil

  Enqueue: them vao sau [E] → cap nhat TAIL
  Dequeue: lay tu [A]      → cap nhat HEAD
  Do phuc tap moi phep:    O(1)
```

| Phep toan | Ham Julia | Do phuc tap |
|---|---|---|
| Khoi tao | `LinkedQueue{T}()` | O(1) |
| Kiem tra rong | `isempty(q)` | O(1) |
| Them cuoi | `enqueue!(q, val)` | O(1) |
| Lay dau | `dequeue!(q)` | O(1) |
| Xem dau | `peek(q)` / `front(q)` | O(1) |
| Xem cuoi | `rear(q)` | O(1) |
| Kich thuoc | `length(q)` | O(1) |
| Xoa het | `clear!(q)` | O(1) |
| Chuyen mang | `to_array(q)` | O(n) |

## Vi du su dung nhanh

```julia
include("src/LinkedQueue.jl")

q = LinkedQueue{Int}()
enqueue!(q, 10); enqueue!(q, 20); enqueue!(q, 30)
display_queue(q)
# Hang doi (dau→cuoi): 10 → 20 → 30
#   head=10  tail=30  size=3

println(peek(q))   # 10
println(rear(q))   # 30
println(dequeue!(q))  # 10
println(length(q))    # 2
```
