import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:go_transitions/go_transitions.dart';
import 'package:jambomama_nigeria_admin_portal/core/component/admin/admin_shell.dart';
import 'package:jambomama_nigeria_admin_portal/core/helpers/admin_access_controller.dart';
import 'package:jambomama_nigeria_admin_portal/modules/authentication/login/login_view.dart';
import 'package:jambomama_nigeria_admin_portal/modules/authentication/pending_approval_page.dart';
import 'package:jambomama_nigeria_admin_portal/modules/authentication/registration/registration_view.dart';
import 'package:jambomama_nigeria_admin_portal/shared/utils/app_helpers.dart';
import 'package:material_ui/material_ui.dart';

import '../../modules/analytics/admin_analytics_page.dart';
import '../../modules/emergency/emergency_assesment_page.dart';
import '../../modules/hospitals/add/admin_add_hospital_page.dart';
import '../../modules/hospitals/hospitals_page.dart';
import '../../modules/profile/admin_profile_page.dart';
import '../../modules/users/users_page.dart';

class RouteHelpers {
  static const String adminLogin = "adminLogin";
  static const String adminRegistration = "adminRegistration";
  static const String adminPendingApproval = "adminPendingApproval";
  static const String adminAnalytics = "adminAnalytics";
  static const String adminUsers = "adminUsers";
  static const String adminProfile = "adminProfile";
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
        name: adminPendingApproval,
        path: "/admin/pending-approval",
        builder: (context, state) => const PendingApprovalPage(),
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

      GoRoute(
        name: adminProfile,
        path: "/admin/profile",
        builder: (context, state) => AdminProfilePage(),
        pageBuilder: GoTransitions.openUpwards.call,
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
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/admin/users',
                name: adminUsers,
                builder: (context, state) {
                  return UsersPage();
                },
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/admin/emergencies',
                name: adminEmergencies,
                builder: (context, state) {
                  return EmergencyAssessmentPage();
                },
              ),
            ],
          ),
          StatefulShellBranch(
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

    redirect: (context, state) async {
      final loggedIn = await AppHelpers.isLoggedIn;
      final location = state.matchedLocation;

      const publicRoutes = [
        '/admin/login',
        '/admin/registration',
      ];

      final isPublicRoute = publicRoutes.contains(location);

      if (!loggedIn && !isPublicRoute) {
        return '/admin/login';
      }

      if (loggedIn && isPublicRoute) {
        final accessController = Get.find<AdminAccessController>();
        final admin = await accessController.refreshCurrentAdmin();
        if (admin == null) return '/admin/login';
        return admin.isApproved
            ? accessController.firstAccessibleLocation
            : '/admin/pending-approval';
      }

      if (loggedIn) {
        final accessController = Get.find<AdminAccessController>();
        final admin = await accessController.refreshCurrentAdmin();
        if (admin == null) return '/admin/login';
        if (!admin.isApproved) {
          return location == '/admin/pending-approval'
              ? null
              : '/admin/pending-approval';
        }
        if (location == '/admin/pending-approval') {
          return accessController.firstAccessibleLocation;
        }

        final requiredTab = accessController.tabForLocation(location);
        if (requiredTab != null && !admin.hasTabAccess(requiredTab)) {
          return accessController.firstAccessibleLocation;
        }
      }

      return null;
    },
  );
}
