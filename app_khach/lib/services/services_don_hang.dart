import 'package:supabase_flutter/supabase_flutter.dart';
import 'dart:developer';

class ServicesDonHang {
  static final supabase = Supabase.instance.client;

  // Hàm tạo đơn hàng mới kết nối với bảng 'don_hang' trên Supabase
  static Future<bool> taoDonHangMoi({
    required String loaiDichVu,
    required String moTa,
    required String diaChi,
    required bool isSOS,
    String? videoBatBenh, // Đã bổ sung tham số này để hết lỗi đỏ
  }) async {
    try {
      // Lấy ID khách hàng hiện tại từ phiên đăng nhập
      final khachHangId = supabase.auth.currentUser?.id;

      // Chuẩn bị cục dữ liệu (Map) để đẩy lên Supabase
      // Key phải khớp 100% với tên cột trong bảng don_hang
      final duLieuDonHang = {
        'loaiDichVu': loaiDichVu,
        'moTa': moTa,
        'dia_chi': diaChi,
        'sos': isSOS,
        'trang_thai': 'Đang tìm thợ',
        // Chỉ gửi video lên nếu khách hàng có quay video
        if (videoBatBenh != null) 'video_bat_benh': videoBatBenh,
        if (khachHangId != null) 'id_khach_hang': khachHangId,
      };

      // Gọi lệnh Insert vào database
      await supabase.from('don_hang').insert(duLieuDonHang);

      return true;
    } catch (e) {
      log('Lỗi khi tạo đơn hàng mới: $e');
      return false;
    }
  }
}
