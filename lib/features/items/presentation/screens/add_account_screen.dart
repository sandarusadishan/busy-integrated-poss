import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/ui/organisms/busy_menu_header.dart';
import '../../../../core/ui/organisms/busy_keyboard_handler.dart';
import '../../../../core/ui/organisms/shortcut_panel.dart';

class AccountMasterScreen extends StatefulWidget {
  const AccountMasterScreen({super.key});

  @override
  State<AccountMasterScreen> createState() => _AccountMasterScreenState();
}

class _AccountMasterScreenState extends State<AccountMasterScreen> {
  // ── Controllers ──────────────────────────────────────────────────────────
  final _nameController = TextEditingController();
  final _aliasController = TextEditingController();
  final _printNameController = TextEditingController();
  final _groupController = TextEditingController();
  final _opBalController = TextEditingController(text: '0.00');
  final _prevYearBalController = TextEditingController(text: '0.00');
  final _addressController = TextEditingController();
  final _countryController = TextEditingController(text: '--Others--');
  final _itPanController = TextEditingController();
  final _emailController = TextEditingController();
  final _mobileNoController = TextEditingController();
  final _telNoController = TextEditingController();
  final _contactPersonController = TextEditingController();
  final _stationController = TextEditingController();
  final _vatController = TextEditingController();
  final _wardController = TextEditingController();
  final _whatsappNoController = TextEditingController();
  final _faxController = TextEditingController();
  final _transportController = TextEditingController();

  final _svatController = TextEditingController();
  final _lstNoController = TextEditingController();
  final _serviceTaxNoController = TextEditingController();
  final _lbtNoController = TextEditingController();
  final _ieCodeController = TextEditingController();

  String _opBalDrCr = 'D';
  String _prevYearBalDrCr = 'D';

  @override
  void dispose() {
    _nameController.dispose();
    _aliasController.dispose();
    _printNameController.dispose();
    _groupController.dispose();
    _opBalController.dispose();
    _prevYearBalController.dispose();
    _addressController.dispose();
    _countryController.dispose();
    _itPanController.dispose();
    _emailController.dispose();
    _mobileNoController.dispose();
    _telNoController.dispose();
    _contactPersonController.dispose();
    _stationController.dispose();
    _vatController.dispose();
    _wardController.dispose();
    _whatsappNoController.dispose();
    _faxController.dispose();
    _transportController.dispose();
    _svatController.dispose();
    _lstNoController.dispose();
    _serviceTaxNoController.dispose();
    _lbtNoController.dispose();
    _ieCodeController.dispose();
    super.dispose();
  }

  // ── Build ─────────────────────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    // Custom exact color matching the screenshots
    const bgColor = Color(0xFFE3F2FD); // Light Blue 50
    const titleBoxColor = Color(0xFF1565C0); // Blue 800

