import 'package:agro_vision/core/themes/app_colors.dart';
import 'package:agro_vision/shared/widgets/custom_appbar.dart';
import 'package:flutter/material.dart';

class OrderManagementScreen extends StatefulWidget {
  const OrderManagementScreen({super.key});

  @override
  State<OrderManagementScreen> createState() => _OrderManagementScreenState();
}

class _OrderManagementScreenState extends State<OrderManagementScreen> {
  List<String> selectedStatuses = [];
  final List<Order> orders = [
    Order(
      id: 1024,
      dueDate: '2020-10-24',
      clientName: 'Omar Kareem',
      contact: '+0123456789',
      amount: 1500.00,
      status: 'Completed',
    ),
  ];

  List<Order> get filteredOrders {
    if (selectedStatuses.isEmpty) return orders;
    return orders
        .where((order) => selectedStatuses.contains(order.status.toLowerCase()))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Order Management',
        actions: [
          IconButton(
            icon: Icon(Icons.filter_alt_outlined, color: Colors.grey[800]),
            onPressed: () => _showFilterOptions(context),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        child: Column(
          children: [
            Expanded(
              child: ListView.separated(
                physics: const BouncingScrollPhysics(),
                itemCount: filteredOrders.length,
                separatorBuilder: (_, __) => const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  final order = filteredOrders[index];
                  return _OrderCard(order: order);
                },
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryColor,
                foregroundColor: Colors.white,
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
              ),
              onPressed: () => _navigateToCreateOrder(context),
              child: const Text(
                'Create Invoice',
                style: TextStyle(fontFamily: 'SYNE'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showFilterOptions(BuildContext context) {
    List<String> currentSelected = List.from(selectedStatuses);
    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            title: const Text('Filter Orders'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CheckboxListTile(
                  title: const Text('Completed'),
                  value: currentSelected.contains('completed'),
                  onChanged: (value) => _updateFilters(
                      currentSelected, 'completed', value, setState),
                ),
                CheckboxListTile(
                  title: const Text('Pending'),
                  value: currentSelected.contains('pending'),
                  onChanged: (value) => _updateFilters(
                      currentSelected, 'pending', value, setState),
                ),
                CheckboxListTile(
                  title: const Text('Cancelled'),
                  value: currentSelected.contains('cancelled'),
                  onChanged: (value) => _updateFilters(
                      currentSelected, 'cancelled', value, setState),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () {
                  setState(() => selectedStatuses = currentSelected);
                  Navigator.pop(context);
                },
                child: const Text('Apply'),
              ),
            ],
          );
        },
      ),
    );
  }

  void _updateFilters(
      List<String> current, String status, bool? value, Function setState) {
    setState(() {
      value! ? current.add(status) : current.remove(status);
    });
  }

  void _navigateToCreateOrder(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CreateOrderScreen(
          onOrderCreated: (newOrder) {
            setState(() => orders.add(newOrder));
          },
        ),
      ),
    );
  }
}

class _OrderCard extends StatelessWidget {
  final Order order;

  const _OrderCard({required this.order});

  @override
  Widget build(BuildContext context) {
    final statusColor = _getStatusColor(order.status);

    return Material(
      borderRadius: BorderRadius.circular(16),
      color: Colors.white,
      elevation: 1,
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () => _navigateToOrderDetail(context),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text('ORDER #${order.id}',
                      style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: Colors.grey[600])),
                  const Spacer(),
                  Icon(Icons.calendar_today, size: 14, color: Colors.grey[500]),
                  const SizedBox(width: 4),
                  Text(order.dueDate,
                      style: TextStyle(
                          fontSize: 13,
                          color: Colors.grey[600],
                          fontWeight: FontWeight.w500)),
                ],
              ),
              const SizedBox(height: 12),
              _InfoRow(
                icon: Icons.person_outline,
                label: 'Client:',
                value: order.clientName,
              ),
              const SizedBox(height: 8),
              _InfoRow(
                icon: Icons.phone_outlined,
                label: 'Contact:',
                value: order.contact,
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Text('\$${order.amount.toStringAsFixed(2)}',
                      style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: Colors.black87)),
                  const Spacer(),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: statusColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.circle, color: statusColor, size: 10),
                        const SizedBox(width: 6),
                        Text(order.status.toUpperCase(),
                            style: TextStyle(
                                color: statusColor,
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                letterSpacing: 0.3)),
                      ],
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'completed':
        return Colors.green;
      case 'pending':
        return Colors.amber[700]!;
      case 'cancelled':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  void _navigateToOrderDetail(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => OrderDetailScreen(order: order),
      ),
    );
  }
}

