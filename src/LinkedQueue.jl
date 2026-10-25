module LinkedQueue

export Node, HangDoi, Queue,
       tao_hang_doi, create_queue, la_rong, is_empty, kich_thuoc, queue_size,
       them!, enqueue!, lay!, dequeue!, xem_dau, peek_front, dau_hang,
       xem_cuoi, peek_rear, to_array, in_hang, in_so_do, print_diagram,
       kiem_tra_bat_bien, check_invariants, dem_so_nut_duyet,
       kiem_tra_dau_vao, validate_input, giai_bai, solve,
       dem_phep_toan_them, dem_phep_toan_khong_cuoi

"""
    Node{T}

Nút trong danh sách liên kết đơn:
- `gia_tri`: Dữ liệu lưu trữ tại nút (giá trị nguyên trong khoảng -1000..1000).
- `tiep`: Tham chiếu đến nút kế tiếp (hoặc `nothing` nếu là nút cuối).
"""
mutable struct Node{T}
    gia_tri::T
    tiep::Union{Node{T}, Nothing}
end

Node(x::T) where T = Node{T}(x, nothing)

"""
    HangDoi{T} (Queue{T})

Hàng đợi (Queue) FIFO cài đặt bằng danh sách liên kết đơn có 2 con trỏ:
- `dau` (head / front): Trỏ tới nút ở đầu hàng đợi (nơi lấy ra / Dequeue).
- `cuoi` (tail / rear): Trỏ tới nút ở cuối hàng đợi (nơi thêm vào / Enqueue).
- `so_luong`: Số lượng phần tử hiện có trong hàng đợi.

Độ phức tạp thời gian:
- `them!` / `enqueue!`: O(1)
- `lay!` / `dequeue!`: O(1)
- `dau_hang` / `xem_dau` / `peek_front`: O(1)
- `xem_cuoi` / `peek_rear`: O(1)
- `la_rong` / `is_empty`: O(1)
- `kich_thuoc` / `queue_size`: O(1)
"""
mutable struct HangDoi{T}
    dau::Union{Node{T}, Nothing}
    cuoi::Union{Node{T}, Nothing}
    so_luong::Int
end

const Queue = HangDoi

"""
    tao_hang_doi(T=Int) / create_queue(T=Int)

Khởi tạo một hàng đợi rỗng kiểu phần tử `T` (mặc định là `Int`).
Độ phức tạp: O(1).
"""
function tao_hang_doi(::Type{T}=Int) where T
    return HangDoi{T}(nothing, nothing, 0)
end
const create_queue = tao_hang_doi

"""
    la_rong(q::HangDoi) / is_empty(q::HangDoi)

Kiểm tra hàng đợi có đang rỗng hay không.
Trả về `true` nếu rỗng (so_luong == 0), `false` nếu có ít nhất 1 phần tử.
Độ phức tạp: O(1).
"""
function la_rong(q::HangDoi)::Bool
    return q.so_luong == 0
end
const is_empty = la_rong

"""
    kich_thuoc(q::HangDoi) / queue_size(q::HangDoi)

Trả về số lượng phần tử hiện có trong hàng đợi.
Độ phức tạp: O(1).
"""
function kich_thuoc(q::HangDoi)::Int
    return q.so_luong
end
const queue_size = kich_thuoc

"""
    dem_so_nut_duyet(q::HangDoi)

Duyệt danh sách từ `dau` tới `cuoi` qua các liên kết `tiep` để đếm số nút thực tế.
Dùng để đối chiếu với biến `so_luong` (yêu cầu thêm của phiếu đề tài DT070).
Độ phức tạp: O(n).
"""
function dem_so_nut_duyet(q::HangDoi)::Int
    dem = 0
    curr = q.dau
    while curr !== nothing
        dem += 1
        curr = curr.tiep
        if dem > q.so_luong + 10  # Chặn chống lặp vô hạn nếu có chu trình
            return -1
        end
    end
    return dem
