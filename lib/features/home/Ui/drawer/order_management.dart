import 'package:agro_vision/features/home/Ui/drawer/widgets/order_details_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../../../core/helpers/cache_helper.dart';
import '../../../../core/network/api_service.dart';
import '../../../../core/network/dio_factory.dart';
import '../../../../models/api_order.dart';
import '../../Api/orders_repo.dart';
import '../../Logic/orders_cubit/orders_cubit.dart';

class OrderManagementScreen extends StatefulWidget {
  const OrderManagementScreen({super.key});

  @override
  State<OrderManagementScreen> createState() => _OrderManagementScreenState();
}

class _OrderManagementScreenState extends State<OrderManagementScreen> {
  List<String> selectedStatuses = [];
  List<Order> orders = [];

  List<Order> _mapApiOrdersToUiOrders(List<ApiOrder> apiOrders) {
    return apiOrders.map((apiOrder) {
      return Order(
        id: apiOrder.id,
        dueDate: _formatDate(apiOrder.deliveredDate),
        clientName: apiOrder.name,
        contact: apiOrder.phone,
        amount: double.parse(apiOrder.total),
        status: _mapApiStatusToUiStatus(apiOrder.status),
        city: apiOrder.city, // now provided
        country: apiOrder.country, // now provided
        subtotal: apiOrder.subtotal, // now provided
        discount: apiOrder.discount, // now provided
        total: apiOrder
            .total, // now provided (if it's a string; adjust if necessary)
      );
    }).toList();
  }

  String _mapApiStatusToUiStatus(String apiStatus) {
    switch (apiStatus.toLowerCase()) {
      case 'delivered':
        return 'Completed';
      case 'pending':
        return 'Pending';
      case 'cancelled':
        return 'Cancelled';
      case 'processing':
        return 'Processing';
      default:
        return 'Pending';
    }
  }

  String _formatDate(DateTime? date) {
    if (date == null) return 'N/A';
    return DateFormat('yyyy-MM-dd').format(date);
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
            appBar: AppBar(
              title: const Text('Order Management'),
              actions: [
                IconButton(
                  icon:
                      Icon(Icons.filter_alt_outlined, color: Colors.grey[800]),
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
                  // Update your local orders list when the bloc loads orders
                  orders = _mapApiOrdersToUiOrders(state.orders);
                }
              },
              builder: (context, state) {
                if (state is OrdersLoading) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (state is OrdersError) {
                  return _ErrorWidget(message: state.message);
                }
                if (state is OrdersLoaded) {
                  final filteredOrders = selectedStatuses.isEmpty
                      ? orders
                      : orders
                          .where((order) => selectedStatuses
                              .contains(order.status.toLowerCase()))
                          .toList();

                  return _buildOrderList(filteredOrders);
                }
                return const Center(child: CircularProgressIndicator());
              },
            )));
  }

  Widget _buildOrderList(List<Order> orders) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      child: Column(
        children: [
          Expanded(
            child: ListView.separated(
              physics: const BouncingScrollPhysics(),
              itemCount: orders.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (context, index) => _OrderCard(order: orders[index]),
            ),
          ),
          // ElevatedButton(
          //   style: ElevatedButton.styleFrom(
          //     backgroundColor: Colors.green,
          //     foregroundColor: Colors.white,
          //     minimumSize: const Size(double.infinity, 50),
          //     shape: RoundedRectangleBorder(
          //         borderRadius: BorderRadius.circular(12)),
          //   ),
          //   // onPressed: () =>
          //   //     _navigateToCreateOrder(context),
          //   child: const Text('Create Invoice'),
          // ),
        ],
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

  // void _navigateToCreateOrder(BuildContext context) {
  //   Navigator.push(
  //     context,
  //     MaterialPageRoute(
  //       builder: (context) => CreateOrderScreen(
  //         onOrderCreated: (newOrder) {
  //           // Instead of manipulating a local list,
  //           // trigger a refresh from your bloc
  //           // Option 1: Dispatch an event (if using Bloc pattern with events)
  //           // context.read<OrdersCubit>().refreshOrders();
  //
  //           // Option 2: Simply re-fetch the orders:
  //           final userId = CacheHelper.getInt('userId');
  //           context.read<OrdersCubit>().fetchOrders(userId);
  //         },
  //       ),
  //     ),
  //   );
  // }
}

class _ErrorWidget extends StatelessWidget {
  final String message;
  const _ErrorWidget({required this.message});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(message, style: const TextStyle(color: Colors.red)),
          ElevatedButton(
            onPressed: () => context
                .read<OrdersCubit>()
                .fetchOrders(CacheHelper.getInt('userId')),
            child: const Text('Retry'),
          )
        ],
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
                      color: statusColor.withValues(alpha: 0.1),
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
  final String city;
  final String country;
  final String subtotal;
  final String discount;
  final String total;

  Order({
    required this.id,
    required this.dueDate,
    required this.clientName,
    required this.contact,
    required this.amount,
    required this.status,
    required this.city,
    required this.country,
    required this.subtotal,
    required this.discount,
    required this.total,
  });
}
