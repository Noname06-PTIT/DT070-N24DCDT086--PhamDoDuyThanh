module LinkedQueue

export Node, HangDoi, Queue,
       tao_hang_doi, create_queue, la_rong, is_empty, kich_thuoc, queue_size,
       them!, enqueue!, lay!, dequeue!, xem_dau, peek_front, dau_hang,
       xem_cuoi, peek_rear, to_array, in_hang, in_so_do, print_diagram,
       kiem_tra_bat_bien, check_invariants, dem_so_nut_duyet,
       kiem_tra_dau_vao, validate_input, giai_bai, solve,
       dem_phep_toan_them, dem_phep_toan_khong_cuoi

# ═══════════════════════════════════════════════════════════════════════════════
# §1  HẰNG SỐ GIỚI HẠN (DT070)
# ═══════════════════════════════════════════════════════════════════════════════

"Số lệnh / phần tử tối đa cho phép trong một lần gọi `giai_bai`."
const MAX_LENH = 1000

"Giới hạn dưới cho giá trị phần tử."
const GIA_TRI_MIN = -1000

"Giới hạn trên cho giá trị phần tử."
const GIA_TRI_MAX = 1000

"Biên dư an toàn khi duyệt nút — phát hiện chu trình trong `dem_so_nut_duyet`."
const GIOI_HAN_VONG = 10

"Tập lệnh hợp lệ trong dữ liệu đầu vào."
const LENH_HOP_LE = (:them, :lay, :dau_hang, :xem_dau, :xem_cuoi,
                      :enqueue, :dequeue, :peek)

"Tập lệnh yêu cầu giá trị kèm theo (enqueue)."
const LENH_CAN_GIA_TRI = (:them, :enqueue)

# ═══════════════════════════════════════════════════════════════════════════════
# §2  CẤU TRÚC DỮ LIỆU
# ═══════════════════════════════════════════════════════════════════════════════

"""
    Node{T}

Nút trong danh sách liên kết đơn:
- `gia_tri::T` — Dữ liệu lưu trữ tại nút.
- `tiep::Union{Node{T}, Nothing}` — Tham chiếu đến nút kế tiếp
  (hoặc `nothing` nếu là nút cuối).
"""
mutable struct Node{T}
    gia_tri::T
    tiep::Union{Node{T}, Nothing}
end

Node(x::T) where T = Node{T}(x, nothing)

"""
    HangDoi{T} (Queue{T})

Hàng đợi (Queue) FIFO cài đặt bằng danh sách liên kết đơn có 2 con trỏ:
- `dau`      (head / front) — Nút ở đầu hàng đợi (nơi lấy ra / Dequeue).
- `cuoi`     (tail / rear)  — Nút ở cuối hàng đợi (nơi thêm vào / Enqueue).
- `so_luong` (size)         — Số lượng phần tử hiện có trong hàng đợi.

Độ phức tạp thời gian:
- `them!` / `enqueue!`          : O(1)
- `lay!` / `dequeue!`           : O(1)
- `xem_dau` / `peek_front`     : O(1)
- `xem_cuoi` / `peek_rear`     : O(1)
- `la_rong` / `is_empty`       : O(1)
- `kich_thuoc` / `queue_size`  : O(1)
"""
mutable struct HangDoi{T}
    dau::Union{Node{T}, Nothing}
    cuoi::Union{Node{T}, Nothing}
    so_luong::Int
end

# ═══════════════════════════════════════════════════════════════════════════════
# §3  KHỞI TẠO
# ═══════════════════════════════════════════════════════════════════════════════

"""
    tao_hang_doi(T=Int) → HangDoi{T}
    create_queue(T=Int) → HangDoi{T}

Khởi tạo một hàng đợi rỗng kiểu phần tử `T` (mặc định là `Int`).
Độ phức tạp: O(1).
"""
function tao_hang_doi(::Type{T}=Int) where T
    return HangDoi{T}(nothing, nothing, 0)
end

# ═══════════════════════════════════════════════════════════════════════════════
# §4  THAO TÁC CƠ BẢN (them!, lay!, xem_dau, xem_cuoi)
# ═══════════════════════════════════════════════════════════════════════════════

