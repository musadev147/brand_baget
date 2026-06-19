import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:brand_bridge/constants/app_colors.dart';
import 'package:brand_bridge/common_wigdets/common_button.dart';
import 'package:brand_bridge/common_wigdets/custom_textfiled.dart';
import 'package:brand_bridge/provider/marketplace_provider.dart';

class CampaignCreateScreen extends StatefulWidget {
  const CampaignCreateScreen({super.key});

  @override
  State<CampaignCreateScreen> createState() => _CampaignCreateScreenState();
}

class _CampaignCreateScreenState extends State<CampaignCreateScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _productController = TextEditingController();
  final TextEditingController _descController = TextEditingController();
  final TextEditingController _budgetController = TextEditingController();
  final TextEditingController _requirementsController = TextEditingController();

  String _selectedPlatform = "YouTube";
  String _selectedContentType = "Video";
  final List<String> _platforms = ["YouTube", "Instagram", "Facebook", "TikTok"];
  final List<String> _contentTypes = ["Video", "Short Video/Reel", "Post", "Live Stream"];

  // AI Assistant States
  bool _isGeneratingAi = false;
  Map<String, String>? _aiOutput;

  void _generateAiContent(MarketplaceProvider provider) async {
    final title = _titleController.text.trim();
    final product = _productController.text.trim();
    if (title.isEmpty || product.isEmpty) {
      Get.snackbar("Missing Fields", "Please enter Campaign Title and Product Name first to use the AI assistant.",
          backgroundColor: Colors.orange, colorText: Colors.white);
      return;
    }

    setState(() {
      _isGeneratingAi = true;
      _aiOutput = null;
    });

    await Future.delayed(const Duration(seconds: 2));

    if (mounted) {
      setState(() {
        _isGeneratingAi = false;
        _aiOutput = provider.aiGenerateScript(title, product);
        // Pre-fill campaign description if empty
        if (_descController.text.isEmpty) {
          _descController.text = "Campaign Concept: ${_aiOutput!['concept']}\n\nSuggested Hook: ${_aiOutput!['hook']}";
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final marketplace = Provider.of<MarketplaceProvider>(context, listen: false);

    return Scaffold(
      backgroundColor: AppColors.cF5F6FA,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: AppColors.allPrimaryColor),
        title: const Text(
          "Create Campaign",
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
                const Text(
                  "Campaign Details",
                  style: TextStyle(fontFamily: 'Poppins', fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.allPrimaryColor),
                ),
                const SizedBox(height: 16),

                CustomTextFormField(
                  controller: _titleController,
                  labelText: "Campaign Title",
                  hintText: "e.g. Android Optimization Video Promotion",
                  validator: (val) => val == null || val.trim().isEmpty ? "Title is required" : null,
                ),
                const SizedBox(height: 16),

                CustomTextFormField(
                  controller: _productController,
                  labelText: "Product Name",
                  hintText: "e.g. Gadget Boost App",
                  validator: (val) => val == null || val.trim().isEmpty ? "Product name is required" : null,
                ),
                const SizedBox(height: 16),

                Row(
                  children: [
                    Expanded(
                      child: _buildDropdownField(
                        label: "Platform",
                        value: _selectedPlatform,
                        items: _platforms,
                        onChanged: (val) => setState(() => _selectedPlatform = val!),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _buildDropdownField(
                        label: "Content Type",
                        value: _selectedContentType,
                        items: _contentTypes,
                        onChanged: (val) => setState(() => _selectedContentType = val!),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                Row(
                  children: [
                    Expanded(
                      child: CustomTextFormField(
                        controller: _budgetController,
                        labelText: "Budget (\$ USD)",
                        hintText: "e.g. 500",
                        keyboardType: TextInputType.number,
                        validator: (val) => val == null || double.tryParse(val) == null ? "Enter a valid budget" : null,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: CustomTextFormField(
                        controller: _requirementsController,
                        labelText: "Creator Requirements",
                        hintText: "e.g. 50k+ subs, Tech category",
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // AI Campaign Assistant trigger
                Card(
                  color: AppColors.appThemeColor.withOpacity(0.06),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: const BorderSide(color: AppColors.appThemeColor, width: 1),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.auto_awesome, color: AppColors.appThemeColor, size: 20),
                            const SizedBox(width: 8),
                            const Text(
                              "AI Campaign Assistant",
                              style: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.bold, fontSize: 14, color: AppColors.allPrimaryColor),
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        const Text(
                          "Instantly generate campaign ideas, hooks, captions, and hashtags based on your title & product name.",
                          style: TextStyle(fontFamily: 'Poppins', fontSize: 11, color: AppColors.c6C6C6C, height: 1.3),
                        ),
                        const SizedBox(height: 12),
                        if (_aiOutput == null && !_isGeneratingAi)
                          ElevatedButton(
                            onPressed: () => _generateAiContent(marketplace),
                            child: const Text("Generate Concept & Script"),
                          ),
                        if (_isGeneratingAi)
                          const Row(
                            children: [
                              SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2)),
                              SizedBox(width: 12),
                              Text("Creating ideas with AI...", style: TextStyle(fontFamily: 'Poppins', fontSize: 13, color: AppColors.c6C6C6C)),
                            ],
                          ),
                        if (_aiOutput != null) ...[
                          const Divider(height: 20),
                          _buildAiOutputField("Concept Idea", _aiOutput!['concept']!),
                          _buildAiOutputField("Suggested Hook", _aiOutput!['hook']!),
                          _buildAiOutputField("Hashtags", _aiOutput!['hashtags']!),
                        ],
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                CustomTextFormField(
                  controller: _descController,
                  labelText: "Campaign Description",
                  hintText: "Enter requirements, content scope, key delivery milestones...",
                  maxLine: 4,
                  validator: (val) => val == null || val.trim().isEmpty ? "Description is required" : null,
                ),
                const SizedBox(height: 28),

                CommonButton(
                  text: "Publish Campaign",
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      final newCampaign = CampaignModel(
                        id: "c${marketplace.campaigns.length + 1}",
                        title: _titleController.text.trim(),
                        productName: _productController.text.trim(),
                        description: _descController.text.trim(),
                        budget: double.parse(_budgetController.text.trim()),
                        deadline: "30 Days from now",
                        platform: _selectedPlatform,
                        contentType: _selectedContentType,
                        requirements: _requirementsController.text.trim(),
                        status: "open",
                        proposals: [],
                      );
                      marketplace.createCampaign(newCampaign);
                      Get.back();
                      Get.snackbar("Success", "Campaign successfully published!",
                          backgroundColor: Colors.green, colorText: Colors.white);
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
            border: Border.all(color: Colors.grey),
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

  Widget _buildAiOutputField(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.bold, fontSize: 11, color: AppColors.appThemeColor)),
          const SizedBox(height: 2),
          Text(value, style: const TextStyle(fontFamily: 'Poppins', fontSize: 12, color: AppColors.allPrimaryColor)),
        ],
      ),
    );
  }
}
