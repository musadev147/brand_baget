import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:brand_bridge/constants/app_colors.dart';
import 'package:brand_bridge/common_wigdets/common_button.dart';
import 'package:brand_bridge/common_wigdets/custom_textfiled.dart';
import 'package:brand_bridge/common_wigdets/user_role.dart';
import 'package:brand_bridge/provider/marketplace_provider.dart';
import 'package:brand_bridge/route/app_pages.dart';
import 'package:brand_bridge/common_wigdets/block_pop_up.dart';

class KycScreen extends StatefulWidget {
  const KycScreen({super.key});

  @override
  State<KycScreen> createState() => _KycScreenState();
}

class _KycScreenState extends State<KycScreen> {
  int _currentStep = 0;
  bool _nidFrontUploaded = false;
  bool _nidBackUploaded = false;
  bool _selfieCaptured = false;
  bool _isVerifying = false;
  int _verifyingPhase = 0;

  final _formKey = GlobalKey<FormState>();
  final TextEditingController _idNumController = TextEditingController();
  final TextEditingController _dobController = TextEditingController();
  final TextEditingController _regNumController = TextEditingController();

  final List<String> _verificationPhases = [
    "Checking document database...",
    "Extracting NID details with Gemini OCR...",
    "Matching face selfie biometric signatures...",
    "Verifying overall account eligibility...",
    "KYC Verification Approved!"
  ];

  @override
  void dispose() {
    _idNumController.dispose();
    _dobController.dispose();
    _regNumController.dispose();
    super.dispose();
  }

  void _nextStep() {
    if (_currentStep == 0) {
      if (_formKey.currentState!.validate()) {
        setState(() => _currentStep = 1);
      }
    } else if (_currentStep == 1) {
      if (_nidFrontUploaded && _nidBackUploaded) {
        setState(() => _currentStep = 2);
      } else {
        Get.snackbar(
          "Documents Required",
          "Please mock upload both front and back documents to proceed.",
          backgroundColor: Colors.amber[800],
          colorText: Colors.white,
        );
      }
    } else if (_currentStep == 2) {
      if (_selfieCaptured) {
        _startAiKycVerification();
      } else {
        Get.snackbar(
          "Selfie Capture Required",
          "Please capture your facial verification scan.",
          backgroundColor: Colors.amber[800],
          colorText: Colors.white,
        );
      }
    }
  }

  void _startAiKycVerification() async {
    setState(() {
      _isVerifying = true;
      _verifyingPhase = 0;
    });

    // Simulate AI pipeline phases
    for (int i = 0; i < _verificationPhases.length; i++) {
      await Future.delayed(const Duration(milliseconds: 1200));
      if (!mounted) return;
      setState(() {
        _verifyingPhase = i;
      });
    }

    await Future.delayed(const Duration(milliseconds: 800));
    if (!mounted) return;

    final marketplace = Provider.of<MarketplaceProvider>(context, listen: false);
    marketplace.setKycVerified(true);
    final route = marketplace.currentRole == UserRole.client
        ? Routes.CLIENT_HOME
        : Routes.CREATOR_HOME;

    Get.offAllNamed(route);

    Get.snackbar(
      "KYC Verification Success",
      "Your identity check was approved automatically by AI check.",
      backgroundColor: Colors.green,
      colorText: Colors.white,
    );
  }

