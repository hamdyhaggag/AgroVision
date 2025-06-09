import 'package:agro_vision/core/themes/app_colors.dart';
import 'package:agro_vision/features/home/Ui/drawer/view_all_order_analytics.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import '../../../../shared/widgets/custom_appbar.dart';
import 'package:agro_vision/features/home/data/models/order_analytics_model.dart'
    as data_models;
import 'dart:convert';

class OrderAnalytics extends StatefulWidget {
  const OrderAnalytics({super.key});

  @override
  State<OrderAnalytics> createState() => _OrderAnalyticsState();
}

class _OrderAnalyticsState extends State<OrderAnalytics> {
  late Future<data_models.OrderAnalyticsData> _analyticsDataFuture;

  final String jsonData =
      """{ "total_orders": 3, "total_sales": 23.9, "status_counts": { "pending": 1, "delivered": 1, "canceled": 1 }, "monthly_sales": [ { "month": "Jan", "total": 0 }, { "month": "Feb", "total": 0 }, { "month": "Mar", "total": 0 }, { "month": "Apr", "total": 0 }, { "month": "May", "total": 8.9 }, { "month": "Jun", "total": 15 }, { "month": "Jul", "total": 0 }, { "month": "Aug", "total": 0 }, { "month": "Sep", "total": 0 }, { "month": "Oct", "total": 0 }, { "month": "Nov", "total": 0 }, { "month": "Dec", "total": 0 } ], "latest_orders": [ { "order_id": 37, "customer": "Salem Ashraf", "amount": 15, "created_at": "2025-06-04" }, { "order_id": 28, "customer": "feby emad", "amount": 7.1, "created_at": "2025-05-01" } ], "clients": [ { "name": "Salem Ashraf", "phone": "1098971853", "orders_count": 2 }, { "name": "feby emad", "phone": "1289379907", "orders_count": 1 } ]}""";

  @override
  void initState() {
    super.initState();
    _analyticsDataFuture = _fetchAnalyticsData();
  }

