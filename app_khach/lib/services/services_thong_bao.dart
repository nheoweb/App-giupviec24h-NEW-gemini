import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'dart:developer';

class ServicesThongBao {
  static final _supabase = Supabase.instance.client;
  static final _fcm = FirebaseMessaging.instance;

  /// 1. Khởi tạo, xin quyền và lưu FCM Token của Khách hàng lên Supabase
  static Future<void> capNhatTokenKhachHang() async {
    try {
      final khachHangId = _supabase.auth.currentUser?.id;
      if (khachHangId == null) return; // Chưa đăng nhập thì bỏ qua

      // Yêu cầu quyền gửi thông báo (Bắt buộc trên iOS và Android 13+)
      NotificationSettings caiDat = await _fcm.requestPermission(
        alert: true,
        badge: true,
        sound: true,
      );

      if (caiDat.authorizationStatus == AuthorizationStatus.authorized) {
        // Lấy Token của thiết bị
        String? tokenThietBi = await _fcm.getToken();

        if (tokenThietBi != null) {
          // Lưu token vào cột fcm_token của bảng khach_hang
          await _supabase
              .from('khach_hang')
              .update({'fcm_token': tokenThietBi})
              .eq('id', khachHangId);

          log("✅ Đã cập nhật fcm_token cho Khách hàng: $khachHangId");
        }
      } else {
        log("⚠️ Khách hàng từ chối cấp quyền nhận thông báo.");
      }
    } catch (loiNgoaiLe) {
      log("❌ Lỗi khi cập nhật token Khách hàng: $loiNgoaiLe");
    }
  }

  /// 2. Lắng nghe thông báo khi Khách hàng đang mở App (Foreground)
  static void langNgheThongBaoTrenApp() {
    FirebaseMessaging.onMessage.listen((RemoteMessage thongBaoMoi) {
      log(
        '💌 Nhận được thông báo (Foreground): ${thongBaoMoi.notification?.title}',
      );

      // TODO: Tích hợp Provider hoặc GetX để show 1 Snackbar hoặc Dialog
      // Ví dụ báo cho khách: "Thợ Nguyễn Văn A đã nhận đơn của bạn!"
    });
  }

  /*
   * LƯU Ý CHO TEAM CODE:
   * Toàn bộ logic HTTP Post bắn thông báo bằng Server Key cũ đã bị xóa bỏ.
   * Để thông báo nổ đơn cho thợ, chỉ cần dùng hàm taoDonHangMoi() 
   * bên trong services_don_hang.dart. Supabase Webhook sẽ tự động kích hoạt.
   */
}
