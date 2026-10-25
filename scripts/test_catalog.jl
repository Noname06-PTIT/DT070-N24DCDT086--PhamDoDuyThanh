# scripts/test_catalog.jl - Danh muc ca kiem thu va doi chieu expected/actual
include(joinpath(@__DIR__, "..", "src", "LinkedQueue.jl"))
using .LinkedQueue

functional_cases = [
    ("T01", "tao_hang_doi()", "so_luong=0; dau=nothing; cuoi=nothing", () -> begin
        q = tao_hang_doi(Int)
        return (kich_thuoc(q) == 0 && q.dau === nothing && q.cuoi === nothing, "so_luong=$(q.so_luong); dau=$(q.dau); cuoi=$(q.cuoi)")
    end),
    ("T02", "them!(q, 10)", "n=1; dau.val=10; cuoi.val=10; dau===cuoi", () -> begin
        q = tao_hang_doi(Int); them!(q, 10)
        return (q.so_luong == 1 && q.dau === q.cuoi && q.dau.gia_tri == 10, "n=$(q.so_luong); dau.val=$(q.dau.gia_tri); cuoi.val=$(q.cuoi.gia_tri); dau===cuoi")
    end),
    ("T03", "them!(10, 20, 30)", "n=3; xem_dau=10; xem_cuoi=30; FIFO=[10,20,30]", () -> begin
        q = tao_hang_doi(Int); them!(q, 10); them!(q, 20); them!(q, 30)
        return (to_array(q) == [10, 20, 30], "n=$(q.so_luong); xem_dau=$(xem_dau(q)); xem_cuoi=$(xem_cuoi(q)); FIFO=$(to_array(q))")
    end),
    ("T04", "them 10,20,30; lay()", "lay=10; con lai [20,30]; n=2", () -> begin
        q = tao_hang_doi(Int); them!(q, 10); them!(q, 20); them!(q, 30); v = lay!(q)
        return (v == 10 && to_array(q) == [20, 30], "lay=$v; con lai $(to_array(q)); n=$(q.so_luong)")
    end),
    ("T05", "Hang moi; lay()", "ArgumentError (Underflow)", () -> begin
        q = tao_hang_doi(Int)
        ok = false
        try lay!(q) catch e ok = e isa ArgumentError end
        return (ok, "ArgumentError (Underflow)")
    end),
    ("T06", "them 1,2,3; lay het", "lay lan luot 1,2,3; cuoi cung rong", () -> begin
        q = tao_hang_doi(Int); them!(q, 1); them!(q, 2); them!(q, 3)
        res = [lay!(q), lay!(q), lay!(q)]
        return (res == [1, 2, 3] && la_rong(q), "lay=$res; la_rong=$(la_rong(q))")
    end),
    ("T07", "them 6; xem_dau 2 lan", "xem1=6; xem2=6; n=1 khong doi", () -> begin
        q = tao_hang_doi(Int); them!(q, 6)
        x1 = xem_dau(q); x2 = xem_dau(q)
        return (x1 == 6 && x2 == 6 && q.so_luong == 1, "xem1=$x1; xem2=$x2; n=$(q.so_luong)")
    end),
    ("T08", "them 2; lay; them 3; lay", "lay1=2; lay2=3; cuoi cung rong", () -> begin
        q = tao_hang_doi(Int); them!(q, 2); v1 = lay!(q); them!(q, 3); v2 = lay!(q)
        return (v1 == 2 && v2 == 3 && la_rong(q), "lay1=$v1; lay2=$v2; la_rong=$(la_rong(q))")
    end),
    ("T09", "them 4,4; lay 1", "lay=4; con lai [4]; n=1; dau===cuoi", () -> begin
        q = tao_hang_doi(Int); them!(q, 4); them!(q, 4); v = lay!(q)
        return (v == 4 && to_array(q) == [4] && q.dau === q.cuoi, "lay=$v; con lai $(to_array(q)); n=$(q.so_luong)")
    end),
    ("T10", "them(4,7); lay(); them(9)", "lay=4; FIFO=[7,9]; n=2", () -> begin
        q = tao_hang_doi(Int); them!(q, 4); them!(q, 7); v = lay!(q); them!(q, 9)
        return (v == 4 && to_array(q) == [7, 9], "lay=$v; FIFO=$(to_array(q)); n=$(q.so_luong)")
    end),
    ("T11", "them(5); lay(); them(8)", "lay=5; FIFO=[8]; dau=cuoi=Node(8)", () -> begin
        q = tao_hang_doi(Int); them!(q, 5); v = lay!(q); them!(q, 8)
        return (v == 5 && to_array(q) == [8] && q.dau === q.cuoi, "lay=$v; FIFO=$(to_array(q)); dau=cuoi=$(q.dau.gia_tri)")
    end),
    ("T12", "xem_dau va xem_cuoi", "dau=50; cuoi=60; n=2", () -> begin
        q = tao_hang_doi(Int); them!(q, 50); them!(q, 60)
        return (xem_dau(q) == 50 && xem_cuoi(q) == 60, "dau=$(xem_dau(q)); cuoi=$(xem_cuoi(q)); n=$(q.so_luong)")
    end),
    ("T13", "Kiem tra bat bien 50 buoc", "cuoi.tiep===nothing; kiem_tra_bat_bien=true", () -> begin
        q = tao_hang_doi(Int)
        for i in 1:30 them!(q, i) end
        for i in 1:20 lay!(q) end
        return (q.cuoi.tiep === nothing && kiem_tra_bat_bien(q), "cuoi.tiep=$(q.cuoi.tiep); bat_bien=true")
    end),
    ("T14", "Duyet dem_so_nut_duyet", "dem_so_nut_duyet == q.so_luong", () -> begin
        q = tao_hang_doi(Int)
        for i in 1:10 them!(q, i) end
        c1 = dem_so_nut_duyet(q)
        lay!(q); lay!(q)
        c2 = dem_so_nut_duyet(q)
        return (c1 == 10 && c2 == 8, "dem_truoc=$c1; dem_sau=$c2; khop 100%")
    end),
    ("T15", "Quy mo lon n=200", "lay du 1..200; cuoi cung rong", () -> begin
        q = tao_hang_doi(Int)
        for i in 1:200 them!(q, i) end
        out = [lay!(q) for _ in 1:200]
        return (out == collect(1:200) && la_rong(q), "da lay 200 phan tu; la_rong=true")
    end),
    ("T16", "giai_bai(hon hop)", "ket qua [2,3]; n=2", () -> begin
        kq = giai_bai([(:them, 1), (:them, 2), (:lay,), (:them, 3)])
        return (kq.mang_ket_qua == [2, 3] && kq.so_luong == 2, "mang=$(kq.mang_ket_qua); n=$(kq.so_luong)")
    end),
    ("T17", "Kieu String va Float64", "lay String='A'; lay Float64=1.5", () -> begin
        qs = tao_hang_doi(String); them!(qs, "A"); v1 = lay!(qs)
        qf = tao_hang_doi(Float64); them!(qf, 1.5); v2 = lay!(qf)
        return (v1 == "A" && v2 == 1.5, "str=$v1; flt=$v2")
    end)
]

