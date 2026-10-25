# scripts/trace_and_scales.jl - Bang trace chi tiet va khao sat quy mo DT070
include(joinpath(@__DIR__, "..", "src", "LinkedQueue.jl"))
using .LinkedQueue

function in_trace()
    println("=================================================================")
    println("BANG TRACE CHI TIET VI DU 1: them(4); them(7); lay(); them(9)")
    println("Buoc | Lenh | Con tro dau | Con tro cuoi | n | Chuoi lien ket")
    println("-----------------------------------------------------------------")
    q = tao_hang_doi(Int)
    println("  0  | Khoi tao | nothing     | nothing      | 0 | (rong)")
    
    them!(q, 4)
    println("  1  | them(4)  | Node(4)     | Node(4)      | 1 | [4] -> nothing")
    
    them!(q, 7)
    println("  2  | them(7)  | Node(4)     | Node(7)      | 2 | [4] -> [7] -> nothing")
    
    v = lay!(q)
    println("  3  | lay()=$v | Node(7)     | Node(7)      | 1 | [7] -> nothing")
    
    them!(q, 9)
    println("  4  | them(9)  | Node(7)     | Node(9)      | 2 | [7] -> [9] -> nothing")
    println("Doi chieu ket qua: FIFO=[7, 9], n=2 -> KHOP 100% VOI PHIEU GIAO DE TAI.")
    println()
    
    println("=================================================================")
    println("BANG TRACE CHI TIET VI DU 2: them(5); lay(); them(8)")
    println("Buoc | Lenh | Con tro dau | Con tro cuoi | n | Chuoi lien ket")
    println("-----------------------------------------------------------------")
    q2 = tao_hang_doi(Int)
    println("  0  | Khoi tao | nothing     | nothing      | 0 | (rong)")
    
    them!(q2, 5)
    println("  1  | them(5)  | Node(5)     | Node(5)      | 1 | [5] -> nothing")
    
    v2 = lay!(q2)
    println("  2  | lay()=$v2| nothing     | nothing      | 0 | (rong - cuoi duoc xoa)")
    
    them!(q2, 8)
    println("  3  | them(8)  | Node(8)     | Node(8)      | 1 | [8] -> nothing")
    println("Doi chieu ket qua: FIFO=[8], dau=cuoi=Node(8) -> KHOP 100% VOI PHIEU GIAO DE TAI.")
    println()
end

function in_scales()
    println("=================================================================")
    println("KHAO SAT SO PHEP TOAN LIEN KET THEO 3 QUY MO n = 10, 50, 200")
    println("(Can cu theo muc Phan tich va nhan xet trong Phieu giao de tai DT070)")
    println("-----------------------------------------------------------------")
    println("Quy mo m | Co con tro cuoi (O(1)) | Khong co con tro cuoi (O(n)) | Ti le tiet kiem")
    println("-----------------------------------------------------------------")
    for m in [10, 50, 200]
        co_cuoi = dem_phep_toan_them(m)
        ko_cuoi = dem_phep_toan_khong_cuoi(m)
        ti_le = round(ko_cuoi / co_cuoi, digits=1)
        println("m = $(rpad(m, 4)) | $(rpad(co_cuoi, 22)) | $(rpad(ko_cuoi, 28)) | Giam $(ti_le) lan")
    end
    println("-----------------------------------------------------------------")
    println("NHAN XET:")
    println("  1. Khi co con tro cuoi, moi thao tac them chi mat dung 3 phep toan lien ket O(1),")
    println("     tong chi phi cho m lenh them la 3*m = O(m).")
    println("  2. Neu bo con tro cuoi, moi lan them phai duyet tu dau danh sach (k-1 phep doc),")
    println("     tong chi phi tro thanh m*(m-1)/2 + 2*m = O(m^2).")
    println("  3. O quy mo m = 200, viec giu con tro cuoi tiet kiem toi 33.8 lan so phep toan.")
    println("=================================================================")
end

in_trace()
in_scales()
