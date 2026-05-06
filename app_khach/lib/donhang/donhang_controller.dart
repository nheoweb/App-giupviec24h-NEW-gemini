import 'package:flutter/material.dart';
import 'package:get/get.dart';
// TODO: Import thư viện image_picker sau khi thêm vào pubspec.yaml
// import 'package:image_picker/image_picker.dart';

import '../theme/theme_mau_sac.dart';
import '../services/services_don_hang.dart';

class DonHangController extends GetxController {
  var loaiDichVuDuocChon = 'Sửa điện nước'.obs;
  var dangTaiDuLieu = false.obs;

  final moTaController = TextEditingController();
  final diaChiController = TextEditingController();

  final List<String> danhSachDichVu = [
    'Sửa điện nước',
    'Điện lạnh',
    'Dọn vệ sinh',
    'Sửa gia dụng',
  ];

  void chonDichVu(String dichVu) {
    loaiDichVuDuocChon.value = dichVu;
  }

  // === BỔ SUNG LƯU TRỮ TRẠNG THÁI VIDEO ===
  var duongDanVideo = ''.obs;

  Future<void> quayVideoBatBenh() async {
    // Code giả lập tạm thời khi chưa cài image_picker:
    duongDanVideo.value = 'da_co_video_demo.mp4';

    Get.snackbar(
      'Thành công',
      'Đã ghi hình tình trạng hỏng hóc',
      backgroundColor: mauChuDao,
      colorText: mauNen,
      margin: const EdgeInsets.all(16),
    );
  }

  // Hàm tiện ích để khách hàng có thể hủy video nếu quay sai
  void xoaVideoBatBenh() {
    duongDanVideo.value = '';
  }

  // --- LUỒNG ĐẶT THỢ TIÊU CHUẨN ---
  Future<void> xacNhanTimTho() async {
    String dichVu = loaiDichVuDuocChon.value;
    String moTa = moTaController.text.trim();
    String diaChi = diaChiController.text.trim();

    if (diaChi.isEmpty) {
      Get.snackbar(
        'Thiếu thông tin',
        'Quý khách vui lòng nhập địa chỉ để thợ có thể đến hỗ trợ nhé!',
        backgroundColor: mauNhan, // Màu cam nhấn cảnh báo nhẹ
        colorText: mauNen,
        snackPosition: SnackPosition.TOP,
        margin: const EdgeInsets.all(16),
      );
      return;
    }

    dangTaiDuLieu.value = true;

    // ĐÃ SỬA: Truyền thêm videoBatBenh vào Services
    bool ketQua = await ServicesDonHang.taoDonHangMoi(
      loaiDichVu: dichVu,
      moTa: moTa,
      diaChi: diaChi,
      isSOS: false,
      videoBatBenh: duongDanVideo.value.isNotEmpty ? duongDanVideo.value : null,
    );

    dangTaiDuLieu.value = false;

    if (ketQua) {
      // Reset lại form sau khi đặt thành công
      moTaController.clear();
      xoaVideoBatBenh();

      Get.snackbar(
        'Thành công!',
        'Đã gửi yêu cầu, hệ thống đang tìm thợ gần bạn nhất...',
        backgroundColor: mauChuDao, // Màu xanh lá uy tín
        colorText: mauNen,
        margin: const EdgeInsets.all(16),
      );
    } else {
      Get.snackbar(
        'Lỗi hệ thống',
        'Đường truyền có vấn đề, vui lòng thử lại sau.',
        backgroundColor: mauLoi,
        colorText: mauNen,
        margin: const EdgeInsets.all(16),
      );
    }
  }

  // === LUỒNG CẤP CỨU SOS ===
  Future<void> xacNhanTimThoSos() async {
    String diaChi = diaChiController.text.trim();

    if (diaChi.isEmpty) {
      Get.snackbar(
        'Khẩn cấp nhưng thiếu địa chỉ!',
        'Vui lòng nhập địa chỉ để thợ SOS phi đến ngay nhé!',
        backgroundColor: mauLoi, // Đỏ khẩn cấp
        colorText: mauNen,
        snackPosition: SnackPosition.TOP,
        margin: const EdgeInsets.all(16),
      );
      return;
    }

    dangTaiDuLieu.value = true;

    // ĐÃ SỬA: Truyền thêm videoBatBenh vào Services
    bool ketQua = await ServicesDonHang.taoDonHangMoi(
      loaiDichVu: 'Cấp cứu SOS',
      moTa: moTaController.text.trim(),
      diaChi: diaChi,
      isSOS: true,
      videoBatBenh: duongDanVideo.value.isNotEmpty ? duongDanVideo.value : null,
    );

    dangTaiDuLieu.value = false;

    if (ketQua) {
      moTaController.clear();
      xoaVideoBatBenh();

      Get.snackbar(
        'Đã phát tín hiệu SOS!',
        'Thợ cứu hộ đang trên đường tới trong vòng 30 phút.',
        backgroundColor: mauNhan, // Màu cam SOS
        colorText: mauNen,
        margin: const EdgeInsets.all(16),
        duration: const Duration(
          seconds: 4,
        ), // Hiển thị lâu hơn chút cho khách an tâm
      );
      // TODO: Điều hướng sang màn hình Radar Đỏ
    }
  }

  @override
  void onClose() {
    moTaController.dispose();
    diaChiController.dispose();
    super.onClose();
  }
}
