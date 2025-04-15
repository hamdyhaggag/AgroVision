import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../models/api_order.dart';

part 'orders_state.freezed.dart';

@freezed
class OrdersState with _$OrdersState {
  const factory OrdersState.initial() = _Initial;
  const factory OrdersState.loading() = _Loading;
  const factory OrdersState.loaded(List<ApiOrder> orders) = _Loaded;
  const factory OrdersState.error(String message) = _Error;
}
