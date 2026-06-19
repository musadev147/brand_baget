import 'package:brand_bridge/provider/carosul_provider.dart';
import 'package:brand_bridge/provider/forget_password_provider.dart';
import 'package:brand_bridge/provider/profile_provider.dart';
import 'package:brand_bridge/provider/singnup_provider.dart';
import 'package:brand_bridge/provider/marketplace_provider.dart';
import 'package:provider/provider.dart';

var providers = [
  ChangeNotifierProvider<ForgetPasswordProvider>(
    create: ((context) => ForgetPasswordProvider()),
  ),

  ChangeNotifierProvider<SignupProvider>(
    create: ((context) => SignupProvider()),
  ),

  ChangeNotifierProvider<ProfileProvider>(
    create: ((context) => ProfileProvider()),
  ),

  ChangeNotifierProvider<CarosulProvider>(
    create: ((context) => CarosulProvider()),
  ),

  ChangeNotifierProvider<MarketplaceProvider>(
    create: ((context) => MarketplaceProvider()),
  ),
];
