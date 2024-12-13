import 'package:flutter/material.dart';
import 'package:agro_vision/shared/widgets/custom_appbar.dart';
import 'package:flutter_svg/svg.dart';
import '../../../../core/themes/app_colors.dart';
import 'edit_product_screen.dart';

class FarmInventoryScreen extends StatefulWidget {
  const FarmInventoryScreen({super.key});

  @override
  FarmInventoryScreenState createState() => FarmInventoryScreenState();
}

class FarmInventoryScreenState extends State<FarmInventoryScreen> {
  List<Map<String, dynamic>> products = [
    {
      'productName': 'Tomato | EG',
      'category': 'vegetable',
      'price': '12 EGP',
      'weight': '72 Kilo',
      'inStock': true,
      'image': 'assets/images/tomato.jpg',
    },
    {
      'productName': 'Potato | EG',
      'category': 'vegetable',
      'price': '8 EGP',
      'weight': '72 Kilo',
      'inStock': false,
      'image': 'assets/images/potato.jpeg',
    },
  ];

  List<Map<String, dynamic>> filteredProducts = [];
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    filteredProducts = products;
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _filterProducts(String query) {
    final filtered = products.where((product) {
      final productName = product['productName'].toLowerCase();
      return productName.contains(query.toLowerCase());
    }).toList();

    setState(() {
      filteredProducts = filtered;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'Farm Inventory'),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildSearchBar(),
            const SizedBox(height: 16.0),
            Expanded(child: _buildProductList()),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return TextField(
      controller: _searchController,
      onChanged: _filterProducts,
      decoration: InputDecoration(
        hintText: 'Search product name',
        prefixIcon: const Icon(Icons.search, color: AppColors.primaryColor),
        suffixIcon: _searchController.text.isNotEmpty
            ? IconButton(
                icon: const Icon(Icons.clear, color: AppColors.primaryColor),
                onPressed: () {
                  _searchController.clear();
                  _filterProducts('');
                },
              )
            : null,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide: const BorderSide(color: Colors.green, width: 1),
        ),
      ),
    );
  }

  Widget _buildProductList() {
    return ListView.builder(
      itemCount: filteredProducts.length,
      itemBuilder: (context, index) {
        final product = filteredProducts[index];
        return _buildProductCard(product, index);
      },
    );
  }

  Widget _buildProductCard(Map<String, dynamic> product, int index) {
    return Card(
      color: Colors.green.shade50,
      elevation: 4.0,
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Expanded(
              child: Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.asset(
                      product['image'],
                      height: 120,
                      width: 120,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      // Product Name
                      Text(
                        product['productName'],
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      const SizedBox(height: 4),

                      // Category Information
                      Text(
                        'Category: ${product['category']}',
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 4),

                      // Price Information
                      Text(
                        'Price: ${product['price']}',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 4),

                      // Weight Information
                      Text(
                        'Weight: ${product['weight']}',
                        style: const TextStyle(
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 8),

                      product['inStock']
                          ? const Text(
                              'In Stock',
                              style: TextStyle(
                                color: AppColors.primaryColor,
                                fontWeight: FontWeight.bold,
                              ),
                            )
                          : const Text(
                              'Out of Stock',
                              style: TextStyle(
                                color: Colors.red,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                    ],
                  ),
                ],
              ),
            ),

            // Edit & Delete actions
            Column(
              children: [
                IconButton(
                  icon: const Icon(Icons.edit, color: AppColors.primaryColor),
                  onPressed: () =>
                      _navigateToEditScreen(context, product, index),
                ),
                IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () => _showDeleteDialog(context, index),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showDeleteDialog(BuildContext context, int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Column(
            children: [
              const Text(
                'Are you sure?',
                style: TextStyle(fontFamily: 'SYNE'),
              ),
              SvgPicture.asset(
                'assets/images/cleanup.svg',
                height: 300,
                width: 300,
              ),
            ],
          ),
          content: const Text(
            'Are you sure you want to remove this card?',
            style: TextStyle(fontFamily: 'SYNE', fontSize: 16),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text(
                'Cancel',
                style:
                    TextStyle(fontFamily: 'SYNE', color: AppColors.blackColor),
              ),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  products.removeAt(index);
                  filteredProducts = products;
                });
                Navigator.pop(context);
              },
              child: const Text('Remove',
                  style: TextStyle(color: Colors.red, fontFamily: 'SYNE')),
            ),
          ],
        );
      },
    );
  }

  void _navigateToEditScreen(
      BuildContext context, Map<String, dynamic> product, int index) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditProductScreen(
          product: product,
          index: index,
          onSave: (updatedProduct) {
            setState(() {
              products[index] = updatedProduct;
              filteredProducts =
                  products; // Ensure the filtered list stays updated
            });
          },
        ),
      ),
    );
  }
}
