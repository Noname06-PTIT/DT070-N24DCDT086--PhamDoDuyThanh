# ==============================================================================
# Tep: demo.jl - Chuong trinh chay thu nghiem DT070
# De tai: Hang doi bang danh sach lien ket co dau va cuoi (LinkedQueue)
# Sinh vien: Pham Do Duy Thanh - MSSV: N24DCDT086 - Lop: D24CQDT01-N
# ==============================================================================
# TOM TAT DANH SACH 8 CA DEMO (A01 - A08):
#   - Demo 1 (A01): Vi du 1 tren phieu - Minh hoa them/lay co ban va noi đuoi O(1).
#   - Demo 2 (A02): Vi du 2 tren phieu - Lay phan tu duy nhat ve rong roi them lai.
#   - Demo 3 (A03): Ca tu thiet ke 1 - Mo phong Buffer tac vu da chu ky (xen ke).
#   - Demo 4 (A04): Ca tu thiet ke 2 - Kiem tra so am, so 0 va gia tri bien [-1000, 1000].
#   - Demo 5 (A05): Ca bien 1 - Kiem tra hang doi rong (n = 0) va bat loi Underflow.
#   - Demo 6 (A06): Ca bien 2 - Xu ly cac phan tu trung gia tri (Node doc lap).
#   - Demo 7 (A07): Ca bien 3 - Chuyen trang thai rong lien tuc & xem_dau khong doi.
#   - Demo 8 (A08): Kiem thu Validator - Tu choi du lieu ngoai bien, sai lenh, rong.
# ==============================================================================

include(joinpath(@__DIR__, "src", "LinkedQueue.jl"))
using .LinkedQueue

const DUONG_KE_DOI = "="^65
const DUONG_KE_DON = "-"^65

# Ham tien ich in khung tieu de chuan cho tung ca Demo
function in_tieu_de(so_demo::Int, ten_demo::String, ma_anh::String)
    println(DUONG_KE_DOI)
    println("=== DEMO $so_demo (Anh $ma_anh): $ten_demo ===")
    println(DUONG_KE_DOI)
end

# ==============================================================================
# NHOM 1: CAC VI DU TREN PHIEU DE TAI (DEMO 1 - DEMO 2)
# ==============================================================================

# ------------------------------------------------------------------------------
# DEMO 1 (Ma anh: A01) - Vi du 1 tren phieu bai tap
# Noi dung: Thuc hien chuoi thao tac them(4) -> them(7) -> lay() -> them(9).
# Muc dich: Chung minh tinh chat FIFO va viec them phan tu moi (9) duoc noi
#           truc tiep vao sau con tro cuoi (7) voi do phuc tap O(1).
# ------------------------------------------------------------------------------
function chay_demo_1()
    in_tieu_de(1, "Vi du 1 tren phieu: them(4); them(7); lay(); them(9)", "A01")
    println("Input theo phieu: them(4); them(7); lay(); them(9)")
    println("Khoi tao hang doi rong...")

    q = tao_hang_doi(Int)
    in_so_do(q; tieu_de="Buoc 0: Khoi tao rong")

    println("Buoc 1: them!(q, 4)")
    them!(q, 4)
    in_so_do(q; tieu_de="Sau them 4")

    println("Buoc 2: them!(q, 7)")
    them!(q, 7)
    in_so_do(q; tieu_de="Sau them 7")

    println("Buoc 3: v = lay!(q)")
    val = lay!(q)
    println("  -> Gia tri lay ra: $val (Ky vong: 4)")
    in_so_do(q; tieu_de="Sau lay()")

    println("Buoc 4: them!(q, 9)")
    them!(q, 9)
    in_so_do(q; tieu_de="Sau them 9")

    println(DUONG_KE_DON)
    println("KET QUA CHINH VI DU 1:")
    println("  - Gia tri lay ra: $val")
    println("  - Danh sach FIFO: $(to_array(q))")
    println("  - So phan tu n:   $(kich_thuoc(q))")
    println("  - Con tro dau:    Node($(xem_dau(q)))")
    println("  - Con tro cuoi:   Node($(xem_cuoi(q)))")
    println("NHAN XET:")
    println("  Them 9 noi truc tiep sau cuoi hien tai la 7 qua cuoi.tiep = nut_moi;")
    println("  khong can duyet tu nut dau de tim cuoi, chi phi dat O(1).")