# ---- Helper: kiểm tra hàng rỗng trước khi thao tác ----
"""Ném `ArgumentError` nếu hàng đợi rỗng, kèm thông báo `hanh_dong`."""
function _yeu_cau_khong_rong(q::HangDoi, hanh_dong::String)
    if q.so_luong == 0
        throw(ArgumentError("Lỗi: Hàng đợi rỗng, không thể $(hanh_dong)!"))
    end
end

"""
    them!(q::HangDoi{T}, gia_tri::T) → q
    enqueue!(q, val) → q

Thêm một phần tử vào cuối hàng đợi (Enqueue) theo mục 5.2.3.3 và 5.4 giáo trình.
- Nếu hàng rỗng: cả `dau` và `cuoi` cùng trỏ tới nút mới.
- Nếu hàng có phần tử: `cuoi.tiep = nut_moi`, sau đó cập nhật `cuoi = nut_moi`.
Độ phức tạp: O(1).
"""
function them!(q::HangDoi{T}, gia_tri::T) where T
    nut_moi = Node{T}(gia_tri, nothing)
    if q.so_luong == 0
        q.dau = nut_moi
    else
        q.cuoi.tiep = nut_moi
    end
    q.cuoi = nut_moi
    q.so_luong += 1
    @assert kiem_tra_bat_bien(q) "Bất biến bị vi phạm sau khi them!"
    return q
end

"""
    lay!(q::HangDoi{T}) → T
    dequeue!(q) → T

Lấy và xóa phần tử ở đầu hàng đợi (Dequeue) theo mục 5.4 giáo trình.
Độ phức tạp: O(1).
Ném `ArgumentError` nếu hàng đợi rỗng (Underflow).
"""
function lay!(q::HangDoi{T}) where T
    _yeu_cau_khong_rong(q, "lấy phần tử (Underflow)")
    gia_tri_dau = q.dau.gia_tri
    q.dau = q.dau.tiep
    q.so_luong -= 1
    if q.dau === nothing
        q.cuoi = nothing
    end
    @assert kiem_tra_bat_bien(q) "Bất biến bị vi phạm sau khi lay!"
    return gia_tri_dau
end

"""
    xem_dau(q) / peek_front(q) / dau_hang(q) → T

Xem giá trị phần tử ở đầu hàng đợi mà không xóa.
Độ phức tạp: O(1).
"""
function xem_dau(q::HangDoi{T}) where T
    _yeu_cau_khong_rong(q, "xem đầu")
    return q.dau.gia_tri
end

"""
    xem_cuoi(q) / peek_rear(q) → T

Xem giá trị phần tử ở cuối hàng đợi mà không xóa.
Độ phức tạp: O(1).
"""
function xem_cuoi(q::HangDoi{T}) where T
    _yeu_cau_khong_rong(q, "xem cuối")
    return q.cuoi.gia_tri
end

# ═══════════════════════════════════════════════════════════════════════════════
# §5  TRUY VẤN (la_rong, kich_thuoc, to_array, in_hang)
# ═══════════════════════════════════════════════════════════════════════════════

"""
    la_rong(q) / is_empty(q) → Bool

Kiểm tra hàng đợi có đang rỗng hay không.
Trả về `true` nếu rỗng (`so_luong == 0`), `false` nếu có ít nhất 1 phần tử.
Độ phức tạp: O(1).
"""
la_rong(q::HangDoi)::Bool = q.so_luong == 0

"""
    kich_thuoc(q) / queue_size(q) → Int

Trả về số lượng phần tử hiện có trong hàng đợi.
Độ phức tạp: O(1).
"""
kich_thuoc(q::HangDoi)::Int = q.so_luong

"""
    to_array(q::HangDoi{T}) → Vector{T}

Chuyển đổi toàn bộ hàng đợi thành một mảng từ đầu đến cuối theo thứ tự FIFO.
Độ phức tạp: O(n).
"""
function to_array(q::HangDoi{T})::Vector{T} where T
    ket_qua = T[]
    sizehint!(ket_qua, q.so_luong)
    curr = q.dau
    while curr !== nothing
        push!(ket_qua, curr.gia_tri)
        curr = curr.tiep
    end
    return ket_qua
