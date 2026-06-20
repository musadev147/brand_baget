import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:brand_bridge/constants/app_colors.dart';
import 'package:brand_bridge/common_wigdets/user_role.dart';
import 'package:brand_bridge/common_wigdets/common_button.dart';
import 'package:brand_bridge/common_wigdets/custom_textfield_only.dart';
import 'package:brand_bridge/provider/marketplace_provider.dart';
import 'package:brand_bridge/route/app_pages.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final TextEditingController _deliveryController = TextEditingController();

  @override
  void dispose() {
    _deliveryController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final marketplace = Provider.of<MarketplaceProvider>(context);

    return Scaffold(
      backgroundColor: AppColors.cF5F6FA,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: AppColors.allPrimaryColor),
        title: const Text(
          "Settings & Profile",
          style: TextStyle(
            fontFamily: 'Poppins',
            fontWeight: FontWeight.bold,
            fontSize: 16,
            color: AppColors.allPrimaryColor,
          ),
        ),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(20.0),
          children: [
            // User Brief Card
            Card(
              color: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: ListTile(
                onTap: marketplace.currentRole == UserRole.creator
                    ? () {
                        final myCreator = marketplace.creators.firstWhere((c) => c.id == "1");
                        Get.toNamed(Routes.CREATOR_PROFILE, arguments: myCreator);
                      }
                    : null,
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                leading: CircleAvatar(
                  radius: 24,
                  backgroundImage: NetworkImage(
                    marketplace.currentRole == UserRole.client
                        ? "https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?w=150"
                        : marketplace.creatorAvatar,
                  ),
                ),
                title: Row(
                  children: [
                    Text(
                      marketplace.userName,
                      style: const TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.bold, fontSize: 15),
                    ),
                    if (marketplace.isKycVerified) ...[
                      const SizedBox(width: 4),
                      const Icon(Icons.verified, color: Colors.blue, size: 16),
                    ],
                  ],
                ),
                subtitle: Text(
                  marketplace.userEmail,
                  style: const TextStyle(fontFamily: 'Poppins', fontSize: 12, color: AppColors.c6C6C6C),
                ),
                trailing: TextButton(
                  onPressed: () => Get.toNamed(Routes.PROFILE),
                  child: const Text("Edit"),
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Fiverr-Style My Orders Section
            _buildOrdersSection(context, marketplace),
            const SizedBox(height: 24),

            const Text(
              "Account Preferences",
              style: TextStyle(fontFamily: 'Poppins', fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.allPrimaryColor),
            ),
            const SizedBox(height: 10),

            _buildSettingsItem(
              icon: Icons.account_balance_wallet_rounded,
              title: marketplace.currentRole == UserRole.client ? "Billing & Payments" : "Earnings & Payouts",
              subtitle: marketplace.currentRole == UserRole.client
                  ? "Manage deposit balances & billing history"
                  : "Withdraw earnings and track pending clearance (BDT/৳)",
              onTap: () {
                Get.toNamed(Routes.WALLET);
              },
            ),

            _buildSettingsItem(
              icon: Icons.cached_rounded,
              title: "Switch User Role",
              subtitle: "Currently: ${marketplace.currentRole == UserRole.client ? 'Client/Brand' : 'Influencer'}",
              onTap: () {
                Get.offAllNamed(Routes.ROLE_SELECTION);
              },
            ),

            _buildSettingsItem(
              icon: Icons.verified_user_rounded,
              title: "Identity Verification (KYC)",
              subtitle: "Manage and verify your identity documents",
              onTap: () {
                Get.toNamed(Routes.KYC);
              },
            ),

            const SizedBox(height: 24),
            const Text(
              "Support & Legal",
              style: TextStyle(fontFamily: 'Poppins', fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.allPrimaryColor),
            ),
            const SizedBox(height: 10),

            _buildSettingsItem(
              icon: Icons.help_outline_rounded,
              title: "Help Center & FAQs",
              subtitle: "Get answers to payment & platform questions",
              onTap: () {
                Get.snackbar("Help Center", "Opening Help Center Support (Mock)",
                    backgroundColor: AppColors.appThemeColor, colorText: Colors.white);
              },
            ),
            _buildSettingsItem(
              icon: Icons.description_outlined,
              title: "Terms of Service",
              subtitle: "Read escrow agreement policies",
              onTap: () {},
            ),
            _buildSettingsItem(
              icon: Icons.shield_outlined,
              title: "Privacy Policy",
              subtitle: "Learn how we secure your data",
              onTap: () {},
            ),

            const SizedBox(height: 32),
            Card(
              color: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: ListTile(
                onTap: () {
                  Get.offAllNamed(Routes.LOGIN);
                },
                leading: const Icon(Icons.logout_rounded, color: Colors.red),
                title: const Text(
                  "Log Out",
                  style: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.bold, fontSize: 14, color: Colors.red),
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildOrdersSection(BuildContext context, MarketplaceProvider marketplace) {
    final isClient = marketplace.currentRole == UserRole.client;
    final allOrders = marketplace.orders;

    // Filter orders: client sees all, creator sees theirs
    final orders = isClient
        ? allOrders
        : allOrders.where((o) => o.creatorName == "Sabbir TechBytes").toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "My Orders & Tracking",
          style: TextStyle(
            fontFamily: 'Poppins',
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: AppColors.allPrimaryColor,
          ),
        ),
        const SizedBox(height: 10),
        if (orders.isEmpty)
          Card(
            color: Colors.white,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: const Padding(
              padding: EdgeInsets.all(20.0),
              child: Center(
                child: Text(
                  "No active orders found.",
                  style: TextStyle(fontFamily: 'Poppins', fontSize: 12, color: Colors.grey),
                ),
              ),
            ),
          )
        else
          ...orders.map((order) {
            Color statusColor = Colors.orange;
            if (order.status == 'in_progress') statusColor = Colors.blue;
            if (order.status == 'delivered') statusColor = Colors.purple;
            if (order.status == 'completed') statusColor = Colors.green;

            return Card(
              margin: const EdgeInsets.only(bottom: 10),
              color: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: ListTile(
                contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                leading: CircleAvatar(
                  radius: 20,
                  backgroundImage: NetworkImage(order.creatorAvatar),
                  backgroundColor: AppColors.cF5F6FA,
                ),
                title: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: AppColors.cF5F6FA,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        order.orderId,
                        style: const TextStyle(fontSize: 8.5, fontWeight: FontWeight.bold, color: Colors.grey),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: statusColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        order.status.toUpperCase().replaceAll("_", " "),
                        style: TextStyle(fontSize: 8, fontWeight: FontWeight.bold, color: statusColor),
                      ),
                    ),
                  ],
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 4),
                    Text(
                      order.title,
                      style: const TextStyle(fontFamily: 'Poppins', fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.allPrimaryColor),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      "\$${order.price.toStringAsFixed(0)} • Delivery: ${order.deliveryTime}",
                      style: const TextStyle(fontFamily: 'Poppins', fontSize: 10.5, color: Colors.grey),
                    ),
                  ],
                ),
                trailing: const Icon(Icons.track_changes_rounded, color: AppColors.appThemeColor, size: 20),
                onTap: () {
                  _showOrderTrackingSheet(context, marketplace, order);
                },
              ),
            );
          }).toList(),
      ],
    );
  }

  void _showOrderTrackingSheet(BuildContext context, MarketplaceProvider marketplace, OrderModel order) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            // Fetch updated order info from provider inside builder
            final currentOrder = marketplace.orders.firstWhere((o) => o.orderId == order.orderId, orElse: () => order);
            final isClient = marketplace.currentRole == UserRole.client;

            // Compute statuses
            final isOfferAccepted = true;
            final isEscrowFunded = currentOrder.status == 'in_progress' || currentOrder.status == 'delivered' || currentOrder.status == 'completed';
            final isWorkDelivered = currentOrder.status == 'delivered' || currentOrder.status == 'completed';
            final isEscrowReleased = currentOrder.status == 'completed';

            return Padding(
              padding: EdgeInsets.fromLTRB(20, 20, 20, MediaQuery.of(context).viewInsets.bottom + 20),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Handle Bar
                    Center(
                      child: Container(
                        width: 40,
                        height: 5,
                        margin: const EdgeInsets.only(bottom: 16),
                        decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(10)),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Order ID: ${currentOrder.orderId}",
                              style: const TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.bold, fontSize: 15, color: AppColors.allPrimaryColor),
                            ),
                            Text(
                              "Associated Campaign/Gig",
                              style: TextStyle(fontFamily: 'Poppins', fontSize: 10.5, color: Colors.grey[500]),
                            ),
                          ],
                        ),
                        IconButton(
                          icon: const Icon(Icons.chat_bubble_outline_rounded, color: AppColors.appThemeColor),
                          onPressed: () {
                            Navigator.pop(context);
                            // Navigate to chat
                            Get.toNamed(Routes.CHAT_INBOX);
                          },
                        ),
                      ],
                    ),
                    const Divider(height: 20),

                    // Order Info Card
                    Text(
                      currentOrder.title,
                      style: const TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.bold, fontSize: 13.5, color: AppColors.allPrimaryColor),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _buildInfoTile("Deal Price", "\$${currentOrder.price.toStringAsFixed(0)}", Colors.green),
                        _buildInfoTile("Delivery Limit", currentOrder.deliveryTime, Colors.black87),
                        _buildInfoTile("Partner Role", isClient ? "Creator/Influencer" : "Client/Brand", AppColors.appThemeColor),
                      ],
                    ),
                    const SizedBox(height: 24),

                    // Fiverr-Style Order Tracking Timeline
                    const Text(
                      "Order Progress Tracker",
                      style: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.bold, fontSize: 13, color: AppColors.allPrimaryColor),
                    ),
                    const SizedBox(height: 16),
                    _buildTimelineStep("1", "Offer Accepted", "Agreement was accepted by both parties", isOfferAccepted, false),
                    _buildTimelineStep("2", "Escrow Funded", isEscrowFunded ? "Escrow protection funded by Brand" : "Awaiting payment from Brand client", isEscrowFunded, !isEscrowFunded),
                    _buildTimelineStep("3", "Work Delivered", isWorkDelivered ? "Creator submitted content draft links" : "Creator working on custom video/post review", isWorkDelivered, isEscrowFunded && !isWorkDelivered),
                    _buildTimelineStep("4", "Escrow Released", isEscrowReleased ? "Funds released. Order completed!" : "Escrow payout pending client approval", isEscrowReleased, isWorkDelivered && !isEscrowReleased),

                    const Divider(height: 24),

                    // Dynamic Payout Actions Block
                    if (currentOrder.status == 'in_progress' && !isClient) ...[
                      // Creator option to submit work
                      const Text(
                        "Deliver Sponsorship Deliverables",
                        style: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.bold, fontSize: 13, color: AppColors.allPrimaryColor),
                      ),
                      const SizedBox(height: 8),
                      CustomTextFormFieldOnly(
                        controller: _deliveryController,
                        hintText: "Paste review link (e.g. youtube.com/watch?v=xxx)",
                      ),
                      const SizedBox(height: 12),
                      CommonButton(
                        text: "Submit Work to Client",
                        onPressed: () {
                          final notes = _deliveryController.text.trim();
                          if (notes.isEmpty) return;
                          
                          marketplace.deliverOrder(currentOrder.orderId, notes);
                          _deliveryController.clear();
                          setModalState(() {}); // refresh dialog state
                          Get.snackbar(
                            "Deliverables Submitted",
                            "Sponsorship work sent. Client will verify and release payment.",
                            backgroundColor: Colors.purple,
                            colorText: Colors.white,
                          );
                        },
                        backgroundColor: Colors.purple,
                      ),
                    ],

                    if (currentOrder.status == 'delivered') ...[
                      // Display delivery notes
                      Container(
                        padding: const EdgeInsets.all(12),
                        width: double.infinity,
                        decoration: BoxDecoration(color: Colors.purple.withOpacity(0.06), borderRadius: BorderRadius.circular(10)),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Row(
                              children: [
                                Icon(Icons.file_present_rounded, color: Colors.purple, size: 16),
                                SizedBox(width: 6),
                                Text(
                                  "Creator Deliverables Submitted:",
                                  style: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.bold, fontSize: 11, color: Colors.purple),
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Text(
                              currentOrder.deliveryNotes ?? "No notes provided.",
                              style: const TextStyle(fontFamily: 'Poppins', fontSize: 12, color: Colors.black87),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                      if (isClient) ...[
                        // Client option to approve work and release escrow
                        CommonButton(
                          text: "Approve Delivery & Release Payment",
                          onPressed: () {
                            marketplace.approveOrder(currentOrder.orderId);
                            setModalState(() {});
                            Get.snackbar(
                              "Order Completed",
                              "Funds released successfully to Creator!",
                              backgroundColor: Colors.green,
                              colorText: Colors.white,
                            );
                          },
                          backgroundColor: Colors.green,
                        ),
                      ] else ...[
                        const Center(
                          child: Text(
                            "Awaiting Brand client review and payout release.",
                            style: TextStyle(fontFamily: 'Poppins', fontSize: 12, color: Colors.orange, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ],

                    if (currentOrder.status == 'completed') ...[
                      Container(
                        padding: const EdgeInsets.all(12),
                        width: double.infinity,
                        decoration: BoxDecoration(color: Colors.green.withOpacity(0.06), borderRadius: BorderRadius.circular(10)),
                        child: const Row(
                          children: [
                            Icon(Icons.check_circle_rounded, color: Colors.green, size: 20),
                            SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                "Order fully completed. Funds have been safely released from Escrow protection to the Creator's wallet.",
                                style: TextStyle(fontFamily: 'Poppins', fontSize: 11.5, color: Colors.green, fontWeight: FontWeight.w600),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildInfoTile(String label, String value, Color valueColor) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 10, color: Colors.grey)),
        const SizedBox(height: 2),
        Text(
          value,
          style: TextStyle(fontFamily: 'Poppins', fontSize: 12.5, fontWeight: FontWeight.bold, color: valueColor),
        ),
      ],
    );
  }

  Widget _buildTimelineStep(String stepNumber, String title, String subtitle, bool isCompleted, bool isPending) {
    Color stepColor = isCompleted ? Colors.green : (isPending ? Colors.orange : Colors.grey[300]!);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                color: isCompleted ? Colors.green : Colors.white,
                shape: BoxShape.circle,
                border: Border.all(color: stepColor, width: 2),
              ),
              child: Center(
                child: isCompleted
                    ? const Icon(Icons.check, size: 14, color: Colors.white)
                    : Text(stepNumber, style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: stepColor)),
              ),
            ),
            Container(
              width: 2,
              height: 28,
              color: isCompleted ? Colors.green : Colors.grey[200],
            ),
          ],
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: isCompleted ? Colors.black87 : Colors.grey[600],
                ),
              ),
              Text(
                subtitle,
                style: const TextStyle(fontFamily: 'Poppins', fontSize: 10, color: Colors.grey),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSettingsItem({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        onTap: onTap,
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(color: AppColors.appThemeColor.withOpacity(0.06), shape: BoxShape.circle),
          child: Icon(icon, color: AppColors.appThemeColor, size: 20),
        ),
        title: Text(title, style: const TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.bold, fontSize: 13)),
        subtitle: Text(subtitle, style: const TextStyle(fontFamily: 'Poppins', fontSize: 11, color: AppColors.c6C6C6C)),
        trailing: const Icon(Icons.chevron_right, size: 18, color: Colors.grey),
      ),
    );
  }
}
