import 'package:example/examples/array_simple_example.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:dart_json_schema_form/dart_json_schema_form.dart';

import '../utils/base_app.dart';

void main() {
  group('ArraySimpleExample Tests', () {
    testWidgets('Renders initial UI correctly', (WidgetTester tester) async {
      await tester.pumpWidget(const BaseApp(child: ArraySimpleExample()));

      await tester.pumpAndSettle();

      // Verify AppBar title
      expect(find.text(ArraySimpleExample.title), findsOneWidget);

      // Verify language selection buttons are present
      for (final lang in languages) {
        expect(find.text(lang.toUpperCase()), findsOneWidget);
      }

      // Verify DjsfForm is present
      expect(find.byType(DjsfForm), findsOneWidget);

      // Verify "Add tag" button (text might be inside the DjsfForm's default add button)
      // DjsfForm uses "Add" by default for array items if addButtonText is not customized in uiSchema for items
      // The uiSchema provided customizes "addButtonText": "Add tag" for the "tags" array itself.
      expect(find.text('Add tag'), findsOneWidget);

      // Initially, because of minItems: 1, one item should be present.
      // The default item title for a string array item is "Item" unless specified.
      // The schema specifies "title": "Tag" for items.
      expect(find.text('Tag'), findsOneWidget);
    });

    testWidgets('Can add and remove tags', (WidgetTester tester) async {
      await tester.pumpWidget(const BaseApp(child: ArraySimpleExample()));

      await tester.pumpAndSettle();

      // Initial state should have one tag input due to minItems: 1
      expect(find.text('Tag'), findsOneWidget);

      // Type Tag 2 and Tap "Add tag" button
      await tester.tap(find.text('Add tag'));
      await tester.pumpAndSettle(); // Allow UI to update

      // Now there should be two tag input fields
      expect(find.text('Tag'), findsNWidgets(2));

      // Find the "Remove" button for the second tag.
      // Assuming the remove button is an Icon button with Icons.delete
      // and it's associated with the second item.
      // The uiSchema has "removable": true
      final removeButtons = find.text('Remove');
      expect(
        removeButtons,
        findsNWidgets(2),
      ); // One for each item, as minItems is 1 and removable is true

      // Tap the "Remove" button for the second tag
      await tester.tap(removeButtons.last);
      await tester.pumpAndSettle();

      // Now there should be only one tag input field left
      expect(find.text('Tag'), findsOneWidget);
    });
  });
}
