class OnboardingContents {
  final String title;
  final String image;
  final String desc;

  OnboardingContents({
    required this.title,
    required this.image,
    required this.desc,
  });
}

List<OnboardingContents> contents = [
  OnboardingContents(
    title: " Monitoring soil and plant ",
    image: "assets/images/onboarding/onboarding1.svg",
    desc:
        "we aim to use optical (VIR) sensing to observe the fields and make timely crop management decisions.",
  ),
  OnboardingContents(
    title: "Early detection of plant and soil diseases",
    image: "assets/images/onboarding/onboarding2.svg",
    desc:
        "our App can detect plant and soil diseases using an existing camera sensor that tracks the plants in real-time day by day.",
  ),
  OnboardingContents(
    title: "Improve agriculture precision",
    image: "assets/images/onboarding/onboarding3.svg",
    desc:
        "we will use satellite imagery, image processing, deep learning, computer vision, and remote sensing to detect changes in the field and crops and solve the problems whenever they pop.",
  ),
];
