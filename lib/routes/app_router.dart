import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../features/home/presentation/screens/home_screen.dart';
import '../features/sales/presentation/screens/sales_order_screen.dart';
import '../features/items/presentation/screens/items_screen.dart';
import '../features/items/presentation/screens/items_list_screen.dart';
import '../features/items/presentation/screens/item_master_screen.dart';
import '../features/items/presentation/screens/modify_item_screen.dart';
import '../features/items/data/models/item.dart';

final GlobalKey<NavigatorState> rootNavigatorKey = GlobalKey<NavigatorState>();

final GoRouter appRouter = GoRouter(
  navigatorKey: rootNavigatorKey,
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const HomeScreen(),
    ),
    GoRoute(
      path: '/items',
      builder: (context, state) => const ItemsScreen(),
    ),
    GoRoute(
      path: '/items-list',
      builder: (context, state) => const ItemsListScreen(),
    ),
    GoRoute(
      path: '/item-master',
      builder: (context, state) {
        final item = state.extra as Item?;
        return ItemMasterScreen(item: item);
      },
    ),
    GoRoute(
      path: '/transaction/:type',
      builder: (context, state) {
        final typeStr = state.pathParameters['type'] ?? 'Sales-Order';
        final title = typeStr.replaceAll('-', ' ');
        return SalesOrderScreen(title: title);
      },
    ),
    GoRoute(
      path: '/modify-item',
      builder: (context, state) {
        final item = state.extra as dynamic; // Cast to dynamic or Item
        return ModifyItemScreen(item: item);
      },
    ),
  ],
);