end

"""
    kiem_tra_bat_bien(q::HangDoi) / check_invariants(q::HangDoi)

Kiểm tra các bất biến hình thức theo yêu cầu đề tài DT070:
1. `so_luong == 0` <==> `dau === nothing` và `cuoi === nothing`.
2. `so_luong > 0` <==> `dau !== nothing` và `cuoi !== nothing` và `cuoi.tiep === nothing`.
3. Số lượng nút duyệt được từ `dau` đến cuối bằng đúng `so_luong`.
4. Nút cuối cùng duyệt được qua liên kết `tiep` phải chính là tham chiếu `cuoi`.
"""
function kiem_tra_bat_bien(q::HangDoi)::Bool
    if q.so_luong == 0
        return q.dau === nothing && q.cuoi === nothing
    end
    if q.dau === nothing || q.cuoi === nothing
        return false
    end
    if q.cuoi.tiep !== nothing
        return false
    end
    dem = 0
    curr = q.dau
    last_node = nothing
    while curr !== nothing
        dem += 1
        last_node = curr
        curr = curr.tiep
        if dem > q.so_luong + 1
            return false
        end
    end
    return (dem == q.so_luong) && (last_node === q.cuoi)
end
const check_invariants = kiem_tra_bat_bien

"""
    them!(q::HangDoi{T}, gia_tri::T) / enqueue!(q, val)

Thêm một phần tử vào cuối hàng đợi (Enqueue) theo mục 5.2.3.3 và 5.4 giáo trình.
- Nếu hàng rỗng: cả `dau` và `cuoi` cùng trỏ tới nút mới.
- Nếu hàng có phần tử: `cuoi.tiep = nut_moi`, sau đó cập nhật `cuoi = nut_moi`.
Độ phức tạp: O(1).
"""
function them!(q::HangDoi{T}, gia_tri::T) where T
    nut_moi = Node{T}(gia_tri, nothing)
    if la_rong(q)
        q.dau = nut_moi
        q.cuoi = nut_moi
    else
        q.cuoi.tiep = nut_moi
        q.cuoi = nut_moi
    end
    q.so_luong += 1
    @assert kiem_tra_bat_bien(q) "Bất biến bị vi phạm sau khi them!"
    return q
end
const enqueue! = them!

"""
    lay!(q::HangDoi{T}) / dequeue!(q)

Lấy và xóa phần tử ở đầu hàng đợi (Dequeue) theo mục 5.4 giáo trình.
- Đọc giá trị tại `dau`.
- Cập nhật `dau = dau.tiep`.
- Nếu sau khi lấy `dau === nothing` (hàng rỗng), cập nhật `cuoi = nothing`.
Độ phức tạp: O(1).
Ném ra `ArgumentError` nếu hàng đợi rỗng (Underflow).
"""
function lay!(q::HangDoi{T}) where T
    if la_rong(q)
        throw(ArgumentError("Lỗi: Hàng đợi rỗng, không thể lấy phần tử (Underflow)!"))
    end
    gia_tri_dau = q.dau.gia_tri
    q.dau = q.dau.tiep
    q.so_luong -= 1
    if q.dau === nothing
        q.cuoi = nothing
    end
    @assert kiem_tra_bat_bien(q) "Bất biến bị vi phạm sau khi lay!"
    return gia_tri_dau
end
const dequeue! = lay!

"""
    xem_dau(q::HangDoi{T}) / peek_front(q) / dau_hang(q)

Xem giá trị phần tử ở đầu hàng đợi mà không xóa.
Độ phức tạp: O(1).
"""
function xem_dau(q::HangDoi{T}) where T
    if la_rong(q)
        throw(ArgumentError("Lỗi: Hàng đợi rỗng, không thể xem đầu!"))
    end
    return q.dau.gia_tri
end
const peek_front = xem_dau
const dau_hang = xem_dau

