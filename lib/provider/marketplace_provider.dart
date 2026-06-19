import 'package:flutter/material.dart';
import 'package:brand_bridge/common_wigdets/user_role.dart';

class CreatorModel {
  final String id;
  final String name;
  final String avatar;
  final List<String> categories;
  final int followersCount;
  final double engagementRate;
  final int avgViews;
  final int reviewsCount;
  final double rating;
  final String location;
  final String bio;
  final Map<String, String> platformLinks;
  final int fakeFollowersPct;
  final double audienceQualityScore;
  final String audienceAgeGenders;
  final List<String> portfolio;
  final List<String> reviews;

  CreatorModel({
    required this.id,
    required this.name,
    required this.avatar,
    required this.categories,
    required this.followersCount,
    required this.engagementRate,
    required this.avgViews,
    required this.reviewsCount,
    required this.rating,
    required this.location,
    required this.bio,
    required this.platformLinks,
    required this.fakeFollowersPct,
    required this.audienceQualityScore,
    required this.audienceAgeGenders,
    required this.portfolio,
    required this.reviews,
  });
}

class CampaignModel {
  final String id;
  final String title;
  final String productName;
  final String description;
  final double budget;
  final String deadline;
  final String platform;
  final String contentType;
  final String requirements;
  final String status; // 'open', 'in_progress', 'completed'
  final List<ProposalModel> proposals;

  CampaignModel({
    required this.id,
    required this.title,
    required this.productName,
    required this.description,
    required this.budget,
    required this.deadline,
    required this.platform,
    required this.contentType,
    required this.requirements,
    required this.status,
    required this.proposals,
  });

  CampaignModel copyWith({
    String? id,
    String? title,
    String? productName,
    String? description,
    double? budget,
    String? deadline,
    String? platform,
    String? contentType,
    String? requirements,
    String? status,
    List<ProposalModel>? proposals,
  }) {
    return CampaignModel(
      id: id ?? this.id,
      title: title ?? this.title,
      productName: productName ?? this.productName,
      description: description ?? this.description,
      budget: budget ?? this.budget,
      deadline: deadline ?? this.deadline,
      platform: platform ?? this.platform,
      contentType: contentType ?? this.contentType,
      requirements: requirements ?? this.requirements,
      status: status ?? this.status,
      proposals: proposals ?? this.proposals,
    );
  }
}

class ProposalModel {
  final String id;
  final String campaignId;
  final String creatorId;
  final String creatorName;
  final String creatorAvatar;
  final double price;
  final String deliveryTime;
  final String message;
  final String status; // 'pending', 'accepted', 'rejected'

  ProposalModel({
    required this.id,
    required this.campaignId,
    required this.creatorId,
    required this.creatorName,
    required this.creatorAvatar,
    required this.price,
    required this.deliveryTime,
    required this.message,
    required this.status,
  });

  ProposalModel copyWith({
    String? id,
    String? campaignId,
    String? creatorId,
    String? creatorName,
    String? creatorAvatar,
    double? price,
    String? deliveryTime,
    String? message,
    String? status,
  }) {
    return ProposalModel(
      id: id ?? this.id,
      campaignId: campaignId ?? this.campaignId,
      creatorId: creatorId ?? this.creatorId,
      creatorName: creatorName ?? this.creatorName,
      creatorAvatar: creatorAvatar ?? this.creatorAvatar,
      price: price ?? this.price,
      deliveryTime: deliveryTime ?? this.deliveryTime,
      message: message ?? this.message,
      status: status ?? this.status,
    );
  }
}

class ChatMessage {
  final String id;
  final String senderName;
  final UserRole senderRole;
  final String text;
  final DateTime time;
  
  // Escrow / Contract related fields
  final bool isContract;
  final String? contractTitle;
  final double? contractBudget;
  final String? contractDeadline;
  final String? contractStatus; // 'pending', 'accepted', 'rejected', 'paid', 'released'

  ChatMessage({
    required this.id,
    required this.senderName,
    required this.senderRole,
    required this.text,
    required this.time,
    this.isContract = false,
    this.contractTitle,
    this.contractBudget,
    this.contractDeadline,
    this.contractStatus,
  });

