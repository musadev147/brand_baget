import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:brand_bridge/constants/app_colors.dart';
import 'package:brand_bridge/common_wigdets/user_role.dart';
import 'package:brand_bridge/common_wigdets/common_button.dart';
import 'package:brand_bridge/provider/marketplace_provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:get/get.dart';
import 'package:brand_bridge/route/app_pages.dart';

class CreatorProfileScreen extends StatefulWidget {
  const CreatorProfileScreen({super.key});

  @override
  State<CreatorProfileScreen> createState() => _CreatorProfileScreenState();
}

class _CreatorProfileScreenState extends State<CreatorProfileScreen> {
  bool _isAnalyzing = false;
  Map<String, dynamic>? _analysisResult;

  Future<void> _launchURL(String urlString) async {
    String formattedUrl = urlString.trim();
    if (formattedUrl.isEmpty) return;
    if (!formattedUrl.startsWith("http://") && !formattedUrl.startsWith("https://")) {
      formattedUrl = "https://$formattedUrl";
    }
    final Uri uri = Uri.parse(formattedUrl);
    try {
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } else {
        Get.snackbar(
          "Error",
          "Could not launch link: $urlString",
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      Get.snackbar(
        "Error",
        "Invalid url format or link could not be opened: $urlString",
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  void _runAudienceAnalysis(MarketplaceProvider provider, String creatorId) async {
    setState(() {
      _isAnalyzing = true;
      _analysisResult = null;
    });

    // Simulate AI delay
    await Future.delayed(const Duration(seconds: 2));

    if (mounted) {
      setState(() {
        _isAnalyzing = false;
        _analysisResult = provider.aiCheckFakeFollowers(creatorId);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // Get creator model from arguments passed via Get
    final CreatorModel creator = ModalRoute.of(context)!.settings.arguments as CreatorModel;
    final provider = Provider.of<MarketplaceProvider>(context, listen: false);
    final bool isVerified = creator.id == "1" ? provider.isKycVerified : true;

    return Scaffold(
      backgroundColor: AppColors.cF5F6FA,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: AppColors.allPrimaryColor),
        title: Row(
          children: [
            Text(
              creator.name,
              style: const TextStyle(
                fontFamily: 'Poppins',
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: AppColors.allPrimaryColor,
              ),
            ),
            if (isVerified) ...[
              const SizedBox(width: 4),
              const Icon(Icons.verified, color: Colors.blue, size: 16),
            ],
          ],
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header info Card
            Card(
              color: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 36,
                      backgroundImage: NetworkImage(creator.avatar),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                creator.name,
                                style: const TextStyle(
                                  fontFamily: 'Poppins',
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.allPrimaryColor,
                                ),
                              ),
                              if (isVerified) ...[
                                const SizedBox(width: 4),
                                const Icon(Icons.verified, color: Colors.blue, size: 18),
                              ],
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text(
                            "Location: ${creator.location}",
                            style: const TextStyle(fontFamily: 'Poppins', fontSize: 12, color: AppColors.c6C6C6C),
                          ),
                          const SizedBox(height: 6),
                          Row(
                            children: creator.categories.map((cat) {
                              return Container(
                                margin: const EdgeInsets.only(right: 6),
                                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                decoration: BoxDecoration(
                                  color: AppColors.appThemeColor.withOpacity(0.08),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Text(
                                  cat,
                                  style: const TextStyle(
                                    fontFamily: 'Poppins',
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.appThemeColor,
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Bio Card
            Card(
              color: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "About Me",
                      style: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.bold, fontSize: 14, color: AppColors.allPrimaryColor),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      creator.bio,
                      style: const TextStyle(fontFamily: 'Poppins', fontSize: 13, color: AppColors.c6C6C6C, height: 1.5),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Stats Cards
            Row(
              children: [
                _buildStatTile("Followers", "${(creator.followersCount / 1000).toStringAsFixed(0)}k", Icons.people),
                const SizedBox(width: 12),
                _buildStatTile("Avg Views", "${(creator.avgViews / 1000).toStringAsFixed(0)}k", Icons.play_circle_fill),
                const SizedBox(width: 12),
                _buildStatTile("Engagement", "${creator.engagementRate}%", Icons.favorite),
              ],
            ),
            const SizedBox(height: 20),

            // Social platforms connections
            Card(
              color: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Connected Platforms",
                      style: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.bold, fontSize: 14, color: AppColors.allPrimaryColor),
                    ),
                    const SizedBox(height: 12),
                    ...creator.platformLinks.entries.map((entry) {
                      return ListTile(
                        contentPadding: EdgeInsets.zero,
                        leading: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: AppColors.appThemeColor.withOpacity(0.08),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            entry.key == 'YouTube'
                                ? Icons.play_arrow_rounded
                                : entry.key == 'Instagram'
                                    ? Icons.camera_alt_outlined
                                    : Icons.link,
                            color: AppColors.appThemeColor,
                          ),
                        ),
                        title: Text(entry.key, style: const TextStyle(fontFamily: 'Poppins', fontSize: 14, fontWeight: FontWeight.bold)),
                        subtitle: Text(entry.value, style: const TextStyle(fontFamily: 'Poppins', fontSize: 12, color: AppColors.c6C6C6C)),
                        trailing: const Icon(Icons.open_in_new, size: 16, color: Colors.grey),
                      );
                    }).toList(),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            // AI Creator Analysis Box
            Card(
              color: AppColors.allPrimaryColor,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.auto_awesome, color: Colors.amber, size: 22),
                        const SizedBox(width: 8),
                        Text(
                          "AI Audience Analysis",
                          style: TextStyle(fontFamily: 'Poppins', fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "Scan this profile to detect fake followers, growth consistency, and verify overall audience reachability.",
                      style: TextStyle(fontFamily: 'Poppins', fontSize: 12, color: Colors.white.withOpacity(0.8), height: 1.4),
                    ),
                    const SizedBox(height: 16),
                    if (_analysisResult == null && !_isAnalyzing)
                      ElevatedButton(
                        onPressed: () => _runAudienceAnalysis(provider, creator.id),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.amber,
                          foregroundColor: AppColors.allPrimaryColor,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        ),
                        child: const Text("Analyze Creator Quality"),
                      ),
                    if (_isAnalyzing)
                      const Row(
                        children: [
                          SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Colors.white), strokeWidth: 2),
                          ),
                          SizedBox(width: 12),
                          Text("Verifying metrics with Gemini AI...", style: TextStyle(fontFamily: 'Poppins', color: Colors.white, fontSize: 13)),
                        ],
                      ),
                    if (_analysisResult != null) ...[
                      const Divider(color: Colors.white24, height: 24),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Audience Quality Index", style: TextStyle(fontFamily: 'Poppins', fontSize: 11, color: Colors.white.withOpacity(0.6))),
                              Text("${_analysisResult!['qualityScore']}/100", style: const TextStyle(fontFamily: 'Poppins', fontSize: 18, fontWeight: FontWeight.bold, color: Colors.greenAccent)),
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Fake Followers Est.", style: TextStyle(fontFamily: 'Poppins', fontSize: 11, color: Colors.white.withOpacity(0.6))),
                              Text("${_analysisResult!['fakeFollowersPct']}%", style: TextStyle(fontFamily: 'Poppins', fontSize: 18, fontWeight: FontWeight.bold, color: _analysisResult!['fakeFollowersPct'] > 10 ? Colors.redAccent : Colors.greenAccent)),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          const Icon(Icons.insights, color: Colors.greenAccent, size: 16),
                          const SizedBox(width: 6),
                          Text(
                            "Growth Pattern: ${_analysisResult!['growthType']}",
                            style: const TextStyle(fontFamily: 'Poppins', fontSize: 12, color: Colors.white, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Portfolio Videos list
            const Text(
              "Previous Collaborations & Portfolio",
              style: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.bold, fontSize: 15, color: AppColors.allPrimaryColor),
            ),
            const SizedBox(height: 10),
            ...creator.portfolio.map((title) {
              return Card(
                margin: const EdgeInsets.only(bottom: 10),
                color: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                child: ListTile(
                  onTap: () => _launchURL(title),
                  leading: const Icon(Icons.video_collection_rounded, color: AppColors.appThemeColor),
                  title: Text(
                    title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontFamily: 'Poppins', fontSize: 13, fontWeight: FontWeight.bold),
                  ),
                  trailing: const Icon(Icons.open_in_new, size: 14, color: Colors.grey),
                ),
              );
            }).toList(),
            const SizedBox(height: 24),

            // Client reviews
            const Text(
              "Client Reviews",
              style: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.bold, fontSize: 15, color: AppColors.allPrimaryColor),
            ),
            const SizedBox(height: 10),
            ...creator.reviews.map((rev) {
              return Card(
                margin: const EdgeInsets.only(bottom: 10),
                color: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Row(
                        children: [
                          CircleAvatar(radius: 12, backgroundColor: AppColors.cF2EFFD, child: Icon(Icons.person, size: 12)),
                          SizedBox(width: 8),
                          Text("Verified Brand Client", style: TextStyle(fontFamily: 'Poppins', fontSize: 12, fontWeight: FontWeight.bold)),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        "\"$rev\"",
                        style: const TextStyle(fontFamily: 'Poppins', fontSize: 12, fontStyle: FontStyle.italic, color: AppColors.c6C6C6C),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
            ],
          ),
        ),
      bottomNavigationBar: provider.currentRole == UserRole.client
          ? SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: CommonButton(
                  text: "Message ${creator.name}",
                  assetIconPath: null,
                  icon: const Icon(Icons.chat_bubble_rounded, color: Colors.white, size: 20),
                  onPressed: () {
                    Get.toNamed(Routes.CHAT, arguments: {
                      "chatId": "direct_${creator.id}",
                      "campaignTitle": "Direct Inquiry with ${creator.name}",
                      "partnerName": creator.name,
                      "partnerRole": UserRole.creator,
                    });
                  },
                  backgroundColor: AppColors.appThemeColor,
                ),
              ),
            )
          : null,
    );
  }

  Widget _buildStatTile(String label, String value, IconData icon) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.grey.withOpacity(0.1)),
        ),
        child: Column(
          children: [
            Icon(icon, color: AppColors.appThemeColor, size: 20),
            const SizedBox(height: 6),
            Text(value, style: const TextStyle(fontFamily: 'Poppins', fontSize: 15, fontWeight: FontWeight.bold, color: AppColors.allPrimaryColor)),
            const SizedBox(height: 2),
            Text(label, style: const TextStyle(fontFamily: 'Poppins', fontSize: 10, color: AppColors.c6C6C6C)),
          ],
        ),
      ),
    );
  }
}
