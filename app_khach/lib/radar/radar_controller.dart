import 'package:get/get.dart';
// import '../services/services_supabase.dart'; // Mở ra sau khi nối API thật

class RadarController extends GetxController {
  // Biến trạng thái
  var dangQuet = true.obs;
  var thongBaoTrangThai = 'Đang quét khu vực quanh bạn...'.obs;
  var thoTimThay = [].obs;

  @override
  void onInit() {
    super.onInit();
    batDauQuetTho();
  }

  void batDauQuetTho() async {
    // Bước 1: Giả lập hiệu ứng quét Radar trong 3 giây
    await Future.delayed(const Duration(seconds: 3));
    thongBaoTrangThai.value = 'Đang gửi thông tin đến thợ...';

    // Bước 2: Giả lập hiệu ứng chờ thợ nhận đơn (2 giây)
    await Future.delayed(const Duration(seconds: 2));

    // Bước 3: Cập nhật UI khi tìm thấy thợ
    dangQuet.value = false;
    thongBaoTrangThai.value = 'Đã tìm thấy thợ gần bạn nhất!';

    // Giả lập dữ liệu thợ lấy từ bảng 'tho' trên Supabase
    thoTimThay.assignAll([
      {
        'tenTho': 'Trần Văn A',
        'khoangCach': '0.5 km',
        'danhGia': 4.9,
        'soChuyen': 120,
      },
    ]);
  }

  void huyTimKiem() {
    // Logic hủy tìm kiếm, quay lại trang trước
    Get.back();
  }
}
