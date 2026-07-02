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
            const Text(
              "Account Preferences",
              style: TextStyle(fontFamily: 'Poppins', fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.allPrimaryColor),
            ),
            const SizedBox(height: 10),

            _buildSettingsItem(
              icon: Icons.track_changes_rounded,
              title: "Order Tracking",
              subtitle: "Track active sponsorship orders & approve payouts",
              onTap: () {
                Get.toNamed(Routes.ORDER_TRACKING);
              },
            ),

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
              "Security & Authentication",
              style: TextStyle(fontFamily: 'Poppins', fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.allPrimaryColor),
            ),
            const SizedBox(height: 10),

             _buildSettingsItem(
              icon: Icons.security_rounded,
              title: "Two-Step Verification (2FA)",
              subtitle: "Manage fingerprint, face verification, and 2FA options",
              onTap: () {
                Get.toNamed(Routes.TWO_STEP_VERIFICATION);
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

  Widget _buildSwitchSettingsItem({
    required IconData icon,
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: AppColors.appThemeColor.withOpacity(0.06),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: AppColors.appThemeColor, size: 20),
        ),
        title: Text(
          title,
          style: const TextStyle(
            fontFamily: 'Poppins',
            fontWeight: FontWeight.bold,
            fontSize: 13,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: const TextStyle(
            fontFamily: 'Poppins',
            fontSize: 11,
            color: AppColors.c6C6C6C,
          ),
        ),
        trailing: Switch.adaptive(
          value: value,
          onChanged: onChanged,
          activeColor: AppColors.appThemeColor,
        ),
      ),
    );
  }
}
