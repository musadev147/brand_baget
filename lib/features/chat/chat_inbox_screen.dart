import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:brand_bridge/constants/app_colors.dart';
import 'package:brand_bridge/common_wigdets/user_role.dart';
import 'package:brand_bridge/provider/marketplace_provider.dart';
import 'package:brand_bridge/route/app_pages.dart';

class ChatInboxScreen extends StatefulWidget {
  const ChatInboxScreen({super.key});

  @override
  State<ChatInboxScreen> createState() => _ChatInboxScreenState();
}

class _ChatInboxScreenState extends State<ChatInboxScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = "";
  String _selectedTab = "All";

  String _formatTime(DateTime time) {
    final now = DateTime.now();
    final difference = now.difference(time);

    if (difference.inMinutes < 1) {
      return "Just now";
    } else if (difference.inHours < 1) {
      return "${difference.inMinutes}m ago";
    } else if (difference.inDays < 1) {
      return "${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}";
    } else if (difference.inDays < 7) {
      return "${difference.inDays}d ago";
    } else {
      return "${time.day}/${time.month}/${time.year}";
    }
  }

  @override
  Widget build(BuildContext context) {
    final marketplace = Provider.of<MarketplaceProvider>(context);
    final isClient = marketplace.currentRole == UserRole.client;

    // Build chat threads from provider data
    final chatThreads = marketplace.campaigns.isNotEmpty || marketplace.gigs.isNotEmpty
        ? _buildChatThreads(marketplace, isClient)
        : <_ChatThread>[];

    // Filter threads based on search query AND active tab
    final filteredThreads = chatThreads.where((thread) {
      // Search Query Filter
      final nameMatches = thread.partnerName.toLowerCase().contains(_searchQuery.toLowerCase());
      final campaignMatches = thread.campaignTitle.toLowerCase().contains(_searchQuery.toLowerCase());
      if (!nameMatches && !campaignMatches) return false;

      // Tab Filters (Fiverr Style)
      final isStarred = marketplace.starredChats.contains(thread.chatId);
      if (_selectedTab == "Starred") {
        return isStarred;
      } else if (_selectedTab == "Unread") {
        return thread.isUnread;
      } else if (_selectedTab == "Offers") {
        return thread.hasOffer;
      }
      return true; // "All"
    }).toList();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: AppColors.allPrimaryColor),
        title: const Text(
          "Inbox Messages",
          style: TextStyle(
            fontFamily: 'Poppins',
            fontWeight: FontWeight.bold,
            fontSize: 18,
            color: AppColors.allPrimaryColor,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.tune, color: AppColors.allPrimaryColor),
            tooltip: "Filters",
            onPressed: () {
              // Show bottom sheet with quick info
              _showInfoBottomSheet(context);
            },
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Fiverr Search Bar
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
              child: TextField(
                controller: _searchController,
                onChanged: (val) {
                  setState(() {
                    _searchQuery = val;
                  });
                },
                decoration: InputDecoration(
                  hintText: "Search by username or keyword...",
                  hintStyle: const TextStyle(fontFamily: 'Poppins', fontSize: 13),
                  prefixIcon: const Icon(Icons.search, color: Colors.grey),
                  filled: true,
                  fillColor: AppColors.cF5F6FA,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                ),
              ),
            ),

            // Fiverr Filter Tabs Bar
            _buildTabBar(),

            // Chat Threads List
            Expanded(
              child: filteredThreads.isEmpty
                  ? _buildEmptyState(marketplace, isClient)
                  : ListView.separated(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                      itemCount: filteredThreads.length,
                      separatorBuilder: (context, index) => Divider(color: Colors.grey[100], height: 1),
                      itemBuilder: (context, index) {
                        final thread = filteredThreads[index];
                        final isStarred = marketplace.starredChats.contains(thread.chatId);

                        return Container(
                          decoration: BoxDecoration(
                            color: thread.isUnread ? AppColors.appThemeColor.withOpacity(0.02) : Colors.transparent,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: ListTile(
                            contentPadding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
                            leading: Stack(
                              children: [
                                CircleAvatar(
                                  radius: 26,
                                  backgroundImage: NetworkImage(thread.partnerAvatar),
                                  backgroundColor: AppColors.cF5F6FA,
                                ),
                                if (thread.isOnline)
                                  Positioned(
                                    right: 1,
                                    bottom: 1,
                                    child: Container(
                                      width: 12,
                                      height: 12,
                                      decoration: BoxDecoration(
                                        color: Colors.green,
                                        shape: BoxShape.circle,
                                        border: Border.all(color: Colors.white, width: 2),
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                            title: Row(
                              children: [
                                Expanded(
                                  child: Row(
                                    children: [
                                      Flexible(
                                        child: Text(
                                          thread.partnerName,
                                          style: TextStyle(
                                            fontFamily: 'Poppins',
                                            fontWeight: thread.isUnread ? FontWeight.bold : FontWeight.w600,
                                            fontSize: 14,
                                            color: AppColors.allPrimaryColor,
                                          ),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                      const SizedBox(width: 6),
                                      // Fiverr Role Pill
                                      Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                        decoration: BoxDecoration(
                                          color: thread.partnerRole == UserRole.client
                                              ? Colors.blue.withOpacity(0.1)
                                              : Colors.green.withOpacity(0.1),
                                          borderRadius: BorderRadius.circular(4),
                                        ),
                                        child: Text(
                                          thread.partnerRole == UserRole.client ? "CLIENT" : "CREATOR",
                                          style: TextStyle(
                                            fontFamily: 'Poppins',
                                            fontSize: 7.5,
                                            fontWeight: FontWeight.bold,
                                            color: thread.partnerRole == UserRole.client ? Colors.blue : Colors.green,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                // Time
                                Text(
                                  _formatTime(thread.lastMessageTime),
                                  style: TextStyle(
                                    fontFamily: 'Poppins',
                                    fontSize: 10,
                                    fontWeight: thread.isUnread ? FontWeight.bold : FontWeight.normal,
                                    color: thread.isUnread ? AppColors.appThemeColor : Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                            subtitle: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      const SizedBox(height: 6),
                                      Row(
                                        children: [
                                          // Custom Offer Indicator (Fiverr Style)
                                          if (thread.hasOffer) ...[
                                            const Icon(Icons.description_outlined, size: 13, color: Colors.amber),
                                            const SizedBox(width: 4),
                                            const Text(
                                              "Custom Offer: ",
                                              style: TextStyle(
                                                fontFamily: 'Poppins',
                                                fontSize: 12,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.amber,
                                              ),
                                            ),
                                          ],
                                          Expanded(
                                            child: Text(
                                              thread.lastMessageText,
                                              style: TextStyle(
                                                fontFamily: 'Poppins',
                                                fontSize: 12.5,
                                                fontWeight: thread.isUnread ? FontWeight.bold : FontWeight.normal,
                                                color: thread.isUnread ? Colors.black87 : Colors.grey[600],
                                              ),
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 6),
                                      // Gig/Campaign Subtitle Info
                                      Text(
                                        "Project: ${thread.campaignTitle}",
                                        style: TextStyle(
                                          fontFamily: 'Poppins',
                                          fontSize: 10.5,
                                          color: Colors.grey[500],
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 8),
                                // Fiverr context thumbnail image + Star on far right
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(4),
                                      child: Image.network(
                                        thread.associatedImage,
                                        width: 40,
                                        height: 30,
                                        fit: BoxFit.cover,
                                        errorBuilder: (context, error, stackTrace) => Container(
                                          width: 40,
                                          height: 30,
                                          color: AppColors.cF5F6FA,
                                          child: const Icon(Icons.image, size: 14, color: Colors.grey),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    GestureDetector(
                                      onTap: () {
                                        marketplace.toggleStarChat(thread.chatId);
                                      },
                                      child: Icon(
                                        isStarred ? Icons.star_rounded : Icons.star_border_rounded,
                                        color: isStarred ? Colors.amber : Colors.grey[300],
                                        size: 20,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            onTap: () {
                              Get.toNamed(Routes.CHAT, arguments: {
                                "chatId": thread.chatId,
                                "campaignTitle": thread.campaignTitle,
                                "partnerName": thread.partnerName,
                                "partnerRole": thread.partnerRole,
                              });
                            },
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

  Widget _buildTabBar() {
    final tabs = ["All", "Unread", "Starred", "Offers"];
    return Container(
      height: 38,
      margin: const EdgeInsets.fromLTRB(16, 4, 16, 12),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: tabs.length,
        itemBuilder: (context, idx) {
          final tab = tabs[idx];
          final isSelected = _selectedTab == tab;
          return GestureDetector(
            onTap: () {
              setState(() {
                _selectedTab = tab;
              });
            },
            child: Container(
              margin: const EdgeInsets.only(right: 8),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: isSelected ? AppColors.allPrimaryColor : AppColors.cF5F6FA,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: isSelected ? Colors.transparent : Colors.grey[200]!,
                  width: 1,
                ),
              ),
              child: Center(
                child: Text(
                  tab,
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 11.5,
                    fontWeight: FontWeight.bold,
                    color: isSelected ? Colors.white : Colors.black87,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  List<_ChatThread> _buildChatThreads(MarketplaceProvider marketplace, bool isClient) {
    final List<_ChatThread> threads = [];
    final campaigns = marketplace.campaigns;
    final gigs = marketplace.gigs;

    // Scan campaigns
    for (var campaign in campaigns) {
      for (var proposal in campaign.proposals) {
        final chatId = "${campaign.id}_${proposal.creatorId}";
        final messages = marketplace.getChatMessages(chatId);

        if (messages.isNotEmpty) {
          final lastMsg = messages.last;
          final hasOffer = messages.any((m) => m.isContract);
          threads.add(_ChatThread(
            chatId: chatId,
            partnerName: isClient ? proposal.creatorName : marketplace.companyName,
            partnerAvatar: isClient ? proposal.creatorAvatar : "https://images.unsplash.com/photo-1486406146926-c627a92ad1ab?w=150",
            campaignTitle: campaign.title,
            lastMessageText: lastMsg.text,
            lastMessageTime: lastMsg.time,
            partnerRole: isClient ? UserRole.creator : UserRole.client,
            associatedImage: "https://images.unsplash.com/photo-1460925895917-afdab827c52f?w=150", // generic campaign image
            hasOffer: hasOffer,
            isUnread: lastMsg.senderRole != marketplace.currentRole,
            isOnline: true,
          ));
        }
      }
    }

    // Scan gigs
    for (var gig in gigs) {
      final chatId = "gig_${gig.id}";
      final messages = marketplace.getChatMessages(chatId);

      if (messages.isNotEmpty) {
        final lastMsg = messages.last;
        final hasOffer = messages.any((m) => m.isContract);
        threads.add(_ChatThread(
          chatId: chatId,
          partnerName: isClient ? gig.creatorName : marketplace.companyName,
          partnerAvatar: isClient ? gig.creatorAvatar : "https://images.unsplash.com/photo-1486406146926-c627a92ad1ab?w=150",
          campaignTitle: gig.title,
          lastMessageText: lastMsg.text,
          lastMessageTime: lastMsg.time,
          partnerRole: isClient ? UserRole.creator : UserRole.client,
          associatedImage: gig.bannerImage,
          hasOffer: hasOffer,
          isUnread: lastMsg.senderRole != marketplace.currentRole,
          isOnline: gig.id == "g1", // Sabbir is online
        ));
      }
    }

    // Sort by latest message time
    threads.sort((a, b) => b.lastMessageTime.compareTo(a.lastMessageTime));
    return threads;
  }

  Widget _buildEmptyState(MarketplaceProvider marketplace, bool isClient) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(height: 30),
          Icon(Icons.chat_bubble_outline_rounded, size: 60, color: Colors.grey[300]),
          const SizedBox(height: 16),
          Text(
            "No ${_selectedTab.toLowerCase()} chats",
            style: const TextStyle(
              fontFamily: 'Poppins',
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: AppColors.allPrimaryColor,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            "You have no conversations in this category. Apply to campaigns or message active creators to initiate new chats.",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 12,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 32),
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              isClient ? "Start Chatting with Creators" : "Your Active Applications",
              style: const TextStyle(
                fontFamily: 'Poppins',
                fontWeight: FontWeight.bold,
                fontSize: 14,
                color: AppColors.allPrimaryColor,
              ),
            ),
          ),
          const SizedBox(height: 12),
          if (isClient)
            ...marketplace.gigs.map((gig) {
              return Card(
                margin: const EdgeInsets.only(bottom: 12),
                color: AppColors.cF5F6FA,
                elevation: 0,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundImage: NetworkImage(gig.creatorAvatar),
                  ),
                  title: Text(
                    gig.creatorName,
                    style: const TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.bold, fontSize: 13),
                  ),
                  subtitle: Text(
                    gig.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontFamily: 'Poppins', fontSize: 11),
                  ),
                  trailing: const Icon(Icons.chevron_right, color: AppColors.appThemeColor),
                  onTap: () {
                    Get.toNamed(Routes.CHAT, arguments: {
                      "chatId": "gig_${gig.id}",
                      "campaignTitle": gig.title,
                      "partnerName": gig.creatorName,
                      "partnerRole": UserRole.creator,
                    });
                  },
                ),
              );
            }).toList()
          else
            ...marketplace.campaigns.where((c) => c.proposals.any((p) => p.creatorId == "1")).map((campaign) {
              final proposal = campaign.proposals.firstWhere((p) => p.creatorId == "1");
              return Card(
                margin: const EdgeInsets.only(bottom: 12),
                color: AppColors.cF5F6FA,
                elevation: 0,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                child: ListTile(
                  leading: const CircleAvatar(
                    backgroundImage: NetworkImage("https://images.unsplash.com/photo-1486406146926-c627a92ad1ab?w=150"),
                  ),
                  title: Text(
                    marketplace.companyName,
                    style: const TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.bold, fontSize: 13),
                  ),
                  subtitle: Text(
                    campaign.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontFamily: 'Poppins', fontSize: 11),
                  ),
                  trailing: const Icon(Icons.chevron_right, color: AppColors.appThemeColor),
                  onTap: () {
                    Get.toNamed(Routes.CHAT, arguments: {
                      "chatId": "${campaign.id}_${proposal.creatorId}",
                      "campaignTitle": campaign.title,
                      "partnerName": marketplace.companyName,
                      "partnerRole": UserRole.client,
                    });
                  },
                ),
              );
            }).toList(),
        ],
      ),
    );
  }

  void _showInfoBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Fiverr-Style Messaging Info",
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppColors.allPrimaryColor,
                ),
              ),
              const SizedBox(height: 12),
              _buildBulletPoint("Filter Tab bar: filter threads by All, Unread, Starred status, or Custom escrow offers."),
              _buildBulletPoint("Star badge toggling: tap the star next to the Gig preview to save chats as important."),
              _buildBulletPoint("Context thumbnail: associated post or campaign banners show directly on the right edge of each inbox row."),
              _buildBulletPoint("Online status: green badges signify active participants in real-time."),
              const SizedBox(height: 16),
              Align(
                alignment: Alignment.centerRight,
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.allPrimaryColor,
                  ),
                  child: const Text("Got it", style: TextStyle(color: Colors.white)),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildBulletPoint(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.check_circle_outline, color: Colors.green, size: 16),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                fontFamily: 'Poppins',
                fontSize: 12,
                color: Colors.black87,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ChatThread {
  final String chatId;
  final String partnerName;
  final String partnerAvatar;
  final String campaignTitle;
  final String lastMessageText;
  final DateTime lastMessageTime;
  final UserRole partnerRole;
  final String associatedImage;
  final bool hasOffer;
  final bool isUnread;
  final bool isOnline;

  _ChatThread({
    required this.chatId,
    required this.partnerName,
    required this.partnerAvatar,
    required this.campaignTitle,
    required this.lastMessageText,
    required this.lastMessageTime,
    required this.partnerRole,
    required this.associatedImage,
    required this.hasOffer,
    required this.isUnread,
    required this.isOnline,
  });
}
