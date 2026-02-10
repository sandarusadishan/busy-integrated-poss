import 'package:intl/intl.dart';

String formatPrice(double price) {
  return NumberFormat.currency(symbol: 'Rs. ', decimalDigits: 2).format(price);
}