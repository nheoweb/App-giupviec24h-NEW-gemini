import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:get/get.dart';

class ServicesThongBao {
  final _supabase = Supabase.instance.client;
  final FirebaseMessaging _fcm = FirebaseMessaging.instance;

  // Hàm khởi tạo và lưu token lên cơ sở dữ liệu
  Future<void> khoiTaoVaLuuToken(String idNguoiDung) async {
    // 1. Xin quyền hiển thị thông báo
    await _fcm.requestPermission();

    // 2. Lấy "địa chỉ" nhận thông báo của điện thoại này
    String? fcmToken = await _fcm.getToken();

    if (fcmToken != null) {
      // 3. Cập nhật fcmToken vào bảng nguoiDung trên Supabase
      await _supabase
          .from('nguoiDung')
          .update({'fcmToken': fcmToken})
          .eq('id', idNguoiDung);

      print('Đã lưu fcmToken thành công: $fcmToken');
    }

    // 4. Lắng nghe thông báo khi app đang mở (hiện tạm Snackbar qua GetX để test)
    FirebaseMessaging.onMessage.listen((RemoteMessage tinNhan) {
      if (tinNhan.notification != null) {
        Get.snackbar(
          tinNhan.notification!.title ?? 'Có thông báo',
          tinNhan.notification!.body ?? '',
          snackPosition: SnackPosition.TOP,
        );
      }
    });
  }
}
