import 'package:flutter/material.dart';

class CartTableCells {
  static Widget hCell(String text, double width, {bool center = false, bool right = false}) {
    return SizedBox(
      width: width,
      height: double.infinity,
      child: Align(
        alignment: right
            ? Alignment.centerRight
            : center
                ? Alignment.center
                : Alignment.centerLeft,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Text(
            text,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blueGrey.shade800),
          ),
        ),
      ),
    );
  }

  static Widget bCell(double width, Widget child) {
    return SizedBox(width: width, height: double.infinity, child: child);
  }
  
}
