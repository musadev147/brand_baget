import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:brand_bridge/constants/app_colors.dart';
import 'package:brand_bridge/common_wigdets/user_role.dart';
import 'package:brand_bridge/provider/marketplace_provider.dart';
import 'package:brand_bridge/route/app_pages.dart';

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
        title: Row(
          children: [
            CircleAvatar(
              radius: 18,
              backgroundImage: NetworkImage(marketplace.creatorAvatar),
            ),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
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
              // Stats Row
              Row(
                children: [
                  _buildCreatorStatCard(
                    title: "Subscribers Reach",
                    value: "${(marketplace.creatorFollowers / 1000).toStringAsFixed(0)}K",
                    icon: Icons.rocket_launch_rounded,
                    color: Colors.amber,
                  ),
                  const SizedBox(width: 16),
                  _buildCreatorStatCard(
                    title: "Platform Earnings",
                    value: "\$1,250",
                    icon: Icons.account_balance_wallet_rounded,
                    color: Colors.green,
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // My Sponsorship Posts Section
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "My Sponsorship Posts",
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.allPrimaryColor,
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
                  : ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: appliedCampaigns.length,
                      itemBuilder: (context, idx) {
                        final campaign = appliedCampaigns[idx];
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
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCreatorStatCard({
    required String title,
    required String value,
    required IconData icon,
    required Color color,
  }) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.03),
              blurRadius: 10,
              offset: const Offset(0, 4),
            )
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: color, size: 24),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 11,
                      color: AppColors.c6C6C6C,
                    ),
                  ),
                  Text(
                    value,
                    style: const TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.allPrimaryColor,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