  @override
  Widget build(BuildContext context) {
    final marketplace = Provider.of<MarketplaceProvider>(context);
    final isClient = marketplace.currentRole == UserRole.client;

    return WillPopScope(
      onWillPop: () async {
        if (_isVerifying) {
          return false;
        }
        if (_currentStep > 0) {
          setState(() => _currentStep--);
          return false;
        }
        return await BlockPopUp.showExitDialog(context);
      },
      child: Scaffold(
        backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: _currentStep > 0 && !_isVerifying
            ? IconButton(
                icon: const Icon(Icons.arrow_back, color: AppColors.allPrimaryColor),
                onPressed: () => setState(() => _currentStep--),
              )
            : null,
        title: const Text(
          "Identity Verification (KYC)",
          style: TextStyle(
            fontFamily: 'Poppins',
            fontWeight: FontWeight.bold,
            fontSize: 16,
            color: AppColors.allPrimaryColor,
          ),
        ),
        actions: [
          if (!_isVerifying)
            TextButton(
              onPressed: () {
                final marketplace = Provider.of<MarketplaceProvider>(context, listen: false);
                final route = marketplace.currentRole == UserRole.client
                    ? Routes.CLIENT_HOME
                    : Routes.CREATOR_HOME;
                Get.offAllNamed(route);
              },
              child: const Text(
                "Skip",
                style: TextStyle(
                  fontFamily: 'Poppins',
                  color: AppColors.appThemeColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
            ),
          const SizedBox(width: 8),
        ],
      ),
      body: SafeArea(
        child: _isVerifying
            ? _buildVerifyingOverlay()
            : SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Step Indicator header
                      _buildStepIndicator(),
                      const SizedBox(height: 32),

                      if (_currentStep == 0)
                        _buildStepOne(isClient)
                      else if (_currentStep == 1)
                        _buildStepTwo(isClient)
                      else
                        _buildStepThree(isClient),

                      const SizedBox(height: 40),

                      CommonButton(
                        text: _currentStep == 2 ? "Submit & Verify KYC" : "Continue to Next Step",
                        onPressed: _nextStep,
                        backgroundColor: AppColors.allPrimaryColor,
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
      ),
    ),);
  }

  Widget _buildStepIndicator() {
    return Row(
      children: [
        _buildStepBadge("1", "Details", _currentStep >= 0),
        _buildStepConnector(_currentStep > 0),
        _buildStepBadge("2", "Uploads", _currentStep >= 1),
        _buildStepConnector(_currentStep > 1),
        _buildStepBadge("3", "Selfie", _currentStep >= 2),
      ],
    );
  }

  Widget _buildStepBadge(String number, String label, bool isActive) {
    return Column(
      children: [
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: isActive ? AppColors.appThemeColor : Colors.grey[200],
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Text(
              number,
              style: TextStyle(
                fontFamily: 'Poppins',
                fontWeight: FontWeight.bold,
                fontSize: 12,
                color: isActive ? Colors.white : Colors.grey[600],
              ),
            ),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontFamily: 'Poppins',
            fontSize: 10,
            fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
            color: isActive ? AppColors.allPrimaryColor : Colors.grey[500],
          ),
        )
      ],
    );
  }

  Widget _buildStepConnector(bool isActive) {
    return Expanded(
      child: Container(
        height: 2,
        margin: const EdgeInsets.only(bottom: 14),
        color: isActive ? AppColors.appThemeColor : Colors.grey[200],
      ),
    );
  }

