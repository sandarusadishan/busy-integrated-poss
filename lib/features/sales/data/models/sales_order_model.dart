import '../../../items/data/models/item.dart';

class SalesOrderItem {
  final Item item;
  double quantity;
  double price;
  String unit;

  SalesOrderItem({
    required this.item,
    required this.quantity,
    required this.price,
    required this.unit,
  });

  double get amount => quantity * price;
}

class SalesOrder {
  String series;
  DateTime date;
  String voucherNo;
  String partyName;
  String materialCenter;
  List<SalesOrderItem> items;
  // Bill Sundries
  double discountPercentage;
  double taxPercentage;

  SalesOrder({
    this.series = 'Main',
    required this.date,
    this.voucherNo = 'Auto',
    this.partyName = '',
    this.materialCenter = 'Main Store',
    this.items = const <SalesOrderItem>[],
    this.discountPercentage = 0.0,
    this.taxPercentage = 0.0,
  });

  double get subTotal => items.fold(0, (sum, item) => sum + item.amount);
  double get discountAmount => subTotal * (discountPercentage / 100);
  double get taxAmount => (subTotal - discountAmount) * (taxPercentage / 100);
  double get grandTotal => subTotal - discountAmount + taxAmount;
}
