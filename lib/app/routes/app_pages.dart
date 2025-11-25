import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';
import 'package:moo_logue/app/core/storage/get_storage.dart';
import 'package:moo_logue/app/model/category/response/get_audio_response_model.dart';
import 'package:moo_logue/app/modules/authentication/views/create_account_view.dart';
import 'package:moo_logue/app/modules/home/views/about_us_view.dart';
import 'package:moo_logue/app/modules/home/views/bottom_bar_view.dart';
import 'package:moo_logue/app/modules/authentication/views/display_view.dart';
import 'package:moo_logue/app/modules/authentication/views/forgot_password_view.dart';
import 'package:moo_logue/app/modules/authentication/views/login_view.dart';
import 'package:moo_logue/app/modules/authentication/views/reset_password_view.dart';
import 'package:moo_logue/app/modules/authentication/views/reset_verification_view.dart';
import 'package:moo_logue/app/modules/authentication/views/settings_view.dart';
import 'package:moo_logue/app/modules/home/views/edit_fontsize_view.dart';
import 'package:moo_logue/app/modules/home/views/emotional_calls_view.dart';
import 'package:moo_logue/app/modules/home/views/fence_Interaction_call_view.dart';
import 'package:moo_logue/app/modules/home/views/fence_interaction_details_view.dart';
import 'package:moo_logue/app/modules/home/views/help_center_view.dart';
import 'package:moo_logue/app/modules/home/views/home_view.dart';
import 'package:moo_logue/app/modules/home/views/leader_board_view.dart';
import 'package:moo_logue/app/modules/home/views/learn_listening_view.dart';
import 'package:moo_logue/app/modules/home/views/quiz_view.dart';
import 'package:moo_logue/app/modules/home/views/search_screen_view.dart';
import 'package:moo_logue/app/modules/home/views/subcategory_list_view.dart';
import 'package:moo_logue/app/modules/home/views/update_profile_view.dart';
import 'package:moo_logue/app/modules/onbording/views/onbording_two_view.dart';
import 'package:moo_logue/app/modules/onbording/views/onbording_view.dart';
import 'package:moo_logue/app/routes/app_routes.dart';

class AppPages {
  static const initial = Routes.onboarding;

  static final routes = GoRouter(
    initialLocation: AppStorage.isLoggedIn() ? Routes.homeView : Routes.onboarding,

    routes: [
      GoRoute(path: Routes.onboarding, pageBuilder: (context, state) => fadePage(OnBordingView(), state)),
      GoRoute(path: Routes.createAccountView, pageBuilder: (context, state) => fadePage(CreateAccountView(), state)),
      GoRoute(path: Routes.updateAccountView, pageBuilder: (context, state) => fadePage(UpdateAccountView(), state)),
      GoRoute(path: Routes.onbordingTwoView, pageBuilder: (context, state) => fadePage(OnbordingTwoView(), state)),
      ShellRoute(
        routes: [
          GoRoute(
            path: Routes.aboutUsView,
            pageBuilder: (context, state) => fadePage(AboutUsView(), state),
            // redirect: (context, state) {
            //   Get.find<BottomBarController>().onItemTapped(3);
            //   return null;
            // },
          ),
          GoRoute(
            path: Routes.homeView,
            pageBuilder: (context, state) => fadePage(HomeView(), state),
            // redirect: (context, state) {
            //   Get.find<BottomBarController>().onItemTapped(0);
            //   return null;
            // },
          ),
          GoRoute(
            path: Routes.learnListeningView,
            pageBuilder: (context, state) => fadePage(LearnListeningView(), state),
            // redirect: (context, state) {
            //   Get.find<BottomBarController>().onItemTapped(1);
            //   return null;
            // },
          ),
          GoRoute(
            path: Routes.emotionalCallsView,
            pageBuilder: (context, state) {
              final args = state.extra as Map<String, dynamic>;
              return fadePage(EmotionalCallsView(id: args['id'], name: args['name']), state);
            },
          ),
          GoRoute(
            path: Routes.fenceInteractionCallView,
            pageBuilder: (context, state) {
              final args = state.extra as AudioDataResponseModel;
              return fadePage(FenceInteractionCallView(audioData: args), state);
            },
          ),
          GoRoute(
            path: Routes.searchScreenView,
            pageBuilder: (context, state) {
              return fadePage(SearchScreenView(), state);
            },
          ),
          GoRoute(
            path: Routes.fenceInteractionDetailsView,
            pageBuilder: (context, state) {
              final args = state.extra as AudioDataResponseModel;
              return fadePage(FenceInteractionDetailsView(audioData: args), state);
            },
          ),
          GoRoute(
            path: Routes.subcategoryListView,
            pageBuilder: (context, state) {
              final args = state.extra as Map<String, dynamic>;
              return fadePage(SubcategoryListView(id: args['id'], name: args['name'], desc: args['desc'] ?? ""), state);
            },
          ),
          GoRoute(
            path: Routes.learnBoardView,
            pageBuilder: (context, state) => fadePage(LearnBoardView(), state),
            // redirect: (context, state) {
            //   Get.find<BottomBarController>().onItemTapped(2);
            //   return null;
            // },
          ),
        ],
        pageBuilder: (context, state, child) {
          return fadePage(BottomBarView(child: child), state);
        },
      ),
      GoRoute(
        path: Routes.quizView,
        pageBuilder: (context, state) {
          // No args needed for global session
          return fadePage(const QuizView(), state);
        },
      ),
      GoRoute(path: Routes.editFontSizeView, pageBuilder: (context, state) => fadePage(EditFontSizeView(), state)),
      GoRoute(path: Routes.loginView, pageBuilder: (context, state) => fadePage(LoginView(), state)),
      GoRoute(path: Routes.forgotPasswordView, pageBuilder: (context, state) => fadePage(ForgotPasswordView(), state)),
      GoRoute(
        path: Routes.resetVerificationView,
        pageBuilder: (context, state) {
          final args = state.extra as Map<String, dynamic>;
          return fadePage(ResetVerificationView(email: args['email'], isCreate: args['isCreate']), state);
        },
      ),
      GoRoute(
        path: Routes.resetPasswordView,
        pageBuilder: (context, state) {
          final args = state.extra as Map<String, dynamic>;
          return fadePage(ResetPasswordView(email: args['email'], isCreate: args['isCreate']), state);
        },
      ),
      GoRoute(path: Routes.settingsView, pageBuilder: (context, state) => fadePage(SettingsView(), state)),
      GoRoute(path: Routes.displayView, pageBuilder: (context, state) => fadePage(DisplayView(), state)),
      GoRoute(path: Routes.helpCenterView, pageBuilder: (context, state) => fadePage(HelpCenterView(), state)),
    ],
  );

  static Page<void> fadePage(Widget child, GoRouterState state) {
    return CustomTransitionPage(
      key: state.pageKey,
      child: child,
      transitionsBuilder: (context, animation, secondaryAnimation, child) => FadeTransition(opacity: animation, child: child),
      transitionDuration: const Duration(milliseconds: 300),
    );
  }
}
