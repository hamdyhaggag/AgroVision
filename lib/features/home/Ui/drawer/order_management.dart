import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/helpers/cache_helper.dart';
import '../../../../core/network/api_service.dart';
import '../../../../core/network/dio_factory.dart';
import '../../../../models/api_order.dart';
import '../../Api/orders_repo.dart';
import '../../Logic/orders_cubit/orders_cubit.dart';

@override
class OrderManagementScreen extends StatelessWidget {
  const OrderManagementScreen({super.key});

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
          appBar: AppBar(title: const Text('Order Management')),
          body: BlocConsumer<OrdersCubit, OrdersState>(
            listener: (context, state) {
              if (state is OrdersError) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(state.message)),
                );
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
                if (state.orders.isEmpty) {
                  return const Center(child: Text('No orders found'));
                }
                return _OrderList(orders: state.orders);
              }
              return const Center(child: CircularProgressIndicator());
            },
          )),
    );
  }
}

class _OrderList extends StatelessWidget {
  final List<ApiOrder> orders;
  const _OrderList({required this.orders});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: orders.length,
      itemBuilder: (context, index) => ListTile(
        title: Text('Order #${orders[index].id}'),
        subtitle: Text('Total: \$${orders[index].total}'),
      ),
    );
  }
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
