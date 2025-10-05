import 'package:example/examples/l18n_custom_bundle_example.dart';
import 'package:example/examples/l18n_messages_example.dart';
import 'package:example/examples/validation_messages_example.dart';
import 'package:example/examples/very_simple_form_example.dart';
import 'package:example/main.dart'; // Ajusta si tu package del example tiene otro name en pubspec
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('Home shows list and navigates to VerySimpleFormExample', (
    tester,
  ) async {
    await tester.pumpWidget(const MyApp());

    await tester.pumpAndSettle();

    // Home visible
    expect(find.text('DJSF Examples'), findsOneWidget);
    expect(find.text(VerySimpleFormExample.title), findsOneWidget);

    // Tap en el item
    await tester.tap(find.text(VerySimpleFormExample.title));
    await tester.pumpAndSettle();

    // Llegamos a la pantalla del ejemplo
    expect(find.text(VerySimpleFormExample.title), findsOneWidget);

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
    expect(find.text(ValidationMessagesExample.title), findsOneWidget);

    // Tap en el item
    await tester.tap(find.text(ValidationMessagesExample.title));
    await tester.pumpAndSettle();

    // Llegamos a la pantalla del ejemplo
    expect(find.text(ValidationMessagesExample.title), findsOneWidget);

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
    expect(find.text(L18nMessagesExample.title), findsOneWidget);

    // Tap en el item
    await tester.tap(find.text(L18nMessagesExample.title));
    await tester.pumpAndSettle();

    // Llegamos a la pantalla del ejemplo
    expect(find.text(L18nMessagesExample.title), findsOneWidget);

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
    expect(find.text(L18nCustomBundlesExample.title), findsOneWidget);

    // Tap en el item
    await tester.tap(find.text(L18nCustomBundlesExample.title));
    await tester.pumpAndSettle();

    // Llegamos a la pantalla del ejemplo
    expect(find.text(L18nCustomBundlesExample.title), findsOneWidget);

    // Volver atrás
    await tester.pageBack();
    await tester.pumpAndSettle();

    // De nuevo en Home
    expect(find.text('DJSF Examples'), findsOneWidget);
  });
}
