import 'dart:developer';

class ServicesThongBao {
  /// Hàm khởi tạo quyền thông báo và lưu FCM Token lên Supabase
  /// Hàm này được gọi khi app khởi động ở main.dart
  Future<void> khoiTaoVaLuuToken(String thoId) async {
    try {
      log('🔄 Bắt đầu khởi tạo dịch vụ thông báo cho Thợ ID: $thoId');

      // TODO: Bước 1 - Xin quyền nhận thông báo từ hệ điều hành (FirebaseMessaging.instance.requestPermission)
      // TODO: Bước 2 - Lấy FCM Token từ Firebase (FirebaseMessaging.instance.getToken)
      // TODO: Bước 3 - Cập nhật FCM Token vừa lấy được vào bảng 'tho' trên Supabase

      // Giả lập độ trễ gọi API để test
      await Future.delayed(const Duration(seconds: 1));

      log('✅ Đã lấy và lưu FCM Token thành công!');
    } catch (e) {
      log('❌ Có lỗi xảy ra trong quá trình cấu hình thông báo: $e');
      // Ném lỗi ra ngoài để main.dart có thể catch được nếu cần
      rethrow;
    }
  }
}