  ChatMessage copyWith({
    String? id,
    String? senderName,
    UserRole? senderRole,
    String? text,
    DateTime? time,
    bool? isContract,
    String? contractTitle,
    double? contractBudget,
    String? contractDeadline,
    String? contractStatus,
  }) {
    return ChatMessage(
      id: id ?? this.id,
      senderName: senderName ?? this.senderName,
      senderRole: senderRole ?? this.senderRole,
      text: text ?? this.text,
      time: time ?? this.time,
      isContract: isContract ?? this.isContract,
      contractTitle: contractTitle ?? this.contractTitle,
      contractBudget: contractBudget ?? this.contractBudget,
      contractDeadline: contractDeadline ?? this.contractDeadline,
      contractStatus: contractStatus ?? this.contractStatus,
    );
  }
}

class GigModel {
  final String id;
  final String creatorId;
  final String creatorName;
  final String creatorAvatar;
  final String title;
  final String description;
  final double price;
  final String deliveryTime;
  final String platform; // Primary platform
  final String socialLink; // Primary link
  final int verifiedFollowers; // Primary followers count
  
  // New fields
  final String bannerImage;
  final String category;
  final String region;
  final String deliverables;
  final String revisions;
  
  final String youtubeLink;
  final String tiktokLink;
  final String facebookLink;
  final String instagramLink;

  final int youtubeFollowers;
  final int tiktokFollowers;
  final int facebookFollowers;
  final int instagramFollowers;
  final String videoUrl;

  int get totalReach => youtubeFollowers + tiktokFollowers + facebookFollowers + instagramFollowers;

  GigModel({
    required this.id,
    required this.creatorId,
    required this.creatorName,
    required this.creatorAvatar,
    required this.title,
    required this.description,
    required this.price,
    required this.deliveryTime,
    required this.platform,
    required this.socialLink,
    required this.verifiedFollowers,
    required this.bannerImage,
    required this.category,
    required this.region,
    required this.deliverables,
    required this.revisions,
    this.youtubeLink = "",
    this.tiktokLink = "",
    this.facebookLink = "",
    this.instagramLink = "",
    this.youtubeFollowers = 0,
    this.tiktokFollowers = 0,
    this.facebookFollowers = 0,
    this.instagramFollowers = 0,
    this.videoUrl = "",
  });
}

class OrderModel {
  final String orderId;
  final String chatId;
  final String title;
  final double price;
  final String deliveryTime;
  final String clientName;
  final String creatorName;
  final String creatorAvatar;
  final String status; // 'pending', 'in_progress', 'delivered', 'completed'
  final DateTime createdAt;
  final String? deliveryNotes;

  OrderModel({
    required this.orderId,
    required this.chatId,
    required this.title,
    required this.price,
    required this.deliveryTime,
    required this.clientName,
    required this.creatorName,
    required this.creatorAvatar,
    required this.status,
    required this.createdAt,
    this.deliveryNotes,
  });

  OrderModel copyWith({
    String? orderId,
    String? chatId,
    String? title,
    double? price,
    String? deliveryTime,
    String? clientName,
    String? creatorName,
    String? creatorAvatar,
    String? status,
    DateTime? createdAt,
    String? deliveryNotes,
  }) {
    return OrderModel(
      orderId: orderId ?? this.orderId,
      chatId: chatId ?? this.chatId,
      title: title ?? this.title,
      price: price ?? this.price,
      deliveryTime: deliveryTime ?? this.deliveryTime,
      clientName: clientName ?? this.clientName,
      creatorName: creatorName ?? this.creatorName,
      creatorAvatar: creatorAvatar ?? this.creatorAvatar,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      deliveryNotes: deliveryNotes ?? this.deliveryNotes,
    );
  }
}

class MarketplaceProvider extends ChangeNotifier {
  // Current user configuration
  UserRole _currentRole = UserRole.client;
  String _userName = "John Doe";
  String _userEmail = "john@example.com";
  
  // Client specific fields
  String _companyName = "TechVibe Global";
  String _businessType = "Software Startup";
  String _clientLocation = "Dhaka, Bangladesh";
  double _budgetRange = 5000.0;