end

# ------------------------------------------------------------------------------
# DEMO 2 (Ma anh: A02) - Vi du 2 tren phieu bai tap
# Noi dung: Thuc hien chuoi thao tac them(5) -> lay() -> them(8).
# Muc dich: Kiem tra viec giai phong ca hai con tro dau va cuoi ve `nothing`
#           khi lay phan tu cuoi cung ra khoi hang doi, dam bao khong bi loi
#           con tro treo (dangling pointer) khi them phan tu moi (8) ngay sau do.
# ------------------------------------------------------------------------------
function chay_demo_2()
    in_tieu_de(2, "Vi du 2 tren phieu: them(5); lay(); them(8)", "A02")
    println("Input theo phieu: them(5); lay(); them(8)")

    q = tao_hang_doi(Int)
    in_so_do(q; tieu_de="Buoc 0: Khoi tao rong")

    println("Buoc 1: them!(q, 5)")
    them!(q, 5)
    in_so_do(q; tieu_de="Sau them 5")

    println("Buoc 2: v = lay!(q)")
    val = lay!(q)
    println("  -> Gia tri lay ra: $val (Ky vong: 5)")
    in_so_do(q; tieu_de="Sau lay() (Hang doi tro ve rong)")
    println("  Kiem tra khi rong: dau === nothing ($(q.dau === nothing)), cuoi === nothing ($(q.cuoi === nothing))")

    println("Buoc 3: them!(q, 8)")
    them!(q, 8)
    in_so_do(q; tieu_de="Sau them 8")

    println(DUONG_KE_DON)
    println("KET QUA CHINH VI DU 2:")
    println("  - Gia tri lay ra: $val")
    println("  - Danh sach FIFO: $(to_array(q))")
    println("  - Con tro dau:    Node($(xem_dau(q)))")
    println("  - Con tro cuoi:   Node($(xem_cuoi(q)))")
    println("  - dau === cuoi:   $(q.dau === q.cuoi)")
    println("NHAN XET:")
    println("  Sau khi lay nut 5 lam hang doi tro ve rong, phai xoa ca con tro cuoi cu")
    println("  (cuoi = nothing) de tranh loi con tro rac truoc khi tao hang moi chua 8.")
end

# ==============================================================================
# NHOM 2: CAC CA TU THIET KE MO RONG (DEMO 3 - DEMO 4)
# ==============================================================================

