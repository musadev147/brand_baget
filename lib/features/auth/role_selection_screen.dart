import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:brand_bridge/constants/app_colors.dart';
import 'package:brand_bridge/common_wigdets/user_role.dart';
import 'package:brand_bridge/provider/marketplace_provider.dart';
import 'package:brand_bridge/route/app_pages.dart';
import 'package:brand_bridge/common_wigdets/block_pop_up.dart';

class RoleSelectionScreen extends StatelessWidget {
  const RoleSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<MarketplaceProvider>(context, listen: false);

    return WillPopScope(
      onWillPop: () => BlockPopUp.showExitDialog(context),
      child: Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 36.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              Text(
                "Choose Your Role",
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: AppColors.allPrimaryColor,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                "Select how you want to use CreatorHub AI today.",
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 14,
                  color: AppColors.c6C6C6C,
                ),
              ),
              const SizedBox(height: 48),
              // Brand Option
              GestureDetector(
                onTap: () {
                  provider.setRole(UserRole.client);
                  Get.toNamed(Routes.LOGIN);
                },
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: AppColors.appThemeColor.withOpacity(0.3),
                      width: 1.5,
                    ),
                    gradient: LinearGradient(
                      colors: [
                        AppColors.appThemeColor.withOpacity(0.05),
                        AppColors.appThemeColor.withOpacity(0.01),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: AppColors.appThemeColor.withOpacity(0.1),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.business_rounded,
                            size: 44,
                            color: AppColors.appThemeColor,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          "I am a Client / Brand",
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: AppColors.allPrimaryColor,
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          "I want to find top influencers, set up campaigns, and sponsor videos to grow my business.",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 13,
                            color: AppColors.c6C6C6C,
                            height: 1.4,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              // Creator Option
              GestureDetector(
                onTap: () {
                  provider.setRole(UserRole.creator);
                  Get.toNamed(Routes.LOGIN);
                },
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: AppColors.cFAFBFD.withOpacity(0.9), // secondary gray border
                      width: 1.5,
                    ),
                    gradient: LinearGradient(
                      colors: [
                        Colors.amber.withOpacity(0.05),
                        Colors.amber.withOpacity(0.01),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.amber.withOpacity(0.1),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.video_camera_back_rounded,
                            size: 44,
                            color: Colors.amber,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          "I am an Influencer / Creator",
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: AppColors.allPrimaryColor,
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          "I want to showcase my stats, find sponsorships, talk to brands, and submit video proposals.",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 13,
                            color: AppColors.c6C6C6C,
                            height: 1.4,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    ),);
  }
}
