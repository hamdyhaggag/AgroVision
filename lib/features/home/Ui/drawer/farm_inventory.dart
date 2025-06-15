import 'package:agro_vision/features/home/Ui/drawer/widgets/edit_crop_dialog.dart';
import 'package:agro_vision/shared/widgets/custom_appbar.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:lottie/lottie.dart';
import 'package:shimmer/shimmer.dart';
import '../../../../core/helpers/cache_helper.dart';
import '../../../../core/network/api_service.dart';
import '../../../../core/network/dio_factory.dart';
import '../../../../core/themes/app_colors.dart';
import '../../../../models/category_model.dart';

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

class EmptyStateWidget extends StatelessWidget {
  const EmptyStateWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Lottie.asset(
            'assets/animations/empty_crops.json',
            width: 250,
            height: 250,
          ),
          const SizedBox(height: 24),
          const Text(
            'No Crops Found',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              fontFamily: 'SYNE',
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'You haven\'t added any crops to your inventory yet.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              color: AppColors.textSecondary,
              fontFamily: 'SYNE',
            ),
          ),
        ],
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
  List<Category> categories = [];
  bool isLoading = true;
  String? errorMessage;
  late final ApiService _apiService;

  @override
  void initState() {
    super.initState();
    final dio = DioFactory.getAgrovisionDio();
    _apiService = ApiService(dio);
    _loadData();
  }

  Future<void> _loadData() async {
    try {
      final categoriesResponse = await _apiService.getCategories();
      final userId = CacheHelper.getInt('userId');
      final cropsResponse = await _apiService.getUserCrops(userId);

      setState(() {
        categories = categoriesResponse.data.categories;
        inventoryItems = cropsResponse.data.crops.map((crop) {
          final cleanCropCategory = crop.productCategory.trim().toLowerCase();
          final matchedCategory = categories.firstWhere(
            (c) {
              final apiCategory = c.name.trim().toLowerCase();
              return cleanCropCategory == apiCategory ||
                  (apiCategory.endsWith('s') &&
                      cleanCropCategory ==
                          apiCategory.substring(0, apiCategory.length - 1)) ||
                  (cleanCropCategory.endsWith('s') &&
                      apiCategory ==
                          cleanCropCategory.substring(
                              0, cleanCropCategory.length - 1));
            },
            orElse: () => Category(id: -1, name: crop.productCategory),
          );

          if (matchedCategory.id == -1) {
            debugPrint('Category not found: ${crop.productCategory}');
          }

          return InventoryItem(
            id: crop.id,
            userId: crop.userId,
            imageUrl: crop.photo != null
                ? 'https://final.agrovision.ltd/storage/app/public/photos/${crop.photo}'
                : 'https://example.com/placeholder.png',
            productName: crop.productName,
            category: matchedCategory.name,
            categoryId: matchedCategory.id,
            price: '${crop.pricePerKilo} EGP',
            quantity: '${crop.quantity} Kg',
            status: crop.status.isNotEmpty ? crop.status : 'Unknown',
          );
        }).toList();
        isLoading = false;
      });
    } on DioException catch (e) {
      setState(() {
        isLoading = false;
        if (e.response?.statusCode == 404) {
          errorMessage = null; // Clear error message for 404 case
          inventoryItems = []; // Clear inventory items
        } else {
          errorMessage = _mapDioErrorToMessage(e);
        }
      });
    } catch (e) {
      setState(() {
        isLoading = false;
        errorMessage = 'An unexpected error occurred. Please try again later.';
      });
    }
  }

  String _mapDioErrorToMessage(DioException e) {
    if (e.response?.statusCode == 401) {
      return 'Your session has expired. Please log in again.';
    } else if (e.response?.statusCode == 403) {
      return 'You don\'t have permission to access this resource.';
    } else if (e.response?.statusCode == 500) {
      return 'Server error. Please try again later.';
    } else if (e.response?.statusCode == 502) {
      return 'Service temporarily unavailable. Please try again later.';
    } else if (e.response?.statusCode == 503) {
      return 'Service is currently down for maintenance.';
    } else if (e.type == DioExceptionType.connectionTimeout ||
        e.type == DioExceptionType.receiveTimeout ||
        e.type == DioExceptionType.sendTimeout) {
      return 'Connection timed out. Please check your internet connection.';
    } else if (e.type == DioExceptionType.connectionError) {
      return 'No internet connection. Please check your network settings.';
    } else if (e.response?.data != null &&
        e.response?.data['message'] != null) {
      return e.response!.data['message'];
    } else {
      return 'An error occurred. Please try again later.';
    }
  }

  String _mapStatusToDisplay(String status) {
    switch (status.toLowerCase()) {
      case 'instock':
        return 'In Stock';
      case 'outofstock':
        return 'Out of Stock';
      case 'lowstock':
        return 'Low Stock';
      default:
        return 'In Stock';
    }
  }

  void _postItem(InventoryItem item) async {
    try {
      if (item.categoryId == -1) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Invalid Category'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('"${item.category}" is not a valid category.'),
                const SizedBox(height: 16),
                const Text('Valid categories:'),
                ...categories.map((c) => Text('- ${c.name.trim()}')),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('OK'),
              ),
            ],
          ),
        );
        return;
      }

      final response = await _apiService.addProductFromCrop({
        'crop_id': item.id,
        'product_name': item.productName,
        'price': double.parse(item.price.replaceAll(' EGP', '')),
        'quantity': int.parse(item.quantity.replaceAll(' Kg', '')),
        'category_id': item.categoryId,
        'description': '',
      });

      if (response.response.statusCode == 201) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Product listed successfully!'),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 2),
          ),
        );
      }
    } on DioException catch (e) {
      String message = 'Posting failed';
      Color color = Colors.red;

      if (e.response?.statusCode == 409) {
        // Show dialog with existing product details
        final existingProduct = e.response?.data['existing_product'];
        if (existingProduct != null) {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text('Product Already Exists'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                      'This product is already listed in the marketplace:'),
                  const SizedBox(height: 16),
                  Text('Name: ${existingProduct['name']}'),
                  Text('Price: ${existingProduct['price']} EGP'),
                  Text('Quantity: ${existingProduct['quantity']} Kg'),
                  Text('Status: ${existingProduct['stock_status']}'),
                  const SizedBox(height: 8),
                  const Text(
                    'Would you like to update the existing product instead?',
                    style: TextStyle(fontWeight: FontWeight.bold),
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
                    Navigator.pop(context);
                    // Create an InventoryItem from the existing product data
                    final existingItem = InventoryItem(
                      id: existingProduct['crop_id'],
                      userId: existingProduct['farmer_id'],
                      imageUrl: existingProduct['images'] != null
                          ? 'https://final.agrovision.ltd/storage/app/public/${existingProduct['images']}'
                          : 'https://example.com/placeholder.png',
                      productName: existingProduct['name'],
                      category: categories
                          .firstWhere(
                            (c) => c.id == existingProduct['category_id'],
                            orElse: () => Category(id: -1, name: 'Unknown'),
                          )
                          .name,
                      categoryId: existingProduct['category_id'],
                      price: '${existingProduct['price']} EGP',
                      quantity: '${existingProduct['quantity']} Kg',
                      status:
                          _mapStatusToDisplay(existingProduct['stock_status']),
                    );
                    _editItem(context, existingItem);
                  },
                  child: const Text('Update Existing'),
                ),
              ],
            ),
          );
          return;
        }
      } else if (e.response?.statusCode == 400) {
        final error = e.response?.data['error']?.toString() ?? '';
        message = error.contains('المنتج موجود بالفعل')
            ? 'Product already exists in marketplace'
            : 'Invalid request: ${error.isNotEmpty ? error : "Unknown error"}';
      } else if (e.response?.statusCode == 302) {
        message = 'Server configuration error - Contact support';
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: color,
          duration: const Duration(seconds: 3),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Unexpected error occurred'),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 3),
        ),
      );
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
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.error_outline, size: 48, color: Colors.red.shade300),
              const SizedBox(height: 16),
              Text(
                errorMessage!,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 16,
                  color: AppColors.textPrimary,
                  fontFamily: 'SYNE',
                ),
              ),
            ],
          ),
        ),
      );
    }
    if (inventoryItems.isEmpty) {
      return const EmptyStateWidget();
    }
    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
      itemCount: inventoryItems.length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (context, index) => InventoryCard(
        item: inventoryItems[index],
        onEdit: () => _editItem(context, inventoryItems[index]),
        onDelete: () => _deleteItem(inventoryItems[index].id),
        onPost: () => _postItem(inventoryItems[index]),
      ),
    );
  }

  void _editItem(BuildContext context, InventoryItem item) async {
    final didSave = await showDialog<bool>(
      context: context,
      builder: (context) => EditCropDialog(
        item: item,
        categories: categories,
        onSave: (formData) => _handleUpdateCrop(item, formData),
      ),
    );

    if (didSave == true) {
      _loadData();
    }
  }

  Future<bool> _handleUpdateCrop(
      InventoryItem item, Map<String, dynamic> formData) async {
    try {
      final response = await _apiService.updateCrop(item.id, formData);
      final updatedCrop = response.data.crop;

      final category = categories.firstWhere(
        (c) => c.name == updatedCrop.productCategory,
        orElse: () => Category(id: -1, name: updatedCrop.productCategory),
      );

      setState(() {
        final index = inventoryItems.indexWhere((i) => i.id == item.id);
        if (index != -1) {
          final photo = updatedCrop.photo;
          inventoryItems[index] = InventoryItem(
            userId: item.userId,
            id: updatedCrop.id,
            imageUrl: photo != null && photo.isNotEmpty
                ? 'https://final.agrovision.ltd/storage/app/public/photos/$photo'
                : 'https://example.com/placeholder.png',
            productName: updatedCrop.productName,
            category: category.name,
            categoryId: category.id,
            price: '${updatedCrop.pricePerKilo} EGP',
            quantity: '${updatedCrop.quantity} Kg',
            status: updatedCrop.status,
          );
        }
      });
      return true;
    } on DioException catch (e) {
      String message = 'Update failed';
      if (e.response?.statusCode == 302) {
        message = 'Session expired. Please log in again.';
      } else if (e.response?.data != null &&
          e.response?.data['message'] != null) {
        message = e.response!.data['message'];
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message)),
      );
      return false;
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('An unexpected error occurred: $e')),
      );
      return false;
    }
  }

  void _deleteItem(int cropId) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirm Delete'),
        content: const Text('Are you sure you want to delete this item?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirmed != true) return;
    try {
      await _apiService.deleteCrop(cropId);
      setState(() {
        inventoryItems.removeWhere((item) => item.id == cropId);
      });
    } on DioException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content:
              Text('Delete failed: ${e.response?.data['message'] ?? 'Error'}'),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to delete item')),
      );
    }
  }
}

