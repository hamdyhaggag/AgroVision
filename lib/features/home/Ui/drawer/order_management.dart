import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:shimmer/shimmer.dart';
import '../../../../core/helpers/cache_helper.dart';
import '../../../../core/network/api_service.dart';
import '../../../../core/network/dio_factory.dart';
import '../../../../models/api_order.dart';
import '../../../../shared/widgets/custom_appbar.dart';
import '../../Api/orders_repo.dart';
import '../../Logic/orders_cubit/orders_cubit.dart';
import 'widgets/order_details_screen.dart';

class OrderManagementScreen extends StatefulWidget {
  const OrderManagementScreen({super.key});

  @override
  State<OrderManagementScreen> createState() => _OrderManagementScreenState();
}

class _OrderManagementScreenState extends State<OrderManagementScreen> {
  List<String> selectedStatuses = [];
  List<Order> orders = [];

  List<Order> _mapApiOrdersToUiOrders(List<ApiOrder> apiOrders) {
    return apiOrders
        .map((apiOrder) => Order(
              id: apiOrder.id,
              clientName: apiOrder.name,
              contact: apiOrder.phone,
              amount: double.parse(apiOrder.total),
              status: _mapApiStatusToUiStatus(apiOrder.status),
              city: apiOrder.city,
              country: apiOrder.country,
              subtotal: apiOrder.subtotal,
              discount: apiOrder.discount,
              total: apiOrder.total,
              deliveredDate: apiOrder.deliveredDate,
              canceledDate: apiOrder.canceledDate,
              createdAt: apiOrder.createdAt,
              updatedAt: apiOrder.updatedAt,
            ))
        .toList();
  }

  String _mapApiStatusToUiStatus(String apiStatus) {
    switch (apiStatus.toLowerCase()) {
      case 'delivered':
        return 'Completed';
      case 'pending':
        return 'Pending';
      case 'cancelled':
        return 'Cancelled';
      case 'ordered':
        return 'Ordered';
      default:
        return 'Pending';
    }
  }

  String _formatDate(DateTime? date) {
    return date != null ? DateFormat('yyyy-MM-dd – HH:mm').format(date) : 'N/A';
  }

  @override
  Widget build(BuildContext context) {
    final userId = CacheHelper.getInt('userId');
    final token = CacheHelper.getStringg('token');

    if (userId == -1 || token.isEmpty) {
      Future.microtask(() => Navigator.pushReplacementNamed(context, '/login'));
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return BlocProvider(
      create: (context) =>
          OrdersCubit(OrdersRepo(ApiService(DioFactory.getAgrovisionDio())))
            ..fetchOrders(userId),
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: CustomAppBar(
          title: 'Order Management',
          actions: [
            IconButton(
              icon: Icon(Icons.filter_alt_outlined, color: Colors.grey[800]),
              onPressed: () => _showFilterOptions(context),
            ),
          ],
        ),
        body: BlocConsumer<OrdersCubit, OrdersState>(
          listener: (context, state) {
            if (state is OrdersError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.message)),
              );
            }
            if (state is OrdersLoaded) {
              orders = _mapApiOrdersToUiOrders(state.orders);
            }
          },
          builder: (context, state) {
            if (state is OrdersLoading) {
              return RefreshIndicator(
                onRefresh: () async =>
                    context.read<OrdersCubit>().fetchOrders(userId),
                child: ListView.separated(
                  physics: const AlwaysScrollableScrollPhysics(),
                  itemCount: 6,
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemBuilder: (_, __) => const _ShimmerOrderCard(),
                ),
              );
            }
            if (state is OrdersError) {
              return _ErrorWidget(message: state.message);
            }
            if (state is OrdersLoaded) {
              return RefreshIndicator(
                onRefresh: () async =>
                    context.read<OrdersCubit>().fetchOrders(userId),
                child: _buildOrderList(selectedStatuses.isEmpty
                    ? orders
                    : orders
                        .where((order) => selectedStatuses
                            .contains(order.status.toLowerCase()))
                        .toList()),
              );
            }
            return const Center(child: CircularProgressIndicator());
          },
        ),
      ),
    );
  }

  Widget _buildOrderList(List<Order> orders) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      child: Column(children: [
        Expanded(
            child: ListView.separated(
          physics: const BouncingScrollPhysics(),
          itemCount: orders.length,
          separatorBuilder: (_, __) => const SizedBox(height: 12),
          itemBuilder: (context, index) =>
              _OrderCard(order: orders[index], formatDate: _formatDate),
        )),
      ]),
    );
  }

  void _showFilterOptions(BuildContext context) {
    List<String> currentSelected = List.from(selectedStatuses);
    showDialog(
        context: context,
        builder: (context) => StatefulBuilder(
              builder: (context, setState) => AlertDialog(
                title: const Text('Filter Orders'),
                content: Column(mainAxisSize: MainAxisSize.min, children: [
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
                ]),
                actions: [
                  TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Cancel')),
                  TextButton(
                    onPressed: () {
                      setState(() => selectedStatuses = currentSelected);
                      Navigator.pop(context);
                    },
                    child: const Text('Apply'),
                  ),
                ],
              ),
            ));
  }

  void _updateFilters(
      List<String> current, String status, bool? value, Function setState) {
    setState(() => value! ? current.add(status) : current.remove(status));
  }
}

