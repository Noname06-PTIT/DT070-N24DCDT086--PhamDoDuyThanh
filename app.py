# =============================================================================
# app.py - Web Server Flask & REST API
# Sinh vien : Pham Do Duy Thanh | MSSV: N24DCDT086 | Ma de: DT070
# =============================================================================

from flask import Flask, render_template, request, jsonify
from logic import (
    liet_ke, liet_ke_co_trace, tinh_ket_qua,
    kiem_tra_tinh_dung, thong_tin_de_tai
)

app = Flask(__name__)


@app.route('/')
def home():
    info = thong_tin_de_tai()
    return render_template('index.html', info=info)


@app.route('/api/run', methods=['POST'])
def api_run():
    data = request.get_json() or {}
    try:
        n = int(data.get('n', 0))
        k = data.get('k')
        if k is not None:
            k = int(k)

        # Gioi han n de bao ve server
        if n > 10:
            return jsonify({
                "status": "error",
                "message": "Gia tri n toi da la 10 de bao ve server."
            }), 400

        so_ket_qua = tinh_ket_qua(n, k)
        ket_qua, trace = liet_ke_co_trace(n, k)

        return jsonify({
            "status": "success",
            "so_ket_qua": so_ket_qua,
            "ket_qua": ket_qua,
            "trace": trace,
            "tong_buoc": len(trace)
        })
    except ValueError as e:
        return jsonify({"status": "error", "message": str(e)}), 400
    except Exception as e:
        return jsonify({"status": "error", "message": f"Loi he thong: {str(e)}"}), 500


@app.route('/api/verify', methods=['GET'])
def api_verify():
    try:
        n = int(request.args.get('n', 3))
        k = request.args.get('k')
        if k is not None:
            k = int(k)
        if n > 8:
            return jsonify({"status": "error", "message": "n toi da 8 cho chuc nang kiem tra."}), 400

        is_correct = kiem_tra_tinh_dung(n, k)
        return jsonify({
            "status": "success",
            "n": n,
            "k": k,
            "tinh_dung": is_correct,
            "ket_luan": "DUNG" if is_correct else "SAI"
        })
    except Exception as e:
        return jsonify({"status": "error", "message": str(e)}), 400


if __name__ == '__main__':
    print("=== Khoi dong ung dung DT070 ===")
    print("Truy cap: http://localhost:5000")
    app.run(debug=True, port=5000)