class CreateOrderScreen extends StatefulWidget {
  final Function(Order) onOrderCreated;

  const CreateOrderScreen({super.key, required this.onOrderCreated});

  @override
  State<CreateOrderScreen> createState() => _CreateOrderScreenState();
}

class _CreateOrderScreenState extends State<CreateOrderScreen> {
  final _formKey = GlobalKey<FormState>();
  bool _isEditing = false;
  late List<TextEditingController> _nameControllers;
  late List<TextEditingController> _descControllers;
  late List<TextEditingController> _rateControllers;

  @override
  void initState() {
    super.initState();
    _initializeControllers();
  }

  @override
  void dispose() {
    for (var c in _nameControllers) {
      c.dispose();
    }
    for (var c in _descControllers) {
      c.dispose();
    }
    for (var c in _rateControllers) {
      c.dispose();
    }
    super.dispose();
  }

  void _initializeControllers() {
    _nameControllers = List.generate(
      items.length,
      (index) => TextEditingController(text: items[index]['name']),
    );
    _descControllers = List.generate(
      items.length,
      (index) => TextEditingController(text: items[index]['desc']),
    );
    _rateControllers = List.generate(
      items.length,
      (index) => TextEditingController(text: items[index]['rate']),
    );
  }

  void _toggleEditMode() {
    setState(() {
      _isEditing = !_isEditing;
      if (!_isEditing) {
        for (int i = 0; i < items.length; i++) {
          items[i]['name'] = _nameControllers[i].text;
          items[i]['desc'] = _descControllers[i].text;
          items[i]['rate'] = _rateControllers[i].text;
        }
      }
    });
  }

