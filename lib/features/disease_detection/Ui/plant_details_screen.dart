import 'dart:io';
import 'dart:convert';
import 'package:agro_vision/features/chat/Ui/chat_bot_detail_screen.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:agro_vision/core/themes/app_colors.dart';
import 'package:agro_vision/core/themes/text_styles.dart';
import 'package:agro_vision/shared/widgets/custom_botton.dart';
import '../../../core/utils/functions.dart';
import '../../../models/disease_model.dart';
import '../../chat/Ui/chat_list_screen.dart';

class PlantDetailsScreen extends StatefulWidget {
  final String? imagePath;
  final String? selectedPlant;

  const PlantDetailsScreen({
    super.key,
    this.imagePath,
    this.selectedPlant,
  }) : assert(imagePath != null || selectedPlant != null,
            'Either imagePath or selectedPlant must be provided.');

  @override
  State<PlantDetailsScreen> createState() => _PlantDetailsScreenState();
}

class _PlantDetailsScreenState extends State<PlantDetailsScreen> {
  final Dio _dio = Dio()..interceptors.add(PrettyDioLogger());
  Future<Map<String, dynamic>>? plantDetailsFuture;

  @override
  void initState() {
    super.initState();
    if (widget.imagePath != null) {
      plantDetailsFuture = fetchPlantDetails(
          File(widget.imagePath!), widget.selectedPlant ?? 'Unknown');
    }
  }

  Future<Map<String, dynamic>> fetchPlantDetails(
      File imageFile, String plantName) async {
    const String apiUrl =
        'https://positive-tiger-endlessly.ngrok-free.app/predict'; // Your API endpoint

    try {
      FormData formData = FormData.fromMap({
        'file': await MultipartFile.fromFile(imageFile.path,
            filename: imageFile.path.split('/').last),
        'plant': plantName,
      });

      final response = await _dio.post(
        apiUrl,
        data: formData,
        options: Options(headers: {'Content-Type': 'multipart/form-data'}),
      );

      if (response.statusCode == 200) {
        final data = response.data;
        await saveReport(data);
        return data;
      } else {
        throw Exception('Failed to load plant details');
      }
    } catch (e) {
      throw Exception('Error fetching data: $e');
    }
  }

  Future<void> saveReport(Map<String, dynamic> report) async {
    final prefs = await SharedPreferences.getInstance();
    final existingReports = prefs.getStringList('diseaseReports') ?? [];
    final newReport = DiseaseModel(
      date: DateTime.now().toString(),
      status: report['class'] ?? 'Unknown',
      isComplete: true,
      imageUrl: widget.imagePath!,
    );
    existingReports.add(jsonEncode(newReport.toJson()));
    await prefs.setStringList('diseaseReports', existingReports);
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Stack(
            children: [
              if (widget.imagePath != null)
                Container(
                  height: size.height * 0.45,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: FileImage(File(widget.imagePath!)),
                      fit: BoxFit.cover,
                    ),
                  ),
                )
              else
                Container(
                  height: size.height * 0.3,
                  color: AppColors.greyLight,
                  child: Center(
                    child: Text(
                      widget.selectedPlant ?? 'Unknown Plant',
                      style: TextStyles.heading1,
                    ),
                  ),
                ),
              Positioned(
                top: size.height * 0.43,
                child: ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                  child: Container(
                    width: size.width,
                    color: Colors.white,
                    child: const Padding(
                      padding:
                          EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                      child: Row(
                        children: [
                          SizedBox(height: 14),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: FutureBuilder<Map<String, dynamic>>(
                future: plantDetailsFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(
                        color: AppColors.primaryColor,
                      ),
                    );
                  } else if (snapshot.hasError) {
                    return Center(
                      child: Text(
                        'Error: ${snapshot.error}',
                        style: TextStyles.bodyText.copyWith(color: Colors.red),
                      ),
                    );
                  } else if (snapshot.hasData) {
                    final data = snapshot.data!;
                    final plantClass =
                        data['class'] as String? ?? 'Unknown Class';
                    final confidence = data['confidence'] as double? ?? 0.0;
                    final reason =
                        data['reason'] as String? ?? 'Reason not provided.';
                    final control = data['control'] as String? ??
                        'Control methods not provided.';

                    return SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const Icon(Icons.check_circle,
                                  color: Colors.green),
                              const SizedBox(width: 8),
                              Text(
                                'We identified the plant!',
                                style: TextStyles.bodyText
                                    .copyWith(color: Colors.green),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          Text(
                            plantClass,
                            style: TextStyles.heading1,
                          ),
                          const SizedBox(height: 16),
                          Row(
                            children: [
                              Text(
                                'Confidence Score',
                                style: TextStyles.bodyText,
                              ),
                              const Spacer(),
                              Text(
                                '${confidence.toStringAsFixed(2)}%',
                                style: TextStyles.bodyText
                                    .copyWith(fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          LinearProgressIndicator(
                            value: confidence / 100,
                            backgroundColor: AppColors.greyLight,
                            color: AppColors.primaryColor,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'Reason',
                            style: TextStyles.heading2,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            reason,
                            style: TextStyles.bodyText,
                            maxLines: 5,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'Control',
                            style: TextStyles.heading2,
                          ),
                          const SizedBox(height: 8),
                          RichText(
                            text: TextSpan(
                              style: TextStyles.bodyText,
                              children: [
                                TextSpan(
                                  text: control,
                                ),
                                TextSpan(
                                  text: ' Read more',
                                  style: const TextStyle(
                                    color: AppColors.primaryColor,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () {},
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 16),
                          CustomBottom(
                            text: 'Talk to the Bot',
                            onPressed: () {
                              navigateTo(context, const ChatBotDetailScreen());
                            },
                          ),
                        ],
                      ),
                    );
                  } else {
                    return const Center(
                      child: Text('No data available'),
                    );
                  }
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
