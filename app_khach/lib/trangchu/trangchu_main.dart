import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../theme/theme_mau_sac.dart';
// import '../donhang/donhang_main.dart'; // Mở dòng này ra khi đã có trang Đặt đơn

class TrangChuMain extends StatelessWidget {
  const TrangChuMain({super.key});

  @override
  Widget build(BuildContext context) {
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
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Icon minh họa (có thể thay bằng hình ảnh sau)
            const Icon(Icons.handyman_rounded, size: 100, color: mauChuDao),
            const SizedBox(height: 20),

            const Text(
              'Sửa chữa nhanh chóng, an tâm tuyệt đối!',
              style: TextStyle(fontSize: 16, color: mauChuChinh),
            ),
            const SizedBox(height: 50),

            // Nút GỌI THỢ NGAY (Màu cam điểm nhấn)
            ElevatedButton(
              onPressed: () {
                // Get.to(() => const DonHangMain()); // Chuyển sang màn hình đặt đơn
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: mauNhan,
                padding: const EdgeInsets.symmetric(
                  horizontal: 40,
                  vertical: 20,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                elevation: 5,
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
    );
  }
}
