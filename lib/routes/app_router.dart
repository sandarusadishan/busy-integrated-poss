import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../features/home/presentation/screens/home_screen.dart';
import '../features/sales/presentation/screens/sales_order_screen.dart';
import '../features/sales/presentation/screens/add_receipt_screen.dart';
import '../features/sales/presentation/screens/modify_receipt_screen.dart';
import '../features/sales/presentation/screens/list_receipt_screen.dart';
import '../features/items/presentation/screens/items_screen.dart';
import '../features/items/presentation/screens/items_list_screen.dart';
import '../features/items/presentation/screens/item_master_screen.dart';
import '../features/items/presentation/screens/modify_item_screen.dart';
import '../features/items/presentation/screens/add_account_screen.dart';
import '../features/items/presentation/screens/modify_account_screen.dart';
import '../features/items/presentation/screens/add_account_group_screen.dart';
import '../features/items/presentation/screens/modify_account_group_screen.dart';
import '../features/items/presentation/screens/list_account_group_screen.dart';
import '../features/items/presentation/screens/bulk_update_account_screen.dart';
import '../features/items/presentation/screens/bulk_update_item_screen.dart';
import '../features/items/presentation/screens/bulk_update_tax_screen.dart';
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
      path: '/add-account',
      builder: (context, state) => const AccountMasterScreen(),
    ),
    GoRoute(
      path: '/modify-account',
      builder: (context, state) => const ModifyAccountScreen(),
    ),
    GoRoute(
      path: '/add-account-group',
      builder: (context, state) => const AddAccountGroupScreen(),
    ),
    GoRoute(
      path: '/modify-account-group',
      builder: (context, state) => const ModifyAccountGroupScreen(),
    ),
    GoRoute(
      path: '/list-account-group',
      builder: (context, state) => const ListAccountGroupScreen(),
    ),
    GoRoute(
      path: '/bulk-update-account',
      builder: (context, state) => const BulkUpdateAccountScreen(),
    ),
    GoRoute(
      path: '/bulk-update-item',
      builder: (context, state) => const BulkUpdateItemScreen(),
    ),
    GoRoute(
      path: '/bulk-update-tax',
      builder: (context, state) => const BulkUpdateTaxScreen(),
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
      path: '/receipt/add',
      builder: (context, state) => const AddReceiptScreen(),
    ),
    GoRoute(
      path: '/receipt/modify',
      builder: (context, state) => const ModifyReceiptScreen(),
    ),
    GoRoute(
      path: '/receipt/list',
      builder: (context, state) => const ListReceiptScreen(),
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
