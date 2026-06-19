import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:brand_bridge/constants/app_colors.dart';
import 'package:brand_bridge/common_wigdets/common_button.dart';
import 'package:brand_bridge/common_wigdets/custom_textfield_only.dart';
import 'package:brand_bridge/common_wigdets/user_role.dart';
import 'package:brand_bridge/provider/marketplace_provider.dart';
import 'package:brand_bridge/route/app_pages.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _msgController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  // Contract popup fields
  final TextEditingController _contractTitleController = TextEditingController();
  final TextEditingController _contractBudgetController = TextEditingController();
  final TextEditingController _contractDeadlineController = TextEditingController();

  // Zoom meeting fields
  final TextEditingController _zoomTopicController = TextEditingController();
  final TextEditingController _zoomTimeController = TextEditingController();
  final TextEditingController _zoomLinkController = TextEditingController();

  @override
  void dispose() {
    _msgController.dispose();
    _scrollController.dispose();
    _contractTitleController.dispose();
    _contractBudgetController.dispose();
    _contractDeadlineController.dispose();
    _zoomTopicController.dispose();
    _zoomTimeController.dispose();
    _zoomLinkController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void _showContractModal(MarketplaceProvider provider, String chatId) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: const Text(
            "Create Custom Offer",
            style: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.bold, color: AppColors.allPrimaryColor),
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CustomTextFormFieldOnly(
                  controller: _contractTitleController,
                  hintText: "Describe your offer (e.g. 1 Ded. YouTube Video)",
                ),
                const SizedBox(height: 12),
                CustomTextFormFieldOnly(
                  controller: _contractBudgetController,
                  hintText: "Total budget (\$ USD)",
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 12),
                CustomTextFormFieldOnly(
                  controller: _contractDeadlineController,
                  hintText: "Delivery Time (e.g. 5 Days)",
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel", style: TextStyle(color: Colors.grey)),
            ),
            ElevatedButton(
              onPressed: () {
                final title = _contractTitleController.text.trim();
                final budgetStr = _contractBudgetController.text.trim();
                final deadline = _contractDeadlineController.text.trim();

                if (title.isEmpty || budgetStr.isEmpty || deadline.isEmpty) return;
                final budget = double.tryParse(budgetStr) ?? 0.0;

                final msg = ChatMessage(
                  id: "msg_${DateTime.now().millisecondsSinceEpoch}",
                  senderName: provider.userName,
                  senderRole: provider.currentRole,
                  text: "Proposed a Custom Offer: $title",
                  time: DateTime.now(),
                  isContract: true,
                  contractTitle: title,
                  contractBudget: budget,
                  contractDeadline: deadline,
                  contractStatus: "pending",
                );

                provider.sendChatMessage(chatId, msg);
                _contractTitleController.clear();
                _contractBudgetController.clear();
                _contractDeadlineController.clear();
                Navigator.pop(context);
                _scrollToBottom();
              },
              style: ElevatedButton.styleFrom(backgroundColor: AppColors.appThemeColor),
              child: const Text("Send Offer", style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }

  void _showZoomMeetingModal(MarketplaceProvider provider, String chatId) {
    _zoomTopicController.text = "Campaign Kickoff & Deliverables Sync";
    _zoomTimeController.text = "Tomorrow at 4:30 PM (BST)";
    _zoomLinkController.text = "https://zoom.us/j/9876543210";

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: const Row(
            children: [
              Icon(Icons.video_call_rounded, color: Colors.blue, size: 28),
              SizedBox(width: 8),
              Text(
                "Invite to Zoom Meeting",
                style: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.bold, fontSize: 16, color: AppColors.allPrimaryColor),
              ),
            ],
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CustomTextFormFieldOnly(
                  controller: _zoomTopicController,
                  hintText: "Meeting Topic",
                ),
                const SizedBox(height: 12),
                CustomTextFormFieldOnly(
                  controller: _zoomTimeController,
                  hintText: "Date & Time (e.g. Tomorrow at 3:00 PM)",
                ),
                const SizedBox(height: 12),
                CustomTextFormFieldOnly(
                  controller: _zoomLinkController,
                  hintText: "Zoom Link",
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel", style: TextStyle(color: Colors.grey)),
            ),
            ElevatedButton(
              onPressed: () {
                final topic = _zoomTopicController.text.trim();
                final timeVal = _zoomTimeController.text.trim();
                final linkVal = _zoomLinkController.text.trim();

                if (topic.isEmpty || timeVal.isEmpty) return;

                final msgText = "[ZoomMeeting: $topic | $timeVal | ${linkVal.isEmpty ? "https://zoom.us/j/9876543210" : linkVal}]";
                _sendTextMessage(provider, chatId, msgText);
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
              child: const Text("Send Invite", style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }

  void _showImagePickerBottomSheet(MarketplaceProvider provider, String chatId) {
    final List<Map<String, String>> mockImages = [
      {
        "name": "influencer_selfie.jpg",
        "url": "https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=400"
      },
      {
        "name": "gaming_setup.jpg",
        "url": "https://images.unsplash.com/photo-1542751371-adc38448a05e?w=400"
      },
      {
        "name": "work_office.jpg",
        "url": "https://images.unsplash.com/photo-1460925895917-afdab827c52f?w=400"
      },
      {
        "name": "fashion_lookbook.jpg",
        "url": "https://images.unsplash.com/photo-1512436991641-6745cdb1723f?w=400"
      },
      {
        "name": "analytics_chart.jpg",
        "url": "https://images.unsplash.com/photo-1551288049-bebda4e38f71?w=400"
      },
      {
        "name": "camera_workspace.jpg",
        "url": "https://images.unsplash.com/photo-1516035069371-29a1b244cc32?w=400"
      },
    ];

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Row(
                children: [
                  Icon(Icons.photo_library_outlined, color: AppColors.appThemeColor),
                  SizedBox(width: 8),
                  Text(
                    "Upload Image from Gallery",
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppColors.allPrimaryColor,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              const Text(
                "Pick an image from your mock phone gallery to send:",
                style: TextStyle(fontFamily: 'Poppins', fontSize: 12, color: Colors.grey),
              ),
              const SizedBox(height: 16),
              SizedBox(
                height: 120,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: mockImages.length,
                  itemBuilder: (context, idx) {
                    final img = mockImages[idx];
                    return GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                        _sendTextMessage(
                          provider,
                          chatId,
                          "[ImageAttachment: ${img['name']} | ${img['url']}]",
                        );
                      },
                      child: Container(
                        margin: const EdgeInsets.only(right: 12),
                        width: 100,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: Colors.grey[300]!),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(9),
                          child: Stack(
                            fit: StackFit.expand,
                            children: [
                              Image.network(
                                img['url']!,
                                fit: BoxFit.cover,
                              ),
                              Positioned(
                                bottom: 0,
                                left: 0,
                                right: 0,
                                child: Container(
                                  color: Colors.black54,
                                  padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 4),
                                  child: Text(
                                    img['name']!,
                                    style: const TextStyle(fontSize: 8, color: Colors.white, fontFamily: 'Poppins'),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
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
              const SizedBox(height: 12),
            ],
          ),
        );
      },
    );
  }

  void _sendTextMessage(MarketplaceProvider marketplace, String chatId, String txt) {
    if (txt.isEmpty) return;

    final msg = ChatMessage(
      id: "msg_${DateTime.now().millisecondsSinceEpoch}",
      senderName: marketplace.userName,
      senderRole: marketplace.currentRole,
      text: txt,
      time: DateTime.now(),
    );

    marketplace.sendChatMessage(chatId, msg);
    _msgController.clear();
    _scrollToBottom();
  }

  void _showActionsBottomSheet(MarketplaceProvider marketplace, String chatId) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        final isClient = marketplace.currentRole == UserRole.client;
        return Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Quick Actions",
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppColors.allPrimaryColor,
                ),
              ),
              const SizedBox(height: 16),
              if (isClient)
                ListTile(
                  leading: const Icon(Icons.description_outlined, color: Colors.amber),
                  title: const Text("Create Custom Offer", style: TextStyle(fontFamily: 'Poppins')),
                  subtitle: const Text("Send a contract with fixed budget and deadline", style: TextStyle(fontSize: 11)),
                  onTap: () {
                    Navigator.pop(context);
                    _showContractModal(marketplace, chatId);
                  },
                ),
              ListTile(
                leading: const Icon(Icons.video_call_rounded, color: Colors.blue),
                title: const Text("Invite to Zoom Meeting", style: TextStyle(fontFamily: 'Poppins')),
                subtitle: const Text("Generate and schedule a Zoom conference invite", style: TextStyle(fontSize: 11)),
                onTap: () {
                  Navigator.pop(context);
                  _showZoomMeetingModal(marketplace, chatId);
                },
              ),
              ListTile(
                leading: const Icon(Icons.camera_alt_outlined, color: Colors.green),
                title: const Text("Upload Image from Gallery", style: TextStyle(fontFamily: 'Poppins')),
                subtitle: const Text("Choose mockup screenshot or attachment to send", style: TextStyle(fontSize: 11)),
                onTap: () {
                  Navigator.pop(context);
                  _showImagePickerBottomSheet(marketplace, chatId);
                },
              ),
              if (!isClient)
                ListTile(
                  leading: const Icon(Icons.rate_review_outlined, color: Colors.purple),
                  title: const Text("Send Video Pitch link", style: TextStyle(fontFamily: 'Poppins')),
                  subtitle: const Text("Simulate sending a video review draft link", style: TextStyle(fontSize: 11)),
                  onTap: () {
                    Navigator.pop(context);
                    _sendTextMessage(
                      marketplace,
                      chatId,
                      "Hey, I recorded a draft review. Please look at this: draft_pitch_review.mp4",
                    );
                  },
                ),
              const SizedBox(height: 8),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // Arguments: Map containing chatId, campaignTitle, partnerName, partnerRole
    final args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    final String chatId = args["chatId"];
    final String campaignTitle = args["campaignTitle"];
    final String partnerName = args["partnerName"];
    final UserRole partnerRole = args["partnerRole"];

    final marketplace = Provider.of<MarketplaceProvider>(context);
    final messages = marketplace.getChatMessages(chatId);

    // Fiverr Mock Quick Responses
    final List<String> quickReplies = marketplace.currentRole == UserRole.client
        ? [
            "Hi, is this still available?",
            "What is the delivery time?",
            "Can we negotiate budget?",
            "Please send custom offer.",
          ]
        : [
            "Yes, I am available for this!",
            "I've sent a custom proposal.",
            "Can you provide more details?",
            "Looking forward to work!",
          ];

    // Auto-scroll to bottom on loaded
    _scrollToBottom();

    return Scaffold(
      backgroundColor: AppColors.cF5F6FA,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: AppColors.allPrimaryColor),
        title: Row(
          children: [
            Stack(
              children: [
                CircleAvatar(
                  radius: 18,
                  backgroundImage: NetworkImage(
                    partnerRole == UserRole.creator
                        ? "https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=150"
                        : "https://images.unsplash.com/photo-1486406146926-c627a92ad1ab?w=150",
                  ),
                ),
                Positioned(
                  right: 0,
                  bottom: 0,
                  child: Container(
                    width: 10,
                    height: 10,
                    decoration: BoxDecoration(
                      color: Colors.green,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 1.5),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    partnerName,
                    style: const TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.bold, fontSize: 14, color: AppColors.allPrimaryColor),
                    overflow: TextOverflow.ellipsis,
                  ),
                  // Fiverr Country + Local time bar
                  Text(
                    "Online • Bangladesh • Local Time: 11:39 PM",
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 9.5,
                      color: AppColors.c6C6C6C,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline, color: AppColors.allPrimaryColor),
            onPressed: () {
              Get.snackbar("Project Info", "Context: $campaignTitle",
                  backgroundColor: AppColors.allPrimaryColor, colorText: Colors.white);
            },
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Project Context Pill Header
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              color: Colors.white,
              width: double.infinity,
              child: Center(
                child: Text(
                  "Discussing Campaign: $campaignTitle",
                  style: const TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: AppColors.appThemeColor,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),

            // Chat Feed
            Expanded(
              child: messages.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.chat_bubble_outline_rounded, size: 48, color: Colors.grey.withOpacity(0.5)),
                          const SizedBox(height: 12),
                          const Text("No messages yet. Say hello!", style: TextStyle(fontFamily: 'Poppins', color: Colors.grey)),
                        ],
                      ),
                    )
                  : ListView.builder(
                      controller: _scrollController,
                      padding: const EdgeInsets.all(16.0),
                      itemCount: messages.length,
                      itemBuilder: (context, idx) {
                        final msg = messages[idx];
                        final isMe = msg.senderRole == marketplace.currentRole;

                        // Custom Offer Check
                        if (msg.isContract) {
                          return _buildFiverrContractCard(marketplace, chatId, msg, isMe);
                        }

                        // Zoom Meeting Check
                        if (msg.text.startsWith("[ZoomMeeting:")) {
                          return _buildZoomMeetingCard(msg, isMe);
                        }

                        // Image Attachment Check
                        if (msg.text.startsWith("[ImageAttachment:")) {
                          return _buildImageAttachmentCard(msg, isMe);
                        }

                        // Attach screenshot mockup check (Legacy fallback)
                        final hasScreenshot = msg.text.contains("Attached Screenshot:");
                        final imageUrl = hasScreenshot && msg.text.contains("[Image: ")
                            ? msg.text.substring(msg.text.indexOf("[Image: ") + 8, msg.text.indexOf("]"))
                            : "";

                        return Align(
                          alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
                          child: Container(
                            margin: const EdgeInsets.symmetric(vertical: 6.0),
                            constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.78),
                            child: Column(
                              crossAxisAlignment: isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
                                  decoration: BoxDecoration(
                                    color: isMe ? AppColors.appThemeColor : Colors.white,
                                    borderRadius: BorderRadius.only(
                                      topLeft: const Radius.circular(12),
                                      topRight: const Radius.circular(12),
                                      bottomLeft: isMe ? const Radius.circular(12) : const Radius.circular(0),
                                      bottomRight: isMe ? const Radius.circular(0) : const Radius.circular(12),
                                    ),
                                    boxShadow: [
                                      BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 4, offset: const Offset(0, 2))
                                    ],
                                  ),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        hasScreenshot ? msg.text.split(" [Image:")[0] : msg.text,
                                        style: TextStyle(
                                          fontFamily: 'Poppins',
                                          fontSize: 13,
                                          color: isMe ? Colors.white : AppColors.allPrimaryColor,
                                        ),
                                      ),
                                      if (hasScreenshot && imageUrl.isNotEmpty) ...[
                                        const SizedBox(height: 8),
                                        ClipRRect(
                                          borderRadius: BorderRadius.circular(8),
                                          child: Image.network(
                                            imageUrl,
                                            height: 140,
                                            width: double.infinity,
                                            fit: BoxFit.cover,
                                            errorBuilder: (context, error, stackTrace) => Container(
                                              height: 140,
                                              color: Colors.grey[200],
                                              child: const Center(child: Icon(Icons.broken_image)),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  "${msg.senderName} • ${_formatMessageTime(msg.time)}",
                                  style: TextStyle(
                                    fontFamily: 'Poppins',
                                    fontSize: 8.5,
                                    color: Colors.grey[500],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
            ),

            // Fiverr Quick Templates Bar
            Container(
              height: 34,
              color: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 4.0),
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 12),
                itemCount: quickReplies.length,
                itemBuilder: (context, idx) {
                  final reply = quickReplies[idx];
                  return GestureDetector(
                    onTap: () {
                      _sendTextMessage(marketplace, chatId, reply);
                    },
                    child: Container(
                      margin: const EdgeInsets.only(right: 8),
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppColors.cF5F6FA,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: Colors.grey[200]!, width: 0.8),
                      ),
                      child: Center(
                        child: Text(
                          reply,
                          style: const TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 11,
                            color: AppColors.allPrimaryColor,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),

            // Text Input bar with "+" Actions Button (Fiverr Style)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              decoration: const BoxDecoration(
                color: Colors.white,
                border: Border(top: BorderSide(color: Colors.black12, width: 0.5)),
              ),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => _showActionsBottomSheet(marketplace, chatId),
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: AppColors.cF5F6FA,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.add, color: AppColors.appThemeColor, size: 20),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: TextField(
                      controller: _msgController,
                      textInputAction: TextInputAction.send,
                      onSubmitted: (val) => _sendTextMessage(marketplace, chatId, val.trim()),
                      decoration: InputDecoration(
                        hintText: "Type message or details...",
                        hintStyle: const TextStyle(fontFamily: 'Poppins', fontSize: 13),
                        filled: true,
                        fillColor: AppColors.cF5F6FA,
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(20), borderSide: BorderSide.none),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  GestureDetector(
                    onTap: () => _sendTextMessage(marketplace, chatId, _msgController.text.trim()),
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: const BoxDecoration(
                        color: AppColors.appThemeColor,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.send, color: Colors.white, size: 18),
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

  // Zoom Meeting invitation Card
  Widget _buildZoomMeetingCard(ChatMessage msg, bool isMe) {
    // Format: [ZoomMeeting: Topic | Date/Time | Zoom Link]
    final content = msg.text.substring(13, msg.text.length - 1);
    final parts = content.split(" | ");
    final topic = parts.isNotEmpty ? parts[0] : "Video Call Meeting";
    final timeVal = parts.length > 1 ? parts[1] : "";
    final zoomLink = parts.length > 2 ? parts[2] : "https://zoom.us/j/9876543210";

    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8.0),
        width: MediaQuery.of(context).size.width * 0.78,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: Colors.blue.withOpacity(0.5), width: 1.5),
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 6, offset: const Offset(0, 3)),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.blue.withOpacity(0.08),
                borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
              ),
              child: const Row(
                children: [
                  Icon(Icons.video_camera_front_rounded, color: Colors.blue, size: 20),
                  SizedBox(width: 8),
                  Text(
                    "Zoom Meeting Invite",
                    style: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.bold, fontSize: 12, color: Colors.blue),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(14.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    topic,
                    style: const TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.bold, fontSize: 13, color: AppColors.allPrimaryColor),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(Icons.schedule, size: 14, color: Colors.grey),
                      const SizedBox(width: 6),
                      Text(
                        timeVal,
                        style: const TextStyle(fontFamily: 'Poppins', fontSize: 11.5, color: Colors.black87),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    height: 36,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        Get.snackbar(
                          "Zoom Meeting",
                          "Redirecting to Zoom meeting room...",
                          backgroundColor: Colors.blue,
                          colorText: Colors.white,
                          icon: const Icon(Icons.videocam, color: Colors.white),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                      ),
                      icon: const Icon(Icons.play_circle_fill_rounded, size: 16, color: Colors.white),
                      label: const Text(
                        "Join Meeting",
                        style: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.bold, fontSize: 12, color: Colors.white),
                      ),
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

  // Gallery Image Attachment Card
  Widget _buildImageAttachmentCard(ChatMessage msg, bool isMe) {
    // Format: [ImageAttachment: filename.jpg | imageUrl]
    final content = msg.text.substring(17, msg.text.length - 1);
    final parts = content.split(" | ");
    final filename = parts.isNotEmpty ? parts[0] : "image.jpg";
    final imageUrl = parts.length > 1 ? parts[1] : "";

    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 6.0),
        width: MediaQuery.of(context).size.width * 0.70,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 4, offset: const Offset(0, 2)),
          ],
          border: Border.all(color: Colors.grey[200]!),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(11)),
              child: Image.network(
                imageUrl,
                height: 180,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  height: 180,
                  color: Colors.grey[200],
                  child: const Center(child: Icon(Icons.broken_image, color: Colors.grey)),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Icon(Icons.insert_drive_file_outlined, size: 14, color: Colors.grey[600]),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      filename,
                      style: TextStyle(fontFamily: 'Poppins', fontSize: 11.5, color: Colors.grey[700]),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
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

  // Revamped Fiverr Custom Offer Box
  Widget _buildFiverrContractCard(MarketplaceProvider provider, String chatId, ChatMessage msg, bool isSentByMe) {
    final status = msg.contractStatus ?? "pending";
    final isClient = provider.currentRole == UserRole.client;

    Color statusColor = Colors.orange;
    if (status == 'accepted') statusColor = Colors.blue;
    if (status == 'paid') statusColor = Colors.teal;
    if (status == 'released') statusColor = Colors.green;

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 12.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 8, offset: const Offset(0, 4))
        ],
        border: Border.all(color: statusColor.withOpacity(0.4), width: 1.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Fiverr Offer Header Banner
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(
              color: statusColor.withOpacity(0.05),
              borderRadius: const BorderRadius.vertical(top: Radius.circular(14)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(Icons.description_outlined, color: statusColor, size: 18),
                    const SizedBox(width: 6),
                    const Text(
                      "CUSTOM OFFER",
                      style: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.bold, fontSize: 12, color: AppColors.allPrimaryColor),
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(color: statusColor, borderRadius: BorderRadius.circular(4)),
                  child: Text(
                    status.toUpperCase(),
                    style: const TextStyle(fontFamily: 'Poppins', fontSize: 9, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  msg.contractTitle ?? "Custom Sponsorship Deliverables",
                  style: const TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.bold, fontSize: 14, color: AppColors.allPrimaryColor),
                ),
                const SizedBox(height: 12),
                
                // Specifications Grid
                Row(
                  children: [
                    _buildSpecTile(Icons.monetization_on_rounded, "Price", "\$${msg.contractBudget?.toStringAsFixed(0)}"),
                    const SizedBox(width: 16),
                    _buildSpecTile(Icons.schedule_rounded, "Delivery", msg.contractDeadline ?? "5 Days"),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    _buildSpecTile(Icons.shield_outlined, "Protection", "Escrow Secured"),
                    const SizedBox(width: 16),
                    _buildSpecTile(Icons.autorenew_rounded, "Revisions", "2 Revisions"),
                  ],
                ),
                const Divider(height: 24, thickness: 0.8),

                // Escrow statement
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.grey[50],
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: const Row(
                    children: [
                      Icon(Icons.lock_outline_rounded, size: 14, color: Colors.green),
                      SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          "Funds are held securely in BrandBridge Escrow and only released when you approve completed work.",
                          style: TextStyle(fontFamily: 'Poppins', fontSize: 10, color: Colors.black54),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                // Fiverr Contract Action Buttons
                if (status == 'pending' && !isClient) ...[
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () {
                            provider.respondToContract(chatId, msg.id, "rejected");
                          },
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(color: Colors.red),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                          ),
                          child: const Text("Decline Offer", style: TextStyle(color: Colors.red, fontSize: 12)),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            provider.respondToContract(chatId, msg.id, "accepted");
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                          ),
                          child: const Text("Accept Offer", style: TextStyle(color: Colors.white, fontSize: 12)),
                        ),
                      ),
                    ],
                  ),
                ],

                if (status == 'accepted' && isClient) ...[
                  CommonButton(
                    text: "Fund Escrow (\$${msg.contractBudget?.toStringAsFixed(0)})",
                    onPressed: () {
                      Get.toNamed(Routes.PAYMENT, arguments: {
                        "chatId": chatId,
                        "messageId": msg.id,
                        "amount": msg.contractBudget,
                        "title": msg.contractTitle,
                      });
                    },
                    backgroundColor: AppColors.appThemeColor,
                  ),
                ],

                if (status == 'paid' && isClient) ...[
                  CommonButton(
                    text: "Release Funds to Creator",
                    onPressed: () {
                      provider.respondToContract(chatId, msg.id, "released");
                      Get.snackbar("Released", "Escrow funds have been successfully released to the creator!",
                          backgroundColor: Colors.green, colorText: Colors.white);
                    },
                    backgroundColor: Colors.green,
                  ),
                ],

                if (status == 'paid' && !isClient) ...[
                  const Center(
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 4.0),
                      child: Text(
                        "Brand has funded escrow. Start creating content!",
                        style: TextStyle(fontFamily: 'Poppins', fontSize: 12, color: Colors.teal, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],

                if (status == 'released') ...[
                  const Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.check_circle_rounded, color: Colors.green, size: 16),
                        SizedBox(width: 6),
                        Text(
                          "Agreement successfully completed and paid!",
                          style: TextStyle(fontFamily: 'Poppins', fontSize: 12, color: Colors.green, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSpecTile(IconData icon, String label, String val) {
    return Expanded(
      child: Row(
        children: [
          Icon(icon, size: 16, color: Colors.grey[500]),
          const SizedBox(width: 6),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: TextStyle(fontFamily: 'Poppins', fontSize: 9.5, color: Colors.grey[500])),
                Text(val, style: const TextStyle(fontFamily: 'Poppins', fontSize: 11, fontWeight: FontWeight.bold, color: AppColors.allPrimaryColor)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _formatMessageTime(DateTime time) {
    return "${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}";
  }
}
