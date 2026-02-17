import 'package:flutter/material.dart';

class ShortcutPanel extends StatelessWidget {
  final List<ShortcutItem> items;
  final VoidCallback? onHelp;

  const ShortcutPanel({
    super.key,
    required this.items,
    this.onHelp,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 140, // Fixed width for sidebar
      color: const Color(0xFFF0F0F0), // Light grey background
      child: Column(
        children: [
          _buildHeader(),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(2),
              itemCount: items.length,
              itemBuilder: (context, index) {
                return _buildShortcutButton(items[index]);
              },
            ),
          ),
          if (onHelp != null) ...[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: OutlinedButton(
                onPressed: onHelp,
                child: const Text('Training Videos'),
              ),
            ),
          ]
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      color: Colors.white,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            'Shortcut Keys',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          Icon(Icons.close, size: 14, color: Colors.red[800]),
        ],
      ),
    );
  }

  Widget _buildShortcutButton(ShortcutItem item) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 2),
      child: Material(
        color: const Color(0xFFE0E0E0), // Button face color
        elevation: 1,
        borderRadius: BorderRadius.circular(2),
        child: InkWell(
          onTap: item.onTap,
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey[400]!),
              borderRadius: BorderRadius.circular(2),
            ),
            child: Row(
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: Colors.grey),
                  ),
                  child: Text(
                    item.keyLabel,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.red, // Key color often red in legacy apps
                      fontSize: 11,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    item.label,
                    style: const TextStyle(
                      fontSize: 11,
                      color: Colors.black87,
                      fontWeight: FontWeight.w500,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class ShortcutItem {
  final String keyLabel;
  final String label;
  final VoidCallback onTap;

  const ShortcutItem({
    required this.keyLabel,
    required this.label,
    required this.onTap,
  });
}
