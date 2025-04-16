import 'package:agro_vision/core/themes/app_colors.dart';
import 'package:agro_vision/features/home/Ui/drawer/view_all_order_analytics.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import '../../../../shared/widgets/custom_appbar.dart';

class OrderAnalytics extends StatelessWidget {
  const OrderAnalytics({super.key});
  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 600;
    return Scaffold(
      appBar: const CustomAppBar(title: 'Order Analytics'),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(
          horizontal: isMobile ? 16 : 24,
          vertical: 16,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildStatsSection(context, isMobile),
            const SizedBox(height: 32),
            _buildChartSection(context),
            const SizedBox(height: 32),
            _buildInvoiceSection(context),
            const SizedBox(height: 32),
            _buildClientsSection(context, isMobile),
          ],
        ),
      ),
    );
  }

  Widget _buildStatsSection(BuildContext context, bool isMobile) {
    final stats = [
      {
        'title': 'Total Balance',
        'value': '\$12,560',
        'icon': Icons.account_balance_wallet_rounded,
        'color': Colors.green
      },
      {
        'title': 'Invoice Sent',
        'value': '421',
        'icon': Icons.send_rounded,
        'color': Colors.blue
      },
      {
        'title': 'Completed',
        'value': '286',
        'icon': Icons.check_circle_rounded,
        'color': Colors.orange
      },
    ];

    return isMobile
        ? Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  Expanded(
                    child: _StatCard(
                      title: stats[0]['title'] as String,
                      value: stats[0]['value'] as String,
                      icon: stats[0]['icon'] as IconData,
                      color: stats[0]['color'] as Color,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _StatCard(
                      title: stats[1]['title'] as String,
                      value: stats[1]['value'] as String,
                      icon: stats[1]['icon'] as IconData,
                      color: stats[1]['color'] as Color,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              _StatCard(
                title: stats[2]['title'] as String,
                value: stats[2]['value'] as String,
                icon: stats[2]['icon'] as IconData,
                color: stats[2]['color'] as Color,
                centerContent: true,
              ),
            ],
          )
        : SizedBox(
            height: 140,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: 3,
              separatorBuilder: (_, __) => const SizedBox(width: 16),
              itemBuilder: (context, index) => _StatCard(
                title: stats[index]['title'] as String,
                value: stats[index]['value'] as String,
                icon: stats[index]['icon'] as IconData,
                color: stats[index]['color'] as Color,
                width: 200,
              ),
            ),
          );
  }

  Widget _buildChartSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Text(
            'Invoices Statistic (Monthly)',
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
          child: const _InvoiceChart(),
        ),
      ],
    );
  }

  Widget _buildInvoiceSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Latest Invoice Payments',
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
          child: const Column(
            children: [
              _InvoiceTile(
                company: 'IBM Graphic Inc.',
                amount: '\$1,500.96',
                date: '2023-03-15',
                status: InvoiceStatus.paid,
              ),
              _Divider(),
              _InvoiceTile(
                company: 'Hyperseed Data',
                amount: '\$20,000.00',
                date: '2023-03-14',
                status: InvoiceStatus.paid,
              ),
              _Divider(),
              _InvoiceTile(
                company: 'XYZ Agency',
                amount: '\$500.00',
                date: '2023-03-13',
                status: InvoiceStatus.pending,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildClientsSection(BuildContext context, bool isMobile) {
    final clients = [
      Client(name: "Ken Graphic Inc.", type: "Design Agency", orders: 183),
      Client(name: "Fullspeedo Crew", type: "Photograph Agency", orders: 99),
      Client(name: "Highspeed Studios", type: "Network Service", orders: 48),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
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
                      builder: (_) => const FullClientsView(),
                    ),
                  );
                },
                child: Text('View all',
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
          children: clients.map((client) => const _ClientCard()).toList(),
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
      constraints: const BoxConstraints(minHeight: 140),
      padding: const EdgeInsets.all(20),
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
        crossAxisAlignment: centerContent
            ? CrossAxisAlignment.center
            : CrossAxisAlignment.start,
        mainAxisAlignment: centerContent
            ? MainAxisAlignment.center
            : MainAxisAlignment.spaceBetween,
        children: [
          if (!centerContent)
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.2),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: color, size: 24),
            ),
          if (!centerContent) const SizedBox(height: 16),
          Column(
            crossAxisAlignment: centerContent
                ? CrossAxisAlignment.center
                : CrossAxisAlignment.start,
            children: [
              if (centerContent)
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.2),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(icon, color: color, size: 24),
                ),
              if (centerContent) const SizedBox(height: 16),
              Text(
                title,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontFamily: 'SYNE',
                      color: Theme.of(context)
                          .colorScheme
                          .onSurface
                          .withValues(alpha: 0.6),
                    ),
              ),
              const SizedBox(height: 8),
              Text(
                value,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontFamily: 'SYNE',
                      fontWeight: FontWeight.w700,
                      color: color,
                    ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _InvoiceChart extends StatelessWidget {
  const _InvoiceChart();

  @override
  Widget build(BuildContext context) {
    return LineChart(
      LineChartData(
        gridData: FlGridData(
          show: true,
          drawVerticalLine: true,
          horizontalInterval: 200,
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
                const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun'];
                return Text(
                  months[value.toInt() - 1],
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: Theme.of(context).colorScheme.onSurface),
                );
              },
            ),
          ),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              interval: 200,
              getTitlesWidget: (value, meta) => Text(
                '\$${value.toInt()}',
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
        maxX: 6,
        minY: 0,
        maxY: 1000,
        lineBarsData: [
          LineChartBarData(
            spots: const [
              FlSpot(1, 200),
              FlSpot(2, 500),
              FlSpot(3, 800),
              FlSpot(4, 600),
              FlSpot(5, 750),
              FlSpot(6, 950),
            ],
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
          LineChartBarData(
            spots: const [
              FlSpot(1, 300),
              FlSpot(2, 400),
              FlSpot(3, 650),
              FlSpot(4, 450),
              FlSpot(5, 550),
              FlSpot(6, 700),
            ],
            isCurved: true,
            color: Colors.grey,
            barWidth: 2,
            isStrokeCapRound: true,
            dotData: const FlDotData(show: false),
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
        'Due $date',
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
  const _ClientCard();
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
            builder: (_) => const FullClientsView(),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              CircleAvatar(
                radius: 24,
                backgroundColor: AppColors.primaryColor.withValues(alpha: 0.1),
                child: const Text(
                  'IB',
                  style: TextStyle(
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
                      'IBM Corp.',
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            fontFamily: 'SYNE',
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Last order: \$12,500',
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
