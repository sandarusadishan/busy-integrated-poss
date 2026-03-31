import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../core/ui/organisms/busy_menu_header.dart';
import '../../../../core/ui/organisms/shortcut_panel.dart';
import '../../../../core/constants/app_colors.dart';

class DisplaySettingsScreen extends StatefulWidget {
  const DisplaySettingsScreen({super.key});

  @override
  State<DisplaySettingsScreen> createState() => _DisplaySettingsScreenState();
}

class _DisplaySettingsScreenState extends State<DisplaySettingsScreen> {
  // Y/N toggle states
  bool _maintainBgImage = false;
  bool _fitToScreen = false;
  bool _maintainLogoImage = false;

  // Image data
  Uint8List? _bgImageBytes;
  Uint8List? _logoImageBytes;
  final _bgImageCtrl = TextEditingController();
  final _logoImageCtrl = TextEditingController();
  final _topCtrl = TextEditingController(text: '0.00');
  final _leftCtrl = TextEditingController(text: '0.00');

  final _picker = ImagePicker();

  // Focus
  late final List<FocusNode> _nodes;
  int _focusedIndex = 0;

  @override
  void initState() {
    super.initState();
    _nodes = List.generate(10, (_) => FocusNode());
    WidgetsBinding.instance.addPostFrameCallback((_) => _nodes[0].requestFocus());
  }

  @override
  void dispose() {
    for (final n in _nodes) n.dispose();
    _bgImageCtrl.dispose();
    _logoImageCtrl.dispose();
    _topCtrl.dispose();
    _leftCtrl.dispose();
    super.dispose();
  }

  void _moveFocus(int delta) {
    final next = (_focusedIndex + delta).clamp(0, _nodes.length - 1);
    setState(() => _focusedIndex = next);
    _nodes[next].requestFocus();
  }

