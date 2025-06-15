import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../models/api_order.dart';
import '../../Api/orders_repo.dart';

abstract class OrdersState {}

class OrdersInitial extends OrdersState {}

class OrdersLoading extends OrdersState {}

class OrdersLoaded extends OrdersState {
  final List<ApiOrder> orders;
  OrdersLoaded(this.orders);
}

class OrdersError extends OrdersState {
  final String message;
  OrdersError(this.message);
}

class OrdersCubit extends Cubit<OrdersState> {
  final OrdersRepo _repo;
  OrdersCubit(this._repo) : super(OrdersInitial());

  Future<void> fetchOrders() async {
    emit(OrdersLoading());
    try {
      final result = await _repo.getUserOrders();
      result.when(
        success: (orders) => emit(OrdersLoaded(orders)),
        failure: (error) => emit(OrdersError(error.toString())),
      );
    } catch (e, stackTrace) {
      if (kDebugMode) {
        print('🔥 Unhandled Exception: $e');
      }
      if (kDebugMode) {
        print('🔥 Stack Trace: $stackTrace');
      }
      emit(OrdersError('Unexpected error: $e'));
    }
  }
}
