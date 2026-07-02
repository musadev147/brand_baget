import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:brand_bridge/constants/app_colors.dart';
import 'package:brand_bridge/common_wigdets/user_role.dart';
import 'package:brand_bridge/provider/marketplace_provider.dart';
import 'package:brand_bridge/route/app_pages.dart';
import 'package:brand_bridge/common_wigdets/home_promo_slider.dart';

class CreatorHomeScreen extends StatelessWidget {
  const CreatorHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final marketplace = Provider.of<MarketplaceProvider>(context);

    // Filter campaigns to see which campaigns this creator applied to
    final appliedCampaigns = marketplace.campaigns.where((c) {
      return c.proposals.any((p) => p.creatorId == "1"); // Sabbir TechBytes is mock ID "1"
    }).toList();

    // Filter gigs created by this creator (Mock: creatorId == "1")
    final myGigs = marketplace.gigs.where((g) => g.creatorId == "1").toList();

    return Scaffold(
      backgroundColor: AppColors.cF5F6FA,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: GestureDetector(
          onTap: () {
            final myCreator = marketplace.creators.firstWhere((c) => c.id == "1");
            Get.toNamed(Routes.CREATOR_PROFILE, arguments: myCreator);
          },
          child: MouseRegion(
            cursor: SystemMouseCursors.click,
            child: Row(
              children: [
                CircleAvatar(
                  radius: 18,
                  backgroundImage: NetworkImage(marketplace.creatorAvatar),
                ),
                const SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          marketplace.userName,
                          style: const TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: AppColors.allPrimaryColor,
                          ),
                        ),
                        if (marketplace.isKycVerified) ...[
                          const SizedBox(width: 4),
                          const Icon(Icons.verified, color: Colors.blue, size: 16),
                        ],
                      ],
                    ),
                    Text(
                      "CreatorSpace Dashboard",
                      style: const TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 11,
                        color: AppColors.c6C6C6C,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.chat_bubble_outline_rounded, color: AppColors.allPrimaryColor),
            tooltip: "Messages",
            onPressed: () => Get.toNamed(Routes.CHAT_INBOX),
          ),
          IconButton(
            icon: const Icon(Icons.notifications_outlined, color: AppColors.allPrimaryColor),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text("Notifications", style: TextStyle(fontFamily: 'Poppins')),
                  content: const Text("You have no new notifications.", style: TextStyle(fontFamily: 'Poppins')),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text("Close"),
                    ),
                  ],
                ),
              );
            },
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Unified Creator Stats Card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [AppColors.allPrimaryColor, Color(0xFF1E293B)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.allPrimaryColor.withOpacity(0.12),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Creator Performance Dashboard",
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                        color: Colors.white,
                      ),
                    ),
                    const Divider(color: Colors.white12, height: 20),
                    // Row 1
                    Row(
                      children: [
                        Expanded(child: _buildUnifiedStatItem("Profile Views", "1,420", Icons.remove_red_eye_rounded, Colors.blue)),
                        const SizedBox(width: 16),
                        Expanded(child: _buildUnifiedStatItem(
                          "Running Projects", 
                          "${marketplace.orders.where((o) => o.creatorName == 'Sabbir TechBytes' && o.status != 'completed').length} Active", 
                          Icons.play_circle_fill_rounded, 
                          Colors.orange
                        )),
                      ],
                    ),
                    const SizedBox(height: 16),
                    // Row 2
                    Row(
                      children: [
                        Expanded(child: _buildUnifiedStatItem("Creator Level", "Level 2", Icons.military_tech_rounded, Colors.amber)),
                        const SizedBox(width: 16),
                        Expanded(child: _buildUnifiedStatItem("Average Rating", "4.8 Rating", Icons.star_rounded, Colors.yellow)),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Promo Slider (Dynamic carousel for Creator updates/actions)
              HomePromoSlider(
                items: [
                  PromoItem(
                    title: "Get Verified & Build Trust",
                    description: "Submit your KYC details to display a verification badge and attract 3x more brand campaigns.",
                    icon: Icons.verified_user_rounded,
                    gradientColors: [const Color(0xFF1E3A8A), const Color(0xFF3B82F6)],
                    buttonText: "Verify Identity",
                    onTap: () => Get.toNamed(Routes.KYC),
                  ),
                  PromoItem(
                    title: "Create Sponsorship Gigs",
                    description: "Offer packages specifying your platforms, follower reach, price, and custom deliverables.",
                    icon: Icons.storefront_rounded,
                    gradientColors: [const Color(0xFF6D28D9), const Color(0xFFEC4899)],
                    buttonText: "Create Gig Post",
                    onTap: () => Get.toNamed(Routes.GIG_CREATE),
                  ),
                  PromoItem(
                    title: "Track Earnings & Payouts",
                    description: "Check your active escrow contracts, pending clearances, and withdraw funds securely.",
                    icon: Icons.account_balance_wallet_rounded,
                    gradientColors: [const Color(0xFF0F766E), const Color(0xFF0D9488)],
                    buttonText: "Go to Wallet",
                    onTap: () => Get.toNamed(Routes.WALLET),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // My Sponsorship Posts Section
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Expanded(
                    child: Text(
                      "My Sponsorship Posts",
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppColors.allPrimaryColor,
                      ),
                    ),
                  ),
                  TextButton.icon(
                    onPressed: () => Get.toNamed(Routes.GIG_CREATE),
                    icon: const Icon(Icons.add),
                    label: const Text("Create Post"),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              myGigs.isEmpty
                  ? Card(
                      color: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      child: Padding(
                        padding: const EdgeInsets.all(24.0),
                        child: Column(
                          children: [
                            const Icon(Icons.storefront_rounded, size: 44, color: Colors.grey),
                            const SizedBox(height: 12),
                            const Text(
                              "No Posts Published",
                              style: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 6),
                            const Text(
                              "Create sponsorship posts detailing what services you offer to brands.",
                              textAlign: TextAlign.center,
                              style: TextStyle(fontFamily: 'Poppins', color: AppColors.c6C6C6C, fontSize: 12),
                            ),
                            const SizedBox(height: 16),
                            ElevatedButton(
                              onPressed: () => Get.toNamed(Routes.GIG_CREATE),
                              child: const Text("Create Sponsorship Post"),
                            ),
                          ],
                        ),
                      ),
                    )
                  : ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: myGigs.length,
                      itemBuilder: (context, idx) {
                        final gig = myGigs[idx];
                        return Card(
                          margin: const EdgeInsets.only(bottom: 12),
                          color: Colors.white,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                            side: BorderSide(color: Colors.grey[200]!),
                          ),
                          child: InkWell(
                            onTap: () {
                              Get.toNamed(Routes.GIG_DETAILS, arguments: gig);
                            },
                            borderRadius: BorderRadius.circular(12),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 14.0),
                              child: Row(
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(8),
                                    child: Image.network(
                                      gig.bannerImage,
                                      width: 60,
                                      height: 48,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          gig.title,
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: const TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.bold, fontSize: 13, color: AppColors.allPrimaryColor),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          "Verified Reach: ${gig.totalReach > 0 ? gig.totalReach.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},') : gig.verifiedFollowers.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')} followers",
                                          style: const TextStyle(fontFamily: 'Poppins', fontSize: 10, color: Colors.green, fontWeight: FontWeight.bold),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    "\$${gig.price.toStringAsFixed(0)}",
                                    style: const TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.bold, fontSize: 15, color: Colors.green),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
              const SizedBox(height: 24),

              // Collaborations Section
              const Text(
                "My Active Collaborations",
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.allPrimaryColor,
                ),
              ),
              const SizedBox(height: 12),
              appliedCampaigns.isEmpty
                  ? Card(
                      color: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      child: const Padding(
                        padding: EdgeInsets.all(24.0),
                        child: Column(
                          children: [
                            Icon(Icons.work_outline_rounded, size: 44, color: Colors.grey),
                            SizedBox(height: 12),
                            Text(
                              "No active collaborations",
                              style: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.bold),
                            ),
                            SizedBox(height: 6),
                            Text(
                              "Apply to campaigns to start collaborating with brands.",
                              textAlign: TextAlign.center,
                              style: TextStyle(fontFamily: 'Poppins', color: AppColors.c6C6C6C, fontSize: 12),
                            ),
                          ],
                        ),
                      ),
                    )
                  : Column(
                      children: [
                        // Display only the last (most recent) collaboration
                        Builder(
                          builder: (context) {
                            final campaign = appliedCampaigns.last;
                            final proposal = campaign.proposals.firstWhere((p) => p.creatorId == "1");

                            return Card(
                              margin: const EdgeInsets.only(bottom: 14),
                              color: Colors.white,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                              child: InkWell(
                                onTap: () {
                                  Get.toNamed(Routes.CHAT, arguments: {
                                    "chatId": "${campaign.id}_${proposal.creatorId}",
                                    "campaignTitle": campaign.title,
                                    "partnerName": marketplace.companyName,
                                    "partnerRole": UserRole.client,
                                  });
                                },
                                borderRadius: BorderRadius.circular(12),
                                child: Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Expanded(
                                            child: Text(
                                              campaign.title,
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                              style: const TextStyle(
                                                fontFamily: 'Poppins',
                                                fontSize: 15,
                                                fontWeight: FontWeight.bold,
                                                color: AppColors.allPrimaryColor,
                                              ),
                                            ),
                                          ),
                                          Container(
                                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                            decoration: BoxDecoration(
                                              color: proposal.status == 'accepted'
                                                  ? Colors.green.withOpacity(0.1)
                                                  : proposal.status == 'rejected'
                                                      ? Colors.red.withOpacity(0.1)
                                                      : Colors.amber.withOpacity(0.1),
                                              borderRadius: BorderRadius.circular(6),
                                            ),
                                            child: Text(
                                              proposal.status.toUpperCase(),
                                              style: TextStyle(
                                                fontFamily: 'Poppins',
                                                fontSize: 10,
                                                fontWeight: FontWeight.bold,
                                                color: proposal.status == 'accepted'
                                                    ? Colors.green
                                                    : proposal.status == 'rejected'
                                                        ? Colors.red
                                                        : Colors.amber[800],
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 6),
                                      Text(
                                        "Brand: TechVibe Global",
                                        style: const TextStyle(
                                          fontFamily: 'Poppins',
                                          fontSize: 12,
                                          color: AppColors.c6C6C6C,
                                        ),
                                      ),
                                      const SizedBox(height: 12),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            "Bid: \$${proposal.price.toStringAsFixed(0)}",
                                            style: const TextStyle(
                                              fontFamily: 'Poppins',
                                              fontSize: 13,
                                              fontWeight: FontWeight.bold,
                                              color: AppColors.allPrimaryColor,
                                            ),
                                          ),
                                          if (proposal.status == 'accepted')
                                            const Row(
                                              children: [
                                                Icon(Icons.chat_bubble_outline, size: 16, color: AppColors.appThemeColor),
                                                SizedBox(width: 4),
                                                Text(
                                                  "Open Chat / Contract",
                                                  style: TextStyle(
                                                    fontFamily: 'Poppins',
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.bold,
                                                    color: AppColors.appThemeColor,
                                                  ),
                                                ),
                                              ],
                                            ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                        if (appliedCampaigns.length > 1) ...[
                          const SizedBox(height: 4),
                          Card(
                            color: Colors.white,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            child: ListTile(
                              onTap: () => Get.toNamed(Routes.PROFILE),
                              leading: const Icon(Icons.history_rounded, color: AppColors.appThemeColor),
                              title: Text(
                                "View Older Collaborations (${appliedCampaigns.length - 1})",
                                style: const TextStyle(
                                  fontFamily: 'Poppins',
                                  fontWeight: FontWeight.bold,
                                  fontSize: 13,
                                  color: AppColors.allPrimaryColor,
                                ),
                              ),
                              subtitle: const Text(
                                "The rest of your collaborations are in your Profile settings",
                                style: TextStyle(
                                  fontFamily: 'Poppins',
                                  fontSize: 11,
                                  color: AppColors.c6C6C6C,
                                ),
                              ),
                              trailing: const Icon(Icons.chevron_right_rounded, size: 18, color: Colors.grey),
                            ),
                          ),
                        ]
                      ],
                    ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildUnifiedStatItem(String title, String value, IconData icon, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, color: color, size: 16),
            const SizedBox(width: 6),
            Text(
              title,
              style: const TextStyle(
                fontFamily: 'Poppins',
                fontSize: 10.5,
                color: Colors.white70,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            fontFamily: 'Poppins',
            fontSize: 15,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ],
    );
  }
}
