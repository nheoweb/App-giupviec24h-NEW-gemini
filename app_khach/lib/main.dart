import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'theme/theme_mau_sac.dart';
import 'trangchu/trangchu_main.dart';

// Các thư viện Backend (Firebase, Supabase) sẽ được import ở đây
// import 'package:firebase_core/firebase_core.dart';
// import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  // Đảm bảo Flutter Core đã sẵn sàng trước khi kết nối Backend
  WidgetsFlutterBinding.ensureInitialized();

  // TODO: Nơi khởi tạo kết nối Firebase (dự án vieclam24h-da70e) và Supabase
  // await Firebase.initializeApp();
  // await Supabase.initialize(url: 'URL_CUA_BAN', anonKey: 'KEY_CUA_BAN');

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Thay thế MaterialApp bằng GetMaterialApp để dùng GetX
    return GetMaterialApp(
      title: 'App Khách Hàng',
      debugShowCheckedModeBanner: false, // Tắt dải băng Đỏ "DEBUG" góc phải
      theme: ThemeData(
        scaffoldBackgroundColor: mauNen,
        primaryColor: mauChuDao,
        appBarTheme: const AppBarTheme(
          backgroundColor: mauChuDao,
          iconTheme: IconThemeData(color: Colors.white),
        ),
        colorScheme: ColorScheme.fromSwatch().copyWith(
          primary: mauChuDao,
          secondary: mauNhan,
        ),
        fontFamily: 'Roboto', // Bạn có thể cấu hình Font sau
      ),
      home: const TrangChuMain(), // Trỏ thẳng vào file Trang Chủ vừa tạo
    );
  }
}
