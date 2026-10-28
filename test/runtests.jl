# ============================================================
#  test/runtests.jl
#  Bo kiem thu (Unit Test) – 22 ca, 127 phep kiem tra
#  De tai DT070 – Hang doi DSLK co dau va cuoi
#  Sinh vien: Pham Do Duy Thanh | MSSV: N24DCDT086
#  Chay: julia --startup-file=no test/runtests.jl
# ============================================================

using Test
include(joinpath(@__DIR__, "..", "src", "LinkedQueue.jl"))

println("=" ^ 60)
println("  BO KIEM THU DT070 – LinkedQueue (DSLK co dau & cuoi)")
println("  Sinh vien: Pham Do Duy Thanh | N24DCDT086")
println("=" ^ 60)

# ============================================================
#  NHOM T: KIEM THU CHUC NANG (T01 – T14)
# ============================================================

@testset "T01 – Khoi tao hang doi rong" begin
    q = LinkedQueue{Int}()
    @test isempty(q)                   # 1
    @test length(q) == 0               # 2
    @test q.head === nothing           # 3
    @test q.tail === nothing           # 4
    @test to_array(q) == Any[]         # 5
    println("  [T01] PASS – khoi tao hang doi rong")
end

@testset "T02 – Enqueue 1 phan tu" begin
    q = LinkedQueue{Int}()
    enqueue!(q, 10)
    @test !isempty(q)                  # 1
    @test length(q) == 1               # 2
    @test q.head !== nothing           # 3
    @test q.tail !== nothing           # 4
    @test q.head.data == 10           # 5
    @test q.tail.data == 10           # 6
    @test q.head === q.tail           # 7  head va tail cung tro 1 nut
    @test to_array(q) == [10]         # 8
    println("  [T02] PASS – enqueue 1 phan tu")
end

@testset "T03 – Enqueue nhieu phan tu" begin
    q = LinkedQueue{Int}()
    enqueue!(q, 1); enqueue!(q, 2); enqueue!(q, 3)
    @test length(q) == 3              # 1
    @test q.head.data == 1            # 2
    @test q.tail.data == 3            # 3
    @test q.head.next.data == 2       # 4
    @test q.head.next.next.data == 3  # 5
    @test q.head.next.next === q.tail # 6
    @test to_array(q) == [1, 2, 3]   # 7
    println("  [T03] PASS – enqueue nhieu phan tu")
end

@testset "T04 – Dequeue 1 phan tu" begin
    q = LinkedQueue{Int}()
    enqueue!(q, 5); enqueue!(q, 6)
    val = dequeue!(q)
    @test val == 5                    # 1  gia tri lay ra dung
    @test length(q) == 1              # 2
    @test !isempty(q)                 # 3
    @test q.head.data == 6            # 4  head moi
    @test q.tail.data == 6            # 5
    @test q.head === q.tail           # 6
    println("  [T04] PASS – dequeue 1 phan tu")
end

@testset "T05 – Dequeue het hang doi" begin
    q = LinkedQueue{Int}()
    enqueue!(q, 10); enqueue!(q, 20); enqueue!(q, 30)
    @test dequeue!(q) == 10           # 1
    @test length(q) == 2              # 2
    @test dequeue!(q) == 20           # 3
    @test length(q) == 1              # 4
    @test dequeue!(q) == 30           # 5
    @test length(q) == 0              # 6
    @test isempty(q)                  # 7
    @test q.head === nothing          # 8
    @test q.tail === nothing          # 9
    println("  [T05] PASS – dequeue het hang doi")
end

@testset "T06 – peek / front (xem dau ma khong xoa)" begin
    q = LinkedQueue{Int}()
    enqueue!(q, 42); enqueue!(q, 99)
    @test peek(q)  == 42             # 1
    @test front(q) == 42             # 2  biet danh front
    @test length(q) == 2             # 3  khong xoa
    @test q.head.data == 42          # 4
    @test to_array(q) == [42, 99]    # 5
    println("  [T06] PASS – peek/front")
end

