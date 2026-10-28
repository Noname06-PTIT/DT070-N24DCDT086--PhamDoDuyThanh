# =============================================================================
# logic.py - Thuat toan cot loi cua de tai DT070
# Sinh vien : Pham Do Duy Thanh
# MSSV      : N24DCDT086
# Mon hoc   : Cau truc Du lieu va Giai thuat (INT13185) - PTIT
# =============================================================================

import math
import time
from itertools import permutations  # De doi sanh tinh dung dan


# --- THONG TIN DE TAI --------------------------------------------------------

def thong_tin_de_tai():
    return {
        "ma_de": "DT070",
        "ten_de": "<<Dien ten de tai DT070 cua ban vao day>>",
        "sinh_vien": "Pham Do Duy Thanh",
        "mssv": "N24DCDT086",
        "mon_hoc": "Cau truc Du lieu va Giai thuat (INT13185)",
        "hoc_vien": "Hoc vien Cong nghe Buu chinh Vien thong (PTIT)"
    }


# --- HAM TINH TOAN -----------------------------------------------------------

def tinh_ket_qua(n, k=None):
    """
    Ham tinh toan ket qua cua bai toan DT070.
    Vi du: dem so luong ket qua, tinh cong thuc toan hoc, ...
    
    Args:
        n (int): Gia tri dau vao chinh.
        k (int, optional): Gia tri thu hai neu can.
    Returns:
        Ket qua tinh toan (int / float / ...).
    Raises:
        ValueError: Neu dau vao khong hop le.
    """
    if n < 0:
        raise ValueError("Gia tri n phai la so nguyen khong am.")
    if k is not None and k < 0:
        raise ValueError("Gia tri k phai la so nguyen khong am.")

    # =============================================
    # TODO: Viet ham tinh toan chinh cua DT070 vao day
    # Vi du neu la bai toan dem to hop:
    #   if k is None: raise ValueError("Can gia tri k")
    #   return math.comb(n, k)
    # =============================================
    return 0  # Thay bang ket qua that


# --- THUAT TOAN LIET KE / SINH KET QUA ---------------------------------------

def liet_ke(n, k=None):
    """
    Ham liet ke toan bo ket qua cua bai toan DT070 (thuat toan de quy / lap).
    
    Returns:
        list: Danh sach cac ket qua (moi ket qua la 1 phan tu hoac danh sach con).
    """
    if n < 0:
        raise ValueError("Gia tri n phai la so nguyen khong am.")

    ket_qua = []

    # =============================================
    # TODO: Viet thuat toan liet ke chinh cua DT070 vao day
    # Vi du voi bai toan sinh hoan vi:
    #   def quay_lui(mang_hien_tai, da_dung):
    #       if len(mang_hien_tai) == n:
    #           ket_qua.append(list(mang_hien_tai))
    #           return
    #       for i in range(1, n + 1):
    #           if not da_dung[i]:
    #               da_dung[i] = True
    #               mang_hien_tai.append(i)
    #               quay_lui(mang_hien_tai, da_dung)
    #               mang_hien_tai.pop()
    #               da_dung[i] = False
    #   da_dung = [False] * (n + 1)
    #   quay_lui([], da_dung)
    # =============================================

    return ket_qua


# --- THUAT TOAN THEO TUNG BUOC (TRACE - Phuc vu giao dien Web) --------------

def liet_ke_co_trace(n, k=None):
    """
    Ham chay thuat toan va ghi lai lich su tung buoc (trace).
    Dung de ve animation step-by-step tren giao dien Web.
    
    Returns:
        tuple: (danh_sach_ket_qua, danh_sach_buoc_trace)
    """
    if n < 0:
        raise ValueError("Gia tri n phai la so nguyen khong am.")

    ket_qua = []
    trace = []
    buoc = [0]  # Dung list de co the sua trong ham long

    def ghi_buoc(mo_ta, trang_thai_hien_tai, loai="buoc"):
        buoc[0] += 1
        trace.append({
            "so_buoc": buoc[0],
            "mo_ta": mo_ta,
            "trang_thai": list(trang_thai_hien_tai) if trang_thai_hien_tai else [],
            "loai": loai  # "buoc", "ket_qua", "quay_lui"
        })

    ghi_buoc("Bat dau thuat toan", [], "bat_dau")

    # =============================================
    # TODO: Viet lai thuat toan chinh nhung co them
    #       loi goi ghi_buoc() tai moi buoc quan trong
    # =============================================

    ghi_buoc("Ket thuc thuat toan", [], "ket_thuc")
    return ket_qua, trace


# --- KIEM TRA TINH DUNG DAN (Doi chieu voi thu vien chuan / vet can) ---------

def kiem_tra_tinh_dung(n, k=None):
    """
    Ham doi chieu ket qua tu cai dat voi thu vien chuan Python
    hoac thuat toan vet can de chung minh tinh dung dan.
    
    Returns:
        bool: True neu ket qua khop, False neu co sai lech.
    """
    ket_qua_thuc_te = sorted([str(x) for x in liet_ke(n, k)])

    # =============================================
    # TODO: Tinh ket qua chuan de doi chieu
    # Vi du:
    #   ket_qua_chuan = sorted([str(list(p)) for p in permutations(range(1, n+1))])
    # =============================================
    ket_qua_chuan = ket_qua_thuc_te  # Tam thoi: coi la dung (thay bang so sanh that)

    return ket_qua_thuc_te == ket_qua_chuan
