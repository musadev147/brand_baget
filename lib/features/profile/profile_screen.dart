import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:brand_bridge/constants/app_colors.dart';
import 'package:brand_bridge/common_wigdets/common_button.dart';
import 'package:brand_bridge/common_wigdets/custom_textfiled.dart';
import 'package:brand_bridge/common_wigdets/user_role.dart';
import 'package:brand_bridge/provider/marketplace_provider.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  
  // Input fields
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  
  // Client specific fields
  final TextEditingController _companyController = TextEditingController();
  final TextEditingController _businessController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _budgetController = TextEditingController();

  // Creator specific fields
  final TextEditingController _bioController = TextEditingController();
  final TextEditingController _followersController = TextEditingController();
  final TextEditingController _ytController = TextEditingController();
  final TextEditingController _igController = TextEditingController();
  final TextEditingController _tiktokController = TextEditingController();
  final TextEditingController _fbController = TextEditingController();
  final TextEditingController _creatorLocationController = TextEditingController();
  final TextEditingController _categoriesController = TextEditingController();
  final TextEditingController _avgViewsController = TextEditingController();
  final TextEditingController _engagementController = TextEditingController();
  
  // 5 Portfolio Demo Video Controllers
  final TextEditingController _portfolio1Controller = TextEditingController();
  final TextEditingController _portfolio2Controller = TextEditingController();
  final TextEditingController _portfolio3Controller = TextEditingController();
  final TextEditingController _portfolio4Controller = TextEditingController();
  final TextEditingController _portfolio5Controller = TextEditingController();

  bool _isInit = true;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_isInit) {
      final marketplace = Provider.of<MarketplaceProvider>(context);
      _nameController.text = marketplace.userName;
      _emailController.text = marketplace.userEmail;
      
      if (marketplace.currentRole == UserRole.client) {
        _companyController.text = marketplace.companyName;
        _businessController.text = marketplace.businessType;
        _locationController.text = marketplace.clientLocation;
        _budgetController.text = marketplace.budgetRange.toStringAsFixed(0);
      } else {
        _bioController.text = marketplace.creatorBio;
        _followersController.text = marketplace.creatorFollowers.toString();
        _ytController.text = marketplace.creatorPlatformLinks["YouTube"] ?? "";
        _igController.text = marketplace.creatorPlatformLinks["Instagram"] ?? "";
        _tiktokController.text = marketplace.creatorPlatformLinks["TikTok"] ?? "";
        _fbController.text = marketplace.creatorPlatformLinks["Facebook"] ?? "";
        _creatorLocationController.text = marketplace.creatorLocation;
        _categoriesController.text = marketplace.creatorCategories.join(", ");
        _avgViewsController.text = marketplace.creatorAvgViews.toString();
        _engagementController.text = marketplace.creatorEngagementRate.toString();
        
        final portfolio = marketplace.creatorPortfolio;
        _portfolio1Controller.text = portfolio.isNotEmpty ? portfolio[0] : "";
        _portfolio2Controller.text = portfolio.length > 1 ? portfolio[1] : "";
        _portfolio3Controller.text = portfolio.length > 2 ? portfolio[2] : "";
        _portfolio4Controller.text = portfolio.length > 3 ? portfolio[3] : "";
        _portfolio5Controller.text = portfolio.length > 4 ? portfolio[4] : "";
      }
      _isInit = false;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _companyController.dispose();
    _businessController.dispose();
    _locationController.dispose();
    _budgetController.dispose();
    _bioController.dispose();
    _followersController.dispose();
    _ytController.dispose();
    _igController.dispose();
    _tiktokController.dispose();
    _fbController.dispose();
    _creatorLocationController.dispose();
    _categoriesController.dispose();
    _avgViewsController.dispose();
    _engagementController.dispose();
    _portfolio1Controller.dispose();
    _portfolio2Controller.dispose();
    _portfolio3Controller.dispose();
    _portfolio4Controller.dispose();
    _portfolio5Controller.dispose();
    super.dispose();
  }

  String? _validateUrl(String? val) {
    if (val == null || val.trim().isEmpty) return null;
    final trimVal = val.trim();
    final urlRegExp = RegExp(
      r'^(https?:\/\/)?(www\.)?[-a-zA-Z0-9@:%._\+~#=]{1,256}\.[a-zA-Z0-9()]{1,6}\b([-a-zA-Z0-9()@:%_\+.~#?&//=]*)$'
    );
    if (!urlRegExp.hasMatch(trimVal)) {
      return "Please enter a valid link (URL)";
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final marketplace = Provider.of<MarketplaceProvider>(context);
    final isClient = marketplace.currentRole == UserRole.client;

    return Scaffold(
      backgroundColor: AppColors.cF5F6FA,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: AppColors.allPrimaryColor),
        title: const Text(
          "Edit Profile",
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
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Stack(
                    children: [
                      CircleAvatar(
                        radius: 48,
                        backgroundImage: NetworkImage(
                          isClient
                              ? "https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?w=150"
                              : marketplace.creatorAvatar,
                        ),
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: Container(
                          padding: const EdgeInsets.all(6),
                          decoration: const BoxDecoration(color: AppColors.appThemeColor, shape: BoxShape.circle),
                          child: const Icon(Icons.camera_alt, color: Colors.white, size: 16),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 32),

                CustomTextFormField(
                  controller: _nameController,
                  labelText: "Full Name",
                  hintText: "Enter your full name",
                  validator: (val) => val == null || val.isEmpty ? "Name is required" : null,
                ),
                const SizedBox(height: 16),

                CustomTextFormField(
                  controller: _emailController,
                  labelText: "Email Address",
                  hintText: "Enter email",
                  keyboardType: TextInputType.emailAddress,
                  validator: (val) => val == null || val.isEmpty ? "Email is required" : null,
                ),
                const SizedBox(height: 16),

                if (isClient) ...[
                  CustomTextFormField(
                    controller: _companyController,
                    labelText: "Company Name",
                    hintText: "Enter company name",
                  ),
                  const SizedBox(height: 16),
                  CustomTextFormField(
                    controller: _businessController,
                    labelText: "Business Sector",
                    hintText: "e.g. E-Commerce, Tech",
                  ),
                  const SizedBox(height: 16),
                  CustomTextFormField(
                    controller: _locationController,
                    labelText: "Location",
                    hintText: "e.g. Dhaka, Bangladesh",
                  ),
                  const SizedBox(height: 16),
                  CustomTextFormField(
                    controller: _budgetController,
                    labelText: "Estimated Marketing Budget (\$)",
                    hintText: "e.g. 5000",
                    keyboardType: TextInputType.number,
                  ),
                ] else ...[
                  CustomTextFormField(
                    controller: _bioController,
                    labelText: "Creator Biography",
                    hintText: "Describe your channel content style...",
                    maxLine: 3,
                  ),
                  const SizedBox(height: 16),
                  CustomTextFormField(
                    controller: _creatorLocationController,
                    labelText: "Location",
                    hintText: "e.g. Dhaka, Bangladesh",
                  ),
                  const SizedBox(height: 16),
                  CustomTextFormField(
                    controller: _categoriesController,
                    labelText: "Categories (comma separated)",
                    hintText: "e.g. Tech, Gaming, Fashion",
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: CustomTextFormField(
                          controller: _followersController,
                          labelText: "Combined Followers",
                          hintText: "e.g. 75000",
                          keyboardType: TextInputType.number,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: CustomTextFormField(
                          controller: _avgViewsController,
                          labelText: "Average Views",
                          hintText: "e.g. 45000",
                          keyboardType: TextInputType.number,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  CustomTextFormField(
                    controller: _engagementController,
                    labelText: "Engagement Rate (%)",
                    hintText: "e.g. 8.4",
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    "Connected Platform Channels",
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: AppColors.allPrimaryColor,
                    ),
                  ),
                  const SizedBox(height: 12),
                  CustomTextFormField(
                    controller: _ytController,
                    labelText: "YouTube Link",
                    hintText: "youtube.com/c/channel",
                  ),
                  const SizedBox(height: 16),
                  CustomTextFormField(
                    controller: _igController,
                    labelText: "Instagram Link",
                    hintText: "instagram.com/profile",
                  ),
                  const SizedBox(height: 16),
                  CustomTextFormField(
                    controller: _tiktokController,
                    labelText: "TikTok Link",
                    hintText: "tiktok.com/@profile",
                  ),
                  const SizedBox(height: 16),
                  CustomTextFormField(
                    controller: _fbController,
                    labelText: "Facebook Link",
                    hintText: "facebook.com/profile",
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    "Demo Video Links (Up to 5 URLs only)",
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: AppColors.allPrimaryColor,
                    ),
                  ),
                  const SizedBox(height: 12),
                  CustomTextFormField(
                    controller: _portfolio1Controller,
                    labelText: "Demo Video Link 1",
                    hintText: "e.g. https://youtube.com/watch?v=...",
                    validator: _validateUrl,
                  ),
                  const SizedBox(height: 12),
                  CustomTextFormField(
                    controller: _portfolio2Controller,
                    labelText: "Demo Video Link 2",
                    hintText: "e.g. https://youtube.com/watch?v=...",
                    validator: _validateUrl,
                  ),
                  const SizedBox(height: 12),
                  CustomTextFormField(
                    controller: _portfolio3Controller,
                    labelText: "Demo Video Link 3",
                    hintText: "e.g. https://youtube.com/watch?v=...",
                    validator: _validateUrl,
                  ),
                  const SizedBox(height: 12),
                  CustomTextFormField(
                    controller: _portfolio4Controller,
                    labelText: "Demo Video Link 4",
                    hintText: "e.g. https://youtube.com/watch?v=...",
                    validator: _validateUrl,
                  ),
                  const SizedBox(height: 12),
                  CustomTextFormField(
                    controller: _portfolio5Controller,
                    labelText: "Demo Video Link 5",
                    hintText: "e.g. https://youtube.com/watch?v=...",
                    validator: _validateUrl,
                  ),
                ],

                const SizedBox(height: 32),
                CommonButton(
                  text: "Save Changes",
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      if (isClient) {
                        marketplace.updateClientProfile(
                          name: _nameController.text.trim(),
                          email: _emailController.text.trim(),
                          company: _companyController.text.trim(),
                          business: _businessController.text.trim(),
                          location: _locationController.text.trim(),
                          budget: double.tryParse(_budgetController.text.trim()) ?? 0.0,
                        );
                      } else {
                        marketplace.updateCreatorProfile(
                          name: _nameController.text.trim(),
                          email: _emailController.text.trim(),
                          categories: _categoriesController.text
                              .split(",")
                              .map((c) => c.trim())
                              .where((c) => c.isNotEmpty)
                              .toList(),
                          bio: _bioController.text.trim(),
                          platformLinks: {
                            if (_ytController.text.trim().isNotEmpty)
                              "YouTube": _ytController.text.trim(),
                            if (_igController.text.trim().isNotEmpty)
                              "Instagram": _igController.text.trim(),
                            if (_tiktokController.text.trim().isNotEmpty)
                              "TikTok": _tiktokController.text.trim(),
                            if (_fbController.text.trim().isNotEmpty)
                              "Facebook": _fbController.text.trim(),
                          },
                          followers: int.tryParse(_followersController.text.trim()) ?? 0,
                          avatar: marketplace.creatorAvatar,
                          location: _creatorLocationController.text.trim(),
                          avgViews: int.tryParse(_avgViewsController.text.trim()) ?? 0,
                          engagementRate: double.tryParse(_engagementController.text.trim()) ?? 0.0,
                          portfolio: [
                            if (_portfolio1Controller.text.trim().isNotEmpty) _portfolio1Controller.text.trim(),
                            if (_portfolio2Controller.text.trim().isNotEmpty) _portfolio2Controller.text.trim(),
                            if (_portfolio3Controller.text.trim().isNotEmpty) _portfolio3Controller.text.trim(),
                            if (_portfolio4Controller.text.trim().isNotEmpty) _portfolio4Controller.text.trim(),
                            if (_portfolio5Controller.text.trim().isNotEmpty) _portfolio5Controller.text.trim(),
                          ],
                        );
                      }
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Profile updated successfully")),
                      );
                    }
                  },
                  backgroundColor: AppColors.allPrimaryColor,
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
