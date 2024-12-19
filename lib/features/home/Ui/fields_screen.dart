import 'package:flutter/material.dart';
import '../../../shared/widgets/custom_appbar.dart';
import '../../monitoring/UI/sensor_data_screen.dart';

class FieldsScreen extends StatelessWidget {
  final List<Map<String, String>> fields;

  const FieldsScreen({super.key, required this.fields});

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: const CustomAppBar(
        title: 'My Fields',
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: fields.length,
        itemBuilder: (context, index) {
          final field = fields[index];

          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SensorDataScreen(
                    field: field, // Pass the actual field data
                  ),
                ),
              );
            },
            child: Card(
              color: Colors.white, // White background for clean look
              elevation: 5, // Subtle shadow for depth
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12), // Rounded corners
              ),
              margin: const EdgeInsets.only(bottom: 16), // Space between cards
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Column(
                  children: [
                    // Image Section
                    ClipRRect(
                      borderRadius:
                          const BorderRadius.vertical(top: Radius.circular(12)),
                      child: Image.asset(
                        field['image']!,
                        fit: BoxFit.cover,
                        width: double.infinity,
                        height: screenWidth < 600
                            ? 150
                            : 200, // Adjust height based on screen size
                      ),
                    ),
                    // Information Section
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Field name (larger and bold)
                          Text(
                            field['name']!,
                            style: TextStyle(
                              fontSize: screenWidth < 600 ? 18 : 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis, // Handle overflow
                          ),
                          const SizedBox(height: 8),
                          // Field size and type (smaller text)
                          Text(
                            "${field['size']} • ${field['type']}",
                            style: TextStyle(
                              fontSize: screenWidth < 600 ? 12 : 14,
                              color: Colors.grey[700], // Softer grey text
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
