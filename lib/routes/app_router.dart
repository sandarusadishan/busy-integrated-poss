import 'package:go_router/go_router.dart';
import '../features/sales/presentation/screens/sales_order_screen.dart';
import '../features/items/presentation/screens/items_screen.dart';
import '../features/items/presentation/screens/modify_item_screen.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const ItemsScreen(),
    ),
    GoRoute(
      path: '/sales-order',
      builder: (context, state) => const SalesOrderScreen(),
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
