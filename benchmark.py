# =============================================================================
# benchmark.py - Do luong hieu nang thuat toan DT070
# Sinh vien : Pham Do Duy Thanh | MSSV: N24DCDT086
# =============================================================================

import time
from logic import liet_ke, tinh_ket_qua, kiem_tra_tinh_dung


def chay_benchmark():
    print("=" * 65)
    print("     BANG DO DAC HIEU NANG THUAT TOAN (BENCHMARK) - DT070")
    print("=" * 65)
    print(f"{'Input (n)':<12} | {'So ket qua':<15} | {'Thoi gian (giay)':<20}")
    print("-" * 65)

    test_cases = [1, 2, 3, 4, 5, 6, 7, 8]
    for n in test_cases:
        try:
            bat_dau = time.perf_counter()
            ds = liet_ke(n)
            ket_thuc = time.perf_counter()
            thoi_gian = ket_thuc - bat_dau
            so_ket_qua = len(ds) if isinstance(ds, list) else ds
            print(f"{n:<12} | {so_ket_qua:<15} | {thoi_gian:<20.6f}")
        except Exception as e:
            print(f"{n:<12} | {'LOI':<15} | {str(e):<20}")

    print("=" * 65)


def chay_kiem_tra_bien():
    print("\n=== KIEM TRA TRUONG HOP BIEN (ASSERT) ===")
    test_cases = [
        {"n": 0,  "expected_error": False},
        {"n": 1,  "expected_error": False},
        {"n": -1, "expected_error": True},
    ]

    for tc in test_cases:
        n = tc["n"]
        try:
            ds = liet_ke(n)
            if tc["expected_error"]:
                print(f"  [FAIL] n={n}: Mong doi loi nhung khong co loi")
            else:
                print(f"  [PASS] n={n}: Tra ve {len(ds) if isinstance(ds, list) else ds} ket qua")
        except ValueError as e:
            if tc["expected_error"]:
                print(f"  [PASS] n={n}: Bat duoc loi hop le -> {e}")
            else:
                print(f"  [FAIL] n={n}: Loi khong mong muon -> {e}")


def chay_kiem_tra_dung_dan():
    print("\n=== DOI CHIEU TINH DUNG DAN (n = 1 den 6) ===")
    for n in range(1, 7):
        try:
            is_ok = kiem_tra_tinh_dung(n)
            ket_luan = "DUNG" if is_ok else "SAI"
            print(f"  n={n}: [{ket_luan}]")
        except Exception as e:
            print(f"  n={n}: [LOI] {e}")


if __name__ == "__main__":
    chay_benchmark()
    chay_kiem_tra_bien()
    chay_kiem_tra_dung_dan()
    print("\n=== Benchmark hoan tat ===")
