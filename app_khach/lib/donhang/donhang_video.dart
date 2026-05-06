import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../theme/theme_mau_sac.dart';
import 'donhang_controller.dart';

class DonHangVideo extends StatelessWidget {
  DonHangVideo({super.key});

  final DonHangController controller = Get.find<DonHangController>();

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.duongDanVideo.value = '';
      controller.diaChiController.clear();
    });

    return Scaffold(
      backgroundColor: mauNen,
      appBar: AppBar(
        title: const Text(
          'Video Bắt Bệnh',
          style: TextStyle(
            color: mauChuChinh,
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
        backgroundColor: mauNen,
        elevation: 0,
        iconTheme: const IconThemeData(color: mauChuChinh),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Quay lại tình trạng hỏng hóc (Tối đa 10s)',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: mauChuChinh,
              ),
            ),
            const SizedBox(height: 16),
            GestureDetector(
              onTap: () {
                controller.quayVideoBatBenh();
              },
              child: Obx(() {
                bool daCoVideo = controller.duongDanVideo.value.isNotEmpty;
                return Container(
                  height: 200,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: daCoVideo ? mauChuDao.withOpacity(0.1) : mauNenXam,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: daCoVideo ? mauChuDao : mauDuongVien,
                      width: 2,
                      style: BorderStyle.solid,
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        daCoVideo ? Icons.check_circle : Icons.videocam,
                        size: 50,
                        color: daCoVideo ? mauChuDao : mauChuPhu,
                      ),
                      const SizedBox(height: 12),
                      Text(
                        daCoVideo ? 'Đã đính kèm Video' : 'Chạm để quay Video',
                        style: TextStyle(
                          color: daCoVideo ? mauChuDao : mauChuPhu,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                );
              }),
            ),
            const SizedBox(height: 32),
            const Text(
              'Địa chỉ của bạn',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: mauChuChinh,
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: controller.diaChiController,
              decoration: InputDecoration(
                hintText: 'Nhập địa chỉ để thợ đến...',
                prefixIcon: const Icon(Icons.location_on, color: mauChuDao),
                filled: true,
                fillColor: mauNenXam,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 40),
            Obx(
              () => SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  onPressed:
                      (controller.dangTaiDuLieu.value ||
                          controller.duongDanVideo.value.isEmpty)
                      ? null
                      : () {
                          controller.xacNhanTimTho();
                        },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: mauChuDao,
                    disabledBackgroundColor: mauDuongVien,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: controller.dangTaiDuLieu.value
                      ? const CircularProgressIndicator(color: mauNen)
                      : const Text(
                          'GỬI VIDEO & TÌM THỢ',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: mauNen,
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
