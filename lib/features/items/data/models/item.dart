class Item {
  final String name;
  final String itemCode; // Added itemCode
  final String alias;
  final String parentGroup;
  final double price;
  final int quantity;
  final String unit;
  final String altUnit; // Added altUnit
  final String imageUrl;

  Item({
    required this.name,
    this.itemCode = '',
    this.alias = '',
    this.parentGroup = 'General',
    required this.price,
    required this.quantity,
    this.unit = 'Kgs.',
    this.altUnit = '',
    required this.imageUrl,
  });
}
