import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/ui/organisms/busy_menu_header.dart';
import '../../../../core/ui/organisms/shortcut_panel.dart';
import '../../../../core/constants/app_colors.dart';

class FeaturesOptionsScreen extends StatefulWidget {
  const FeaturesOptionsScreen({super.key});

  @override
  State<FeaturesOptionsScreen> createState() => _FeaturesOptionsScreenState();
}

class _FeaturesOptionsScreenState extends State<FeaturesOptionsScreen> {
  int _selectedIndex = 0;
  late final FocusNode _focusNode;

  final List<_FeatureOption> _options = [
    _FeatureOption('Regional Settings', '/configuration/regional-settings'),
    _FeatureOption('Display Settings', '/configuration/display-settings'),
    _FeatureOption('General', null),
    _FeatureOption('Accounts', null),
    _FeatureOption('Inventory', null),
    _FeatureOption('VAT/GST', null),
    _FeatureOption('Excise', null, disabled: true),
    _FeatureOption('Service Tax', null, disabled: true),
    _FeatureOption('TDS/TCS', null),
    _FeatureOption('POS', null),
    _FeatureOption('Enquiry/Support Mgmt.', null),
    _FeatureOption('Enterprise Features', null),
    _FeatureOption('Exit', null, isExit: true),
  ];

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }



  void _activateOption(int index) {
    final opt = _options[index];
    if (opt.isExit) { context.pop(); return; }
    if (opt.route != null) {
      context.push(opt.route!);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('${opt.label} - not yet implemented'),
        duration: const Duration(seconds: 1),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Focus(
      focusNode: _focusNode,
      autofocus: true,
      onKeyEvent: (node, event) {
        if (event is KeyDownEvent || event is KeyRepeatEvent) {
          if (event.logicalKey == LogicalKeyboardKey.arrowDown) {
            setState(() => _selectedIndex = (_selectedIndex + 1).clamp(0, _options.length - 1));
            return KeyEventResult.handled;
          } else if (event.logicalKey == LogicalKeyboardKey.arrowUp) {
            setState(() => _selectedIndex = (_selectedIndex - 1).clamp(0, _options.length - 1));
            return KeyEventResult.handled;
          } else if (event.logicalKey == LogicalKeyboardKey.enter ||
              event.logicalKey == LogicalKeyboardKey.numpadEnter) {
            _activateOption(_selectedIndex);
            return KeyEventResult.handled;
          }
        }
        return KeyEventResult.ignored;
      },
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const BusyMenuHeader(),
            Expanded(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final isWide = constraints.maxWidth >= 800;
                  return Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Main panel — takes as much space as available
                      Expanded(child: _buildMainContainer(isWide)),
                      // Shortcut panel only on wide screens
                      if (isWide) const ShortcutPanel(items: []),
                    ],
                  );
                },
              ),
            ),
            _buildStatusBar(),
          ],
        ),
      ),
    );
  }

  Widget _buildMainContainer(bool isWide) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.primaryLight,
        border: Border(
          right: BorderSide(color: AppColors.primaryDark, width: 1),
          bottom: BorderSide(color: AppColors.primaryDark, width: 1),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Red title
          Container(
            margin: const EdgeInsets.only(top: 6, bottom: 6),
            alignment: Alignment.center,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 2),
              color: const Color(0xFFCC3333),
              child: const Text('Features / Options',
                  style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)),
            ),
          ),
          Expanded(
            child: isWide
                ? _buildWideLayout()
                : _buildNarrowLayout(),
          ),
        ],
      ),
    );
  }

  // Desktop: buttons on left, message on right
  Widget _buildWideLayout() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 200,
          child: _buildButtonList(),
        ),
        Expanded(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32.0),
              child: _buildHelpText(),
            ),
          ),
        ),
      ],
    );
  }

  // Mobile: buttons stacked, message below
  Widget _buildNarrowLayout() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: _buildHelpText(),
          ),
          const Divider(thickness: 1),
          _buildButtonList(),
        ],
      ),
    );
  }

  Widget _buildButtonList() {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.only(left: 8, top: 4, bottom: 8, right: 4),
      itemCount: _options.length,
      itemBuilder: (context, index) => _buildOptionButton(index),
    );
  }

  Widget _buildHelpText() {
    return Text(
      'From here you can configure the Features / Options available in Busy.  Please choose the section to be configured from the buttons provided in left.',
      textAlign: TextAlign.center,
      style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.black87, height: 1.5),
    );
  }

  Widget _buildOptionButton(int index) {
    final opt = _options[index];
    final isSelected = _selectedIndex == index;
    return GestureDetector(
      onTap: opt.disabled ? null : () {
        setState(() => _selectedIndex = index);
        _activateOption(index);
      },
      child: Container(
        height: 30,
        margin: const EdgeInsets.only(bottom: 2),
        decoration: BoxDecoration(
          color: opt.disabled
              ? AppColors.panelBg
              : (isSelected ? AppColors.primary : Colors.white),
          border: Border.all(
            color: isSelected ? AppColors.primaryDark : AppColors.border,
            width: isSelected ? 2 : 1,
          ),
        ),
        alignment: Alignment.center,
        child: Text(
          opt.label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: opt.disabled ? Colors.grey : Colors.black87,
          ),
        ),
      ),
    );
  }

  Widget _buildStatusBar() {
    return Container(
      height: 22,
      color: AppColors.primaryDark,
      alignment: Alignment.center,
      child: const Text('[ Esc - Quit ]',
          style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.white)),
    );
  }
}

class _FeatureOption {
  final String label;
  final String? route;
  final bool disabled;
  final bool isExit;
  const _FeatureOption(this.label, this.route, {this.disabled = false, this.isExit = false});
}