  // Creator specific fields
  List<String> _creatorCategories = ["Tech", "Gaming"];
  String _creatorBio = "Veteran tech reviewer and gamer based in Dhaka.";
  Map<String, String> _creatorPlatformLinks = {
    "YouTube": "youtube.com/c/sabbirtech",
    "Instagram": "instagram.com/sabbir_tech"
  };
  int _creatorFollowers = 75000;
  String _creatorAvatar = "https://images.unsplash.com/photo-1535713875002-d1d0cf377fde?w=150";

  // Data Stores
  List<CreatorModel> _creators = [];
  List<CampaignModel> _campaigns = [];
  List<GigModel> _gigs = [];
  Map<String, List<ChatMessage>> _chats = {}; // Key: chatID (e.g. campaignId_creatorId or gigId_clientId)
  List<String> _notifications = [];
  final Set<String> _starredChats = {};
  List<OrderModel> _orders = [];

  // Client Wallet
  double _clientDepositBalance = 150.0;
  double _clientLifetimeSpent = 1250.0;

  // Creator Wallet
  double _creatorAvailableBalance = 800.0;
  double _creatorWithdrawnBalance = 450.0;

  // Getters
  UserRole get currentRole => _currentRole;
  String get userName => _userName;
  String get userEmail => _userEmail;
  String get companyName => _companyName;
  String get businessType => _businessType;
  String get clientLocation => _clientLocation;
  double get budgetRange => _budgetRange;
  List<String> get creatorCategories => _creatorCategories;
  String get creatorBio => _creatorBio;
  Map<String, String> get creatorPlatformLinks => _creatorPlatformLinks;
  int get creatorFollowers => _creatorFollowers;
  String get creatorAvatar => _creatorAvatar;
  List<CreatorModel> get creators => _creators;
  List<CampaignModel> get campaigns => _campaigns;
  List<GigModel> get gigs => _gigs;
  List<String> get notifications => _notifications;
  Set<String> get starredChats => _starredChats;
  List<OrderModel> get orders => _orders;

  // Wallet Getters
  double get clientDepositBalance => _clientDepositBalance;
  double get clientLifetimeSpent => _clientLifetimeSpent;
  double get clientActiveEscrow => _orders.where((o) => o.status == 'in_progress' || o.status == 'delivered').fold(0.0, (sum, o) => sum + o.price);
  
  double get creatorAvailableBalance => _creatorAvailableBalance;
  double get creatorWithdrawnBalance => _creatorWithdrawnBalance;
  double get creatorPendingClearance => _orders.where((o) => o.status == 'in_progress' || o.status == 'delivered').fold(0.0, (sum, o) => sum + o.price);
  double get creatorNetEarnings => _orders.where((o) => o.status == 'completed').fold(0.0, (sum, o) => sum + o.price) + _creatorWithdrawnBalance + _creatorAvailableBalance;

  MarketplaceProvider() {
    _loadMockData();
  }

  void setRole(UserRole role) {
    _currentRole = role;
    notifyListeners();
  }

  void updateClientProfile({
    required String name,
    required String email,
    required String company,
    required String business,
    required String location,
    required double budget,
  }) {
    _userName = name;
    _userEmail = email;
    _companyName = company;
    _businessType = business;
    _clientLocation = location;
    _budgetRange = budget;
    notifyListeners();
  }

  void updateCreatorProfile({
    required String name,
    required String email,
    required List<String> categories,
    required String bio,
    required Map<String, String> platformLinks,
    required int followers,
    required String avatar,
  }) {
    _userName = name;
    _userEmail = email;
    _creatorCategories = categories;
    _creatorBio = bio;
    _creatorPlatformLinks = platformLinks;
    _creatorFollowers = followers;
    _creatorAvatar = avatar;
    notifyListeners();
  }

  // --- Campaign actions ---
  void createCampaign(CampaignModel campaign) {
    _campaigns.insert(0, campaign);
    _addNotification("New Campaign Created: ${campaign.title}");
    notifyListeners();
  }

  void submitProposal(String campaignId, ProposalModel proposal) {
    final idx = _campaigns.indexWhere((c) => c.id == campaignId);
    if (idx != -1) {
      final updatedProposals = List<ProposalModel>.from(_campaigns[idx].proposals)..add(proposal);
      _campaigns[idx] = _campaigns[idx].copyWith(proposals: updatedProposals);
      _addNotification("New proposal received for campaign: ${_campaigns[idx].title}");
      notifyListeners();
    }
  }

