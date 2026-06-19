import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:brand_bridge/constants/app_colors.dart';
import 'package:brand_bridge/provider/marketplace_provider.dart';
import 'package:brand_bridge/route/app_pages.dart';

class ClientHomeScreen extends StatelessWidget {
  const ClientHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final marketplace = Provider.of<MarketplaceProvider>(context);
    final openCampaigns = marketplace.campaigns;
    final activeGigs = marketplace.gigs;

    return Scaffold(
      backgroundColor: AppColors.cF5F6FA,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              marketplace.companyName,
              style: const TextStyle(
                fontFamily: 'Poppins',
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.allPrimaryColor,
              ),
            ),
            Text(
              "Client Dashboard",
              style: const TextStyle(
                fontFamily: 'Poppins',
                fontSize: 12,
                color: AppColors.c6C6C6C,
              ),
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
              // Notification popup modal
              showModalBottomSheet(
                context: context,
                backgroundColor: Colors.white,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                ),
                builder: (context) {
                  final notifications = marketplace.notifications;
                  return Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              "Notifications",
                              style: TextStyle(
                                fontFamily: 'Poppins',
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: AppColors.allPrimaryColor,
                              ),
                            ),
                            TextButton(
                              onPressed: () {
                                marketplace.clearNotifications();
                                Navigator.pop(context);
                              },
                              child: const Text("Clear All"),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Expanded(
                          child: notifications.isEmpty
                              ? const Center(
                                  child: Text("No new notifications"),
                                )
                              : ListView.builder(
                                  itemCount: notifications.length,
                                  itemBuilder: (context, idx) {
                                    return Card(
                                      margin: const EdgeInsets.symmetric(vertical: 6.0),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: ListTile(
                                        leading: const Icon(Icons.info_outline, color: AppColors.appThemeColor),
                                        title: Text(
                                          notifications[idx],
                                          style: const TextStyle(fontFamily: 'Poppins', fontSize: 13),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                        ),
                      ],
                    ),
                  );
                },
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
                  _buildStatCard(
                    title: "Active Campaigns",
                    value: "${openCampaigns.where((c) => c.status == 'open' || c.status == 'in_progress').length}",
                    icon: Icons.campaign_rounded,
                    color: AppColors.appThemeColor,
                  ),
                  const SizedBox(width: 16),
                  _buildStatCard(
                    title: "Total Budget",
                    value: "\$${marketplace.budgetRange.toStringAsFixed(0)}",
                    icon: Icons.monetization_on_rounded,
                    color: Colors.green,
                  ),
                ],
              ),
              const SizedBox(height: 24),
              // AI Quick Prompt Container
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  gradient: const LinearGradient(
                    colors: [AppColors.allPrimaryColor, AppColors.appThemeColor],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Find Creators with AI",
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      "Describe your product launch, and our AI recommends the perfect influencer matches.",
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 13,
                        color: Colors.white.withOpacity(0.85),
                      ),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton.icon(
                      onPressed: () {
                        Get.toNamed(Routes.AI_RECOMMENDATION);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: AppColors.allPrimaryColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      icon: const Icon(Icons.auto_awesome),
                      label: const Text("Launch AI Discovery"),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 28),

              // Creator Sponsorship Posts Marketplace Section
              const Text(
                "Sponsorship Posts Marketplace",
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.allPrimaryColor,
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                height: 200,
                child: activeGigs.isEmpty
                    ? const Center(child: Text("No sponsorship posts available."))
                    : ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: activeGigs.length,
                        itemBuilder: (context, index) {
                          final gig = activeGigs[index];
                          return Container(
                            width: 260,
                            margin: const EdgeInsets.only(right: 16),
                            child: Card(
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
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    ClipRRect(
                                      borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                                      child: Image.network(
                                        gig.bannerImage,
                                        height: 80,
                                        width: double.infinity,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(12.0),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              CircleAvatar(
                                                radius: 10,
                                                backgroundImage: NetworkImage(gig.creatorAvatar),
                                              ),
                                              const SizedBox(width: 6),
                                              Expanded(
                                                child: Text(
                                                  gig.creatorName,
                                                  maxLines: 1,
                                                  overflow: TextOverflow.ellipsis,
                                                  style: const TextStyle(fontFamily: 'Poppins', fontSize: 11, fontWeight: FontWeight.bold),
                                                ),
                                              ),
                                              Container(
                                                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                                decoration: BoxDecoration(color: AppColors.allPrimaryColor.withOpacity(0.08), borderRadius: BorderRadius.circular(4)),
                                                child: Text(
                                                  gig.category,
                                                  style: const TextStyle(fontSize: 8, fontWeight: FontWeight.bold, color: AppColors.allPrimaryColor),
                                                ),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 6),
                                          Text(
                                            gig.title,
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: const TextStyle(fontFamily: 'Poppins', fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.allPrimaryColor),
                                          ),
                                          const SizedBox(height: 6),
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                "Reach: ${gig.totalReach > 0 ? (gig.totalReach / 1000).toStringAsFixed(0) : (gig.verifiedFollowers / 1000).toStringAsFixed(0)}k followers",
                                                style: const TextStyle(fontSize: 9, color: Colors.green, fontWeight: FontWeight.bold),
                                              ),
                                              Text(
                                                "\$${gig.price.toStringAsFixed(0)}",
                                                style: const TextStyle(fontFamily: 'Poppins', fontSize: 13, fontWeight: FontWeight.bold, color: Colors.green),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
              ),
              const SizedBox(height: 28),

              // Section Header: My Campaigns
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "My Campaigns",
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.allPrimaryColor,
                    ),
                  ),
                  TextButton.icon(
                    onPressed: () => Get.toNamed(Routes.CAMPAIGN_CREATE),
                    icon: const Icon(Icons.add),
                    label: const Text("Create"),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              openCampaigns.isEmpty
                  ? Card(
                      color: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(24.0),
                        child: Column(
                          children: [
                            const Icon(Icons.campaign_outlined, size: 48, color: Colors.grey),
                            const SizedBox(height: 12),
                            const Text(
                              "No campaigns posted yet",
                              style: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 6),
                            const Text(
                              "Create a campaign to let influencers submit sponsorship proposals.",
                              textAlign: TextAlign.center,
                              style: TextStyle(fontFamily: 'Poppins', color: AppColors.c6C6C6C, fontSize: 12),
                            ),
                            const SizedBox(height: 16),
                            ElevatedButton(
                              onPressed: () => Get.toNamed(Routes.CAMPAIGN_CREATE),
                              child: const Text("Create Campaign"),
                            ),
                          ],
                        ),
                      ),
                    )
                  : ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: openCampaigns.length,
                      itemBuilder: (context, idx) {
                        final campaign = openCampaigns[idx];
                        return Card(
                          margin: const EdgeInsets.only(bottom: 14),
                          color: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: InkWell(
                            onTap: () {
                              Get.toNamed(Routes.PROPOSAL, arguments: campaign);
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
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                            color: AppColors.allPrimaryColor,
                                          ),
                                        ),
                                      ),
                                      Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                        decoration: BoxDecoration(
                                          color: campaign.status == 'open'
                                              ? Colors.blue.withOpacity(0.1)
                                              : Colors.green.withOpacity(0.1),
                                          borderRadius: BorderRadius.circular(6),
                                        ),
                                        child: Text(
                                          campaign.status.toUpperCase(),
                                          style: TextStyle(
                                            fontFamily: 'Poppins',
                                            fontSize: 10,
                                            fontWeight: FontWeight.bold,
                                            color: campaign.status == 'open' ? Colors.blue : Colors.green,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 6),
                                  Text(
                                    "Product: ${campaign.productName}",
                                    style: const TextStyle(
                                      fontFamily: 'Poppins',
                                      fontSize: 13,
                                      color: AppColors.c6C6C6C,
                                    ),
                                  ),
                                  const SizedBox(height: 12),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        "Budget: \$${campaign.budget.toStringAsFixed(0)}",
                                        style: const TextStyle(
                                          fontFamily: 'Poppins',
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.green,
                                        ),
                                      ),
                                      Text(
                                        "${campaign.proposals.length} Proposals",
                                        style: const TextStyle(
                                          fontFamily: 'Poppins',
                                          fontSize: 13,
                                          fontWeight: FontWeight.bold,
                                          color: AppColors.appThemeColor,
                                        ),
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

  Widget _buildStatCard({
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
