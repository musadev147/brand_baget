import 'package:flutter/material.dart';
import 'package:brand_bridge/common_wigdets/user_role.dart';
import 'package:brand_bridge/common_wigdets/block_pop_up.dart';
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
      onWillPop: () => BlockPopUp.showExitDialog(context),
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