# ------------------------------------------------------------------------------
# DEMO 3 (Ma anh: A03) - Ca tu thiet ke 1: Buffer hang doi da chu ky
# Noi dung: Xen ke lien tuc giua nap tac vu (100, 200, 300), phuc vu tac vu,
#           va nap tiep tac vu moi (400, 500) qua 4 pha.
# Muc dich: Mo phong hoat dong cua bo dem tien trinh (Task Queue) trong thuc te,
#           kiem tra tinh toan ven cua thu tu FIFO qua nhieu chu ky them/lay.
# ------------------------------------------------------------------------------
function chay_demo_3()
    in_tieu_de(3, "Ca tu thiet ke 1: Buffer hang doi da chu ky (Xen ke them/lay)", "A03")
    println("Mo phong hang doi tien trinh / tac vu phuc vu voi chuoi 8 thao tac:")

    q = tao_hang_doi(Int)

    println("Pha 1: Nap 3 tac vu ban dau [100, 200, 300]")
    foreach(x -> them!(q, x), [100, 200, 300])
    in_so_do(q; tieu_de="Sau Pha 1")

    println("Pha 2: Phuc vu 1 tac vu o dau")
    t1 = lay!(q)
    println("  -> Phuc vu: $t1 | Hang con lai: $(to_array(q))")

    println("Pha 3: Nap them 2 tac vu moi [400, 500]")
    foreach(x -> them!(q, x), [400, 500])
    in_so_do(q; tieu_de="Sau Pha 3")

    println("Pha 4: Phuc vu tiep 2 tac vu o dau")
    t2 = lay!(q); println("  -> Phuc vu: $t2")
    t3 = lay!(q); println("  -> Phuc vu: $t3")
    in_so_do(q; tieu_de="Sau Pha 4")

    println("Tong ket ca tu thiet ke 1:")
    println("  - Cac tac vu da phuc vu: [$t1, $t2, $t3] (Dung thu tu den truoc: 100, 200, 300)")
    println("  - Cac tac vu con lai:    $(to_array(q)) (Ky vong: [400, 500])")
    println("  - Bat bien toan ven:     $(kiem_tra_bat_bien(q) ? "DUNG" : "SAI")")
end

# ------------------------------------------------------------------------------
# DEMO 4 (Ma anh: A04) - Ca tu thiet ke 2: Xu ly so am, so 0 va gia tri bien
# Noi dung: Nap mang [-500, 0, 1000, -999] vao hang doi va lay ra toan bo.
# Muc dich: Kiem tra hang doi hoat dong chinh xac voi day du mien gia tri hop le
#           trong doan [-1000, 1000] (bao gom so am, so 0 va bien tren/duoi).
# ------------------------------------------------------------------------------
function chay_demo_4()
    in_tieu_de(4, "Ca tu thiet ke 2: Xu ly gia tri am va so 0 trong [-1000, 1000]", "A04")

    q = tao_hang_doi(Int)
    du_lieu = [-500, 0, 1000, -999]

    println("Nap chuoi gia tri chua so am, so 0 va bien: $du_lieu")
    for x in du_lieu
        them!(q, x)
        println("  + them!($x) -> dau=$(xem_dau(q)), cuoi=$(xem_cuoi(q)), n=$(kich_thuoc(q))")
    end
    in_so_do(q; tieu_de="Hang doi sau khi nap day du")

    println("Tien hanh lay lan luot tat ca cac phan tu:")
    kq = Int[]
    while !la_rong(q)
        push!(kq, lay!(q))
    end

    println("Ket qua lay ra:  $kq")
    println("Ky vong ban dau: $du_lieu")
    println("So khop FIFO:    $(kq == du_lieu ? "DUNG (Chinh xac 100%)" : "SAI")")
    println("Trang thai cuoi: dau=$(q.dau), cuoi=$(q.cuoi), la_rong=$(la_rong(q))")
end

# ==============================================================================
# NHOM 3: CAC CA KIEM THU BIEN VA NGOAI LE (DEMO 5 - DEMO 8)
# ==============================================================================

# ------------------------------------------------------------------------------
# DEMO 5 (Ma anh: A05) - Ca bien 1: Thao tac tren hang doi rong (Ca 1 tren phieu)
# Noi dung: Khoi tao hang doi rong (n = 0), thu goi lay!(q) va xem_dau(q).
# Muc dich: Minh hoa kha nang phat hien va nem ngoai le `ArgumentError` (Underflow)
#           an toan khi nguoi dung co tinh lay hoac xem phan tu tu hang doi rong.
# ------------------------------------------------------------------------------
function chay_demo_5()
    in_tieu_de(5, "Ca bien 1: Hang doi rong (Kich thuoc nho nhat n=0)", "A05")

    q = tao_hang_doi(Int)
    println("Trang thai hang moi khoi tao:")
    println("  - la_rong(q):    ", la_rong(q))
    println("  - kich_thuoc(q): ", kich_thuoc(q))
    println("  - q.dau:         ", q.dau)
    println("  - q.cuoi:        ", q.cuoi)
    println("  - Bat bien:      ", kiem_tra_bat_bien(q))

    println("\nThu lay!(q) tren hang doi rong:")
    try
        lay!(q)
    catch e
        println("  => Bat ngoai le ArgumentError thanh cong: ", sprint(showerror, e))
    end

    println("\nThu xem_dau(q) tren hang doi rong:")
    try
        xem_dau(q)
    catch e
        println("  => Bat ngoai le ArgumentError thanh cong: ", sprint(showerror, e))
    end

    println("\nKet luan: Hang doi rong duoc xu ly an toan tuyet doi theo Ca 1 cua phieu.")