  final List<Map<String, String>> items = [
    {
      'name': 'Fresh Potato 2025',
      'desc': 'Fresh Potato 2025 * 100K',
      'rate': '15.00',
      'amount': '1500.00 EGP'
    },
    {
      'name': 'Fresh Tomato 2025',
      'desc': 'Fresh Tomato 2025 * 95K',
      'rate': '10.00',
      'amount': '\$15,435.00'
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Create Invoice',
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: _submitForm,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Client Information',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      )),
                  const SizedBox(height: 16),
                  TextFormField(
                    initialValue: 'Omar Kareem',
                    decoration: _inputDecoration('Client Name'),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    initialValue: 'EL_BADR GROUP',
                    decoration: _inputDecoration('Company Name'),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    initialValue: 'omar@gmail.com',
                    decoration: _inputDecoration('Email'),
                    keyboardType: TextInputType.emailAddress,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    initialValue: '01065971853',
                    decoration: _inputDecoration('Phone'),
                    keyboardType: TextInputType.phone,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    initialValue:
                        'Franklin Avenue Street, New York, ABC 5562, United States',
                    decoration: _inputDecoration('Address'),
                    maxLines: 2,
                  ),
                ],
              ),
              const SizedBox(height: 24),
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: const Icon(Icons.calendar_today,
                    color: AppColors.primaryColor),
                title: _isEditing
                    ? TextButton(
                        onPressed: _handleEditDate,
                        child: const Text('October 31st, 2020',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                      )
                    : const Text('October 31st, 2020',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: Icon(
                        _isEditing ? Icons.save : Icons.edit_outlined,
                        color: AppColors.primaryColor,
                        size: 22,
                      ),
                      onPressed: _toggleEditMode,
                      tooltip: _isEditing ? 'Save Changes' : 'Edit',
                    ),
                    const SizedBox(width: 8),
                    IconButton(
                      icon: const Icon(Icons.add_circle_outline,
                          size: 24, color: AppColors.primaryColor),
                      onPressed: _addNewItem,
                      tooltip: 'Add New Item',
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: DataTable(
                    columns: const [
                      DataColumn(label: Text('ITEM NAME')),
                      DataColumn(label: Text('ITEM DESCRIPTION')),
                      DataColumn(label: Text('RATE')),
                      DataColumn(label: Text('AMOUNT')),
                    ],
                    rows: List<DataRow>.generate(
                      items.length,
                      (index) => DataRow(
                        cells: [
                          DataCell(_isEditing
                              ? TextFormField(
                                  controller: _nameControllers[index],
                                  decoration: const InputDecoration(
                                    border: UnderlineInputBorder(),
                                  ),
                                )
                              : Text(items[index]['name']!)),
                          DataCell(_isEditing
                              ? TextFormField(
                                  controller: _descControllers[index],
                                  decoration: const InputDecoration(
                                    border: UnderlineInputBorder(),
                                  ),
                                )
                              : Text(items[index]['desc']!)),
                          DataCell(_isEditing
                              ? TextFormField(
                                  controller: _rateControllers[index],
                                  decoration: const InputDecoration(
                                    border: UnderlineInputBorder(),
                                  ),
                                  keyboardType: TextInputType.number,
                                )
                              : Text(items[index]['rate']!)),
                          DataCell(Text(items[index]['amount']!)),
                        ],
                      ),
                    ),
                  )),
              const SizedBox(height: 24),
              Column(
                children: [
                  TextFormField(
                    initialValue: '#INV-0001234',
                    decoration: _inputDecoration('Invoice Number'),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    decoration: const InputDecoration(
                      labelText: 'Amount (EGP)',
                      border: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: AppColors.primaryColor)),
                      focusedBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: AppColors.primaryColor)),
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    ),
                    initialValue: '5,000.00',
                    keyboardType: TextInputType.number,
                  ),
                ],
              ),
              const SizedBox(height: 32),
              ElevatedButton.icon(
                icon: const Icon(Icons.send),
                label: const Text('SEND INVOICE'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryColor,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                onPressed: _submitForm,
              ),
            ],
          ),
        ),
      ),
    );
  }

  InputDecoration _inputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      border: const OutlineInputBorder(),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    );
  }

  void _addNewItem() {
    setState(() {
      items.add({
        'name': 'New Item',
        'desc': 'Item description',
        'rate': '0.00',
        'amount': '0.00'
      });
    });
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      Navigator.pop(context);
    }
  }

  void _handleEditDate() {
    showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    ).then((pickedDate) {
      if (pickedDate != null) {
        // Update date state
      }
    });
  }
}

class OrderDetailScreen extends StatelessWidget {
  final Order order;

