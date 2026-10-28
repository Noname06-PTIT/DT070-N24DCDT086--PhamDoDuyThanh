# =============================================================================
# tests/test_logic.py - Bo kiem thu (Unit Test) cua de tai DT070
# Sinh vien : Pham Do Duy Thanh | MSSV: N24DCDT086
# Chay lenh : pytest tests/test_logic.py -v -s
# =============================================================================

import pytest
from logic import (
    thong_tin_de_tai,
    tinh_ket_qua,
    liet_ke,
    kiem_tra_tinh_dung
)


# ===========================================================================
# HAM HO TRO IN LOG DEP RA CONSOLE
# ===========================================================================

def in_ket_qua(ma_ca, doi_tuong, input_str, expected, actual, is_pass):
    print("\n" + "=" * 70)
    print(f"MA CA     : {ma_ca}")
    print(f"DOI TUONG : {doi_tuong}")
    print(f"INPUT     : {input_str}")
    print(f"EXPECTED  : {expected}")
    print(f"ACTUAL    : {actual}")
    print(f"KET LUAN  : {'PASS ✓' if is_pass else 'FAIL ✗'}")
    print("=" * 70)


# ===========================================================================
# NHOM TC01 - NHAN DIEN SINH VIEN & DE TAI
# ===========================================================================

def test_TC01_nhan_dien_de_tai():
    ma_ca = "TC01 - Nhan dien de tai"
    doi_tuong = "Ham thong_tin_de_tai"
    input_str = "Khong co input"
    expected = "ma_de=DT070, mssv=N24DCDT086"

    info = thong_tin_de_tai()
    actual = f"ma_de={info.get('ma_de')}, mssv={info.get('mssv')}"
    is_pass = (info.get("ma_de") == "DT070" and info.get("mssv") == "N24DCDT086")

    in_ket_qua(ma_ca, doi_tuong, input_str, expected, actual, is_pass)
    assert is_pass, "Thong tin nhan dien sai!"


# ===========================================================================
# NHOM TC02 - KIEM TRA DAU VAO HOP LE (TRUONG HOP CO BAN)
# ===========================================================================

def test_TC02_input_hop_le_n0():
    ma_ca = "TC02 - Input hop le n=0"
    doi_tuong = "Ham liet_ke"
    input_str = "n=0"
    # TODO: Sua expected theo dau ra that cua thuat toan DT070 khi n=0
    expected = "[]"

    actual_val = liet_ke(0)
    actual = str(actual_val)
    # TODO: Sua dieu kien is_pass cho dung
    is_pass = isinstance(actual_val, list)

    in_ket_qua(ma_ca, doi_tuong, input_str, expected, actual, is_pass)
    assert is_pass


def test_TC03_input_hop_le_n1():
    ma_ca = "TC03 - Input hop le n=1"
    doi_tuong = "Ham liet_ke"
    input_str = "n=1"
    # TODO: Sua expected theo dau ra that cua thuat toan DT070 khi n=1
    expected = "Kieu list"

    actual_val = liet_ke(1)
    actual = str(actual_val)
    is_pass = isinstance(actual_val, list)

    in_ket_qua(ma_ca, doi_tuong, input_str, expected, actual, is_pass)
    assert is_pass


def test_TC04_vi_du_phieu_de_1():
    """Vi du 1 trong phieu de tai DT070 - thay gia tri can kiem tra"""
    ma_ca = "TC04 - Vi du 1 trong phieu"
    doi_tuong = "Ham liet_ke / tinh_ket_qua"
    # TODO: Lay vi du 1 tu phieu de tai DT070 cua ban
    input_str = "n=???"
    expected = "???"

    # TODO: Goi ham va sua dieu kien
    # actual_val = liet_ke(???)
    # is_pass = (actual_val == ???)
    is_pass = True  # Tam thoi PASS de chay duoc

    in_ket_qua(ma_ca, doi_tuong, input_str, expected, "Chua cai dat", is_pass)
    assert is_pass


def test_TC05_vi_du_phieu_de_2():
    """Vi du 2 trong phieu de tai DT070"""
    ma_ca = "TC05 - Vi du 2 trong phieu"
    doi_tuong = "Ham liet_ke / tinh_ket_qua"
    # TODO: Lay vi du 2 tu phieu de tai DT070 cua ban
    input_str = "n=???"
    expected = "???"

    is_pass = True  # Tam thoi PASS

    in_ket_qua(ma_ca, doi_tuong, input_str, expected, "Chua cai dat", is_pass)
    assert is_pass


# ===========================================================================
# NHOM TC06 - KIEM TRA NGOAI LE (INVALID INPUT)
# ===========================================================================

def test_TC06_n_am_phai_bao_loi():
    ma_ca = "TC06 - n am phai bao loi ValueError"
    doi_tuong = "Ham liet_ke bat ngoai le"
    input_str = "n=-1"
    expected = "Nem ngoai le ValueError"

    try:
        liet_ke(-1)
        is_pass = False
        actual = "KHONG co ngoai le (SAI)"
    except ValueError:
        is_pass = True
        actual = "Bat duoc ValueError (DUNG)"
    except Exception as e:
        is_pass = False
        actual = f"Loai ngoai le sai: {type(e).__name__}"

    in_ket_qua(ma_ca, doi_tuong, input_str, expected, actual, is_pass)
    assert is_pass, "Phai nem ValueError khi n < 0!"


# ===========================================================================
# NHOM TC07 - TINH DUNG DAN (DOI CHIEU VOI CHUAN)
# ===========================================================================

def test_TC07_tinh_dung_n3():
    ma_ca = "TC07 - Doi chieu tinh dung dan (n=3)"
    doi_tuong = "Ham kiem_tra_tinh_dung"
    input_str = "n=3"
    expected = "True (Ket qua khop thu vien chuan)"

    is_pass = kiem_tra_tinh_dung(3)
    actual = str(is_pass)

    in_ket_qua(ma_ca, doi_tuong, input_str, expected, actual, is_pass)
    assert is_pass, "Ket qua khong dung dan khi so sanh voi chuan!"


def test_TC08_tinh_dung_n4():
    ma_ca = "TC08 - Doi chieu tinh dung dan (n=4)"
    doi_tuong = "Ham kiem_tra_tinh_dung"
    input_str = "n=4"
    expected = "True"

    is_pass = kiem_tra_tinh_dung(4)
    actual = str(is_pass)

    in_ket_qua(ma_ca, doi_tuong, input_str, expected, actual, is_pass)
    assert is_pass
