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
      }
      _isInit = false;
    }
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
                    controller: _followersController,
                    labelText: "Total Combined Followers",
                    hintText: "e.g. 75000",
                    keyboardType: TextInputType.number,
                  ),
                  const SizedBox(height: 16),
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
                          categories: marketplace.creatorCategories,
                          bio: _bioController.text.trim(),
                          platformLinks: {
                            "YouTube": _ytController.text.trim(),
                            "Instagram": _igController.text.trim(),
                          },
                          followers: int.tryParse(_followersController.text.trim()) ?? 0,
                          avatar: marketplace.creatorAvatar,
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
