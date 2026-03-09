import 'package:flutter/material.dart';

class BusyStatusBar extends StatelessWidget {
  final Map<String, dynamic>? company;
  final String userName;

  const BusyStatusBar({
    super.key,
    this.company,
    this.userName = 'Busy',
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 36,
      decoration: BoxDecoration(
        color: const Color(0xFFF5F5F5),
        border: Border(top: BorderSide(color: Colors.grey.shade400, width: 1)),
      ),
      child: Row(
        children: [
          // Busy Logo placeholder
          Container(
            width: 60,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              border: Border(right: BorderSide(color: Colors.grey.shade400)),
            ),
            child: const Text(
              'Busy',
              style: TextStyle(
                color: Color(0xFF0058D0),
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),

          _buildBox(
            '${company?['name'] ?? 'Savibala Hardware'}\n(Comp0001)',
            Colors.black,
            width: 250,
          ),
          _buildBox(
            'F.Y.        :      2026-27\nLST No. :',
            Colors.black,
            width: 150,
          ),
          _buildBox(
            'User        :      $userName\nCountry  :      Sri Lanka',
            Colors.black,
            width: 180,
          ),
          _buildBox(
            'Listening Port :      981\nBLS Valid Upto :      03-12-2025 (Expired)',
            Colors.red.shade900,
            width: 250,
          ),

          Expanded(
            child: Container(
              decoration: BoxDecoration(
                border: Border(right: BorderSide(color: Colors.grey.shade400)),
              ),
              alignment: Alignment.center,
              child: const Text(
                'Your\nCompanyLogo',
                style: TextStyle(color: Colors.red, fontSize: 10),
                textAlign: TextAlign.center,
              ),
            ),
          ),

          _buildBox(
            'F10 Calculator',
            Colors.black,
            width: 100,
          ),
          Container(
            width: 100,
            alignment: Alignment.center,
            child: const Text(
              'Monday\n09-03-2026',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 10),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBox(String text, Color textColor, {double? width}) {
    return Container(
      width: width,
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        border: Border(right: BorderSide(color: Colors.grey.shade400)),
      ),
      alignment: Alignment.centerLeft,
      child: Text(
        text,
        style: TextStyle(
          fontSize: 10,
          color: textColor,
          height: 1.2,
        ),
      ),
    );
  }
}
