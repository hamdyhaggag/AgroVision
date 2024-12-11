import 'package:agro_vision/core/themes/app_colors.dart';
import 'package:agro_vision/core/themes/text_styles.dart';
import 'package:agro_vision/shared/widgets/custom_botton.dart';
import 'package:flutter/material.dart';

class PlantDetailsScreen extends StatelessWidget {
  const PlantDetailsScreen({super.key});

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
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/plant_sample.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),

          // Content Section
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header with Status
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

                    // Plant Name
                    const Text(
                      'Pyrus Communis',
                      style: TextStyles.heading1,
                    ),

                    const SizedBox(height: 16),

                    // Confidence Score
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

                    // Cause Description
                    const Text(
                      'Cause',
                      style: TextStyles.heading2,
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Pyrus cordata, the Heart-leaved pear or Plymouth pear, is a rare wild species of pear belonging to the family Rosaceae. It gets its name in Spanish, Portuguese, and French from the shape of its leaves. In the UK, it is known as Plymouth Pear after the city of Plymouth in Devon, where it was originally found in 1870.',
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

                    // Button
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
