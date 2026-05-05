import 'package:flutter/material.dart';
import 'package:get/get.dart';

// Import cấu hình màu sắc và các services (Tuân thủ Modularity)
import '../theme/theme_mau_sac.dart';
import '../services/services_don_hang.dart';
import '../services/services_thong_bao.dart';

class DonhangSos extends StatefulWidget {
  const DonhangSos({super.key});

  @override
  State<DonhangSos> createState() => _DonhangSosState();
}

class _DonhangSosState extends State<DonhangSos> {
  // 1. Khai báo biến 100% Tiếng Việt camelCase
  final TextEditingController noiDungSuCo = TextEditingController();
  final TextEditingController diaChiKhachHang = TextEditingController();
  final TextEditingController soDienThoaiLienHe = TextEditingController();

  bool trangThaiDangXuLy = false;

  // 2. Khởi tạo các lớp Services
  final ServicesDonHang _dichVuDonHang = ServicesDonHang();
  final ServicesThongBao _dichVuThongBao = ServicesThongBao();

  // 3. Hàm xử lý logic cốt lõi khi bấm nút SOS
  Future<void> xuLyGoiThoKhanCap() async {
    // Validate dữ liệu nhanh
    if (noiDungSuCo.text.trim().isEmpty ||
        diaChiKhachHang.text.trim().isEmpty ||
        soDienThoaiLienHe.text.trim().isEmpty) {
      Get.snackbar(
        'Thiếu thông tin!',
        'Vui lòng nhập đủ sự cố, số điện thoại và địa chỉ để thợ đến cứu viện nhé.',
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
        snackPosition: SnackPosition.TOP,
        margin: const EdgeInsets.all(16),
      );
      return;
    }

    // Bật hiệu ứng loading
    setState(() {
      trangThaiDangXuLy = true;
    });

    try {
      // BƯỚC 1: Gọi Service lưu xuống bảng don_hang trên Supabase
      // Lưu ý: Cần truyền cờ sos: true để database nhận diện đơn ưu tiên
      String? idDonTaoMoi = await _dichVuDonHang.taoDonHangMoi(
        tieuDe: 'SOS: ${noiDungSuCo.text}',
        moTa: noiDungSuCo.text,
        loaiDichVu: 'Khẩn Cấp', // Mặc định đơn SOS
        diaChi: diaChiKhachHang.text,
        soDienThoai: soDienThoaiLienHe.text,
        laDonSos: true,
      );

      // BƯỚC 2: Nếu tạo đơn thành công, gọi Firebase bắn Push Notification nổ đơn
      if (idDonTaoMoi != null) {
        await _dichVuThongBao.guiThongBaoDonMoiChoTho(
          idDonHang: idDonTaoMoi,
          tieuDeSuCo: noiDungSuCo.text,
          loaiDichVu: 'Khẩn Cấp',
          laDonKhanCapSos: true, // Cờ này giúp service bắn âm thanh còi hú
        );

        // Thành công -> Đóng trang SOS, quay về Trang chủ và báo tin vui
        Get.back();
        Get.snackbar(
          'Đã phát tín hiệu SOS! ⚡',
          'Hệ thống đang điều phối thợ đến ${diaChiKhachHang.text} trong vòng 30 phút.',
          backgroundColor: mauChuDao, // Đổi sang màu Xanh Lá tạo sự an tâm
          colorText: Colors.white,
          duration: const Duration(seconds: 5),
          snackPosition: SnackPosition.TOP,
          margin: const EdgeInsets.all(16),
        );
      } else {
        throw Exception('Không nhận được ID đơn hàng từ Supabase');
      }
    } catch (loi) {
      Get.snackbar(
        'Có lỗi xảy ra',
        'Không thể phát tín hiệu lúc này. Vui lòng thử lại!',
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
      );
      print('Lỗi xử lý SOS: $loi');
    } finally {
      // Tắt hiệu ứng loading dù thành công hay thất bại
      setState(() {
        trangThaiDangXuLy = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: mauNen, // Nền trắng sáng
      appBar: AppBar(
        title: const Text(
          'GỌI THỢ KHẨN CẤP',
          style: TextStyle(
            fontWeight: FontWeight.w900,
            color: Colors.white,
            letterSpacing: 1.2,
          ),
        ),
        backgroundColor: mauNhan, // Đổi AppBar sang màu Cam Khẩn cấp
        centerTitle: true,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SafeArea(
        // Dùng SafeArea để không bị lẹm vào tai thỏ/tai thỏ
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. Banner Cảnh báo & Cam kết
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: mauNhan.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: mauNhan.withOpacity(0.5)),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: const BoxDecoration(
                        color: mauNhan,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.timer_rounded,
                        color: Colors.white,
                        size: 28,
                      ),
                    ),
                    const SizedBox(width: 16),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'CAM KẾT 30 PHÚT',
                            style: TextStyle(
                              color: mauNhan,
                              fontSize: 16,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            'Thợ gần nhất sẽ bỏ qua các đơn khác để đến hỗ trợ bạn ngay lập tức.',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.black87,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),

              // 2. Form nhập liệu Tình trạng (Ưu tiên UX gõ nhanh)
              const Text(
                'Tình trạng sự cố:',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: noiDungSuCo,
                maxLines: 3,
                textInputAction: TextInputAction
                    .next, // Bấm Next trên bàn phím để nhảy ô dưới
                decoration: InputDecoration(
                  hintText: 'Ví dụ: Vỡ ống nước ngập sàn, chập cháy điện...',
                  hintStyle: TextStyle(color: Colors.grey.shade400),
                  filled: true,
                  fillColor: Colors.grey.shade50,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  focusedBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: mauNhan, width: 2),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // 3. Form nhập liệu Địa chỉ
              const Text(
                'Địa chỉ của bạn:',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: diaChiKhachHang,
                textInputAction: TextInputAction.next,
                decoration: InputDecoration(
                  hintText: 'Số nhà, tên đường, phường, quận...',
                  hintStyle: TextStyle(color: Colors.grey.shade400),
                  filled: true,
                  fillColor: Colors.grey.shade50,
                  prefixIcon: const Icon(
                    Icons.location_on_rounded,
                    color: mauNhan,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  focusedBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: mauNhan, width: 2),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // 4. Form nhập liệu Số điện thoại
              const Text(
                'Số điện thoại liên hệ:',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: soDienThoaiLienHe,
                keyboardType: TextInputType.phone,
                textInputAction: TextInputAction.done,
                decoration: InputDecoration(
                  hintText: 'Nhập số điện thoại để thợ gọi lại',
                  hintStyle: TextStyle(color: Colors.grey.shade400),
                  filled: true,
                  fillColor: Colors.grey.shade50,
                  prefixIcon: const Icon(
                    Icons.phone_in_talk_rounded,
                    color: mauChuDao,
                  ), // Mix chút màu xanh lá
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  focusedBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: mauNhan, width: 2),
                  ),
                ),
              ),

              const Spacer(), // Đẩy nút bấm xuống sát đáy màn hình
              // 5. NÚT HÀNH ĐỘNG CHÍNH (CTA) - Kích thước khổng lồ dễ chạm
              SizedBox(
                width: double.infinity,
                height: 65,
                child: ElevatedButton(
                  onPressed: trangThaiDangXuLy ? null : xuLyGoiThoKhanCap,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: mauNhan,
                    disabledBackgroundColor: mauNhan.withOpacity(0.6),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 8,
                    shadowColor: mauNhan.withOpacity(0.5),
                  ),
                  child: trangThaiDangXuLy
                      ? const SizedBox(
                          height: 28,
                          width: 28,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 3,
                          ),
                        )
                      : const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.wifi_tethering_error_rounded,
                              color: Colors.white,
                              size: 28,
                            ),
                            SizedBox(width: 12),
                            Text(
                              'PHÁT TÍN HIỆU SOS',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w900,
                                color: Colors.white,
                                letterSpacing: 1.0,
                              ),
                            ),
                          ],
                        ),
                ),
              ),
              const SizedBox(
                height: 12,
              ), // Khoảng cách an toàn với thanh vuốt iOS
            ],
          ),
        ),
      ),
    );
  }
}
