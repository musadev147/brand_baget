import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:brand_bridge/constants/app_colors.dart';
import 'package:brand_bridge/common_wigdets/common_button.dart';
import 'package:brand_bridge/common_wigdets/user_role.dart';
import 'package:brand_bridge/provider/marketplace_provider.dart';
import 'package:brand_bridge/route/app_pages.dart';

class GigDetailsScreen extends StatelessWidget {
  const GigDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final GigModel gig = ModalRoute.of(context)!.settings.arguments as GigModel;

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
          "Sponsorship Post Details",
          style: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.bold, fontSize: 16, color: AppColors.allPrimaryColor),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(color: Colors.grey[200], height: 1),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Banner header
              Stack(
                children: [
                  Container(
                    height: 180.h,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      image: DecorationImage(image: NetworkImage(gig.bannerImage), fit: BoxFit.cover),
                    ),
                  ),
                  Container(
                    height: 180.h,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Colors.black.withOpacity(0.7), Colors.transparent],
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 16,
                    left: 20,
                    right: 20,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            gig.category,
                            style: const TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              color: AppColors.allPrimaryColor,
                            ),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.green,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            "Total Reach: ${gig.totalReach > 0 ? gig.totalReach.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},') : gig.verifiedFollowers.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')} followers",
                            style: const TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title
                    Text(
                      gig.title,
                      style: const TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppColors.allPrimaryColor,
                        height: 1.4,
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Creator row info
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.grey[50],
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Colors.grey[200]!),
                      ),
                      child: Row(
                        children: [
                          CircleAvatar(
                            radius: 20,
                            backgroundImage: NetworkImage(gig.creatorAvatar),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  gig.creatorName,
                                  style: const TextStyle(fontFamily: 'Poppins', fontSize: 13, fontWeight: FontWeight.bold, color: AppColors.allPrimaryColor),
                                ),
                                const Text(
                                  "Sponsor Creator Profile Verified",
                                  style: TextStyle(fontFamily: 'Poppins', fontSize: 11, color: Colors.black54),
                                ),
                              ],
                            ),
                          ),
                          const Icon(Icons.verified, color: Colors.green, size: 20),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Social Accounts Grid
                    const Text(
                      "Linked Verified Channels",
                      style: TextStyle(fontFamily: 'Poppins', fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.allPrimaryColor),
                    ),
                    const SizedBox(height: 10),
                    _buildLinkedChannelsGrid(gig),
                    const SizedBox(height: 24),

                    // Post Details
                    const Text(
                      "Sponsorship Scope & Details",
                      style: TextStyle(fontFamily: 'Poppins', fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.allPrimaryColor),
                    ),
                    const SizedBox(height: 10),

                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.grey[200]!),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildDetailRow(Icons.location_on_outlined, "Target Region", gig.region),
                          const Divider(height: 20),
                          _buildDetailRow(Icons.check_circle_outline, "Deliverables Scope", gig.deliverables),
                          const Divider(height: 20),
                          _buildDetailRow(Icons.loop, "Revision Count", gig.revisions),
                          const Divider(height: 20),
                          _buildDetailRow(Icons.timer_outlined, "Delivery Timeline", gig.deliveryTime),
                          const Divider(height: 20),
                          _buildDetailRow(Icons.attach_money, "Sponsorship Budget", "\$${gig.price.toStringAsFixed(0)}"),
                        ],
                      ),
                    ),
                    if (gig.videoUrl.isNotEmpty) ...[
                      const SizedBox(height: 20),
                      const Text(
                        "Sponsorship Video Pitch",
                        style: TextStyle(fontFamily: 'Poppins', fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.allPrimaryColor),
                      ),
                      const SizedBox(height: 10),
                      MockVideoPlayerWidget(videoUrl: gig.videoUrl, title: gig.title),
                    ],
                    const SizedBox(height: 20),

                    // Description text
                    const Text(
                      "Additional Terms",
                      style: TextStyle(fontFamily: 'Poppins', fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.allPrimaryColor),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      gig.description,
                      style: const TextStyle(fontFamily: 'Poppins', fontSize: 13, color: Colors.black54, height: 1.5),
                    ),
                    const SizedBox(height: 28),

                    // Messenger integration button
                    CommonButton(
                      text: "Chat with Creator",
                      assetIconPath: null,
                      icon: const Icon(Icons.chat_bubble_rounded, color: Colors.white, size: 20),
                      onPressed: () {
                        Get.toNamed(Routes.CHAT, arguments: {
                          "chatId": "gig_${gig.id}",
                          "campaignTitle": gig.title,
                          "partnerName": gig.creatorName,
                          "partnerRole": UserRole.creator,
                        });
                      },
                      backgroundColor: AppColors.appThemeColor,
                    ),
                    const SizedBox(height: 12),

                    // Order / Escrow button
                    CommonButton(
                      text: "Order Sponsorship Package",
                      assetIconPath: null,
                      icon: const Icon(Icons.shopping_bag_rounded, color: Colors.white, size: 20),
                      onPressed: () {
                        Get.toNamed(Routes.PAYMENT, arguments: {
                          "chatId": "gig_${gig.id}",
                          "messageId": "contract_${gig.id}",
                          "amount": gig.price,
                          "title": gig.title,
                        });
                      },
                      backgroundColor: AppColors.allPrimaryColor,
                    ),
                    const SizedBox(height: 36),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLinkedChannelsGrid(GigModel gig) {
    List<Widget> items = [];

    // Parse the new counts or baseline followers if new links are empty
    final isNewModel = gig.youtubeLink.isNotEmpty || gig.tiktokLink.isNotEmpty || gig.facebookLink.isNotEmpty || gig.instagramLink.isNotEmpty;

    if (isNewModel) {
      if (gig.youtubeLink.isNotEmpty) {
        items.add(_buildSocialTile(Icons.play_circle_fill, Colors.red, "YouTube", gig.youtubeFollowers));
      }
      if (gig.tiktokLink.isNotEmpty) {
        items.add(_buildSocialTile(Icons.music_note, Colors.black, "TikTok", gig.tiktokFollowers));
      }
      if (gig.facebookLink.isNotEmpty) {
        items.add(_buildSocialTile(Icons.facebook, Colors.blue[800]!, "Facebook", gig.facebookFollowers));
      }
      if (gig.instagramLink.isNotEmpty) {
        items.add(_buildSocialTile(Icons.camera_alt, Colors.purple, "Instagram", gig.instagramFollowers));
      }
    } else {
      // Fallback for mock baseline gigs
      final pColor = gig.platform == "YouTube"
          ? Colors.red
          : (gig.platform == "Instagram" ? Colors.purple : AppColors.allPrimaryColor);
      final pIcon = gig.platform == "YouTube"
          ? Icons.play_circle_fill
          : (gig.platform == "Instagram" ? Icons.camera_alt : Icons.link);
      items.add(_buildSocialTile(pIcon, pColor, gig.platform, gig.verifiedFollowers));
    }

    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      crossAxisSpacing: 10,
      mainAxisSpacing: 10,
      childAspectRatio: 2.2,
      children: items,
    );
  }

  Widget _buildSocialTile(IconData icon, Color color, String platform, int followers) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Row(
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  platform,
                  style: const TextStyle(fontFamily: 'Poppins', fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.allPrimaryColor),
                ),
                Text(
                  "${followers.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')} followers",
                  style: const TextStyle(fontFamily: 'Poppins', fontSize: 10, color: Colors.green, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(IconData icon, String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: AppColors.appThemeColor, size: 20),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(fontFamily: 'Poppins', fontSize: 11, color: Colors.black54),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: const TextStyle(fontFamily: 'Poppins', fontSize: 13, fontWeight: FontWeight.bold, color: AppColors.allPrimaryColor),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class MockVideoPlayerWidget extends StatefulWidget {
  final String videoUrl;
  final String title;

  const MockVideoPlayerWidget({
    super.key,
    required this.videoUrl,
    required this.title,
  });

  @override
  State<MockVideoPlayerWidget> createState() => _MockVideoPlayerWidgetState();
}

class _MockVideoPlayerWidgetState extends State<MockVideoPlayerWidget> {
  bool _isPlaying = false;
  bool _isMuted = false;
  bool _isBuffering = false;
  double _progress = 0.0;
  final int _duration = 90; // mock duration in seconds (1:30)
  int _position = 0;
  Timer? _timer;
  
  // Custom height offset list for animating soundwave bars
  final List<double> _waveHeights = [12, 24, 8, 32, 16, 28, 14, 20, 6, 22];

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _togglePlay() {
    if (_isPlaying) {
      _pause();
    } else {
      _play();
    }
  }

  void _play() {
    setState(() {
      _isBuffering = true;
    });

    // Simulate buffer lag for 800ms
    Future.delayed(const Duration(milliseconds: 800), () {
      if (!mounted) return;
      setState(() {
        _isBuffering = false;
        _isPlaying = true;
      });

      _timer?.cancel();
      _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
        if (!mounted) return;
        setState(() {
          if (_position >= _duration) {
            _pause();
            _position = 0;
            _progress = 0.0;
          } else {
            _position++;
            _progress = _position / _duration;
          }
        });
      });
    });
  }

  void _pause() {
    _timer?.cancel();
    setState(() {
      _isPlaying = false;
    });
  }

  void _seek(double val) {
    setState(() {
      _progress = val;
      _position = (val * _duration).round();
    });
  }

  String _formatDuration(int seconds) {
    final int minutes = seconds ~/ 60;
    final int remainingSeconds = seconds % 60;
    return "$minutes:${remainingSeconds.toString().padLeft(2, '0')}";
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          )
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          // Simulated Video Content Window
          AspectRatio(
            aspectRatio: 16 / 9,
            child: Stack(
              children: [
                // Visual Background (Category-themed mockup)
                Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Color(0xFF0F2027), Color(0xFF203A43), Color(0xFF2C5364)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                  child: Center(
                    child: Opacity(
                      opacity: 0.08,
                      child: Icon(
                        Icons.movie_creation_outlined,
                        size: 100.sp,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),

                // Pitch Overlay Info
                Positioned(
                  top: 12,
                  left: 12,
                  right: 12,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.black.withValues(alpha: 0.6),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(Icons.verified, color: Colors.green, size: 12),
                              const SizedBox(width: 4),
                              Flexible(
                                child: Text(
                                  widget.videoUrl.split('/').last.split('?').first,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(fontFamily: 'Poppins', color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      IconButton(
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                        icon: const Icon(Icons.fullscreen_rounded, color: Colors.white70, size: 20),
                        onPressed: () => _openFullscreenEmulator(context),
                      ),
                    ],
                  ),
                ),

                // Play / Pause / Buffer states
                Center(
                  child: _isBuffering
                      ? Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.black.withValues(alpha: 0.5),
                            shape: BoxShape.circle,
                          ),
                          child: const CircularProgressIndicator(color: Colors.white),
                        )
                      : GestureDetector(
                          onTap: _togglePlay,
                          child: Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.black.withValues(alpha: 0.5),
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.white30, width: 2),
                            ),
                            child: Icon(
                              _isPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded,
                              color: Colors.white,
                              size: 36,
                            ),
                          ),
                        ),
                ),

                // Bottom Overlay Bar (Soundwaves & Controls)
                Positioned(
                  bottom: 8,
                  left: 12,
                  right: 12,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Simulated animated sound waves if playing
                      Row(
                        children: List.generate(_waveHeights.length, (idx) {
                          final h = _waveHeights[idx];
                          return AnimatedContainer(
                            duration: const Duration(milliseconds: 300),
                            margin: const EdgeInsets.only(right: 2),
                            width: 3,
                            height: _isPlaying ? (idx % 2 == 0 ? h * 0.8 : h * 1.2) : 4,
                            decoration: BoxDecoration(
                              color: _isPlaying ? AppColors.appThemeColor : Colors.white24,
                              borderRadius: BorderRadius.circular(2),
                            ),
                          );
                        }),
                      ),

                      // Time Elapsed info
                      Text(
                        "${_formatDuration(_position)} / ${_formatDuration(_duration)}",
                        style: const TextStyle(fontFamily: 'Poppins', color: Colors.white70, fontSize: 10, fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Player Control Panel
          Container(
            color: const Color(0xFF1E1E24),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: Row(
              children: [
                // Quick Play Button
                IconButton(
                  icon: Icon(
                    _isPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded,
                    color: Colors.white,
                    size: 24,
                  ),
                  onPressed: _togglePlay,
                ),

                // Timeline slider
                Expanded(
                  child: SliderTheme(
                    data: SliderThemeData(
                      trackHeight: 3,
                      activeTrackColor: AppColors.appThemeColor,
                      inactiveTrackColor: Colors.white24,
                      thumbColor: AppColors.appThemeColor,
                      thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 6),
                      overlayColor: AppColors.appThemeColor.withValues(alpha: 0.2),
                      overlayShape: const RoundSliderOverlayShape(overlayRadius: 14),
                    ),
                    child: Slider(
                      value: _progress,
                      min: 0.0,
                      max: 1.0,
                      onChanged: _seek,
                    ),
                  ),
                ),

                // Volume Controller
                IconButton(
                  icon: Icon(
                    _isMuted ? Icons.volume_off_rounded : Icons.volume_up_rounded,
                    color: Colors.white70,
                    size: 20,
                  ),
                  onPressed: () {
                    setState(() {
                      _isMuted = !_isMuted;
                    });
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Opens a custom Landscape full-screen video player dialog emulator
  void _openFullscreenEmulator(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (context, setDlgState) {
            return Dialog(
              backgroundColor: Colors.transparent,
              insetPadding: const EdgeInsets.all(10),
              child: OrientationBuilder(
                builder: (context, orientation) {
                  return Container(
                    width: double.infinity,
                    height: 280,
                    decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    clipBehavior: Clip.antiAlias,
                    child: Stack(
                      children: [
                        // Background
                        Container(
                          decoration: const BoxDecoration(
                            gradient: LinearGradient(
                              colors: [Color(0xFF0F2027), Color(0xFF2C5364)],
                            ),
                          ),
                          child: Center(
                            child: Opacity(
                              opacity: 0.05,
                              child: Icon(Icons.movie_filter_rounded, size: 200, color: Colors.white),
                            ),
                          ),
                        ),

                        // Title
                        Positioned(
                          top: 16,
                          left: 16,
                          child: Text(
                            "Fullscreen: ${widget.title}",
                            style: const TextStyle(fontFamily: 'Poppins', color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold),
                          ),
                        ),

                        // Close button
                        Positioned(
                          top: 12,
                          right: 12,
                          child: IconButton(
                            icon: const Icon(Icons.close_rounded, color: Colors.white, size: 24),
                            onPressed: () => Navigator.pop(ctx),
                          ),
                        ),

                        // Buffer/Play state
                        Center(
                          child: Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.black.withValues(alpha: 0.6),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(Icons.play_arrow_rounded, color: Colors.white, size: 44),
                          ),
                        ),

                        // Fullscreen indicator tag
                        Positioned(
                          bottom: 16,
                          left: 16,
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: AppColors.appThemeColor,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: const Text(
                              "LANDSCAPE SIMULATION MODE",
                              style: TextStyle(fontFamily: 'Poppins', fontSize: 10, color: Colors.white, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            );
          },
        );
      },
    );
  }
}