"""
    xem_cuoi(q::HangDoi{T}) / peek_rear(q)

Xem giá trị phần tử ở cuối hàng đợi mà không xóa.
Độ phức tạp: O(1).
"""
function xem_cuoi(q::HangDoi{T}) where T
    if la_rong(q)
        throw(ArgumentError("Lỗi: Hàng đợi rỗng, không thể xem cuối!"))
    end
    return q.cuoi.gia_tri
end
const peek_rear = xem_cuoi

"""
    to_array(q::HangDoi{T})

Chuyển đổi toàn bộ hàng đợi thành một mảng từ đầu đến cuối theo thứ tự FIFO.
"""
function to_array(q::HangDoi{T})::Vector{T} where T
    ket_qua = T[]
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
    arr = to_array(q)
    println("FIFO: ", arr, " | n = ", q.so_luong)
end

"""
    in_so_do(q::HangDoi; tieu_de::String="") / print_diagram

In sơ đồ trực quan thể hiện con trỏ dau, cuoi và danh sách liên kết.
Đáp ứng yêu cầu Lần vết chuyên biệt (C2, C3) trong phiếu đề tài.
"""
function in_so_do(q::HangDoi; tieu_de::String="")
    if !isempty(tieu_de)
        println("=== $tieu_de ===")
    end
    println("So luong n: ", q.so_luong)
    if la_rong(q)
        println("Trang thai: RONG")
        println("  dau  (head) --> nothing")
        println("  cuoi (tail) --> nothing")
    else
        val_dau = q.dau.gia_tri
        val_cuoi = q.cuoi.gia_tri
        println("  dau  (head) --> Node($val_dau)")
        println("  cuoi (tail) --> Node($val_cuoi)")
        print("  Chuoi lien ket: ")
        curr = q.dau
        ds = String[]
        while curr !== nothing
            push!(ds, "[$(curr.gia_tri)]")
            curr = curr.tiep
        end
        println(join(ds, " -> ") * " -> nothing")
    end
    println("  Bat bien hop le: ", kiem_tra_bat_bien(q))
    println()
end
const print_diagram = in_so_do

"""
    kiem_tra_dau_vao(du_lieu) / validate_input(du_lieu)

Hợp đồng input/output theo phiếu DT070:
- Dãy tối đa 1000 lệnh hoặc giá trị.
- Giá trị x nguyên nằm trong đoạn [-1000, 1000].
- Từ chối nếu dữ liệu không đúng quy ước.
"""
function kiem_tra_dau_vao(du_lieu)
    if du_lieu === nothing
        throw(ArgumentError("Lỗi: Dữ liệu đầu vào là nothing!"))
    end
    if !(du_lieu isa Vector)
        throw(ArgumentError("Lỗi: Dữ liệu phải là một Vector chứa các phần tử hoặc lệnh thao tác!"))
    end
    if length(du_lieu) > 1000
        throw(ArgumentError("Lỗi: Số lượng lệnh vượt quá giới hạn cho phép (tối đa 1000 lệnh)!"))
    end
    for (idx, item) in enumerate(du_lieu)
        if item isa Tuple
            cmd = item[1]
            if !(cmd in (:them, :lay, :dau_hang, :xem_dau, :xem_cuoi, :enqueue, :dequeue, :peek))
                throw(ArgumentError("Lỗi tại phần tử $idx: Lệnh '$cmd' không hợp lệ!"))
            end
            if (cmd in (:them, :enqueue))
                if length(item) < 2
                    throw(ArgumentError("Lỗi tại phần tử $idx: Lệnh thêm cần có giá trị kèm theo!"))
                end
                val = item[2]
                if !(val isa Integer)
                    throw(ArgumentError("Lỗi tại phần tử $idx: Giá trị thêm phải là số nguyên!"))
                end
                if !( -1000 <= val <= 1000 )
                    throw(ArgumentError("Lỗi tại phần tử $idx: Giá trị $val nằm ngoài phạm vi [-1000, 1000]!"))
                end
            end
        elseif item isa Integer
            if !( -1000 <= item <= 1000 )
                throw(ArgumentError("Lỗi tại phần tử $idx: Giá trị $item nằm ngoài phạm vi [-1000, 1000]!"))
            end
        else
            throw(ArgumentError("Lỗi tại phần tử $idx: Phần tử '$item' không phải số nguyên hoặc lệnh hợp lệ!"))
        end
    end
    return true
