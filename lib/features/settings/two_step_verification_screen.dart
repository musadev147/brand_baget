import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:brand_bridge/constants/app_colors.dart';
import 'package:brand_bridge/provider/marketplace_provider.dart';

class TwoStepVerificationScreen extends StatefulWidget {
  const TwoStepVerificationScreen({super.key});

  @override
  State<TwoStepVerificationScreen> createState() => _TwoStepVerificationScreenState();
}

class _TwoStepVerificationScreenState extends State<TwoStepVerificationScreen> {
  bool _isEnrollingBiometric = false;
  String _enrollmentType = ""; // "Fingerprint" or "Face"

  void _showPhoneOtpVerificationDialog(BuildContext context, MarketplaceProvider marketplace) {
    int phase = 0; // 0 = Input Phone, 1 = Sending, 2 = Input OTP, 3 = Success
    String enteredPhone = "";
    final phoneController = TextEditingController();
    final otpController = TextEditingController();
    final formKey = GlobalKey<FormState>();

    showDialog(
      context: context,
      barrierDismissible: phase != 1 && phase != 3,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return Dialog(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              child: Container(
                padding: const EdgeInsets.all(24),
                child: Form(
                  key: formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (phase == 0) ...[
                        const Icon(Icons.phone_iphone_rounded, size: 48, color: AppColors.appThemeColor),
                        const SizedBox(height: 16),
                        const Text(
                          "Verify Phone Number",
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: AppColors.allPrimaryColor,
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          "We will send a 4-digit verification code (OTP) to your phone number.",
                          textAlign: TextAlign.center,
                          style: TextStyle(fontFamily: 'Poppins', fontSize: 11, color: Colors.grey),
                        ),
                        const SizedBox(height: 20),
                        TextFormField(
                          controller: phoneController,
                          keyboardType: TextInputType.phone,
                          decoration: InputDecoration(
                            hintText: "Enter Phone Number",
                            prefixText: "+880 ",
                            hintStyle: const TextStyle(fontFamily: 'Poppins', fontSize: 13),
                            filled: true,
                            fillColor: AppColors.cF4F5F7,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide.none,
                            ),
                          ),
                          validator: (val) {
                            if (val == null || val.isEmpty) {
                              return "Please enter your phone number";
                            }
                            if (val.length < 9) {
                              return "Please enter a valid phone number";
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 24),
                        SizedBox(
                          width: double.infinity,
                          height: 48,
                          child: ElevatedButton(
                            onPressed: () {
                              if (formKey.currentState!.validate()) {
                                enteredPhone = "+880 ${phoneController.text}";
                                setDialogState(() => phase = 1);
                                Future.delayed(const Duration(milliseconds: 1500), () {
                                  setDialogState(() => phase = 2);
                                });
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.appThemeColor,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                            ),
                            child: const Text(
                              "Send OTP Code",
                              style: TextStyle(
                                fontFamily: 'Poppins',
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ] else if (phase == 1) ...[
                        const SizedBox(height: 20),
                        const CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(AppColors.appThemeColor)),
                        const SizedBox(height: 24),
                        Text(
                          "Sending OTP code to $enteredPhone...",
                          textAlign: TextAlign.center,
                          style: const TextStyle(fontFamily: 'Poppins', fontSize: 12, color: Colors.grey),
                        ),
                        const SizedBox(height: 20),
                      ] else if (phase == 2) ...[
                        const Icon(Icons.mark_email_unread_rounded, size: 48, color: AppColors.appThemeColor),
                        const SizedBox(height: 16),
                        const Text(
                          "Enter Verification Code",
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: AppColors.allPrimaryColor,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          "Code sent to $enteredPhone. Enter the 4-digit code to verify your account (Try '1234').",
                          textAlign: TextAlign.center,
                          style: const TextStyle(fontFamily: 'Poppins', fontSize: 11, color: Colors.grey),
                        ),
                        const SizedBox(height: 20),
                        TextFormField(
                          controller: otpController,
                          keyboardType: TextInputType.number,
                          textAlign: TextAlign.center,
                          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, letterSpacing: 8),
                          decoration: InputDecoration(
                            hintText: "XXXX",
                            hintStyle: const TextStyle(fontFamily: 'Poppins', fontSize: 14, letterSpacing: 0),
                            filled: true,
                            fillColor: AppColors.cF4F5F7,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide.none,
                            ),
                          ),
                          validator: (val) {
                            if (val == null || val.isEmpty) {
                              return "Please enter OTP";
                            }
                            if (val != "1234") {
                              return "Incorrect verification code";
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 24),
                        SizedBox(
                          width: double.infinity,
                          height: 48,
                          child: ElevatedButton(
                            onPressed: () {
                              if (formKey.currentState!.validate()) {
                                setDialogState(() => phase = 3);
                                Future.delayed(const Duration(milliseconds: 1500), () {
                                  Navigator.of(context).pop();
                                  marketplace.setPhoneVerified(true, enteredPhone);
                                  marketplace.togglePhoneOtp(true);
                                  Get.snackbar(
                                    "Verification Success",
                                    "Phone OTP verification activated successfully!",
                                    backgroundColor: Colors.green,
                                    colorText: Colors.white,
                                    snackPosition: SnackPosition.BOTTOM,
                                  );
                                });
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.appThemeColor,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                            ),
                            child: const Text(
                              "Verify & Enable",
                              style: TextStyle(
                                fontFamily: 'Poppins',
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ] else if (phase == 3) ...[
                        const SizedBox(height: 20),
                        const Icon(Icons.check_circle_rounded, size: 64, color: Colors.green),
                        const SizedBox(height: 16),
                        const Text(
                          "Account Verified!",
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: AppColors.allPrimaryColor,
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          "Enabling SMS OTP Two-Step Verification...",
                          style: TextStyle(fontFamily: 'Poppins', fontSize: 11, color: Colors.grey),
                        ),
                        const SizedBox(height: 20),
                      ]
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  void _showEnrollingDialog(String type, ValueChanged<bool> onComplete) {
    setState(() {
      _isEnrollingBiometric = true;
      _enrollmentType = type;
    });

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            // Simulate enrollment phases
            Future.delayed(const Duration(milliseconds: 1500), () {
              if (Navigator.canPop(context)) {
                Navigator.of(context).pop();
                onComplete(true);
                setState(() => _isEnrollingBiometric = false);
                Get.snackbar(
                  "Success",
                  "$type registered successfully!",
                  backgroundColor: Colors.green,
                  colorText: Colors.white,
                  snackPosition: SnackPosition.BOTTOM,
                );
              }
            });

            return Dialog(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              elevation: 0,
              backgroundColor: Colors.transparent,
              child: Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.rectangle,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 10.0,
                      offset: Offset(0.0, 10.0),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "Register $type",
                      style: const TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppColors.allPrimaryColor,
                      ),
                    ),
                    const SizedBox(height: 20),
                    // Pulsing scanner simulation
                    TweenAnimationBuilder(
                      tween: Tween<double>(begin: 0.8, end: 1.2),
                      duration: const Duration(seconds: 1),
                      curve: Curves.easeInOut,
                      onEnd: () {},
                      builder: (context, double scale, child) {
                        return Transform.scale(
                          scale: scale,
                          child: Icon(
                            type == "Fingerprint"
                                ? Icons.fingerprint_rounded
                                : Icons.face_retouching_natural_rounded,
                            size: 72,
                            color: AppColors.appThemeColor,
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 24),
                    const Text(
                      "Place your sensor scan...",
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 12,
                        color: Colors.grey,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const SizedBox(
                      width: 100,
                      child: LinearProgressIndicator(
                        backgroundColor: AppColors.cF4F5F7,
                        valueColor: AlwaysStoppedAnimation<Color>(AppColors.appThemeColor),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    ).then((_) {
      setState(() => _isEnrollingBiometric = false);
    });
  }

  @override
  Widget build(BuildContext context) {
    final marketplace = Provider.of<MarketplaceProvider>(context);

    return Scaffold(
      backgroundColor: AppColors.cF5F6FA,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: AppColors.allPrimaryColor),
        title: const Text(
          "Two-Step Verification",
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
            // Shield Illustration Card
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [AppColors.allPrimaryColor, Color(0xFF1E293B)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.allPrimaryColor.withOpacity(0.15),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: const Column(
                children: [
                  Icon(
                    Icons.security_rounded,
                    size: 64,
                    color: Colors.white,
                  ),
                  SizedBox(height: 16),
                  Text(
                    "Keep your account fully secured",
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    "Two-step verification adds an additional layer of security to your account by requiring biometric approval or code verification.",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 11,
                      color: Colors.white70,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Master switch
            Card(
              color: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: SwitchListTile.adaptive(
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                activeColor: AppColors.appThemeColor,
                title: const Text(
                  "Two-Step Verification (2FA)",
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    color: AppColors.allPrimaryColor,
                  ),
                ),
                subtitle: const Text(
                  "Require an additional confirmation to access account details or release escrow funds",
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 11,
                    color: AppColors.c6C6C6C,
                  ),
                ),
                value: marketplace.isTwoStepEnabled,
                onChanged: (val) {
                  marketplace.toggleTwoStep(val);
                  if (!val) {
                    marketplace.toggleFingerprint(false);
                    marketplace.toggleFaceVerification(false);
                  }
                  Get.snackbar(
                    "Two-Step Update",
                    val ? "2-Step Verification Activated" : "2-Step Verification Deactivated",
                    backgroundColor: val ? Colors.green : Colors.orange,
                    colorText: Colors.white,
                    snackPosition: SnackPosition.BOTTOM,
                  );
                },
              ),
            ),
            const SizedBox(height: 20),

            if (marketplace.isTwoStepEnabled) ...[
              const Text(
                "SMS OTP Verification",
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: AppColors.allPrimaryColor,
                ),
              ),
              const SizedBox(height: 10),

              Card(
                color: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                child: SwitchListTile.adaptive(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  activeColor: AppColors.appThemeColor,
                  secondary: const Icon(Icons.sms_rounded, color: AppColors.appThemeColor),
                  title: const Text(
                    "SMS / Phone OTP",
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                    ),
                  ),
                  subtitle: Text(
                    marketplace.isPhoneVerified
                        ? "Phone verified: ${marketplace.phoneNumber}"
                        : "Verify phone number to receive secure login/action OTPs",
                    style: const TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 11,
                      color: AppColors.c6C6C6C,
                    ),
                  ),
                  value: marketplace.isPhoneOtpEnabled,
                  onChanged: (val) {
                    if (val) {
                      if (marketplace.isPhoneVerified) {
                        marketplace.togglePhoneOtp(true);
                      } else {
                        _showPhoneOtpVerificationDialog(context, marketplace);
                      }
                    } else {
                      marketplace.togglePhoneOtp(false);
                      Get.snackbar(
                        "Security Changed",
                        "SMS OTP verification disabled",
                        backgroundColor: Colors.orange,
                        colorText: Colors.white,
                        snackPosition: SnackPosition.BOTTOM,
                      );
                    }
                  },
                ),
              ),
              const SizedBox(height: 20),

              const Text(
                "Biometric Methods",
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: AppColors.allPrimaryColor,
                ),
              ),
              const SizedBox(height: 10),

              // Fingerprint Verification Option
              Card(
                color: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                child: SwitchListTile.adaptive(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  activeColor: AppColors.appThemeColor,
                  secondary: const Icon(Icons.fingerprint_rounded, color: AppColors.appThemeColor),
                  title: const Text(
                    "Fingerprint Scanner",
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                    ),
                  ),
                  subtitle: const Text(
                    "Verify your fingerprint scanner to confirm transactions & changes",
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 11,
                      color: AppColors.c6C6C6C,
                    ),
                  ),
                  value: marketplace.isFingerprintEnabled,
                  onChanged: (val) {
                    if (val) {
                      _showEnrollingDialog("Fingerprint", (success) {
                        if (success) marketplace.toggleFingerprint(true);
                      });
                    } else {
                      marketplace.toggleFingerprint(false);
                      Get.snackbar(
                        "Security Changed",
                        "Fingerprint verification disabled",
                        backgroundColor: Colors.orange,
                        colorText: Colors.white,
                        snackPosition: SnackPosition.BOTTOM,
                      );
                    }
                  },
                ),
              ),
              const SizedBox(height: 10),

              // Face Verification Option
              Card(
                color: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                child: SwitchListTile.adaptive(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  activeColor: AppColors.appThemeColor,
                  secondary: const Icon(Icons.face_retouching_natural_rounded, color: AppColors.appThemeColor),
                  title: const Text(
                    "Face ID / Facial Recognition",
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                    ),
                  ),
                  subtitle: const Text(
                    "Use high-precision face recognition signature details",
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 11,
                      color: AppColors.c6C6C6C,
                    ),
                  ),
                  value: marketplace.isFaceVerificationEnabled,
                  onChanged: (val) {
                    if (val) {
                      _showEnrollingDialog("Face Verification", (success) {
                        if (success) marketplace.toggleFaceVerification(true);
                      });
                    } else {
                      marketplace.toggleFaceVerification(false);
                      Get.snackbar(
                        "Security Changed",
                        "Face verification disabled",
                        backgroundColor: Colors.orange,
                        colorText: Colors.white,
                        snackPosition: SnackPosition.BOTTOM,
                      );
                    }
                  },
                ),
              ),
              const SizedBox(height: 20),

              // Additional Mock methods info
              Card(
                color: AppColors.appThemeColor.withOpacity(0.05),
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: BorderSide(color: AppColors.appThemeColor.withOpacity(0.1)),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(Icons.info_outline_rounded, color: AppColors.appThemeColor, size: 20),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Backup Verification Options",
                              style: TextStyle(
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                                color: AppColors.allPrimaryColor,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              "Email verification codes are enabled by default as a secure backup option if biometrics fail.",
                              style: TextStyle(
                                fontFamily: 'Poppins',
                                fontSize: 10.5,
                                color: Colors.grey[700],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ] else ...[
              // Warning card when 2FA is disabled
              Card(
                color: Colors.amber.shade50,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: BorderSide(color: Colors.amber.shade200),
                ),
                child: const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(Icons.warning_amber_rounded, color: Colors.amber, size: 20),
                      SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Account Protection Recommended",
                              style: TextStyle(
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                                color: AppColors.allPrimaryColor,
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              "We highly recommend enabling Two-Step Verification to protect your campaign budgets, contracts, and sensitive personal information.",
                              style: TextStyle(
                                fontFamily: 'Poppins',
                                fontSize: 10.5,
                                color: AppColors.c4A4A68,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
