import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/ui/organisms/busy_menu_header.dart';
import '../../../../core/ui/organisms/shortcut_panel.dart';
import '../../../../core/constants/app_colors.dart';

class RegionalSettingsScreen extends StatefulWidget {
  const RegionalSettingsScreen({super.key});

  @override
  State<RegionalSettingsScreen> createState() => _RegionalSettingsScreenState();
}

class _RegionalSettingsScreenState extends State<RegionalSettingsScreen> {
  // Dropdowns
  final _dateFormats = ['DD/MM/YYYY', 'MM/DD/YYYY'];
  String _dateFormat = 'MM/DD/YYYY';

  final _numberFormats = [
    '999,999,999.99',
    '9,99,99,999.99',
    '999999999.99',
    '9.99.99.999,99',
  ];
  String _numberFormat = '999,999,999.99';

  final _timeFormats = ['12 Hours', '24 Hours'];
  String _timeFormat = '12 Hours';

  // Text fields
  final _dateSepCtrl = TextEditingController(text: '-');
  final _currSymCtrl = TextEditingController(text: 'Rs.');
  final _currStrCtrl = TextEditingController(text: 'LKR');
  final _currSubCtrl = TextEditingController(text: 'Cents');
  final _currDecCtrl = TextEditingController(text: '2');
  final _currFontCtrl = TextEditingController();
  final _skipSepCtrl = TextEditingController(text: 'N');
  final _countryCtrl = TextEditingController(text: 'Sri Lanka');
  final _stateCtrl = TextEditingController();