end
const validate_input = kiem_tra_dau_vao

"""
    giai_bai(du_lieu) / solve(du_lieu)

Thực hiện một chuỗi thao tác (hoặc nạp một danh sách số nguyên) vào hàng đợi.
Trả về bộ kết quả gồm trạng thái hàng đợi cuối, mảng phần tử, số lượng và nhật ký thao tác.
"""
function giai_bai(du_lieu)
    kiem_tra_dau_vao(du_lieu)
    q = tao_hang_doi(Int)
    nhat_ky = String[]
    
    for item in du_lieu
        if item isa Tuple
            cmd = item[1]
            if cmd in (:them, :enqueue)
                val = Int(item[2])
                them!(q, val)
                push!(nhat_ky, "them($val) -> FIFO=$(to_array(q)), n=$(q.so_luong)")
            elseif cmd in (:lay, :dequeue)
                val = lay!(q)
                push!(nhat_ky, "lay() -> trả về $val, còn lại FIFO=$(to_array(q)), n=$(q.so_luong)")
            elseif cmd in (:dau_hang, :xem_dau, :peek)
                val = xem_dau(q)
                push!(nhat_ky, "dau_hang() -> $val, FIFO=$(to_array(q)), n=$(q.so_luong)")
            elseif cmd in (:xem_cuoi,)
                val = xem_cuoi(q)
                push!(nhat_ky, "xem_cuoi() -> $val, FIFO=$(to_array(q)), n=$(q.so_luong)")
            end
        elseif item isa Integer
            val = Int(item)
            them!(q, val)
            push!(nhat_ky, "them($val) -> FIFO=$(to_array(q)), n=$(q.so_luong)")
        end
    end
    
    return (
        hang_doi = q,
        mang_ket_qua = to_array(q),
        so_luong = kich_thuoc(q),
        nhat_ky = nhat_ky
    )
end
const solve = giai_bai

"""
    dem_phep_toan_them(m::Int)

Mô phỏng đếm số phép toán liên kết (đọc/ghi con trỏ) khi thêm m phần tử
vào hàng đợi có cả hai con trỏ `dau` và `cuoi`.
Mỗi lệnh thêm thực hiện đúng 3 thao tác con trỏ:
- Tạo nút mới: nut.tiep = nothing (1 ghi)
- Nối sau cuối: cuoi.tiep = nut_moi (1 ghi)
- Cập nhật đuôi: cuoi = nut_moi (1 ghi)
Tổng số phép toán là 3 * m = O(m) (hằng số O(1) cho mỗi lệnh).
"""
function dem_phep_toan_them(m::Int)
    return m * 3
end

"""
    dem_phep_toan_khong_cuoi(m::Int)

Mô phỏng đếm số phép toán liên kết khi BỎ con trỏ `cuoi` (chỉ giữ con trỏ `dau`).
Để thêm phần tử thứ k, phải duyệt từ đầu qua k-1 liên kết:
Tổng số phép đọc liên kết = sum_{k=1}^m (k-1) = m*(m-1)/2.
Cộng thêm 2 phép gán liên kết (tạo nút và nối) cho mỗi bước = 2*m.
Tổng = m*(m-1)/2 + 2*m = O(m^2).
"""
function dem_phep_toan_khong_cuoi(m::Int)
    return div(m * (m - 1), 2) + 2 * m
end

end # module LinkedQueue