@testset "T07 – rear (xem cuoi ma khong xoa)" begin
    q = LinkedQueue{Int}()
    enqueue!(q, 7); enqueue!(q, 8); enqueue!(q, 9)
    @test rear(q) == 9               # 1
    @test length(q) == 3             # 2  khong xoa
    @test q.tail.data == 9           # 3
    dequeue!(q)
    @test rear(q) == 9               # 4  cuoi khong doi khi lay dau
    println("  [T07] PASS – rear")
end

@testset "T08 – Kiem tra size tung buoc" begin
    q = LinkedQueue{Int}()
    @test length(q) == 0             # 1
    enqueue!(q, 1); @test length(q) == 1  # 2
    enqueue!(q, 2); @test length(q) == 2  # 3
    enqueue!(q, 3); @test length(q) == 3  # 4
    dequeue!(q);    @test length(q) == 2  # 5
    dequeue!(q);    @test length(q) == 1  # 6
    enqueue!(q, 4); @test length(q) == 2  # 7
    dequeue!(q);    @test length(q) == 1  # 8
    dequeue!(q);    @test length(q) == 0  # 9
    println("  [T08] PASS – size tung buoc")
end

@testset "T09 – isempty chuyen trang thai" begin
    q = LinkedQueue{Int}()
    @test isempty(q)                 # 1  ban dau rong
    enqueue!(q, 1)
    @test !isempty(q)                # 2  sau khi them
    dequeue!(q)
    @test isempty(q)                 # 3  sau khi lay het
    enqueue!(q, 2); enqueue!(q, 3)
    @test !isempty(q)                # 4
    clear!(q)
    @test isempty(q)                 # 5  sau clear
    println("  [T09] PASS – isempty chuyen trang thai")
end

@testset "T10 – Thu tu FIFO (First In First Out)" begin
    q = LinkedQueue{Int}()
    for v in [11, 22, 33, 44, 55]
        enqueue!(q, v)
    end
    expected = [11, 22, 33, 44, 55]
    for (i, ex) in enumerate(expected)
        @test dequeue!(q) == ex      # 5 phep kiem (1 moi vong)
    end
    @test isempty(q)                 # 6
    println("  [T10] PASS – thu tu FIFO")
end

@testset "T11 – clear! xoa toan bo" begin
    q = LinkedQueue{Int}()
    enqueue!(q, 1); enqueue!(q, 2); enqueue!(q, 3)
    clear!(q)
    @test isempty(q)                 # 1
    @test length(q) == 0             # 2
    @test q.head === nothing         # 3
    @test q.tail === nothing         # 4
    @test to_array(q) == Any[]       # 5
    println("  [T11] PASS – clear!")
end

@testset "T12 – Xen ke enqueue/dequeue (mixed)" begin
    q = LinkedQueue{Int}()
    enqueue!(q, 10)
    enqueue!(q, 20)
    @test dequeue!(q) == 10          # 1
    enqueue!(q, 30)
    enqueue!(q, 40)
    @test length(q) == 3             # 2  [20,30,40]
    @test q.head.data == 20          # 3
    @test q.tail.data == 40          # 4
    @test dequeue!(q) == 20          # 5
    @test dequeue!(q) == 30          # 6
    @test dequeue!(q) == 40          # 7
    @test isempty(q)                 # 8
    enqueue!(q, 99)
    @test peek(q) == 99              # 9
    @test rear(q) == 99              # 10
    println("  [T12] PASS – xen ke enqueue/dequeue")
end

@testset "T13 – Con tro head va tail sau tung buoc" begin
    q = LinkedQueue{Int}()
    enqueue!(q, 1)
    @test q.head === q.tail          # 1  chi 1 nut
    enqueue!(q, 2)
    @test q.head !== q.tail          # 2  2 nut khac nhau
    @test q.head.data == 1           # 3
    @test q.tail.data == 2           # 4
    @test q.head.next === q.tail     # 5
    dequeue!(q)
    @test q.head === q.tail          # 6  lai 1 nut
    @test q.head.data == 2           # 7
    dequeue!(q)
    @test q.head === nothing         # 8
    @test q.tail === nothing         # 9
    println("  [T13] PASS – con tro head & tail")
end

