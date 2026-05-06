import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../theme/theme_mau_sac.dart';
import 'donhang_controller.dart';
import 'donhang_sos.dart';
import 'donhang_video.dart';

class DonHangMain extends StatelessWidget {
  DonHangMain({super.key});

  // "Tiêm" (Inject) Controller vào UI
  final DonHangController controller = Get.put(DonHangController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: mauNen,
      appBar: AppBar(
        title: const Text(
          'Đặt thợ ngay',
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
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _vePhanChonDichVu(),
            const SizedBox(height: 24),
            _vePhanMoTaVanDe(),
            const SizedBox(height: 16),
            _veNutTinhNangKhacBiet(),
            const SizedBox(height: 24),
            _vePhanDiaChi(),
            const SizedBox(height: 40),
            _veNutTimTho(),
          ],
        ),
      ),
    );
  }

  // --- CÁC WIDGET CON ---
  Widget _vePhanChonDichVu() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '1. Bạn cần sửa gì?',
          style: TextStyle(
            color: mauChuChinh,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        Obx(
          () => Wrap(
            spacing: 10,
            runSpacing: 10,
            children: controller.danhSachDichVu.map((dichVu) {
              bool isSelected = controller.loaiDichVuDuocChon.value == dichVu;
              return ChoiceChip(
                label: Text(dichVu),
                selected: isSelected,
                selectedColor: mauChuDao.withOpacity(0.2),
                backgroundColor: mauNenXam,
                labelStyle: TextStyle(
                  color: isSelected ? mauChuDao : mauChuPhu,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                ),
                side: BorderSide(
                  color: isSelected ? mauChuDao : Colors.transparent,
                ),
                onSelected: (bool selected) {
                  controller.chonDichVu(dichVu);
                },
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  Widget _vePhanMoTaVanDe() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '2. Mô tả tình trạng (Không bắt buộc)',
          style: TextStyle(
            color: mauChuChinh,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        TextField(
          controller: controller.moTaController,
          maxLines: 3,
          decoration: InputDecoration(
            hintText: 'Ví dụ: Tủ lạnh kêu to, rò nước...',
            hintStyle: const TextStyle(color: mauChuPhu),
            filled: true,
            fillColor: mauNenXam,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
          ),
        ),
      ],
    );
  }

  Widget _veNutTinhNangKhacBiet() {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton.icon(
            onPressed: () {
              Get.to(() => DonHangVideo());
            },
            icon: const Icon(Icons.videocam, color: mauChuDao),
            label: const Text(
              'Quay Video\nBắt Bệnh',
              textAlign: TextAlign.center,
              style: TextStyle(color: mauChuChinh, fontSize: 13),
            ),
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 12),
              side: const BorderSide(color: mauChuDao),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: ElevatedButton.icon(
            onPressed: () {
              Get.to(() => DonHangSos());
            },
            icon: const Icon(Icons.warning_rounded, color: mauNen),
            label: const Text(
              'Cấp Cứu SOS\n(Có mặt 30p)',
              textAlign: TextAlign.center,
              style: TextStyle(color: mauNen, fontSize: 13),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: mauNhan,
              padding: const EdgeInsets.symmetric(vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _vePhanDiaChi() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '3. Địa chỉ của bạn',
          style: TextStyle(
            color: mauChuChinh,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        TextField(
          controller: controller.diaChiController,
          decoration: InputDecoration(
            hintText: 'Nhập địa chỉ chi tiết...',
            hintStyle: const TextStyle(color: mauChuPhu),
            prefixIcon: const Icon(Icons.location_on, color: mauChuDao),
            filled: true,
            fillColor: mauNenXam,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
          ),
        ),
      ],
    );
  }

  Widget _veNutTimTho() {
    return SizedBox(
      width: double.infinity,
      height: 55,
      child: ElevatedButton(
        onPressed: () {
          controller.xacNhanTimTho();
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: mauChuDao,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          elevation: 2,
        ),
        child: const Text(
          'TÌM THỢ NGAY',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: mauNen,
          ),
        ),
      ),
    );
  }
}
