import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:brand_bridge/constants/app_colors.dart';
import 'package:brand_bridge/common_wigdets/common_button.dart';
import 'package:brand_bridge/common_wigdets/custom_textfiled.dart';
import 'package:brand_bridge/common_wigdets/user_role.dart';
import 'package:brand_bridge/provider/marketplace_provider.dart';
import 'package:brand_bridge/route/app_pages.dart';

class ProposalScreen extends StatefulWidget {
  const ProposalScreen({super.key});

  @override
  State<ProposalScreen> createState() => _ProposalScreenState();
}

class _ProposalScreenState extends State<ProposalScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _deliveryController = TextEditingController();
  final TextEditingController _messageController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final CampaignModel campaign = ModalRoute.of(context)!.settings.arguments as CampaignModel;
    final marketplace = Provider.of<MarketplaceProvider>(context);
    final isClient = marketplace.currentRole == UserRole.client;

    // Refresh campaign data from provider to show real-time changes
    final activeCampaign = marketplace.campaigns.firstWhere((c) => c.id == campaign.id, orElse: () => campaign);

    return Scaffold(
      backgroundColor: AppColors.cF5F6FA,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: AppColors.allPrimaryColor),
        title: Text(
          isClient ? "Manage Proposals" : "Submit Proposal",
          style: const TextStyle(
            fontFamily: 'Poppins',
            fontWeight: FontWeight.bold,
            fontSize: 16,
            color: AppColors.allPrimaryColor,
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Campaign overview card
              Card(
                color: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        activeCampaign.title,
                        style: const TextStyle(fontFamily: 'Poppins', fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.allPrimaryColor),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        "Product: ${activeCampaign.productName} • Platform: ${activeCampaign.platform}",
                        style: const TextStyle(fontFamily: 'Poppins', fontSize: 12, color: AppColors.appThemeColor, fontWeight: FontWeight.bold),
                      ),
                      const Divider(height: 20),
                      const Text(
                        "Description:",
                        style: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.bold, fontSize: 12, color: AppColors.allPrimaryColor),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        activeCampaign.description,
                        style: const TextStyle(fontFamily: 'Poppins', fontSize: 13, color: AppColors.c6C6C6C, height: 1.4),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Est. Budget: \$${activeCampaign.budget.toStringAsFixed(0)}",
                            style: const TextStyle(fontFamily: 'Poppins', fontSize: 14, fontWeight: FontWeight.bold, color: Colors.green),
                          ),
                          Text(
                            "Deadline: ${activeCampaign.deadline}",
                            style: const TextStyle(fontFamily: 'Poppins', fontSize: 12, color: AppColors.c6C6C6C),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Dynamic Layout depending on UserRole
              if (!isClient) ...[
                // Influencer submitting a pitch
                const Text(
                  "Your Pitch Details",
                  style: TextStyle(fontFamily: 'Poppins', fontSize: 15, fontWeight: FontWeight.bold, color: AppColors.allPrimaryColor),
                ),
                const SizedBox(height: 12),
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      CustomTextFormField(
                        controller: _priceController,
                        labelText: "Your Bid Price (\$ USD)",
                        hintText: "e.g. 450",
                        keyboardType: TextInputType.number,
                        validator: (val) => val == null || double.tryParse(val) == null ? "Enter a valid bid price" : null,
                      ),
                      const SizedBox(height: 16),
                      CustomTextFormField(
                        controller: _deliveryController,
                        labelText: "Estimated Delivery Days",
                        hintText: "e.g. 5 days",
                        validator: (val) => val == null || val.isEmpty ? "Enter delivery time" : null,
                      ),
                      const SizedBox(height: 16),
                      CustomTextFormField(
                        controller: _messageController,
                        labelText: "Cover Message",
                        hintText: "Pitch your ideas, state why you're a great fit...",
                        maxLine: 3,
                        validator: (val) => val == null || val.isEmpty ? "Enter a cover pitch message" : null,
                      ),
                      const SizedBox(height: 24),
                      CommonButton(
                        text: "Submit Proposal Pitch",
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            final proposal = ProposalModel(
                              id: "prop_${marketplace.userName}_${campaign.id}",
                              campaignId: campaign.id,
                              creatorId: "1", // Sabbir TechBytes Mock ID
                              creatorName: marketplace.userName,
                              creatorAvatar: marketplace.creatorAvatar,
                              price: double.parse(_priceController.text.trim()),
                              deliveryTime: _deliveryController.text.trim(),
                              message: _messageController.text.trim(),
                              status: "pending",
                            );
                            marketplace.submitProposal(campaign.id, proposal);
                            Get.back();
                            Get.snackbar("Success", "Proposal submitted to brand!",
                                backgroundColor: Colors.green, colorText: Colors.white);
                          }
                        },
                        backgroundColor: AppColors.appThemeColor,
                      ),
                    ],
                  ),
                ),
              ] else ...[
                // Brand Client reviewing proposals
                const Text(
                  "Proposals Received",
                  style: TextStyle(fontFamily: 'Poppins', fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.allPrimaryColor),
                ),
                const SizedBox(height: 12),
                activeCampaign.proposals.isEmpty
                    ? Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Center(
                          child: Text("No proposals received for this campaign yet.", style: TextStyle(fontFamily: 'Poppins', color: Colors.grey)),
                        ),
                      )
                    : ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: activeCampaign.proposals.length,
                        itemBuilder: (context, idx) {
                          final prop = activeCampaign.proposals[idx];

                          return Card(
                            margin: const EdgeInsets.only(bottom: 14),
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
                                        radius: 20,
                                        backgroundImage: NetworkImage(prop.creatorAvatar),
                                      ),
                                      const SizedBox(width: 12),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              prop.creatorName,
                                              style: const TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.bold, fontSize: 14),
                                            ),
                                            Text(
                                              "Delivery: ${prop.deliveryTime}",
                                              style: const TextStyle(fontFamily: 'Poppins', fontSize: 11, color: AppColors.c6C6C6C),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Text(
                                        "\$${prop.price.toStringAsFixed(0)}",
                                        style: const TextStyle(fontFamily: 'Poppins', fontSize: 16, fontWeight: FontWeight.bold, color: Colors.green),
                                      ),
                                    ],
                                  ),
                                  const Divider(height: 20),
                                  const Text(
                                    "Proposal Message:",
                                    style: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.bold, fontSize: 11, color: AppColors.allPrimaryColor),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    prop.message,
                                    style: const TextStyle(fontFamily: 'Poppins', fontSize: 12, color: AppColors.c6C6C6C, height: 1.4),
                                  ),
                                  const SizedBox(height: 16),
                                  if (prop.status == 'pending')
                                    Row(
                                      children: [
                                        Expanded(
                                          child: OutlinedButton(
                                            onPressed: () {
                                              marketplace.updateProposalStatus(campaign.id, prop.id, "rejected");
                                            },
                                            style: OutlinedButton.styleFrom(
                                              side: const BorderSide(color: Colors.red),
                                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                            ),
                                            child: const Text("Decline", style: TextStyle(color: Colors.red)),
                                          ),
                                        ),
                                        const SizedBox(width: 12),
                                        Expanded(
                                          child: ElevatedButton(
                                            onPressed: () {
                                              marketplace.updateProposalStatus(campaign.id, prop.id, "accepted");
                                              
                                              // Accept details and launch direct chat
                                              Get.toNamed(Routes.CHAT, arguments: {
                                                "chatId": "${campaign.id}_${prop.creatorId}",
                                                "campaignTitle": campaign.title,
                                                "partnerName": prop.creatorName,
                                                "partnerRole": UserRole.creator,
                                              });
                                            },
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: Colors.green,
                                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                            ),
                                            child: const Text("Accept Pitch"),
                                          ),
                                        ),
                                      ],
                                    )
                                  else
                                    Align(
                                      alignment: Alignment.centerRight,
                                      child: Text(
                                        prop.status.toUpperCase(),
                                        style: TextStyle(
                                          fontFamily: 'Poppins',
                                          fontWeight: FontWeight.bold,
                                          color: prop.status == 'accepted' ? Colors.green : Colors.red,
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
