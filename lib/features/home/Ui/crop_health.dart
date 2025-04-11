import 'package:agro_vision/features/home/Ui/widgets/recommendation_detail.dart';
import 'package:agro_vision/features/home/Ui/widgets/recommendation_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
          children: [
            RecommendationTile(
              icon: Icons.water_drop_rounded,
              title: 'Smart Irrigation',
              tips: const [
                'Implement drip irrigation for water efficiency',
                'Monitor soil moisture 3x weekly',
                'Adjust watering based on growth stage'
              ],
              color1: const Color(0xFF2D9CDB),
              color2: const Color(0xFF56CCF2),
              onTap: () => _navigateToDetail(
                context,
                title: 'Smart Irrigation',
                icon: Icons.water_drop_rounded,
                tips: [
                  'Implement drip irrigation for water efficiency',
                  'Monitor soil moisture 3x weekly',
                  'Adjust watering based on growth stage'
                ],
                articleTips: const [
                  'Drip irrigation systems deliver water directly to the plant roots through a network of valves, pipes, tubing, and emitters. This method significantly reduces evaporation and runoff compared to conventional irrigation. Studies show that smart irrigation controllers can adjust watering schedules based on weather data, potentially saving 15-20% more water.',
                  'Regular soil moisture monitoring using tensiometers or capacitive sensors helps maintain optimal hydration levels. For most crops, the ideal soil moisture tension ranges between 10-30 kPa. Monitoring three times weekly allows for timely adjustments, especially during critical growth phases like flowering and fruit development.',
                  'Different growth stages require varying water amounts:\n- Vegetative: 20-25mm/week\n- Flowering: 30-35mm/week\n- Fruit Development: 40-45mm/week\nAdjust emitters to deliver 0.5-2.0 liters/hour depending on crop type and soil composition.'
                ],
                color1: const Color(0xFF2D9CDB),
                color2: const Color(0xFF56CCF2),
              ),
            ),
            RecommendationTile(
              icon: Icons.spa_rounded,
              title: 'Nutrient Management',
              tips: const [
                'Apply NPK 20-10-10 during vegetation',
                'Conduct soil tests every 6 weeks',
                'Use compost tea for organic boost'
              ],
              color1: const Color(0xFF27AE60),
              color2: const Color(0xFF6FCF97),
              onTap: () => _navigateToDetail(context,
                  title: 'Nutrient Management',
                  icon: Icons.spa_rounded,
                  tips: [
                    'Apply NPK 20-10-10 during vegetation',
                    'Conduct soil tests every 6 weeks',
                    'Use compost tea for organic boost'
                  ],
                  articleTips: const [
                    'NPK 20-10-10 provides 200kg N/ha per application. Split applications into 4 doses during vegetative stage. Maintain soil pH 6.0-6.5 for optimal phosphorus availability.',
                    'Soil tests should measure:\n- N: 25-50 ppm\n- P: 15-30 ppm\n- K: 200-400 ppm\nMicronutrient targets: Zn 2-5 ppm, Fe 4.5-6.5 ppm',
                    'Compost tea recipes:\n- Aerobic: 1:10 compost/water, 24-48h brew\n- Add molasses (0.5%) for microbial growth\nApply within 4 hours of brewing'
                  ],
                  color1: const Color(0xFF27AE60),
                  color2: const Color(0xFF6FCF97)),
            ),
            RecommendationTile(
              icon: Icons.bug_report_rounded,
              title: 'Integrated Pest Control',
              tips: const [
                'Release beneficial insects weekly',
                'Apply neem oil every 14 days',
                'Rotate chemical treatments monthly'
              ],
              color1: const Color(0xFFEB5757),
              color2: const Color(0xFFFF7676),
              onTap: () => _navigateToDetail(context,
                  title: 'Integrated Pest Control',
                  icon: Icons.bug_report_rounded,
                  tips: [
                    'Release beneficial insects weekly',
                    'Apply neem oil every 14 days',
                    'Rotate chemical treatments monthly'
                  ],
                  articleTips: const [
                    'Release rates:\n- Ladybugs: 1,500/acre weekly\n- Trichogramma wasps: 50,000/acre\n- Predatory mites: 100/m² every 2 weeks',
                    'Neem oil concentrations:\n- Preventive: 0.5% AZA\n- Active infestation: 2% AZA\nApply at 500 L/ha coverage',
                    'Rotate between IRAC groups:\n1. Group 3 (Pyrethroids)\n2. Group 4 (Neonicotinoids)\n3. Group 28 (Diamides)\nMinimum 30-day rotation'
                  ],
                  color1: const Color(0xFFEB5757),
                  color2: const Color(0xFFFF7676)),
            ),
            RecommendationTile(
              icon: Icons.grass_rounded,
              title: 'Soil Preparation',
              tips: const [
                'Deep till soil to 30cm depth',
                'Add 5kg/m² organic matter',
                'Balance pH between 6.0-6.8'
              ],
              color1: const Color(0xFFFFB74D),
              color2: const Color(0xFFFFD54F),
              onTap: () => _navigateToDetail(context,
                  title: 'Soil Preparation',
                  icon: Icons.grass_rounded,
                  tips: [
                    'Deep till soil to 30cm depth',
                    'Add 5kg/m² organic matter',
                    'Balance pH between 6.0-6.8'
                  ],
                  articleTips: const [
                    'Deep tillage improves root penetration up to 1.2m depth. Use subsoiler shanks at 45cm spacing. Avoid compaction with <2.0 g/cm³ bulk density',
                    'Organic matter additions:\n- Compost: 5-10 t/ha\n- Vermicompost: 2-3 t/ha\n- Biochar: 0.5-1 t/ha\nIncorporate to 20cm depth',
                    'pH adjustment materials:\n- Lime (CaCO₃): 2-4 t/ha raises pH by 0.5\n- Sulfur: 1-2 t/ha lowers pH by 0.5\nTest 6 weeks after application'
                  ],
                  color1: const Color(0xFFFFB74D),
                  color2: const Color(0xFFFFD54F)),
            ),
            RecommendationTile(
              icon: Icons.autorenew_rounded,
              title: 'Crop Rotation',
              tips: const [
                'Rotate legumes with cereals',
                'Maintain 3-year rotation cycle',
                'Plant cover crops between seasons'
              ],
              color1: const Color(0xFF9B51E0),
              color2: const Color(0xFFBB6BD9),
              onTap: () => _navigateToDetail(context,
                  title: 'Crop Rotation',
                  icon: Icons.autorenew_rounded,
                  tips: [
                    'Rotate legumes with cereals',
                    'Maintain 3-year rotation cycle',
                    'Plant cover crops between seasons'
                  ],
                  articleTips: const [
                    'Legume-cereal rotations increase nitrogen by 40-60 kg/ha. Follow soybeans with corn (3:1 ratio). Avoid same-family crops for 3 seasons',
                    'Rotation sequence example:\nYear 1: Legumes\nYear 2: Leafy vegetables\nYear 3: Root crops\nYear 4: Cereals',
                    'Cover crop options:\n- Winter: Rye + Vetch (3:1 mix)\n- Summer: Buckwheat + Sunnhemp\nTerminate at 50% flowering'
                  ],
                  color1: const Color(0xFF9B51E0),
                  color2: const Color(0xFFBB6BD9)),
            ),
            RecommendationTile(
              icon: Icons.schedule_rounded,
              title: 'Harvest Timing',
              tips: const [
                'Harvest morning hours for freshness',
                'Check brix levels before picking',
                'Use maturity indices for each crop'
              ],
              color1: const Color(0xFFF2994A),
              color2: const Color(0xFFF2C94C),
              onTap: () => _navigateToDetail(context,
                  title: 'Harvest Timing',
                  icon: Icons.schedule_rounded,
                  tips: [
                    'Harvest morning hours for freshness',
                    'Check brix levels before picking',
                    'Use maturity indices for each crop'
                  ],
                  articleTips: const [
                    'Morning harvest (6-9 AM) reduces field heat by 5-7°C. Produce temperature should be <25°C before storage',
                    'Brix level targets:\n- Leafy greens: 6-8%\n- Fruits: 12-14%\n- Root crops: 10-12%\nMeasure with refractometer',
                    'Maturity indices:\n- Tomatoes: 90% color change\n- Apples: 12 lb pressure test\n- Wheat: 14% moisture'
                  ],
                  color1: const Color(0xFFF2994A),
                  color2: const Color(0xFFF2C94C)),
            ),
            RecommendationTile(
              icon: Icons.cut_rounded,
              title: 'Pruning Techniques',
              tips: const [
                'Disinfect tools between plants',
                'Maintain 45° cutting angle',
                'Remove 20% canopy maximum'
              ],
              color1: const Color(0xFF219653),
              color2: const Color(0xFF6FCF97),
              onTap: () => _navigateToDetail(context,
                  title: 'Pruning Techniques',
                  icon: Icons.cut_rounded,
                  tips: [
                    'Disinfect tools between plants',
                    'Maintain 45° cutting angle',
                    'Remove 20% canopy maximum'
                  ],
                  articleTips: const [
                    'Disinfection protocols:\n- 10% bleach solution\n- 70% ethanol\n- 0.5% quaternary ammonium\nSoak tools for 2 minutes between plants',
                    'Branch collar cuts:\n- 45° angle\n- 3mm from bud\n- 1/3 branch diameter limit\nRemove crossing/rubbing branches first',
                    'Canopy management:\n- Max 20% removal per session\n- Maintain 30% light penetration\n- Dwarf trees: 2.5m height limit'
                  ],
                  color1: const Color(0xFF219653),
                  color2: const Color(0xFF6FCF97)),
            ),
            RecommendationTile(
              icon: Icons.park_rounded,
              title: 'Weed Management',
              tips: const [
                'Apply pre-emergent herbicides',
                'Manual weed weekly',
                'Use solarization in off-season'
              ],
              color1: const Color(0xFF4F4F4F),
              color2: const Color(0xFF828282),
              onTap: () => _navigateToDetail(context,
                  title: 'Weed Management',
                  icon: Icons.park_rounded,
                  tips: [
                    'Apply pre-emergent herbicides',
                    'Manual weed weekly',
                    'Use solarization in off-season'
                  ],
                  articleTips: const [
                    'Pre-emergent options:\n- Pendimethalin 1.5 L/ha\n- Metolachlor 1.0 L/ha\nApply 7 days before planting',
                    'Manual weeding:\n- 2-3 leaf stage\n- 10cm weed height max\n- Remove 95% root mass\nRepeat every 14 days',
                    'Solarization:\n- 6 weeks summer\n- Clear 1.5mil plastic\n- Soil temp >45°C\nFollow with mustard cover crop'
                  ],
                  color1: const Color(0xFF4F4F4F),
                  color2: const Color(0xFF828282)),
            ),
            RecommendationTile(
              icon: Icons.health_and_safety_rounded,
              title: 'Disease Prevention',
              tips: const [
                'Apply copper fungicides preventively',
                'Ensure 50cm plant spacing',
                'Remove infected plants immediately'
              ],
              color1: const Color(0xFFEB5757),
              color2: const Color(0xFFF2994A),
              onTap: () => _navigateToDetail(context,
                  title: 'Disease Prevention',
                  icon: Icons.health_and_safety_rounded,
                  tips: [
                    'Apply copper fungicides preventively',
                    'Ensure 50cm plant spacing',
                    'Remove infected plants immediately'
                  ],
                  articleTips: const [
                    'Copper formulations:\n- Bordeaux mix 1%\n- Copper oxychloride 0.3%\n- Apply at 500 L/ha\nMax 3kg Cu/ha/year',
                    'Spacing guidelines:\n- Tomatoes: 60×90cm\n- Wheat: 20×5cm\n- Orchards: 4-6m rows\nUse stake-and-weave system',
                    'Infected plant protocol:\n- Bag before removal\n- Solarize debris\n- 3-year crop break\nSoil drench with Trichoderma'
                  ],
                  color1: const Color(0xFFEB5757),
                  color2: const Color(0xFFF2994A)),
            ),
            RecommendationTile(
              icon: Icons.cloud_rounded,
              title: 'Weather Adaptation',
              tips: const [
                'Install windbreaks for young plants',
                'Use shade nets in heat waves',
                'Apply anti-transpirants before frost'
              ],
              color1: const Color(0xFF2F80ED),
              color2: const Color(0xFF56CCF2),
              onTap: () => _navigateToDetail(context,
                  title: 'Weather Adaptation',
                  icon: Icons.cloud_rounded,
                  tips: [
                    'Install windbreaks for young plants',
                    'Use shade nets in heat waves',
                    'Apply anti-transpirants before frost'
                  ],
                  articleTips: const [
                    'Windbreak design:\n- 50% porosity\n- 4-6 rows staggered\n- 10H protection (H=height)\nUse Casuarina/Sesbania species',
                    'Shade net specifications:\n- 30% for vegetables\n- 50% for nurseries\n- 70% for orchards\nUV-stabilized HDPE',
                    'Anti-transpirants:\n- Kaolin clay 5%\n- Pinolene 0.1%\nApply 24h before frost\nReapply after rain'
                  ],
                  color1: const Color(0xFF2F80ED),
                  color2: const Color(0xFF56CCF2)),
            ),
            RecommendationTile(
              icon: Icons.build_rounded,
              title: 'Equipment Care',
              tips: const [
                'Lubricate machinery weekly',
                'Calibrate sprayers monthly',
                'Replace worn parts quarterly'
              ],
              color1: const Color(0xFF4F4F4F),
              color2: const Color(0xFF828282),
              onTap: () => _navigateToDetail(context,
                  title: 'Equipment Care',
                  icon: Icons.build_rounded,
                  tips: [
                    'Lubricate machinery weekly',
                    'Calibrate sprayers monthly',
                    'Replace worn parts quarterly'
                  ],
                  articleTips: const [
                    'Lubrication schedule:\n- Gearboxes: SAE 90 (500h)\n- Chains: NLGI #2 (50h)\n- Pivots: EP grease (100h)\nClean with diesel before applying',
                    'Sprayer calibration:\n- Nozzle flow check (±5%)\n- Pressure 2-3 bar\n- Pattern uniformity test\nRecord in maintenance log',
                    'Replacement thresholds:\n- Belts: 10% stretch\n- Filters: 15% flow drop\n- Disc openers: 20% wear\nKeep 10% spare parts inventory'
                  ],
                  color1: const Color(0xFF4F4F4F),
                  color2: const Color(0xFF828282)),
            ),
            RecommendationTile(
              icon: Icons.warehouse_rounded,
              title: 'Post-Harvest Handling',
              tips: const [
                'Cool produce within 2 hours',
                'Maintain 90-95% storage humidity',
                'Use ethylene absorbers for fruits'
              ],
              color1: const Color(0xFF219653),
              color2: const Color(0xFF27AE60),
              onTap: () => _navigateToDetail(context,
                  title: 'Post-Harvest Handling',
                  icon: Icons.warehouse_rounded,
                  tips: [
                    'Cool produce within 2 hours',
                    'Maintain 90-95% storage humidity',
                    'Use ethylene absorbers for fruits'
                  ],
                  articleTips: const [
                    'Rapid cooling methods:\n- Hydrocooling (1°C water)\n- Forced-air (4h to 4°C)\n- Vacuum cooling (20min)\nTarget 10°C/hr cooling rate',
                    'Humidity control:\n- Perforated LDPE bags\n- Wet wall systems\n- Silica gel packets\nMonitor with data loggers',
                    'Ethylene management:\n- 1-MCP sachets (0.5ppm)\n- KMnO₄ filters\n- Ventilation 0.5m³/min\nStore below 10°C'
                  ],
                  color1: const Color(0xFF219653),
                  color2: const Color(0xFF27AE60)),
            ),
            RecommendationTile(
              icon: Icons.eco_rounded,
              title: 'Sustainable Practices',
              tips: const [
                'Implement no-till farming',
                'Install bee habitats',
                'Use biochar for carbon sequestration'
              ],
              color1: const Color(0xFF219653),
              color2: const Color(0xFF6FCF97),
              onTap: () => _navigateToDetail(context,
                  title: 'Sustainable Practices',
                  icon: Icons.eco_rounded,
                  tips: [
                    'Implement no-till farming',
                    'Install bee habitats',
                    'Use biochar for carbon sequestration'
                  ],
                  articleTips: const [
                    'No-till benefits:\n- 30% fuel savings\n- 0.5% SOC increase/year\n- Earthworm density 2×\nUse disc seeders',
                    'Bee habitat design:\n- 5 nests/acre\n- 10mm diameter holes\n- Orient SE facing\nPlant Lavender/Borage borders',
                    'Biochar application:\n- 500kg/ha\n- Mix with compost 1:2\n- pH 7-8 optimal\nIncrease CEC by 20-30%'
                  ],
                  color1: const Color(0xFF219653),
                  color2: const Color(0xFF6FCF97)),
            ),
          ],
        ),
      ),
    );
  }

  void _navigateToDetail(
    BuildContext context, {
    required String title,
    required IconData icon,
    required List<String> tips,
    required List<String> articleTips,
    required Color color1,
    required Color color2,
  }) {
    HapticFeedback.selectionClick();
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => RecommendationDetail(
          title: title,
          icon: icon,
          tips: tips,
          articleTips: articleTips,
          color1: color1,
          color2: color2,
        ),
      ),
    );
  }
}