  Future<void> _pickImage({required bool isBg}) async {
    try {
      final picked = await _picker.pickImage(source: ImageSource.gallery);
      if (picked == null) return;
      final bytes = await picked.readAsBytes();
      setState(() {
        if (isBg) {
          _bgImageBytes = bytes;
          _bgImageCtrl.text = picked.name;
        } else {
          _logoImageBytes = bytes;
          _logoImageCtrl.text = picked.name;
        }
      });
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Could not pick image: $e'), duration: const Duration(seconds: 2)),
        );
      }
    }
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
    final w = isWide ? 400.0 : (maxWidth - 16).clamp(280.0, 400.0);
    return Container(
      width: w,
      decoration: BoxDecoration(
        color: const Color(0xFFECF3FB),
        border: Border.all(color: AppColors.primaryDark, width: 1),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Title
          Stack(children: [
            Center(
              child: Container(
                margin: const EdgeInsets.symmetric(vertical: 5),
                padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 2),
                color: const Color(0xFFCC3333),
                child: const Text('Display Settings',
                    style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)),
              ),
            ),
            Positioned(
              top: 4, right: 4,
              child: Container(
                width: 18, height: 18,
                color: const Color(0xFFD0D8E8),
                child: const Icon(Icons.arrow_forward, size: 12, color: Colors.black54),
              ),
            ),
          ]),

          Padding(
            padding: const EdgeInsets.fromLTRB(10, 4, 10, 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 1. Maintain Company Background Image?
                _ynRow('Maintain Company Background Image?', _maintainBgImage, _nodes[0], 0,
                    (v) => setState(() => _maintainBgImage = v)),

                if (_maintainBgImage) ...[
                  const SizedBox(height: 6),
                  // 2. Path + folder button + preview
                  _pathRow('Specify Company Background Image', _bgImageCtrl, _nodes[1], 1, isBg: true),

                  // Preview
                  if (_bgImageBytes != null) ...[
                    const SizedBox(height: 6),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(2),
                      child: Image.memory(_bgImageBytes!,
                          height: 60, fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => const SizedBox()),
                    ),
                  ],
                  const SizedBox(height: 6),

                  // 3. Fit to Screen?
                  _ynRow('Fit to Screen?', _fitToScreen, _nodes[2], 2,
                      (v) => setState(() => _fitToScreen = v)),

                  // 4. Top / Left (when not fit to screen)
                  if (!_fitToScreen) ...[
                    const SizedBox(height: 6),
                    Row(children: [
                      _lbl('Top'), const SizedBox(width: 6),
                      _numField(_topCtrl, _nodes[3]),
                      const SizedBox(width: 4),
                      _hint('(Inches)'),
                      const Spacer(),
                      _lbl('Left'), const SizedBox(width: 6),
                      _numField(_leftCtrl, _nodes[4]),
                      const SizedBox(width: 4),
                      _hint('(Inches)'),
                    ]),
                  ],
                  const SizedBox(height: 6),
                ] else
                  const SizedBox(height: 4),

                // 5. Maintain Company Logo Image?
                _ynRow('Maintain Company Logo Image?', _maintainLogoImage, _nodes[5], 5,
                    (v) => setState(() => _maintainLogoImage = v)),

                if (_maintainLogoImage) ...[
                  const SizedBox(height: 6),
                  _pathRow('Specify Company Logo Image', _logoImageCtrl, _nodes[6], 6, isBg: false),

                  // Preview
                  if (_logoImageBytes != null) ...[
                    const SizedBox(height: 6),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(2),
                      child: Image.memory(_logoImageBytes!,
                          height: 50, fit: BoxFit.contain,
                          errorBuilder: (_, __, ___) => const SizedBox()),
                    ),
                  ],
                ] else ...[
                  const SizedBox(height: 2),
                  Padding(
                    padding: const EdgeInsets.only(left: 2),
                    child: Text('Specify Company Logo Image',
                        style: TextStyle(fontSize: 10, color: Colors.grey.shade400)),
                  ),
                ],

                const SizedBox(height: 14),
                Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  _btn('Ok', () { if (context.canPop()) context.pop(); }),
                  const SizedBox(width: 8),
                  _btn('Quit', () { if (context.canPop()) context.pop(); }),
                ]),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ── Y/N Toggle Row ──
  Widget _ynRow(String label, bool value, FocusNode node, int idx, ValueChanged<bool> onChanged) {
    return KeyboardListener(
      focusNode: node,
      onKeyEvent: (e) {
        if (e is KeyDownEvent) {
          if (e.logicalKey == LogicalKeyboardKey.space || e.logicalKey == LogicalKeyboardKey.keyY) {
            onChanged(true);
          } else if (e.logicalKey == LogicalKeyboardKey.keyN) {
            onChanged(false);
          } else if (e.logicalKey == LogicalKeyboardKey.arrowDown || e.logicalKey == LogicalKeyboardKey.tab) {
            _moveFocus(1);
          } else if (e.logicalKey == LogicalKeyboardKey.arrowUp) {
            _moveFocus(-1);
          }
        }
      },
      child: GestureDetector(
        onTap: () {
          setState(() => _focusedIndex = idx);
          node.requestFocus();
          onChanged(!value);
        },
        child: Row(children: [
          Expanded(
            child: Text(label, style: const TextStyle(fontSize: 11, color: Color(0xFF800000))),
          ),
          const SizedBox(width: 6),
          Container(
            width: 22, height: 18,
            decoration: BoxDecoration(
              color: node.hasFocus ? AppColors.primary : Colors.white,
              border: Border.all(
                color: node.hasFocus ? AppColors.primaryDark : const Color(0xFFA0A0A0),
                width: node.hasFocus ? 2 : 1,
              ),
            ),
            alignment: Alignment.center,
            child: Text(value ? 'Y' : 'N',
                style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: node.hasFocus ? AppColors.primaryDark : Colors.black87)),
          ),
        ]),
      ),
    );
  }

  // ── Path Row with folder button ──
  Widget _pathRow(String label, TextEditingController ctrl, FocusNode node, int idx, {required bool isBg}) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(label, style: const TextStyle(fontSize: 10, color: Colors.black54)),
      const SizedBox(height: 2),
      Row(children: [
        Expanded(
          child: SizedBox(
            height: 22,
            child: TextField(
              controller: ctrl,
              focusNode: node,
              readOnly: true,
              style: const TextStyle(fontSize: 11),
              decoration: const InputDecoration(
                isDense: true,
                contentPadding: EdgeInsets.symmetric(horizontal: 4, vertical: 3),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(borderRadius: BorderRadius.zero,
                    borderSide: BorderSide(color: Color(0xFFA0A0A0))),
                enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.zero,
                    borderSide: BorderSide(color: Color(0xFFA0A0A0))),
                focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.zero,
                    borderSide: BorderSide(color: Colors.blue, width: 2)),
              ),
            ),
          ),
        ),
        const SizedBox(width: 2),
        // Folder browse button
        GestureDetector(
          onTap: () => _pickImage(isBg: isBg),
          child: Container(
            width: 24, height: 22,
            decoration: BoxDecoration(
              color: const Color(0xFFE0E8F0),
              border: Border.all(color: const Color(0xFF888888)),
            ),
            child: const Icon(Icons.folder_open, size: 14, color: Color(0xFF5D4037)),
          ),
        ),
      ]),
    ]);
  }

  Widget _numField(TextEditingController ctrl, FocusNode node) {
    return SizedBox(
      width: 55, height: 20,
      child: TextField(
        controller: ctrl,
        focusNode: node,
        keyboardType: TextInputType.number,
        style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
        decoration: InputDecoration(
          isDense: true,
          contentPadding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
          filled: true,
          fillColor: Colors.white,
          border: const OutlineInputBorder(borderRadius: BorderRadius.zero,
              borderSide: BorderSide(color: Color(0xFFA0A0A0))),
          enabledBorder: const OutlineInputBorder(borderRadius: BorderRadius.zero,
              borderSide: BorderSide(color: Color(0xFFA0A0A0))),
          focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.zero,
              borderSide: BorderSide(color: AppColors.primaryDark, width: 2)),
        ),
      ),
    );
  }

  Widget _lbl(String t) => Text(t, style: const TextStyle(fontSize: 11, color: Color(0xFF800000)));
  Widget _hint(String t) => Text(t, style: const TextStyle(fontSize: 10, color: Colors.deepPurple));

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
