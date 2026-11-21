import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rak_baca/main.dart';

void main() {
  testWidgets('Cari buku, tandai favorit, lalu filter koleksi', (tester) async {
    await tester.pumpWidget(const RakBaca());
    await tester.enterText(find.byType(TextField), 'Sherlock');
    await tester.pump();
    expect(find.text('1 buku'), findsOneWidget);
    await tester.tap(find.byTooltip('Simpan ke favorit'));
    await tester.pump();
    await tester.enterText(find.byType(TextField), '');
    await tester.pump();
    await tester.tap(find.text('Favorit (1)'));
    await tester.pumpAndSettle();
    expect(find.text('The Adventures of Sherlock Holmes'), findsOneWidget);
    expect(find.text('Pride and Prejudice'), findsNothing);
  });
}
