# ============================================================
#  demo.jl  –  Minh hoa thuat toan LinkedQueue (DT070)
#  Sinh vien: Pham Do Duy Thanh | MSSV: N24DCDT086
#
#  Cach chay:
#    julia --startup-file=no demo.jl --ca=1
#    julia --startup-file=no demo.jl --ca=2
#    julia --startup-file=no demo.jl --nhap
# ============================================================

include(joinpath(@__DIR__, "src", "LinkedQueue.jl"))

# ─────────────────────────────────────────────────────────────
#  TIEN ICH IN SO DO TRUC QUAN
# ─────────────────────────────────────────────────────────────
function in_so_do(q::LinkedQueue; ten="Q")
    if isempty(q)
        println("  $ten : [RONG]")
        return
    end
    arr = to_array(q)
    # So do: HEAD → [A] → [B] → [C] ← TAIL
    nhom = ["[$(x)]" for x in arr]
    s = join(nhom, " → ")
    println("  $ten : HEAD → $s ← TAIL   (size=$(length(q)))")
end

function phan_cach(tieu_de::String)
    println()
    println("─" ^ 60)
    println("  $tieu_de")
    println("─" ^ 60)
end

# ─────────────────────────────────────────────────────────────
#  CA DEMO 1 – Thao tac co ban
# ─────────────────────────────────────────────────────────────
function demo_ca_1()
    phan_cach("CA DEMO 1 – Cac phep toan co ban tren hang doi")
    println("  Vi du: n=4, cac phan tu = {10, 20, 30, 40}")
    println()

    q = LinkedQueue{Int}()
    println("  1) Khoi tao hang doi rong:")
    in_so_do(q)
    println("     isempty=$(isempty(q))  size=$(length(q))")

    println()
    println("  2) Enqueue lan luot: 10, 20, 30, 40")
    for v in [10, 20, 30, 40]
        enqueue!(q, v)
        print("     Sau enqueue($v): ")
        in_so_do(q)
    end

    println()
    println("  3) peek (xem phan tu dau ma khong xoa):")
    println("     peek = $(peek(q))")
    println("     rear = $(rear(q))")
    in_so_do(q)

    println()
    println("  4) Dequeue 2 lan:")
    for _ in 1:2
        val = dequeue!(q)
        print("     Da lay ra: $val  →  ")
        in_so_do(q)
    end

    println()
    println("  5) Enqueue them: 50")
    enqueue!(q, 50)
    in_so_do(q)

    println()
    println("  6) Xoa toan bo (clear!):")
    clear!(q)
    in_so_do(q)
    println("     isempty=$(isempty(q))")
end

# ─────────────────────────────────────────────────────────────
#  CA DEMO 2 – Mo phong hang cho in ve
# ─────────────────────────────────────────────────────────────
function demo_ca_2()
    phan_cach("CA DEMO 2 – Mo phong hang cho xep hang mua ve")
    println("  Kich ban: Cua hang mo, khach xep hang, phuc vu tung nguoi.")
    println()

    khach_den  = ["An", "Binh", "Cuong", "Dung", "Em"]
    q = LinkedQueue{String}()

    println("  [1] $( length(khach_den) ) khach xep hang vao cung:")
    for k in khach_den
        enqueue!(q, k)
        println("     → Khach $(k) vao hang.  Hang: $(join(to_array(q), \", \"))")
    end
    println()
    println("  Trang thai hang sau khi xep:")
    in_so_do(q; ten="HangCho")

    println()
    println("  [2] Quy phuc vu tung nguoi (FIFO):")
    buoc = 1
    while !isempty(q)
        nguoi = dequeue!(q)
        println("     Buoc $buoc: Phuc vu [$nguoi].  Con lai: ", isempty(q) ? "[RONG]" : join(to_array(q), ", "))
        buoc += 1
    end
    println()
    println("  Hang cho sau khi phuc vu xong:")
    in_so_do(q; ten="HangCho")
end

# ─────────────────────────────────────────────────────────────
#  CHE DO NHAP TAY
# ─────────────────────────────────────────────────────────────
function demo_nhap()
    phan_cach("CHE DO NHAP TAY – Hang doi so nguyen")
    q = LinkedQueue{Int}()

    println("  Lenh: E <so>  = Enqueue | D = Dequeue | P = Peek | R = Rear")
    println("        C = Clear | L = List | Q = Thoat")
    println()

    while true
        print("  > ")
        dong = strip(readline())
        if isempty(dong); continue; end

        parts = split(dong)
        lenh  = uppercase(parts[1])

        if lenh == "E"
            if length(parts) < 2
                println("  Loi: Nhap so sau E.  Vi du: E 42")
                continue
            end
            val = tryparse(Int, parts[2])
            if val === nothing
                println("  Loi: '$(parts[2])' khong phai so nguyen.")
                continue
            end
            enqueue!(q, val)
            print("  Enqueue($val) → ")
            in_so_do(q)
        elseif lenh == "D"
            try
                val = dequeue!(q)
                print("  Dequeue = $val → ")
                in_so_do(q)
            catch e
                println("  Loi: ", e.msg)
            end
        elseif lenh == "P"
            try
                println("  peek (dau) = $(peek(q))")
            catch e
                println("  Loi: ", e.msg)
            end
        elseif lenh == "R"
            try
                println("  rear (cuoi) = $(rear(q))")
            catch e
                println("  Loi: ", e.msg)
            end
        elseif lenh == "C"
            clear!(q)
            println("  Da xoa toan bo hang doi.")
        elseif lenh == "L"
            in_so_do(q)
        elseif lenh == "Q"
            println("  Thoat. Tam biet!")
            break
        else
            println("  Lenh khong hop le. Dung: E D P R C L Q")
        end
    end
end

# ─────────────────────────────────────────────────────────────
#  MAIN – Phan tich tham so dong lenh
# ─────────────────────────────────────────────────────────────
function main()
    println("=" ^ 60)
    println("  DT070 – Hang doi DSLK co dau va cuoi")
    println("  Sinh vien: Pham Do Duy Thanh | MSSV: N24DCDT086")
    println("=" ^ 60)

    ca   = nothing
    nhap = false

    for arg in ARGS
        if startswith(arg, "--ca=")
            ca = tryparse(Int, split(arg, "=")[2])
        elseif arg == "--nhap"
            nhap = true
        end
    end

    if nhap
        demo_nhap()
    elseif ca == 1
        demo_ca_1()
    elseif ca == 2
        demo_ca_2()
    else
        println()
        println("  Cach su dung:")
        println("    julia --startup-file=no demo.jl --ca=1   # Demo co ban")
        println("    julia --startup-file=no demo.jl --ca=2   # Mo phong hang cho")
        println("    julia --startup-file=no demo.jl --nhap   # Nhap tay tuong tac")
    end

    println()
end

main()
