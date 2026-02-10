class Item {
  final String name;
  final String alias;
  final String parentGroup;
  final double price;
  final int quantity;
  final String unit;
  final String imageUrl;

  Item({
    required this.name,
    this.alias = '',
    this.parentGroup = 'General',
    required this.price,
    required this.quantity,
    this.unit = 'Kgs.',
    required this.imageUrl,
  });
}