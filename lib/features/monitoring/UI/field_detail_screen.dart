import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/themes/app_colors.dart';
import '../../../../shared/widgets/stat_card.dart';
import '../../../../shared/widgets/growth_rate_chart.dart';

class FieldDetailScreen extends StatelessWidget {
  final Map<String, String> field;

  const FieldDetailScreen({super.key, required this.field});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: HeaderSection(field: field),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Card(
                  color: Colors.white,
                  elevation: 3,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const GrowthRateChart()),
            ),
          ),
        ],
      ),
    );
  }
}

class HeaderSection extends StatelessWidget {
  final Map<String, String> field;

  const HeaderSection({super.key, required this.field});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          height: 450.h,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(field['image'] ?? 'assets/images/field.png'),
              fit: BoxFit.cover,
            ),
          ),
        ),
        Container(
          height: 450.h,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.black.withOpacity(0.5), Colors.transparent],
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 50.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 28.h),
              Text(
                field['name'] ?? 'Field Name',
                style: Theme.of(context)
                    .textTheme
                    .headlineSmall
                    ?.copyWith(color: Colors.white),
              ),
              SizedBox(height: 10.h),
              Row(
                children: [
                  Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                    decoration: BoxDecoration(
                      color: AppColors.primaryColor,
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    child: Text(
                      'Live',
                      style: TextStyle(color: Colors.white, fontSize: 12.sp),
                    ),
                  ),
                  SizedBox(width: 8.w),
                  Text(
                    '${field['size']} • ${field['date']}',
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium
                        ?.copyWith(color: Colors.white),
                  ),
                ],
              ),
              SizedBox(height: 40.h),
              const SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    StatCard(
                      title: "EC",
                      value: '93%',
                      icon: Icons.electric_bolt,
                    ),
                    StatCard(
                      title: "Fertility",
                      value: '85%',
                      icon: Icons.park,
                    ),
                    StatCard(
                      title: 'Hum',
                      value: '74%',
                      icon: Icons.water_drop,
                    ),
                    StatCard(
                      title: 'K',
                      value: '74%',
                      icon: Icons.science,
                    ),
                    StatCard(
                      title: 'N',
                      value: '74%',
                      icon: Icons.science,
                    ),
                    StatCard(
                      title: 'P',
                      value: '74%',
                      icon: Icons.science,
                    ),
                    StatCard(
                      title: 'PH',
                      value: '74%',
                      icon: Icons.balance,
                    ),
                    StatCard(
                      title: 'Temp',
                      value: '74%',
                      icon: Icons.thermostat,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        Positioned(
          top: 16.h,
          child: IconButton(
            color: Colors.white,
            icon: const Icon(Icons.arrow_back_ios_new_rounded),
            onPressed: () {
              if (Navigator.canPop(context)) {
                Navigator.of(context).pop();
              }
            },
          ),
        ),
      ],
    );
  }
}
