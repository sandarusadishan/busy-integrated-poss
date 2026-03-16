import 'package:go_router/go_router.dart';
import '../features/items/presentation/screens/items_screen.dart';
import '../features/pos/presentation/screens/pos_screen.dart';
import '../features/shared/screens/shared_screen.dart';
 // Add this import

final GoRouter appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const ItemsScreen(),
    ),
    GoRoute(
      path: '/pos',
      name: 'pos',  // Optional: named route
      builder: (context, state) => const POSScreen(),
    ),

     // ✅ NEW SHARED SCREEN ROUTE
    GoRoute(
      path: '/shared',
      name: 'shared',
      builder: (context, state) => const SharedScreen(),
    ),
  ],
);