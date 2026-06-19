import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:get/get.dart';
import 'package:brand_bridge/constants/app_colors.dart';
import 'package:brand_bridge/common_wigdets/user_role.dart';
import 'package:brand_bridge/common_wigdets/common_button.dart';
import 'package:brand_bridge/common_wigdets/custom_textfield_only.dart';
import 'package:brand_bridge/provider/marketplace_provider.dart';

class WalletScreen extends StatefulWidget {
  const WalletScreen({super.key});

  @override
  State<WalletScreen> createState() => _WalletScreenState();
}

class _WalletScreenState extends State<WalletScreen> {
  final TextEditingController _depositController = TextEditingController();
  final TextEditingController _withdrawAccountController = TextEditingController();
  String _selectedWithdrawMethod = "bkash";
  String _clientTab = "deposit";

  @override
  void dispose() {
    _depositController.dispose();
    _withdrawAccountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final marketplace = Provider.of<MarketplaceProvider>(context);
    final isClient = marketplace.currentRole == UserRole.client;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.allPrimaryColor),
          onPressed: () => Get.back(),
        ),
        title: Text(
          isClient ? "Billing & Payments" : "Earnings & Payouts",
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
              // Fiverr-Style Core Balance Card
              _buildCoreBalanceCard(marketplace, isClient),
              const SizedBox(height: 24),

              // Interactive Action Sections
              if (isClient) ...[
                _buildClientDepositSection(marketplace),
                const SizedBox(height: 20),
                _buildClientPaymentMethodsSection(context),
              ] else ...[
                _buildCreatorWithdrawalSection(marketplace),
              ],
              const SizedBox(height: 28),

              // Transaction History
              const Text(
                "Transaction History",
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: AppColors.allPrimaryColor,
                ),
              ),
              const SizedBox(height: 10),
              _buildTransactionHistory(marketplace, isClient),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCoreBalanceCard(MarketplaceProvider marketplace, bool isClient) {
    final double usdVal = isClient ? marketplace.clientDepositBalance : marketplace.creatorAvailableBalance;
    final double bdtVal = usdVal * 118.0;

    final primaryVal = "\$${usdVal.toStringAsFixed(2)}";
    final conversionVal = "৳${bdtVal.toStringAsFixed(0)} BDT";
    final label = isClient ? "Available deposit balance" : "Available for withdrawal";

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: LinearGradient(
          colors: isClient
              ? [AppColors.allPrimaryColor, AppColors.appThemeColor]
              : [Colors.green[800]!, Colors.teal[600]!],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: (isClient ? AppColors.allPrimaryColor : Colors.green).withOpacity(0.2),
            blurRadius: 12,
            offset: const Offset(0, 6),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label.toUpperCase(),
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 10,
              fontWeight: FontWeight.bold,
              color: Colors.white.withOpacity(0.8),
              letterSpacing: 1.0,
            ),
          ),
          const SizedBox(height: 6),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(
                primaryVal,
                style: const TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              Text(
                conversionVal,
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.white.withOpacity(0.9),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          const Divider(color: Colors.white24, height: 1),
          const SizedBox(height: 16),
          // Sub Stats Row
          if (isClient)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildCardStat("Active Escrow", "\$${marketplace.clientActiveEscrow.toStringAsFixed(0)} (৳${(marketplace.clientActiveEscrow * 118).toStringAsFixed(0)})"),
                _buildCardStat("Lifetime Spent", "\$${marketplace.clientLifetimeSpent.toStringAsFixed(0)} (৳${(marketplace.clientLifetimeSpent * 118).toStringAsFixed(0)})"),
              ],
            )
          else
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildCardStat("Pending Clear", "\$${marketplace.creatorPendingClearance.toStringAsFixed(0)} (৳${(marketplace.creatorPendingClearance * 118).toStringAsFixed(0)})"),
                _buildCardStat("Net Income", "\$${marketplace.creatorNetEarnings.toStringAsFixed(0)} (৳${(marketplace.creatorNetEarnings * 118).toStringAsFixed(0)})"),
                _buildCardStat("Withdrawn", "\$${marketplace.creatorWithdrawnBalance.toStringAsFixed(0)} (৳${(marketplace.creatorWithdrawnBalance * 118).toStringAsFixed(0)})"),
              ],
            ),
        ],
      ),
    );
  }

  Widget _buildCardStat(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontFamily: 'Poppins',
            fontSize: 9,
            color: Colors.white.withOpacity(0.7),
          ),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: const TextStyle(
            fontFamily: 'Poppins',
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ],
    );
  }

  Widget _buildClientDepositSection(MarketplaceProvider marketplace) {
    final isDeposit = _clientTab == "deposit";
    final double usdVal = marketplace.clientDepositBalance;
    final double bdtVal = usdVal * 118.0;

    return Card(
      color: AppColors.cF5F6FA,
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Tabs to switch between Deposit and Withdraw
            Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () => setState(() => _clientTab = "deposit"),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      decoration: BoxDecoration(
                        color: isDeposit ? AppColors.allPrimaryColor : Colors.white,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: isDeposit ? Colors.transparent : Colors.grey[200]!),
                      ),
                      child: Center(
                        child: Text(
                          "Deposit",
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: isDeposit ? Colors.white : Colors.black87,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: GestureDetector(
                    onTap: () => setState(() => _clientTab = "withdraw"),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      decoration: BoxDecoration(
                        color: !isDeposit ? AppColors.allPrimaryColor : Colors.white,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: !isDeposit ? Colors.transparent : Colors.grey[200]!),
                      ),
                      child: Center(
                        child: Text(
                          "Withdraw",
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: !isDeposit ? Colors.white : Colors.black87,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            if (isDeposit) ...[
              const Row(
                children: [
                  Icon(Icons.account_balance_wallet_rounded, color: AppColors.appThemeColor),
                  SizedBox(width: 8),
                  Text(
                    "Deposit Wallet Payouts",
                    style: TextStyle(fontFamily: 'Poppins', fontSize: 13.5, fontWeight: FontWeight.bold, color: AppColors.allPrimaryColor),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              CustomTextFormFieldOnly(
                controller: _depositController,
                hintText: "Enter deposit amount (\$ USD)",
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  _buildQuickAmountButton(r"+$50", 50.0),
                  const SizedBox(width: 8),
                  _buildQuickAmountButton(r"+$100", 100.0),
                  const SizedBox(width: 8),
                  _buildQuickAmountButton(r"+$250", 250.0),
                ],
              ),
              const SizedBox(height: 16),
              CommonButton(
                text: "Fund Available Payout Balance",
                onPressed: () {
                  final text = _depositController.text.trim();
                  final amount = double.tryParse(text) ?? 0.0;
                  if (amount <= 0) return;

                  marketplace.depositClientFunds(amount);
                  _depositController.clear();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text("Successfully deposited \$${amount.toStringAsFixed(0)} (৳${(amount * 118).toStringAsFixed(0)} BDT) to platform wallet!"),
                      backgroundColor: Colors.green,
                    ),
                  );
                },
                backgroundColor: AppColors.allPrimaryColor,
              ),
            ] else ...[
              // Client withdraw refund
              const Row(
                children: [
                  Icon(Icons.payments_rounded, color: Colors.orange),
                  SizedBox(width: 8),
                  Text(
                    "Withdraw Refund Payout",
                    style: TextStyle(fontFamily: 'Poppins', fontSize: 13.5, fontWeight: FontWeight.bold, color: AppColors.allPrimaryColor),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              const Text(
                "Select Refund Payout Method",
                style: TextStyle(fontFamily: 'Poppins', fontSize: 11.5, color: Colors.grey, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  _buildWithdrawTab("bkash", "bKash (BDT)"),
                  const SizedBox(width: 10),
                  _buildWithdrawTab("bank", "Bank Transfer"),
                ],
              ),
              const SizedBox(height: 12),
              CustomTextFormFieldOnly(
                controller: _withdrawAccountController,
                hintText: _selectedWithdrawMethod == "bkash" ? "bKash Mobile Account Number (BDT)" : "IBAN / Bank Routing Number",
                keyboardType: TextInputType.text,
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Maximum Refundable",
                    style: TextStyle(fontFamily: 'Poppins', fontSize: 11.5, color: Colors.grey, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    "৳${bdtVal.toStringAsFixed(0)} BDT",
                    style: const TextStyle(fontFamily: 'Poppins', fontSize: 14, color: Colors.orange, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              CommonButton(
                text: usdVal > 0.0
                    ? "Withdraw ৳${bdtVal.toStringAsFixed(0)} BDT Now"
                    : "No Funds Available for Refund",
                onPressed: usdVal > 0.0
                    ? () {
                        final account = _withdrawAccountController.text.trim();
                        if (account.isEmpty) {
                          Get.snackbar("Error", "Please input withdrawal account details first.");
                          return;
                        }
                        
                        marketplace.withdrawClientFunds(usdVal);
                        _withdrawAccountController.clear();
                        
                        Get.snackbar(
                          "Refund Request Success",
                          "Refund of ৳${bdtVal.toStringAsFixed(0)} BDT (\$${usdVal.toStringAsFixed(0)} USD) initiated via ${_selectedWithdrawMethod.toUpperCase()}.",
                          backgroundColor: Colors.green,
                          colorText: Colors.white,
                        );
                      }
                    : () {},
                backgroundColor: usdVal > 0.0 ? Colors.orange[800]! : Colors.grey,
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildQuickAmountButton(String label, double val) {
    return Expanded(
      child: OutlinedButton(
        onPressed: () {
          _depositController.text = val.toStringAsFixed(0);
        },
        style: OutlinedButton.styleFrom(
          side: BorderSide(color: AppColors.appThemeColor.withOpacity(0.3)),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          backgroundColor: Colors.white,
        ),
        child: Text(label, style: const TextStyle(fontSize: 11, color: AppColors.appThemeColor)),
      ),
    );
  }

  Widget _buildClientPaymentMethodsSection(BuildContext context) {
    return Card(
      color: Colors.white,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: Colors.grey[200]!),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Row(
                  children: [
                    Icon(Icons.credit_card_rounded, color: AppColors.appThemeColor),
                    SizedBox(width: 8),
                    Text(
                      "Saved Payment Methods",
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 13.5,
                        fontWeight: FontWeight.bold,
                        color: AppColors.allPrimaryColor,
                      ),
                    ),
                  ],
                ),
                TextButton(
                  onPressed: () => _showAddPaymentMethodDialog(context),
                  child: const Text(
                    "+ Add New",
                    style: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.bold, fontSize: 11.5),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            _buildSavedPaymentItem(
              icon: Icons.phone_android_rounded,
              title: "bKash Personal Wallet",
              number: "01755-XXX920",
              isPrimary: true,
            ),
            const Divider(height: 20),
            _buildSavedPaymentItem(
              icon: Icons.credit_card_rounded,
              title: "Visa Credit Card",
              number: "**** **** **** 4242",
              isPrimary: false,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSavedPaymentItem({
    required IconData icon,
    required String title,
    required String number,
    required bool isPrimary,
  }) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: AppColors.appThemeColor.withOpacity(0.06),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: AppColors.appThemeColor, size: 20),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                  color: AppColors.allPrimaryColor,
                ),
              ),
              Text(
                number,
                style: const TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 11,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
        ),
        if (isPrimary)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
            decoration: BoxDecoration(
              color: Colors.green.withOpacity(0.1),
              borderRadius: BorderRadius.circular(4),
            ),
            child: const Text(
              "PRIMARY",
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 8.5,
                fontWeight: FontWeight.bold,
                color: Colors.green,
              ),
            ),
          ),
      ],
    );
  }

  void _showAddPaymentMethodDialog(BuildContext context) {
    String selectedType = "bkash";
    final TextEditingController accountController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              backgroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              title: const Text(
                "Add Payment Method",
                style: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.bold, fontSize: 15),
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Method Type",
                    style: TextStyle(fontFamily: 'Poppins', fontSize: 11.5, color: Colors.grey, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: ChoiceChip(
                          label: const Text("bKash", style: TextStyle(fontFamily: 'Poppins', fontSize: 11.5)),
                          selected: selectedType == "bkash",
                          onSelected: (val) {
                            if (val) setDialogState(() => selectedType = "bkash");
                          },
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: ChoiceChip(
                          label: const Text("Nagad", style: TextStyle(fontFamily: 'Poppins', fontSize: 11.5)),
                          selected: selectedType == "nagad",
                          onSelected: (val) {
                            if (val) setDialogState(() => selectedType = "nagad");
                          },
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: ChoiceChip(
                          label: const Text("Card", style: TextStyle(fontFamily: 'Poppins', fontSize: 11.5)),
                          selected: selectedType == "card",
                          onSelected: (val) {
                            if (val) setDialogState(() => selectedType = "card");
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    selectedType == "card" ? "Card Details" : "Mobile Wallet Number",
                    style: const TextStyle(fontFamily: 'Poppins', fontSize: 11.5, color: Colors.grey, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  CustomTextFormFieldOnly(
                    controller: accountController,
                    hintText: selectedType == "card" ? "Card Number (16 digits)" : "Mobile Number (e.g. 017xxxxxxxx)",
                    keyboardType: selectedType == "card" ? TextInputType.number : TextInputType.phone,
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text("Cancel"),
                ),
                ElevatedButton(
                  onPressed: () {
                    final detail = accountController.text.trim();
                    if (detail.isEmpty) return;
                    Navigator.pop(context);
                    Get.snackbar(
                      "Success",
                      "Added new $selectedType payment method successfully!",
                      backgroundColor: Colors.green,
                      colorText: Colors.white,
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.allPrimaryColor,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  child: const Text("Save Method", style: TextStyle(color: Colors.white)),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Widget _buildCreatorWithdrawalSection(MarketplaceProvider marketplace) {
    final double usdVal = marketplace.creatorAvailableBalance;
    final double bdtVal = usdVal * 118.0;
    final hasBalance = usdVal > 0.0;

    return Card(
      color: AppColors.cF5F6FA,
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                Icon(Icons.payments_rounded, color: Colors.green),
                SizedBox(width: 8),
                Text(
                  "Withdraw Earnings Payout",
                  style: TextStyle(fontFamily: 'Poppins', fontSize: 13.5, fontWeight: FontWeight.bold, color: AppColors.allPrimaryColor),
                ),
              ],
            ),
            const SizedBox(height: 16),
            const Text(
              "Select Payout Method",
              style: TextStyle(fontFamily: 'Poppins', fontSize: 11.5, color: Colors.grey, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                _buildWithdrawTab("bkash", "bKash (BDT)"),
                const SizedBox(width: 10),
                _buildWithdrawTab("bank", "Bank Transfer"),
              ],
            ),
            const SizedBox(height: 12),
            CustomTextFormFieldOnly(
              controller: _withdrawAccountController,
              hintText: _selectedWithdrawMethod == "bkash" ? "bKash Mobile Account Number (BDT)" : "IBAN / Bank Routing Number",
              keyboardType: TextInputType.text,
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Withdrawal Amount",
                  style: TextStyle(fontFamily: 'Poppins', fontSize: 11.5, color: Colors.grey, fontWeight: FontWeight.bold),
                ),
                Text(
                  "৳${bdtVal.toStringAsFixed(0)} BDT",
                  style: const TextStyle(fontFamily: 'Poppins', fontSize: 14, color: Colors.green, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 16),
            CommonButton(
              text: hasBalance
                  ? "Withdraw ৳${bdtVal.toStringAsFixed(0)} BDT Now"
                  : "Insufficient Available Balance",
              onPressed: hasBalance
                  ? () {
                      final account = _withdrawAccountController.text.trim();
                      if (account.isEmpty) {
                        Get.snackbar("Error", "Please input withdrawal account details first.");
                        return;
                      }
                      
                      marketplace.withdrawCreatorEarnings(usdVal);
                      _withdrawAccountController.clear();
                      
                      Get.snackbar(
                        "Withdrawal Processed",
                        "Payout of ৳${bdtVal.toStringAsFixed(0)} BDT (\$${usdVal.toStringAsFixed(0)} USD) initiated via ${_selectedWithdrawMethod.toUpperCase()}.",
                        backgroundColor: Colors.green,
                        colorText: Colors.white,
                      );
                    }
                  : () {},
              backgroundColor: hasBalance ? Colors.green[800]! : Colors.grey,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWithdrawTab(String id, String label) {
    final isSelected = _selectedWithdrawMethod == id;
    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            _selectedWithdrawMethod = id;
          });
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
            color: isSelected ? Colors.green[800] : Colors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: isSelected ? Colors.transparent : Colors.grey[200]!),
          ),
          child: Center(
            child: Text(
              label,
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 11.5,
                fontWeight: FontWeight.bold,
                color: isSelected ? Colors.white : Colors.black87,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTransactionHistory(MarketplaceProvider marketplace, bool isClient) {
    final List<_TxnItem> txns = [];

    // Dynamically generate simulated history based on order and wallet values
    if (isClient) {
      if (marketplace.clientDepositBalance > 150.0) {
        final double amountUsd = marketplace.clientDepositBalance - 150.0;
        final double amountBdt = amountUsd * 118.0;
        txns.add(_TxnItem(
          title: "Wallet Deposit",
          desc: "Funded via secure gateway (৳${amountBdt.toStringAsFixed(0)} BDT)",
          amount: "+ \$${amountUsd.toStringAsFixed(0)}",
          color: Colors.green,
          date: "Today",
        ));
      } else if (marketplace.clientDepositBalance < 150.0) {
        final double withdrawnUsd = 150.0 - marketplace.clientDepositBalance;
        final double withdrawnBdt = withdrawnUsd * 118.0;
        txns.add(_TxnItem(
          title: "Deposit Refund Payout",
          desc: "Withdrawn via $_selectedWithdrawMethod (৳${withdrawnBdt.toStringAsFixed(0)} BDT)",
          amount: "- \$${withdrawnUsd.toStringAsFixed(0)}",
          color: Colors.red,
          date: "Today",
        ));
      }
      
      // Active orders transaction mockups
      for (var order in marketplace.orders) {
        final double priceBdt = order.price * 118.0;
        if (order.status == 'in_progress' || order.status == 'delivered') {
          txns.add(_TxnItem(
            title: "Escrow Held Payout",
            desc: "Locked for order: ${order.orderId} (৳${priceBdt.toStringAsFixed(0)} BDT)",
            amount: "- \$${order.price.toStringAsFixed(0)}",
            color: Colors.orange,
            date: "Recent",
          ));
        } else if (order.status == 'completed') {
          txns.add(_TxnItem(
            title: "Released Payment Payout",
            desc: "Completed order: ${order.orderId} (৳${priceBdt.toStringAsFixed(0)} BDT)",
            amount: "- \$${order.price.toStringAsFixed(0)}",
            color: Colors.grey,
            date: "Completed",
          ));
        }
      }
      // base mock
      txns.add(_TxnItem(
        title: "Campaign Budget Hold",
        desc: "Funded escrow for Android App Launch (৳59,000 BDT)",
        amount: "- \$500.00",
        color: Colors.grey,
        date: "1 week ago",
      ));
    } else {
      // Creator history
      if (marketplace.creatorWithdrawnBalance > 450.0) {
        final double amountUsd = marketplace.creatorWithdrawnBalance - 450.0;
        final double amountBdt = amountUsd * 118.0;
        txns.add(_TxnItem(
          title: "Earning Withdrawal",
          desc: "Withdrawn via $_selectedWithdrawMethod (৳${amountBdt.toStringAsFixed(0)} BDT)",
          amount: "- \$${amountUsd.toStringAsFixed(0)}",
          color: Colors.red,
          date: "Today",
        ));
      }

      for (var order in marketplace.orders) {
        if (order.creatorName == "Sabbir TechBytes") {
          final double priceBdt = order.price * 118.0;
          if (order.status == 'completed') {
            txns.add(_TxnItem(
              title: "Cleared Payout Payout",
              desc: "From completed order: ${order.orderId} (৳${priceBdt.toStringAsFixed(0)} BDT)",
              amount: "+ \$${order.price.toStringAsFixed(0)}",
              color: Colors.green,
              date: "Cleared",
            ));
          } else if (order.status == 'in_progress' || order.status == 'delivered') {
            txns.add(_TxnItem(
              title: "Pending Clearance Payout",
              desc: "Escrow held for order: ${order.orderId} (৳${priceBdt.toStringAsFixed(0)} BDT)",
              amount: "+ \$${order.price.toStringAsFixed(0)}",
              color: Colors.orange,
              date: "Pending",
            ));
          }
        }
      }

      txns.add(_TxnItem(
        title: "Cleared Payout Payout",
        desc: "Completed clothing sponsor campaign (৳29,500 BDT)",
        amount: "+ \$250.00",
        color: Colors.green,
        date: "2 weeks ago",
      ));
      txns.add(_TxnItem(
        title: "Withdrawn via bKash",
        desc: "External payout processed successfully (৳53,100 BDT)",
        amount: "- \$450.00",
        color: Colors.red,
        date: "3 weeks ago",
      ));
    }

    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: txns.length,
      separatorBuilder: (context, idx) => Divider(color: Colors.grey[100], height: 1),
      itemBuilder: (context, idx) {
        final txn = txns[idx];
        return ListTile(
          contentPadding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
          title: Text(
            txn.title,
            style: const TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.bold, fontSize: 13, color: AppColors.allPrimaryColor),
          ),
          subtitle: Text(
            "${txn.desc} • ${txn.date}",
            style: const TextStyle(fontFamily: 'Poppins', fontSize: 10.5, color: Colors.grey),
          ),
          trailing: Text(
            txn.amount,
            style: TextStyle(
              fontFamily: 'Poppins',
              fontWeight: FontWeight.bold,
              fontSize: 13.5,
              color: txn.color,
            ),
          ),
        );
      },
    );
  }
}

class _TxnItem {
  final String title;
  final String desc;
  final String amount;
  final Color color;
  final String date;

  _TxnItem({
    required this.title,
    required this.desc,
    required this.amount,
    required this.color,
    required this.date,
  });
}