  Future<data_models.OrderAnalyticsData> _fetchAnalyticsData() async {
    // Simulate network delay
    await Future.delayed(const Duration(seconds: 1));
    final Map<String, dynamic> decodedData = json.decode(jsonData);
    return data_models.OrderAnalyticsData.fromJson(decodedData);
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 600;
    return Scaffold(
      appBar: const CustomAppBar(title: 'Order Analytics'),
      body: FutureBuilder<data_models.OrderAnalyticsData>(
        future: _analyticsDataFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            final data = snapshot.data!;
            return SingleChildScrollView(
              padding: EdgeInsets.symmetric(
                horizontal: isMobile ? 16 : 24,
                vertical: 16,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildStatsSection(context, isMobile, data.totalOrders,
                      data.totalSales, data.statusCounts),
                  const SizedBox(height: 32),
                  _buildChartSection(context, data.monthlySales),
                  const SizedBox(height: 32),
                  _buildInvoiceSection(context, data.latestOrders),
                  const SizedBox(height: 32),
                  _buildClientsSection(context, isMobile, data.clients),
                ],
              ),
            );
          } else {
            return const Center(child: Text('No data available'));
          }
        },
      ),
    );
  }

  Widget _buildStatsSection(
      BuildContext context,
      bool isMobile,
      int totalOrders,
      double totalSales,
      data_models.StatusCounts statusCounts) {
    final stats = [
      {
        'title': 'Total Orders',
        'value': totalOrders.toString(),
        'icon': Icons.shopping_cart_rounded,
        'color': Colors.green
      },
      {
        'title': 'Total Sales',
        'value': '\$' + totalSales.toStringAsFixed(2),
        'icon': Icons.attach_money_rounded,
        'color': Colors.blue
      },
      {
        'title': 'Pending Orders',
        'value': statusCounts.pending.toString(),
        'icon': Icons.pending_actions_rounded,
        'color': Colors.orange
      },
      {
        'title': 'Delivered Orders',
        'value': statusCounts.delivered.toString(),
        'icon': Icons.check_circle_rounded,
        'color': Colors.purple
      },
      {
        'title': 'Canceled Orders',
        'value': statusCounts.canceled.toString(),
        'icon': Icons.cancel_rounded,
        'color': Colors.red
      },
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 1.8,
      ),
      itemCount: stats.length,
      itemBuilder: (context, index) => _StatCard(
        title: stats[index]['title'] as String,
        value: stats[index]['value'] as String,
        icon: stats[index]['icon'] as IconData,
        color: stats[index]['color'] as Color,
        centerContent: true,
      ),
    );
  }

  Widget _buildChartSection(
      BuildContext context, List<data_models.MonthlySale> monthlySales) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Text(
            'Sales Statistic (Monthly)',
            style: Theme.of(context)
                .textTheme
                .titleLarge
                ?.copyWith(fontFamily: 'SYNE', fontWeight: FontWeight.w600),
          ),
        ),
        const SizedBox(height: 16),
        Container(
          height: 280,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: _InvoiceChart(monthlySales: monthlySales),
        ),
      ],
    );
  }

  Widget _buildInvoiceSection(
      BuildContext context, List<data_models.LatestOrder> latestOrders) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Latest Orders',
                style: Theme.of(context)
                    .textTheme
                    .titleLarge
                    ?.copyWith(fontFamily: 'SYNE', fontWeight: FontWeight.w600),
              ),
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const InvoiceSectionView(),
                    ),
                  );
                },
                child: const Text('View all'),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        Container(
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 12,
                offset: const Offset(0, 4),
              )
            ],
          ),
          child: Column(
            children: latestOrders
                .map((order) => Column(children: [
                      _InvoiceTile(
                        company: order.customer,
                        amount: '\$' + order.amount.toStringAsFixed(2),
                        date: order.createdAt,
                        status: InvoiceStatus.paid,
                      ),
                      const _Divider(),
                    ]))
                .toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildClientsSection(
      BuildContext context, bool isMobile, List<data_models.Client> clients) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Top Clients',
                style: TextStyle(
                  fontSize: 20,
                  fontFamily: 'Syne',
                  fontWeight: FontWeight.w600,
                  color: AppColors.blackColor,
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => FullClientsView(clients: clients),
                    ),
                  );
                },
                child: const Text('View all',
                    style: TextStyle(
                      fontFamily: 'Syne',
                      color: AppColors.blackColor,
                      fontWeight: FontWeight.w600,
                    )),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        Wrap(
          spacing: 16,
          runSpacing: 16,
          children:
              clients.map((client) => _ClientCard(client: client)).toList(),
        )
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;
  final double? width;
  final bool centerContent;

  const _StatCard({
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
    this.width,
    this.centerContent = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width ?? double.infinity,
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            color.withValues(alpha: 0.05),
            color.withValues(alpha: 0.15)
          ],
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.2),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 16),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  fontFamily: 'SYNE',
                  color: Theme.of(context)
                      .colorScheme
                      .onSurface
                      .withValues(alpha: 0.6),
                  fontSize: 11,
                ),
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 2),
          Text(
            value,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontFamily: 'SYNE',
                  fontWeight: FontWeight.w700,
                  color: color,
                  fontSize: 14,
                ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class _InvoiceChart extends StatelessWidget {
  final List<data_models.MonthlySale> monthlySales;
  const _InvoiceChart({required this.monthlySales});

  @override
  Widget build(BuildContext context) {
    final spots = monthlySales.asMap().entries.map((entry) {
      final index = entry.key;
      final sale = entry.value;
      return FlSpot((index + 1).toDouble(), sale.total);
    }).toList();

    double maxY =
        monthlySales.map((e) => e.total).reduce((a, b) => a > b ? a : b);
    maxY = (maxY * 1.2).ceilToDouble(); // Add some padding to the max Y value

    final maxMonthValue = monthlySales.length.toDouble();

    return LineChart(
      LineChartData(
        gridData: FlGridData(
          show: true,
          drawVerticalLine: true,
          horizontalInterval: maxY / 5,
          verticalInterval: 1,
          getDrawingHorizontalLine: (value) => FlLine(
            color: Colors.grey.withValues(alpha: 0.1),
            strokeWidth: 1,
          ),
          getDrawingVerticalLine: (value) => FlLine(
            color: Colors.grey.withValues(alpha: 0.1),
            strokeWidth: 1,
          ),
        ),
        titlesData: FlTitlesData(
          show: true,
          rightTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          topTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 30,
              interval: 1,
              getTitlesWidget: (value, meta) {
                if (value.toInt() - 1 < monthlySales.length &&
                    value.toInt() - 1 >= 0) {
                  return Text(
                    monthlySales[value.toInt() - 1].month,
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: Theme.of(context).colorScheme.onSurface),
                  );
                }
                return const Text('');
              },
            ),
          ),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              interval: maxY / 5, // Dynamic interval based on max Y
              getTitlesWidget: (value, meta) => Text(
                '\$' + value.toInt().toString(),
                style: Theme.of(context)
                    .textTheme
                    .labelSmall
                    ?.copyWith(color: Theme.of(context).colorScheme.onSurface),
              ),
              reservedSize: 40,
            ),
          ),
        ),
        borderData: FlBorderData(
          show: false,
        ),
        minX: 1,
        maxX: maxMonthValue,
        minY: 0,
        maxY: maxY,
        lineBarsData: [
          LineChartBarData(
            spots: spots,
            isCurved: true,
            color: AppColors.primaryColor,
            barWidth: 4,
            isStrokeCapRound: true,
            dotData: const FlDotData(show: false),
            belowBarData: BarAreaData(
              show: true,
              color: AppColors.primaryColor.withValues(alpha: 0.2),
            ),
          ),
        ],
      ),
    );
  }
}

