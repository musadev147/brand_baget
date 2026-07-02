import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:brand_bridge/constants/app_colors.dart';
import 'package:brand_bridge/common_wigdets/user_role.dart';
import 'package:brand_bridge/common_wigdets/common_button.dart';
import 'package:brand_bridge/common_wigdets/custom_textfield_only.dart';
import 'package:brand_bridge/provider/marketplace_provider.dart';
import 'package:brand_bridge/route/app_pages.dart';

class OrderTrackingScreen extends StatefulWidget {
  const OrderTrackingScreen({super.key});

  @override
  State<OrderTrackingScreen> createState() => _OrderTrackingScreenState();
}

class _OrderTrackingScreenState extends State<OrderTrackingScreen> {
  final TextEditingController _deliveryController = TextEditingController();

  void _showRevisionInputDialog(BuildContext context, MarketplaceProvider marketplace, OrderModel order, VoidCallback onSubmitted) {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: const Text(
            "Request Revision",
            style: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.bold, fontSize: 16),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                "Please describe the changes you need the creator to make in detail.",
                style: TextStyle(fontFamily: 'Poppins', fontSize: 11, color: Colors.grey),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: controller,
                maxLines: 3,
                decoration: InputDecoration(
                  hintText: "e.g. Please correct the pricing display and speak louder in the introduction.",
                  hintStyle: const TextStyle(fontFamily: 'Poppins', fontSize: 12),
                  filled: true,
                  fillColor: AppColors.cF4F5F7,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel", style: TextStyle(fontFamily: 'Poppins')),
            ),
            ElevatedButton(
              onPressed: () {
                final notes = controller.text.trim();
                if (notes.isNotEmpty) {
                  marketplace.requestRevision(order.orderId, notes);
                  Navigator.pop(context);
                  Navigator.pop(context);
                  onSubmitted();
                  Get.snackbar(
                    "Revision Requested",
                    "The creator has been notified of your revision requests.",
                    backgroundColor: Colors.red,
                    colorText: Colors.white,
                  );
                }
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              child: const Text("Submit", style: TextStyle(fontFamily: 'Poppins', color: Colors.white)),
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    _deliveryController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final marketplace = Provider.of<MarketplaceProvider>(context);
    final isClient = marketplace.currentRole == UserRole.client;
    final allOrders = marketplace.orders;

    // Filter orders: client sees all, creator sees theirs
    final orders = isClient
        ? allOrders
        : allOrders.where((o) => o.creatorName == "Sabbir TechBytes").toList();

    return Scaffold(
      backgroundColor: AppColors.cF5F6FA,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: AppColors.allPrimaryColor),
        title: const Text(
          "Order Tracking",
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
            // Info Header Card
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [AppColors.allPrimaryColor, Color(0xFF1E293B)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.allPrimaryColor.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                children: [
                  const Icon(Icons.track_changes_rounded, size: 40, color: Colors.white),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Escrow Order Tracking",
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          isClient
                              ? "Monitor your campaigns, review submissions, and release payments safely from escrow protection."
                              : "Submit post review links, track approval, and clear BDT payouts directly from escrow protection.",
                          style: const TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 11,
                            color: Colors.white70,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            const Text(
              "Active & Past Orders",
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: AppColors.allPrimaryColor,
              ),
            ),
            const SizedBox(height: 12),

            if (orders.isEmpty)
              Card(
                color: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                child: const Padding(
                  padding: EdgeInsets.all(32.0),
                  child: Center(
                    child: Column(
                      children: [
                        Icon(Icons.receipt_long_rounded, size: 48, color: Colors.grey),
                        SizedBox(height: 12),
                        Text(
                          "No active orders found.",
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey,
                          ),
                        ),
                      ],
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
                if (order.status == 'revision_requested') statusColor = Colors.red;

                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  color: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    leading: CircleAvatar(
                      radius: 22,
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
                          style: const TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 12.5,
                            fontWeight: FontWeight.bold,
                            color: AppColors.allPrimaryColor,
                          ),
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
        ),
      ),
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
            final currentOrder = marketplace.orders.firstWhere((o) => o.orderId == order.orderId, orElse: () => order);
            final isClient = marketplace.currentRole == UserRole.client;

            final isOfferAccepted = true;
            final isEscrowFunded = currentOrder.status == 'in_progress' || currentOrder.status == 'delivered' || currentOrder.status == 'completed' || currentOrder.status == 'revision_requested';
            final isWorkDelivered = currentOrder.status == 'delivered' || currentOrder.status == 'completed';
            final isEscrowReleased = currentOrder.status == 'completed';

            return Padding(
              padding: EdgeInsets.fromLTRB(20, 20, 20, MediaQuery.of(context).viewInsets.bottom + 20),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
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
                            Get.toNamed(Routes.CHAT_INBOX);
                          },
                        ),
                      ],
                    ),
                    const Divider(height: 20),

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

                    const Text(
                      "Order Progress Tracker",
                      style: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.bold, fontSize: 13, color: AppColors.allPrimaryColor),
                    ),
                    const SizedBox(height: 16),
                    _buildTimelineStep("1", "Offer Accepted", "Agreement was accepted by both parties", isOfferAccepted, false),
                    _buildTimelineStep("2", "Escrow Funded", isEscrowFunded ? "Escrow protection funded by Brand" : "Awaiting payment from Brand client", isEscrowFunded, !isEscrowFunded),
                    _buildTimelineStep(
                      "3",
                      currentOrder.status == 'revision_requested' ? "Revision Requested" : "Work Delivered",
                      currentOrder.status == 'revision_requested'
                          ? "Revision requested: ${currentOrder.revisionNotes}"
                          : (isWorkDelivered ? "Creator submitted content draft links" : "Creator working on custom post review"),
                      isWorkDelivered,
                      currentOrder.status == 'revision_requested' || (isEscrowFunded && !isWorkDelivered),
                    ),
                    _buildTimelineStep("4", "Escrow Released", isEscrowReleased ? "Funds released. Order completed!" : "Escrow payout pending client approval", isEscrowReleased, isWorkDelivered && !isEscrowReleased),

                    if ((currentOrder.status == 'in_progress' || currentOrder.status == 'revision_requested') && !isClient) ...[
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
                        text: currentOrder.status == 'revision_requested' ? "Submit Re-delivery Draft" : "Submit Work to Client",
                        onPressed: () {
                          final notes = _deliveryController.text.trim();
                          if (notes.isEmpty) return;
                          
                          marketplace.deliverOrder(currentOrder.orderId, notes);
                          _deliveryController.clear();
                          setModalState(() {});
                          setState(() {});
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

                    if (currentOrder.status == 'revision_requested') ...[
                      Container(
                        padding: const EdgeInsets.all(12),
                        width: double.infinity,
                        decoration: BoxDecoration(color: Colors.red.withOpacity(0.06), borderRadius: BorderRadius.circular(10)),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Row(
                              children: [
                                Icon(Icons.cached_rounded, color: Colors.red, size: 16),
                                SizedBox(width: 6),
                                Text(
                                  "Revision Instructions Received:",
                                  style: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.bold, fontSize: 11, color: Colors.red),
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Text(
                              currentOrder.revisionNotes ?? "No instructions provided.",
                              style: const TextStyle(fontFamily: 'Poppins', fontSize: 12, color: Colors.black87),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              "Revisions Remaining: ${currentOrder.revisionsLeft}",
                              style: const TextStyle(fontFamily: 'Poppins', fontSize: 10, color: Colors.red, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                    ],

                    if (currentOrder.status == 'delivered') ...[
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
                        CommonButton(
                          text: "Approve Delivery & Release Payment",
                          onPressed: () {
                            marketplace.approveOrder(currentOrder.orderId);
                            setModalState(() {});
                            setState(() {}); // refresh main orders screen
                            Get.snackbar(
                              "Order Completed",
                              "Funds released successfully to Creator!",
                              backgroundColor: Colors.green,
                              colorText: Colors.white,
                            );
                          },
                          backgroundColor: Colors.green,
                        ),
                        const SizedBox(height: 10),
                        CommonButton(
                          text: "Request Revision (${currentOrder.revisionsLeft} Left)",
                          onPressed: () {
                            if (currentOrder.revisionsLeft > 0) {
                              _showRevisionInputDialog(context, marketplace, currentOrder, () {
                                setModalState(() {});
                                setState(() {});
                              });
                            } else {
                              Get.snackbar(
                                "Limit Reached",
                                "No revisions left for this contract.",
                                backgroundColor: Colors.orange,
                                colorText: Colors.white,
                              );
                            }
                          },
                          backgroundColor: Colors.red,
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

                    if (currentOrder.status != 'completed' && isClient) ...[
                      const Divider(height: 32),
                      const Text(
                        "Timeline & Extension Control",
                        style: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.bold, fontSize: 13, color: AppColors.allPrimaryColor),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        "Need to give the creator more time to deliver or make revisions? You can extend the delivery limit directly.",
                        style: TextStyle(fontFamily: 'Poppins', fontSize: 10.5, color: Colors.grey),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(
                            child: CommonButton(
                              text: "+2 Days",
                              onPressed: () {
                                marketplace.extendOrderTimeline(currentOrder.orderId, 2);
                                setModalState(() {});
                                setState(() {});
                                Get.snackbar(
                                  "Timeline Extended",
                                  "Delivery time extended by 2 days.",
                                  backgroundColor: Colors.indigo,
                                  colorText: Colors.white,
                                );
                              },
                              backgroundColor: AppColors.allPrimaryColor.withOpacity(0.85),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: CommonButton(
                              text: "+5 Days",
                              onPressed: () {
                                marketplace.extendOrderTimeline(currentOrder.orderId, 5);
                                setModalState(() {});
                                setState(() {});
                                Get.snackbar(
                                  "Timeline Extended",
                                  "Delivery time extended by 5 days.",
                                  backgroundColor: Colors.indigo,
                                  colorText: Colors.white,
                                );
                              },
                              backgroundColor: AppColors.allPrimaryColor.withOpacity(0.85),
                            ),
                          ),
                        ],
                      ),
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
}
