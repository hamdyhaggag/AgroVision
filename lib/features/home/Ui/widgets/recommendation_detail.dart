import 'package:flutter/material.dart';

class RecommendationDetail extends StatelessWidget {
  final String title;
  final IconData icon;
  final List<String> tips;
  final Color color1;
  final Color color2;
  final List<String> articleTips;

  const RecommendationDetail({
    required this.title,
    required this.icon,
    required this.tips,
    required this.color1,
    required this.color2,
    required this.articleTips,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_rounded,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Hero(
          flightShuttleBuilder: (flightContext, animation, flightDirection,
              fromHeroContext, toHeroContext) {
            return ScaleTransition(
              scale: animation.drive(
                Tween<double>(begin: 0.0, end: 1.0).chain(
                  CurveTween(curve: Curves.easeInOutCubic),
                ),
              ),
              child: FadeTransition(
                opacity: animation,
                child: toHeroContext.widget,
              ),
            );
          },
          tag: title,
          child: Material(
            color: Colors.transparent,
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: Colors.white,
                letterSpacing: 0.8,
              ),
            ),
          ),
        ),
        centerTitle: true,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [color1, color2],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        elevation: 4,
        shadowColor: color1.withValues(alpha: 0.3),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.white,
              Color.lerp(color1.withValues(alpha: 0.05), Colors.white, 0.8)!
            ],
          ),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 500),
                  curve: Curves.fastOutSlowIn,
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [color1, color2],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: color2.withValues(alpha: 0.4),
                        blurRadius: 16,
                        offset: const Offset(0, 8),
                      )
                    ],
                  ),
                  child: Icon(icon, size: 48, color: Colors.white),
                ),
              ),
              const SizedBox(height: 32),
              Center(
                child: Text(
                  'Key Recommendations',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                    color: color1,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              ...List.generate(tips.length, (index) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: ScaleTransition(
                    scale: CurvedAnimation(
                      parent: kAlwaysCompleteAnimation,
                      curve: Interval(0.1 + index * 0.1, 1,
                          curve: Curves.easeOutBack),
                    ),
                    child: FadeTransition(
                      opacity: CurvedAnimation(
                        parent: kAlwaysCompleteAnimation,
                        curve: Interval(0.1 + index * 0.1, 1),
                      ),
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.05),
                              blurRadius: 12,
                              offset: const Offset(0, 4),
                            )
                          ],
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: 32,
                              height: 32,
                              decoration: BoxDecoration(
                                color: color1.withValues(alpha: 0.1),
                                shape: BoxShape.circle,
                              ),
                              alignment: Alignment.center,
                              child:
                                  Icon(Icons.circle, size: 12, color: color1),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Text(
                                tips[index],
                                style: TextStyle(
                                  fontSize: 16,
                                  height: 1.5,
                                  color: Colors.grey[800],
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              }),
              const SizedBox(height: 32),
              Center(
                child: Text(
                  'Detailed Guidance',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                    color: color1,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              ...articleTips
                  .map((paragraph) => Padding(
                        padding: const EdgeInsets.only(bottom: 24),
                        child: RichText(
                          textAlign: TextAlign.justify,
                          text: TextSpan(
                            style: TextStyle(
                              fontSize: 15,
                              height: 1.6,
                              color: Colors.grey[700],
                              fontWeight: FontWeight.w400,
                            ),
                            children: [
                              TextSpan(
                                text: '• ',
                                style: TextStyle(
                                  color: color1,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                ),
                              ),
                              TextSpan(text: paragraph),
                            ],
                          ),
                        ),
                      ))
                  .toList(),
            ],
          ),
        ),
      ),
    );
  }
}
