import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../theme/theme_mau_sac.dart';
import 'donhang_controller.dart';

class DonHangSos extends StatelessWidget {
  DonHangSos({super.key});

  final DonHangController controller = Get.find<DonHangController>();

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.moTaController.clear();
      controller.diaChiController.clear();
    });

    return Scaffold(
      backgroundColor: mauLoi.withOpacity(
        0.05,
      ), // Dùng màu lỗi pha nhạt làm nền
      appBar: AppBar(
        title: const Text(
          'CẤP CỨU SOS',
          style: TextStyle(
            color: mauLoi,
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
        backgroundColor: mauLoi.withOpacity(0.05),
        elevation: 0,
        iconTheme: const IconThemeData(color: mauLoi),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Icon(Icons.warning_amber_rounded, size: 80, color: mauNhan),
            const SizedBox(height: 16),
            const Text(
              'Thợ giỏi nhất sẽ có mặt trong 30 phút!',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: mauChuChinh,
              ),
            ),
            const SizedBox(height: 32),
            TextField(
              controller: controller.diaChiController,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              decoration: InputDecoration(
                hintText: 'Nhập địa chỉ KHẨN CẤP...',
                prefixIcon: const Icon(
                  Icons.location_on,
                  color: mauLoi,
                  size: 28,
                ),
                filled: true,
                fillColor: mauNen,
                contentPadding: const EdgeInsets.symmetric(vertical: 20),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: const BorderSide(color: mauLoi, width: 2),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: const BorderSide(color: mauLoi, width: 2),
                ),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: controller.moTaController,
              decoration: InputDecoration(
                hintText: 'Mô tả nhanh (VD: Vỡ ống nước, chập điện...)',
                filled: true,
                fillColor: mauNen,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const Spacer(),
            Obx(
              () => SizedBox(
                width: double.infinity,
                height: 65,
                child: ElevatedButton(
                  onPressed: controller.dangTaiDuLieu.value
                      ? null
                      : () {
                          controller.xacNhanTimThoSos();
                        },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: mauLoi,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 5,
                  ),
                  child: controller.dangTaiDuLieu.value
                      ? const CircularProgressIndicator(color: mauNen)
                      : const Text(
                          'PHÁT TÍN HIỆU CỨU HỘ',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: mauNen,
                          ),
                        ),
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
