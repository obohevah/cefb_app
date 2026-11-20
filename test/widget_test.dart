import 'package:flutter_test/flutter_test.dart';
import 'package:cefb_app/main.dart';

void main() {
  testWidgets('ChristEmbassyApp smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const ChristEmbassyApp());
    expect(find.byType(ChristEmbassyApp), findsOneWidget);
  });
}
