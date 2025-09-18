import 'package:clevertournamentapp/src/app.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  testWidgets('App renders dashboard shell', (WidgetTester tester) async {
    await tester.pumpWidget(const ProviderScope(child: CleverTournamentApp()));
    await tester.pumpAndSettle();

    expect(find.text('CleverTournament'), findsWidgets);
  });
}
