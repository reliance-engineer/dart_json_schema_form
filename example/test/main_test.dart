import 'package:flutter_test/flutter_test.dart';
import 'package:example/main.dart'; // Ajusta si tu package del example tiene otro name en pubspec

void main() {
  testWidgets('Home shows list and navigates to VerySimpleFormExample', (
    tester,
  ) async {
    await tester.pumpWidget(const MyApp());

    await tester.pumpAndSettle();

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

  testWidgets('Home shows list and navigates to ValidationMessagesExample', (
    tester,
  ) async {
    await tester.pumpWidget(const MyApp());

    await tester.pumpAndSettle();

    // Home visible
    expect(find.text('DJSF Examples'), findsOneWidget);
    expect(find.text('Validation messages'), findsOneWidget);

    // Tap en el item
    await tester.tap(find.text('Validation messages'));
    await tester.pumpAndSettle();

    // Llegamos a la pantalla del ejemplo
    expect(find.text('DJSF Validation messages'), findsOneWidget);

    // Volver atrás
    await tester.pageBack();
    await tester.pumpAndSettle();

    // De nuevo en Home
    expect(find.text('DJSF Examples'), findsOneWidget);
  });

  testWidgets('Home shows list and navigates to L18nMessagesExample', (
    tester,
  ) async {
    await tester.pumpWidget(const MyApp());

    await tester.pumpAndSettle();

    // Home visible
    expect(find.text('DJSF Examples'), findsOneWidget);
    expect(find.text('Internationalization Example'), findsOneWidget);

    // Tap en el item
    await tester.tap(find.text('Internationalization Example'));
    await tester.pumpAndSettle();

    // Llegamos a la pantalla del ejemplo
    expect(find.text('DJSF Internationalization Example'), findsOneWidget);

    // Volver atrás
    await tester.pageBack();
    await tester.pumpAndSettle();

    // De nuevo en Home
    expect(find.text('DJSF Examples'), findsOneWidget);
  });

  testWidgets('Home shows list and navigates to L18nCustomBundlesExample', (
    tester,
  ) async {
    await tester.pumpWidget(const MyApp());

    await tester.pumpAndSettle();

    // Home visible
    expect(find.text('DJSF Examples'), findsOneWidget);
    expect(find.text('Custom Internationalization Example'), findsOneWidget);

    // Tap en el item
    await tester.tap(find.text('Custom Internationalization Example'));
    await tester.pumpAndSettle();

    // Llegamos a la pantalla del ejemplo
    expect(
      find.text('DJSF Custom Internationalization Example'),
      findsOneWidget,
    );

    // Volver atrás
    await tester.pageBack();
    await tester.pumpAndSettle();

    // De nuevo en Home
    expect(find.text('DJSF Examples'), findsOneWidget);
  });
}
