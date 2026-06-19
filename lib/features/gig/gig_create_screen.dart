import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:brand_bridge/constants/app_colors.dart';
import 'package:brand_bridge/common_wigdets/common_button.dart';
import 'package:brand_bridge/common_wigdets/custom_textfiled.dart';
import 'package:brand_bridge/common_wigdets/custom_textfield_only.dart';
import 'package:brand_bridge/provider/marketplace_provider.dart';

class GigCreateScreen extends StatefulWidget {
  const GigCreateScreen({super.key});

  @override
  State<GigCreateScreen> createState() => _GigCreateScreenState();
}

class _GigCreateScreenState extends State<GigCreateScreen> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _creatorNameController;
  late final TextEditingController _creatorAvatarController;
  late final TextEditingController _bannerUrlController;
  
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _deliveryController = TextEditingController();
  final TextEditingController _regionController = TextEditingController(text: "Dhaka, Bangladesh");
  final TextEditingController _deliverablesController = TextEditingController();
  final TextEditingController _videoUrlController = TextEditingController();

  // Social link follower controllers (editable manually)
  final TextEditingController _ytFollowersController = TextEditingController(text: "0");
  final TextEditingController _ttFollowersController = TextEditingController(text: "0");
  final TextEditingController _fbFollowersController = TextEditingController(text: "0");
  final TextEditingController _igFollowersController = TextEditingController(text: "0");

  @override
  void initState() {
    super.initState();
    final marketplace = Provider.of<MarketplaceProvider>(context, listen: false);
    _creatorNameController = TextEditingController(text: marketplace.userName);
    _creatorAvatarController = TextEditingController(text: marketplace.creatorAvatar);
    _bannerUrlController = TextEditingController(text: _selectedBanner);
  }

  // Selected mock video file metadata
  String _selectedVideoFileName = "";
  String _selectedVideoDuration = "";

  // Social link controllers
  final TextEditingController _ytController = TextEditingController();
  final TextEditingController _ttController = TextEditingController();
  final TextEditingController _fbController = TextEditingController();
  final TextEditingController _igController = TextEditingController();

  // Banner selection
  String _selectedBanner = "https://images.unsplash.com/photo-1618005182384-a83a8bd57fbe?w=600";
  String _selectedBannerName = "Technology Abstract";

  // Category and Revisions
  String _selectedCategory = "Tech";
  final List<String> _categories = ["Tech", "Fashion", "Food", "Travel", "Lifestyle", "Gaming", "Education"];
  
  String _selectedRevision = "2 Revisions";
  final List<String> _revisions = ["1 Revision", "2 Revisions", "3 Revisions", "Unlimited Revisions"];

  // Verification state for social counts
  bool _isVerifying = false;
  
  // Scraped metrics
  int _ytFollowers = 0;
  String _ytChannelName = "";
  bool _ytVerified = false;

  int _ttFollowers = 0;
  String _ttChannelName = "";
  bool _ttVerified = false;

  int _fbFollowers = 0;
  String _fbChannelName = "";
  bool _fbVerified = false;

  int _igFollowers = 0;
  String _igChannelName = "";
  bool _igVerified = false;

  final Map<String, String> _bannerTemplates = {
    "Technology Abstract": "https://images.unsplash.com/photo-1618005182384-a83a8bd57fbe?w=600",
    "Fashion & Closet": "https://images.unsplash.com/photo-1512436991641-6745cdb1723f?w=600",
    "Food & Gastronomy": "https://images.unsplash.com/photo-1498837167922-ddd27525d352?w=600",
    "Modern Gradient": "https://images.unsplash.com/photo-1460925895917-afdab827c52f?w=600",
  };

  void _showBannerPicker() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Select Post Banner Template",
                style: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.bold, fontSize: 16, color: AppColors.allPrimaryColor),
              ),
              const SizedBox(height: 16),
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 1.5,
                ),
                itemCount: _bannerTemplates.length,
                itemBuilder: (context, index) {
                  final key = _bannerTemplates.keys.elementAt(index);
                  final url = _bannerTemplates[key]!;
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedBanner = url;
                        _selectedBannerName = key;
                        _bannerUrlController.text = url;
                      });
                      Navigator.pop(context);
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: _selectedBannerName == key ? AppColors.allPrimaryColor : Colors.grey[300]!,
                          width: _selectedBannerName == key ? 2 : 1,
                        ),
                        image: DecorationImage(image: NetworkImage(url), fit: BoxFit.cover),
                      ),
                      child: Container(
                        alignment: Alignment.bottomCenter,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          gradient: LinearGradient(
                            colors: [Colors.black.withOpacity(0.6), Colors.transparent],
                            begin: Alignment.bottomCenter,
                            end: Alignment.topCenter,
                          ),
                        ),
                        padding: const EdgeInsets.all(6),
                        child: Text(
                          key,
                          style: const TextStyle(fontFamily: 'Poppins', fontSize: 11, color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _showVideoPicker() {
    final Map<String, List<String>> mockVideos = {
      "Tech Review Draft (0:45)": [
        "creator_pitch_tech_review.mp4",
        "0:45",
        "https://assets.mixkit.co/videos/preview/mixkit-influencer-creating-social-media-content-34346-large.mp4"
      ],
      "Fashion Reels Showcase (1:30)": [
        "makeup_fashion_closet.mp4",
        "1:30",
        "https://assets.mixkit.co/videos/preview/mixkit-woman-recording-a-makeup-vlog-with-her-phone-34336-large.mp4"
      ],
      "Food Intro Clip (0:25)": [
        "food_gastronomy_intro.mov",
        "0:25",
        "https://assets.mixkit.co/videos/preview/mixkit-holding-a-cell-phone-with-a-vertical-video-of-a-dish-49953-large.mp4"
      ],
      "Corporate Pitch Brief (1:10)": [
        "corporate_pitch_brief.mp4",
        "1:10",
        "https://assets.mixkit.co/videos/preview/mixkit-blogging-in-front-of-a-camera-with-ring-light-34358-large.mp4"
      ],
    };

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Select Pitch Video File",
                style: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.bold, fontSize: 16, color: AppColors.allPrimaryColor),
              ),
              const SizedBox(height: 8),
              const Text(
                "Simulate picking a high-quality video file from your camera roll or local files.",
                style: TextStyle(fontFamily: 'Poppins', fontSize: 12, color: Colors.black54),
              ),
              const SizedBox(height: 16),
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: mockVideos.length,
                itemBuilder: (context, index) {
                  final key = mockVideos.keys.elementAt(index);
                  final details = mockVideos[key]!;
                  final filename = details[0];
                  final duration = details[1];
                  final url = details[2];

                  return Card(
                    color: Colors.white,
                    elevation: 0,
                    margin: const EdgeInsets.only(bottom: 10),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                      side: BorderSide(color: Colors.grey[200]!),
                    ),
                    child: ListTile(
                      leading: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: AppColors.appThemeColor.withValues(alpha: 0.1),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.video_library_rounded, color: AppColors.appThemeColor, size: 20),
                      ),
                      title: Text(
                        key,
                        style: const TextStyle(fontFamily: 'Poppins', fontSize: 13, fontWeight: FontWeight.bold, color: AppColors.allPrimaryColor),
                      ),
                      subtitle: Text(
                        "File: $filename | Duration: $duration",
                        style: const TextStyle(fontFamily: 'Poppins', fontSize: 11, color: Colors.black54),
                      ),
                      onTap: () {
                        setState(() {
                          _selectedVideoFileName = filename;
                          _selectedVideoDuration = duration;
                          _videoUrlController.text = url;
                        });
                        Navigator.pop(context);
                      },
                    ),
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _verifyAllLinks(MarketplaceProvider provider) async {
    final hasYt = _ytController.text.trim().isNotEmpty;
    final hasTt = _ttController.text.trim().isNotEmpty;
    final hasFb = _fbController.text.trim().isNotEmpty;
    final hasIg = _igController.text.trim().isNotEmpty;

    if (!hasYt && !hasTt && !hasFb && !hasIg) {
      Get.snackbar("Links Required", "Please input at least one social media link to verify.",
          backgroundColor: Colors.orange, colorText: Colors.white);
      return;
    }

    setState(() {
      _isVerifying = true;
    });

    // Simulate API scrape latency
    await Future.delayed(const Duration(seconds: 2));

    if (mounted) {
      setState(() {
        _isVerifying = false;

        if (hasYt) {
          final res = provider.verifySocialLink("YouTube", _ytController.text.trim());
          _ytChannelName = res["channelName"];
          _ytFollowers = res["followers"];
          _ytVerified = true;
          _ytFollowersController.text = _ytFollowers.toString();
        } else {
          _ytVerified = false;
          _ytFollowers = 0;
          _ytFollowersController.text = "0";
        }

        if (hasTt) {
          final res = provider.verifySocialLink("TikTok", _ttController.text.trim());
          _ttChannelName = res["channelName"];
          _ttFollowers = res["followers"];
          _ttVerified = true;
          _ttFollowersController.text = _ttFollowers.toString();
        } else {
          _ttVerified = false;
          _ttFollowers = 0;
          _ttFollowersController.text = "0";
        }

        if (hasFb) {
          final res = provider.verifySocialLink("Facebook", _fbController.text.trim());
          _fbChannelName = res["channelName"];
          _fbFollowers = res["followers"];
          _fbVerified = true;
          _fbFollowersController.text = _fbFollowers.toString();
        } else {
          _fbVerified = false;
          _fbFollowers = 0;
          _fbFollowersController.text = "0";
        }

        if (hasIg) {
          final res = provider.verifySocialLink("Instagram", _igController.text.trim());
          _igChannelName = res["channelName"];
          _igFollowers = res["followers"];
          _igVerified = true;
          _igFollowersController.text = _igFollowers.toString();
        } else {
          _igVerified = false;
          _igFollowers = 0;
          _igFollowersController.text = "0";
        }
      });

      Get.snackbar("Links Scraped", "Channel metrics updated successfully!",
          backgroundColor: Colors.green, colorText: Colors.white);
    }
  }

  @override
  Widget build(BuildContext context) {
    final marketplace = Provider.of<MarketplaceProvider>(context, listen: false);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.allPrimaryColor),
          onPressed: () => Get.back(),
        ),
        title: const Text(
          "Create Sponsorship Post",
          style: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.bold, fontSize: 16, color: AppColors.allPrimaryColor),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(color: Colors.grey[200], height: 1),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Sponsorship Post Details",
                  style: TextStyle(fontFamily: 'Poppins', fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.allPrimaryColor),
                ),
                const SizedBox(height: 16),

                // Creator Profile Details Override Section
                Card(
                  color: Colors.grey[50],
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: BorderSide(color: Colors.grey[200]!),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Row(
                          children: [
                            Icon(Icons.person_outline, color: AppColors.appThemeColor, size: 22),
                            SizedBox(width: 8),
                            Text(
                              "Creator Profile Info (Optional)",
                              style: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.bold, fontSize: 13, color: AppColors.allPrimaryColor),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        CustomTextFormField(
                          controller: _creatorNameController,
                          labelText: "Display Name Override",
                          hintText: "e.g. Sabbir TechBytes",
                          validator: (val) => val == null || val.trim().isEmpty ? "Display Name is required" : null,
                        ),
                        const SizedBox(height: 12),
                        CustomTextFormField(
                          controller: _creatorAvatarController,
                          labelText: "Avatar Image URL",
                          hintText: "Enter custom avatar image link",
                          validator: (val) => val == null || val.trim().isEmpty ? "Avatar URL is required" : null,
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // Interactive Banner Picker Card
                InkWell(
                  onTap: _showBannerPicker,
                  child: Container(
                    height: 140.h,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      image: DecorationImage(image: NetworkImage(_selectedBanner), fit: BoxFit.cover),
                      border: Border.all(color: Colors.grey[300]!),
                    ),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: Colors.black.withOpacity(0.35),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.camera_alt, color: Colors.white, size: 28),
                          const SizedBox(height: 6),
                          Text(
                            "Choose Template Banner (${_selectedBannerName})",
                            style: const TextStyle(fontFamily: 'Poppins', fontSize: 12, color: Colors.white, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // Custom Banner URL input
                CustomTextFormField(
                  controller: _bannerUrlController,
                  labelText: "Or Custom Banner Image URL",
                  hintText: "e.g. https://images.unsplash.com/photo-...",
                  onChanged: (val) {
                    setState(() {
                      _selectedBanner = val.trim();
                      _selectedBannerName = "Custom URL";
                    });
                  },
                ),
                const SizedBox(height: 20),

                // Package Title
                CustomTextFormField(
                  controller: _titleController,
                  labelText: "Sponsorship Post Title",
                  hintText: "e.g. Dedicated Video Review + Insta Reel campaign",
                  validator: (val) => val == null || val.trim().isEmpty ? "Title is required" : null,
                ),
                const SizedBox(height: 16),

                // Category & Pricing
                Row(
                  children: [
                    Expanded(
                      child: _buildDropdownField(
                        label: "Target Category",
                        value: _selectedCategory,
                        items: _categories,
                        onChanged: (val) {
                          setState(() {
                            _selectedCategory = val!;
                          });
                        },
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: CustomTextFormField(
                        controller: _priceController,
                        labelText: "Price (\$ USD)",
                        hintText: "e.g. 500",
                        keyboardType: TextInputType.number,
                        validator: (val) => val == null || double.tryParse(val) == null ? "Enter valid price" : null,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Delivery Timeline & Revisions
                Row(
                  children: [
                    Expanded(
                      child: CustomTextFormField(
                        controller: _deliveryController,
                        labelText: "Delivery Timeline",
                        hintText: "e.g. 7 Days",
                        validator: (val) => val == null || val.trim().isEmpty ? "Timeline is required" : null,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _buildDropdownField(
                        label: "Revision Limit",
                        value: _selectedRevision,
                        items: _revisions,
                        onChanged: (val) {
                          setState(() {
                            _selectedRevision = val!;
                          });
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Target Region
                CustomTextFormField(
                  controller: _regionController,
                  labelText: "Target Audience Location",
                  hintText: "e.g. Bangladesh (Dhaka based)",
                  validator: (val) => val == null || val.trim().isEmpty ? "Target location is required" : null,
                ),
                const SizedBox(height: 16),

                // Deliverables details
                CustomTextFormField(
                  controller: _deliverablesController,
                  labelText: "Deliverables List Scope",
                  hintText: "e.g. 1 dedicated YouTube video (10m) + 1 Instagram Reel",
                  validator: (val) => val == null || val.trim().isEmpty ? "Deliverables scope details are required" : null,
                ),
                const SizedBox(height: 24),

                // Social Profile Links Auto-Scraper Card
                Card(
                  color: Colors.grey[50],
                  elevation: 0,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12), side: BorderSide(color: Colors.grey[200]!)),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Row(
                          children: [
                            Icon(Icons.link, color: AppColors.appThemeColor, size: 20),
                            const SizedBox(width: 8),
                            Text(
                              "Link Social Profiles & Pages",
                              style: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.bold, fontSize: 13, color: AppColors.allPrimaryColor),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        const Text(
                          "Pasting links automatically fetches your verified follower metrics, visible to potential sponsors.",
                          style: TextStyle(fontFamily: 'Poppins', fontSize: 11, color: Colors.black54, height: 1.3),
                        ),
                        const SizedBox(height: 16),

                        // YouTube URL
                        _buildSocialUrlInput(
                          label: "YouTube Channel Link",
                          controller: _ytController,
                          followersController: _ytFollowersController,
                          hintText: "e.g. youtube.com/c/mytechchannel",
                          icon: Icons.play_circle_fill,
                          iconColor: Colors.red,
                          isVerified: _ytVerified,
                          channelName: _ytChannelName,
                          followers: _ytFollowers,
                        ),
                        const SizedBox(height: 12),

                        // TikTok URL
                        _buildSocialUrlInput(
                          label: "TikTok Profile Link",
                          controller: _ttController,
                          followersController: _ttFollowersController,
                          hintText: "e.g. tiktok.com/@myfashionfeed",
                          icon: Icons.music_note,
                          iconColor: Colors.black,
                          isVerified: _ttVerified,
                          channelName: _ttChannelName,
                          followers: _ttFollowers,
                        ),
                        const SizedBox(height: 12),

                        // Facebook URL
                        _buildSocialUrlInput(
                          label: "Facebook Page Link",
                          controller: _fbController,
                          followersController: _fbFollowersController,
                          hintText: "e.g. facebook.com/myfoodvlog",
                          icon: Icons.facebook,
                          iconColor: Colors.blue[800]!,
                          isVerified: _fbVerified,
                          channelName: _fbChannelName,
                          followers: _fbFollowers,
                        ),
                        const SizedBox(height: 12),

                        // Instagram URL
                        _buildSocialUrlInput(
                          label: "Instagram Profile Link",
                          controller: _igController,
                          followersController: _igFollowersController,
                          hintText: "e.g. instagram.com/mylifestyle",
                          icon: Icons.camera_alt,
                          iconColor: Colors.purple,
                          isVerified: _igVerified,
                          channelName: _igChannelName,
                          followers: _igFollowers,
                        ),
                        const SizedBox(height: 20),

                        // Fetch Action button
                        SizedBox(
                          width: double.infinity,
                          height: 44,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.appThemeColor,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                              elevation: 0,
                            ),
                            onPressed: _isVerifying ? null : () => _verifyAllLinks(marketplace),
                            child: _isVerifying
                                ? const SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                                  )
                                : const Text(
                                    "Auto-Verify & Fetch Followers",
                                    style: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.bold, fontSize: 13, color: Colors.white),
                                  ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // Pitch Video Selection Card
                Card(
                  color: Colors.grey[50],
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: BorderSide(color: Colors.grey[200]!),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Row(
                          children: [
                            Icon(Icons.video_call_rounded, color: AppColors.appThemeColor, size: 22),
                            SizedBox(width: 8),
                            Text(
                              "Sponsorship Pitch Video (Optional)",
                              style: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.bold, fontSize: 13, color: AppColors.allPrimaryColor),
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        const Text(
                          "Add a short video pitch, portfolio walkthrough, or review sample to attract premium sponsors.",
                          style: TextStyle(fontFamily: 'Poppins', fontSize: 11, color: Colors.black54, height: 1.3),
                        ),
                        const SizedBox(height: 16),

                        // Option 1: URL input
                        CustomTextFormField(
                          controller: _videoUrlController,
                          labelText: "Video Stream URL / Embed Link",
                          hintText: "e.g. youtube.com/watch?v=mypitch",
                          onChanged: (val) {
                            if (val.trim().isNotEmpty && _selectedVideoFileName.isNotEmpty) {
                              setState(() {
                                _selectedVideoFileName = "";
                                _selectedVideoDuration = "";
                              });
                            }
                          },
                        ),
                        const SizedBox(height: 12),

                        // Divider OR
                        Row(
                          children: [
                            Expanded(child: Divider(color: Colors.grey[300])),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 10.0),
                              child: Text(
                                "OR SELECT LOCAL FILE",
                                style: TextStyle(fontFamily: 'Poppins', fontSize: 9, fontWeight: FontWeight.bold, color: Colors.grey[400]),
                              ),
                            ),
                            Expanded(child: Divider(color: Colors.grey[300])),
                          ],
                        ),
                        const SizedBox(height: 12),

                        // Option 2: File Picker trigger
                        if (_selectedVideoFileName.isEmpty)
                          SizedBox(
                            width: double.infinity,
                            height: 44,
                            child: OutlinedButton.icon(
                              style: OutlinedButton.styleFrom(
                                side: const BorderSide(color: AppColors.appThemeColor),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                              ),
                              onPressed: _showVideoPicker,
                              icon: const Icon(Icons.video_library_rounded, color: AppColors.appThemeColor, size: 18),
                              label: const Text(
                                "Pick Video Pitch File",
                                style: TextStyle(fontFamily: 'Poppins', fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.appThemeColor),
                              ),
                            ),
                          )
                        else
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: Colors.grey[200]!),
                            ),
                            child: Row(
                              children: [
                                const Icon(Icons.check_circle, color: Colors.green, size: 20),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        _selectedVideoFileName,
                                        style: const TextStyle(fontFamily: 'Poppins', fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.allPrimaryColor),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      Text(
                                        "Duration: $_selectedVideoDuration (Simulated local draft)",
                                        style: const TextStyle(fontFamily: 'Poppins', fontSize: 10, color: Colors.black54),
                                      ),
                                    ],
                                  ),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.cancel, color: Colors.red, size: 20),
                                  onPressed: () {
                                    setState(() {
                                      _selectedVideoFileName = "";
                                      _selectedVideoDuration = "";
                                      _videoUrlController.clear();
                                    });
                                  },
                                ),
                              ],
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // Scope text
                CustomTextFormField(
                  controller: _descController,
                  labelText: "Campaign Delivery Terms",
                  hintText: "Detailed explanation of project workflow, constraints, timeline...",
                  maxLine: 4,
                  validator: (val) => val == null || val.trim().isEmpty ? "Terms scope is required" : null,
                ),
                const SizedBox(height: 28),

                // Publish action
                CommonButton(
                  text: "Publish Sponsorship Post",
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      final hasLinked = _ytController.text.trim().isNotEmpty ||
                          _ttController.text.trim().isNotEmpty ||
                          _fbController.text.trim().isNotEmpty ||
                          _igController.text.trim().isNotEmpty;
                      if (!hasLinked) {
                        Get.snackbar("Links Required", "Please input at least one social media link before publishing.",
                            backgroundColor: Colors.orange, colorText: Colors.white);
                        return;
                      }

                      // Parse manual followers
                      final ytFollowers = int.tryParse(_ytFollowersController.text.trim()) ?? 0;
                      final ttFollowers = int.tryParse(_ttFollowersController.text.trim()) ?? 0;
                      final fbFollowers = int.tryParse(_fbFollowersController.text.trim()) ?? 0;
                      final igFollowers = int.tryParse(_igFollowersController.text.trim()) ?? 0;

                      // Primary platform resolution
                      String primaryPlatform = "YouTube";
                      String primaryLink = "";
                      int primaryFollowers = 0;

                      if (_ytController.text.trim().isNotEmpty) {
                        primaryPlatform = "YouTube";
                        primaryLink = _ytController.text.trim();
                        primaryFollowers = ytFollowers;
                      } else if (_ttController.text.trim().isNotEmpty) {
                        primaryPlatform = "TikTok";
                        primaryLink = _ttController.text.trim();
                        primaryFollowers = ttFollowers;
                      } else if (_fbController.text.trim().isNotEmpty) {
                        primaryPlatform = "Facebook";
                        primaryLink = _fbController.text.trim();
                        primaryFollowers = fbFollowers;
                      } else if (_igController.text.trim().isNotEmpty) {
                        primaryPlatform = "Instagram";
                        primaryLink = _igController.text.trim();
                        primaryFollowers = igFollowers;
                      }

                      final newPost = GigModel(
                        id: "g${marketplace.gigs.length + 1}",
                        creatorId: "1",
                        creatorName: _creatorNameController.text.trim(),
                        creatorAvatar: _creatorAvatarController.text.trim(),
                        title: _titleController.text.trim(),
                        description: _descController.text.trim(),
                        price: double.parse(_priceController.text.trim()),
                        deliveryTime: _deliveryController.text.trim(),
                        platform: primaryPlatform,
                        socialLink: primaryLink,
                        verifiedFollowers: primaryFollowers,
                        // New fields
                        bannerImage: _selectedBanner,
                        category: _selectedCategory,
                        region: _regionController.text.trim(),
                        deliverables: _deliverablesController.text.trim(),
                        revisions: _selectedRevision,
                        youtubeLink: _ytController.text.trim(),
                        youtubeFollowers: ytFollowers,
                        tiktokLink: _ttController.text.trim(),
                        tiktokFollowers: ttFollowers,
                        facebookLink: _fbController.text.trim(),
                        facebookFollowers: fbFollowers,
                        instagramLink: _igController.text.trim(),
                        instagramFollowers: igFollowers,
                        videoUrl: _videoUrlController.text.trim(),
                      );

                      marketplace.publishGig(newPost);
                      Get.back();
                      Get.snackbar("Success", "Sponsorship Post successfully listed!",
                          backgroundColor: Colors.green, colorText: Colors.white);
                    }
                  },
                  backgroundColor: AppColors.allPrimaryColor,
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDropdownField({
    required String label,
    required String value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontFamily: 'Poppins', fontSize: 13, fontWeight: FontWeight.bold, color: AppColors.allPrimaryColor)),
        const SizedBox(height: 6),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey[300]!),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: value,
              isExpanded: true,
              style: const TextStyle(fontFamily: 'Poppins', fontSize: 13, color: AppColors.allPrimaryColor),
              items: items.map((item) {
                return DropdownMenuItem<String>(
                  value: item,
                  child: Text(item),
                );
              }).toList(),
              onChanged: onChanged,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSocialUrlInput({
    required String label,
    required TextEditingController controller,
    required TextEditingController followersController,
    required String hintText,
    required IconData icon,
    required Color iconColor,
    required bool isVerified,
    required String channelName,
    required int followers,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, color: iconColor, size: 16),
            const SizedBox(width: 6),
            Text(label, style: const TextStyle(fontFamily: 'Poppins', fontSize: 11, fontWeight: FontWeight.bold, color: AppColors.allPrimaryColor)),
          ],
        ),
        const SizedBox(height: 4),
        Row(
          children: [
            Expanded(
              flex: 3,
              child: CustomTextFormFieldOnly(
                controller: controller,
                hintText: hintText,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              flex: 1,
              child: CustomTextFormFieldOnly(
                controller: followersController,
                hintText: "Followers",
                keyboardType: TextInputType.number,
              ),
            ),
          ],
        ),
        if (isVerified) ...[
          const SizedBox(height: 4),
          Row(
            children: [
              const Icon(Icons.check_circle, color: Colors.green, size: 14),
              const SizedBox(width: 4),
              Expanded(
                child: Text(
                  "Verified: ${channelName} • ${followers.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')} followers",
                  style: const TextStyle(fontFamily: 'Poppins', fontSize: 11, color: Colors.green, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ],
      ],
    );
  }
}
