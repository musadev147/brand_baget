import 'package:flutter/material.dart';
import 'package:brand_bridge/common_wigdets/user_role.dart';
import 'package:brand_bridge/constants/app_colors.dart';
import 'package:brand_bridge/features/home/client_home_screen.dart';
import 'package:brand_bridge/features/home/creator_home_screen.dart';
import 'package:brand_bridge/features/creator_search/search_creator_screen.dart';
import 'package:brand_bridge/features/ai_recommendation/ai_recommendation_screen.dart';
import 'package:brand_bridge/features/campaign/campaign_list_screen.dart';
import 'package:brand_bridge/features/analytics/analytics_screen.dart';
import 'package:brand_bridge/features/settings/settings_screen.dart';

class CustomNavigation extends StatefulWidget {
  final UserRole role;
  final int selectedIndex;

  const CustomNavigation({
    super.key,
    required this.role,
    this.selectedIndex = 0,
  });

  @override
  State<CustomNavigation> createState() => _CustomNavigationState();
}

class _CustomNavigationState extends State<CustomNavigation> {
  int _selectedIndex = 0;

  late final List<Widget> _clientScreens = [
    const ClientHomeScreen(),
    const SearchCreatorScreen(),
    const AiRecommendationScreen(),
    const CampaignListScreen(),
    const SettingsScreen(),
  ];

  late final List<Widget> _creatorScreens = [
    const CreatorHomeScreen(),
    const CampaignListScreen(),
    const AnalyticsScreen(),
    const SettingsScreen(),
  ];

  late final List<IconData> _clientIcons = [
    Icons.dashboard_rounded,
    Icons.search_rounded,
    Icons.auto_awesome,
    Icons.campaign_rounded,
    Icons.settings_rounded,
  ];

  late final List<IconData> _creatorIcons = [
    Icons.dashboard_rounded,
    Icons.campaign_rounded,
    Icons.analytics_rounded,
    Icons.settings_rounded,
  ];

  late final List<String> _clientLabels = [
    "Home",
    "Search",
    "AI Match",
    "Campaigns",
    "Settings",
  ];

  late final List<String> _creatorLabels = [
    "Home",
    "Browse",
    "Analytics",
    "Settings",
  ];

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.selectedIndex;
  }

  @override
  Widget build(BuildContext context) {
    final isClient = widget.role == UserRole.client;
    final screens = isClient ? _clientScreens : _creatorScreens;
    final icons = isClient ? _clientIcons : _creatorIcons;
    final labels = isClient ? _clientLabels : _creatorLabels;

    return WillPopScope(
      onWillPop: () async {
        final shouldExit = await showDialog<bool>(
          context: context,
          barrierDismissible: false,
          builder: (context) {
            return Dialog(
              backgroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppColors.appThemeColor.withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.logout, color: AppColors.appThemeColor, size: 30),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      "Exit App",
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppColors.allPrimaryColor,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      "Are you sure you want to exit?",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 14,
                        color: AppColors.c6C6C6C,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () => Navigator.of(context).pop(false),
                            style: OutlinedButton.styleFrom(
                              side: const BorderSide(color: Colors.grey),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: const Text("No", style: TextStyle(color: Colors.black)),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () => Navigator.of(context).pop(true),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.appThemeColor,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: const Text("Yes", style: TextStyle(color: Colors.white)),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        );
        return shouldExit ?? false;
      },
      child: Scaffold(
        backgroundColor: AppColors.cF5F6FA,
        body: IndexedStack(
          index: _selectedIndex,
          children: screens,
        ),
        bottomNavigationBar: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(24),
              topRight: Radius.circular(24),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 10,
                offset: Offset(0, -2),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: List.generate(icons.length, (index) {
              final isSelected = _selectedIndex == index;

              return GestureDetector(
                onTap: () {
                  setState(() {
                    _selectedIndex = index;
                  });
                },
                child: Container(
                  color: Colors.transparent,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        icons[index],
                        size: 24,
                        color: isSelected
                            ? AppColors.appThemeColor
                            : AppColors.c87878A,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        labels[index],
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 10,
                          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                          color: isSelected
                              ? AppColors.appThemeColor
                              : AppColors.c87878A,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}
