import 'dart:io';
import 'dart:convert';
import 'package:agro_vision/features/chat/Ui/chat_bot_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:agro_vision/core/themes/app_colors.dart';
import 'package:agro_vision/core/themes/text_styles.dart';
import 'package:agro_vision/shared/widgets/custom_botton.dart';
import '../../../models/disease_model.dart';
import '../../chat/logic/chat_cubit.dart';

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
  final ImagePicker _picker = ImagePicker();
  Future<Map<String, dynamic>>? plantDetailsFuture;
  bool _isStartingChat = false;

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
        options: Options(
          headers: {'Content-Type': 'multipart/form-data'},
          sendTimeout: const Duration(seconds: 15),
          receiveTimeout: const Duration(seconds: 15),
        ),
      );

      if (response.statusCode == 200) {
        final data = response.data;
        final processedData = processResponse(data);
        await saveReport(processedData);
        return processedData;
      } else {
        throw 'Server returned unexpected status: ${response.statusCode}';
      }
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.sendTimeout ||
          e.type == DioExceptionType.receiveTimeout) {
        throw 'Connection timed out. Please check your internet connection.';
      } else if (e.response != null) {
        throw 'Server error: ${e.response?.statusCode}';
      } else {
        throw 'Network error: ${e.message}';
      }
    } on SocketException {
      throw 'No internet connection. Please check your network settings.';
    } catch (e) {
      throw 'Failed to process request: ${e.toString()}';
    }
  }

  Map<String, dynamic> processResponse(Map<String, dynamic> data) {
    if (data.containsKey('prediction')) {
      final prediction = data['prediction'] as Map<String, dynamic>;
      return {
        'class': prediction['class'] ?? 'Unknown Class',
        'confidence': _parseConfidence(prediction['confidence']),
        'reason': prediction['reason'] ?? 'Reason not provided.',
        'control': prediction['control'] ?? 'Control methods not provided.',
      };
    }
    return {
      'class': data['class'] ?? 'Unknown Class',
      'confidence': _parseConfidence(data['confidence']),
      'reason': data['reason'] ?? 'Reason not provided.',
      'control': data['control'] ?? 'Control methods not provided.',
    };
  }

  double _parseConfidence(dynamic confidence) {
    if (confidence is String) {
      return double.tryParse(confidence.replaceAll('%', '')) ?? 0.0;
    }
    return (confidence as num?)?.toDouble() ?? 0.0;
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

  Future<void> _handleImageRetry() async {
    final result = await showModalBottomSheet<ImageSource>(
      context: context,
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('Choose from Gallery'),
              onTap: () => Navigator.pop(context, ImageSource.gallery),
            ),
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text('Take a Photo'),
              onTap: () => Navigator.pop(context, ImageSource.camera),
            ),
          ],
        ),
      ),
    );

    if (result != null && mounted) {
      final XFile? image = await _picker.pickImage(source: result);
      if (image != null && mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => PlantDetailsScreen(
              imagePath: image.path,
              plantType: widget.plantType,
            ),
          ),
        );
      }
    }
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
            child: FutureBuilder<Map<String, dynamic>>(
              future: plantDetailsFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                      child: CircularProgressIndicator(
                          color: AppColors.primaryColor));
                } else if (snapshot.hasError) {
                  return _buildErrorUI(snapshot.error.toString());
                } else if (snapshot.hasData) {
                  return _buildResultUI(snapshot.data!);
                } else {
                  return const Center(child: Text('No data available'));
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorUI(String error) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.red.shade50,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.error_outline_rounded,
                size: 48,
                color: Colors.red.shade700,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Oops! Something Went Wrong',
              style: TextStyles.heading2.copyWith(
                fontSize: 20,
                color: AppColors.errorColor,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              _parseErrorMessage(error),
              textAlign: TextAlign.center,
              style: TextStyles.bodyText.copyWith(
                color: Theme.of(context)
                    .colorScheme
                    .onSurface
                    .withValues(alpha: 0.8),
              ),
            ),
            const SizedBox(height: 24),
            CustomBottom(
              text: 'Try Again',
              onPressed: () => setState(() {
                plantDetailsFuture = fetchPlantDetails(File(widget.imagePath!));
              }),
              icon: Icons.refresh_rounded,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildResultUI(Map<String, dynamic> data) {
    final plantClass = data['class'] as String? ?? 'Unknown Class';
    final confidence = data['confidence'] as double? ?? 0.0;
    final reason = data['reason'] as String? ?? 'Reason not provided.';
    final control =
        data['control'] as String? ?? 'Control methods not provided.';
    final isInvalidInput = plantClass == 'Invalid Input';
    final isIdentified = !isInvalidInput && plantClass != 'Unknown Class';

    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 300),
      child: Column(
        key: ValueKey(isInvalidInput),
        children: [
          Container(
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
            decoration: BoxDecoration(
              color: isInvalidInput
                  ? Colors.red.withValues(alpha: 0.1)
                  : isIdentified
                      ? Colors.green.withValues(alpha: 0.1)
                      : Colors.orange.withValues(alpha: 0.1),
              borderRadius:
                  const BorderRadius.vertical(bottom: Radius.circular(20)),
            ),
            child: Row(
              children: [
                Icon(
                  isInvalidInput
                      ? Icons.error_outline_rounded
                      : isIdentified
                          ? Icons.verified_rounded
                          : Icons.help_outline_rounded,
                  color: isInvalidInput
                      ? AppColors.errorColor
                      : isIdentified
                          ? Colors.green
                          : Colors.orange,
                  size: 32,
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        isInvalidInput
                            ? 'Invalid Input Detected'
                            : isIdentified
                                ? 'Plant Identified'
                                : 'Unclear Detection',
                        style: TextStyles.heading2.copyWith(
                          fontSize: 18,
                          color: isInvalidInput
                              ? AppColors.errorColor
                              : isIdentified
                                  ? Colors.green
                                  : Colors.orange,
                        ),
                      ),
                      Text(
                        plantClass,
                        style: TextStyles.bodyText.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (isInvalidInput) _buildInvalidInputVisual(),
                  if (isIdentified) ...[
                    const SizedBox(height: 24),
                    Row(
                      children: [
                        Text('Confidence Score', style: TextStyles.bodyText),
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
                  ],
                  const SizedBox(height: 24),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.onErrorContainer,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Analysis', style: TextStyles.heading2),
                        const SizedBox(height: 12),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Icon(
                              Icons.info_outline_rounded,
                              color: isInvalidInput
                                  ? AppColors.errorColor
                                  : AppColors.primaryColor,
                              size: 20,
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                reason,
                                style: TextStyles.bodyText,
                              ),
                            ),
                          ],
                        ),
                        if (control.isNotEmpty) ...[
                          const SizedBox(height: 12),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Icon(
                                Icons.tips_and_updates_rounded,
                                color: isInvalidInput
                                    ? AppColors.errorColor
                                    : AppColors.primaryColor,
                                size: 20,
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  control,
                                  style: TextStyles.bodyText,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  if (isInvalidInput) ...[
                    CustomBottom(
                      text: 'Retry with New Image',
                      onPressed: _handleImageRetry,
                      icon: Icons.camera_alt_rounded,
                      color: Colors.red,
                    ),
                  ],
                  if (!isInvalidInput)
                    CustomBottom(
                      text: 'Talk to the Bot',
                      isLoading: _isStartingChat,
                      onPressed: () async {
                        if (_isStartingChat) return;
                        setState(() => _isStartingChat = true);
                        try {
                          final chatCubit = context.read<ChatCubit>();
                          final newSession = await chatCubit.createNewSession();
                          chatCubit.addBotMessage(
                            'Diagnosis Result:\n• Disease: ${data['class']}\n• Reason: ${data['reason']}\n• Control: ${data['control']}\n\nHow can I help?',
                            newSession.id,
                          );
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const ChatBotDetailScreen(),
                            ),
                          );
                        } catch (e) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                                content: Text('Chat error: ${e.toString()}')),
                          );
                        } finally {
                          if (mounted) setState(() => _isStartingChat = false);
                        }
                      },
                    ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInvalidInputVisual() {
    return Column(
      children: [
        const SizedBox(height: 24),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border:
                Border.all(color: Colors.red.withValues(alpha: 0.3), width: 2),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(14),
            child: Stack(
              alignment: Alignment.center,
              children: [
                Image.file(
                  File(widget.imagePath!),
                  height: 150,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
                Container(
                  color: Colors.red.withValues(alpha: 0.2),
                  child: Center(
                    child: Icon(
                      Icons.warning_amber_rounded,
                      size: 48,
                      color: Colors.red.shade700,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  String _parseErrorMessage(String error) {
    const errorMap = {
      'connection timed out': 'Network connection timed out',
      'no internet connection': 'Internet connection required',
      'server error': 'Problem with our servers',
      'invalid input': 'Invalid image uploaded',
      '500': 'Internal server error',
    };
    final errorLower = error.toLowerCase();
    return errorMap.entries
        .firstWhere(
          (entry) => errorLower.contains(entry.key.toLowerCase()),
          orElse: () => const MapEntry('', 'An unexpected error occurred'),
        )
        .value;
  }
}
