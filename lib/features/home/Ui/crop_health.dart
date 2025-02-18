import 'package:flutter/material.dart';

import '../../../shared/widgets/custom_appbar.dart';

class CropHealth extends StatelessWidget {
  const CropHealth({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        title: 'Crop Health',
        isHome: false,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: ListView(
          children: const [
            SizedBox(height: 24),
            RecommendationTile(
              icon: Icons.water_drop_rounded,
              title: 'Smart Irrigation',
              tips: [
                'Implement drip irrigation for water efficiency',
                'Monitor soil moisture 3x weekly',
                'Adjust watering based on growth stage'
              ],
              color1: Color(0xFF2D9CDB),
              color2: Color(0xFF56CCF2),
            ),
            RecommendationTile(
                icon: Icons.spa_rounded,
                title: 'Nutrient Management',
                tips: [
                  'Apply NPK 20-10-10 during vegetation',
                  'Conduct soil tests every 6 weeks',
                  'Use compost tea for organic boost'
                ],
                color1: Color(0xFF27AE60),
                color2: Color(0xFF6FCF97)),
            RecommendationTile(
                icon: Icons.bug_report_rounded,
                title: 'Integrated Pest Control',
                tips: [
                  'Release beneficial insects weekly',
                  'Apply neem oil every 14 days',
                  'Rotate chemical treatments monthly'
                ],
                color1: Color(0xFFEB5757),
                color2: Color(0xFFFF7676)),
            RecommendationTile(
                icon: Icons.grass_rounded,
                title: 'Soil Preparation',
                tips: [
                  'Deep till soil to 30cm depth',
                  'Add 5kg/m² organic matter',
                  'Balance pH between 6.0-6.8'
                ],
                color1: Color(0xFFFFB74D),
                color2: Color(0xFFFFD54F)),
            RecommendationTile(
                icon: Icons.autorenew_rounded,
                title: 'Crop Rotation',
                tips: [
                  'Rotate legumes with cereals',
                  'Maintain 3-year rotation cycle',
                  'Plant cover crops between seasons'
                ],
                color1: Color(0xFF9B51E0),
                color2: Color(0xFFBB6BD9)),
            RecommendationTile(
                icon: Icons.schedule_rounded,
                title: 'Harvest Timing',
                tips: [
                  'Harvest morning hours for freshness',
                  'Check brix levels before picking',
                  'Use maturity indices for each crop'
                ],
                color1: Color(0xFFF2994A),
                color2: Color(0xFFF2C94C)),
            RecommendationTile(
                icon: Icons.cut_rounded,
                title: 'Pruning Techniques',
                tips: [
                  'Disinfect tools between plants',
                  'Maintain 45° cutting angle',
                  'Remove 20% canopy maximum'
                ],
                color1: Color(0xFF219653),
                color2: Color(0xFF6FCF97)),
            RecommendationTile(
                icon: Icons.park_rounded,
                title: 'Weed Management',
                tips: [
                  'Apply pre-emergent herbicides',
                  'Manual weed weekly',
                  'Use solarization in off-season'
                ],
                color1: Color(0xFF4F4F4F),
                color2: Color(0xFF828282)),
            RecommendationTile(
                icon: Icons.health_and_safety_rounded,
                title: 'Disease Prevention',
                tips: [
                  'Apply copper fungicides preventively',
                  'Ensure 50cm plant spacing',
                  'Remove infected plants immediately'
                ],
                color1: Color(0xFFEB5757),
                color2: Color(0xFFF2994A)),
            RecommendationTile(
                icon: Icons.cloud_rounded,
                title: 'Weather Adaptation',
                tips: [
                  'Install windbreaks for young plants',
                  'Use shade nets in heat waves',
                  'Apply anti-transpirants before frost'
                ],
                color1: Color(0xFF2F80ED),
                color2: Color(0xFF56CCF2)),
            RecommendationTile(
                icon: Icons.build_rounded,
                title: 'Equipment Care',
                tips: [
                  'Lubricate machinery weekly',
                  'Calibrate sprayers monthly',
                  'Replace worn parts quarterly'
                ],
                color1: Color(0xFF4F4F4F),
                color2: Color(0xFF828282)),
            RecommendationTile(
                icon: Icons.warehouse_rounded,
                title: 'Post-Harvest Handling',
                tips: [
                  'Cool produce within 2 hours',
                  'Maintain 90-95% storage humidity',
                  'Use ethylene absorbers for fruits'
                ],
                color1: Color(0xFF219653),
                color2: Color(0xFF27AE60)),
            RecommendationTile(
                icon: Icons.eco_rounded,
                title: 'Sustainable Practices',
                tips: [
                  'Implement no-till farming',
                  'Install bee habitats',
                  'Use biochar for carbon sequestration'
                ],
                color1: Color(0xFF219653),
                color2: Color(0xFF6FCF97)),
          ],
        ),
      ),
    );
  }
}

class RecommendationTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final List<String> tips;
  final Color color1;
  final Color color2;

  const RecommendationTile({
    required this.icon,
    required this.title,
    required this.tips,
    required this.color1,
    required this.color2,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () {},
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [color1, color2],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(icon, color: Colors.white, size: 24),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(title,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          )),
                    ),
                    Icon(Icons.chevron_right_rounded, color: Colors.grey[500]),
                  ],
                ),
                const SizedBox(height: 12),
                ...tips.map((tip) => Padding(
                      padding: const EdgeInsets.symmetric(vertical: 6),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(Icons.circle_rounded, size: 8, color: color1),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(tip,
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey[700],
                                  height: 1.4,
                                )),
                          ),
                        ],
                      ),
                    )),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
