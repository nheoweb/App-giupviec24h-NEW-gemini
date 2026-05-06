import 'package:supabase_flutter/supabase_flutter.dart';

class ServicesDonHang {
  // Khởi tạo đối tượng client của Supabase
  static final _supabase = Supabase.instance.client;

  // Hàm tạo đơn hàng mới, trả về true nếu thành công, false nếu thất bại
  static Future<bool> taoDonHangMoi({
    required String loaiDichVu,
    required String moTa,
    required String diaChi,
    bool isSOS = false,
  }) async {
    try {
      // Gọi lệnh insert vào bảng don_hang
      await _supabase.from('don_hang').insert({
        'loaiDichVu':
            loaiDichVu, // Tên cột tham chiếu theo file don_hang_36.png
        'moTa': moTa,
        'dia_chi': diaChi,
        'sos': isSOS,
        'trang_thai': 'Đang tìm thợ', // Trạng thái mặc định ban đầu
        // TODO: Mở comment dòng dưới khi đã làm xong phần Xác thực (Auth)
        // 'id_khach_hang': _supabase.auth.currentUser?.id,
      });

      return true; // Thành công
    } catch (e) {
      print('Lỗi ServicesDonHang - taoDonHangMoi: $e');
      return false; // Thất bại
    }
  }
}
