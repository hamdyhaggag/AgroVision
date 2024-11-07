import 'package:agro_vision/core/themes/app_colors.dart';
import 'package:agro_vision/features/home/Ui/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import '../../../core/helpers/shared_pref_helper.dart';
import '../../../core/utils/functions.dart';
import '../../home/Ui/screen_layout.dart';
import '../Logic/onboarding_contents.dart';
import '../Logic/size_config.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  late PageController _controller;

  @override
  void initState() {
    _controller = PageController();
    super.initState();
  }

  int _currentPage = 0;
  List colors = const [
    Color(0xffffffff),
    Color(0xffffffff),
    Color(0xffffffff),
    Color(0xffffffff),
    Color(0xffffffff),
    Color(0xffffffff),
  ];

  AnimatedContainer _buildDots({required int index}) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(50)),
          color: AppColors.primaryColor),
      margin: const EdgeInsets.only(right: 5),
      height: 10,
      curve: Curves.easeIn,
      width: _currentPage == index ? 20 : 10,
    );
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    double width = SizeConfig.screenW!;
    bool isSmallScreen = width <= 550;

    return Scaffold(
      backgroundColor: colors[_currentPage],
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              children: [
                Expanded(
                  flex: 3,
                  child: PageView.builder(
                    physics: const BouncingScrollPhysics(),
                    controller: _controller,
                    reverse: false,
                    onPageChanged: (value) =>
                        setState(() => _currentPage = value),
                    itemCount: contents.length,
                    itemBuilder: (context, i) {
                      return Padding(
                        padding: EdgeInsets.all(isSmallScreen ? 20.0 : 40.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            SizedBox(height: 70.h),
                            SvgPicture.asset(
                              contents[i].image,
                              height: SizeConfig.blockV! *
                                  (isSmallScreen ? 35 : 35),
                            ),
                            SizedBox(height: isSmallScreen ? 30 : 100),
                            Text(
                              contents[i].title,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontFamily: "PTS",
                                fontWeight: FontWeight.w600,
                                color: AppColors.blackColor,
                                fontSize: isSmallScreen ? 24 : 12,
                              ),
                            ),
                            const SizedBox(height: 15),
                            LayoutBuilder(
                              builder: (context, constraints) {
                                double fontSize = isSmallScreen ? 15 : 16;
                                return Text(
                                  contents[i].desc,
                                  style: TextStyle(
                                    fontFamily: "PTS",
                                    fontWeight: FontWeight.w300,
                                    color: AppColors.blackColor,
                                    fontSize: fontSize,
                                  ),
                                  textAlign: TextAlign.center,
                                );
                              },
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(
                          contents.length,
                          (index) => _buildDots(index: index),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 40,
                          vertical: 58,
                        ),
                        child: Row(
                          mainAxisAlignment: _currentPage == 0
                              ? MainAxisAlignment.center
                              : MainAxisAlignment.spaceBetween,
                          children: [
                            // Back button (only shows if _currentPage > 0)
                            if (_currentPage > 0)
                              Expanded(
                                child: ElevatedButton(
                                  onPressed: () {
                                    _controller.previousPage(
                                      duration:
                                          const Duration(milliseconds: 200),
                                      curve: Curves.easeIn,
                                    );
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: AppColors.greyLight,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    padding: EdgeInsets.symmetric(
                                      vertical: isSmallScreen ? 15 : 17,
                                    ),
                                    textStyle: TextStyle(
                                      fontSize: isSmallScreen ? 20 : 23,
                                      fontFamily: 'PTS',
                                    ),
                                  ),
                                  child: Text(
                                    "Back",
                                    style: TextStyle(
                                      fontWeight: FontWeight.w700,
                                      color: AppColors.greyColor,
                                    ),
                                  ),
                                ),
                              ),

                            // Spacer between buttons for both 'Back, Next' and 'Back, Start'
                            if (_currentPage > 0) const SizedBox(width: 10),

                            // Next or Start Now button
                            Expanded(
                              child: ElevatedButton(
                                onPressed: () {
                                  if (_currentPage + 1 == contents.length) {
                                    navigateTo(context, const ScreenLayout());
                                    CacheHelper.saveData(
                                        key: 'isEnterBefore', value: true);
                                  } else {
                                    _controller.nextPage(
                                      duration:
                                          const Duration(milliseconds: 200),
                                      curve: Curves.easeIn,
                                    );
                                  }
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.primaryColor,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  padding: EdgeInsets.symmetric(
                                    vertical: isSmallScreen ? 15 : 17,
                                  ),
                                  textStyle: TextStyle(
                                    fontSize: isSmallScreen ? 20 : 23,
                                    fontFamily: 'PTS',
                                  ),
                                ),
                                child: Text(
                                  _currentPage == contents.length - 1
                                      ? "Start"
                                      : "Next",
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Positioned(
              top: 20,
              left: 20,
              child: TextButton(
                onPressed: () {
                  navigateTo(context, const HomeScreen());
                  CacheHelper.saveData(key: 'isEnterBefore', value: true);
                },
                style: TextButton.styleFrom(
                  elevation: 0,
                  textStyle: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: isSmallScreen ? 18 : 20,
                    fontFamily: 'PTS',
                  ),
                ),
                child: const Text(
                  "Skip",
                  style: TextStyle(color: AppColors.primaryColor),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
