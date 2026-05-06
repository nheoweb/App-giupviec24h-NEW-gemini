import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../theme/theme_mau_sac.dart'; // Nơi chứa mauChuDao, mauNen, mauNhan...
import 'radar_controller.dart';

class RadarMain extends StatelessWidget {
  RadarMain({super.key});

  final RadarController controller = Get.put(RadarController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: mauNen,
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Spacer(),

            // 1. Khối Hiệu ứng Radar / Ảnh đại diện
            Obx(
              () => Container(
                height: 200,
                width: 200,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: controller.dangQuet.value
                      ? mauChuDao.withOpacity(0.2)
                      : mauNhan.withOpacity(0.2), // Màu cam nhạt khi tìm thấy
                ),
                child: Center(
                  child: Icon(
                    controller.dangQuet.value
                        ? Icons.radar_rounded
                        : Icons.check_circle_rounded,
                    size: 100,
                    color: controller.dangQuet.value ? mauChuDao : mauNhan,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 40),

            // 2. Dòng chữ trạng thái
            Obx(
              () => Text(
                controller.thongBaoTrangThai.value,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: mauChuChinh,
                ),
              ),
            ),

            const SizedBox(height: 30),

            // 3. Khối thông tin Thợ (Chỉ hiện khi đã quét xong)
            Obx(() {
              if (controller.dangQuet.value) return const SizedBox.shrink();

              var tho = controller.thoTimThay[0];
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 24),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                elevation: 4,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      const CircleAvatar(
                        radius: 30,
                        backgroundColor: mauNenXam,
                        child: Icon(Icons.person, size: 40, color: mauChuDao),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              tho['tenTho'],
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: mauChuChinh,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                const Icon(
                                  Icons.star,
                                  color: mauNhan,
                                  size: 16,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  '${tho['danhGia']} (${tho['soChuyen']} chuyến)',
                                ),
                                const Spacer(),
                                const Icon(
                                  Icons.location_on,
                                  color: mauChuDao,
                                  size: 16,
                                ),
                                Text(tho['khoangCach']),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),

            const Spacer(),

            // 4. Nút Hủy
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Obx(
                () => TextButton(
                  onPressed: () => controller.huyTimKiem(),
                  style: TextButton.styleFrom(
                    foregroundColor: mauLoi,
                    minimumSize: const Size(double.infinity, 50),
                  ),
                  child: Text(
                    controller.dangQuet.value
                        ? 'HỦY TÌM KIẾM'
                        : 'QUAY LẠI TRANG CHỦ',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
