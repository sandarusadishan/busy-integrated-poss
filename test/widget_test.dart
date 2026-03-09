import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:busy_items_app/features/items/presentation/screens/item_master_screen.dart';
import 'package:busy_items_app/features/items/presentation/screens/items_list_screen.dart';

void main() {
  testWidgets('Test Master Screen', (WidgetTester tester) async {
    await tester.pumpWidget(
        const ProviderScope(child: MaterialApp(home: ItemMasterScreen())));
    await tester.pumpAndSettle();
  });
  testWidgets('Test List Screen', (WidgetTester tester) async {
    await tester.pumpWidget(
        const ProviderScope(child: MaterialApp(home: ItemsListScreen())));
    await tester.pumpAndSettle();
  });
}
