class MenuNode {
  final String title;
  final String? route;
  final List<MenuNode> children;

  const MenuNode({
    required this.title,
    this.route,
    this.children = const [],
  });
}

// Global Menu Definition Based on the Busy Software Image
const List<MenuNode> appMenus = [
  MenuNode(title: 'Company', children: [
    MenuNode(title: 'Open Company'),
    MenuNode(title: 'Close Company'),
    MenuNode(title: 'Edit Company'),
  ]),
  MenuNode(
    title: 'Administration',
    children: [
      MenuNode(
        title: 'Masters',
        children: [
          MenuNode(title: 'Account', children: [
            MenuNode(title: 'Add', route: '/add-account'),
            MenuNode(title: 'Modify', route: '/modify-account'),
            MenuNode(title: 'List'),
          ]),
          MenuNode(title: 'Account Group', children: [
            MenuNode(title: 'Add', route: '/add-account-group'),
            MenuNode(title: 'Modify', route: '/modify-account-group'),
            MenuNode(title: 'List', route: '/list-account-group'),
          ]),
          MenuNode(title: 'Std. Narration'),
          MenuNode(title: 'o'),
          MenuNode(title: 'Item', children: [
            MenuNode(title: 'Add', route: '/item-master'),
            MenuNode(title: 'Modify', route: '/modify-item'),
            MenuNode(title: 'List', route: '/items-list'),
          ]),
          MenuNode(title: 'Item Group', children: [
            MenuNode(title: 'Add'),
            MenuNode(title: 'Modify'),
            MenuNode(title: 'List'),
          ]),
          MenuNode(title: 'Material Centre', children: [
            MenuNode(title: 'Add', route: '/material-centre/add'),
            MenuNode(title: 'Modify', route: '/material-centre/modify'),
            MenuNode(title: 'List', route: '/material-centre/list'),
          ]),
          MenuNode(title: 'Material Centre Group', children: [
            MenuNode(title: 'Add', route: '/material-centre/add'),
            MenuNode(title: 'Modify', route: '/material-centre/modify'),
            MenuNode(title: 'List', route: '/material-centre/list'),
          ]),
          MenuNode(title: 'Unit', children: [
            MenuNode(title: 'Add', route: '/unit/add'),
            MenuNode(title: 'Modify', route: '/unit/modify'),
            MenuNode(title: 'List', route: '/unit/list'),
          ]),
          MenuNode(title: 'Unit Conversion'),
          MenuNode(title: 'Bill Sundry'),
          MenuNode(title: 'Bill of Material'),
          MenuNode(title: 'o'),
          MenuNode(title: 'Misc. Masters'),
          MenuNode(title: 'o'),
          MenuNode(title: 'Bulk Updation', children: [
            MenuNode(
                title: 'Multiple Account Creation/Modification',
                route: '/bulk-update-account'),
            MenuNode(
                title: 'Multiple Item Creation/Modification',
                route: '/bulk-update-item'),
            MenuNode(
                title: 'Multiple Tax Category Creation/Modification',
                route: '/bulk-update-tax'),
          ]),
        ],
      ),
      MenuNode(title: 'Configuration'),
      MenuNode(title: 'Users'),
      MenuNode(title: 'Utilities'),
      MenuNode(title: 'Bulk Updations'),
      MenuNode(title: 'Data Export Import'),
      MenuNode(title: 'Miscellaneous Data Entry'),
      MenuNode(title: 'Change Financial Year'),
    ],
  ),
  MenuNode(
    title: 'Transactions',
    children: [
      MenuNode(title: 'Sales Quotation', children: [
        MenuNode(title: 'Add', route: '/transaction/Sales-Quotation'),
        MenuNode(title: 'Modify'),
        MenuNode(title: 'List'),
      ]),
      MenuNode(title: 'Purchase Quotation', children: [
        MenuNode(title: 'Add', route: '/transaction/Purchase-Quotation'),
        MenuNode(title: 'Modify'),
        MenuNode(title: 'List'),
      ]),
      MenuNode(title: 'Sales Order', children: [
        MenuNode(title: 'Add', route: '/transaction/Sales-Order'),
        MenuNode(title: 'Modify'),
        MenuNode(title: 'List'),
      ]),
      MenuNode(title: 'Purchase Order', children: [
        MenuNode(title: 'Add', route: '/transaction/Purchase-Order'),
        MenuNode(title: 'Modify'),
        MenuNode(title: 'List'),
      ]),
      MenuNode(title: 'Sales', children: [
        MenuNode(title: 'Add', route: '/transaction/Sales'),
        MenuNode(title: 'Modify'),
        MenuNode(title: 'List'),
      ]),
      MenuNode(title: 'Purchase', children: [
        MenuNode(title: 'Add', route: '/transaction/Purchase'),
        MenuNode(title: 'Modify'),
        MenuNode(title: 'List'),
      ]),
      MenuNode(title: 'Sales Return (Cr. Note)', children: [
        MenuNode(title: 'Add', route: '/transaction/Sales-Return-(Cr.-Note)'),
        MenuNode(title: 'Modify'),
        MenuNode(title: 'List'),
      ]),
      MenuNode(title: 'Purchase Return (Dr. Note)', children: [
        MenuNode(
            title: 'Add', route: '/transaction/Purchase-Return-(Dr.-Note)'),
        MenuNode(title: 'Modify'),
        MenuNode(title: 'List'),
      ]),
      MenuNode(title: 'Payment', children: [
        MenuNode(title: 'Add', route: '/transaction/Payment'),
        MenuNode(title: 'Modify'),
        MenuNode(title: 'List'),
      ]),
      MenuNode(title: 'Receipt', children: [
        MenuNode(title: 'Add', route: '/receipt/add'),
        MenuNode(title: 'Modify', route: '/receipt/modify'),
        MenuNode(title: 'List', route: '/receipt/list'),
      ]),
      MenuNode(title: 'Journal', children: [
        MenuNode(title: 'Add', route: '/transaction/Journal'),
        MenuNode(title: 'Modify'),
        MenuNode(title: 'List'),
      ]),
      MenuNode(title: 'Contra', children: [
        MenuNode(title: 'Add', route: '/transaction/Contra'),
        MenuNode(title: 'Modify'),
        MenuNode(title: 'List'),
      ]),
      MenuNode(title: 'Dr. Note (w/o Items)', children: [
        MenuNode(title: 'Add', route: '/transaction/Dr.-Note-(w-o-Items)'),
        MenuNode(title: 'Modify'),
        MenuNode(title: 'List'),
      ]),
      MenuNode(title: 'Cr. Note (w/o Items)', children: [
        MenuNode(title: 'Add', route: '/transaction/Cr.-Note-(w-o-Items)'),
        MenuNode(title: 'Modify'),
        MenuNode(title: 'List'),
      ]),
      MenuNode(title: 'Stock Transfer', children: [
        MenuNode(title: 'Add', route: '/transaction/Stock-Transfer'),
        MenuNode(title: 'Modify'),
        MenuNode(title: 'List'),
      ]),
      MenuNode(title: 'Production', children: [
        MenuNode(title: 'Add', route: '/transaction/Production'),
        MenuNode(title: 'Modify'),
        MenuNode(title: 'List'),
      ]),
      MenuNode(title: 'Unassemble', children: [
        MenuNode(title: 'Add', route: '/transaction/Unassemble'),
        MenuNode(title: 'Modify'),
        MenuNode(title: 'List'),
      ]),
      MenuNode(title: 'Stock Journal', children: [
        MenuNode(title: 'Add', route: '/transaction/Stock-Journal'),
        MenuNode(title: 'Modify'),
        MenuNode(title: 'List'),
      ]),
      MenuNode(title: 'Mat. Issued to Party', children: [
        MenuNode(title: 'Add', route: '/transaction/Mat.-Issued-to-Party'),
        MenuNode(title: 'Modify'),
        MenuNode(title: 'List'),
      ]),
      MenuNode(title: 'Mat. Rcvd. from Party', children: [
        MenuNode(title: 'Add', route: '/transaction/Mat.-Rcvd.-from-Party'),
        MenuNode(title: 'Modify'),
        MenuNode(title: 'List'),
      ]),
      MenuNode(title: 'Physical Stock', children: [
        MenuNode(title: 'Add', route: '/transaction/Physical-Stock'),
        MenuNode(title: 'Modify'),
        MenuNode(title: 'List'),
      ]),
    ],
  ),
  MenuNode(title: 'Display', children: [
    MenuNode(title: 'Balance Sheet'),
    MenuNode(title: 'Trial Balance'),
  ]),
  MenuNode(title: 'Help'),
  MenuNode(title: 'Favourites'),
];
