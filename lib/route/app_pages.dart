import 'package:get/get.dart';
import 'package:brand_bridge/common_wigdets/custom_navigation.dart';
import 'package:brand_bridge/common_wigdets/user_role.dart';
import 'package:brand_bridge/features/splash/splash_screen.dart';
import 'package:brand_bridge/features/onboarding/onboarding_screen.dart';
import 'package:brand_bridge/features/auth/login_screen.dart';
import 'package:brand_bridge/features/auth/register_screen.dart';
import 'package:brand_bridge/features/auth/role_selection_screen.dart';
import 'package:brand_bridge/features/kyc/kyc_screen.dart';
import 'package:brand_bridge/features/creator_search/search_creator_screen.dart';
import 'package:brand_bridge/features/creator_profile/creator_profile_screen.dart';
import 'package:brand_bridge/features/ai_recommendation/ai_recommendation_screen.dart';
import 'package:brand_bridge/features/campaign/campaign_create_screen.dart';
import 'package:brand_bridge/features/campaign/campaign_list_screen.dart';
import 'package:brand_bridge/features/proposal/proposal_screen.dart';
import 'package:brand_bridge/features/chat/chat_screen.dart';
import 'package:brand_bridge/features/chat/chat_inbox_screen.dart';
import 'package:brand_bridge/features/payment/payment_screen.dart';
import 'package:brand_bridge/features/analytics/analytics_screen.dart';
import 'package:brand_bridge/features/profile/profile_screen.dart';
import 'package:brand_bridge/features/settings/settings_screen.dart';
import 'package:brand_bridge/features/gig/gig_create_screen.dart';
import 'package:brand_bridge/features/gig/gig_details_screen.dart';
import 'package:brand_bridge/features/wallet/wallet_screen.dart';
import 'package:brand_bridge/features/settings/two_step_verification_screen.dart';
import 'package:brand_bridge/features/settings/order_tracking_screen.dart';

part 'app_routes.dart';

class AppPages {
  static const INITIAL = Routes.SPLASH;

  static final routes = [
    GetPage(
      name: Routes.SPLASH,
      page: () => const SplashScreen(),
    ),
    GetPage(
      name: Routes.ONBOARDING,
      page: () => const OnboardingScreen(),
    ),
    GetPage(
      name: Routes.LOGIN,
      page: () => const LoginScreen(),
    ),
    GetPage(
      name: Routes.REGISTER,
      page: () => const RegisterScreen(),
    ),
    GetPage(
      name: Routes.ROLE_SELECTION,
      page: () => const RoleSelectionScreen(),
    ),
    GetPage(
      name: Routes.KYC,
      page: () => const KycScreen(),
    ),
    GetPage(
      name: Routes.CLIENT_HOME,
      page: () => const CustomNavigation(role: UserRole.client),
    ),
    GetPage(
      name: Routes.CREATOR_HOME,
      page: () => const CustomNavigation(role: UserRole.creator),
    ),
    GetPage(
      name: Routes.SEARCH_CREATOR,
      page: () => const SearchCreatorScreen(),
    ),
    GetPage(
      name: Routes.CREATOR_PROFILE,
      page: () => const CreatorProfileScreen(),
    ),
    GetPage(
      name: Routes.AI_RECOMMENDATION,
      page: () => const AiRecommendationScreen(),
    ),
    GetPage(
      name: Routes.CAMPAIGN_CREATE,
      page: () => const CampaignCreateScreen(),
    ),
    GetPage(
      name: Routes.CAMPAIGN_LIST,
      page: () => const CampaignListScreen(),
    ),
    GetPage(
      name: Routes.PROPOSAL,
      page: () => const ProposalScreen(),
    ),
    GetPage(
      name: Routes.CHAT,
      page: () => const ChatScreen(),
    ),
    GetPage(
      name: Routes.CHAT_INBOX,
      page: () => const ChatInboxScreen(),
    ),
    GetPage(
      name: Routes.PAYMENT,
      page: () => const PaymentScreen(),
    ),
    GetPage(
      name: Routes.ANALYTICS,
      page: () => const AnalyticsScreen(),
    ),
    GetPage(
      name: Routes.PROFILE,
      page: () => const ProfileScreen(),
    ),
    GetPage(
      name: Routes.SETTINGS,
      page: () => const SettingsScreen(),
    ),
    GetPage(
      name: Routes.GIG_CREATE,
      page: () => const GigCreateScreen(),
    ),
    GetPage(
      name: Routes.GIG_DETAILS,
      page: () => const GigDetailsScreen(),
    ),
    GetPage(
      name: Routes.WALLET,
      page: () => const WalletScreen(),
    ),
    GetPage(
      name: Routes.TWO_STEP_VERIFICATION,
      page: () => const TwoStepVerificationScreen(),
    ),
    GetPage(
      name: Routes.ORDER_TRACKING,
      page: () => const OrderTrackingScreen(),
    ),
  ];
}
