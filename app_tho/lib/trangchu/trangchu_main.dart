import 'package:flutter/material.dart';
import '../theme/theme_mau_sac.dart';

class TrangChuMain extends StatelessWidget {
  const TrangChuMain({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Trang Chủ Thợ'), centerTitle: true),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.engineering,
              size: 80,
              color: mauChuDao, // Sử dụng biến màu xanh lá từ theme
            ),
            const SizedBox(height: 20),
            const Text(
              'App Thợ đang sẵn sàng nhận việc!',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 40),
            // Nút giả lập tính năng SOS theo Project Charter
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: ElevatedButton.icon(
                onPressed: () {
                  // TODO: Xử lý logic khi có đơn khẩn cấp
                },
                icon: const Icon(Icons.warning_amber_rounded),
                label: const Text('Sẵn sàng nhận lệnh SOS'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: mauNhan, // Sử dụng biến màu cam từ theme
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
