import 'package:go_router/go_router.dart';
import '../features/items/presentation/screens/items_screen.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const ItemsScreen(),
    ),
  ],
);