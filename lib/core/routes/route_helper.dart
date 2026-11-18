import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:go_transitions/go_transitions.dart';
import 'package:jambomama_nigeria_admin_portal/modules/authentication/login/view/login_screen.dart';

class RouteHelpers {
  static const String adminLogin = "adminLogin";
  static const String adminRegistration = "adminRegistration";

  static final GoRouter goRouter = GoRouter(
    navigatorKey: Get.key,
    // errorBuilder: (context, state) => ErrorPage(),
    initialLocation: "/admin/login",
    routes: [
      GoRoute(
        name: adminLogin,
        path: "/admin/login",
        builder: (context, state) => LoginScreen(),
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

      // StatefulShellRoute.indexedStack(
      //   branches: [
      //     // StatefulShellBranch(
      //     //   routes: [
      //     //     GoRoute(
      //     //       path: '/merchant-home-page',
      //     //       name: merchantHomePage,
      //     //       builder: (context, state) {
      //     //         return ();
      //     //       },
      //     //     ),
      //     //   ],
      //     // ),
      //     StatefulShellBranch(
      //       routes: [
      //         GoRoute(
      //           path: '/merchant/analytics',
      //           name: merchantAnalyticsPage,
      //           builder: (context, state) {
      //             return MerchantAnalyticsPage();
      //           },
      //         ),
      //       ],
      //     ),
      //     StatefulShellBranch(
      //       routes: [
      //         GoRoute(
      //           path: '/merchant/tags',
      //           name: tagsPage,
      //           builder: (context, state) {
      //             return MerchantTagsPage();
      //           },
      //         ),
      //       ],
      //     ),
      //     StatefulShellBranch(
      //       routes: [
      //         GoRoute(
      //           path: '/merchant/campaign',
      //           name: merchantCampaignPage,
      //           builder: (context, state) {
      //             return MerchantCampaignsPage();
      //           },
      //         ),
      //       ],
      //     ),
      //   ],
      //   builder: (context, state, navigationShell) {
      //     return MerchantHomePage(shell: navigationShell);
      //   },
      // ),
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
