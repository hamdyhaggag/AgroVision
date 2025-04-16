import 'package:flutter/material.dart';
import '../../../../../core/themes/app_colors.dart';
import '../../../../../shared/widgets/custom_appbar.dart';
import '../order_management.dart';

class OrderDetailScreen extends StatelessWidget {
  final Order order;
  final String Function(DateTime?) formatDate;

  const OrderDetailScreen({
    super.key,
    required this.order,
    required this.formatDate,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return Scaffold(
      appBar: CustomAppBar(
        title: 'Order Details',
        actions: [
          IconButton(
              icon: Icon(Icons.print, color: colors.onSurface),
              onPressed: () {}),
          IconButton(
              icon: Icon(Icons.more_vert, color: colors.onSurface),
              onPressed: () {}),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          _buildHeaderSection(colors),
          const SizedBox(height: 24),
          _buildCustomerCard(colors),
          const SizedBox(height: 24),
          _buildOrderItems(theme),
          const SizedBox(height: 24),
          _buildDateCard(colors, formatDate(order.createdAt)),
          const SizedBox(height: 24),
          _buildTotalSection(theme),
        ]),
      ),
    );
  }

  Widget _buildHeaderSection(ColorScheme colors) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child:
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Expanded(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text('INVOICE NUMBER',
                      style: TextStyle(
                        color: colors.outline,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        letterSpacing: 0.8,
                      )),
                  const SizedBox(height: 8),
                  Row(children: [
                    Icon(Icons.receipt_outlined,
                        size: 20, color: colors.primary),
                    const SizedBox(width: 12),
                    Text('#INV-${order.id.toString().padLeft(6, '0')}',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w700,
                          color: colors.primary,
                          letterSpacing: -0.5,
                          fontFamily: 'Poppins',
                        )),
                  ]),
                ]),
                const SizedBox(height: 8),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
                  decoration: BoxDecoration(
                    color: _getStatusColor(order.status),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(mainAxisSize: MainAxisSize.min, children: [
                    Icon(Icons.check_circle_outline,
                        size: 18, color: colors.onPrimaryContainer),
                    const SizedBox(width: 6),
                    Text(order.status,
                        style: TextStyle(
                          color: colors.onPrimaryContainer,
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        )),
                  ]),
                ),
              ])),
        ]),
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'completed':
        return Colors.green;
      case 'ordered':
        return Colors.amber[600]!;
      case 'cancelled':
        return Colors.red;
      default:
        return AppColors.primaryColor;
    }
  }

  Widget _buildCustomerCard(ColorScheme colors) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(children: [
          CircleAvatar(
              radius: 28, child: Image.asset('assets/images/user.png')),
          const SizedBox(width: 16),
          Expanded(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                Text(order.clientName,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: colors.onSurface,
                    )),
                const SizedBox(height: 8),
                _buildInfoRow(Icons.phone, colors.outline, order.contact),
                _buildInfoRow(Icons.location_on, colors.outline,
                    '${order.city}, ${order.country}'),
              ])),
        ]),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, Color color, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Icon(icon, size: 16, color: color),
        const SizedBox(width: 8),
        Expanded(
            child: Text(text,
                style: TextStyle(
                  color: color,
                  fontFamily: 'Poppins',
                ))),
      ]),
    );
  }

  Widget _buildOrderItems(ThemeData theme) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: Text('Order Summary',
            style: theme.textTheme.titleMedium!
                .copyWith(fontWeight: FontWeight.w600)),
      ),
      const SizedBox(height: 12),
      Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(children: [
            _buildSummaryRow('Subtotal', '\$${order.subtotal}'),
            const Divider(
              height: 24,
              color: AppColors.greyLight,
            ),
            _buildSummaryRow('Discount', '-\$${order.discount}'),
            const Divider(
              height: 24,
              color: AppColors.greyLight,
            ),
            _buildSummaryRow('Total', '\$${order.total}', isTotal: true),
          ]),
        ),
      ),
    ]);
  }

  Widget _buildSummaryRow(String label, String value, {bool isTotal = false}) {
    return Row(children: [
      Text(label,
          style: TextStyle(
            fontSize: 14,
            fontWeight: isTotal ? FontWeight.w700 : FontWeight.w500,
            color: Colors.grey[600],
          )),
      const Spacer(),
      Text(value,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            fontFamily: 'Poppins',
            color: isTotal ? AppColors.primaryColor : Colors.black87,
          )),
    ]);
  }

  Widget _buildDateCard(ColorScheme colors, String formattedDate) {
    return Card(
      color: AppColors.primaryColor,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        child: Row(children: [
          const Icon(Icons.calendar_month, color: Colors.white),
          const SizedBox(width: 12),
          Text(formattedDate,
              style: TextStyle(
                color: colors.onPrimaryContainer,
                fontWeight: FontWeight.w500,
                fontFamily: 'Poppins',
              )),
        ]),
      ),
    );
  }

  Widget _buildTotalSection(ThemeData theme) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(children: [
          _buildTotalRow('Payment Method:', 'Credit Card', theme),
          const Divider(
            height: 24,
            color: AppColors.greyLight,
          ),
          _buildTotalRow('Transaction ID:', 'PAY-${order.id}123', theme),
        ]),
      ),
    );
  }

  Widget _buildTotalRow(String label, String value, ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(children: [
        Text(label,
            style: theme.textTheme.bodyMedium!.copyWith(
              color: theme.colorScheme.outline,
              fontWeight: FontWeight.w500,
            )),
        const Spacer(),
        Text(value,
            style: theme.textTheme.bodyMedium!.copyWith(
              fontWeight: FontWeight.w600,
            )),
      ]),
    );
  }
}
