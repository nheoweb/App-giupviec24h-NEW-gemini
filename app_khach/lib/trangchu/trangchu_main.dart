import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../theme/theme_mau_sac.dart';
// import '../services/services_don_hang.dart'; // Import file xử lý DB
// import 'trangchu_banner.dart'; // Mở comment khi viết xong phần Banner
// import 'trangchu_danh_sach.dart'; // Mở comment khi viết xong phần Danh sách

class TrangChuMain extends StatelessWidget {
  const TrangChuMain({super.key});

  @override
  Widget build(BuildContext context) {
    // Khởi tạo Service ở đây (Sẽ sử dụng khi nối API)
    // final ServicesDonHang donHangService = Get.put(ServicesDonHang());

    return Scaffold(
      backgroundColor: mauNen,
      appBar: AppBar(
        backgroundColor: mauChuDao,
        title: const Text(
          'Sàn Gọi Thợ 24/7',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        centerTitle: true,
        elevation: 0,
        actions: [
          // Nút Cấp cứu SOS theo Đặc tả Dự án (Cam kết 30 phút)
          IconButton(
            icon: const Icon(Icons.warning_rounded, color: mauLoi, size: 28),
            tooltip: 'Cấp cứu SOS',
            onPressed: () {
              // Chuyển hướng sang màn hình SOS
              // Get.to(() => const DonHangSos());
            },
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. Phân hệ Banner quảng cáo / Flash Sale
              // const TrangChuBanner(),
              const SizedBox(height: 30),

              // 2. Phân hệ Kêu gọi hành động chính (Tối ưu 3 cú chạm)
              Center(
                child: Column(
                  children: [
                    const Icon(
                      Icons.handyman_rounded,
                      size: 90,
                      color: mauChuDao,
                    ),
                    const SizedBox(height: 15),
                    const Text(
                      'Sửa chữa nhanh chóng, an tâm tuyệt đối!',
                      style: TextStyle(
                        fontSize: 16,
                        color: mauChuChinh,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 35),

                    // Nút bấm lớn màu Cam
                    ElevatedButton(
                      onPressed: () async {
                        // Logic lưu đơn hàng xuống Supabase thông qua Services
                        /*
                        bool thanhCong = await donHangService.taoDonHangMoi(
                          tieuDe: 'Cần thợ tổng hợp',
                          moTa: 'Khách hàng đặt nhanh từ màn hình chính',
                          idKhachHang: 'LAY_TU_GETX_AUTH_STATE',
                        );
                        
                        if (thanhCong) {
                          Get.snackbar(
                            'Thành công', 
                            'Hệ thống đang tìm thợ gần nhất...',
                            backgroundColor: mauChuDao,
                            colorText: Colors.white,
                          );
                        }
                        */
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: mauNhan,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 45,
                          vertical: 18,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        elevation: 4,
                      ),
                      child: const Text(
                        'GỌI THỢ NGAY',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 40),

              // 3. Phân hệ Danh mục dịch vụ mở rộng (Điện nước, Vệ sinh...)
              // Padding(
              //   padding: const EdgeInsets.symmetric(horizontal: 20),
              //   child: const Text(
              //     'Dịch vụ của chúng tôi',
              //     style: TextStyle(
              //       fontSize: 18,
              //       fontWeight: FontWeight.bold,
              //       color: mauChuChinh,
              //     ),
              //   ),
              // ),
              // const TrangChuDanhSach(),
            ],
          ),
        ),
      ),
    );
  }
}