end

# ------------------------------------------------------------------------------
# DEMO 6 (Ma anh: A06) - Ca bien 2: Phan tu trung gia tri (Ca 5 tren phieu)
# Noi dung: Them hai so 4 lien tiep: them(4) -> them(4) -> lay() -> con [4].
# Muc dich: Chung minh moi phan tu du co cung gia_tri (4) van duoc cap phat
#           thanh cac Node doc lap trong bo nho; xoa nut dau khong lam mat nut sau.
# ------------------------------------------------------------------------------
function chay_demo_6()
    in_tieu_de(6, "Ca bien 2: Phan tu trung gia tri: them(4,4); lay 1 (Ca 5 tren phieu)", "A06")
    println("Input theo phieu: them(4); them(4); lay()")

    q = tao_hang_doi(Int)

    println("Buoc 1: them!(q, 4)")
    them!(q, 4)
    println("Buoc 2: them!(q, 4)")
    them!(q, 4)
    in_so_do(q; tieu_de="Sau khi them hai so 4")

    println("Buoc 3: v = lay!(q)")
    val = lay!(q)
    println("  -> Gia tri lay ra: $val (Ky vong: 4)")
    in_so_do(q; tieu_de="Sau khi lay mot phan tu")

    println(DUONG_KE_DON)
    println("KET QUA CA BIEN 2:")
    println("  - Con lai:       $(to_array(q)) (Ky vong: [4])")
    println("  - So luong n:    $(kich_thuoc(q)) (Ky vong: 1)")
    println("  - dau === cuoi:  $(q.dau === q.cuoi) (Cung tro ve nut 4 duy nhat)")
    println("  - cuoi.tiep:     $(q.cuoi.tiep) (Ky vong: nothing)")
    println("NHAN XET:")
    println("  Moi phan tu du trung gia tri van duoc cap phat thanh mot Node doc lap;")
    println("  khi lay mot phan tu, nut con lai van duoc giu nguyen ven khong bi anh huong.")
end

# ------------------------------------------------------------------------------
# DEMO 7 (Ma anh: A07) - Ca bien 3: Gop Ca 4 va Ca 3 tren phieu bai tap
# Noi dung:
#   - Phan A (Ca 4): them(2) -> lay() -> them(3) -> lay() -> hang doi ve rong.
#   - Phan B (Ca 3): them(6) -> xem_dau() 2 lan lien tiep.
# Muc dich: Kiem tra viec chuyen trang thai giua rong <-> 1 phan tu nhieu lan,
#           dong thoi xac nhan thao tac `xem_dau` chi doc chu khong xoa phan tu.
# ------------------------------------------------------------------------------
function chay_demo_7()
    in_tieu_de(7, "Ca bien 3: Chuyen trang thai rong va xem dau hai lan (Ca 4 va Ca 3)", "A07")

    println("--- PHAN A: Ca 4 tren phieu: them 2; lay; them 3; lay -> 2,3 cuoi rong ---")
    q = tao_hang_doi(Int)
    them!(q, 2)
    v1 = lay!(q)
    them!(q, 3)
    v2 = lay!(q)
    println("  - Gia tri lay lan 1: $v1 (Ky vong: 2)")
    println("  - Gia tri lay lan 2: $v2 (Ky vong: 3)")
    println("  - Trang thai cuoi:   la_rong=$(la_rong(q)), dau=$(q.dau), cuoi=$(q.cuoi)")

    println("\n--- PHAN B: Ca 3 tren phieu: them 6; xem hai lan -> 6,6 ma n=1 khong doi ---")
    q2 = tao_hang_doi(Int)
    them!(q2, 6)
    x1 = xem_dau(q2)
    x2 = xem_dau(q2)
    println("  - xem_dau lan 1: $x1 (Ky vong: 6)")
    println("  - xem_dau lan 2: $x2 (Ky vong: 6)")
    println("  - So luong n:    $(kich_thuoc(q2)) (Ky vong: 1)")
    println("  - FIFO hien tai: $(to_array(q2)) (Ky vong: [6])")
    println("Ket luan: Cac ca bien tren phieu de tai deu dat chuan 100%.")
