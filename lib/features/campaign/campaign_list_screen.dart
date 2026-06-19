import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:brand_bridge/constants/app_colors.dart';
import 'package:brand_bridge/provider/marketplace_provider.dart';
import 'package:brand_bridge/route/app_pages.dart';

class CampaignListScreen extends StatefulWidget {
  const CampaignListScreen({super.key});

  @override
  State<CampaignListScreen> createState() => _CampaignListScreenState();
}

class _CampaignListScreenState extends State<CampaignListScreen> {
  String _selectedPlatform = "All";
  final List<String> _platforms = ["All", "YouTube", "Instagram", "Facebook", "TikTok"];

  @override
  Widget build(BuildContext context) {
    final marketplace = Provider.of<MarketplaceProvider>(context);
    
    // Filter campaigns based on selected platform filter
    final campaigns = marketplace.campaigns.where((c) {
      return _selectedPlatform == "All" || c.platform == _selectedPlatform;
    }).toList();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          "Available Sponsorships",
          style: TextStyle(
            fontFamily: 'Poppins', 
            fontWeight: FontWeight.bold, 
            fontSize: 16, 
            color: AppColors.allPrimaryColor,
          ),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(
            color: Colors.grey[200],
            height: 1,
          ),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Filter bar
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
              color: Colors.grey[50],
              child: Row(
                children: [
                  const Text(
                    "Filter:",
                    style: TextStyle(
                      fontFamily: 'Poppins', 
                      fontWeight: FontWeight.bold, 
                      fontSize: 13, 
                      color: AppColors.allPrimaryColor,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: _platforms.map((p) {
                          final isSelected = _selectedPlatform == p;
                          return Padding(
                            padding: const EdgeInsets.only(right: 6.0),
                            child: ChoiceChip(
                              label: Text(
                                p,
                                style: TextStyle(
                                  fontFamily: 'Poppins',
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                  color: isSelected ? Colors.white : Colors.black87,
                                ),
                              ),
                              selected: isSelected,
                              selectedColor: AppColors.allPrimaryColor,
                              backgroundColor: Colors.grey[200],
                              onSelected: (selected) {
                                if (selected) {
                                  setState(() {
                                    _selectedPlatform = p;
                                  });
                                }
                              },
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // Campaign List
            Expanded(
              child: campaigns.isEmpty
                  ? const Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.layers_clear_outlined, size: 54, color: Colors.grey),
                          SizedBox(height: 12),
                          Text("No sponsorships found.", style: TextStyle(fontFamily: 'Poppins', color: Colors.grey)),
                        ],
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.all(16.0),
                      itemCount: campaigns.length,
                      itemBuilder: (context, idx) {
                        final campaign = campaigns[idx];
                        // Check if this creator already applied
                        final alreadyApplied = campaign.proposals.any((p) => p.creatorId == "1");

                        return Container(
                          margin: const EdgeInsets.only(bottom: 16.0),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Colors.grey[200]!),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.03),
                                blurRadius: 8,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
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
                                        color: AppColors.allPrimaryColor.withOpacity(0.1),
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                      child: Text(
                                        campaign.platform,
                                        style: const TextStyle(
                                          fontFamily: 'Poppins',
                                          fontSize: 10,
                                          fontWeight: FontWeight.bold,
                                          color: AppColors.allPrimaryColor,
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
                                    color: AppColors.appThemeColor, 
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  campaign.description,
                                  maxLines: 3,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    fontFamily: 'Poppins', 
                                    fontSize: 12, 
                                    color: Colors.black54, 
                                    height: 1.4,
                                  ),
                                ),
                                const SizedBox(height: 12),
                                _buildInfoLabel(Icons.military_tech_rounded, "Req: ${campaign.requirements}"),
                                const Divider(color: Colors.black12, height: 24),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "Est. Budget: \$${campaign.budget.toStringAsFixed(0)}",
                                      style: TextStyle(
                                        fontFamily: 'Poppins',
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.green[700],
                                      ),
                                    ),
                                    ElevatedButton(
                                      onPressed: alreadyApplied
                                          ? null
                                          : () {
                                              // Navigate to proposal pitch screen
                                              Get.toNamed(Routes.PROPOSAL, arguments: campaign);
                                            },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: alreadyApplied ? Colors.grey[350] : AppColors.allPrimaryColor,
                                        foregroundColor: alreadyApplied ? Colors.black54 : Colors.white,
                                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                                        elevation: 0,
                                      ),
                                      child: Text(alreadyApplied ? "Applied" : "Apply Now"),
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
    );
  }

  Widget _buildInfoLabel(IconData icon, String label) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 14, color: Colors.black54),
        const SizedBox(width: 4),
        Text(
          label,
          style: const TextStyle(fontFamily: 'Poppins', fontSize: 11, color: Colors.black54),
        ),
      ],
    );
  }
}
