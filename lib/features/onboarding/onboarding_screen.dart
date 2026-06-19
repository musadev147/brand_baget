import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:brand_bridge/constants/app_colors.dart';
import 'package:brand_bridge/constants/text_font_style.dart';
import 'package:brand_bridge/common_wigdets/common_button.dart';
import 'package:brand_bridge/route/app_pages.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<Map<String, String>> _onboardingData = [
    {
      "title": "Discover Top Creators",
      "description": "Find and collaborate with verified YouTuber, TikToker, and Instagram influencers to scale your brand reach.",
      "icon": "people_alt_rounded",
    },
    {
      "title": "AI-Powered Matchmaking",
      "description": "Describe your product campaign and let our advanced AI recommend the creators with the highest conversion rates.",
      "icon": "psychology_rounded",
    },
    {
      "title": "Secure Escrow Payments",
      "description": "Funds are held safely in escrow and only released when the creator completes and delivers the content as agreed.",
      "icon": "gpp_good_rounded",
    }
  ];

  IconData _getIcon(String iconName) {
    switch (iconName) {
      case "people_alt_rounded":
        return Icons.people_alt_rounded;
      case "psychology_rounded":
        return Icons.psychology_rounded;
      case "gpp_good_rounded":
        return Icons.gpp_good_rounded;
      default:
        return Icons.star_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          TextButton(
            onPressed: () => Get.offNamed(Routes.LOGIN),
            child: Text(
              "Skip",
              style: TextStyle(
                fontFamily: 'Poppins',
                color: AppColors.c6C6C6C,
                fontSize: 15,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(width: 16),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            children: [
              Expanded(
                child: PageView.builder(
                  controller: _pageController,
                  onPageChanged: (int page) {
                    setState(() {
                      _currentPage = page;
                    });
                  },
                  itemCount: _onboardingData.length,
                  itemBuilder: (context, index) {
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 160,
                          height: 160,
                          decoration: BoxDecoration(
                            color: AppColors.appThemeColor.withOpacity(0.08),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            _getIcon(_onboardingData[index]["icon"]!),
                            size: 80,
                            color: AppColors.appThemeColor,
                          ),
                        ),
                        const SizedBox(height: 48),
                        Text(
                          _onboardingData[index]["title"]!,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                            color: AppColors.allPrimaryColor,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          _onboardingData[index]["description"]!,
                          textAlign: TextAlign.center,
                          style: TextFontStyle.textStyle16Poppins500494953.copyWith(
                            fontSize: 15,
                            height: 1.5,
                            color: AppColors.c6C6C6C,
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  _onboardingData.length,
                  (index) => Container(
                    margin: const EdgeInsets.symmetric(horizontal: 4.0),
                    width: _currentPage == index ? 24.0 : 8.0,
                    height: 8.0,
                    decoration: BoxDecoration(
                      color: _currentPage == index
                          ? AppColors.appThemeColor
                          : AppColors.c9C9BA6.withOpacity(0.5),
                      borderRadius: BorderRadius.circular(4.0),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 40),
              CommonButton(
                text: _currentPage == _onboardingData.length - 1
                    ? "Get Started"
                    : "Next",
                onPressed: () {
                  if (_currentPage < _onboardingData.length - 1) {
                    _pageController.nextPage(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeIn,
                    );
                  } else {
                    Get.offNamed(Routes.LOGIN);
                  }
                },
                backgroundColor: AppColors.appThemeColor,
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
