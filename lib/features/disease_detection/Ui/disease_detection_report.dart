import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:agro_vision/core/themes/app_colors.dart';
import '../../../models/disease_model.dart';
import '../../../shared/widgets/custom_appbar.dart';

class DiseaseDetectionReports extends StatefulWidget {
  const DiseaseDetectionReports({super.key});

  @override
  State<DiseaseDetectionReports> createState() =>
      _DiseaseDetectionReportsState();
}

class _DiseaseDetectionReportsState extends State<DiseaseDetectionReports> {
  List<DiseaseModel> diseases = [];
  Set<int> selectedReports = {}; // To track selected reports
  bool isSelectionMode = false; // Track if selection mode is active

  @override
  void initState() {
    super.initState();
    _loadReports();
  }

  Future<void> _loadReports() async {
    final prefs = await SharedPreferences.getInstance();
    final reportStrings = prefs.getStringList('diseaseReports') ?? [];
    final loadedReports = reportStrings
        .map((report) => DiseaseModel.fromJson(jsonDecode(report)))
        .toList();

    setState(() {
      diseases = loadedReports;
    });
  }

  Future<void> _deleteSelectedReports() async {
    final prefs = await SharedPreferences.getInstance();

    final deletedReports =
        selectedReports.map((index) => diseases[index]).toList();

    setState(() {
      diseases = diseases
          .asMap()
          .entries
          .where((entry) => !selectedReports.contains(entry.key))
          .map((entry) => entry.value)
          .toList();
      selectedReports.clear();
      isSelectionMode = false;
    });

    final updatedReports =
        diseases.map((report) => jsonEncode(report.toJson())).toList();
    await prefs.setStringList('diseaseReports', updatedReports);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Reports deleted.'),
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(10),
        duration: const Duration(seconds: 5),
        action: SnackBarAction(
          label: 'Undo',
          onPressed: () async {
            setState(() {
              diseases.addAll(deletedReports);
            });

            final restoredReports =
                diseases.map((report) => jsonEncode(report.toJson())).toList();
            await prefs.setStringList('diseaseReports', restoredReports);
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Reports',
        isHome: true,
        actions: [
          if (isSelectionMode)
            IconButton(
              icon: const Icon(Icons.delete),
              onPressed: _deleteSelectedReports,
            ),
        ],
      ),
      body: diseases.isEmpty
          ? const Center(
              child: Text(
                'No reports available.',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            )
          : ListView.builder(
              itemCount: diseases.length,
              itemBuilder: (context, index) {
                final disease = diseases[index];
                final isSelected = selectedReports.contains(index);

                return GestureDetector(
                  onLongPress: () {
                    setState(() {
                      isSelectionMode = true;
                    });
                  },
                  onTap: () {
                    if (isSelectionMode) {
                      setState(() {
                        if (isSelected) {
                          selectedReports.remove(index);
                        } else {
                          selectedReports.add(index);
                        }
                      });
                    }
                  },
                  child: Card(
                    elevation: 0,
                    color: isSelected ? Colors.grey[300] : Colors.white,
                    margin:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (isSelectionMode)
                            Checkbox(
                              value: isSelected,
                              activeColor: AppColors.primaryColor,
                              onChanged: (value) {
                                setState(() {
                                  if (value == true) {
                                    selectedReports.add(index);
                                  } else {
                                    selectedReports.remove(index);
                                  }
                                });
                              },
                            ),
                          // Image Section
                          Container(
                            width: 100,
                            height: 100,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              image: DecorationImage(
                                image: _getImageProvider(disease.imageUrl),
                                fit: BoxFit.cover,
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
                  ),
                );
              },
            ),
    );
  }

  /// Returns the correct ImageProvider based on whether the path is a file or an asset.
  ImageProvider _getImageProvider(String path) {
    if (File(path).existsSync()) {
      return FileImage(File(path));
    } else {
      return AssetImage(path);
    }
  }
}