  void updateProposalStatus(String campaignId, String proposalId, String newStatus) {
    final idx = _campaigns.indexWhere((c) => c.id == campaignId);
    if (idx != -1) {
      final updatedProposals = _campaigns[idx].proposals.map((prop) {
        if (prop.id == proposalId) {
          return prop.copyWith(status: newStatus);
        }
        return prop;
      }).toList();

      String statusText = "open";
      if (newStatus == "accepted") {
        statusText = "in_progress";
      }

      _campaigns[idx] = _campaigns[idx].copyWith(
        proposals: updatedProposals,
        status: statusText,
      );
      _addNotification("Proposal ${newStatus} for campaign: ${_campaigns[idx].title}");
      notifyListeners();
    }
  }

  // --- Gig Actions ---
  void publishGig(GigModel gig) {
    _gigs.insert(0, gig);
    _addNotification("New Gig Published: ${gig.title}");
    notifyListeners();
  }

  // Auto-Scraper Follower Mock Simulator
  Map<String, dynamic> verifySocialLink(String platform, String url) {
    final urlLower = url.toLowerCase();
    int followers = 15000; // baseline random followers
    String channelName = "Creator Channel";

    // Dynamic heuristics based on matching strings in URL
    if (urlLower.contains("sabbir") || urlLower.contains("techbytes")) {
      followers = 75000;
      channelName = "Sabbir TechBytes";
    } else if (urlLower.contains("nabila") || urlLower.contains("closet")) {
      followers = 120000;
      channelName = "Nabila's Closet";
    } else if (urlLower.contains("rafsan") || urlLower.contains("foodie")) {
      followers = 52000;
      channelName = "Foodie Rafsan";
    } else if (urlLower.contains("adnan") || urlLower.contains("learn")) {
      followers = 150000;
      channelName = "Learn With Adnan";
    } else if (urlLower.contains("farhan") || urlLower.contains("fitness")) {
      followers = 45000;
      channelName = "Fitness With Farhan";
    } else {
      // Generate random consistent follower count based on string length
      followers = 5000 + (url.length * 350) + (platform.length * 1000);
      channelName = url.split("/").last;
      if (channelName.isEmpty || channelName == "@") {
        channelName = "Influencer Feed";
      }
    }

    return {
      "channelName": channelName,
      "followers": followers,
      "isVerified": true,
      "platform": platform,
    };
  }

  // --- Chat Actions ---
  List<ChatMessage> getChatMessages(String chatId) {
    return _chats[chatId] ?? [];
  }

  void sendChatMessage(String chatId, ChatMessage message) {
    if (!_chats.containsKey(chatId)) {
      _chats[chatId] = [];
    }
    _chats[chatId]!.add(message);
    notifyListeners();
  }

  void respondToContract(String chatId, String messageId, String status) {
    if (_chats.containsKey(chatId)) {
      final idx = _chats[chatId]!.indexWhere((msg) => msg.id == messageId);
      if (idx != -1) {
        final contract = _chats[chatId]![idx];
        _chats[chatId]![idx] = contract.copyWith(contractStatus: status);
        
        // Sync Order list
        _syncOrder(chatId, contract, status);

        _addNotification("Contract is now ${status}!");
        notifyListeners();
      }
    }
  }

  void toggleStarChat(String chatId) {
    if (_starredChats.contains(chatId)) {
      _starredChats.remove(chatId);
    } else {
      _starredChats.add(chatId);
    }
    notifyListeners();
  }

  void deliverOrder(String orderId, String deliveryNotes) {
    final idx = _orders.indexWhere((o) => o.orderId == orderId);
    if (idx != -1) {
      _orders[idx] = _orders[idx].copyWith(
        status: 'delivered',
        deliveryNotes: deliveryNotes,
      );
      _addNotification("Order $orderId has been delivered!");
      notifyListeners();
    }
  }