  Widget _buildStepOne(bool isClient) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          isClient ? "Verification Info" : "Creator KYC Information",
          style: const TextStyle(fontFamily: 'Poppins', fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.allPrimaryColor),
        ),
        const SizedBox(height: 8),
        Text(
          isClient
              ? "Provide corporate registration credentials to start campaigns."
              : "Verify your legal national identity to unlock payouts & gigs.",
          style: const TextStyle(fontFamily: 'Poppins', fontSize: 13, color: AppColors.c6C6C6C, height: 1.4),
        ),
        const SizedBox(height: 24),
        if (isClient) ...[
          CustomTextFormField(
            controller: _regNumController,
            labelText: "Trade License / Company ID",
            hintText: "e.g. REG-102948-28",
            prefixIcon: const Icon(Icons.business_center_outlined, color: Colors.grey),
            validator: (val) => val == null || val.trim().isEmpty ? "Trade license ID is required" : null,
          ),
          const SizedBox(height: 18),
        ],
        CustomTextFormField(
          controller: _idNumController,
          labelText: isClient ? "Owner NID / Passport Number" : "NID / Passport Number",
          hintText: "e.g. 1998263729102",
          keyboardType: TextInputType.number,
          prefixIcon: const Icon(Icons.badge_outlined, color: Colors.grey),
          validator: (val) => val == null || val.trim().isEmpty ? "Identity document number is required" : null,
        ),
        const SizedBox(height: 18),
        CustomTextFormField(
          controller: _dobController,
          labelText: "Date of Birth",
          hintText: "DD/MM/YYYY",
          prefixIcon: const Icon(Icons.calendar_month_outlined, color: Colors.grey),
          validator: (val) => val == null || val.trim().isEmpty ? "Date of birth is required" : null,
        ),
      ],
    );
  }

  Widget _buildStepTwo(bool isClient) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          isClient ? "License Documents Upload" : "Identity Documents Upload",
          style: const TextStyle(fontFamily: 'Poppins', fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.allPrimaryColor),
        ),
        const SizedBox(height: 8),
        const Text(
          "Select files to attach front and back views for verification.",
          style: TextStyle(fontFamily: 'Poppins', fontSize: 13, color: AppColors.c6C6C6C, height: 1.4),
        ),
        const SizedBox(height: 24),
        _buildUploadCard(
          title: isClient ? "Trade License Certificate (Front)" : "NID / Passport (Front Photo)",
          isUploaded: _nidFrontUploaded,
          onTap: () => setState(() => _nidFrontUploaded = true),
        ),
        const SizedBox(height: 16),
        _buildUploadCard(
          title: isClient ? "Owner Identification (Back Photo)" : "NID / Passport (Back Photo)",
          isUploaded: _nidBackUploaded,
          onTap: () => setState(() => _nidBackUploaded = true),
        ),
      ],
    );
  }

  Widget _buildUploadCard({required String title, required bool isUploaded, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
        decoration: BoxDecoration(
          color: isUploaded ? Colors.green.withOpacity(0.04) : Colors.grey[50],
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isUploaded ? Colors.green : Colors.grey[300]!,
            width: isUploaded ? 1.5 : 1,
            style: isUploaded ? BorderStyle.solid : BorderStyle.solid,
          ),
        ),
        child: Column(
          children: [
            Icon(
              isUploaded ? Icons.verified_rounded : Icons.cloud_upload_outlined,
              size: 40,
              color: isUploaded ? Colors.green : AppColors.appThemeColor,
            ),
            const SizedBox(height: 12),
            Text(
              title,
              style: const TextStyle(fontFamily: 'Poppins', fontSize: 13, fontWeight: FontWeight.bold, color: AppColors.allPrimaryColor),
            ),
            const SizedBox(height: 4),
            Text(
              isUploaded ? "Document attached successfully" : "Tap here to mockup scan file",
              style: TextStyle(fontFamily: 'Poppins', fontSize: 11, color: isUploaded ? Colors.green[800] : Colors.grey[500]),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStepThree(bool isClient) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Facial selfie Verification Scan",
          style: TextStyle(fontFamily: 'Poppins', fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.allPrimaryColor),
        ),
        const SizedBox(height: 8),
        const Text(
          "Take a direct facial photo to verify NID credentials match.",
          style: TextStyle(fontFamily: 'Poppins', fontSize: 13, color: AppColors.c6C6C6C, height: 1.4),
        ),
        const SizedBox(height: 32),
        Center(
          child: Stack(
            alignment: Alignment.center,
            children: [
              Container(
                width: 180,
                height: 180,
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: _selfieCaptured ? Colors.green : AppColors.appThemeColor,
                    width: 3,
                  ),
                ),
                child: ClipOval(
                  child: _selfieCaptured
                      ? Image.network(
                          isClient
                              ? "https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?w=200"
                              : "https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=200",
                          fit: BoxFit.cover,
                        )
                      : Icon(
                          Icons.face_retouching_natural_rounded,
                          size: 64,
                          color: Colors.grey[400],
                        ),
                ),
              ),
              if (!_selfieCaptured)
                Positioned(
                  bottom: 8,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.6),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Text(
                      "Place Face inside Ring",
                      style: TextStyle(fontFamily: 'Poppins', fontSize: 10, color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
            ],
          ),
        ),
        const SizedBox(height: 32),
        Center(
          child: OutlinedButton.icon(
            onPressed: () => setState(() => _selfieCaptured = true),
            icon: Icon(_selfieCaptured ? Icons.check : Icons.camera_alt),
            label: Text(_selfieCaptured ? "Face Scan Verified" : "Capture Face Selfie"),
            style: OutlinedButton.styleFrom(
              foregroundColor: _selfieCaptured ? Colors.green : AppColors.appThemeColor,
              side: BorderSide(color: _selfieCaptured ? Colors.green : AppColors.appThemeColor),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildVerifyingOverlay() {
    final progress = (_verifyingPhase + 1) / _verificationPhases.length;
    final isDone = _verifyingPhase == _verificationPhases.length - 1;

    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  width: 100,
                  height: 100,
                  child: CircularProgressIndicator(
                    value: progress,
                    strokeWidth: 6,
                    valueColor: AlwaysStoppedAnimation<Color>(isDone ? Colors.green : AppColors.appThemeColor),
                    backgroundColor: Colors.grey[200],
                  ),
                ),
                Icon(
                  isDone ? Icons.verified : Icons.auto_awesome,
                  size: 44,
                  color: isDone ? Colors.green : AppColors.appThemeColor,
                ),
              ],
            ),
            const SizedBox(height: 36),
            Text(
              _verificationPhases[_verifyingPhase],
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: isDone ? Colors.green : AppColors.allPrimaryColor,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              isDone ? "Verification Approved" : "Processing Verification...",
              style: const TextStyle(fontFamily: 'Poppins', fontSize: 12, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}