validators = [
    ("V01", "lay!(hang_rong)", "ArgumentError", () -> begin
        q = tao_hang_doi(Int)
        try lay!(q); return false catch e return e isa ArgumentError end
    end),
    ("V02", "xem_dau(hang_rong)", "ArgumentError", () -> begin
        q = tao_hang_doi(Int)
        try xem_dau(q); return false catch e return e isa ArgumentError end
    end),
    ("V03", "xem_cuoi(hang_rong)", "ArgumentError", () -> begin
        q = tao_hang_doi(Int)
        try xem_cuoi(q); return false catch e return e isa ArgumentError end
    end),
    ("V04", "kiem_tra_dau_vao(nothing)", "ArgumentError", () -> begin
        try kiem_tra_dau_vao(nothing); return false catch e return e isa ArgumentError end
    end),
    ("V05", "kiem_tra_dau_vao(chuoi)", "ArgumentError", () -> begin
        try kiem_tra_dau_vao("chuoi_ky_tu"); return false catch e return e isa ArgumentError end
    end),
    ("V06", "kiem_tra_dau_vao(lenh_sai)", "ArgumentError", () -> begin
        try kiem_tra_dau_vao([(:lenh_sai, 10)]); return false catch e return e isa ArgumentError end
    end),
    ("V07", "kiem_tra_dau_vao((:them,))", "ArgumentError", () -> begin
        try kiem_tra_dau_vao([(:them,)]); return false catch e return e isa ArgumentError end
    end),
    ("V08", "kiem_tra_dau_vao(x=1500)", "ArgumentError", () -> begin
        try kiem_tra_dau_vao([1500]); return false catch e return e isa ArgumentError end
    end),
    ("V09", "kiem_tra_dau_vao(x=3.14)", "ArgumentError", () -> begin
        try kiem_tra_dau_vao([3.14]); return false catch e return e isa ArgumentError end
    end)
]

println("CATALOG | id | input | expected | actual | result")
for (id, inp, exp, fn) in functional_cases
    ok, act = fn()
    @assert ok "Fail at $id"
    println("CATALOG | $id | $inp | $exp | $act | PASS")
end

for (id, inp, exp, fn) in validators
    ok = fn()
    @assert ok "Fail at $id"
    println("CATALOG | $id | $inp | $exp | $exp | PASS")
end

println("CATALOG_OK functional_cases=$(length(functional_cases)) helper_validator_cases=$(length(validators)) total_cases=$(length(functional_cases)+length(validators))")
