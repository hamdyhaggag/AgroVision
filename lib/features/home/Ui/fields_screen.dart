import 'package:flutter/material.dart';

import '../../../shared/widgets/custom_appbar.dart';

class FieldsScreen extends StatelessWidget {
  final List<Map<String, String>> fields;

  const FieldsScreen({super.key, required this.fields});

  @override
  Widget build(BuildContext context) {
    // Use MediaQuery to get screen width for responsiveness
    double screenWidth = MediaQuery.of(context).size.width;

    // Determine the number of columns based on screen size
    int crossAxisCount = screenWidth < 600
        ? 2
        : screenWidth < 1200
            ? 3
            : 4;

    return Scaffold(
      appBar: const CustomAppBar(
        title: 'My Fields',
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(16.0),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount:
              crossAxisCount, // Responsive columns based on screen size
          mainAxisSpacing: 16.0,
          crossAxisSpacing: 16.0,
          childAspectRatio: screenWidth < 600
              ? 0.7
              : 0.8, // Adjust aspect ratio for small screens
        ),
        itemCount: fields.length,
        itemBuilder: (context, index) {
          final field = fields[index];
          return Card(
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Column(
                children: [
                  ClipRRect(
                    borderRadius:
                        BorderRadius.vertical(top: Radius.circular(16)),
                    child: Image.asset(
                      field['image']!,
                      fit: BoxFit.cover,
                      height: screenWidth < 600
                          ? 150
                          : 180, // Adjust image height for small screens
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          field['name']!,
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: screenWidth < 600
                                ? 16
                                : 18, // Font size adjustment
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          "${field['size']} • ${field['type']}",
                          style: TextStyle(
                            fontWeight: FontWeight.w400,
                            color: Colors.grey,
                            fontSize: screenWidth < 600
                                ? 12
                                : 14, // Font size adjustment
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
