import 'package:flutter_test/flutter_test.dart';
import 'package:floricultura/main.dart';

void main() {
  testWidgets('lista mostra o registro de exemplo', (tester) async {
    await tester.pumpWidget(const FloriculturaApp());
    expect(find.text('Rosa'), findsOneWidget);
  });
}
