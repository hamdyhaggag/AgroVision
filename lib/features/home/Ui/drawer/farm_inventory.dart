import 'package:agro_vision/shared/widgets/custom_appbar.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import '../../../../core/helpers/cache_helper.dart';
import '../../../../core/network/api_service.dart';
import '../../../../core/network/dio_factory.dart';
import '../../../../core/themes/app_colors.dart';

class InventoryCardShimmer extends StatelessWidget {
  const InventoryCardShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 6),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withValues(alpha: 0.08),
              spreadRadius: 2,
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                      width: double.infinity,
                      height: 16,
                      color: Colors.grey.shade300),
                  const SizedBox(height: 8),
                  Container(width: 80, height: 12, color: Colors.grey.shade300),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Container(
                          width: 60, height: 14, color: Colors.grey.shade300),
                      const SizedBox(width: 24),
                      Container(
                          width: 60, height: 14, color: Colors.grey.shade300),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Container(
                        width: 60, height: 20, color: Colors.grey.shade300),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class FarmInventoryScreen extends StatefulWidget {
  const FarmInventoryScreen({super.key});

  @override
  State<FarmInventoryScreen> createState() => _FarmInventoryScreenState();
}

class _FarmInventoryScreenState extends State<FarmInventoryScreen> {
  List<InventoryItem> inventoryItems = [];
  bool isLoading = true;
  String? errorMessage;
  late final ApiService _apiService;

  @override
  void initState() {
    super.initState();
    final dio = DioFactory.getAgrovisionDio();
    _apiService = ApiService(dio);
    _fetchCrops();
  }

  Future<void> _fetchCrops() async {
    try {
      final userId = CacheHelper.getInt('userId');
      final response = await _apiService.getUserCrops(userId);
      final crops = response.data.crops;
      setState(() {
        inventoryItems = crops
            .map((crop) => InventoryItem(
                  imageUrl: crop.photo != null
                      ? 'https://final.agrovision.ltd/storage/app/public/photos/${crop.photo}'
                      : 'https://example.com/placeholder.png',
                  productName: crop.productName,
                  category: crop.productCategory,
                  price: '${crop.pricePerKilo} EGP',
                  quantity: '${crop.quantity} Kg',
                  status: crop.status.isNotEmpty ? crop.status : 'Unknown',
                ))
            .toList();
        isLoading = false;
        errorMessage = null;
      });
    } on DioException catch (e) {
      setState(() {
        isLoading = false;
        if (e.response?.statusCode == 404 &&
            e.response?.data['message'] == 'No Crop found for this user.') {
          inventoryItems = [];
          errorMessage = 'You haven’t added any products yet.';
        } else {
          errorMessage = 'Unable to load inventory. Please try again.';
        }
      });
    } catch (e) {
      setState(() {
        isLoading = false;
        errorMessage = 'An unexpected error occurred.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'Farm Inventory'),
      body: Column(
        children: [
          Expanded(child: _buildBody()),
        ],
      ),
    );
  }

  Widget _buildBody() {
    if (isLoading) {
      return ListView.builder(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
        itemCount: 5,
        itemBuilder: (context, index) => const InventoryCardShimmer(),
      );
    }
    if (errorMessage != null) {
      return Center(child: Text(errorMessage!));
    }
    if (inventoryItems.isEmpty) {
      return const Center(child: Text('No crops available.'));
    }
    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
      itemCount: inventoryItems.length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (context, index) => InventoryCard(
        item: inventoryItems[index],
        onEdit: () => _editItem(context, inventoryItems[index]),
        onDelete: () => _deleteItem(index),
      ),
    );
  }

  void _editItem(BuildContext context, InventoryItem item) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Edit Item', style: TextStyle(fontFamily: 'SYNE')),
        content: const Text('Edit functionality implementation',
            style: TextStyle(fontFamily: 'SYNE')),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close', style: TextStyle(fontFamily: 'SYNE')),
          ),
        ],
      ),
    );
  }

  void _deleteItem(int index) {
    setState(() => inventoryItems.removeAt(index));
  }
}

class InventoryCard extends StatelessWidget {
  final InventoryItem item;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const InventoryCard({
    super.key,
    required this.item,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final statusColor = item.status == 'In Stock'
        ? AppColors.successColor
        : AppColors.errorColor;
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.08),
            spreadRadius: 2,
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: Colors.grey.shade50,
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  item.imageUrl,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Center(
                    child: Icon(Icons.image_not_supported,
                        color: Colors.grey.shade400),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              item.productName,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                fontFamily: 'SYNE',
                                color: AppColors.textPrimary,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              item.category.toUpperCase(),
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                                color: AppColors.textSecondary,
                                letterSpacing: 0.8,
                              ),
                            ),
                          ],
                        ),
                      ),
                      PopupMenuButton(
                        itemBuilder: (context) => [
                          PopupMenuItem(
                              onTap: onEdit,
                              child: const Text('Edit',
                                  style: TextStyle(fontFamily: 'SYNE'))),
                          PopupMenuItem(
                              onTap: onDelete,
                              child: const Text('Delete',
                                  style: TextStyle(
                                      color: Colors.red, fontFamily: 'SYNE'))),
                        ],
                        icon:
                            Icon(Icons.more_vert, color: Colors.grey.shade600),
                      )
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      _buildDetailItem(
                          icon: Icons.price_change_outlined, value: item.price),
                      const SizedBox(width: 24),
                      _buildDetailItem(
                          icon: Icons.scale_outlined, value: item.quantity),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: statusColor.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          item.status == 'In Stock'
                              ? Icons.check_circle_outline
                              : Icons.highlight_off_outlined,
                          size: 16,
                          color: statusColor,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          item.status,
                          style: TextStyle(
                            color: statusColor,
                            fontWeight: FontWeight.w600,
                            fontSize: 12,
                            fontFamily: 'SYNE',
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailItem({required IconData icon, required String value}) {
    return Row(
      children: [
        Icon(icon, size: 18, color: AppColors.textSecondary),
        const SizedBox(width: 6),
        Text(
          value,
          style: const TextStyle(
            fontFamily: 'SYNE',
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: AppColors.textPrimary,
          ),
        ),
      ],
    );
  }
}

class InventoryItem {
  final String imageUrl;
  final String productName;
  final String category;
  final String price;
  final String quantity;
  final String status;

  InventoryItem({
    required this.imageUrl,
    required this.productName,
    required this.category,
    required this.price,
    required this.quantity,
    required this.status,
  });
}
