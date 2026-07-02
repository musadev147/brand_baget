import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:brand_bridge/constants/app_colors.dart';
import 'package:brand_bridge/common_wigdets/common_button.dart';
import 'package:brand_bridge/common_wigdets/custom_textfiled.dart';
import 'package:brand_bridge/common_wigdets/user_role.dart';
import 'package:brand_bridge/provider/marketplace_provider.dart';
import 'package:get/get.dart';
import 'package:brand_bridge/route/app_pages.dart';

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
  final TextEditingController _designationController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _businessNumController = TextEditingController();
  final TextEditingController _dinController = TextEditingController();
  final TextEditingController _tinController = TextEditingController();
  String _selectedCountry = "Bangladesh";
  final List<String> _countries = [
    "Bangladesh",
    "United States",
    "United Kingdom",
    "India",
    "Canada",
    "Australia",
    "Germany",
    "Singapore",
    "United Arab Emirates",
  ];

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
        _designationController.text = marketplace.clientDesignation;
        _phoneController.text = marketplace.clientPhone;
        _businessNumController.text = marketplace.clientBusinessNumber;
        _dinController.text = marketplace.clientDinNumber;
        _tinController.text = marketplace.clientTinNumber;
        _selectedCountry = _countries.contains(marketplace.clientCountry)
            ? marketplace.clientCountry
            : _countries.first;
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
    _designationController.dispose();
    _phoneController.dispose();
    _businessNumController.dispose();
    _dinController.dispose();
    _tinController.dispose();
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
                    controller: _designationController,
                    labelText: "Designation",
                    hintText: "e.g. Director, Manager, Owner",
                  ),
                  const SizedBox(height: 16),
                  // Country Select Dropdown
                  const Text(
                    "Country",
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: AppColors.allPrimaryColor,
                    ),
                  ),
                  const SizedBox(height: 8),
                  DropdownButtonFormField<String>(
                    value: _selectedCountry,
                    style: const TextStyle(fontFamily: 'Poppins', fontSize: 13, color: AppColors.allPrimaryColor),
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(color: AppColors.cDFE0E4),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(color: AppColors.cDFE0E4),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(color: AppColors.appThemeColor),
                      ),
                    ),
                    items: _countries.map((String country) {
                      return DropdownMenuItem<String>(
                        value: country,
                        child: Text(country),
                      );
                    }).toList(),
                    onChanged: (val) {
                      if (val != null) {
                        setState(() => _selectedCountry = val);
                      }
                    },
                  ),
                  const SizedBox(height: 16),
                  CustomTextFormField(
                    controller: _phoneController,
                    labelText: "Phone Number",
                    hintText: "e.g. +880 1712-345678",
                    keyboardType: TextInputType.phone,
                  ),
                  const SizedBox(height: 16),
                  CustomTextFormField(
                    controller: _businessController,
                    labelText: "Business Sector",
                    hintText: "e.g. E-Commerce, Tech",
                  ),
                  const SizedBox(height: 16),
                  CustomTextFormField(
                    controller: _businessNumController,
                    labelText: "Business Registration Number",
                    hintText: "e.g. BN-998273-A",
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: CustomTextFormField(
                          controller: _dinController,
                          labelText: "DIN Number",
                          hintText: "e.g. DIN-8874-982",
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: CustomTextFormField(
                          controller: _tinController,
                          labelText: "TIN Number",
                          hintText: "e.g. TIN-7483-92138",
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  CustomTextFormField(
                    controller: _locationController,
                    labelText: "Location Address",
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
                  const SizedBox(height: 24),
                  const Text(
                    "Other Active Collaborations",
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: AppColors.allPrimaryColor,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Builder(
                    builder: (context) {
                      final appliedCampaigns = marketplace.campaigns.where((c) {
                        return c.proposals.any((p) => p.creatorId == "1");
                      }).toList();

                      final olderCollaborations = appliedCampaigns.isNotEmpty
                          ? appliedCampaigns.sublist(0, appliedCampaigns.length - 1)
                          : <CampaignModel>[];

                      if (olderCollaborations.isEmpty) {
                        return Card(
                          color: Colors.white,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          child: const Padding(
                            padding: EdgeInsets.all(16.0),
                            child: Center(
                              child: Text(
                                "No other active collaborations",
                                style: TextStyle(fontFamily: 'Poppins', fontSize: 12, color: Colors.grey),
                              ),
                            ),
                          ),
                        );
                      }

                      return Column(
                        children: olderCollaborations.map((campaign) {
                          final proposal = campaign.proposals.firstWhere((p) => p.creatorId == "1");

                          return Card(
                            margin: const EdgeInsets.only(bottom: 12),
                            color: Colors.white,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            child: ListTile(
                              onTap: () {
                                Get.toNamed(Routes.CHAT, arguments: {
                                  "chatId": "${campaign.id}_${proposal.creatorId}",
                                  "campaignTitle": campaign.title,
                                  "partnerName": marketplace.companyName,
                                  "partnerRole": UserRole.client,
                                });
                              },
                              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                              title: Text(
                                campaign.title,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontFamily: 'Poppins',
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.allPrimaryColor,
                                ),
                              ),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const SizedBox(height: 4),
                                  Text(
                                    "Brand: TechVibe Global • Bid: \$${proposal.price.toStringAsFixed(0)}",
                                    style: const TextStyle(
                                      fontFamily: 'Poppins',
                                      fontSize: 11,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ],
                              ),
                              trailing: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                decoration: BoxDecoration(
                                  color: proposal.status == 'accepted'
                                      ? Colors.green.withOpacity(0.1)
                                      : proposal.status == 'rejected'
                                          ? Colors.red.withOpacity(0.1)
                                          : Colors.amber.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Text(
                                  proposal.status.toUpperCase(),
                                  style: TextStyle(
                                    fontFamily: 'Poppins',
                                    fontSize: 8,
                                    fontWeight: FontWeight.bold,
                                    color: proposal.status == 'accepted'
                                        ? Colors.green
                                        : proposal.status == 'rejected'
                                            ? Colors.red
                                            : Colors.amber[800],
                                  ),
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      );
                    },
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
                          designation: _designationController.text.trim(),
                          country: _selectedCountry,
                          phone: _phoneController.text.trim(),
                          businessNumber: _businessNumController.text.trim(),
                          dinNumber: _dinController.text.trim(),
                          tinNumber: _tinController.text.trim(),
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
