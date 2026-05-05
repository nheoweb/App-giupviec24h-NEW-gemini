import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_core/firebase_core.dart';
import 'services/services_fcm.dart';

// Biến màu sắc mượn tạm từ thiết kế chuẩn
const Color mauChuDao = Color(0xFF88C057);

void main() async {
  // Bắt buộc gọi dòng này trước khi khởi tạo Firebase
  WidgetsFlutterBinding.ensureInitialized();

  // Khởi tạo Firebase
  // LƯU Ý: Bạn cần cấu hình file google-services.json cho Android vào thư mục app_tho/android/app
  await Firebase.initializeApp();

  // Khởi động Trạm Radar FCM
  final ServicesFcm dichVuFcm = ServicesFcm();
  await dichVuFcm.khoiTaoLangNgheThongBao();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'App Thợ GVD',
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: const Text(
            'Trạm Chờ Đơn',
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
          ),
          backgroundColor: mauChuDao, // Xanh lá
          centerTitle: true,
          elevation: 0,
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Hiệu ứng giả lập đang quét sóng
              const CircularProgressIndicator(color: mauChuDao),
              const SizedBox(height: 24),
              Text(
                'Đang bật radar bắt sóng đơn hàng... 📡',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.grey.shade700,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
