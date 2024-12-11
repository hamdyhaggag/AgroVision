import 'dart:io';

import 'package:flutter/material.dart';
import 'package:agro_vision/core/themes/app_colors.dart';
import 'package:agro_vision/core/themes/text_styles.dart';
import 'package:agro_vision/shared/widgets/custom_botton.dart';

class PlantDetailsScreen extends StatelessWidget {
  final String imagePath;

  const PlantDetailsScreen({super.key, required this.imagePath});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Image Section
          Container(
            height: size.height * 0.3,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: FileImage(File(imagePath)),
                fit: BoxFit.cover,
              ),
            ),
          ),

          // Content Section (No Changes Needed)
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.check_circle, color: Colors.green),
                        const SizedBox(width: 8),
                        Text(
                          'Hurray, we identified the plant!',
                          style:
                              TextStyles.bodyText.copyWith(color: Colors.green),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Pyrus Communis',
                      style: TextStyles.heading1,
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        const Text(
                          'Confidence Score',
                          style: TextStyles.bodyText,
                        ),
                        const Spacer(),
                        Text(
                          '87%',
                          style: TextStyles.bodyText
                              .copyWith(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    const LinearProgressIndicator(
                      value: 0.87,
                      backgroundColor: AppColors.greyLight,
                      color: AppColors.primaryColor,
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Cause',
                      style: TextStyles.heading2,
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Pyrus cordata, the Heart-leaved pear or Plymouth pear...',
                      style: TextStyles.bodyText,
                      maxLines: 5,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),
                    InkWell(
                      onTap: () {},
                      child: Text(
                        'Read more',
                        style: TextStyles.bodyText
                            .copyWith(color: AppColors.primaryColor),
                      ),
                    ),
                    const SizedBox(height: 100),
                    CustomBottom(
                        text: 'Get Consultant', onPressed: () => print('Hi')),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