  void approveOrder(String orderId) {
    final idx = _orders.indexWhere((o) => o.orderId == orderId);
    if (idx != -1) {
      final order = _orders[idx];
      if (order.status != 'completed') {
        _orders[idx] = order.copyWith(status: 'completed');
        
        // Payout to Creator Available wallet
        _creatorAvailableBalance += order.price;
        
        // Also update the contract status to 'released' in chats
        final chatId = order.chatId;
        if (_chats.containsKey(chatId)) {
          final messages = _chats[chatId]!;
          final contractIdx = messages.indexWhere((m) => m.isContract);
          if (contractIdx != -1) {
            messages[contractIdx] = messages[contractIdx].copyWith(contractStatus: 'released');
          }
        }
        
        _addNotification("Order $orderId completed successfully! \$${order.price.toStringAsFixed(0)} added to Creator balance.");
        notifyListeners();
      }
    }
  }

  void depositClientFunds(double amount) {
    _clientDepositBalance += amount;
    _addNotification("Deposited \$${amount.toStringAsFixed(0)} to wallet balance.");
    notifyListeners();
  }

  void withdrawClientFunds(double amount) {
    if (amount <= _clientDepositBalance) {
      _clientDepositBalance -= amount;
      _addNotification("Withdrawn \$${amount.toStringAsFixed(0)} from deposit balance.");
      notifyListeners();
    }
  }

  void withdrawCreatorEarnings(double amount) {
    if (amount <= _creatorAvailableBalance) {
      _creatorAvailableBalance -= amount;
      _creatorWithdrawnBalance += amount;
      _addNotification("Withdrawn \$${amount.toStringAsFixed(0)} to external account.");
      notifyListeners();
    }
  }

  void _syncOrder(String chatId, ChatMessage contract, String status) {
    final existingIdx = _orders.indexWhere((o) => o.chatId == chatId);
    final orderStatus = status == 'released'
        ? 'completed'
        : status == 'paid'
            ? 'in_progress'
            : 'pending';

    // Auto-update Client wallet metrics when escrow is funded
    if (orderStatus == 'in_progress' && existingIdx == -1) {
      final budget = contract.contractBudget ?? 0.0;
      if (_clientDepositBalance >= budget) {
        _clientDepositBalance -= budget;
      } else {
        _clientLifetimeSpent += budget;
      }
    }

    if (existingIdx != -1) {
      _orders[existingIdx] = _orders[existingIdx].copyWith(status: orderStatus);
    } else {
      // Resolve client and creator details
      String client = _companyName;
      String creator = "Sabbir TechBytes";
      String avatar = "https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=150";

      if (chatId.startsWith("gig_")) {
        final gigId = chatId.substring(4);
        final gig = _gigs.firstWhere((g) => g.id == gigId, orElse: () => _gigs.first);
        creator = gig.creatorName;
        avatar = gig.creatorAvatar;
      } else {
        final parts = chatId.split("_");
        if (parts.length > 1) {
          final creatorId = parts[1];
          final cr = _creators.firstWhere((c) => c.id == creatorId, orElse: () => _creators.first);
          creator = cr.name;
          avatar = cr.avatar;
        }
      }

      _orders.insert(
        0,
        OrderModel(
          orderId: "ORD-${contract.id.substring(contract.id.length - 6).toUpperCase()}",
          chatId: chatId,
          title: contract.contractTitle ?? "Custom Deliverable",
          price: contract.contractBudget ?? 0.0,
          deliveryTime: contract.contractDeadline ?? "5 Days",
          clientName: client,
          creatorName: creator,
          creatorAvatar: avatar,
          status: orderStatus,
          createdAt: DateTime.now(),
        ),
      );
    }
  }

  // --- Notification Actions ---
  void _addNotification(String message) {
    _notifications.insert(0, message);
    if (_notifications.length > 50) {
      _notifications.removeLast();
    }
  }

  void clearNotifications() {
    _notifications.clear();
    notifyListeners();
  }

  // --- Search System ---
  List<CreatorModel> searchCreators(String query, {
    String? category,
    String? platform,
    String? location,
    int? minFollowers,
  }) {
    return _creators.where((creator) {
      final matchesQuery = query.isEmpty ||
          creator.name.toLowerCase().contains(query.toLowerCase()) ||
          creator.bio.toLowerCase().contains(query.toLowerCase());

      final matchesCategory = category == null ||
          category.isEmpty ||
          category == "All" ||
          creator.categories.contains(category);

      final matchesPlatform = platform == null ||
          platform.isEmpty ||
          platform == "All" ||
          creator.platformLinks.containsKey(platform);

      final matchesLocation = location == null ||
          location.isEmpty ||
          location == "All" ||
          creator.location.toLowerCase().contains(location.toLowerCase());

      final matchesFollowers = minFollowers == null ||
          creator.followersCount >= minFollowers;

      return matchesQuery && matchesCategory && matchesPlatform && matchesLocation && matchesFollowers;
    }).toList();
  }

