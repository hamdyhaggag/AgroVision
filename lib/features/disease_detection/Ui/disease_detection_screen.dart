import 'package:agro_vision/core/themes/app_colors.dart';
import 'package:flutter/material.dart';
import '../../../core/themes/text_styles.dart';
import '../../../models/disease_model.dart';
import '../../../shared/widgets/custom_appbar.dart';

class DiseaseDetectionScreen extends StatelessWidget {
  final List<DiseaseModel> diseases = [
    DiseaseModel(
      date: "23 Jan",
      status: "Healthy",
      isComplete: true,
      imageUrl: "assets/images/cotton.png",
    ),
    DiseaseModel(
      date: "22 Jan",
      status: "Healthy",
      isComplete: true,
      imageUrl: "assets/images/wheat.png",
    ),
    DiseaseModel(
      date: "21 Jan",
      status: "Not Healthy",
      isComplete: false,
      imageUrl: "assets/images/pests.png",
    ),
    DiseaseModel(
      date: "20 Jan",
      status: "Harmful",
      isComplete: false,
      imageUrl: "assets/images/cane.png",
    ),
  ];

  DiseaseDetectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        title: 'Reports',
        isHome: true,
      ),
      body: ListView.builder(
        itemCount: diseases.length,
        itemBuilder: (context, index) {
          final disease = diseases[index];
          return Card(
            elevation: 0,
            color: Colors.white,
            margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
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
                        image: AssetImage(disease.imageUrl),
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  // Text Section
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
                            disease.isComplete ? "Complete" : "Incomplete",
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
      ),
    );
  }
}