end

"""
    in_hang(q::HangDoi)

In dãy phần tử từ đầu đến cuối theo định dạng FIFO.
"""
function in_hang(q::HangDoi)
    println("FIFO: ", to_array(q), " | n = ", q.so_luong)
end

# ═══════════════════════════════════════════════════════════════════════════════
# §6  BẤT BIẾN & KIỂM TRA TOÀN VẸN (DT070)
# ═══════════════════════════════════════════════════════════════════════════════

"""
    dem_so_nut_duyet(q::HangDoi) → Int

Duyệt danh sách từ `dau` tới `cuoi` qua các liên kết `tiep` để đếm số nút thực tế.
Dùng để đối chiếu với biến `so_luong` (yêu cầu thêm của phiếu đề tài DT070).

Trả về `-1` nếu phát hiện có thể tồn tại chu trình (vượt ngưỡng an toàn).
Độ phức tạp: O(n).
"""
function dem_so_nut_duyet(q::HangDoi)::Int
    dem = 0
    curr = q.dau
    gioi_han = q.so_luong + GIOI_HAN_VONG
    while curr !== nothing
        dem += 1
        curr = curr.tiep
        if dem > gioi_han
            return -1   # Có thể chu trình
        end
    end
    return dem
end

"""
    kiem_tra_bat_bien(q::HangDoi) / check_invariants(q) → Bool

Kiểm tra 4 bất biến hình thức theo yêu cầu đề tài DT070:
1. `so_luong == 0`  ⟺  `dau === nothing` và `cuoi === nothing`.
2. `so_luong > 0`   ⟹  `dau !== nothing`, `cuoi !== nothing`, `cuoi.tiep === nothing`.
3. Số nút duyệt được từ `dau` đến cuối bằng đúng `so_luong`.
4. Nút cuối cùng duyệt được qua liên kết `tiep` phải chính là tham chiếu `cuoi`.
"""
function kiem_tra_bat_bien(q::HangDoi)::Bool
    # Bất biến 1: Hàng rỗng ⟺ cả hai con trỏ đều nothing
    if q.so_luong == 0
        return q.dau === nothing && q.cuoi === nothing
    end

    # Bất biến 2: Hàng không rỗng → con trỏ hợp lệ
    if q.dau === nothing || q.cuoi === nothing
        return false
    end
    if q.cuoi.tiep !== nothing
        return false
    end

    # Bất biến 3 & 4: Đếm nút và kiểm tra nút cuối
    dem = 0
    last_node = nothing
    curr = q.dau
    while curr !== nothing
        dem += 1
        last_node = curr
        curr = curr.tiep
        if dem > q.so_luong + 1   # Chặn chống lặp vô hạn
            return false
        end
    end
    return dem == q.so_luong && last_node === q.cuoi
end

# ═══════════════════════════════════════════════════════════════════════════════
# §7  HIỂN THỊ SƠ ĐỒ TRỰC QUAN (Lần vết C2, C3)
# ═══════════════════════════════════════════════════════════════════════════════

"""
    in_so_do(q::HangDoi; tieu_de="") / print_diagram(q; tieu_de="")

In sơ đồ trực quan thể hiện con trỏ `dau`, `cuoi` và chuỗi liên kết.
Đáp ứng yêu cầu Lần vết chuyên biệt (C2, C3) trong phiếu đề tài.
"""
function in_so_do(q::HangDoi; tieu_de::String="")
    io = IOBuffer()
    if !isempty(tieu_de)
        println(io, "=== $tieu_de ===")
    end
    println(io, "So luong n: ", q.so_luong)
    if q.so_luong == 0
        println(io, "Trang thai: RONG")
        println(io, "  dau  (head) --> nothing")
        println(io, "  cuoi (tail) --> nothing")
    else
        println(io, "  dau  (head) --> Node($(q.dau.gia_tri))")
        println(io, "  cuoi (tail) --> Node($(q.cuoi.gia_tri))")
        # Xây chuỗi liên kết
        parts = String[]
        sizehint!(parts, q.so_luong)
        curr = q.dau
        while curr !== nothing
            push!(parts, "[$(curr.gia_tri)]")
            curr = curr.tiep
        end
        println(io, "  Chuoi lien ket: ", join(parts, " -> "), " -> nothing")
    end
    println(io, "  Bat bien hop le: ", kiem_tra_bat_bien(q))
    println(io)                       # Dòng trống ngăn cách
    print(String(take!(io)))          # Flush một lần duy nhất