class InventoryCard extends StatelessWidget {
  final InventoryItem item;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final VoidCallback onPost;

  const InventoryCard({
    super.key,
    required this.item,
    required this.onEdit,
    required this.onDelete,
    required this.onPost,
  });

  @override
  Widget build(BuildContext context) {
    final statusColor = item.status == 'In Stock'
        ? AppColors.primaryColor
        : item.status == 'Out of Stock'
            ? AppColors.errorColor
            : AppColors.successColor;
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
                                style: TextStyle(fontFamily: 'SYNE')),
                          ),
                          PopupMenuItem(
                            onTap: onPost,
                            child: const Text('Post on Market',
                                style: TextStyle(fontFamily: 'SYNE')),
                          ),
                          PopupMenuItem(
                            onTap: onDelete,
                            child: const Text('Delete',
                                style: TextStyle(
                                    color: Colors.red, fontFamily: 'SYNE')),
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
                          assetName: 'assets/icon/money.svg',
                          value: item.price),
                      const SizedBox(width: 24),
                      _buildDetailItem(
                          assetName: 'assets/icon/weight.svg',
                          value: item.quantity),
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

  Widget _buildDetailItem({
    IconData? icon,
    String? assetName,
    required String value,
  }) {
    final bool hasIcon = assetName != null || icon != null;

    return Row(
      children: [
        if (assetName != null) ...[
          SvgPicture.asset(
            assetName,
            width: 18,
            height: 18,
            colorFilter: const ColorFilter.mode(
                AppColors.textSecondary, BlendMode.srcIn),
          ),
        ] else if (icon != null) ...[
          Icon(
            icon,
            size: 18,
            color: AppColors.textSecondary,
          ),
        ],
        if (hasIcon) const SizedBox(width: 6),
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
  final int id;
  final String imageUrl;
  final String productName;
  final String category;
  final int categoryId;
  final String price;
  final String quantity;
  final String status;
  final int userId;

  InventoryItem({
    required this.id,
    required this.userId,
    required this.imageUrl,
    required this.productName,
    required this.category,
    required this.categoryId,
    required this.price,
    required this.quantity,
    required this.status,
  });
}