  const OrderDetailScreen({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Order Details',
            style: TextStyle(fontWeight: FontWeight.w600)),
        centerTitle: false,
        actions: [
          IconButton(
            icon: Icon(Icons.print, color: colors.onBackground),
            onPressed: () {},
          ),
          IconButton(
            icon: Icon(Icons.more_vert, color: colors.onBackground),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeaderSection(colors),
            const SizedBox(height: 24),
            _buildCustomerCard(colors),
            const SizedBox(height: 24),
            _buildOrderItems(theme),
            const SizedBox(height: 24),
            _buildDateCard(colors),
            const SizedBox(height: 24),
            _buildTotalSection(theme),
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderSection(ColorScheme colors) {
    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: colors.outline.withOpacity(0.1)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('INVOICE NUMBER',
                          style: TextStyle(
                            color: colors.outline,
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            letterSpacing: 0.8,
                          )),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Icon(Icons.receipt_outlined,
                              size: 20, color: colors.primary),
                          const SizedBox(width: 12),
                          Text('#INV-00012456',
                              style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.w700,
                                color: colors.primary,
                                letterSpacing: -0.5,
                              )),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
                    decoration: BoxDecoration(
                      color: AppColors.primaryColor,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.check_circle_outline,
                            size: 18, color: colors.onPrimaryContainer),
                        const SizedBox(width: 6),
                        Text('Invoice Sent',
                            style: TextStyle(
                              color: colors.onPrimaryContainer,
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                            )),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCustomerCard(ColorScheme colors) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            const CircleAvatar(
              radius: 28,
              backgroundImage: NetworkImage('https://i.pravatar.cc/150?img=3'),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Omar Mohamed',
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: colors.onSurface)),
                  const SizedBox(height: 8),
                  _buildInfoRow(Icons.location_on, colors.outline,
                      '18 Guild Street, London, EC2V 5PX, United Kingdom'),
                  _buildInfoRow(
                      Icons.email, colors.outline, 'omarmohamed@mail.com'),
                  _buildInfoRow(Icons.phone, colors.outline, '(012) 3456 789'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, Color color, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 16, color: color),
          const SizedBox(width: 8),
          Expanded(child: Text(text, style: TextStyle(color: color))),
        ],
      ),
    );
  }

  Widget _buildOrderItems(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Text('Order Items',
              style: theme.textTheme.titleMedium!
                  .copyWith(fontWeight: FontWeight.w600)),
        ),
        const SizedBox(height: 12),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                _buildTableHeader(theme),
                const Divider(height: 24),
                _buildTableRow(
                  'Fresh Potato 2025',
                  '100K',
                  '15.00',
                  '1500.00 EGP',
                  theme,
                ),
                const Divider(height: 24),
                _buildTableRow(
                  'Fresh Tomato 2025',
                  '95K',
                  '10.00',
                  '\$15,435.00',
                  theme,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTableHeader(ThemeData theme) {
    return const Row(
      children: [
        Expanded(
            flex: 3,
            child: Text('Item', style: TextStyle(fontWeight: FontWeight.w500))),
        Expanded(
            child: Text('Qty', style: TextStyle(fontWeight: FontWeight.w500))),
        Expanded(
            child: Text('Rate', style: TextStyle(fontWeight: FontWeight.w500))),
        Expanded(
            child:
                Text('Amount', style: TextStyle(fontWeight: FontWeight.w500))),
      ],
    );
  }

  Widget _buildTableRow(
      String item, String qty, String rate, String amount, ThemeData theme) {
    return Row(
      children: [
        Expanded(flex: 3, child: Text(item)),
        Expanded(child: Text(qty, textAlign: TextAlign.center)),
        Expanded(child: Text(rate, textAlign: TextAlign.center)),
        Expanded(
            child: Text(amount,
                style: theme.textTheme.bodyMedium!
                    .copyWith(fontWeight: FontWeight.w600),
                textAlign: TextAlign.right)),
      ],
    );
  }

  Widget _buildDateCard(ColorScheme colors) {
    return Card(
      color: AppColors.primaryColor,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        child: Row(
          children: [
            const Icon(Icons.calendar_month, color: Colors.white),
            const SizedBox(width: 12),
            Text('Saturday, October 24th, 2020',
                style: TextStyle(
                    color: colors.onPrimaryContainer,
                    fontWeight: FontWeight.w500)),
          ],
        ),
      ),
    );
  }

  Widget _buildTotalSection(ThemeData theme) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _buildTotalRow('Subtotal:', '\$17,883.00', theme),
            _buildTotalRow('Tax (2%):', '\$357.66', theme),
            const Divider(height: 24),
            _buildTotalRow('Total:', '\$18,240.66', theme, isTotal: true),
          ],
        ),
      ),
    );
  }

  Widget _buildTotalRow(String label, String value, ThemeData theme,
      {bool isTotal = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Text(label,
              style: theme.textTheme.bodyMedium!.copyWith(
                  color: theme.colorScheme.outline,
                  fontWeight: isTotal ? FontWeight.w600 : FontWeight.normal)),
          const Spacer(),
          Text(value,
              style: theme.textTheme.bodyMedium!.copyWith(
                  fontWeight: FontWeight.w600,
                  fontSize: isTotal ? 16 : 14,
                  color: isTotal ? theme.colorScheme.primary : null)),
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 16, color: Colors.grey[500]),
        const SizedBox(width: 8),
        Text(label,
            style: TextStyle(
                fontSize: 13,
                color: Colors.grey[600],
                fontWeight: FontWeight.w500)),
        const SizedBox(width: 4),
        Text(value,
            style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.black87)),
      ],
    );
  }
}

class Order {
  final int id;
  final String dueDate;
  final String clientName;
  final String contact;
  final double amount;
  final String status;

  Order({
    required this.id,
    required this.dueDate,
    required this.clientName,
    required this.contact,
    required this.amount,
    required this.status,
  });
}
