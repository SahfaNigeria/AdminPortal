import 'dart:io';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:jambomama_nigeria_admin_portal/core/helpers/dependencies.dart'
    as dep;
import 'package:jambomama_nigeria_admin_portal/core/services/notification/firebase_notification_service.dart';
import 'package:jambomama_nigeria_admin_portal/firebase_options.dart';
import 'package:material_ui/material_ui.dart';
import 'package:flutter_web_plugins/flutter_web_plugins.dart' as wp;
import 'package:google_fonts/google_fonts.dart';
import 'package:jambomama_nigeria_admin_portal/core/routes/route_helper.dart';
import 'package:jambomama_nigeria_admin_portal/shared/constants/app_constants.dart';

import 'core/theme/colors.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  wp.setUrlStrategy(wp.PathUrlStrategy());
  await dep.init();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await FirebaseNotificationService.initialize();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    return MaterialApp.router(
      title: AppConstants.appName,
      themeAnimationCurve: Curves.linear,
      routerConfig: RouteHelpers.goRouter,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: false,
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.primary,
          primary: AppColors.primary,
          secondary: AppColors.primary,
          surface: AppColors.surface,
        ),
        visualDensity: VisualDensity.adaptivePlatformDensity,
        textTheme: GoogleFonts.poppinsTextTheme(textTheme),
      ),
    );
  }
}