    return Scaffold(
      backgroundColor: bgColor,
      body: BusyKeyboardHandler(
        onEscape: () => context.pop(),
        onF2: () => _handleSave(context),
        child: Column(
          children: [
            // ── Main Menu Header ─────────────────────────────────────────────
            const BusyMenuHeader(),

            // ── Title Bar ────────────────────────────────────────────────────
            Container(
              width: double.infinity,
              alignment: Alignment.center,
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 2),
                decoration: BoxDecoration(
                    color: titleBoxColor,
                    border: Border.all(color: Colors.white, width: 1),
                    boxShadow: const [
                      BoxShadow(color: Colors.grey, offset: Offset(2, 2)),
                    ]),
                child: const Text(
                  'Add Account Master',
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 13),
                ),
              ),
            ),

            // ── Main Content ─────────────────────────────────────────────────
            Expanded(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // ── Form (3 columns) ─────────────────────────────────────
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // ── LEFT COLUMN: General Info ─────────────────────
                          Expanded(
                            flex: 12,
                            child: _buildGroupBox(
                              title: 'General Info.',
                              child: SingleChildScrollView(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    _buildDenseRow('Name', _nameController,
                                        isNameField: true),
                                    _buildDenseRow('(Alias)', _aliasController),
                                    _buildDenseRow(
                                        'Print Name', _printNameController),
                                    const SizedBox(height: 12),
                                    _buildDenseRow('Group', _groupController),
                                    const SizedBox(height: 12),
                                    _buildBalRow(
                                        'Op. Bal.',
                                        _opBalController,
                                        _opBalDrCr,
                                        (val) =>
                                            setState(() => _opBalDrCr = val)),
                                    _buildBalRow(
                                        'Prev. Year Bal.',
                                        _prevYearBalController,
                                        _prevYearBalDrCr,
                                        (val) => setState(
                                            () => _prevYearBalDrCr = val)),
                                    const SizedBox(height: 12),

                                    // Address area
                                    const Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        SizedBox(
                                            width: 100,
                                            child: Text('Address',
                                                style:
                                                    TextStyle(fontSize: 12))),
                                        Expanded(
                                            child: SizedBox(
                                          height: 50,
                                        ))
                                      ],
                                    ),
                                    const SizedBox(height: 12),
                                    _buildDenseRow(
                                        'Country', _countryController),
                                    const SizedBox(height: 48), // Padding

                                    Row(children: [
                                      Expanded(
                                          child: _buildDenseRow(
                                              'IT PAN', _itPanController,
                                              labelWidth: 100)),
                                      Expanded(
                                          child: _buildDenseRow(
                                              'VAT', _vatController,
                                              labelWidth: 80)),
                                    ]),
                                    Row(children: [
                                      Expanded(
                                          child: _buildDenseRow(
                                              'E-Mail', _emailController,
                                              labelWidth: 100)),
                                      Expanded(
                                          child: _buildDenseRow(
                                              'Ward', _wardController,
                                              labelWidth: 80)),
                                    ]),
                                    Row(children: [
                                      Expanded(
                                          child: _buildDenseRow(
                                              'Mobile No.', _mobileNoController,
                                              labelWidth: 100)),
                                      Expanded(
                                          child: _buildDenseRow('WhatsApp No.',
                                              _whatsappNoController,
                                              labelWidth: 80)),
                                    ]),
                                    // Label for whatsapp
                                    Padding(
                                      padding: const EdgeInsets.only(left: 200),
                                      child: Text(
                                          "(Country code w/o '+', '0' e.g. 9199XXXXXXX)",
                                          style: TextStyle(
                                              fontSize: 9,
                                              color: Colors.purple[800])),
                                    ),
                                    Row(children: [
                                      Expanded(
                                          child: _buildDenseRow(
                                              'Tel. No.', _telNoController,
                                              labelWidth: 100)),
                                      Expanded(
                                          child: _buildDenseRow(
                                              'Fax', _faxController,
                                              labelWidth: 80)),
                                    ]),
                                    Row(children: [
                                      Expanded(
                                          child: _buildDenseRow(
                                              'Contact Person',
                                              _contactPersonController,
                                              labelWidth: 100)),
                                      Expanded(
                                          child: _buildDenseRow(
                                              'Transport', _transportController,
                                              labelWidth: 80)),
                                    ]),
                                    _buildDenseRow(
                                        'Station', _stationController,
                                        labelWidth: 100),
                                  ],
                                ),
                              ),
                            ),
                          ),

                          // ── MIDDLE COLUMN: Other Info ──────────────────────
                          Expanded(
                            flex: 8,
                            child: _buildGroupBox(
                              title: 'Other Info',
                              child: SingleChildScrollView(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const SizedBox(
                                        height:
                                            180), // To push content down as in screenshot
                                    Row(
                                      children: [
                                        Expanded(
                                            child: _buildDenseRow(
                                                'SVAT', _svatController,
                                                labelWidth: 80)),
                                        Expanded(
                                            child: _buildDenseRow(
                                                'LST No.', _lstNoController,
                                                labelWidth: 50)),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Expanded(
                                            child: _buildDenseRow(
                                                'Service Tax No',
                                                _serviceTaxNoController,
                                                labelWidth: 80)),
                                        Expanded(
                                            child: _buildDenseRow(
                                                'LBT No.', _lbtNoController,
                                                labelWidth: 50)),
                                      ],
                                    ),
                                    _buildDenseRow('IE Code', _ieCodeController,
                                        labelWidth: 80),
                                    const SizedBox(height: 100),
                                    const Row(
                                      children: [
                                        Expanded(
                                            child: Text('Enable Email Query',
                                                style:
                                                    TextStyle(fontSize: 12))),
                                        Expanded(
                                            child: Text('Enable SMS Query',
                                                style:
                                                    TextStyle(fontSize: 12))),
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),

                          // ── RIGHT COLUMN: Extra Info ───────────────────────
                          Expanded(
                            flex: 8,
                            child: _buildGroupBox(
                              title: 'Extra Info.',
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    right: 8.0, top: 4.0, bottom: 4.0),
                                child: Container(
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      border: Border.all(
                                          color: Colors.grey.shade400),
                                    ),
                                    child: ListView.builder(
                                        itemCount: 20,
                                        itemBuilder: (ctx, idx) =>
                                            const SizedBox(
                                              height: 18,
                                              width: double.infinity,
                                            ))),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // ── Shortcut Sidebar ─────────────────────────────────────
                  ShortcutPanel(
                    items: [
                      ShortcutItem(keyLabel: 'F1', label: 'Help', onTap: () {}),
                      ShortcutItem(
                          keyLabel: 'F1', label: 'Add Account', onTap: () {}),
                      ShortcutItem(
                          keyLabel: 'F2', label: 'Add Item', onTap: () {}),
                      ShortcutItem(
                          keyLabel: 'F3', label: 'Add Master', onTap: () {}),
                      ShortcutItem(
                          keyLabel: 'F3', label: 'Add Voucher', onTap: () {}),
                      ShortcutItem(
                          keyLabel: 'F5', label: 'Add Payment', onTap: () {}),
                      ShortcutItem(
                          keyLabel: 'F6', label: 'Add Receipt', onTap: () {}),
                      ShortcutItem(
                          keyLabel: 'F7', label: 'Add Journal', onTap: () {}),
                      ShortcutItem(
                          keyLabel: 'F8',
                          label: 'Add Sales',
                          onTap: () =>
                              context.push('/transaction/Sales-Order')),
                      ShortcutItem(
                          keyLabel: 'F9', label: 'Add Purchase', onTap: () {}),
                      ShortcutItem(
                          keyLabel: 'B', label: 'Balance Sheet', onTap: () {}),
                      ShortcutItem(
                          keyLabel: 'I', label: 'Trial Balance', onTap: () {}),
                      ShortcutItem(
                          keyLabel: 'S', label: 'Stock Status', onTap: () {}),
                      ShortcutItem(
                          keyLabel: 'A', label: 'Acc. Summary', onTap: () {}),
                      ShortcutItem(
                          keyLabel: 'L', label: 'Acc. Ledger', onTap: () {}),
                      ShortcutItem(
                          keyLabel: 'I', label: 'Item Summary', onTap: () {}),
                      ShortcutItem(
                          keyLabel: 'D', label: 'Item Ledger', onTap: () {}),
                      ShortcutItem(
                          keyLabel: 'G', label: 'GST Summary', onTap: () {}),
                      ShortcutItem(
                          keyLabel: 'U', label: 'Switch User', onTap: () {}),
                      ShortcutItem(
                          keyLabel: 'F', label: 'Configuration', onTap: () {}),
                      ShortcutItem(
                          keyLabel: 'K', label: 'Lock Program', onTap: () {}),
                    ],
                    onHelp: () {},
                  ),
                ],
              ),
            ),

            // ── Bottom Buttons ─────────────────────────────────────────────
            Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 8.0, horizontal: 24.0),
              child: Row(
                children: [
                  _buildActionButton('Notes'),
                  const SizedBox(width: 24),
                  _buildActionButton('Opt. Fields'),
                  const SizedBox(width: 8),
                  Container(
                      width: 40,
                      height: 24,
                      decoration: BoxDecoration(
                          color: Colors.grey.shade300,
                          border: Border.all(color: Colors.grey)),
                      child: const Center(
                          child: Text("ACC\nIMAGE",
                              style: TextStyle(
                                  fontSize: 8,
                                  fontWeight: FontWeight.bold,
                                  height: 1.0),
                              textAlign: TextAlign.center))),
                  const SizedBox(width: 150),
                  _buildActionButton('Multiple Alias'),
                  const SizedBox(width: 50),
                  _buildActionButton('Save',
                      onPressed: () => _handleSave(context)),
                  const SizedBox(width: 8),
                  _buildActionButton('Quit', onPressed: () => context.pop()),
                ],
              ),
            ),

            // ── Bottom Status Bar ─────────────────────────────────────────────
            Container(
              height: 24,
              padding: const EdgeInsets.symmetric(horizontal: 8),
              decoration: const BoxDecoration(
                border: Border(top: BorderSide(color: Colors.white, width: 2)),
                color: Color(0xFF3F51B5), // Status bar blue
              ),
              child: Row(
                children: [
                  _buildStatusItem('[ Esc - Quit ]', Colors.white),
                  const SizedBox(width: 8),
                  _buildStatusItem('[ F2 - Done ]', Colors.white),
                  const SizedBox(width: 8),
                  _buildStatusItem(
                      '[ F4 - Pick Party Details from GSTIN ]', Colors.white),
                  const Spacer(),
                  Container(color: Colors.white, width: 1, height: 24),
                  _buildStatusItem('F10 Calculator', Colors.black,
                      bgColor: Colors.grey.shade300),
                ],
              ),
            ),

            Container(
              height: 24,
              padding: const EdgeInsets.symmetric(horizontal: 8),
              decoration: const BoxDecoration(
                border: Border(top: BorderSide(color: Colors.grey)),
                color: Colors.white,
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: const Text('Busy',
                        style: TextStyle(
                            color: Colors.blue,
                            fontWeight: FontWeight.bold,
                            fontSize: 16)),
                  ),
                  const SizedBox(width: 30),
                  const Expanded(
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                        Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text('Savibala Hardware',
                                  style: TextStyle(fontSize: 9)),
                              Text('(Comp0001)', style: TextStyle(fontSize: 9)),
                            ]),
                        Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('F.Y.       :     2026-27',
                                  style: TextStyle(fontSize: 9)),
                              Text('LST No. :', style: TextStyle(fontSize: 9)),
                            ]),
                        Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('User     :     Busy',
                                  style: TextStyle(fontSize: 9)),
                              Text('Country :     Sri Lanka',
                                  style: TextStyle(fontSize: 9)),
                            ]),
                        Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Listening Port :     981',
                                  style: TextStyle(fontSize: 9)),
                              Text('BLS Valid Upto :',
                                  style: TextStyle(
                                      fontSize: 9, color: Colors.red)),
                            ]),
                      ])),
                  const SizedBox(width: 10),
                  Container(
                    width: 60,
                    alignment: Alignment.center,
                    child: const Text("Your\nCompany\nLogo",
                        style: TextStyle(
                            fontSize: 8, color: Colors.red, height: 1.0),
                        textAlign: TextAlign.center),
                  ),
                  Container(
                    width: 70,
                    alignment: Alignment.center,
                    child: const Text("Tuesday\n03-17-2026",
                        style: TextStyle(
                            fontSize: 9, color: Colors.black, height: 1.0),
                        textAlign: TextAlign.center),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Logic ─────────────────────────────────────────────────────────────────
  void _handleSave(BuildContext context) {
    if (_nameController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Name is required!'), backgroundColor: Colors.red),
      );
      return;
    }
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Account saved: ${_nameController.text}'),
        backgroundColor: const Color(0xFF2E7D32),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  // ── Helper Widgets ────────────────────────────────────────────────────────

  Widget _buildActionButton(String label, {VoidCallback? onPressed}) {
    return Container(
      width: 90,
      height: 24,
      decoration: const BoxDecoration(
          boxShadow: [BoxShadow(color: Colors.grey, offset: Offset(2, 2))]),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          padding: EdgeInsets.zero,
          shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
          side: BorderSide(color: Colors.grey.shade400, width: 1),
          elevation: 0,
        ),
        onPressed: onPressed ?? () {},
        child: Text(label,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 11)),
      ),
    );
  }

  Widget _buildGroupBox({required String title, required Widget child}) {
    return Container(
      margin: const EdgeInsets.only(left: 4, right: 4, top: 8, bottom: 0),
      child: Stack(
        children: [
          Container(
              margin: const EdgeInsets.only(top: 8),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade400, width: 1.5),
              ),
              clipBehavior: Clip.none,
              child: Container(
                padding: const EdgeInsets.fromLTRB(8, 12, 8, 8),
                // Inner border effect
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.white, width: 1.0),
                ),
                child: child,
              )),
          Positioned(
            left: 8,
            top: 0,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              color: const Color(0xFFE3F2FD), // Match bg color
              child: Text(
                title,
                style: const TextStyle(
                    color:
                        Color(0xFF1565C0), // Blue text color for group titles
                    fontSize: 11,
                    fontWeight: FontWeight.w400),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBalRow(String label, TextEditingController controller,
      String drCr, Function(String) onDrCrChanged) {
    return Padding(
        padding: const EdgeInsets.only(bottom: 2.0),
        child: Row(children: [
          SizedBox(
              width: 100,
              child: Text(label, style: const TextStyle(fontSize: 12))),
          SizedBox(
              width: 60,
              height: 20,
              child: TextField(
                textInputAction: TextInputAction.next,
                onSubmitted: (_) => FocusScope.of(context).nextFocus(),
                controller: controller,
                textAlign: TextAlign.right,
                style:
                    const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                decoration: const InputDecoration(
                    isDense: true,
                    contentPadding: EdgeInsets.zero,
                    border: InputBorder.none),
              )),
          const SizedBox(width: 40),
          const Text('(Rs.)  Dr/Cr',
              style: TextStyle(fontSize: 12, color: Colors.black)),
          const SizedBox(width: 10),
          GestureDetector(
            onTap: () => onDrCrChanged(drCr == 'D' ? 'C' : 'D'),
            child: Text(drCr,
                style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: Colors.black)),
          )
        ]));
  }

  Widget _buildDenseRow(String label, TextEditingController controller,
      {bool isNameField = false, double labelWidth = 100}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 2.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            width: labelWidth,
            child: Text(
              label,
              style: TextStyle(
                  fontSize: 12,
                  color: label == 'Country'
                      ? Colors.black
                      : (label.contains('(') ? Colors.black : Colors.black87)),
            ),
          ),
          Expanded(
              child: SizedBox(
            height: isNameField ? 22 : 20,
            child: TextField(
              textInputAction: TextInputAction.next,
              onSubmitted: (_) => FocusScope.of(context).nextFocus(),
              controller: controller,
              style: TextStyle(
                  fontSize: 12,
                  fontWeight: isNameField ? FontWeight.bold : FontWeight.normal,
                  color: isNameField ? Colors.white : Colors.black),
              decoration: InputDecoration(
                filled: isNameField,
                fillColor: isNameField
                    ? const Color(0xFF333333)
                    : Colors.transparent, // Dark background for Name
                isDense: true,
                contentPadding: isNameField
                    ? const EdgeInsets.symmetric(horizontal: 4, vertical: 4)
                    : const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
                border: InputBorder.none,
              ),
            ),
          )),
        ],
      ),
    );
  }

  Widget _buildStatusItem(String text, Color textColor, {Color? bgColor}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      color: bgColor ?? Colors.transparent,
      child: Text(text,
          style: TextStyle(
              fontSize: 11, fontWeight: FontWeight.bold, color: textColor)),
    );
  }
}
