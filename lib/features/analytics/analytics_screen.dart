import 'package:flutter/material.dart';
import 'package:brand_bridge/constants/app_colors.dart';

class AnalyticsScreen extends StatelessWidget {
  const AnalyticsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          "Performance Insights",
          style: TextStyle(
            fontFamily: 'Poppins', 
            fontWeight: FontWeight.bold, 
            fontSize: 16, 
            color: AppColors.allPrimaryColor,
          ),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(
            color: Colors.grey[200],
            height: 1,
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Creator Statistics",
                style: TextStyle(
                  fontFamily: 'Poppins', 
                  fontSize: 18, 
                  fontWeight: FontWeight.bold, 
                  color: AppColors.allPrimaryColor,
                ),
              ),
              const SizedBox(height: 16),

              // Grid of Key Performance Indicators
              GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 1.3,
                children: [
                  _buildKpiCard("Video Views", "185,400", Icons.remove_red_eye_rounded, Colors.amber),
                  _buildKpiCard("Total Reach", "342,000", Icons.rocket_rounded, Colors.purple),
                  _buildKpiCard("Avg Engagement", "8.9%", Icons.bolt_rounded, Colors.teal),
                  _buildKpiCard("Conversions", "3.4%", Icons.shopping_cart_rounded, Colors.green),
                ],
              ),
              const SizedBox(height: 28),

              // Performance Trend Visualizer (Bar Chart mockup using standard widgets for safety & aesthetics)
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.grey[200]!),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.03),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Weekly Reach Trend",
                        style: TextStyle(
                          fontFamily: 'Poppins', 
                          fontWeight: FontWeight.bold, 
                          fontSize: 14, 
                          color: AppColors.allPrimaryColor,
                        ),
                      ),
                      const SizedBox(height: 24),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          _buildChartBar("W1", 40),
                          _buildChartBar("W2", 70),
                          _buildChartBar("W3", 110),
                          _buildChartBar("W4", 90),
                          _buildChartBar("W5", 150),
                          _buildChartBar("W6", 130),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 28),

              // Campaign Breakdowns
              const Text(
                "Individual Sponsorship Results",
                style: TextStyle(
                  fontFamily: 'Poppins', 
                  fontSize: 16, 
                  fontWeight: FontWeight.bold, 
                  color: AppColors.allPrimaryColor,
                ),
              ),
              const SizedBox(height: 12),

              _buildCreatorAnalyticsRow(
                name: "TechVibe Global (Optimization App)",
                views: "48,200",
                engagement: "9.2%",
                status: "Completed",
                avatar: "https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=150",
              ),
              const SizedBox(height: 12),
              _buildCreatorAnalyticsRow(
                name: "Aura Premium Collection",
                views: "72,500",
                engagement: "11.1%",
                status: "In Progress",
                avatar: "https://images.unsplash.com/photo-1494790108377-be9c29b29330?w=150",
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildKpiCard(String label, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(color: color.withOpacity(0.12), shape: BoxShape.circle),
                child: Icon(icon, color: color, size: 20),
              ),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                value, 
                style: const TextStyle(
                  fontFamily: 'Poppins', 
                  fontSize: 20, 
                  fontWeight: FontWeight.bold, 
                  color: AppColors.allPrimaryColor,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                label, 
                style: const TextStyle(
                  fontFamily: 'Poppins', 
                  fontSize: 11, 
                  color: Colors.black54,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildChartBar(String label, double height) {
    return Column(
      children: [
        Container(
          width: 24,
          height: height,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(6),
            gradient: const LinearGradient(
              colors: [Colors.amber, Colors.orange],
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: const TextStyle(
            fontFamily: 'Poppins', 
            fontSize: 11, 
            color: Colors.black54, 
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildCreatorAnalyticsRow({
    required String name,
    required String views,
    required String engagement,
    required String status,
    required String avatar,
  }) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 20,
            backgroundImage: NetworkImage(avatar),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name, 
                  style: const TextStyle(
                    fontFamily: 'Poppins', 
                    fontWeight: FontWeight.bold, 
                    fontSize: 13, 
                    color: AppColors.allPrimaryColor,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  "Status: $status",
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 11,
                    color: status == 'Completed' ? Colors.green[700] : Colors.orange[700],
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                "$views views", 
                style: const TextStyle(
                  fontFamily: 'Poppins', 
                  fontWeight: FontWeight.bold, 
                  fontSize: 13, 
                  color: AppColors.allPrimaryColor,
                ),
              ),
              Text(
                "ER: $engagement", 
                style: const TextStyle(
                  fontFamily: 'Poppins', 
                  fontSize: 11, 
                  color: Colors.black54,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
