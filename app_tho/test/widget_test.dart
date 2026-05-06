import 'package:flutter_test/flutter_test.dart';
import 'package:app_tho/main.dart'; // Đảm bảo import đúng đường dẫn app của bạn

void main() {
  testWidgets('Kiểm tra khởi động App Thợ', (WidgetTester tester) async {
    // Gọi đúng class UngDungTho thay vì MyApp
    await tester.pumpWidget(const UngDungTho());

    // Một bài test cơ bản: Đảm bảo Widget UngDungTho được render thành công trên màn hình
    expect(find.byType(UngDungTho), findsOneWidget);
  });
}
