import 'package:flutter_test/flutter_test.dart';

import 'package:app/main.dart';

void main() {
  testWidgets('Character sheet renders primary sections', (tester) async {
    await tester.pumpWidget(const CharacterApp());

    expect(find.text('Essence Character Forge'), findsOneWidget);
    expect(find.text('Character Basics'), findsOneWidget);
    expect(find.text('Racial Abilities'), findsOneWidget);
  });
}
