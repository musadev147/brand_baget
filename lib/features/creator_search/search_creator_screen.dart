import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:brand_bridge/constants/app_colors.dart';
import 'package:brand_bridge/provider/marketplace_provider.dart';
import 'package:brand_bridge/route/app_pages.dart';

class SearchCreatorScreen extends StatefulWidget {
  const SearchCreatorScreen({super.key});

  @override
  State<SearchCreatorScreen> createState() => _SearchCreatorScreenState();
}

class _SearchCreatorScreenState extends State<SearchCreatorScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _selectedCategory = "All";
  String _selectedPlatform = "All";
  String _selectedLocation = "All";

  final List<String> _categories = ["All", "Tech", "Gaming", "Fashion", "Food", "Travel", "Education", "Fitness"];
  final List<String> _platforms = ["All", "YouTube", "Instagram", "Facebook", "TikTok"];
  final List<String> _locations = ["All", "Dhaka", "Chittagong"];

  @override
  Widget build(BuildContext context) {
    final marketplace = Provider.of<MarketplaceProvider>(context);
    final results = marketplace.searchCreators(
      _searchController.text,
      category: _selectedCategory,
      platform: _selectedPlatform,
      location: _selectedLocation,
    );

    return Scaffold(
      backgroundColor: AppColors.cF5F6FA,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: AppColors.allPrimaryColor),
        title: const Text(
          "Discover Creators",
          style: TextStyle(
            fontFamily: 'Poppins',
            fontWeight: FontWeight.bold,
            fontSize: 18,
            color: AppColors.allPrimaryColor,
          ),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Search Input and Filters Area
            Container(
              padding: const EdgeInsets.all(16.0),
              color: Colors.white,
              child: Column(
                children: [
                  TextField(
                    controller: _searchController,
                    onChanged: (val) => setState(() {}),
                    decoration: InputDecoration(
                      hintText: "Search creators (e.g. tech, fashion...)",
                      hintStyle: const TextStyle(fontFamily: 'Poppins', fontSize: 13),
                      prefixIcon: const Icon(Icons.search, color: Colors.grey),
                      filled: true,
                      fillColor: AppColors.cF5F6FA,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 16),
                    ),
                  ),
                  const SizedBox(height: 12),
                  // Dropdown filters row
                  Row(
                    children: [
                      _buildDropdownFilter(
                        label: "Category",
                        value: _selectedCategory,
                        items: _categories,
                        onChanged: (val) {
                          setState(() {
                            _selectedCategory = val!;
                          });
                        },
                      ),
                      const SizedBox(width: 8),
                      _buildDropdownFilter(
                        label: "Platform",
                        value: _selectedPlatform,
                        items: _platforms,
                        onChanged: (val) {
                          setState(() {
                            _selectedPlatform = val!;
                          });
                        },
                      ),
                      const SizedBox(width: 8),
                      _buildDropdownFilter(
                        label: "Location",
                        value: _selectedLocation,
                        items: _locations,
                        onChanged: (val) {
                          setState(() {
                            _selectedLocation = val!;
                          });
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
            // Results list
            Expanded(
              child: results.isEmpty
                  ? const Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.search_off_rounded, size: 54, color: Colors.grey),
                          SizedBox(height: 12),
                          Text(
                            "No creators found",
                            style: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.bold, color: Colors.grey),
                          ),
                        ],
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.all(16.0),
                      itemCount: results.length,
                      itemBuilder: (context, idx) {
                        final creator = results[idx];
                        return Card(
                          margin: const EdgeInsets.only(bottom: 16.0),
                          color: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: InkWell(
                            onTap: () {
                              Get.toNamed(Routes.CREATOR_PROFILE, arguments: creator);
                            },
                            borderRadius: BorderRadius.circular(12),
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  CircleAvatar(
                                    radius: 32,
                                    backgroundImage: NetworkImage(creator.avatar),
                                  ),
                                  const SizedBox(width: 16),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Expanded(
                                              child: Row(
                                                children: [
                                                  Flexible(
                                                    child: Text(
                                                      creator.name,
                                                      maxLines: 1,
                                                      overflow: TextOverflow.ellipsis,
                                                      style: const TextStyle(
                                                        fontFamily: 'Poppins',
                                                        fontSize: 16,
                                                        fontWeight: FontWeight.bold,
                                                        color: AppColors.allPrimaryColor,
                                                      ),
                                                    ),
                                                  ),
                                                  if (creator.id == "1" ? marketplace.isKycVerified : true) ...[
                                                    const SizedBox(width: 4),
                                                    const Icon(Icons.verified, color: Colors.blue, size: 16),
                                                  ],
                                                ],
                                              ),
                                            ),
                                            Row(
                                              children: [
                                                const Icon(Icons.star, color: Colors.amber, size: 16),
                                                const SizedBox(width: 2),
                                                Text(
                                                  "${creator.rating}",
                                                  style: const TextStyle(
                                                    fontFamily: 'Poppins',
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 4),
                                        // Categories chip row
                                        Row(
                                          children: creator.categories.map((cat) {
                                            return Container(
                                              margin: const EdgeInsets.only(right: 6),
                                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                              decoration: BoxDecoration(
                                                color: AppColors.appThemeColor.withOpacity(0.08),
                                                borderRadius: BorderRadius.circular(4),
                                              ),
                                              child: Text(
                                                cat,
                                                style: const TextStyle(
                                                  fontFamily: 'Poppins',
                                                  fontSize: 10,
                                                  fontWeight: FontWeight.bold,
                                                  color: AppColors.appThemeColor,
                                                ),
                                              ),
                                            );
                                          }).toList(),
                                        ),
                                        const SizedBox(height: 8),
                                        Text(
                                          creator.bio,
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                          style: const TextStyle(
                                            fontFamily: 'Poppins',
                                            fontSize: 12,
                                            color: AppColors.c6C6C6C,
                                            height: 1.4,
                                          ),
                                        ),
                                        const SizedBox(height: 12),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              "${(creator.followersCount / 1000).toStringAsFixed(0)}k followers",
                                              style: const TextStyle(
                                                fontFamily: 'Poppins',
                                                fontSize: 13,
                                                fontWeight: FontWeight.bold,
                                                color: AppColors.allPrimaryColor,
                                              ),
                                            ),
                                            Text(
                                              "ER: ${creator.engagementRate}%",
                                              style: const TextStyle(
                                                fontFamily: 'Poppins',
                                                fontSize: 12,
                                                color: Colors.green,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
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
          ],
        ),
      ),
    );
  }

  Widget _buildDropdownFilter({
    required String label,
    required String value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
  }) {
    return Expanded(
      child: Container(
        height: 38,
        padding: const EdgeInsets.symmetric(horizontal: 8),
        decoration: BoxDecoration(
          color: AppColors.cF5F6FA,
          borderRadius: BorderRadius.circular(8),
        ),
        child: DropdownButtonHideUnderline(
          child: DropdownButton<String>(
            value: value,
            isExpanded: true,
            style: const TextStyle(fontFamily: 'Poppins', fontSize: 11, color: AppColors.allPrimaryColor, fontWeight: FontWeight.bold),
            icon: const Icon(Icons.arrow_drop_down, size: 18),
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
    );
  }
}
