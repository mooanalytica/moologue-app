import 'dart:developer';
import 'package:audio_waveforms/audio_waveforms.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart' as ja;
import 'package:linear_progress_bar/linear_progress_bar.dart';
import 'package:moo_logue/app/core/constants/app_assets.dart';
import 'package:moo_logue/app/core/constants/app_colors.dart';
import 'package:moo_logue/app/core/constants/app_sizes.dart';
import 'package:moo_logue/app/core/constants/app_strings.dart';
import 'package:moo_logue/app/core/extention/sized_box_extention.dart';
import 'package:moo_logue/app/modules/home/controllers/quiz_view_controller.dart';
import 'package:moo_logue/app/utils/common_function.dart';
import 'package:moo_logue/app/widgets/app_snackbar.dart';

class QuizView extends StatefulWidget {
  const QuizView({super.key}); // Remove audioId

  @override
  State<QuizView> createState() => _QuizViewState();
}

class _QuizViewState extends State<QuizView> {
  late final QuizViewController quizViewController;
  @override
  void initState() {
    quizViewController = Get.put(QuizViewController()); // No audioId
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      debugPrint('quizViewController.currentQuestionIndex.value>${quizViewController.currentQuestionIndex.value}');
      quizViewController.quizQuestions?.clear();
      await quizViewController.startQuiz(context).then((value) async {
        final idx = quizViewController.currentQuestionIndex.value;
        await quizViewController.playAudioAtIndex(idx);
        quizViewController.listenAudioStreams();
      });
    });
    super.initState();
  }

  void showAnswerBottomSheet(BuildContext context, bool locked) {
    final isComplete = quizViewController.isQuizComplete();
    final total = quizViewController.answerAttempts.length;
    final correct = quizViewController.answerAttempts.where((a) => a.isCorrect).length;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: quizViewController.isAnswerCorrect.value == true || isComplete == true ? AppColors.primary : Colors.red,

      shape: RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20.r))),
      builder: (_) {
        return Padding(
          padding: EdgeInsets.symmetric(horizontal: AppSize.horizontalPadding, vertical: 20.h),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              RotatingCircleIcon(),
              SizedBox(height: 10.h),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    // locked ? "You've already attempted!":
                    quizViewController.isAnswerCorrect.value == true ? "Correct!" : "Wrong!",
                    style: context.textTheme.titleLarge?.copyWith(
                      fontSize: 16.sp,
                      color: context.isDarkMode ? AppColors.closeIconBgColor : AppColors.whiteColor,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 25.h),

              if (!isComplete) ...[
                GetBuilder<QuizViewController>(
                  builder: (quizViewController) => GestureDetector(
                    onTap: () async {
                      // quizViewController.waveformController?.dispose();

                      Navigator.pop(context);
                      await quizViewController.nextQuestionAndPlay();
                      quizViewController.isZoomedOut.value = false;
                      quizViewController.selectQuiz.value = -1;
                      quizViewController.update();
                    },
                    child: Container(
                      height: 65.h,

                      decoration: BoxDecoration(
                        color: context.isDarkMode ? AppColors.darkBackground : AppColors.whiteColor,
                        borderRadius: BorderRadius.circular(100.r),
                      ),
                      child: Center(
                        child: Text(
                          AppString.nextQuestion,
                          style: context.textTheme.titleLarge?.copyWith(
                            fontSize: 12.sp,
                            color: context.isDarkMode ? AppColors.closeIconBgColor : AppColors.primary,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ] else ...[
                Text(
                  'Your score: $correct / $total',
                  style: context.textTheme.titleLarge?.copyWith(
                    fontSize: 18.sp,
                    color: context.isDarkMode ? AppColors.closeIconBgColor : AppColors.whiteColor,
                  ),
                ),
                16.h.heightBox,
                GestureDetector(
                  onTap: () async {
                    Navigator.pop(context);

                    await quizViewController.clearSessionAndExit(context);
                    await quizViewController.generateGlobalQuizSession();
                  },
                  child: Container(
                    height: 65.h,
                    width: 220.w,
                    decoration: BoxDecoration(
                      color: context.isDarkMode ? AppColors.darkBackground : AppColors.whiteColor,
                      borderRadius: BorderRadius.circular(100.r),
                    ),
                    child: Center(
                      child: Text(
                        'Close',
                        style: context.textTheme.titleLarge?.copyWith(
                          fontSize: 12.sp,
                          color: context.isDarkMode ? AppColors.closeIconBgColor : AppColors.primary,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ],
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    // quizViewController.disposeAudioController();

    quizViewController.audioPlayer.stop();
    quizViewController.audioPlayer.dispose();
    for (var w in quizViewController.waveformControllers) {
      w.dispose();
    }
    if (Get.isRegistered<QuizViewController>()) {
      Get.delete<QuizViewController>();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<QuizViewController>(
      builder: (controller) {
        final totalQuestions = controller.quizQuestions?.length ?? 0;
        return Scaffold(
          body: SafeArea(
            top: true,
            bottom: false,
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: AppSize.horizontalPadding),
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: () async {
                          debugPrint('controller.currentQuestionIndex.value==========>>>>>${controller.currentQuestionIndex.value}');
                          if (controller.currentQuestionIndex.value == 0) {
                            Navigator.pop(context);
                          } else {
                            await controller.previousQuestionAndPlay();
                          }
                        },
                        child: SvgPicture.asset(
                          AppAssets.backArrow_icon,
                          colorFilter: ColorFilter.mode(
                            context.isDarkMode ? AppColors.whiteColor : AppColors.primaryTextColor,
                            BlendMode.srcIn,
                          ),
                        ),
                      ),
                      // 20.w.widthBox,
                      // Obx(
                      //   () => FittedBox(
                      //     fit: BoxFit.scaleDown,
                      //     child: Text(
                      //       // Show current/total question count
                      //       '${controller.currentQuestionIndex.value + 1}/$totalQuestions',
                      //       style: context.textTheme.labelMedium?.copyWith(fontSize: 14.sp),
                      //     ),
                      //   ),
                      // ),
                      // 20.w.widthBox,
                      // Expanded(
                      //   child: Container(
                      //     height: 5.h,
                      //     child: LinearProgressBar(
                      //       maxSteps: totalQuestions > 0 ? totalQuestions : 1,
                      //       progressType: LinearProgressBar.progressTypeLinear,
                      //       currentStep: controller.currentQuestionIndex.value + 1,
                      //       progressColor: AppColors.primary,
                      //       backgroundColor: AppColors.sliderColor.withValues(alpha: 0.5),
                      //     ),
                      //   ),
                      // ),
                      // 20.w.widthBox,
                      Spacer(),
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context).pop();
                          log("============$Navigator");
                        },
                        child: Container(
                          height: 30.h,
                          width: 30.w,
                          decoration: const BoxDecoration(shape: BoxShape.circle, color: AppColors.closeIconBgColor),
                          child: const Icon(Icons.close, color: AppColors.primaryTextColor, size: 12),
                        ),
                      ),
                    ],
                  ),
                ),
                35.h.heightBox,
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Container(
                    height: 80.h,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      // color: AppColors.aboutContainerColor.withValues(alpha: 0.25),
                      color: AppColors.primary.withValues(alpha: 0.25),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: const EdgeInsets.all(8),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child:
                          (controller.waveformControllers.isEmpty ||
                              controller.currentQuestionIndex.value >= controller.waveformControllers.length)
                          ? const SizedBox()
                          : AudioFileWaveforms(
                              key: ValueKey(controller.waveformControllers[controller.currentQuestionIndex.value].hashCode),
                              continuousWaveform: true,
                              animationDuration: const Duration(seconds: 1),
                              playerController: controller.waveformControllers[controller.currentQuestionIndex.value],
                              enableSeekGesture: false,
                              size: const Size(double.infinity, 80),
                              waveformType: WaveformType.long,
                              playerWaveStyle: PlayerWaveStyle(
                                // fixedWaveColor: const Color(0xff367A23).withValues(alpha: context.isDarkMode ? 0.2 : 0.33),
                                fixedWaveColor: const Color(0xFF04b07c).withValues(alpha: context.isDarkMode ? 0.2 : 0.33),
                                liveWaveColor: context.isDarkMode ? const Color(0xff02db99) : const Color(0xff367A23),
                                // liveWaveColor: context.isDarkMode ? const Color(0xffA4D23B) : const Color(0xff367A23),
                                showTop: true,
                                spacing: 3.0,
                                waveThickness: 2.0,
                                waveCap: StrokeCap.round,
                                showSeekLine: false,
                              ),
                            ),
                    ),
                  ),
                ),

                35.h.heightBox,
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    IconButton(
                      onPressed: () {
                        controller.toggleRepeat();
                        controller.update();
                      },
                      icon: SizedBox(
                        height: 16.h,
                        width: 16.w,
                        child: SizedBox(
                          child: SvgPicture.asset(AppAssets.repeatIcon, height: 16.h, width: 16.w,color:  AppColors.primary,),
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: controller.skipBackward,
                      icon: Icon(Icons.fast_rewind, color: AppColors.primary),
                      // icon: Container(
                      //   child: SvgPicture.asset(AppAssets.priviosIcon, height: 16.h, width: 16.w),
                      // ),
                    ),
                    GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: () async {
                        await controller.togglePlayPause();
                      },
                      child: StreamBuilder<ja.PlayerState>(
                        stream: controller.audioPlayer.playerStateStream,
                        builder: (context, snapshot) {
                          final state = snapshot.data;
                          final playing = state?.playing ?? false;
                          final completed = state?.processingState == ja.ProcessingState.completed;

                          // Update controller based on actual state
                          controller.isAudioPlay = state?.playing ?? false;

                          return Container(
                            width: 65.w,
                            height: 65.h,
                            decoration: BoxDecoration(color: AppColors.primary, shape: BoxShape.circle),
                            child: !controller.isReady
                                ? Center(
                                    child: SvgPicture.asset(AppAssets.playIcon, width: 13.w, height: 14.h, fit: BoxFit.fill),
                                  )
                                : Center(
                                    child: (!playing || completed)
                                        ? SvgPicture.asset(AppAssets.playIcon, width: 13.w, height: 14.h, fit: BoxFit.fill)
                                        : SvgPicture.asset(AppAssets.playPushIcon, width: 13.w, height: 14.h, fit: BoxFit.fill),
                                  ),
                          );
                        },
                      ),
                    ),

                    IconButton(
                      onPressed: controller.skipForward,
                      icon: Icon(Icons.fast_forward, color: AppColors.primary),
                      // icon: SvgPicture.asset(AppAssets.nextIcon, height: 16.h, width: 16.w),
                    ),
                    IconButton(
                      onPressed: () {
                        controller.toggleMute();
                        controller.update();
                      },
                      icon: controller.isMuted
                          ? SvgPicture.asset(AppAssets.muteIcon, height: 16.h, width: 16.w)
                          : Icon(Icons.volume_down_alt, color: AppColors.primary),
                    ),
                  ],
                ),
                35.h.heightBox,
                Text(AppString.quizDisc, style: context.textTheme.labelMedium?.copyWith(fontSize: 14.sp)),
                35.h.heightBox,

                controller.quizQuestions == null
                    ? Center(child: Text("No questions available"))
                    : Obx(() {
                        final quizQuestions = controller.quizQuestions;
                        if (quizQuestions == null || quizQuestions.isEmpty) {
                          return const Center(child: Text("No questions available"));
                        }

                        final currentQuestion = quizQuestions[controller.currentQuestionIndex.value];

                        final options =
                            (currentQuestion.mainCategoryOptions.isNotEmpty
                                    ? currentQuestion.mainCategoryOptions
                                    : currentQuestion.subCategoryOptions)
                                .where((o) => o.trim().isNotEmpty)
                                .toList();

                        // Preselect based on persisted selection
                        controller.applyPersistedSelectionForCurrentIndex(options);

                        final locked = controller.isCurrentLocked();
                        bool isSnackBarVisible = false;
                        return Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20.w),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ...List.generate(options.length, (index) {
                                final optionText = formatString(options[index]);

                                return GestureDetector(
                                  onTap: locked
                                      ? null
                                      : () {
                                          if (controller.isAudioPlay == false && locked == false) {
                                            if (!isSnackBarVisible) {
                                              isSnackBarVisible = true; // Mark SnackBar as visible
                                              showSnackBar(
                                                context,
                                                'Play Sound',
                                                backgroundColor: Colors.red,
                                                duration: Duration(seconds: 1), // Optional: Set duration
                                              );

                                              Future.delayed(Duration(seconds: 1), () {
                                                isSnackBarVisible = false;
                                              });
                                            }

                                            return;
                                          } else {
                                            controller.selectQuiz.value = index;
                                            controller.checkForButtonEnabled(optionText);
                                            controller.checkAnswer(options[index]);
                                          }
                                        },
                                  child: Opacity(
                                    opacity: locked ? 0.6 : 1.0,
                                    child: Padding(
                                      padding: const EdgeInsets.only(top: 8),
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: controller.selectQuiz.value == index
                                              ? AppColors.closeIconBgColor
                                              : AppColors.closeIconBgColor.withOpacity(0.25),
                                          borderRadius: BorderRadius.circular(10),
                                          border: Border.all(color: AppColors.borderColor, width: 1.w),
                                        ),
                                        child: Padding(
                                          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 15.h),
                                          child: Center(
                                            child: Text(
                                              removeTimeMarkers(optionText),
                                              // optionText,
                                              style: controller.selectQuiz.value == index
                                                  ? context.textTheme.bodyLarge?.copyWith(
                                                      fontWeight: FontWeight.w700,
                                                      color: context.isDarkMode ? AppColors.primary : AppColors.primaryTextColor,
                                                    )
                                                  : context.textTheme.labelMedium?.copyWith(fontSize: 16.sp),
                                              textAlign: TextAlign.center,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              }),
                            ],
                          ),
                        );
                      }),
                Spacer(),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 0.h),
                  child: GestureDetector(
                    onTap: () async {
                      if (quizViewController.selectQuiz.value == -1) {
                        showSnackBar(context, 'Please choose one option.', backgroundColor: Colors.red);

                        return;
                      }

                      quizViewController.lockCurrentAnswer();
                      final locked = quizViewController.isCurrentLocked();
                      if (quizViewController.isQuizComplete()) {
                        showAnswerBottomSheet(context, locked);
                      } else {
                        showAnswerBottomSheet(context, locked);
                      }
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: quizViewController.selectQuiz.value != -1 ? AppColors.primary : AppColors.primary.withValues(alpha: 0.25),
                        borderRadius: BorderRadius.circular(100.r),
                      ),
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
                        child: Center(
                          child: Text(
                            AppString.checkAnswer,
                            style: context.textTheme.titleLarge?.copyWith(fontSize: 16.sp, color: AppColors.whiteColor),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 20),
              ],
            ),
          ),
        );
      },
    );
  }
}

class RotatingCircleIcon extends StatefulWidget {
  const RotatingCircleIcon({super.key});

  @override
  State<RotatingCircleIcon> createState() => _RotatingCircleIconState();
}

class _RotatingCircleIconState extends State<RotatingCircleIcon> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _rotation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(duration: const Duration(seconds: 1), vsync: this);

    _rotation = Tween<double>(begin: 0.0, end: 0.5).animate(CurvedAnimation(parent: _controller, curve: Curves.bounceOut));

    _controller.forward(); // Play once
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 60.h,
      width: 60.w,
      child: Stack(
        alignment: Alignment.center,
        children: [
          RotationTransition(
            turns: _rotation,
            // painter: HalfCirclePainter(),
            child: SvgPicture.asset(AppAssets.threeStarTwoIcon, height: 25.h, width: 25.w),
          ),
        ],
      ),
    );
  }
}

class HalfCirclePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.blueAccent
      ..strokeWidth = 3.0
      ..style = PaintingStyle.stroke;

    final rect = Rect.fromLTWH(0, 0, size.width, size.height);
    canvas.drawArc(rect, 0, 3.50, false, paint); // Draw half circle
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
