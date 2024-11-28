import 'package:flutter/material.dart';
import '../../features/home/Ui/fields_screen.dart';
import '../../features/monitoring/UI/field_detail_screen.dart'; // Import the field detail screen

class FieldsWidget extends StatelessWidget {
  final List<Map<String, String>> fields;

  const FieldsWidget({super.key, required this.fields});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'My Fields',
              style: TextStyle(
                fontSize: 18,
                fontFamily: 'Syne',
                fontWeight: FontWeight.bold,
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => FieldsScreen(fields: fields),
                  ),
                );
              },
              child: const Text(
                'See All',
                style: TextStyle(
                    color: Colors.grey,
                    fontWeight: FontWeight.w400,
                    fontFamily: 'SYNE'),
              ),
            ),
          ],
        ),
        SizedBox(
          height: 200,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: fields.length,
            itemBuilder: (context, index) {
              final field = fields[index];
              return SizedBox(
                  width: 170,
                  child: GestureDetector(
                    onTap: () {
                      // Navigate to the FieldDetailScreen and pass the selected field data
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => FieldDetailScreen(field: field),
                        ),
                      );
                    },
                    child: Card(
                      color: Colors.white,
                      elevation: 3,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: ClipRRect(
                              borderRadius: const BorderRadius.vertical(
                                top: Radius.circular(16),
                              ),
                              child: Image.asset(
                                field['image']!,
                                fit: BoxFit.cover,
                                width: double.infinity,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  field['name']!,
                                  style: Theme.of(context).textTheme.bodyLarge,
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  "${field['size']} • ${field['type']}",
                                  style: Theme.of(context).textTheme.bodyMedium,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ));
            },
          ),
        ),
      ],
    );
  }
}
