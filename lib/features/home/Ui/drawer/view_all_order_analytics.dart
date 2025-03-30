import 'package:agro_vision/core/themes/app_colors.dart';
import 'package:flutter/material.dart';

import '../../../../shared/widgets/custom_appbar.dart';

class InvoiceSectionView extends StatelessWidget {
  const InvoiceSectionView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('All Invoice Payments')),
      body: Center(
        child: Text(
          'Invoice Section View Content',
          style: Theme.of(context).textTheme.headlineSmall,
        ),
      ),
    );
  }
}

class FullClientsView extends StatelessWidget {
  const FullClientsView({super.key});

  @override
  Widget build(BuildContext context) {
    final clients = [
      Client(name: "Ken Graphic Inc.", type: "Design Agency", orders: 183),
      Client(name: "Fullspeedo Crew", type: "Photograph Agency", orders: 99),
      Client(name: "Highspeed Studios", type: "Network Service", orders: 48),
    ];

    final totalOrders = clients.fold(0, (sum, client) => sum + client.orders);
    final maxOrders =
        clients.map((e) => e.orders).reduce((a, b) => a > b ? a : b);

    return Scaffold(
      appBar: CustomAppBar(
        title: 'Client Portfolio',
        actions: [
          IconButton(
            icon: const Icon(Icons.search, color: AppColors.primaryColor),
            onPressed: () {/* Implement search */},
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(
                totalClients: clients.length, totalOrders: totalOrders),
            const SizedBox(height: 24),
            Text('Active Clients',
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
                itemBuilder: (context, index) => _ClientCard(
                  client: clients[index],
                  maxOrders: maxOrders.toDouble(),
                ),
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
            AppColors.primaryColor.withValues(alpha: 0.9),
            AppColors.primaryColor.withValues(alpha: 0.7)
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.indigo.withOpacity(0.1),
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
              icon: Icons.group_rounded,
              color: Colors.white,
            ),
            _buildStatItem(
              title: "Total Orders",
              value: totalOrders.toString(),
              icon: Icons.shopping_bag_rounded,
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
            color: color.withOpacity(0.15),
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
                color: color.withOpacity(0.8))),
      ],
    );
  }
}

class _ClientCard extends StatelessWidget {
  final Client client;
  final double maxOrders;

  const _ClientCard({required this.client, required this.maxOrders});

  @override
  Widget build(BuildContext context) {
    final progress = client.orders / maxOrders;

    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: () {},
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, 4),
            )
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          AppColors.primaryColor.withValues(alpha: 0.9),
                          AppColors.secondaryColor.withValues(alpha: 0.4)
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Text(
                        client.name.substring(0, 2),
                        style: const TextStyle(
                            color: Colors.white,
                            fontFamily: 'Syne',
                            fontWeight: FontWeight.w600),
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
                        Text(client.type.toUpperCase(),
                            style: TextStyle(
                                fontSize: 12,
                                fontFamily: 'Syne',
                                color: Colors.grey.shade600,
                                letterSpacing: 0.5)),
                      ],
                    ),
                  ),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: _getProgressColor(progress).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: _getProgressColor(progress).withOpacity(0.3),
                        width: 1,
                      ),
                    ),
                    child: Text("${client.orders} orders",
                        style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            fontFamily: 'Syne',
                            color: _getProgressColor(progress))),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: LinearProgressIndicator(
                  value: progress,
                  backgroundColor: Colors.grey.shade200,
                  valueColor:
                      AlwaysStoppedAnimation(_getProgressColor(progress)),
                  minHeight: 8,
                ),
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Order Volume",
                      style: TextStyle(
                          fontSize: 12,
                          fontFamily: 'Syne',
                          color: Colors.grey.shade600)),
                  Text("${(progress * 100).toStringAsFixed(1)}%",
                      style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          fontFamily: 'Syne',
                          color: _getProgressColor(progress))),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color _getProgressColor(double progress) {
    if (progress > 0.75) return Colors.green.shade600;
    if (progress > 0.5) return Colors.orange.shade600;
    return Colors.red.shade600;
  }
}

class Client {
  final String name;
  final String type;
  final int orders;

  Client({
    required this.name,
    required this.type,
    required this.orders,
  });
}
