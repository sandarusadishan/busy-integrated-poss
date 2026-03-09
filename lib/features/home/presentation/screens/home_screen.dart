import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/providers/auth_provider.dart';
import '../../../../core/ui/organisms/busy_menu_header.dart';
import '../../../../core/ui/organisms/open_company_dialog.dart';
import '../../../../core/ui/organisms/shortcut_panel.dart';
import '../../../../core/ui/organisms/status_bar.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  final FocusNode _homeFocusNode = FocusNode();

  @override
  void dispose() {
    _homeFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<AuthState>(authProvider, (previous, next) {
      if (!(previous?.isLoggedIn ?? false) && next.isLoggedIn) {
        // Automatically focus the menu right after login (delay prevents hasSize assert)
        Future.delayed(const Duration(milliseconds: 100), () {
          if (mounted) {
            BusyMenuHeader.companyFocusNode.requestFocus();
          }
        });
      }
    });

    final authState = ref.watch(authProvider);

    return CallbackShortcuts(
      bindings: {
        const SingleActivator(LogicalKeyboardKey.enter): () {
          if (!authState.isLoggedIn) {
            showDialog(
              context: context,
              barrierDismissible: false,
              builder: (_) => const OpenCompanyDialog(),
            );
          } else {
            BusyMenuHeader.companyFocusNode.requestFocus();
          }
        },
      },
      child: Focus(
        focusNode: _homeFocusNode,
        autofocus: true,
        child: Scaffold(
          backgroundColor:
              const Color(0xFFC4E4F9), // Light blue base behind everything
          body: Column(
            children: [
              const BusyMenuHeader(),
              Expanded(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Main Background Area
                    Expanded(
                      child: Container(
                        decoration: const BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Color(0xFFE5F3FD), // Top lighter blue
                              Color(0xFFACCDE8), // Bottom darker blue
                            ],
                          ),
                        ),
                        child: Stack(
                          children: [
                            if (authState.isLoggedIn)
                              Positioned(
                                bottom: 20,
                                left: 0,
                                right: 0,
                                child: Text(
                                  '${authState.company?['name'] ?? 'Savibala Hardware'} (F.Y. 2026-27)',
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color:
                                        Color(0xFF6B0000), // Dark classic red
                                  ),
                                ),
                              ),
                            if (!authState.isLoggedIn)
                              const Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.lock,
                                        size: 80, color: Colors.grey),
                                    SizedBox(height: 16),
                                    Text(
                                      'Please select a company to continue',
                                      style: TextStyle(
                                        fontSize: 18,
                                        color: Colors.black54,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                    // Right side Shortcut Panel
                    if (authState.isLoggedIn)
                      ShortcutPanel(
                        items: [
                          ShortcutItem(
                              keyLabel: 'F1', label: 'Help', onTap: () {}),
                          ShortcutItem(
                              keyLabel: 'F1',
                              label: 'Add Account',
                              onTap: () => context.push('/items')),
                          ShortcutItem(
                              keyLabel: 'F2',
                              label: 'Add Item',
                              onTap: () => context.push('/item-master')),
                          ShortcutItem(
                              keyLabel: 'F3',
                              label: 'Add Master',
                              onTap: () {}),
                          ShortcutItem(
                              keyLabel: 'F3',
                              label: 'Add Voucher',
                              onTap: () {}),
                          ShortcutItem(
                              keyLabel: 'F5',
                              label: 'Add Payment',
                              onTap: () =>
                                  context.push('/transaction/Payment')),
                          ShortcutItem(
                              keyLabel: 'F6',
                              label: 'Add Receipt',
                              onTap: () =>
                                  context.push('/transaction/Receipt')),
                          ShortcutItem(
                              keyLabel: 'F7',
                              label: 'Add Journal',
                              onTap: () =>
                                  context.push('/transaction/Journal')),
                          ShortcutItem(
                              keyLabel: 'F8',
                              label: 'Add Sales',
                              onTap: () => context.push('/transaction/Sales')),
                          ShortcutItem(
                              keyLabel: 'F9',
                              label: 'Add Purchase',
                              onTap: () =>
                                  context.push('/transaction/Purchase')),
                          ShortcutItem(
                              keyLabel: 'B',
                              label: 'Balance Sheet',
                              onTap: () {}),
                          ShortcutItem(
                              keyLabel: 'T',
                              label: 'Trial Balance',
                              onTap: () {}),
                          ShortcutItem(
                              keyLabel: 'S',
                              label: 'Stock Status',
                              onTap: () {}),
                          ShortcutItem(
                              keyLabel: 'A',
                              label: 'Acc. Summary',
                              onTap: () {}),
                          ShortcutItem(
                              keyLabel: 'L',
                              label: 'Acc. Ledger',
                              onTap: () {}),
                          ShortcutItem(
                              keyLabel: 'I',
                              label: 'Item Summary',
                              onTap: () {}),
                          ShortcutItem(
                              keyLabel: 'D',
                              label: 'Item Ledger',
                              onTap: () {}),
                          ShortcutItem(
                              keyLabel: 'G',
                              label: 'GST Summary',
                              onTap: () {}),
                          ShortcutItem(
                              keyLabel: 'U',
                              label: 'Switch User',
                              onTap: () {}),
                          ShortcutItem(
                              keyLabel: 'E',
                              label: 'Configuration',
                              onTap: () {}),
                          ShortcutItem(
                              keyLabel: 'K',
                              label: 'Lock Program',
                              onTap: () {}),
                        ],
                        onHelp: () {},
                      ),
                  ],
                ),
              ),
              // Bottom Status Bar
              if (authState.isLoggedIn)
                BusyStatusBar(company: authState.company),
            ],
          ),
        ),
      ),
    );
  }
}
