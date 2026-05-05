import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';

class ServicesFcm {
  final FirebaseMessaging _mayChuFirebase = FirebaseMessaging.instance;

  /// Hàm khởi tạo radar bắt sóng
  Future<void> khoiTaoLangNgheThongBao() async {
    // 1. Xin quyền người dùng hiển thị thông báo (Bắt buộc trên iOS và Android 13+)
    NotificationSettings caiDatQuyen = await _mayChuFirebase.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    if (caiDatQuyen.authorizationStatus == AuthorizationStatus.authorized) {
      print('✅ Thợ đã cấp quyền nhận thông báo nổ đơn.');

      // 2. Đăng ký nhận tín hiệu từ Kênh "SOS"
      // Phải khớp 100% với tên topic mà app_khach đã bắn ra
      await _mayChuFirebase.subscribeToTopic('tho_san_sang_sos');
      print('✅ Đã dò đúng đài, sẵn sàng bắt sóng kênh: tho_san_sang_sos');

      // 3. Xử lý khi app đang mở trên màn hình (Foreground)
      FirebaseMessaging.onMessage.listen((RemoteMessage tinNhanNhanDuoc) {
        if (tinNhanNhanDuoc.notification != null) {
          // Giao diện nổ đơn đập vào mắt thợ
          Get.snackbar(
            tinNhanNhanDuoc.notification!.title ?? '🚨 CÓ ĐƠN MỚI!',
            tinNhanNhanDuoc.notification!.body ?? 'Chạm để nhận đơn ngay.',
            backgroundColor: const Color(
              0xFFFBB040,
            ), // Màu cam cảnh báo (#fbb040)
            colorText: Colors.white,
            duration: const Duration(
              seconds: 8,
            ), // Hiển thị lâu hơn để thợ kịp đọc
            snackPosition: SnackPosition.TOP,
            margin: const EdgeInsets.all(16),
            icon: const Icon(
              Icons.electric_bolt_rounded,
              color: Colors.white,
              size: 32,
            ),
            mainButton: TextButton(
              onPressed: () {
                // TODO: Điều hướng vào trang Chi tiết đơn hàng để Nhận
                Get.back();
              },
              child: const Text(
                'XEM NGAY',
                style: TextStyle(color: Colors.white),
              ),
            ),
          );
        }
      });
    } else {
      print('❌ Thợ từ chối nhận thông báo.');
    }
  }
}
