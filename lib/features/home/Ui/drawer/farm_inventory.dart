import 'package:agro_vision/shared/widgets/custom_appbar.dart';
import 'package:flutter/material.dart';
import '../../../../core/themes/app_colors.dart';
import 'add_new_product.dart';

class FarmInventoryScreen extends StatefulWidget {
  const FarmInventoryScreen({super.key});

  @override
  State<FarmInventoryScreen> createState() => _FarmInventoryScreenState();
}

class _FarmInventoryScreenState extends State<FarmInventoryScreen> {
  final List<InventoryItem> inventoryItems = [
    InventoryItem(
      imageUrl: 'https://images.unsplash.com/photo-1580939798894-28b2df78fdc6',
      productName: 'Potato | EG',
      category: 'Vegetable',
      price: '8 EGP',
      quantity: '45 Kg',
      status: 'In Stock',
    ),
    InventoryItem(
      imageUrl: 'https://images.unsplash.com/photo-1588252181028-fcb92a68ac66',
      productName: 'Tomato | EG',
      category: 'Vegetable',
      price: '12 EGP',
      quantity: '7 Kg',
      status: 'Out of Stock',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'Farm Inventory'),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 20, 16, 12),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search inventory...',
                hintStyle:
                    TextStyle(color: Colors.grey.shade500, fontFamily: 'SYNE'),
                prefixIcon: Icon(Icons.search, color: Colors.grey.shade600),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(
                      color: AppColors.primaryColor, width: 1.5),
                ),
                contentPadding: const EdgeInsets.symmetric(vertical: 16),
              ),
            ),
          ),
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
              itemCount: inventoryItems.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (context, index) => InventoryCard(
                item: inventoryItems[index],
                onEdit: () => _editItem(context, inventoryItems[index]),
                onDelete: () => _deleteItem(index),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryColor,
                foregroundColor: Colors.white,
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
              ),
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => AddNewProduct(),
                ),
              ),
              child: const Text(
                'Add New Order',
                style: TextStyle(fontFamily: 'SYNE'),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _editItem(BuildContext context, InventoryItem item) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text(
          'Edit Item',
          style: TextStyle(fontFamily: 'SYNE'),
        ),
        content: const Text(
          'Edit functionality implementation',
          style: TextStyle(fontFamily: 'SYNE'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'Close',
              style: TextStyle(fontFamily: 'SYNE'),
            ),
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
                            child: const Text(
                              'Edit',
                              style: TextStyle(fontFamily: 'SYNE'),
                            ),
                            onTap: onEdit,
                          ),
                          PopupMenuItem(
                            child: const Text(
                              'Delete',
                              style: TextStyle(
                                  color: Colors.red, fontFamily: 'SYNE'),
                            ),
                            onTap: onDelete,
                          ),
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
                        icon: Icons.price_change_outlined,
                        value: item.price,
                      ),
                      const SizedBox(width: 24),
                      _buildDetailItem(
                        icon: Icons.scale_outlined,
                        value: item.quantity,
                      ),
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