class _ShimmerOrderCard extends StatelessWidget {
  const _ShimmerOrderCard();

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: Colors.white,
        ),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 100,
                  height: 16,
                  color: Colors.white,
                ),
                const Spacer(),
                Container(
                  width: 120,
                  height: 14,
                  color: Colors.white,
                ),
              ],
            ),
            const SizedBox(height: 12),
            _buildShimmerRow(),
            const SizedBox(height: 8),
            _buildShimmerRow(),
            const SizedBox(height: 12),
            Row(
              children: [
                Container(
                  width: 80,
                  height: 18,
                  color: Colors.white,
                ),
                const Spacer(),
                Container(
                  width: 100,
                  height: 24,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.white,
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _buildShimmerRow() {
    return Row(
      children: [
        Container(
          width: 16,
          height: 16,
          color: Colors.white,
        ),
        const SizedBox(width: 8),
        Container(
          width: 60,
          height: 14,
          color: Colors.white,
        ),
        const SizedBox(width: 4),
        Container(
          width: 100,
          height: 14,
          color: Colors.white,
        ),
      ],
    );
  }
}

class _ErrorWidget extends StatelessWidget {
  final String message;
  const _ErrorWidget({required this.message});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        Text(message,
            style: const TextStyle(
              color: Colors.red,
            )),
        ElevatedButton(
          onPressed: () => context
              .read<OrdersCubit>()
              .fetchOrders(CacheHelper.getInt('userId')),
          child: const Text('Retry'),
        )
      ]),
    );
  }
}

class _OrderCard extends StatelessWidget {
  final Order order;
  final String Function(DateTime?) formatDate;

  const _OrderCard({required this.order, required this.formatDate});

  @override
  Widget build(BuildContext context) {
    final statusColor = _getStatusColor(order.status);

    return Material(
      borderRadius: BorderRadius.circular(16),
      color: Colors.white,
      elevation: 1,
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  OrderDetailScreen(order: order, formatDate: formatDate),
            )),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(children: [
              Text('ORDER #${order.id}',
                  style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      fontFamily: 'Poppins',
                      color: Colors.grey[600])),
              const Spacer(),
              Icon(Icons.calendar_today, size: 14, color: Colors.grey[500]),
              const SizedBox(width: 4),
              Text(formatDate(order.createdAt),
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.grey[600],
                    fontWeight: FontWeight.w500,
                    fontFamily: 'Poppins',
                  )),
            ]),
            const SizedBox(height: 12),
            _InfoRow(
                icon: Icons.person_outline,
                label: 'Client:',
                value: order.clientName),
            const SizedBox(height: 8),
            _InfoRow(
                icon: Icons.phone_outlined,
                label: 'Contact:',
                value: order.contact),
            const SizedBox(height: 12),
            Row(children: [
              Text('\$${order.amount.toStringAsFixed(2)}',
                  style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      fontFamily: 'Poppins',
                      color: Colors.black87)),
              const Spacer(),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: statusColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(children: [
                  Icon(Icons.circle, color: statusColor, size: 10),
                  const SizedBox(width: 6),
                  Text(order.status.toUpperCase(),
                      style: TextStyle(
                        color: statusColor,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.3,
                      )),
                ]),
              )
            ])
          ]),
        ),
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'completed':
        return Colors.green;
      case 'ordered':
        return Colors.amber[700]!;
      case 'cancelled':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _InfoRow(
      {required this.icon, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(children: [
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
            color: Colors.black87,
            fontFamily: 'Poppins',
          )),
    ]);
  }
}

class Order {
  final int id;
  final String clientName;
  final String contact;
  final double amount;
  final String status;
  final String city;
  final String country;
  final String subtotal;
  final String discount;
  final String total;
  final DateTime? deliveredDate;
  final DateTime? canceledDate;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  Order({
    required this.id,
    required this.clientName,
    required this.contact,
    required this.amount,
    required this.status,
    required this.city,
    required this.country,
    required this.subtotal,
    required this.discount,
    required this.total,
    required this.deliveredDate,
    required this.canceledDate,
    required this.createdAt,
    required this.updatedAt,
  });
}
