import 'package:flutter/material.dart';

class OrderManagementScreen extends StatelessWidget {
  const OrderManagementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Order Management',
            style: TextStyle(fontWeight: FontWeight.w600)),
        centerTitle: true,
        elevation: 1,
        actions: [
          IconButton(
            icon: Icon(Icons.filter_alt_outlined, color: Colors.grey[800]),
            onPressed: () => _showFilterOptions(context),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        backgroundColor: Colors.blue.shade800,
        child: const Icon(Icons.add, color: Colors.white),
        onPressed: () => _navigateToCreateOrder(context),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        child: ListView.separated(
          physics: const BouncingScrollPhysics(),
          itemCount: orders.length,
          separatorBuilder: (_, __) => const SizedBox(height: 12),
          itemBuilder: (context, index) {
            final order = orders[index];
            return _OrderCard(order: order);
          },
        ),
      ),
    );
  }

  void _showFilterOptions(BuildContext context) {
    // Implement filter dialog
  }

  void _navigateToCreateOrder(BuildContext context) {
    // Implement navigation
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
              // Header Row
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

              // Client Section
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

              // Footer Row
              Row(
                children: [
                  // Amount
                  Text('\$${order.amount.toStringAsFixed(2)}',
                      style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: Colors.black87)),
                  const Spacer(),

                  // Status Badge
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
    // Implement navigation
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

// Updated Order model
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

// Updated example orders
final List<Order> orders = [
  Order(
      id: 1024,
      dueDate: '2023-08-15',
      clientName: 'John Doe',
      contact: '+1 (555) 123-4567',
      amount: 1500.00,
      status: 'Completed'),
  Order(
      id: 1025,
      dueDate: '2023-08-18',
      clientName: 'Jane Smith',
      contact: 'jane@example.com',
      amount: 2000.00,
      status: 'Pending'),
  Order(
      id: 1026,
      dueDate: '2023-08-20',
      clientName: 'Acme Corp.',
      contact: '+1 (555) 765-4321',
      amount: 3500.00,
      status: 'Completed'),
];