@testset "T14 – to_array chinh xac" begin
    q = LinkedQueue{Int}()
    @test to_array(q) == Any[]             # 1  hang rong
    enqueue!(q, 5)
    @test to_array(q) == [5]              # 2
    enqueue!(q, 10); enqueue!(q, 15)
    @test to_array(q) == [5, 10, 15]      # 3
    dequeue!(q)
    @test to_array(q) == [10, 15]         # 4
    clear!(q)
    @test to_array(q) == Any[]            # 5
    println("  [T14] PASS – to_array")
end

# ============================================================
#  NHOM V: KIEM THU NGOAI LE / BIEN (V01 – V08)
# ============================================================

@testset "V01 – dequeue! tren hang doi rong" begin
    q = LinkedQueue{Int}()
    @test_throws ArgumentError dequeue!(q)  # 1
    err = try dequeue!(q) catch e; e end
    @test err isa ArgumentError             # 2
    @test contains(sprint(showerror, err), "RONG")  # 3
    println("  [V01] PASS – dequeue! hang rong nem ArgumentError")
end

@testset "V02 – peek tren hang doi rong" begin
    q = LinkedQueue{Int}()
    @test_throws ArgumentError peek(q)      # 1
    err = try peek(q) catch e; e end
    @test err isa ArgumentError             # 2
    @test contains(sprint(showerror, err), "RONG")  # 3
    println("  [V02] PASS – peek hang rong nem ArgumentError")
end

@testset "V03 – rear tren hang doi rong" begin
    q = LinkedQueue{Int}()
    @test_throws ArgumentError rear(q)      # 1
    err = try rear(q) catch e; e end
    @test err isa ArgumentError             # 2
    @test contains(sprint(showerror, err), "RONG")  # 3
    println("  [V03] PASS – rear hang rong nem ArgumentError")
end

@testset "V04 – Enqueue sau clear! hang doi" begin
    q = LinkedQueue{Int}()
    enqueue!(q, 1); enqueue!(q, 2)
    clear!(q)
    @test isempty(q)                 # 1
    enqueue!(q, 99)
    @test length(q) == 1             # 2
    @test peek(q) == 99              # 3
    @test rear(q) == 99              # 4
    @test q.head === q.tail          # 5
    println("  [V04] PASS – enqueue sau clear!")
end

@testset "V05 – Hang doi 1 phan tu: head === tail" begin
    q = LinkedQueue{Int}()
    enqueue!(q, 777)
    @test q.head === q.tail          # 1
    @test q.head.data == 777         # 2
    @test q.head.next === nothing    # 3
    @test q.tail.next === nothing    # 4
    println("  [V05] PASS – 1 phan tu: head === tail")
end

@testset "V06 – Sau dequeue het: head va tail = nothing" begin
    q = LinkedQueue{Int}()
    enqueue!(q, 1); enqueue!(q, 2)
    dequeue!(q); dequeue!(q)
    @test q.head === nothing         # 1
    @test q.tail === nothing         # 2
    @test isempty(q)                 # 3
    @test length(q) == 0             # 4
    @test_throws ArgumentError dequeue!(q)  # 5
    println("  [V06] PASS – sau dequeue het")
end

@testset "V07 – Hang doi kieu String" begin
    q = LinkedQueue{String}()
    enqueue!(q, "Alice")
    enqueue!(q, "Bob")
    enqueue!(q, "Charlie")
    @test peek(q)  == "Alice"        # 1
    @test rear(q)  == "Charlie"      # 2
    @test length(q) == 3             # 3
    @test dequeue!(q) == "Alice"     # 4
    @test dequeue!(q) == "Bob"       # 5
    @test to_array(q) == ["Charlie"] # 6
    println("  [V07] PASS – hang doi kieu String")
end

@testset "V08 – Hang doi lon (1000 phan tu)" begin
    q = LinkedQueue{Int}()
    N = 1000
    for i in 1:N
        enqueue!(q, i)
    end
    @test length(q) == N             # 1
    @test peek(q)  == 1              # 2
    @test rear(q)  == N              # 3
    for i in 1:N
        @test dequeue!(q) == i       # 1000 phep kiem
    end
    @test isempty(q)                 # 1
    println("  [V08] PASS – hang doi lon $N phan tu")
end

println()
println("=" ^ 60)
println("  BO KIEM THU HOAN TAT")
println("=" ^ 60)