  // --- Dynamic Mock AI Actions ---
  List<Map<String, dynamic>> aiMatchCampaign(String campaignRequirement) {
    String queryLower = campaignRequirement.toLowerCase();
    List<Map<String, dynamic>> matches = [];

    for (var creator in _creators) {
      int score = 70;
      List<String> reasons = [];

      bool categoryMatch = false;
      for (var cat in creator.categories) {
        if (queryLower.contains(cat.toLowerCase())) {
          categoryMatch = true;
          score += 15;
        }
      }
      if (categoryMatch) {
        reasons.add("Fits the campaign's industry niche (${creator.categories.join(', ')})");
      }

      if (queryLower.contains(creator.location.toLowerCase())) {
        score += 10;
        reasons.add("Audience located primarily in targeted area: ${creator.location}");
      }

      if (creator.engagementRate > 6.0) {
        score += 5;
        reasons.add("Highly active audience (Engagement: ${creator.engagementRate}%)");
      } else {
        reasons.add("Stable engagement profile (Engagement: ${creator.engagementRate}%)");
      }

      if (queryLower.contains("micro") && creator.followersCount < 100000) {
        score += 10;
        reasons.add("Perfect fit as a micro-influencer targeting hyper-local growth");
      } else if (queryLower.contains("macro") && creator.followersCount >= 100000) {
        score += 10;
        reasons.add("Large reach influencer suitable for national awareness campaigns");
      }

      if (score > 100) score = 100;
      if (score < 50) score = 50;

      if (score >= 70) {
        matches.add({
          "creator": creator,
          "matchPercentage": score,
          "reasons": reasons,
        });
      }
    }

    matches.sort((a, b) => (b["matchPercentage"] as int).compareTo(a["matchPercentage"] as int));
    return matches;
  }

  Map<String, String> aiGenerateScript(String campaignTitle, String productName) {
    return {
      "concept": "Engaging unboxing video with a fast-paced hook showcasing the unique aspects of $productName.",
      "hook": "Stop scrolling! If you've been looking for the ultimate way to boost your productivity, you need to see this...",
      "body": "First, the setup is incredibly simple. In under two minutes, I was up and running. Let's look at the core features. The screen responsive rate is top tier, and it integrates seamlessly with your tools. Here's a live demo of how I use it to manage my daily campaigns.",
      "callToAction": "Click the link in my bio to get an exclusive 15% discount on $productName today. Don't wait!",
      "hashtags": "#$productName #creatorreview #techunboxing #sponsored #honestreview #workspacegoals"
    };
  }

  Map<String, dynamic> aiCheckFakeFollowers(String creatorId) {
    final creator = _creators.firstWhere((c) => c.id == creatorId, orElse: () => _creators.first);
    
    List<Map<String, dynamic>> growthTimeline = [
      {"month": "Jan", "followers": (creator.followersCount * 0.85).round()},
      {"month": "Feb", "followers": (creator.followersCount * 0.88).round()},
      {"month": "Mar", "followers": (creator.followersCount * 0.92).round()},
      {"month": "Apr", "followers": (creator.followersCount * 0.95).round()},
      {"month": "May", "followers": (creator.followersCount * 0.98).round()},
      {"month": "Jun", "followers": creator.followersCount},
    ];

    return {
      "qualityScore": creator.audienceQualityScore,
      "fakeFollowersPct": creator.fakeFollowersPct,
      "growthType": creator.fakeFollowersPct > 15 ? "Spiky (Suspicious)" : "Organic (Stable)",
      "audienceReachability": "High (82% active users)",
      "growthTimeline": growthTimeline,
    };
  }

