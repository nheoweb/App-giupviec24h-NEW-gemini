import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

// Tuân thủ nguyên tắc Modular: Import biến màu và các trang UI
import 'theme/theme_mau_sac.dart';
import 'trangchu/trangchu_main.dart';

// Import service xử lý logic (Tách biệt hoàn toàn với UI)
import 'services/services_thong_bao.dart';

void main() async {
  // 1. Đảm bảo Flutter Core đã sẵn sàng trước khi kết nối nền tảng Native (Firebase/Supabase)
  WidgetsFlutterBinding.ensureInitialized();

  // 2. Khởi tạo kết nối Firebase (Dự án vieclam24h-da70e)
  try {
    await Firebase.initializeApp();
    log("✅ Đã khởi tạo Firebase thành công cho App Thợ");
  } catch (e) {
    log("❌ Lỗi khởi tạo Firebase: $e");
  }

  // 3. Khởi tạo kết nối Supabase (Database & Realtime)
  try {
    await Supabase.initialize(
      // URL được lấy từ Data API Access trên Dashboard Supabase của bạn
      url: 'https://nbhsawvdmlkftgkjycmg.supabase.co',
      anonKey:
          'ĐIỀN_MÃ_ANON_KEY_CỦA_BẠN_VÀO_ĐÂY', // Thay mã Anon Key thật của project vào
    );
    log('✅ Khởi tạo Supabase thành công');
  } catch (e) {
    log('❌ Lỗi khởi tạo Supabase: $e');
  }

  // 4. Kích hoạt Service Lắng nghe Thông báo (FCM Token)
  try {
    final servicesThongBao = ServicesThongBao();
    // Tạm thời hardcode ID của 1 Thợ (Lấy uuid từ bảng 'tho') để test lưu token
    // Sau này sẽ lấy từ GetX Controller khi Thợ đăng nhập thành công
    await servicesThongBao.khoiTaoVaLuuToken('ID_THO_CUA_BAN_TREN_SUPABASE');
  } catch (e) {
    log('❌ Lỗi khởi tạo Service Thông Báo: $e');
  }

  // 5. Khởi chạy App
  runApp(const UngDungTho());
}

// ==========================================
// GIAO DIỆN KHỞI TẠO APP THỢ
// ==========================================
class UngDungTho extends StatelessWidget {
  const UngDungTho({super.key});

  @override
  Widget build(BuildContext context) {
    // Sử dụng GetMaterialApp để quản lý State và Route đa màn hình theo chuẩn dự án
    return GetMaterialApp(
      title: 'App Thợ - Sàn Dịch Vụ',
      debugShowCheckedModeBanner: false,

      // Thiết lập Theme chuẩn theo Project Charter: Nút to, chữ rõ, màu xanh lá/cam
      theme: ThemeData(
        scaffoldBackgroundColor: mauNen, // Màu nền trắng sáng
        primaryColor: mauChuDao, // Xanh lá #88c057
        appBarTheme: AppBarTheme(
          backgroundColor: mauChuDao,
          iconTheme: const IconThemeData(color: Colors.white),
          titleTextStyle: const TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
          elevation: 0,
        ),
        colorScheme: ColorScheme.fromSwatch().copyWith(
          primary: mauChuDao,
          secondary: mauNhan, // Cam SOS #fbb040
        ),
        textTheme: const TextTheme(
          bodyLarge: TextStyle(fontSize: 16, color: Colors.black87),
          bodyMedium: TextStyle(fontSize: 14, color: Colors.black87),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: mauChuDao,
            foregroundColor: Colors.white,
            minimumSize: const Size(
              double.infinity,
              54,
            ), // Nút bấm kích thước lớn, dễ chạm
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            elevation: 2,
          ),
        ),
        fontFamily: 'Roboto',
      ),

      // Khởi động vào thẳng Trang Chủ Thợ
      home: const TrangChuMain(),
    );
  }
}
