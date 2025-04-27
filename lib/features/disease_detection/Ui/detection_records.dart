import 'dart:convert';
import 'dart:io';
import 'package:agro_vision/features/disease_detection/Ui/plant_details_screen.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:agro_vision/core/themes/app_colors.dart';
import '../../../models/disease_model.dart';
import 'package:intl/intl.dart';

class DetectionRecords extends StatefulWidget {
  const DetectionRecords({super.key});

  @override
  State<DetectionRecords> createState() => _DetectionRecordsState();
}

class _DetectionRecordsState extends State<DetectionRecords> {
  List<DiseaseModel> diseases = [];
  Set<int> selectedReports = {};
  bool isSelectionMode = false;

  @override
  void initState() {
    super.initState();
    _loadReports();
  }

  Future<void> _loadReports() async {
    final prefs = await SharedPreferences.getInstance();
    final reportStrings = prefs.getStringList('diseaseReports') ?? [];

    final validReports = reportStrings.where((report) {
      try {
        jsonDecode(report);
        return true;
      } catch (e) {
        return false;
      }
    }).toList();

    if (validReports.length != reportStrings.length) {
      await prefs.setStringList('diseaseReports', validReports);
    }

    final loadedReports = validReports
        .map((report) => DiseaseModel.fromJson(jsonDecode(report)))
        .toList();

    setState(() => diseases = loadedReports);
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
        content: const Text('Records have been deleted.'),
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
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () {
            if (Navigator.canPop(context)) {
              Navigator.of(context).pop();
            }
          },
        ),
        title: isSelectionMode
            ? Text('${selectedReports.length} Selected')
            : const Text(
                'Detection Records',
                style: TextStyle(
                  fontFamily: 'SYNE',
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
        actions: [
          if (isSelectionMode)
            IconButton(
              icon: const Icon(Icons.close),
              onPressed: () => setState(() {
                selectedReports.clear();
                isSelectionMode = false;
              }),
            ),
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
                'No records available.',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w300,
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
                      selectedReports.add(index);
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
                    } else {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>
                              PlantDetailsScreen.fromCachedDisease(disease),
                        ),
                      );
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
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  DateFormat('yyyy-MM-dd   hh:mm a')
                                      .format(DateTime.parse(disease.date))
                                      .toLowerCase(),
                                  style: const TextStyle(
                                    fontFamily: 'SYNE',
                                    fontWeight: FontWeight.w500,
                                    fontSize: 15,
                                    color: AppColors.blackColor,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  disease.status,
                                  style: const TextStyle(
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

  ImageProvider _getImageProvider(String path) {
    if (File(path).existsSync()) {
      return FileImage(File(path));
    } else {
      return AssetImage(path);
    }
  }
}
