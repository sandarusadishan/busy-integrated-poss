import 'dart:typed_data';

import 'package:flutter/services.dart' show rootBundle;
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

import 'package:busy_items_app/features/pos/presentation/providers/pos_provider.dart';

class InvoicePdfHps {
  static Future<Uint8List> buildPdfBytes({
    required List<CartItem> items,
    required String invoiceNo,
    required DateTime dateTime,
    required String customerName,
    String? mobile,
    required double subtotal,
    required double totalPaid,
    required String paymentLabel,
    required String companyName,
    required String addressLine,
    String footerUrl = "https://pos.svg.lk/pos/create",
  }) async {
    final logoBytes =
        (await rootBundle.load('assets/images/logo.png')).buffer.asUint8List();
    final logo = pw.MemoryImage(logoBytes);

    final doc = pw.Document();

    doc.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.fromLTRB(28, 24, 28, 24),
        footer: (context) => pw.Row(
          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
          children: [
            pw.Text(footerUrl, style: const pw.TextStyle(fontSize: 8)),
            pw.Text(
              '${context.pageNumber}/${context.pagesCount}',
              style: const pw.TextStyle(fontSize: 8),
            ),
          ],
        ),
        build: (context) {
          return [
            // ===== TOP HEADER =====
            pw.Row(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Expanded(
                  child: pw.Text(
                    _formatTopLeftDate(dateTime),
                    style: const pw.TextStyle(fontSize: 9),
                  ),
                ),
                pw.Expanded(
                  child: pw.Center(
                    child: pw.Image(logo, height: 24),
                  ),
                ),
                pw.Expanded(
                  child: pw.Align(
                    alignment: pw.Alignment.topRight,
                    child: pw.Text(
                      invoiceNo,
                      style: const pw.TextStyle(fontSize: 9),
                    ),
                  ),
                ),
              ],
            ),

            pw.SizedBox(height: 26),

            // ===== COMPANY =====
            pw.Center(
              child: pw.Text(
                companyName,
                style: pw.TextStyle(
                  fontSize: 12,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
            ),
            pw.SizedBox(height: 2),
            pw.Center(
              child: pw.Text(addressLine, style: const pw.TextStyle(fontSize: 8)),
            ),

            pw.SizedBox(height: 10),
            pw.Divider(thickness: 1),
            pw.SizedBox(height: 6),

            // ===== INFO SECTION =====
            pw.Row(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Expanded(
                  child: pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      _labelLine("Invoice No."),
                      _labelLine("Date"),
                      _labelLine("Customer"),
                      _labelLine("Mobile:"),
                    ],
                  ),
                ),
                pw.SizedBox(width: 12),
                pw.Expanded(
                  child: pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.end,
                    children: [
                      _valueLine(invoiceNo),
                      _valueLine(_formatRightDate(dateTime)),
                      _valueLine(customerName),
                      _valueLine(mobile ?? ""),
                    ],
                  ),
                ),
              ],
            ),

            pw.SizedBox(height: 10),
            pw.Divider(thickness: 0.8, color: PdfColors.grey400),
            pw.SizedBox(height: 8),

            // ===== ITEMS =====
            pw.Column(
              children: items.asMap().entries.map((e) {
                final idx = e.key + 1;
                final c = e.value;
                final lineTotal = c.item.price * c.quantity;

                final desc =
                    '#$idx. ${c.item.name} , ${c.quantity} , ${c.item.unit} ${c.item.price.toStringAsFixed(0)}';

                return pw.Column(
                  children: [
                    pw.Row(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        pw.Expanded(
                          child: pw.Text(desc, style: const pw.TextStyle(fontSize: 8)),
                        ),
                        pw.SizedBox(width: 10),
                        pw.Text(
                          lineTotal.toStringAsFixed(2),
                          style: const pw.TextStyle(fontSize: 8),
                        ),
                      ],
                    ),
                    pw.SizedBox(height: 2),
                    pw.Row(
                      children: [
                        pw.Text(
                          '${c.quantity.toStringAsFixed(2)} x ${c.item.price.toStringAsFixed(2)}',
                          style: const pw.TextStyle(fontSize: 8),
                        ),
                      ],
                    ),
                    pw.SizedBox(height: 8),
                    pw.Divider(thickness: 0.6, color: PdfColors.grey300),
                    pw.SizedBox(height: 8),
                  ],
                );
              }).toList(),
            ),

            pw.SizedBox(height: 20),

            // ===== TOTALS SECTION - ALIGNED WITH INFO SECTION ABOVE =====
            pw.Row(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                // LEFT COLUMN - Labels (Subtotal, Total, Cash, Total Paid)
                pw.Expanded(
                  child: pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      _labelLine("Subtotal:"),
                      _labelLine("Total:"),
                      _labelLine("$paymentLabel(${_formatCashDate(dateTime)}):"),
                      _labelLine("Total Paid:"),
                    ],
                  ),
                ),
                pw.SizedBox(width: 12),
                // RIGHT COLUMN - Values (Rs amounts)
                pw.Expanded(
                  child: pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.end,
                    children: [
                      _valueLine("Rs ${subtotal.toStringAsFixed(2)}"),
                      _valueLine("Rs ${subtotal.toStringAsFixed(2)}"),
                      _valueLine("Rs ${totalPaid.toStringAsFixed(2)}"),
                      _valueLine("Rs ${totalPaid.toStringAsFixed(2)}"),
                    ],
                  ),
                ),
              ],
            ),

            pw.SizedBox(height: 12),
            pw.Divider(thickness: 1),
          ];
        },
      ),
    );

    return doc.save();
  }

  static pw.Widget _labelLine(String t) => pw.Padding(
        padding: const pw.EdgeInsets.only(bottom: 2),
        child: pw.Text(
          t,
          style: pw.TextStyle(fontSize: 8, fontWeight: pw.FontWeight.bold),
        ),
      );

  static pw.Widget _valueLine(String t) => pw.Padding(
        padding: const pw.EdgeInsets.only(bottom: 2),
        child: pw.Text(t, style: const pw.TextStyle(fontSize: 8)),
      );

  static String _formatTopLeftDate(DateTime dt) {
    final d = '${dt.day}/${dt.month}/${dt.year.toString().substring(2)}';
    final h = dt.hour % 12 == 0 ? 12 : dt.hour % 12;
    final ampm = dt.hour >= 12 ? 'PM' : 'AM';
    final m = dt.minute.toString().padLeft(2, '0');
    return '$d, $h.$m $ampm';
  }

  static String _formatRightDate(DateTime dt) {
    final dd = dt.day.toString().padLeft(2, '0');
    final mm = dt.month.toString().padLeft(2, '0');
    final yyyy = dt.year.toString();
    final hh = dt.hour.toString().padLeft(2, '0');
    final mi = dt.minute.toString().padLeft(2, '0');
    return '$dd/$mm/$yyyy $hh:$mi';
  }

  static String _formatCashDate(DateTime dt) {
    final dd = dt.day.toString().padLeft(2, '0');
    final mm = dt.month.toString().padLeft(2, '0');
    final yyyy = dt.year.toString();
    return '$dd/$mm/$yyyy';
  }
}