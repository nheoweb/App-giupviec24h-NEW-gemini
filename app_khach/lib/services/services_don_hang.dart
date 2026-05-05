import 'package:supabase_flutter/supabase_flutter.dart';

class ServicesDonHang {
  // Khởi tạo đối tượng client của Supabase
  final _supabase = Supabase.instance.client;

  /// Hàm tạo đơn hàng mới đẩy lên Supabase
  /// Hàm này dùng chung cho cả việc đặt đơn thông thường và đơn SOS khẩn cấp
  Future<String?> taoDonHangMoi({
    required String tieuDe,
    required String moTa,
    required String loaiDichVu,
    required String diaChi,
    String? soDienThoai, // Có thể lấy từ form SOS
    bool laDonSos = false, // Mặc định là false, truyền true khi bấm nút SOS
  }) async {
    try {
      // Lấy ID của Khách Hàng đang đăng nhập
      // Trong giai đoạn test chưa ráp luồng Đăng nhập, biến này có thể bị null.
      final String? idKhachHang = _supabase.auth.currentUser?.id;

      // Chuẩn bị payload dữ liệu (Map) để INSERT vào bảng don_hang.
      // LƯU Ý: Các key ở đây phải gõ chính xác 100% tên cột trong database Supabase của bạn.
      final Map<String, dynamic> duLieuDonHang = {
        'tieuDe': tieuDe,
        'moTa': moTa,
        'loaiDichVu': loaiDichVu,
        'dia_chi': diaChi,
        'sos':
            laDonSos, // Cờ quyết định đây có phải đơn ưu tiên cam kết 30 phút không
        'trang_thai': 'Đang tìm thợ', // Trạng thái khởi tạo mặc định
        // Bảng don_hang hiện tại không có cột số điện thoại riêng,
        // ta tận dụng cột tuy_chon_them (kiểu text) để lưu SĐT liên hệ khẩn cấp
        'tuy_chon_them': soDienThoai != null
            ? 'SĐT Liên hệ nhanh: $soDienThoai'
            : null,
      };

      // Chỉ gán id_khach_hang nếu người dùng đã đăng nhập thật sự
      if (idKhachHang != null) {
        duLieuDonHang['id_khach_hang'] = idKhachHang;
      }

      // 1. Gọi API chọc thẳng vào bảng don_hang
      // 2. Thực hiện lệnh insert
      // 3. Chain thêm select('id').single() để Supabase trả về đúng cái ID uuid vừa tạo thay vì toàn bộ object
      final ketQuaTraVe = await _supabase
          .from('don_hang')
          .insert(duLieuDonHang)
          .select('id')
          .single();

      // Trả về ID đơn hàng thành công để UI lấy ID này ném cho service_thong_bao bắn Push
      return ketQuaTraVe['id'].toString();
    } catch (loiNgoaiLe) {
      // Log lỗi ra console để debug, không làm crash app
      print('Lỗi nghiêm trọng khi tạo đơn hàng trên Supabase: $loiNgoaiLe');
      return null; // Trả về null để file UI biết đường báo lỗi đỏ cho user
    }
  }
}
