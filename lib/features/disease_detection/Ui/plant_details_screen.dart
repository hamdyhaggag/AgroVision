import 'dart:io';
import 'dart:convert';
import 'package:agro_vision/features/chat/Ui/chat_bot_detail_screen.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:agro_vision/core/themes/app_colors.dart';
import 'package:agro_vision/core/themes/text_styles.dart';
import 'package:agro_vision/shared/widgets/custom_botton.dart';
import '../../../models/disease_model.dart';
import '../../chat/Logic/chat_cubit.dart';

class PlantDetailsScreen extends StatefulWidget {
  final String? imagePath;
  final String plantType;
  final Map<String, dynamic>? cachedData;

  const PlantDetailsScreen({
    super.key,
    this.imagePath,
    required this.plantType,
    this.cachedData,
  }) : assert(imagePath != null, 'Image path must be provided');

  @override
  State<PlantDetailsScreen> createState() => _PlantDetailsScreenState();

  factory PlantDetailsScreen.fromDisease(DiseaseModel disease) {
    return PlantDetailsScreen(
      imagePath: disease.imageUrl,
      plantType: disease.status,
    );
  }

  factory PlantDetailsScreen.fromCachedDisease(DiseaseModel disease) {
    return PlantDetailsScreen(
      imagePath: disease.imageUrl,
      plantType: disease.status,
      cachedData: {
        'class': disease.status,
        'confidence': disease.confidence,
        'reason': disease.reason,
        'control': disease.control,
      },
    );
  }
}

class _PlantDetailsScreenState extends State<PlantDetailsScreen> {
  final Dio _dio = Dio()..interceptors.add(PrettyDioLogger());
  Future<Map<String, dynamic>>? plantDetailsFuture;

  @override
  void initState() {
    super.initState();
    if (widget.cachedData != null) {
      plantDetailsFuture = Future.value(widget.cachedData);
    } else if (widget.imagePath != null) {
      plantDetailsFuture = fetchPlantDetails(File(widget.imagePath!));
    }
  }

  Future<Map<String, dynamic>> fetchPlantDetails(File imageFile) async {
    const String apiUrl =
        'https://positive-tiger-endlessly.ngrok-free.app/predict';

    try {
      FormData formData = FormData.fromMap({
        'file': await MultipartFile.fromFile(imageFile.path,
            filename: imageFile.path.split('/').last),
        'plant': widget.plantType.toLowerCase(),
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
      date: DateTime.now().toIso8601String(),
      status: report['class']?.toString() ?? 'Unknown',
      isComplete: true,
      imageUrl: widget.imagePath!,
      reason: report['reason']?.toString() ?? '',
      control: report['control']?.toString() ?? '',
      confidence: (report['confidence'] as num?)?.toDouble() ?? 0.0,
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
              Container(
                height: size.height * 0.45,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: FileImage(File(widget.imagePath!)),
                    fit: BoxFit.cover,
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
                      child: Row(children: [SizedBox(height: 14)]),
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
                            color: AppColors.primaryColor));
                  } else if (snapshot.hasError) {
                    return Center(
                        child: Text('Error: ${snapshot.error}',
                            style: TextStyles.bodyText
                                .copyWith(color: Colors.red)));
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
                              Text('We identified the plant!',
                                  style: TextStyles.bodyText
                                      .copyWith(color: Colors.green)),
                            ],
                          ),
                          const SizedBox(height: 16),
                          Text(plantClass, style: TextStyles.heading1),
                          const SizedBox(height: 16),
                          Row(
                            children: [
                              Text('Confidence Score',
                                  style: TextStyles.bodyText),
                              const Spacer(),
                              Text('${confidence.toStringAsFixed(2)}%',
                                  style: TextStyles.bodyText
                                      .copyWith(fontWeight: FontWeight.bold)),
                            ],
                          ),
                          const SizedBox(height: 8),
                          LinearProgressIndicator(
                            value: confidence / 100,
                            backgroundColor: AppColors.greyLight,
                            color: AppColors.primaryColor,
                          ),
                          const SizedBox(height: 16),
                          Text('Reason', style: TextStyles.heading2),
                          const SizedBox(height: 8),
                          Text(reason,
                              style: TextStyles.bodyText,
                              maxLines: 5,
                              overflow: TextOverflow.ellipsis),
                          const SizedBox(height: 16),
                          Text('Control', style: TextStyles.heading2),
                          const SizedBox(height: 8),
                          RichText(
                            text: TextSpan(
                              style: TextStyles.bodyText,
                              children: [
                                TextSpan(text: control),
                                TextSpan(
                                  text: ' Read more',
                                  style: const TextStyle(
                                      color: AppColors.primaryColor,
                                      fontWeight: FontWeight.bold),
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () {},
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 16),
                          CustomBottom(
                            text: 'Talk to the Bot',
                            onPressed: () async {
                              if (!snapshot.hasData) return;

                              final data = snapshot.data!;
                              final plantClass = data['class'] ?? 'Unknown';
                              final reason =
                                  data['reason'] ?? 'No reason provided';
                              final control =
                                  data['control'] ?? 'No control measures';

                              final chatCubit = context.read<ChatCubit>();

                              final newSession =
                                  await chatCubit.createNewSession();
                              if (newSession == null) return;

                              chatCubit.addBotMessage(
                                'Diagnosis Result:\n'
                                '• Disease: $plantClass\n'
                                '• Reason: $reason\n'
                                '• Control Measures: $control\n\n'
                                'How can I assist you further?',
                                newSession.id,
                              );

                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => const ChatBotDetailScreen(),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    );
                  } else {
                    return const Center(child: Text('No data available'));
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
