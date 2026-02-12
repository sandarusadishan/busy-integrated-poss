import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../items/data/models/item.dart';
import '../../items/data/dummy/dummy_items.dart';

// Provider for all items (you might want to share this too)
final allItemsProvider = Provider<List<Item>>((ref) {
  // You can refactor your dummy items to be shared
  return getDummyItems();
});

// Search query provider
final sharedSearchQueryProvider = 
    NotifierProvider<SharedSearchQueryNotifier, String>(
        SharedSearchQueryNotifier.new);

class SharedSearchQueryNotifier extends Notifier<String> {
  @override
  String build() => '';

  void setQuery(String query) {
    state = query;
  }

  void clearQuery() {
    state = '';
  }
}

// Filtered items provider that can be used anywhere
final filteredItemsProvider = Provider<List<Item>>((ref) {
  final allItems = ref.watch(allItemsProvider);
  final searchQuery = ref.watch(sharedSearchQueryProvider).toLowerCase();
  
  if (searchQuery.isEmpty) return allItems;
  
  return allItems.where((item) {
    return item.name.toLowerCase().contains(searchQuery) ||
        item.alias.toLowerCase().contains(searchQuery) ||
        item.parentGroup.toLowerCase().contains(searchQuery);
  }).toList();
});