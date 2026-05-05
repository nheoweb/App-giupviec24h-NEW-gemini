import 'dart:convert';
import 'package:http/http.dart' as http;

class ServicesThongBao {
  // Hàm gửi Push Notification nổ đơn cho hệ sinh thái Thợ
  Future<void> guiThongBaoDonMoiChoTho({
    required String idDonHang,
    required String tieuDeSuCo,
    required String loaiDichVu,
    required bool laDonKhanCapSos,
  }) async {
    try {
      // Tạm thời ở MVP, ta dùng Legacy API của Firebase để test cho nhanh.
      // Cần lấy Server Key trong cài đặt của project Firebase: vieclam24h-da70e
      const String khoaMayChuFirebase = 'ĐIỀN_SERVER_KEY_CỦA_FIREBASE_VÀO_ĐÂY';
      const String duongDanApi = 'https://fcm.googleapis.com/fcm/send';

      // Định tuyến: Nếu là đơn SOS, bắn cho toàn bộ thợ. Nếu không, bắn theo loại dịch vụ.
      String chuDeNhan = laDonKhanCapSos
          ? "/topics/tho_san_sang_sos"
          : "/topics/tho_$loaiDichVu";

      final Map<String, dynamic> duLieuThongBao = {
        "to": chuDeNhan,
        "notification": {
          "title": laDonKhanCapSos
              ? "🚨 CÓ ĐƠN SOS KHẨN CẤP!"
              : "⚡ CÓ ĐƠN $loaiDichVu MỚI!",
          "body": "Sự cố: $tieuDeSuCo. Chạm để nhận đơn ngay!",
          "sound": "default", // Chuông báo mặc định
        },
        "data": {
          "click_action": "FLUTTER_NOTIFICATION_CLICK",
          "idDonHang": idDonHang,
          "loaiThongBao": laDonKhanCapSos ? "DON_SOS" : "DON_THUONG",
        },
      };

      final phanHoi = await http.post(
        Uri.parse(duongDanApi),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'key=$khoaMayChuFirebase',
        },
        body: jsonEncode(duLieuThongBao),
      );

      if (phanHoi.statusCode == 200) {
        print('Đã bắn lệnh Push Notification thành công lên Firebase!');
      } else {
        print('Lỗi Firebase: ${phanHoi.body}');
      }
    } catch (loiNgoaiLe) {
      print('Lỗi ngoại lệ khi gửi Push: $loiNgoaiLe');
    }
  }
}