  @override
  void dispose() {
    for (final c in [_dateSepCtrl, _currSymCtrl, _currStrCtrl, _currSubCtrl,
      _currDecCtrl, _currFontCtrl, _skipSepCtrl, _countryCtrl, _stateCtrl]) {
      c.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const BusyMenuHeader(),
          Expanded(
            child: LayoutBuilder(builder: (context, constraints) {
              final isWide = constraints.maxWidth >= 700;
              return Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Align(
                      alignment: Alignment.topLeft,
                      child: _buildDialog(isWide, constraints.maxWidth),
                    ),
                  ),
                  if (isWide) const ShortcutPanel(items: []),
                ],
              );
            }),
          ),
          _buildStatusBar(),
        ],
      ),
    );
  }

  Widget _buildDialog(bool isWide, double maxWidth) {
    final dialogWidth = isWide ? 445.0 : (maxWidth - 16).clamp(280.0, 445.0);

    return Container(
      width: dialogWidth,
      margin: const EdgeInsets.all(0),
      decoration: BoxDecoration(
        color: const Color(0xFFECF3FB),
        border: Border.all(color: AppColors.primaryDark, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Title bar row
          Stack(
            children: [
              Center(
                child: Container(
                  margin: const EdgeInsets.only(top: 5, bottom: 5),
                  padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 2),
                  color: const Color(0xFFCC3333),
                  child: const Text('Regional Settings',
                      style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)),
                ),
              ),
              Positioned(
                top: 4,
                right: 4,
                child: Container(
                  width: 18,
                  height: 18,
                  color: const Color(0xFFD0D8E8),
                  child: const Icon(Icons.arrow_forward, size: 12, color: Colors.black54),
                ),
              ),
            ],
          ),
          // Form content
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            child: isWide ? _buildWideForm() : _buildNarrowForm(),
          ),
        ],
      ),
    );
  }

  // ── Wide (desktop): 2-column layout exactly matching Busy ERP ──
  Widget _buildWideForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _twoColRow('Date Format', _dropdown(_dateFormats, _dateFormat, (v) => setState(() => _dateFormat = v!), width: 120),
            'Date Separator', _tf(_dateSepCtrl, width: 32)),
        _gap,
        _twoColRow('Currency Symbol', _tf(_currSymCtrl, width: 80),
            'Currency String', _tf(_currStrCtrl, width: 50)),
        _gap,
        _twoColRow('Currency Sub-string', _tf(_currSubCtrl, width: 80),
            'Currency Decimal Places', _tf(_currDecCtrl, width: 30)),
        _gap,
        _oneColRow('Currency Font', _tf(_currFontCtrl, width: 180, enabled: false)),
        _gap,
        _oneColRow('Format for displaying numbers',
            _dropdown(_numberFormats, _numberFormat, (v) => setState(() => _numberFormat = v!), width: 140)),
        _gap,
        _twoColRow(
          'Skip Currency Separator in Numbers Formatting', _tf(_skipSepCtrl, width: 24),
          'Time Format', _dropdown(_timeFormats, _timeFormat, (v) => setState(() => _timeFormat = v!), width: 90),
        ),
        const SizedBox(height: 14),
        _countryStateBox(),
        const SizedBox(height: 16),
        _buttons(),
        const SizedBox(height: 10),
      ],
    );
  }

  // ── Narrow (mobile): single column stacked ──
  Widget _buildNarrowForm() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _mobileRow('Date Format', _dropdown(_dateFormats, _dateFormat, (v) => setState(() => _dateFormat = v!), width: 120)),
          _gap,
          _mobileRow('Date Separator', _tf(_dateSepCtrl, width: 40)),
          _gap,
          _mobileRow('Currency Symbol', _tf(_currSymCtrl, width: 100)),
          _gap,
          _mobileRow('Currency String', _tf(_currStrCtrl, width: 60)),
          _gap,
          _mobileRow('Currency Sub-string', _tf(_currSubCtrl, width: 100)),
          _gap,
          _mobileRow('Currency Decimal Places', _tf(_currDecCtrl, width: 40)),
          _gap,
          _mobileRow('Currency Font', _tf(_currFontCtrl, width: 160, enabled: false)),
          _gap,
          _mobileRow('Format for displaying numbers',
              _dropdown(_numberFormats, _numberFormat, (v) => setState(() => _numberFormat = v!), width: 140)),
          _gap,
          _mobileRow('Skip Separator', _tf(_skipSepCtrl, width: 28)),
          _gap,
          _mobileRow('Time Format',
              _dropdown(_timeFormats, _timeFormat, (v) => setState(() => _timeFormat = v!), width: 100)),
          const SizedBox(height: 14),
          _countryStateBox(),
          const SizedBox(height: 16),
          _buttons(),
          const SizedBox(height: 10),
        ],
      ),
    );
  }

  Widget get _gap => const SizedBox(height: 9);

  // ── Two-column row ──
  Widget _twoColRow(String l1, Widget w1, String l2, Widget w2) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(width: 170, child: _lbl(l1)),
        w1,
        const Spacer(),
        _lbl(l2),
        const SizedBox(width: 6),
        w2,
      ],
    );
  }

  Widget _oneColRow(String label, Widget child) {
    return Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
      SizedBox(width: 200, child: _lbl(label)),
      child,
    ]);
  }

  Widget _mobileRow(String label, Widget child) {
    return Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
      Expanded(child: _lbl(label)),
      const SizedBox(width: 6),
      child,
    ]);
  }

  Widget _lbl(String text, {Color color = const Color(0xFF800000)}) {
    return Text(text, style: TextStyle(fontSize: 11, color: color));
  }

  // ── Country & State grouped box ──
  Widget _countryStateBox() {
    return Container(
      decoration: BoxDecoration(border: Border.all(color: Colors.grey.shade400)),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned(
            top: -8,
            left: 8,
            child: Container(
              color: const Color(0xFFECF3FB),
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: const Text('-Country & State Information-',
                  style: TextStyle(fontSize: 10, color: Colors.black87)),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(8, 14, 8, 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _oneColRow('Country', _tf(_countryCtrl, width: 150, enabled: false)),
                const SizedBox(height: 6),
                _oneColRow('State', _tf(_stateCtrl, width: 150, enabled: false)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buttons() {
    return Row(mainAxisAlignment: MainAxisAlignment.center, children: [
      _btn('Save', () {}),
      const SizedBox(width: 8),
      _btn('Quit', () { if (context.canPop()) context.pop(); }),
    ]);
  }

  // ── Widgets ──

  Widget _tf(TextEditingController ctrl, {double width = 100, bool enabled = true}) {
    return SizedBox(
      width: width,
      height: 20,
      child: TextField(
        controller: ctrl,
        enabled: enabled,
        style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.black),
        decoration: InputDecoration(
          isDense: true,
          contentPadding: const EdgeInsets.symmetric(horizontal: 3, vertical: 2),
          filled: true,
          fillColor: enabled ? Colors.white : const Color(0xFFE8EDF4),
          border: const OutlineInputBorder(borderRadius: BorderRadius.zero,
              borderSide: BorderSide(color: Color(0xFFA0A0A0))),
          enabledBorder: const OutlineInputBorder(borderRadius: BorderRadius.zero,
              borderSide: BorderSide(color: Color(0xFFA0A0A0))),
          focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.zero,
              borderSide: BorderSide(color: AppColors.primaryDark, width: 2)),
          disabledBorder: InputBorder.none,
        ),
      ),
    );
  }

  Widget _dropdown(List<String> items, String value, ValueChanged<String?> onChanged, {double width = 110}) {
    return Container(
      width: width,
      height: 20,
      padding: const EdgeInsets.symmetric(horizontal: 3),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: const Color(0xFFA0A0A0)),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          isDense: true,
          isExpanded: true,
          style: const TextStyle(fontSize: 11, color: Colors.black, fontWeight: FontWeight.bold),
          items: items.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }

  Widget _btn(String label, VoidCallback onPressed) {
    return SizedBox(
      height: 24,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFFE8E8E8),
          foregroundColor: Colors.black,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
          side: const BorderSide(color: Color(0xFF888888)),
          elevation: 0,
        ),
        onPressed: onPressed,
        child: Text(label, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
      ),
    );
  }

  Widget _buildStatusBar() {
    return Container(
      height: 22,
      color: AppColors.primaryDark,
      alignment: Alignment.center,
      child: const Text('[ Esc - Quit ]   [ F2 - Done ]',
          style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.white)),
    );
  }
}