end

# ═══════════════════════════════════════════════════════════════════════════════
# §8  KIỂM TRA DỮ LIỆU ĐẦU VÀO (Hợp đồng I/O — DT070)
# ═══════════════════════════════════════════════════════════════════════════════

# ---- Helpers nội bộ (không export) ----

"""Kiểm tra một lệnh Tuple tại vị trí `idx`. Ném `ArgumentError` nếu sai."""
function _kiem_tra_lenh(idx::Int, item::Tuple)
    cmd = item[1]
    if !(cmd in LENH_HOP_LE)
        throw(ArgumentError("Lỗi tại phần tử $idx: Lệnh '$cmd' không hợp lệ!"))
    end
    if cmd in LENH_CAN_GIA_TRI
        if length(item) < 2
            throw(ArgumentError("Lỗi tại phần tử $idx: Lệnh thêm cần có giá trị kèm theo!"))
        end
        val = item[2]
        if !(val isa Integer)
            throw(ArgumentError("Lỗi tại phần tử $idx: Giá trị thêm phải là số nguyên!"))
        end
        if !(GIA_TRI_MIN <= val <= GIA_TRI_MAX)
            throw(ArgumentError("Lỗi tại phần tử $idx: Giá trị $val nằm ngoài phạm vi [$GIA_TRI_MIN, $GIA_TRI_MAX]!"))
        end
    end
end

"""Kiểm tra một giá trị Integer tại vị trí `idx`. Ném `ArgumentError` nếu ngoài phạm vi."""
function _kiem_tra_so(idx::Int, val::Integer)
    if !(GIA_TRI_MIN <= val <= GIA_TRI_MAX)
        throw(ArgumentError("Lỗi tại phần tử $idx: Giá trị $val nằm ngoài phạm vi [$GIA_TRI_MIN, $GIA_TRI_MAX]!"))
    end
end

"""
    kiem_tra_dau_vao(du_lieu) / validate_input(du_lieu) → true

Hợp đồng input/output theo phiếu DT070:
- Dữ liệu phải là `Vector`, không `nothing`.
- Dãy tối đa $(MAX_LENH) lệnh hoặc giá trị.
- Giá trị `x` nguyên nằm trong đoạn [$(GIA_TRI_MIN), $(GIA_TRI_MAX)].
- Từ chối nếu dữ liệu không đúng quy ước.
"""
function kiem_tra_dau_vao(du_lieu)
    du_lieu === nothing &&
        throw(ArgumentError("Lỗi: Dữ liệu đầu vào là nothing!"))
    !(du_lieu isa Vector) &&
        throw(ArgumentError("Lỗi: Dữ liệu phải là một Vector chứa các phần tử hoặc lệnh thao tác!"))
    length(du_lieu) > MAX_LENH &&
        throw(ArgumentError("Lỗi: Số lượng lệnh vượt quá giới hạn cho phép (tối đa $MAX_LENH lệnh)!"))

    for (idx, item) in enumerate(du_lieu)
        if item isa Tuple
            _kiem_tra_lenh(idx, item)
        elseif item isa Integer
            _kiem_tra_so(idx, item)
        else
            throw(ArgumentError("Lỗi tại phần tử $idx: Phần tử '$item' không phải số nguyên hoặc lệnh hợp lệ!"))
        end
    end
    return true
end

# ═══════════════════════════════════════════════════════════════════════════════
# §9  GIẢI BÀI — THỰC THI CHUỖI THAO TÁC
# ═══════════════════════════════════════════════════════════════════════════════

# ---- Helper: ghi nhật ký ngắn gọn ----
_ghi_log(nhat_ky, ten, gia_tri, q) =
    push!(nhat_ky, "$ten($gia_tri) -> FIFO=$(to_array(q)), n=$(q.so_luong)")

