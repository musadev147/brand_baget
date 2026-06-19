import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:brand_bridge/constants/app_colors.dart';
import 'package:brand_bridge/common_wigdets/common_button.dart';
import 'package:brand_bridge/common_wigdets/custom_textfield_only.dart';
import 'package:brand_bridge/provider/marketplace_provider.dart';

class PaymentScreen extends StatefulWidget {
  const PaymentScreen({super.key});

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  String _selectedMethod = "bkash";
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _pinController = TextEditingController();
  bool _isProcessing = false;

  void _processEscrowPayment(MarketplaceProvider provider, String chatId, String messageId) async {
    setState(() {
      _isProcessing = true;
    });

    // Simulate payment gateway delay
    await Future.delayed(const Duration(seconds: 2));

    if (mounted) {
      setState(() {
        _isProcessing = false;
      });

      // Update contract status to 'paid'
      provider.respondToContract(chatId, messageId, "paid");
      
      Get.back();
      Get.snackbar(
        "Payment Escrow Funded",
        "Successfully held funds. The creator has been notified to start work.",
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    final String chatId = args["chatId"];
    final String messageId = args["messageId"];
    final double amount = args["amount"];
    final String title = args["title"];

    final marketplace = Provider.of<MarketplaceProvider>(context, listen: false);

    return Scaffold(
      backgroundColor: AppColors.cF5F6FA,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: AppColors.allPrimaryColor),
        title: const Text(
          "Secure Escrow Payment",
          style: TextStyle(
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
              // Payment Summary
              Card(
                color: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text("Deal Details", style: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.bold, fontSize: 12, color: AppColors.c6C6C6C)),
                      const SizedBox(height: 6),
                      Text(title, style: const TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.bold, fontSize: 15, color: AppColors.allPrimaryColor)),
                      const Divider(height: 24),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text("Total Funding Amount", style: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.bold, fontSize: 13)),
                          Text(
                            "\$${amount.toStringAsFixed(0)}",
                            style: const TextStyle(fontFamily: 'Poppins', fontSize: 20, fontWeight: FontWeight.bold, color: Colors.green),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Text(
                        "Note: Money is securely held by CreatorHub Platform and only released once you verify completion.",
                        style: TextStyle(fontFamily: 'Poppins', fontSize: 11, color: AppColors.c6C6C6C.withOpacity(0.8), height: 1.3),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),

              const Text("Select Payment Method", style: TextStyle(fontFamily: 'Poppins', fontSize: 15, fontWeight: FontWeight.bold, color: AppColors.allPrimaryColor)),
              const SizedBox(height: 12),

              // Payment options row
              Row(
                children: [
                  _buildMethodCard("bkash", "bKash", Colors.pink),
                  const SizedBox(width: 12),
                  _buildMethodCard("nagad", "Nagad", Colors.orange),
                  const SizedBox(width: 12),
                  _buildMethodCard("card", "Card / Stripe", AppColors.appThemeColor),
                ],
              ),
              const SizedBox(height: 24),

              // Dynamic Payment Inputs
              if (_selectedMethod == 'bkash' || _selectedMethod == 'nagad') ...[
                Card(
                  color: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Pay with ${_selectedMethod == 'bkash' ? 'bKash' : 'Nagad'} Account",
                          style: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.bold, fontSize: 13, color: _selectedMethod == 'bkash' ? Colors.pink : Colors.orange),
                        ),
                        const SizedBox(height: 16),
                        CustomTextFormFieldOnly(
                          controller: _phoneController,
                          hintText: "Account Mobile Number (e.g. 017xxxxxxxx)",
                          keyboardType: TextInputType.phone,
                        ),
                        const SizedBox(height: 12),
                        CustomTextFormFieldOnly(
                          controller: _pinController,
                          hintText: "Enter Gateway PIN",
                          obscureText: true,
                        ),
                      ],
                    ),
                  ),
                ),
              ] else ...[
                Card(
                  color: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Pay with Credit / Debit Card",
                          style: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.bold, fontSize: 13, color: AppColors.allPrimaryColor),
                        ),
                        const SizedBox(height: 16),
                        CustomTextFormFieldOnly(
                          hintText: "Card Holder Name",
                        ),
                        const SizedBox(height: 12),
                        CustomTextFormFieldOnly(
                          hintText: "Card Number (16 Digits)",
                          keyboardType: TextInputType.number,
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Expanded(
                              child: CustomTextFormFieldOnly(hintText: "Expiry (MM/YY)"),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: CustomTextFormFieldOnly(hintText: "CVV"),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
              const SizedBox(height: 36),

              _isProcessing
                  ? const Center(
                      child: Column(
                        children: [
                          CircularProgressIndicator(),
                          SizedBox(height: 12),
                          Text("Connecting to secure gateway...", style: TextStyle(fontFamily: 'Poppins', fontSize: 13, color: AppColors.c6C6C6C)),
                        ],
                      ),
                    )
                  : CommonButton(
                      text: "Confirm & Fund \$${amount.toStringAsFixed(0)}",
                      onPressed: () => _processEscrowPayment(marketplace, chatId, messageId),
                      backgroundColor: AppColors.allPrimaryColor,
                    ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMethodCard(String id, String label, Color accentColor) {
    final isSelected = _selectedMethod == id;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _selectedMethod = id),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 14),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: isSelected ? accentColor : Colors.grey.withOpacity(0.2), width: isSelected ? 2 : 1),
          ),
          child: Column(
            children: [
              Icon(
                id == 'card' ? Icons.credit_card : Icons.phone_android,
                color: isSelected ? accentColor : Colors.grey,
                size: 24,
              ),
              const SizedBox(height: 6),
              Text(
                label,
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: isSelected ? accentColor : AppColors.allPrimaryColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
