import 'package:flutter_test/flutter_test.dart';
import 'package:example/main.dart'; // Ajusta si tu package del example tiene otro name en pubspec

void main() {
  testWidgets('Home shows list and navigates to VerySimpleFormExample', (
    tester,
  ) async {
    await tester.pumpWidget(const MyApp());

    // Home visible
    expect(find.text('DJSF Examples'), findsOneWidget);
    expect(find.text('Very simple form'), findsOneWidget);

    // Tap en el item
    await tester.tap(find.text('Very simple form'));
    await tester.pumpAndSettle();

    // Llegamos a la pantalla del ejemplo
    expect(find.text('DJSF Very Simple Example'), findsOneWidget);

    // Volver atrás
    await tester.pageBack();
    await tester.pumpAndSettle();

    // De nuevo en Home
    expect(find.text('DJSF Examples'), findsOneWidget);
  });
}
