# ============================================================
#  src/LinkedQueue.jl
#  De tai DT070 – Hang doi bang danh sach lien ket co dau va cuoi
#  Mon hoc  : Cau truc Du lieu va Giai thuat (INT13185) – PTIT
#  Sinh vien: Pham Do Duy Thanh  |  MSSV: N24DCDT086
#  Can cu   : Giao trinh CTDL&GT PTIT, Chuong 2 (Hang doi – Queue)
# ============================================================

# ─────────────────────────────────────────────────────────────
#  CAU TRUC NUT (Node)
# ─────────────────────────────────────────────────────────────
"""
    Node{T}

Mot nut trong danh sach lien ket don.
Truong `data` luu gia tri, `next` tro den nut ke tiep.
"""
mutable struct Node{T}
    data::T
    next::Union{Node{T}, Nothing}
end
Node{T}(data::T) where T = Node{T}(data, nothing)

# ─────────────────────────────────────────────────────────────
#  CAU TRUC HANG DOI (LinkedQueue)
# ─────────────────────────────────────────────────────────────
"""
    LinkedQueue{T}

Hang doi (Queue) duoc cai dat bang danh sach lien ket don
voi hai con tro `head` (dau hang – noi lay ra) va `tail`
(cuoi hang – noi them vao).  Do phuc tap moi phep: O(1).
"""
mutable struct LinkedQueue{T}
    head::Union{Node{T}, Nothing}   # Con tro DAU hang (Front)
    tail::Union{Node{T}, Nothing}   # Con tro CUOI hang (Rear)
    n::Int                          # So phan tu hien tai
end

""" Tao hang doi rong kieu T. """
LinkedQueue{T}() where T = LinkedQueue{T}(nothing, nothing, 0)

""" Tao hang doi rong kieu Any (tien ich). """
LinkedQueue() = LinkedQueue{Any}()


# ─────────────────────────────────────────────────────────────
#  CAC PHEP TOAN CO BAN
# ─────────────────────────────────────────────────────────────

"""
    Base.isempty(q) → Bool

Kiem tra hang doi co rong hay khong.
Tra ve `true` neu rong, `false` neu con phan tu.
"""
Base.isempty(q::LinkedQueue) = (q.n == 0)

"""
    Base.length(q) → Int

Tra ve so luong phan tu dang co trong hang doi.
"""
Base.length(q::LinkedQueue) = q.n


"""
    enqueue!(q, val) → q

Them phan tu `val` vao CUOI hang doi (O(1)).
Cap nhat con tro `tail`; neu hang rong thi `head` = `tail` = nut moi.
"""
function enqueue!(q::LinkedQueue{T}, val) where T
    node = Node{T}(convert(T, val))
    if isempty(q)
        q.head = node
        q.tail = node
    else
        q.tail.next = node
        q.tail = node
    end
    q.n += 1
    return q
end


"""
    dequeue!(q) → val

Lay va xoa phan tu o DAU hang doi (O(1)).
Cap nhat con tro `head`; neu hang tro nen rong thi `tail = nothing`.
Nem `ArgumentError` neu hang doi rong.
"""
function dequeue!(q::LinkedQueue)
    if isempty(q)
        throw(ArgumentError("dequeue!: hang doi dang RONG, khong the lay phan tu."))
    end
    val    = q.head.data
    q.head = q.head.next
    if q.head === nothing
        q.tail = nothing
    end
    q.n -= 1
    return val
end


"""
    peek(q) → val

Tra ve phan tu o DAU hang doi ma khong xoa (O(1)).
Nem `ArgumentError` neu hang doi rong.
"""
function peek(q::LinkedQueue)
    if isempty(q)
        throw(ArgumentError("peek: hang doi dang RONG."))
    end
    return q.head.data
end

# Biet danh (alias) cho quen thuoc
front(q::LinkedQueue) = peek(q)


"""
    rear(q) → val

Tra ve phan tu o CUOI hang doi ma khong xoa (O(1)).
Nem `ArgumentError` neu hang doi rong.
"""
function rear(q::LinkedQueue)
    if isempty(q)
        throw(ArgumentError("rear: hang doi dang RONG."))
    end
    return q.tail.data
end


"""
    clear!(q) → q

Xoa toan bo phan tu trong hang doi; dat head = tail = nothing, n = 0.
"""
function clear!(q::LinkedQueue)
    q.head = nothing
    q.tail = nothing
    q.n    = 0
    return q
end


# ─────────────────────────────────────────────────────────────
#  TIEN ICH HIEN THI
# ─────────────────────────────────────────────────────────────

"""
    to_array(q) → Vector

Chuyen hang doi thanh mang theo thu tu (dau → cuoi).
"""
function to_array(q::LinkedQueue)
    arr = Any[]
    cur = q.head
    while cur !== nothing
        push!(arr, cur.data)
        cur = cur.next
    end
    return arr
end


"""
    display_queue(q; label="Hang doi")

In hang doi ra man hinh theo dinh dang:
  label (dau→cuoi): A → B → C
  head=A  tail=C  size=3
"""
function display_queue(q::LinkedQueue; label::String = "Hang doi")
    if isempty(q)
        println("$label: [RONG]")
    else
        arr = to_array(q)
        println("$label (dau→cuoi): ", join(string.(arr), " → "))
        println("  head=$(q.head.data)  tail=$(q.tail.data)  size=$(q.n)")
    end
end
