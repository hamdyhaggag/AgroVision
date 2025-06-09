import 'package:flutter/material.dart';

class OrderAnalyticsData {
  final int totalOrders;
  final double totalSales;
  final StatusCounts statusCounts;
  final List<MonthlySale> monthlySales;
  final List<LatestOrder> latestOrders;
  final List<Client> clients;

  OrderAnalyticsData({
    required this.totalOrders,
    required this.totalSales,
    required this.statusCounts,
    required this.monthlySales,
    required this.latestOrders,
    required this.clients,
  });

  factory OrderAnalyticsData.fromJson(Map<String, dynamic> json) {
    return OrderAnalyticsData(
      totalOrders: json['total_orders'] as int,
      totalSales: json['total_sales'] is int
          ? (json['total_sales'] as int).toDouble()
          : json['total_sales'] as double,
      statusCounts:
          StatusCounts.fromJson(json['status_counts'] as Map<String, dynamic>),
      monthlySales: (json['monthly_sales'] as List<dynamic>)
          .map((e) => MonthlySale.fromJson(e as Map<String, dynamic>))
          .toList(),
      latestOrders: (json['latest_orders'] as List<dynamic>)
          .map((e) => LatestOrder.fromJson(e as Map<String, dynamic>))
          .toList(),
      clients: (json['clients'] as List<dynamic>)
          .map((e) => Client.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}

class StatusCounts {
  final int pending;
  final int delivered;
  final int canceled;

  StatusCounts({
    required this.pending,
    required this.delivered,
    required this.canceled,
  });

  factory StatusCounts.fromJson(Map<String, dynamic> json) {
    return StatusCounts(
      pending: json['pending'] as int,
      delivered: json['delivered'] as int,
      canceled: json['canceled'] as int,
    );
  }
}

class MonthlySale {
  final String month;
  final double total;

  MonthlySale({required this.month, required this.total});

  factory MonthlySale.fromJson(Map<String, dynamic> json) {
    return MonthlySale(
      month: json['month'] as String,
      total: json['total'] is int
          ? (json['total'] as int).toDouble()
          : json['total'] as double,
    );
  }
}

class LatestOrder {
  final int orderId;
  final String customer;
  final double amount;
  final String createdAt;

  LatestOrder({
    required this.orderId,
    required this.customer,
    required this.amount,
    required this.createdAt,
  });

  factory LatestOrder.fromJson(Map<String, dynamic> json) {
    return LatestOrder(
      orderId: json['order_id'] as int,
      customer: json['customer'] as String,
      amount: json['amount'] is int
          ? (json['amount'] as int).toDouble()
          : json['amount'] as double,
      createdAt: json['created_at'] as String,
    );
  }
}

class Client {
  final String name;
  final String phone;
  final int ordersCount;

  Client({
    required this.name,
    required this.phone,
    required this.ordersCount,
  });

  factory Client.fromJson(Map<String, dynamic> json) {
    return Client(
      name: json['name'] as String,
      phone: json['phone'] as String,
      ordersCount: json['orders_count'] as int,
    );
  }
}