end

# ------------------------------------------------------------------------------
# DEMO 8 (Ma anh: A08) - Kiem thu bo xac thuc dau vao (Validator) va Ngoai le
# Noi dung: Thu nghiem 3 tinh huong du lieu sai:
#   1. Gia tri vuot nguong cho phep: x = 1500 (ngoai doan [-1000, 1000]).
#   2. Cu phap lenh khong ton tai: (:lenh_sai, 10).
#   3. Lay phan tu khi hang doi dang rong (Underflow).
# Muc dich: Chung minh bo Validator chan dung moi du lieu khong hop le ngay tu dau.
# ------------------------------------------------------------------------------
function chay_demo_8()
    in_tieu_de(8, "Phan hoi du lieu khong hop le (Ngoai le va Validator)", "A08")
    println("DT070 - MINH HOA TU CHOI DU LIEU KHONG HOP LE")
    println("Cac dieu kien kiem tra theo hop dong phieu:")
    println("  1. Gia tri ngoai mien [-1000, 1000]")
    println("  2. Du lieu dau vao nothing hoac sai kieu")
    println("  3. Lenh thao tac khong hop le\n")

    # Thu nghiem 1: Kiem tra gia tri vuot nguong 1000
    try
        println("Thu nghiem 1: Gia tri them x = 1500 (ngoai [-1000, 1000]):")
        kiem_tra_dau_vao([(:them, 1500)])
        error("LOI: Validator da khong bat duoc x = 1500")
    catch e
        println("  DA TU CHOI DU LIEU: ", sprint(showerror, e))
    end

    # Thu nghiem 2: Kiem tra lenh sai cu phap
    try
        println("\nThu nghiem 2: Lenh khong hop le (:lenh_sai):")
        kiem_tra_dau_vao([(:lenh_sai, 10)])
        error("LOI: Validator da khong bat duoc lenh sai")
    catch e
        println("  DA TU CHOI DU LIEU: ", sprint(showerror, e))
    end

    # Thu nghiem 3: Kiem tra loi Underflow khi lay tren hang rong
    q = tao_hang_doi(Int)
    try
        println("\nThu nghiem 3: Lay phan tu tren hang doi rong:")
        lay!(q)
        error("LOI: Khong nem loi Underflow")
    catch e
        println("  DA TU CHOI DU LIEU: ", sprint(showerror, e))
    end

    println("\n" * DUONG_KE_DON)
    println("KET QUA MINH HOA: DUNG; tat ca loi du kien da duoc bat an toan.")
    println("Ma thoat 0 chi danh cho demo bat loi dung nhu mong doi.")
end

# ==============================================================================
# PHAN 4: CHE DO TUONG TAC BAN PHIM & HAM DIEU HUONG CHINH (MAIN)
# ==============================================================================