class _InvoiceTile extends StatelessWidget {
  final String company;
  final String amount;
  final String date;
  final InvoiceStatus status;
  const _InvoiceTile(
      {required this.company,
      required this.amount,
      required this.date,
      required this.status});
  @override
  Widget build(BuildContext context) {
    final statusColor = {
      InvoiceStatus.paid: Colors.green,
      InvoiceStatus.pending: Colors.orange,
      InvoiceStatus.overdue: Colors.red,
    }[status];
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      leading: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: statusColor!.withValues(alpha: 0.1),
          shape: BoxShape.circle,
        ),
        child: Icon(
          Icons.receipt_long_rounded,
          color: statusColor,
          size: 24,
        ),
      ),
      title: Text(
        company,
        style: Theme.of(context)
            .textTheme
            .bodyLarge
            ?.copyWith(fontFamily: 'SYNE', fontWeight: FontWeight.w500),
      ),
      subtitle: Text(
        'Order Date: $date',
        style: Theme.of(context).textTheme.bodySmall?.copyWith(
            fontFamily: 'SYNE',
            color:
                Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6)),
      ),
      trailing: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            amount,
            style: Theme.of(context)
                .textTheme
                .bodyLarge
                ?.copyWith(fontFamily: 'SYNE', fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 4),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: statusColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              status.name.toUpperCase(),
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  fontFamily: 'SYNE',
                  color: statusColor,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.5),
            ),
          ),
        ],
      ),
    );
  }
}

enum InvoiceStatus { paid, pending, overdue }

class _ClientCard extends StatelessWidget {
  final data_models.Client client;
  const _ClientCard({required this.client});
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => FullClientsView(
                clients: const []), // Changed to do nothing specific on tap, as a single client detail view is not implemented yet. // Pass clients to FullClientsView
          ),
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
                    fontFamily: 'SYNE',
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      client.name,
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            fontFamily: 'SYNE',
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Orders: ${client.ordersCount}',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            fontFamily: 'SYNE',
                            color: Theme.of(context)
                                .colorScheme
                                .onSurface
                                .withValues(alpha: 0.6),
                          ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.chevron_right_rounded,
                color: Theme.of(context)
                    .colorScheme
                    .onSurface
                    .withValues(alpha: 0.3),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Divider extends StatelessWidget {
  const _Divider();
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Divider(
        height: 1,
        color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.1),
      ),
    );
  }
}
