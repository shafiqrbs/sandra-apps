Future<void> main() async {
  final lang = {
    'home': 'Home',
    'search_product': 'Search Products',
    'place_order': 'Place Order',
    'price': 'Price',
    'qty': 'Qty',
    'quantity': 'Quantity',
    'female': 'Female',
    'male': 'Male',
    'others': 'Others',
    'shipping': 'Shipping',
    'success': 'Success',
    'save': 'Save',
    'print': 'Print',
    'hold': 'Hold',
    '%': '%',
    'flat': 'Flat',
    'percent': 'percent',
    'percent%': 'percent(%)',
    'sub_total': 'SubTotal',
    'vat': 'VAT',
    'total': 'Total',
    'discount': 'Discount',
    'amount': 'Amount',
    'customer': 'Customer',
    'cash': 'Cash',
    'mobile': 'mobile',
    'mobile_account': 'Mobile Account',
    'payment_mobile': 'Payment Mobile',
    'payment_trx_id': 'Payment Transaction ID',
    'bank_account': 'Bank Account',
    'payment_card': 'Payment Card',
    'bank': 'Bank',
    'return': 'Return',
    'due': 'Due',
    'connect_printer': 'Please Connect Printer',
    'search_here': 'Search Your Desired Product',
    'start_date': 'Start Date',
    'search': 'Search',
    'customer_list': 'Customer List',
    'add_customer': 'Add Customer',
    'customer_title': 'Customer Title',
    'user_name': 'Username',
    'enter_username_here': 'Enter username here',
    'user_name_required': 'Username required',
    'mobile': 'Mobile',
    'item_name': 'Item Name',
    'net_payable': 'Net Payable',
    'enter_mobile_number_here': 'Enter mobile number here',
    'mobile_no_is_required': 'Mobile number is required',
    'address': 'Address',
    'district_city': 'District_City',
    'enter_address_here': 'Enter address here',
    'end_date': 'End Date',
    'report': 'Report',
    'share': 'Share',
    'call': 'Call',
    'receive': 'Receive',
    'date': 'Date',
    'description': 'Description',
    'sales': 'Sales',
    'received': 'Receive',
    'balance': 'Balance',
    'enter_email': 'Enter email here',
    'opening_balance': 'Opening balance',
    'add_remark': 'Add remark',
    'welcome': 'Welcome',
    'to_store': 'To Store',
    'create_account': 'Create Account',
    'forgot_password?': 'Forgot password?',
    'enter_password': 'Enter password',
    'password_required': 'Password required',
    'login': 'Login',
    'close': 'Close',
    'otp_login': 'OTP Login',
    'english': 'English',
    'bangla': 'Bangla',
    'hindi': 'Hindi',
    'sl_no': 'SL No',
    'sales_order': 'Sales Order',
    'sub_title': 'Sub-Title',
    'list': 'List',
    'outstanding': 'Outstanding',
    'brand': 'Brand',
    'purchase_price': 'Purchase',
    'sales_price': 'Sales',
    'damage_price': 'Damage',
    'open_quantity': 'Opening',
    'category': 'Category',
    'purchase_quantity': 'Purchase',
    'sales_quantity': 'Sales',
    'damage_quantity': 'Damage',
    'short_list': 'Short List',
    'filter': 'Filter',
    'stock_in': 'Stock In',
    'add_product': 'Add Product',
    'please_provide_your_product_details':
    'Please provide your product details',
    'unit': 'Unit',
    'discount_price': 'Discount',
    'minimum_qty': 'Minimum',
    'opening_qty': 'Opening',
    'reset': 'Reset',
    'product_name': 'Product Name',
    'selected_item': 'Selected Item',
    'are_you_sure_to_process_order': 'Are you sure to process order?',
    'per_(%)': 'Per (%)',
    'pcs': 'PCS',
    'days': 'Days',
    'mobile_no': 'Mobile No',
    'enter_mobile_no': 'Enter mobile no',
    'get_otp': 'GET OTP',
    'create_your_store': 'Create your store',
    'store': 'Store',
    'sample_username': 'Sample username',
    'add': 'Add',
    'order_processing': 'Order processing',
    'print_without_discount': 'Print without discount',
    'mrp': 'MRP',
    'purchase_qty': 'Purchase QTY',
    'sales_qty': 'Sales QTY',
    'damage_qty': 'Damage QTY',
    'enter_your_balance': 'Enter your balance',
    'profit': 'Profit',
    'model_number': 'Model Number',
    'create_sales': 'Create Sales',
    'register_account': 'Register Account',
    'register_title': 'Register Title',
    'register': 'Register',
    'mobile_no_required': 'Mobile no required',
    'please_fill_all_the_information_correctly':
    'Please fill all the information correctly',
    'license': 'License',
    'enter_license_number': 'Enter license number',
    'license_number_required': 'License number required',
    'license_number': 'License number',
    'active_number': 'Active number',
    'enter_active_number': 'Enter active number',
    'active_number_required': 'Active number required',
    'add_sales_item': 'Add Sales Item',
    "don't_have_an_account": "Don't have an account?",
    'already_have_an_account': 'Already have an account',
    'choose_category': 'Choose category',
    'choose_brand': 'Choose brand',
    'choose_unit': 'Choose unit',
    'add_prescription': 'Add prescription',
    'new_customer': 'New customer',
    's/n': 'S/N',
    'name': 'Name',
    'client_name': 'Client Name',
    'created_by': 'Created By',
    'status': 'Status',
    'overView': 'Overview',
    'expense': 'Expense',
    'purchase': 'Purchase',
    'income_receive': 'Income receive',
    'add_sales': 'Add Sales',
    'custom_receive': 'Custom Receive',
    'add_purchase': 'Add purchase',
    'supplier_payment': 'Supplier Payment',
    'settings': 'Settings',
    'profile': 'Profile',
    'logout': 'Logout',
    'pos': 'POS',
    'prescription': 'Prescription',
    'add_stock': 'Add Stock',
    'stock': 'Stock',
    'instant': 'Instant',
    'sales_return': 'Sales Return',
    'forgot_password': 'Forgot password',
    'shortcut': 'Shortcut',
    'store_name': 'Store Name',
    'language': 'Language',
    'dashboard': 'Dashboard',
    'data_export': 'Data Export',
    'data_import': 'Data Import',
    'invoice': 'Invoice',
    'password': 'Password',
    'search_customer': 'Search customer',
    'select_medicine': 'Select medicine',
    'brand_name': 'Brand name',
    'start_qty': 'Start quantity',
    'end_qty': 'End quantity',
    'receive_type': 'Receive type',
    'vendor': 'Vendor',
    'stock_item': 'Stock item',
    'stock_adjustment': 'Stock adjustment',
    'purchase_return': 'Purchase return',
    'inventory': 'Inventory',
    'accounting': 'Accounting',

  };

  final keys = lang.keys.toList();
  final values = lang.values.toList();
  print('{');
  for (var i = 0; i < keys.length; i++) {
    final lowerCamelCaseKey = lowerCamelCase(keys[i]);
    //remove quotes from values
    final value = values[i].replaceAll("'", '');
    print('"$lowerCamelCaseKey" : "$value",');
  }
  print('}');
}

extension StringExtension on String {
  String capitalize() {
    if (isEmpty) return this;
    return this[0].toUpperCase() + substring(1);
  }
}

String lowerCamelCase(String input) {
  final List<String> words = input.split('_');
  final List<String> capitalizedWords = words.map(
    (word) {
      return word.capitalize();
    },
  ).toList();
  final String firstWord = capitalizedWords.removeAt(0).toLowerCase();
  capitalizedWords.insert(0, firstWord);
  return capitalizedWords.join();
}
