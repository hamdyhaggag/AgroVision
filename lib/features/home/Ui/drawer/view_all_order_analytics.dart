import 'package:agro_vision/core/themes/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:agro_vision/features/home/data/models/order_analytics_model.dart'
    as data_models;

import '../../../../shared/widgets/custom_appbar.dart';

class InvoiceSectionView extends StatelessWidget {
  final List<data_models.LatestOrder> latestOrders;
  const InvoiceSectionView({super.key, required this.latestOrders});

  @override
  Widget build(BuildContext context) {
    final totalInvoices = latestOrders.length;
    final totalRevenue =
        latestOrders.fold(0.0, (sum, order) => sum + order.amount);

    return Scaffold(
      appBar: CustomAppBar(
        title: 'Invoice Payments',
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(
                totalInvoices: totalInvoices, totalRevenue: totalRevenue),
            const SizedBox(height: 24),
            const Text('Recent Transactions',
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'Syne',
                    color: AppColors.blackColor)),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.separated(
                itemCount: latestOrders.length,
                separatorBuilder: (_, __) => const SizedBox(height: 12),
                itemBuilder: (context, index) =>
                    _InvoiceCard(order: latestOrders[index]),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(
      {required int totalInvoices, required double totalRevenue}) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.primaryColor.withValues(alpha: 0.9),
            AppColors.primaryColor.withValues(alpha: 0.7)
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.indigo.withValues(alpha: 0.1),
            blurRadius: 12,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildStatItem(
              title: "Total Invoices",
              value: totalInvoices.toString(),
              icon: Icons.receipt_long_rounded,
              color: Colors.white,
            ),
            _buildStatItem(
              title: "Total Revenue",
              value: "\$${totalRevenue.toStringAsFixed(2)}",
              icon: Icons.attach_money_rounded,
              color: Colors.white,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem({
    required String title,
    required String value,
    required IconData icon,
    required Color color,
  }) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.15),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, size: 28, color: color),
        ),
        const SizedBox(height: 8),
        Text(value,
            style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w700,
                fontFamily: 'Syne',
                color: color)),
        Text(title,
            style: TextStyle(
                fontSize: 14,
                fontFamily: 'Syne',
                color: color.withValues(alpha: 0.8))),
      ],
    );
  }
}

class _InvoiceCard extends StatelessWidget {
  final data_models.LatestOrder order;

  const _InvoiceCard({required this.order});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: () {},
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withValues(alpha: 0.1),
              blurRadius: 10,
              offset: const Offset(0, 4),
            )
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("#INV-${order.orderId}",
                      style: TextStyle(
                          fontSize: 14,
                          fontFamily: 'Syne',
                          color: Colors.grey.shade600)),
                  _buildStatusIndicator("Paid"),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(order.customer,
                          style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              fontFamily: 'Syne',
                              color: AppColors.primaryColor)),
                      const SizedBox(height: 4),
                      Text("Due: ${order.createdAt}",
                          style: TextStyle(
                              fontSize: 12,
                              fontFamily: 'Syne',
                              color: Colors.grey.shade600)),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text("\$${order.amount.toStringAsFixed(2)}",
                          style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                              fontFamily: 'Syne',
                              color: AppColors.primaryColor)),
                      const SizedBox(height: 4),
                      Text("USD",
                          style: TextStyle(
                              fontSize: 12,
                              fontFamily: 'Syne',
                              color: Colors.grey.shade600)),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case "Paid":
        return Colors.green;
      case "Pending":
        return Colors.orange;
      case "Overdue":
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  Widget _buildStatusIndicator(String status) {
    final color = _getStatusColor(status);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withValues(alpha: 0.3), width: 1),
      ),
      child: Text(status,
          style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              fontFamily: 'Syne',
              color: color)),
    );
  }
}

class FullClientsView extends StatelessWidget {
  final List<data_models.Client> clients;
  const FullClientsView({super.key, required this.clients});

  @override
  Widget build(BuildContext context) {
    final totalClients = clients.length;
    final totalOrders =
        clients.fold(0, (sum, client) => sum + client.ordersCount);

    return Scaffold(
      appBar: CustomAppBar(
        title: 'Clients',
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(totalClients: totalClients, totalOrders: totalOrders),
            const SizedBox(height: 24),
            const Text('All Clients',
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'Syne',
                    color: AppColors.blackColor)),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.separated(
                itemCount: clients.length,
                separatorBuilder: (_, __) => const SizedBox(height: 12),
                itemBuilder: (context, index) =>
                    _ClientCard(client: clients[index]),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader({required int totalClients, required int totalOrders}) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.secondaryColor.withValues(alpha: 0.9),
            AppColors.secondaryColor.withValues(alpha: 0.7)
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.lightBlue.withValues(alpha: 0.1),
            blurRadius: 12,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildStatItem(
              title: "Total Clients",
              value: totalClients.toString(),
              icon: Icons.people_alt_rounded,
              color: Colors.white,
            ),
            _buildStatItem(
              title: "Total Orders",
              value: totalOrders.toString(),
              icon: Icons.shopping_cart_rounded,
              color: Colors.white,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem({
    required String title,
    required String value,
    required IconData icon,
    required Color color,
  }) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.15),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, size: 28, color: color),
        ),
        const SizedBox(height: 8),
        Text(value,
            style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w700,
                fontFamily: 'Syne',
                color: color)),
        Text(title,
            style: TextStyle(
                fontSize: 14,
                fontFamily: 'Syne',
                color: color.withValues(alpha: 0.8))),
      ],
    );
  }
}

class _ClientCard extends StatelessWidget {
  final data_models.Client client;

  const _ClientCard({required this.client});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: () {},
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withValues(alpha: 0.1),
              blurRadius: 10,
              offset: const Offset(0, 4),
            )
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              CircleAvatar(
                radius: 24,
                backgroundColor: AppColors.primaryColor.withValues(alpha: 0.1),
                child: Text(
                  client.name.substring(0, 1).toUpperCase(),
                  style: const TextStyle(
                    color: AppColors.primaryColor,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Syne',
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(client.name,
                        style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            fontFamily: 'Syne',
                            color: AppColors.primaryColor)),
                    const SizedBox(height: 4),
                    Text("Phone: ${client.phone}",
                        style: TextStyle(
                            fontSize: 12,
                            fontFamily: 'Syne',
                            color: Colors.grey.shade600)),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text("${client.ordersCount}",
                      style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          fontFamily: 'Syne',
                          color: AppColors.primaryColor)),
                  const SizedBox(height: 4),
                  Text("Orders",
                      style: TextStyle(
                          fontSize: 12,
                          fontFamily: 'Syne',
                          color: Colors.grey.shade600)),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class Invoice {
  final String id;
  final String client;
  final String date;
  final double amount;
  final String status;

  Invoice({
    required this.id,
    required this.client,
    required this.date,
    required this.amount,
    required this.status,
  });
}
