# test/verify_exhaustive.jl - Oracle doi chung doc lap DT070
# So sanh LinkedQueue (custom) voi Array Reference Model tren 20.000 thao tac

include(joinpath(@__DIR__, "..", "src", "LinkedQueue.jl"))
using .LinkedQueue

function verify_exhaustive()
    println("ORACLE: Bat dau kiem chung doc lap voi Mo hinh Hang doi Mang...")
    q = tao_hang_doi(Int)
    ref = Int[]
    
    total_ops = 20000
    so_them = 0
    so_lay = 0
    so_xem = 0
    
    # 1. Kiem tra toan bo 20.000 thao tac ngau nhien
    for i in 1:total_ops
        r = rand()
        if r < 0.55 || isempty(ref)
            val = rand(-1000:1000)
            them!(q, val)
            push!(ref, val)
            so_them += 1
        elseif r < 0.85
            val_q = lay!(q)
            val_ref = popfirst!(ref)
            @assert val_q == val_ref "Loi sai khac gia tri lay ra tai buoc $i: $val_q != $val_ref"
            so_lay += 1
        else
            val_q = xem_dau(q)
            val_ref = first(ref)
            @assert val_q == val_ref "Loi sai khac xem dau tai buoc $i"
            val_c = xem_cuoi(q)
            val_cref = last(ref)
            @assert val_c == val_cref "Loi sai khac xem cuoi tai buoc $i"
            so_xem += 1
        end
        
        # Kiem tra bat bien va dong bo trang thai sau moi 100 buoc
        if i % 100 == 0 || i == total_ops
            @assert kich_thuoc(q) == length(ref) "Kich thuoc sai khac tai buoc $i"
            @assert to_array(q) == ref "Mang noi dung sai khac tai buoc $i"
            @assert kiem_tra_bat_bien(q) "Bat bien vi pham tai buoc $i"
            @assert dem_so_nut_duyet(q) == q.so_luong "Duyet nut sai khac tai buoc $i"
        end
    end
    
    # 2. Lay het toan bo phan tu con lai
    while !la_rong(q)
        vq = lay!(q)
        vref = popfirst!(ref)
        @assert vq == vref
    end
    @assert isempty(ref) && la_rong(q)
    @assert q.dau === nothing && q.cuoi === nothing
    
    println("EXHAUSTIVE_OK total_operations=$total_ops so_them=$so_them so_lay=$so_lay so_xem=$so_xem")
    println("ORACLE=Vector FIFO Reference Model; Invariants, head, tail, and elements matched 100%.")
    println("Tat ca 20.000 phep kiem chung ngau nhien deu hoan thanh xuat sac voi ma thoat 0.")
end

verify_exhaustive()
