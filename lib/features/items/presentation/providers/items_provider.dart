import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/dummy/dummy_items.dart';
import '../../data/models/item.dart';

final itemsProvider = Provider<List<Item>>((ref) {
  return getDummyItems();
});

final searchQueryProvider =
    NotifierProvider<SearchQueryNotifier, String>(SearchQueryNotifier.new);

class SearchQueryNotifier extends Notifier<String> {
  @override
  String build() => '';

  void setQuery(String query) {
    state = query;
  }
}
