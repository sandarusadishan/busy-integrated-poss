import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/sales_order_model.dart';
import '../../../items/data/models/item.dart';

// Dummy list of parties for dropdown
final partyListProvider = Provider<List<String>>((ref) {
  return [
    'Busy Infotech Pvt. Ltd.',
    'Savibala Hardware',
    'Walk-in Customer',
    'Saman Stores',
    'City Traders',
  ];
});

final salesOrderProvider =
    NotifierProvider<SalesOrderNotifier, SalesOrder>(SalesOrderNotifier.new);

class SalesOrderNotifier extends Notifier<SalesOrder> {
  @override
  SalesOrder build() {
    return SalesOrder(date: DateTime.now());
  }

  void updateHeader(
      {String? series,
      DateTime? date,
      String? voucherNo,
      String? partyName,
      String? materialCenter}) {
    state = SalesOrder(
      series: series ?? state.series,
      date: date ?? state.date,
      voucherNo: voucherNo ?? state.voucherNo,
      partyName: partyName ?? state.partyName,
      materialCenter: materialCenter ?? state.materialCenter,
      items: state.items,
      discountPercentage: state.discountPercentage,
      taxPercentage: state.taxPercentage,
    );
  }

  void addItem(Item item) {
    final newItem = SalesOrderItem(
      item: item,
      quantity: 1,
      price: item.price,
      unit: item.unit,
    );
    state = SalesOrder(
      series: state.series,
      date: state.date,
      voucherNo: state.voucherNo,
      partyName: state.partyName,
      materialCenter: state.materialCenter,
      items: [...state.items, newItem],
      discountPercentage: state.discountPercentage,
      taxPercentage: state.taxPercentage,
    );
  }

  void updateItem(int index, {double? quantity, double? price}) {
    final newItems = [...state.items];
    final oldItem = newItems[index];
    newItems[index] = SalesOrderItem(
      item: oldItem.item,
      quantity: quantity ?? oldItem.quantity,
      price: price ?? oldItem.price,
      unit: oldItem.unit,
    );
    state = SalesOrder(
      series: state.series,
      date: state.date,
      voucherNo: state.voucherNo,
      partyName: state.partyName,
      materialCenter: state.materialCenter,
      items: newItems,
      discountPercentage: state.discountPercentage,
      taxPercentage: state.taxPercentage,
    );
  }

  void removeItem(int index) {
    final newItems = [...state.items];
    newItems.removeAt(index);
    state = SalesOrder(
      series: state.series,
      date: state.date,
      voucherNo: state.voucherNo,
      partyName: state.partyName,
      materialCenter: state.materialCenter,
      items: newItems,
      discountPercentage: state.discountPercentage,
      taxPercentage: state.taxPercentage,
    );
  }

  void updateSundry({double? discount, double? tax}) {
    state = SalesOrder(
      series: state.series,
      date: state.date,
      voucherNo: state.voucherNo,
      partyName: state.partyName,
      materialCenter: state.materialCenter,
      items: state.items,
      discountPercentage: discount ?? state.discountPercentage,
      taxPercentage: tax ?? state.taxPercentage,
    );
  }
}
