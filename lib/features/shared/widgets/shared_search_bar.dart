import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:busy_items_app/core/constants/app_colors.dart';
import 'package:busy_items_app/features/items/data/models/item.dart';
import 'package:busy_items_app/features/shared/providers/search_provider.dart';


class SharedSearchBar extends ConsumerWidget {
  final String hintText;
  final double? width;
  final bool showDropdown;
  final Function(Item)? onItemSelected;

  const SharedSearchBar({
    super.key,
    this.hintText = "Search items...",
    this.width,
    this.showDropdown = true,
    this.onItemSelected,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final searchQuery = ref.watch(sharedSearchQueryProvider);
    final filteredItems = ref.watch(filteredItemsProvider);
    final hasFocus = FocusNode();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: width ?? 300,
          height: 40,
          padding: const EdgeInsets.symmetric(horizontal: 8),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(4),
            border: Border.all(color: AppColors.primary.withOpacity(0.3)),
            boxShadow: const [
              BoxShadow(
                color: Color(0x0D000000),
                blurRadius: 2,
                offset: Offset(0, 1),
              ),
            ],
          ),
          child: Row(
            children: [
              const Icon(Icons.search, size: 20, color: AppColors.primary),
              const SizedBox(width: 8),
              Expanded(
                child: Focus(
                  onFocusChange: (hasFocus) {
                    if (!hasFocus && showDropdown) {
                      // Optionally hide dropdown when focus is lost
                    }
                  },
                  child: TextField(
                    focusNode: hasFocus,
                    decoration: InputDecoration(
                      hintText: hintText,
                      border: InputBorder.none,
                      isDense: true,
                      contentPadding: EdgeInsets.zero,
                    ),
                    style: const TextStyle(fontSize: 14),
                    onChanged: (val) => ref
                        .read(sharedSearchQueryProvider.notifier)
                        .setQuery(val),
                    onTap: () {
                      // Show dropdown when tapped
                    },
                  ),
                ),
              ),
              if (searchQuery.isNotEmpty)
                IconButton(
                  icon: const Icon(Icons.clear, size: 18),
                  onPressed: () => ref
                      .read(sharedSearchQueryProvider.notifier)
                      .clearQuery(),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
            ],
          ),
        ),
        
        // Dropdown with filtered items
        if (showDropdown && searchQuery.isNotEmpty && filteredItems.isNotEmpty)
          Container(
            width: width ?? 300,
            margin: const EdgeInsets.only(top: 2),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(4),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                ),
              ],
              border: Border.all(color: AppColors.border),
            ),
            constraints: const BoxConstraints(maxHeight: 300),
            child: ListView.builder(
              shrinkWrap: true,
              physics: const ClampingScrollPhysics(),
              itemCount: filteredItems.length,
              itemBuilder: (context, index) {
                final item = filteredItems[index];
                return ListTile(
                  leading: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(4),
                      color: Colors.grey[200],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: Image.network(
                        item.imageUrl,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) =>
                            const Icon(Icons.broken_image,
                                size: 20, color: Colors.grey),
                      ),
                    ),
                  ),
                  title: Text(
                    item.name,
                    style: const TextStyle(fontWeight: FontWeight.w500),
                  ),
                  subtitle: Text(
                    item.alias,
                    style: const TextStyle(fontSize: 12),
                  ),
                  trailing: Text(
                    'Rs. ${item.price.toStringAsFixed(2)}',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary,
                    ),
                  ),
                  onTap: () {
                    ref.read(sharedSearchQueryProvider.notifier).clearQuery();
                    onItemSelected?.call(item);
                  },
                );
              },
            ),
          ),
      ],
    );
  }
}