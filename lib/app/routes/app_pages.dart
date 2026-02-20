import 'package:get/get.dart';
import 'app_routes.dart';
import '../../modules/setup/controllers/setup_controller.dart';
import '../../modules/setup/views/setup_view.dart';
import '../../modules/setup/views/home_view.dart';
import '../../modules/role_reveal/controllers/role_reveal_controller.dart';
import '../../modules/role_reveal/views/role_reveal_view.dart';
import '../../modules/game_round/controllers/game_round_controller.dart';
import '../../modules/game_round/views/game_round_view.dart';
import '../../modules/voting/controllers/voting_controller.dart';
import '../../modules/voting/views/voting_view.dart';
import '../../modules/voting/views/elimination_view.dart';
import '../../modules/result/controllers/result_controller.dart';
import '../../modules/result/views/result_view.dart';
import '../../modules/setup/controllers/home_controller.dart';

class AppPages {
  static final pages = [
    GetPage(
      name: Routes.home,
      page: () => const HomeView(),
      binding: BindingsBuilder(() {
        Get.lazyPut(() => HomeController());
      }),
    ),
    GetPage(
      name: Routes.setup,
      page: () => const SetupView(),
      binding: BindingsBuilder(() {
        Get.lazyPut(() => SetupController());
      }),
    ),
    GetPage(
      name: Routes.roleReveal,
      page: () => const RoleRevealView(),
      binding: BindingsBuilder(() {
        Get.lazyPut(() => RoleRevealController());
      }),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: Routes.gameRound,
      page: () => const GameRoundView(),
      binding: BindingsBuilder(() {
        Get.lazyPut(() => GameRoundController());
      }),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: Routes.voting,
      page: () => const VotingView(),
      binding: BindingsBuilder(() {
        Get.lazyPut(() => VotingController());
      }),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: Routes.elimination,
      page: () => const EliminationView(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: Routes.result,
      page: () => const ResultView(),
      binding: BindingsBuilder(() {
        Get.lazyPut(() => ResultController());
      }),
      transition: Transition.fadeIn,
    ),
  ];
}