  // --- Initializing Mock Data ---
  void _loadMockData() {
    _creators = [
      CreatorModel(
        id: "1",
        name: "Sabbir TechBytes",
        avatar: "https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=150",
        categories: ["Tech", "Gaming"],
        followersCount: 75000,
        engagementRate: 8.4,
        avgViews: 45000,
        reviewsCount: 34,
        rating: 4.8,
        location: "Dhaka",
        bio: "Reviewing the latest mobile gadgets and PC builds. Helping brands connect with youth in Bangladesh.",
        platformLinks: {"YouTube": "youtube.com/c/sabbirtech", "Instagram": "instagram.com/sabbir_tech"},
        fakeFollowersPct: 4,
        audienceQualityScore: 92.5,
        audienceAgeGenders: "18-24 (62%), 25-34 (28%)",
        portfolio: ["Realme 11 Pro review", "My gaming desk tour 2026", "Top 5 software for students"],
        reviews: ["Sabbir was extremely professional and delivered the script ahead of schedule.", "Excellent engagement! We got over 1,500 app installs from his video."],
      ),
      CreatorModel(
        id: "2",
        name: "Nabila's Closet",
        avatar: "https://images.unsplash.com/photo-1494790108377-be9c29b29330?w=150",
        categories: ["Fashion", "Lifestyle"],
        followersCount: 120000,
        engagementRate: 9.1,
        avgViews: 65000,
        reviewsCount: 42,
        rating: 4.9,
        location: "Dhaka",
        bio: "Daily outfit inspiration, makeup routines, and lifestyle vlogging in Bangladesh.",
        platformLinks: {"Instagram": "instagram.com/nabilacloset", "TikTok": "tiktok.com/@nabilacloset"},
        fakeFollowersPct: 6,
        audienceQualityScore: 89.0,
        audienceAgeGenders: "13-17 (20%), 18-24 (70%)",
        portfolio: ["Summer Outfit Lookbook", "My Skincare Routine", "Shopping VLOG in Gulshan"],
        reviews: ["Great aesthetic quality. Highly recommended for clothing promotions.", "Nabila knows how to showcase products beautifully. Fun working with her!"],
      ),
      CreatorModel(
        id: "3",
        name: "Foodie Rafsan",
        avatar: "https://images.unsplash.com/photo-1500648767791-00dcc994a43e?w=150",
        categories: ["Food", "Travel"],
        followersCount: 52000,
        engagementRate: 6.8,
        avgViews: 28000,
        reviewsCount: 15,
        rating: 4.5,
        location: "Chittagong",
        bio: "Searching for the best street foods and luxury dining spaces in Bangladesh.",
        platformLinks: {"YouTube": "youtube.com/c/foodierafsan", "Facebook": "facebook.com/foodierafsan"},
        fakeFollowersPct: 12,
        audienceQualityScore: 78.4,
        audienceAgeGenders: "18-24 (45%), 25-34 (40%)",
        portfolio: ["Chittagong Mezban Tour", "Best burgers in town", "Cox's Bazar luxury resort food review"],
        reviews: ["Rafsan creates super mouthwatering videos. Our restaurant saw a huge weekend surge."],
      ),
    ];

    _campaigns = [
      CampaignModel(
        id: "c1",
        title: "Gadget Boost App Launch",
        productName: "Gadget Boost Android App",
        description: "Looking for Tech/Gaming YouTuber in Dhaka to create an review or mention of our brand new smartphone optimization application. Must show features like ram cleaner and battery saver.",
        budget: 500.0,
        deadline: "July 10, 2026",
        platform: "YouTube",
        contentType: "YouTube Video",
        requirements: "50k+ Subscribers, Dhaka Location, Tech category",
        status: "open",
        proposals: [
          ProposalModel(
            id: "p1",
            campaignId: "c1",
            creatorId: "1",
            creatorName: "Sabbir TechBytes",
            creatorAvatar: "https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=150",
            price: 450.0,
            deliveryTime: "5 Days",
            message: "Hey! I would love to make a review. Your app matches my content style perfectly.",
            status: "pending",
          )
        ],
      ),
    ];

    _gigs = [
      GigModel(
        id: "g1",
        creatorId: "1",
        creatorName: "Sabbir TechBytes",
        creatorAvatar: "https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=150",
        title: "I will make an engaging YouTube unboxing video review for your mobile phone gadget",
        description: "I will unbox your product, test key gaming features, run benchmarks, and publish an honest, engaging review on my YouTube channel. Follower base is completely local and active in Bangladesh.",
        price: 400.0,
        deliveryTime: "7 Days",
        platform: "YouTube",
        socialLink: "youtube.com/c/sabbirtech",
        verifiedFollowers: 75000,
        bannerImage: "https://images.unsplash.com/photo-1618005182384-a83a8bd57fbe?w=600",
        category: "Tech",
        region: "Dhaka, Bangladesh",
        deliverables: "1 Dedicated Review Video (8-10 mins) + 1 Community Post",
        revisions: "2 Revisions",
        youtubeLink: "youtube.com/c/sabbirtech",
        youtubeFollowers: 75000,
        instagramLink: "instagram.com/sabbir_tech",
        instagramFollowers: 15000,
        videoUrl: "https://assets.mixkit.co/videos/preview/mixkit-influencer-creating-social-media-content-34346-large.mp4",
      ),
      GigModel(
        id: "g2",
        creatorId: "2",
        creatorName: "Nabila's Closet",
        creatorAvatar: "https://images.unsplash.com/photo-1494790108377-be9c29b29330?w=150",
        title: "I will promote your fashion clothing line in a beautiful Instagram Reel",
        description: "I will film a high-quality styling reel showing different sarees/dresses from your collection. Includes caption tagging and story posts for 24 hours.",
        price: 250.0,
        deliveryTime: "4 Days",
        platform: "Instagram",
        socialLink: "instagram.com/nabilacloset",
        verifiedFollowers: 120000,
        bannerImage: "https://images.unsplash.com/photo-1512436991641-6745cdb1723f?w=600",
        category: "Fashion",
        region: "Dhaka, Bangladesh",
        deliverables: "1 Instagram Reel (30-60 secs) + 2 Stories with swipe-up link tags",
        revisions: "1 Revision",
        instagramLink: "instagram.com/nabilacloset",
        instagramFollowers: 120000,
        tiktokLink: "tiktok.com/@nabilacloset",
        tiktokFollowers: 85000,
        videoUrl: "https://assets.mixkit.co/videos/preview/mixkit-woman-recording-a-makeup-vlog-with-her-phone-34336-large.mp4",
      ),
    ];

    _chats = {
      "c1_1": [
        ChatMessage(
          id: "m_mock1",
          senderName: "Sabbir TechBytes",
          senderRole: UserRole.creator,
          text: "Hey! I would love to make a review. Your app matches my content style perfectly.",
          time: DateTime.now().subtract(const Duration(hours: 2)),
        ),
        ChatMessage(
          id: "m_mock2",
          senderName: "TechVibe Global",
          senderRole: UserRole.client,
          text: "Thanks for the interest! Can you deliver within 5 days as stated in your proposal?",
          time: DateTime.now().subtract(const Duration(minutes: 45)),
        ),
      ],
      "gig_g2": [
        ChatMessage(
          id: "m_mock3",
          senderName: "TechVibe Global",
          senderRole: UserRole.client,
          text: "Hello Nabila, we are interested in your Instagram Reel package. Can you include a discount for 3 reels?",
          time: DateTime.now().subtract(const Duration(days: 1)),
        ),
        ChatMessage(
          id: "m_mock4",
          senderName: "Nabila's Closet",
          senderRole: UserRole.creator,
          text: "Hi! Yes, I can offer a 10% discount for bulk orders. Let me know if you want to proceed.",
          time: DateTime.now().subtract(const Duration(hours: 18)),
        ),
      ]
    };

    _orders = [
      OrderModel(
        orderId: "ORD-K592X1",
        chatId: "c1_1",
        title: "Gadget Boost App Video Review",
        price: 450.0,
        deliveryTime: "5 Days",
        clientName: "TechVibe Global",
        creatorName: "Sabbir TechBytes",
        creatorAvatar: "https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=150",
        status: "in_progress",
        createdAt: DateTime.now().subtract(const Duration(days: 2)),
      ),
      OrderModel(
        orderId: "ORD-Z483L9",
        chatId: "gig_g2",
        title: "Instagram Fashion Reels Styling",
        price: 250.0,
        deliveryTime: "4 Days",
        clientName: "TechVibe Global",
        creatorName: "Nabila's Closet",
        creatorAvatar: "https://images.unsplash.com/photo-1494790108377-be9c29b29330?w=150",
        status: "completed",
        createdAt: DateTime.now().subtract(const Duration(days: 10)),
      ),
    ];
  }
}
