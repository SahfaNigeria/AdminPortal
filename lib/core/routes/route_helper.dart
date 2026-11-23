import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:go_transitions/go_transitions.dart';
import 'package:jambomama_nigeria_admin_portal/core/component/admin/admin_shell.dart';
import 'package:jambomama_nigeria_admin_portal/modules/authentication/login/login_view.dart';
import 'package:jambomama_nigeria_admin_portal/modules/authentication/registration/registration_view.dart';
import 'package:material_ui/material_ui.dart';

import '../../modules/analytics/admin_analytics_page.dart';
import '../../modules/emergency/emergency_assesment_page.dart';
import '../../modules/hospitals/add/admin_add_hospital_page.dart';
import '../../modules/hospitals/hospitals_page.dart';
import '../../modules/users/users_page.dart';

class RouteHelpers {
  static const String adminLogin = "adminLogin";
  static const String adminRegistration = "adminRegistration";
  static const String adminAnalytics = "adminAnalytics";
  static const String adminUsers = "adminUsers";
  static const String adminEmergencies = "adminEmergencies";
  static const String adminHospitals = "adminHospitals";
  static const String adminAddHospitals = "adminAddHospitals";

  static final GoRouter goRouter = GoRouter(
    navigatorKey: Get.key,
    // errorBuilder: (context, state) => ErrorPage(),
    initialLocation: "/admin/login",
    routes: [
      GoRoute(
        name: adminLogin,
        path: "/admin/login",
        builder: (context, state) => LoginPage(),
        pageBuilder: GoTransitions.openUpwards.call,
        // routes: [
        //   GoRoute(
        //     name: signUpEmail,
        //     path: "email",
        //     builder: (context, state) => SignUpEmail(),
        //     pageBuilder: GoTransitions.fade,
        //   ),
        // ],
      ),
      GoRoute(
        name: adminRegistration,
        path: "/admin/registration",
        builder: (context, state) => RegistrationPage(),
        pageBuilder: GoTransitions.openUpwards.call,
        // routes: [
        //   GoRoute(
        //     name: signUpEmail,
        //     path: "email",
        //     builder: (context, state) => SignUpEmail(),
        //     pageBuilder: GoTransitions.fade,
        //   ),
        // ],
      ),
      GoRoute(
        name: adminAddHospitals,
        path: "/admin/add-hospital",
        builder: (context, state) => AdminAddHospitalPage(),
        pageBuilder: GoTransitions.openUpwards.call,
        // routes: [
        //   GoRoute(
        //     name: signUpEmail,
        //     path: "email",
        //     builder: (context, state) => SignUpEmail(),
        //     pageBuilder: GoTransitions.fade,
        //   ),
        // ],
      ),
      // GoRoute(
      //   name: merchantCreateCampaignPage,
      //   path: "/merchant/create-campaign/:campaignId",
      //   builder: (context, state) {
      //     final campaignId = state.pathParameters['campaignId']!;
      //     final isEdit = state.uri.queryParameters['isEdit'];
      //     return MerchantCreateCampaignPage(
      //       campaignId: campaignId,
      //       isEdit: bool.tryParse(isEdit ?? "") ?? false,
      //     );
      //   },
      // ),

      // GoRoute(
      //   path: '/landing/activate-nfc',
      //   name: 'activateNfcBlocked',
      //   redirect: (context, state) => '/404',
      // ),

      StatefulShellRoute.indexedStack(
        branches: [
          // StatefulShellBranch(
          //   routes: [
          //     GoRoute(
          //       path: '/merchant-home-page',
          //       name: merchantHomePage,
          //       builder: (context, state) {
          //         return ();
          //       },
          //     ),
          //   ],
          // ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/admin/analytics',
                name: adminAnalytics,
                builder: (context, state) {
                  return AdminAnalyticsPage();
                },
              ),
            ],
          ), StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/admin/users',
                name: adminUsers,
                builder: (context, state) {
                  return UsersPage();
                },
              ),
            ],
          ),StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/admin/emergencies',
                name: adminEmergencies,
                builder: (context, state) {
                  return EmergencyAssessmentPage();
                },
              ),
            ],
          ), StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/admin/hospitals',
                name: adminHospitals,
                builder: (context, state) {
                  return HospitalsPage();
                },
              ),
            ],
          ),
          // StatefulShellBranch(
          //   routes: [
          //     GoRoute(
          //       path: '/merchant/tags',
          //       name: tagsPage,
          //       builder: (context, state) {
          //         return MerchantTagsPage();
          //       },
          //     ),
          //   ],
          // ),
          // StatefulShellBranch(
          //   routes: [
          //     GoRoute(
          //       path: '/merchant/campaign',
          //       name: merchantCampaignPage,
          //       builder: (context, state) {
          //         return MerchantCampaignsPage();
          //       },
          //     ),
          //   ],
          // ),
        ],
        builder: (context, state, navigationShell) {
          return AdminShell(shell: SelectionArea(child: navigationShell));
        },
      ),
      // GoRoute(
      //   name: verification,
      //   path: "/verification",
      //   // builder: (context, state) => Dashboard(),
      //   pageBuilder: GoTransitions.fade,
      // ),
      // GoRoute(
      //   name: forgottenPassword,
      //   path: "/forgotten-password",
      //   // builder: (context, state) => Dashboard(),
      //   pageBuilder: GoTransitions.fade,
      // ),
    ],

    // redirect: (context, state) {
    //   final loggedIn = BasicComponents.isLoggedIn;
    //   final location = state.matchedLocation;

    //   final publicRoutes = [
    //     '/merchant/login',
    //     '/user/activate-nfc',
    //     '/landing/activate-nfc',
    //     '/scan-required',
    //   ];

    //   final isPublic = publicRoutes.any((route) => location.startsWith(route));

    //   if (!loggedIn && !isPublic) {
    //     return '/merchant/login';
    //   }

    //   if (loggedIn && location == '/merchant/login') {
    //     return '/merchant/analytics';
    //   }

    //   return null;
    // },
  );
}
