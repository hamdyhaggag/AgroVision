import 'package:agro_vision/features/home/Ui/drawer/view_all_order_analytics.dart';
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
    return SizedBox(
      height: isMobile ? 160 : 140,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: 3,
        separatorBuilder: (_, __) => const SizedBox(width: 16),
        itemBuilder: (context, index) {
          final stats = [
            {
              'title': 'Total Balance',
              'value': '\$21,560.57',
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
              'value': '874',
              'icon': Icons.check_circle_rounded,
              'color': Colors.orange
            },
          ];
          return _StatCard(
            title: stats[index]['title'] as String,
            value: stats[index]['value'] as String,
            icon: stats[index]['icon'] as IconData,
            color: stats[index]['color'] as Color,
            width: isMobile ? 180 : 200,
          );
        },
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
                color: Colors.black.withOpacity(0.05),
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
                color: Colors.black.withOpacity(0.05),
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
    final totalHorizontalPadding = isMobile ? 16 * 2 : 24 * 2;
    final totalSpacing = isMobile ? 16 : 16 * 3;
    final cardWidth = (MediaQuery.of(context).size.width -
            totalHorizontalPadding -
            totalSpacing) /
        (isMobile ? 2 : 4);
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
                      builder: (_) => const FullClientsView(),
                    ),
                  );
                },
                child: const Text('View all'),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        Wrap(
          spacing: 16,
          runSpacing: 16,
          children: List.generate(4, (_) {
            return SizedBox(
              width: cardWidth,
              child: const _ClientCard(),
            );
          }),
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
  final double width;
  const _StatCard(
      {required this.title,
      required this.value,
      required this.icon,
      required this.color,
      this.width = 200});
  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [color.withOpacity(0.05), color.withOpacity(0.15)],
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: color.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(height: 16),
          Text(
            title,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontFamily: 'SYNE',
                color:
                    Theme.of(context).colorScheme.onSurface.withOpacity(0.6)),
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontFamily: 'SYNE', fontWeight: FontWeight.w700, color: color),
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
    return Column(
      children: [
        SizedBox(
          height: 200,
          child: CustomPaint(
            painter: _ChartPainter(),
          ),
        ),
        const SizedBox(height: 20),
        const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _ChartLegend(color: Colors.blue, label: 'Current Month'),
            SizedBox(width: 24),
            _ChartLegend(color: Colors.grey, label: 'Previous Month'),
          ],
        )
      ],
    );
  }
}

class _ChartPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {}
  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _ChartLegend extends StatelessWidget {
  final Color color;
  final String label;
  const _ChartLegend({required this.color, required this.label});
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
              fontFamily: 'SYNE',
              color: Theme.of(context).colorScheme.onSurface),
        ),
      ],
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
          color: statusColor!.withOpacity(0.1),
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
            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6)),
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
              color: statusColor.withOpacity(0.1),
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
  const _ClientCard({super.key});
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () {},
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              CircleAvatar(
                radius: 24,
                backgroundColor: Colors.blue.withOpacity(0.1),
                child: const Text(
                  'IB',
                  style: TextStyle(
                    color: Colors.blue,
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
                                .withOpacity(0.6),
                          ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.chevron_right_rounded,
                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.3),
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
        color: Theme.of(context).colorScheme.onSurface.withOpacity(0.1),
      ),
    );
  }
}