_ghi_log_lay(nhat_ky, gia_tri, q) =
    push!(nhat_ky, "lay() -> trả về $gia_tri, còn lại FIFO=$(to_array(q)), n=$(q.so_luong)")

_ghi_log_xem(nhat_ky, ten, gia_tri, q) =
    push!(nhat_ky, "$ten() -> $gia_tri, FIFO=$(to_array(q)), n=$(q.so_luong)")

"""
    giai_bai(du_lieu) / solve(du_lieu)

Thực hiện một chuỗi thao tác (hoặc nạp một danh sách số nguyên) vào hàng đợi.

Trả về `NamedTuple` gồm:
- `hang_doi`     — Hàng đợi sau khi xử lý.
- `mang_ket_qua` — Mảng phần tử còn lại.
- `so_luong`     — Số phần tử còn lại.
- `nhat_ky`      — Nhật ký thao tác từng bước.
"""
function giai_bai(du_lieu)
    kiem_tra_dau_vao(du_lieu)
    q = tao_hang_doi(Int)
    nhat_ky = String[]
    sizehint!(nhat_ky, length(du_lieu))

    for item in du_lieu
        if item isa Tuple
            _xu_ly_lenh!(q, item, nhat_ky)
        elseif item isa Integer
            val = Int(item)
            them!(q, val)
            _ghi_log(nhat_ky, "them", val, q)
        end
    end

    return (
        hang_doi     = q,
        mang_ket_qua = to_array(q),
        so_luong     = kich_thuoc(q),
        nhat_ky      = nhat_ky,
    )
end

"""Dispatch lệnh Tuple vào hàm tương ứng."""
function _xu_ly_lenh!(q::HangDoi{Int}, item::Tuple, nhat_ky::Vector{String})
    cmd = item[1]
    if cmd in (:them, :enqueue)
        val = Int(item[2])
        them!(q, val)
        _ghi_log(nhat_ky, "them", val, q)
    elseif cmd in (:lay, :dequeue)
        val = lay!(q)
        _ghi_log_lay(nhat_ky, val, q)
    elseif cmd in (:dau_hang, :xem_dau, :peek)
        val = xem_dau(q)
        _ghi_log_xem(nhat_ky, "dau_hang", val, q)
    elseif cmd in (:xem_cuoi,)
        val = xem_cuoi(q)
        _ghi_log_xem(nhat_ky, "xem_cuoi", val, q)
    end
end

# ═══════════════════════════════════════════════════════════════════════════════
# §10  PHÂN TÍCH ĐỘ PHỨC TẠP — ĐẾM PHÉP TOÁN CON TRỎ
# ═══════════════════════════════════════════════════════════════════════════════

"""
    dem_phep_toan_them(m::Int) → Int

Đếm số phép toán con trỏ khi thêm `m` phần tử với cả hai con trỏ `dau` và `cuoi`.
Mỗi lệnh thêm = 3 thao tác (tạo nút, nối cuối, cập nhật đuôi).
Tổng: `3m` = O(m), tức O(1) cho mỗi lệnh.
"""
dem_phep_toan_them(m::Int) = 3m

"""
    dem_phep_toan_khong_cuoi(m::Int) → Int

Đếm số phép toán khi BỎ con trỏ `cuoi` (chỉ giữ `dau`).
Phần tử thứ k phải duyệt k−1 liên kết → Tổng = m(m−1)/2 + 2m = O(m²).
"""
dem_phep_toan_khong_cuoi(m::Int) = div(m * (m - 1), 2) + 2m

# ═══════════════════════════════════════════════════════════════════════════════
# §11  ALIAS TIẾNG ANH (tương thích ngược)
# ═══════════════════════════════════════════════════════════════════════════════

const Queue          = HangDoi
const create_queue   = tao_hang_doi
const is_empty       = la_rong
const queue_size     = kich_thuoc
const enqueue!       = them!
const dequeue!       = lay!
const peek_front     = xem_dau
const dau_hang       = xem_dau
const peek_rear      = xem_cuoi
const check_invariants = kiem_tra_bat_bien
const print_diagram  = in_so_do
const validate_input = kiem_tra_dau_vao
const solve          = giai_bai

end # module LinkedQueue
