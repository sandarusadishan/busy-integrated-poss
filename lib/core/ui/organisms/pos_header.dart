// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class POSHeader extends StatelessWidget implements PreferredSizeWidget {
  const POSHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF0F2027), Color(0xFF203A43), Color(0xFF2C5364)],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 4,
            offset: Offset(0, 2),
          )
        ],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      height: 56, // Standard AppBar height
      child: Row(
        children: [
          // Logo / Title
          const Icon(Icons.point_of_sale, color: Colors.white, size: 28),
          const SizedBox(width: 12),
          const Text(
            'Busy POS',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.2,
            ),
          ),

          Container(
              width: 1,
              margin: const EdgeInsets.symmetric(vertical: 12),
              color: Colors.white24),

          // Navigation Items
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                _buildNavItem(context, 'Items', Icons.inventory_2, '/items'),
                const SizedBox(width: 8),
                _buildNavItem(context, 'Sales', Icons.shopping_cart,
                    '/transaction/Sales-Order'),
                const SizedBox(width: 8),
                _buildNavItem(
                    context, 'Reports', Icons.bar_chart, null), // Placeholder
                const SizedBox(width: 8),
                _buildNavItem(
                    context, 'Settings', Icons.settings, null), // Placeholder
              ],
            ),
          ),

          // User Profile / Actions
          Row(
            children: [
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.notifications, color: Colors.white),
                tooltip: 'Notifications',
              ),
              const SizedBox(width: 8),
              const CircleAvatar(
                backgroundColor: Colors.white,
                radius: 16,
                child: Icon(Icons.person, color: Color(0xFF1565C0), size: 20),
              ),
              const SizedBox(width: 8),
              const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Admin User',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.bold)),
                  Text('Busy Mode',
                      style: TextStyle(color: Colors.white70, fontSize: 10)),
                ],
              )
            ],
          )
        ],
      ),
    );
  }

  Widget _buildNavItem(
      BuildContext context, String label, IconData icon, String? route) {
    // Check if current route matches (simple check)
    final String currentRoute = GoRouterState.of(context).uri.toString();
    final bool isSelected = route != null &&
        (currentRoute == route ||
            (route != '/' && currentRoute.startsWith(route)));

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: route != null ? () => context.push(route) : null,
        borderRadius: BorderRadius.circular(4),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: isSelected
                ? Colors.white.withValues(alpha: 0.2)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(4),
            border: isSelected ? Border.all(color: Colors.white30) : null,
          ),
          child: Row(
            children: [
              Icon(icon, color: Colors.white, size: 18),
              const SizedBox(width: 8),
              Text(
                label,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(56);
}
