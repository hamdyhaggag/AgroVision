import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import '../../../models/disease_model.dart';
import '../../../shared/widgets/custom_appbar.dart';
import '../../../core/themes/app_colors.dart';

class DiseaseDetectionScreen extends StatefulWidget {
  const DiseaseDetectionScreen({super.key});

  @override
  State<DiseaseDetectionScreen> createState() => _DiseaseDetectionScreenState();
}

class _DiseaseDetectionScreenState extends State<DiseaseDetectionScreen> {
  late Future<List<DiseaseModel>> _diseaseFuture;

  Future<List<DiseaseModel>> fetchDiseases() async {
    final response = await Dio()
        .get('https://api.example.com/diseases'); // Replace with your API URL.
    if (response.statusCode == 200) {
      return (response.data as List)
          .map((json) => DiseaseModel.fromJson(json))
          .toList();
    } else {
      throw Exception('Failed to load diseases');
    }
  }

  @override
  void initState() {
    super.initState();
    _diseaseFuture = fetchDiseases();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        title: 'Reports',
        isHome: true,
      ),
      body: FutureBuilder<List<DiseaseModel>>(
        future: _diseaseFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Text('No diseases found.'),
            );
          } else {
            final diseases = snapshot.data!;
            return ListView.builder(
              itemCount: diseases.length,
              itemBuilder: (context, index) {
                final disease = diseases[index];
                return Card(
                  elevation: 0,
                  margin:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 150,
                          height: 115,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: NetworkImage(disease.imageUrl),
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                disease.date,
                                style: TextStyle(
                                  fontFamily: 'SYNE',
                                  fontWeight: FontWeight.w500,
                                  fontSize: 15,
                                  color: AppColors.blackColor,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                disease.status,
                                style: TextStyle(
                                  fontFamily: 'SYNE',
                                  fontWeight: FontWeight.w500,
                                  fontSize: 15,
                                  color: AppColors.blackColor,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Chip(
                                elevation: 0,
                                label: Text(
                                  disease.isComplete
                                      ? "Complete"
                                      : "Incomplete",
                                  style: TextStyle(
                                    fontFamily: 'SYNE',
                                    fontWeight: FontWeight.w500,
                                    fontSize: 13,
                                    color: disease.isComplete
                                        ? Colors.green
                                        : Colors.red,
                                  ),
                                ),
                                backgroundColor: disease.isComplete
                                    ? AppColors.completeColor
                                    : AppColors.inCompleteColor,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                  side: const BorderSide(
                                    color: Colors.transparent,
                                    width: 1,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const Icon(Icons.chevron_right_rounded),
                      ],
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
