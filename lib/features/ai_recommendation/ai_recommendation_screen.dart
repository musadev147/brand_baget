import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:brand_bridge/constants/app_colors.dart';
import 'package:brand_bridge/provider/marketplace_provider.dart';
import 'package:brand_bridge/route/app_pages.dart';

class AiRecommendationScreen extends StatefulWidget {
  const AiRecommendationScreen({super.key});

  @override
  State<AiRecommendationScreen> createState() => _AiRecommendationScreenState();
}

class _AiRecommendationScreenState extends State<AiRecommendationScreen> {
  final TextEditingController _promptController = TextEditingController();
  bool _isLoading = false;
  List<Map<String, dynamic>>? _matches;

  void _runAiMatch(MarketplaceProvider provider) async {
    final query = _promptController.text.trim();
    if (query.isEmpty) return;

    setState(() {
      _isLoading = true;
      _matches = null;
    });

    // Simulate AI match calculation delay
    await Future.delayed(const Duration(seconds: 2));

    if (mounted) {
      setState(() {
        _isLoading = false;
        _matches = provider.aiMatchCampaign(query);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final marketplace = Provider.of<MarketplaceProvider>(context, listen: false);

    return Scaffold(
      backgroundColor: AppColors.cF5F6FA,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: AppColors.allPrimaryColor),
        title: const Text(
          "AI Match Discovery",
          style: TextStyle(
            fontFamily: 'Poppins',
            fontWeight: FontWeight.bold,
            fontSize: 16,
            color: AppColors.allPrimaryColor,
          ),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Intro Card
              Card(
                color: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: AppColors.appThemeColor.withOpacity(0.1),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.auto_awesome_rounded, color: AppColors.appThemeColor, size: 24),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Describe Your Campaign",
                              style: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.bold, fontSize: 14, color: AppColors.allPrimaryColor),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              "Explain your brand product or target audience, and AI will calculate matching metrics.",
                              style: TextStyle(fontFamily: 'Poppins', fontSize: 11, color: AppColors.c6C6C6C),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Input Box
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 10, offset: const Offset(0, 4))
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    children: [
                      TextField(
                        controller: _promptController,
                        maxLines: 3,
                        decoration: const InputDecoration(
                          hintText: "Example: I want to promote my tech mobile app to young gamers in Dhaka with a macro YouTuber.",
                          hintStyle: TextStyle(fontFamily: 'Poppins', fontSize: 12, color: Colors.grey),
                          border: InputBorder.none,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          ElevatedButton.icon(
                            onPressed: _isLoading ? null : () => _runAiMatch(marketplace),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.allPrimaryColor,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                            ),
                            icon: _isLoading
                                ? const SizedBox(
                                    width: 16,
                                    height: 16,
                                    child: CircularProgressIndicator(
                                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                      strokeWidth: 2,
                                    ),
                                  )
                                : const Icon(Icons.auto_awesome, size: 16),
                            label: const Text("Find Matches"),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Recommendations results area
              Expanded(
                child: _isLoading
                    ? const Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CircularProgressIndicator(),
                            SizedBox(height: 16),
                            Text("Analyzing creator demographics...", style: TextStyle(fontFamily: 'Poppins', fontSize: 13, color: AppColors.c6C6C6C)),
                          ],
                        ),
                      )
                    : _matches == null
                        ? const Center(
                            child: Text(
                              "Submit a prompt to calculate AI matching scores.",
                              style: TextStyle(fontFamily: 'Poppins', color: Colors.grey, fontSize: 13),
                            ),
                          )
                        : _matches!.isEmpty
                            ? const Center(
                                child: Text("No creators match this campaign description.", style: TextStyle(fontFamily: 'Poppins')),
                              )
                            : Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    "AI Matching Results",
                                    style: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.bold, fontSize: 15, color: AppColors.allPrimaryColor),
                                  ),
                                  const SizedBox(height: 12),
                                  Expanded(
                                    child: ListView.builder(
                                      itemCount: _matches!.length,
                                      itemBuilder: (context, index) {
                                        final item = _matches![index];
                                        final CreatorModel creator = item["creator"];
                                        final int score = item["matchPercentage"];
                                        final List<String> reasons = item["reasons"];

                                        return Card(
                                          margin: const EdgeInsets.only(bottom: 16),
                                          color: Colors.white,
                                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                          child: Padding(
                                            padding: const EdgeInsets.all(16.0),
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Row(
                                                  children: [
                                                    CircleAvatar(
                                                      radius: 24,
                                                      backgroundImage: NetworkImage(creator.avatar),
                                                    ),
                                                    const SizedBox(width: 12),
                                                    Expanded(
                                                      child: Column(
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        children: [
                                                          Text(
                                                            creator.name,
                                                            style: const TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.bold, fontSize: 15),
                                                          ),
                                                          Text(
                                                            "${(creator.followersCount / 1000).toStringAsFixed(0)}k followers • ${creator.location}",
                                                            style: const TextStyle(fontFamily: 'Poppins', fontSize: 12, color: AppColors.c6C6C6C),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    Container(
                                                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                                                      decoration: BoxDecoration(
                                                        color: Colors.green.withOpacity(0.1),
                                                        borderRadius: BorderRadius.circular(20),
                                                      ),
                                                      child: Text(
                                                        "$score% Match",
                                                        style: const TextStyle(
                                                          fontFamily: 'Poppins',
                                                          fontSize: 12,
                                                          fontWeight: FontWeight.bold,
                                                          color: Colors.green,
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                const Divider(height: 24),
                                                const Text(
                                                  "AI Matching Logic:",
                                                  style: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.bold, fontSize: 12, color: AppColors.allPrimaryColor),
                                                ),
                                                const SizedBox(height: 6),
                                                ...reasons.map((r) => Padding(
                                                      padding: const EdgeInsets.only(bottom: 4.0),
                                                      child: Row(
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        children: [
                                                          const Icon(Icons.check_circle_outline_rounded, color: Colors.green, size: 14),
                                                          const SizedBox(width: 6),
                                                          Expanded(
                                                            child: Text(
                                                              r,
                                                              style: const TextStyle(fontFamily: 'Poppins', fontSize: 12, color: AppColors.c6C6C6C),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    )),
                                                const SizedBox(height: 12),
                                                Row(
                                                  mainAxisAlignment: MainAxisAlignment.end,
                                                  children: [
                                                    OutlinedButton(
                                                      onPressed: () {
                                                        Get.toNamed(Routes.CREATOR_PROFILE, arguments: creator);
                                                      },
                                                      style: OutlinedButton.styleFrom(
                                                        padding: const EdgeInsets.symmetric(horizontal: 16),
                                                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                                                      ),
                                                      child: const Text("View Profile"),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                ],
                              ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