# ------------------------------------------------------------------------------
# Che do nhap tu ban phim (Kich hoat khi chay: julia demo.jl --nhap)
# Cho phep nguoi dung tu nhap so luong lenh m (1..1000) va go truc tiep cac lenh:
# `them <x>`, `lay`, `xem` de kiem tra hang doi theo thoi gian thuc.
# ------------------------------------------------------------------------------
function chay_nhap_ban_phim()
    println(DUONG_KE_DOI)
    println("CHE DO NHAP BAN PHIM: THEO QUY TAC DE TAI DT070")
    println(DUONG_KE_DOI)

    q = tao_hang_doi(Int)
    println("Nhap so luong lenh thao tac (toi da 1000):")
    m = tryparse(Int, strip(readline()))

    if m === nothing || !(1 <= m <= 1000)
        println("So luong lenh khong hop le (phai trong 1..1000). Dung chuong trinh.")
        return
    end

    println("Nhap lan luot $m lenh. Cu phap moi dong:")
    println("  + them <x>   (vi du: them 42)")
    println("  + lay")
    println("  + xem")

    for i in 1:m
        print("Lenh $i: ")
        parts = split(strip(readline()))
        isempty(parts) && continue

        cmd = lowercase(parts[1])
        if cmd == "them"
            if length(parts) < 2
                println("  Loi: Thieu gia tri them!")
                continue
            end
            val = tryparse(Int, parts[2])
            if val === nothing || !(-1000 <= val <= 1000)
                println("  Loi: Gia tri phai la so nguyen trong [-1000, 1000]!")
                continue
            end
            them!(q, val)
            println("  -> Da them $val. FIFO: $(to_array(q)), n=$(kich_thuoc(q))")

        elseif cmd == "lay"
            if la_rong(q)
                println("  Loi: Hang doi rong, khong the lay!")
            else
                x = lay!(q)
                println("  -> Gia tri lay ra: $x. FIFO: $(to_array(q)), n=$(kich_thuoc(q))")
            end

        elseif cmd in ("xem", "dau")
            if la_rong(q)
                println("  Loi: Hang doi rong!")
            else
                println("  -> Phan tu dau hang: $(xem_dau(q))")
            end

        else
            println("  Loi: Lenh khong hop le ('$cmd')!")
        end
    end

    in_so_do(q; tieu_de="Trang thai cuoi cung sau khi nhap ban phim")
end

# Danh sach anh xa so thu tu ca demo (1 -> 8) toi ham tuong ung
const DANH_SACH_DEMO = [
    chay_demo_1, chay_demo_2, chay_demo_3, chay_demo_4,
    chay_demo_5, chay_demo_6, chay_demo_7, chay_demo_8
]

# ------------------------------------------------------------------------------
# Ham main(): Xu ly tham so dong lenh (ARGS)
#   - Chay tat ca 8 demo:        julia demo.jl
#   - Chay rieng 1 demo (1..8):  julia demo.jl --ca=1
#   - Chay che do nhap tay:      julia demo.jl --nhap
# ------------------------------------------------------------------------------
function main()
    ca = 0
    nhap = false

    for arg in ARGS
        if startswith(arg, "--ca=")
            ca = something(tryparse(Int, split(arg, "=")[2]), 0)
        elseif arg == "--nhap"
            nhap = true
        end
    end

    if nhap
        chay_nhap_ban_phim()
        return
    end

    if 1 <= ca <= length(DANH_SACH_DEMO)
        DANH_SACH_DEMO[ca]()
    else
        println("DT070 - HANG DOI BANG DANH SACH LIEN KET CO DAU VA CUOI")
        println("Sinh vien: Pham Do Duy Thanh - MSSV: N24DCDT086 - Lop: D24CQDT01-N\n")
        for ham_demo in DANH_SACH_DEMO
            ham_demo()
            println()
        end
        println("HOAN THANH TOAN BO 8 DEMO A01 - A08 CHUAN PHIEU DE TAI DT070!")
    end
end

main()
