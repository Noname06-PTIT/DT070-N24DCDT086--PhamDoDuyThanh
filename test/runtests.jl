# test/runtests.jl - Bo kiem thu tu dong DT070
# De tai: Hang doi bang danh sach lien ket co dau va cuoi (LinkedQueue)
# Sinh vien: Pham Do Duy Thanh - MSSV: N24DCDT086 - Lop: D24CQDT01-N

using Test
include(joinpath(@__DIR__, "..", "src", "LinkedQueue.jl"))
using .LinkedQueue

println("=================================================================")
println("CHAY KIEM THU TU DONG - DE TAI DT070")
println("Hang doi bang danh sach lien ket co dau va cuoi (LinkedQueue)")
println("Sinh vien: Pham Do Duy Thanh - MSSV: N24DCDT086 - Lop: D24CQDT01-N")
println("=================================================================")

@testset "DT070 - Kiem thu toan dien Hang doi danh sach lien ket" begin

    @testset "T01 - Khoi tao hang doi rong" begin
        q = tao_hang_doi(Int)
        @test la_rong(q) == true
        @test is_empty(q) == true
        @test kich_thuoc(q) == 0
        @test queue_size(q) == 0
        @test q.dau === nothing
        @test q.cuoi === nothing
        @test kiem_tra_bat_bien(q) == true
        @test check_invariants(q) == true
        @test to_array(q) == Int[]
    end

    @testset "T02 - Them mot phan tu vao hang doi rong" begin
        q = tao_hang_doi(Int)
        them!(q, 10)
        @test la_rong(q) == false
        @test kich_thuoc(q) == 1
        @test q.dau !== nothing
        @test q.cuoi !== nothing
        @test q.dau === q.cuoi
        @test q.dau.gia_tri == 10
        @test q.cuoi.gia_tri == 10
        @test q.cuoi.tiep === nothing
        @test kiem_tra_bat_bien(q) == true
        @test to_array(q) == [10]
    end

    @testset "T03 - Them nhieu phan tu bao toan FIFO" begin
        q = tao_hang_doi(Int)
        them!(q, 10)
        enqueue!(q, 20)
        them!(q, 30)
        @test kich_thuoc(q) == 3
        @test xem_dau(q) == 10
        @test peek_front(q) == 10
        @test dau_hang(q) == 10
        @test xem_cuoi(q) == 30
        @test peek_rear(q) == 30
        @test to_array(q) == [10, 20, 30]
        @test kiem_tra_bat_bien(q) == true
    end

    @testset "T04 - Lay phan tu ra khoi hang doi (Dequeue)" begin
        q = tao_hang_doi(Int)
        them!(q, 10)
        them!(q, 20)
        them!(q, 30)
        
        val = lay!(q)
        @test val == 10
        @test kich_thuoc(q) == 2
        @test xem_dau(q) == 20
        @test xem_cuoi(q) == 30
        @test to_array(q) == [20, 30]
        @test kiem_tra_bat_bien(q) == true

        val2 = dequeue!(q)
        @test val2 == 20
        @test to_array(q) == [30]
    end

    @testset "T05 - Ca 1 tren phieu: Hang moi; lay() bao loi Underflow" begin
        q = tao_hang_doi(Int)
        @test la_rong(q) == true
        @test_throws ArgumentError lay!(q)
        @test_throws ArgumentError dequeue!(q)
        @test q.dau === nothing
        @test q.cuoi === nothing
    end

    @testset "T06 - Ca 2 tren phieu: Them 1,2,3 roi lay het -> 1,2,3" begin
        q = tao_hang_doi(Int)
        them!(q, 1); them!(q, 2); them!(q, 3)
        @test kich_thuoc(q) == 3
        @test lay!(q) == 1
        @test lay!(q) == 2
        @test lay!(q) == 3
        @test la_rong(q) == true
        @test q.dau === nothing
        @test q.cuoi === nothing
        @test kiem_tra_bat_bien(q) == true
    end

    @testset "T07 - Ca 3 tren phieu: Them 6; xem hai lan -> 6,6, n=1" begin
        q = tao_hang_doi(Int)
        them!(q, 6)
        @test xem_dau(q) == 6
        @test xem_dau(q) == 6
        @test dau_hang(q) == 6
        @test kich_thuoc(q) == 1
        @test to_array(q) == [6]
        @test kiem_tra_bat_bien(q) == true
    end

    @testset "T08 - Ca 4 tren phieu: Them 2; lay; them 3; lay tra 2,3 cuoi rong" begin
        q = tao_hang_doi(Int)
        them!(q, 2)
        @test lay!(q) == 2
        @test la_rong(q) == true
        @test q.dau === nothing
        @test q.cuoi === nothing
        
        them!(q, 3)
        @test lay!(q) == 3
        @test la_rong(q) == true
        @test q.dau === nothing
        @test q.cuoi === nothing
        @test kiem_tra_bat_bien(q) == true
    end

    @testset "T09 - Ca 5 tren phieu: Them 4,4; lay mot -> con [4], n=1" begin
        q = tao_hang_doi(Int)
        them!(q, 4)
        them!(q, 4)
        @test kich_thuoc(q) == 2
        @test lay!(q) == 4
        @test kich_thuoc(q) == 1
        @test to_array(q) == [4]
        @test q.dau === q.cuoi
        @test q.dau.gia_tri == 4
        @test kiem_tra_bat_bien(q) == true
    end

    @testset "T10 - Vi du 1 tren phieu: them(4); them(7); lay(); them(9)" begin
        # lay=4; FIFO=[7,9]; n=2
        q = tao_hang_doi(Int)
        them!(q, 4)
        them!(q, 7)
        v = lay!(q)
        them!(q, 9)
        @test v == 4
        @test to_array(q) == [7, 9]
        @test kich_thuoc(q) == 2
        @test xem_dau(q) == 7
        @test xem_cuoi(q) == 9
        @test kiem_tra_bat_bien(q) == true
    end

    @testset "T11 - Vi du 2 tren phieu: them(5); lay(); them(8)" begin
        # lay=5; FIFO=[8]; dau=cuoi la nut 8
        q = tao_hang_doi(Int)
        them!(q, 5)
        v = lay!(q)
        them!(q, 8)
        @test v == 5
        @test to_array(q) == [8]
        @test kich_thuoc(q) == 1
        @test q.dau === q.cuoi
        @test q.dau.gia_tri == 8
        @test q.cuoi.tiep === nothing
        @test kiem_tra_bat_bien(q) == true
    end

    @testset "T12 - Xem dau va xem cuoi khong lam bien doi hang doi" begin
        q = tao_hang_doi(Int)
        them!(q, 50)
        them!(q, 60)
        @test xem_dau(q) == 50
        @test xem_cuoi(q) == 60
        @test kich_thuoc(q) == 2
        @test to_array(q) == [50, 60]
    end

    @testset "T13 - Bat bien cuoi.tiep === nothing qua 50 thao tac ngau nhien" begin
        q = tao_hang_doi(Int)
        for i in 1:30
            them!(q, i)
            @test q.cuoi.tiep === nothing
            @test kiem_tra_bat_bien(q) == true
        end
        for i in 1:20
            lay!(q)
            @test q.cuoi.tiep === nothing
            @test kiem_tra_bat_bien(q) == true
        end
    end

    @testset "T14 - Doi chieu dem_so_nut_duyet voi q.so_luong" begin
        q = tao_hang_doi(Int)
        @test dem_so_nut_duyet(q) == 0
        for i in 1:15
            them!(q, i * 10)
            @test dem_so_nut_duyet(q) == q.so_luong
        end
        for i in 1:10
            lay!(q)
            @test dem_so_nut_duyet(q) == q.so_luong
        end
    end

    @testset "T15 - Kiem thu quy mo lon 200 phan tu lien tuc" begin
        q = tao_hang_doi(Int)
        for i in 1:200
            them!(q, i)
        end
        @test kich_thuoc(q) == 200
        @test xem_dau(q) == 1
        @test xem_cuoi(q) == 200
        @test kiem_tra_bat_bien(q) == true
        out = Int[]
        while !la_rong(q)
            push!(out, lay!(q))
        end
        @test out == collect(1:200)
        @test la_rong(q) == true
    end

    @testset "T16 - Ham giai_bai voi danh sach thao tac hon hop" begin
        du_lieu = [(:them, 1), (:them, 2), (:lay,), (:them, 3)]
        kq = giai_bai(du_lieu)
        @test kq.mang_ket_qua == [2, 3]
        @test kq.so_luong == 2
        @test length(kq.nhat_ky) == 4
    end

    @testset "T17 - Ho tro phan tu String va Float64 (Kieu tong quat T)" begin
        qs = tao_hang_doi(String)
        them!(qs, "A"); them!(qs, "B")
        @test lay!(qs) == "A"
        @test xem_dau(qs) == "B"
        
        qf = tao_hang_doi(Float64)
        them!(qf, 1.5); them!(qf, 2.5)
        @test lay!(qf) == 1.5
    end

    @testset "V01 - Ngoai le: Lay phan tu khi hang doi rong (Underflow)" begin
        q = tao_hang_doi(Int)
        @test_throws ArgumentError lay!(q)
        @test_throws ArgumentError dequeue!(q)
    end

    @testset "V02 - Ngoai le: Xem dau khi hang doi rong" begin
        q = tao_hang_doi(Int)
        @test_throws ArgumentError xem_dau(q)
        @test_throws ArgumentError peek_front(q)
        @test_throws ArgumentError dau_hang(q)
    end

    @testset "V03 - Ngoai le: Xem cuoi khi hang doi rong" begin
        q = tao_hang_doi(Int)
        @test_throws ArgumentError xem_cuoi(q)
        @test_throws ArgumentError peek_rear(q)
    end

    @testset "V04 - Validator: Tu choi du lieu nothing" begin
        @test_throws ArgumentError kiem_tra_dau_vao(nothing)
        @test_throws ArgumentError validate_input(nothing)
    end

    @testset "V05 - Validator: Tu choi du lieu khong phai Vector" begin
        @test_throws ArgumentError kiem_tra_dau_vao("khong_phai_vector")
        @test_throws ArgumentError kiem_tra_dau_vao(12345)
    end

    @testset "V06 - Validator: Tu choi lenh khong hop le" begin
        @test_throws ArgumentError kiem_tra_dau_vao([(:lenh_sai, 10)])
    end

    @testset "V07 - Validator: Tu choi lenh :them thieu tham so" begin
        @test_throws ArgumentError kiem_tra_dau_vao([(:them,)])
    end

    @testset "V08 - Validator: Tu choi gia tri ngoai pham vi [-1000, 1000]" begin
        @test_throws ArgumentError kiem_tra_dau_vao([1001])
        @test_throws ArgumentError kiem_tra_dau_vao([-1001])
        @test_throws ArgumentError kiem_tra_dau_vao([(:them, 2000)])
        @test_throws ArgumentError kiem_tra_dau_vao([(:them, -1500)])
    end

    @testset "V09 - Validator: Tu choi phan tu so thuc khi ky vong so nguyen" begin
        @test_throws ArgumentError kiem_tra_dau_vao([3.14])
        @test_throws ArgumentError kiem_tra_dau_vao([(:them, 4.5)])
    end

end

println("
=================================================================")
println("KET QUA: TAT CA CAC CA KIEM THU DA PASS 100%!")
println("=================================================================")
