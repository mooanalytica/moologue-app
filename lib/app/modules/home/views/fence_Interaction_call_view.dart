import 'package:audio_waveforms/audio_waveforms.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:just_audio/just_audio.dart' as ja;
import 'package:moo_logue/app/core/constants/app_assets.dart';
import 'package:moo_logue/app/core/constants/app_colors.dart';
import 'package:moo_logue/app/core/constants/app_const.dart';
import 'package:moo_logue/app/core/constants/app_sizes.dart';
import 'package:moo_logue/app/core/constants/app_strings.dart';
import 'package:moo_logue/app/core/extention/sized_box_extention.dart';
import 'package:moo_logue/app/model/category/response/get_audio_response_model.dart';
import 'package:moo_logue/app/modules/home/controllers/fence_Interaction_call_controller.dart';
import 'package:moo_logue/app/routes/app_routes.dart';
import 'package:moo_logue/app/routes/index.js.dart';
import 'package:moo_logue/app/utils/common_function.dart';
import 'package:moo_logue/app/widgets/app_snackbar.dart';
import 'package:moo_logue/app/widgets/common_home_app_bar.dart';
import 'package:moo_logue/app/widgets/rounded_asset_image.dart';

class FenceInteractionCallView extends StatefulWidget {
  final AudioDataResponseModel? audioData;

  const FenceInteractionCallView({super.key, this.audioData});

  @override
  State<FenceInteractionCallView> createState() => _FenceInteractionCallViewState();
}

class _FenceInteractionCallViewState extends State<FenceInteractionCallView> {
  final controller = Get.put(FenceInteractionCallController());
  @override
  void initState() {
    String url = "$awsFilesUrl${widget.audioData?.audioFile}";
    if (!Get.isRegistered<FenceInteractionCallController>()) {
      Get.put(FenceInteractionCallController());
    }
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await controller.setup(url);
      controller.listenAudioStreams();
    });

    super.initState();
  }

  @override
  void dispose() {
    if (Get.isRegistered<FenceInteractionCallController>()) {
      Get.delete<FenceInteractionCallController>();
    }

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      appBar: CustomHomeAppBar(),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: AppSize.horizontalPadding),
        child: GetBuilder<FenceInteractionCallController>(
          builder: (controller) {
            if (controller.isReady == false) {
              return showLoader();
            }
            return Column(
              children: [
                25.heightBox,
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: () => ctx!.pop(),
                      child: Container(
                        height: 30,
                        width: 30,
                        color: Colors.transparent,
                        child: Center(
                          child: SvgPicture.asset(
                            AppAssets.arrowleftIcon,
                            colorFilter: ColorFilter.mode(
                              context.isDarkMode ? AppColors.whiteColor : AppColors.primaryTextColor,
                              BlendMode.srcIn,
                            ),
                          ),
                        ),
                      ),
                    ),
                    10.widthBox,
                    Expanded(
                      child: Text(
                        textAlign: TextAlign.center,
                        formatString("${widget.audioData?.audioTitle}", capitalizeWords: false),
                        style: context.textTheme.displayMedium,
                      ),
                    ),
                    10.widthBox,
                    GestureDetector(
                      onTap: () async {
                        // controller.audioPlayer.stop();
                        await controller.audioPlayer.pause();
                        await controller.waveformController?.pausePlayer();
                        context.push(Routes.quizView, extra: widget.audioData?.audioId);
                      },
                      child: Container(
                        height: 30,
                        width: 30,
                        color: Colors.transparent,
                        child: Center(
                          child: RoundedAssetImage(
                            color: context.isDarkMode ? AppColors.whiteColor : Colors.black,
                            imagePath: AppAssets.quizImage,
                            width: 25.w,
                            height: 25.h,
                            fit: BoxFit.cover,
                            borderRadius: 0,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(),
                  ],
                ),
                25.heightBox,
                RoundedNetworkImage(
                  imageUrl: "$awsFilesUrl${widget.audioData?.audioImage}",
                  width: double.infinity,
                  height: 200.h,
                  fit: BoxFit.cover,
                  borderRadius: 20,
                ),
                25.heightBox,
                Container(
                  height: 80,
                  decoration: BoxDecoration(
                    // color: AppColors.aboutContainerColor.withValues(alpha: 0.25),
                    color: AppColors.primary.withValues(alpha: 0.25),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding: const EdgeInsets.all(8),
                  child: Align(
                    alignment: Alignment.centerLeft, // Force start from left
                    child: AudioFileWaveforms(
                      // key: UniqueKey(),
                      continuousWaveform: true,
                      animationDuration: const Duration(seconds: 1),
                      playerController: controller.waveformController!,
                      enableSeekGesture: false,
                      size: const Size(double.infinity, 80), // match container
                      waveformType: WaveformType.long,
                      playerWaveStyle: PlayerWaveStyle(
                        fixedWaveColor: const Color(0xFF04b07c).withValues(alpha: context.isDarkMode ? 0.2 : 0.33),
                        // fixedWaveColor: const Color(0xff367A23).withValues(alpha: context.isDarkMode ? 0.2 : 0.33),
                        // liveWaveColor: context.isDarkMode ? Color(0xffA4D23B) : Color(0xff367A23),
                        liveWaveColor: context.isDarkMode ? Color(0xff02db99) : Color(0xff367A23),
                        showTop: true,
                        spacing: 3.0,
                        waveThickness: 2.0,
                        waveCap: StrokeCap.round,
                        showSeekLine: false,
                      ),
                    ),
                  ),
                ),
                10.heightBox,
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: AppSize.horizontalPadding),
                  child: Row(
                    children: [
                      Text(
                        controller.formatDuration(controller.position),
                        style: context.textTheme.titleLarge?.copyWith(fontSize: 14.sp, color: AppColors.primary),
                      ),
                      Spacer(),
                      Text(
                        controller.formatDuration(controller.duration),
                        style: context.textTheme.titleLarge?.copyWith(color: AppColors.primary, fontSize: 14.sp),
                      ),
                    ],
                  ),
                ),
                5.heightBox,
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
                      onTap: controller.togglePlayPause,
                      child: StreamBuilder<ja.PlayerState>(
                        stream: controller.audioPlayer.playerStateStream,
                        builder: (context, snapshot) {
                          final state = snapshot.data;
                          final playing = state?.playing ?? false;
                          final completed = state?.processingState == ja.ProcessingState.completed;

                          return Container(
                            width: 65.w,
                            height: 65.h,
                            decoration: BoxDecoration(color: AppColors.primary, shape: BoxShape.circle),
                            child: Center(
                              child: (!playing || completed)
                                  ? SvgPicture.asset(AppAssets.playIcon, width: 13.w, height: 14.h, fit: BoxFit.fill)
                                  : SvgPicture.asset(
                                AppAssets.playPushIcon,
                                width: 13.w,
                                height: 14.h,
                                fit: BoxFit.fill,
                              ),
                            ),
                          );
                          // return IconButton(
                          //   icon: Icon(
                          //     (!playing || completed)
                          //         ? Icons.play_arrow
                          //         : Icons.pause,
                          //   ),
                          //   iconSize: 40,
                          //   onPressed: controller.togglePlayPause,
                          // );
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
                35.heightBox,
                GestureDetector(
                  onTap: () {
                    ctx?.push(Routes.fenceInteractionDetailsView, extra: widget.audioData);
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: AppColors.aboutContainerColor,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 10, horizontal: AppSize.horizontalPadding),
                      child: Text(
                        AppString.callDetails,
                        style: context.textTheme.titleLarge?.copyWith(fontSize: 10.sp, color: AppColors.primary),
                      ),
                    ),
                  ),
                ),
                // Text(
                //   AppString.fenceInteractionCallDisc,
                //   style: context.textTheme.titleSmall?.copyWith(
                //     fontWeight: FontWeight.w400,
                //   ),
                // ),
                // 10.heightBox,
                // Row(
                //   mainAxisAlignment: MainAxisAlignment.start,
                //   children: List.generate(
                //     controller.fenceCallList.length,
                //     (index) => Padding(
                //       padding: const EdgeInsets.only(right: 10),
                //       child: Container(
                //         decoration: BoxDecoration(
                //           color: AppColors.aboutContainerColor,
                //           borderRadius: BorderRadius.circular(12),
                //         ),
                //         child: Padding(
                //           padding: EdgeInsets.symmetric(
                //             vertical: 10,
                //             horizontal: AppSize.horizontalPadding,
                //           ),
                //           child: Text(
                //             controller.fenceCallList[index],
                //             style: context.textTheme.titleLarge?.copyWith(
                //               fontSize: 10.sp,
                //               color: AppColors.primary,
                //             ),
                //           ),
                //         ),
                //       ),
                //     ),
                //   ),
                // ),
              ],
            );
          },
        ),
      ),
    );
  }
}

// import 'dart:io';
// import 'package:audio_waveforms/audio_waveforms.dart';
// import 'package:flutter/material.dart';
// import 'package:just_audio/just_audio.dart' as ja;
// import 'package:http/http.dart' as http;
// import 'package:just_audio/just_audio.dart';
// import 'package:path_provider/path_provider.dart';
//
// class AudioPlayerScreen extends StatefulWidget {
//   const AudioPlayerScreen({super.key});
//
//   @override
//   State<AudioPlayerScreen> createState() => _AudioPlayerScreenState();
// }
//
// class _AudioPlayerScreenState extends State<AudioPlayerScreen> {
//   final ja.AudioPlayer _audioPlayer = ja.AudioPlayer();
//   late final PlayerController _waveformController;
//   bool isRepeating = false;
//
//   final String remoteUrl = "http://samachar.chetakbooks.shop//uploads/1745854811778-699518468.mp4";
//
//   bool isReady = false;
//   bool isMuted = false;
//   bool isPlaying = false;
//   String? _audioFilePath; // store file path for refresh
//
//   @override
//   void initState() {
//     super.initState();
//     _waveformController = PlayerController();
//     _setup();
//
//     // Keep waveform synced
//     _audioPlayer.positionStream.listen((pos) {
//       _waveformController.seekTo(pos.inMilliseconds);
//     });
//
//     // Handle when audio finishes
//     _audioPlayer.playerStateStream.listen((state) async {
//       if (state.processingState == ja.ProcessingState.completed) {
//         if (isRepeating) {
//           // Restart audio
//           await _audioPlayer.seek(Duration.zero);
//           await _audioPlayer.play();
//
//           // Restart waveform properly
//           await _waveformController.stopPlayer();
//           await _waveformController.seekTo(0);
//
//           WidgetsBinding.instance.addPostFrameCallback((_) async {
//             await _waveformController.startPlayer();
//           });
//         } else {
//           // Stop normally
//           await _waveformController.seekTo(0);
//           await _waveformController.pausePlayer();
//           setState(() => isPlaying = false);
//         }
//       }
//     });
//   }
//
//   /// Download and prepare audio
//   Future<void> _setup() async {
//     try {
//       final bytes = await http.get(Uri.parse(remoteUrl));
//       final dir = await getApplicationDocumentsDirectory();
//       final file = File('${dir.path}/temp_audio.mp3');
//       await file.writeAsBytes(bytes.bodyBytes);
//
//       _audioFilePath = file.path; // store path
//
//       await _waveformController.preparePlayer(
//         path: _audioFilePath!,
//         shouldExtractWaveform: true,
//         noOfSamples: 200,
//       );
//       await _waveformController.seekTo(0);
//
//       await _audioPlayer.setFilePath(_audioFilePath!);
//
//       setState(() => isReady = true);
//     } catch (e) {
//       debugPrint('Error preparing player: $e');
//     }
//   }
//
//   /// Play / Pause
//   Future<void> _togglePlayPause() async {
//     final state = _audioPlayer.playerState;
//     final playing = state.playing;
//     final completed = state.processingState == ja.ProcessingState.completed;
//
//     if (completed) {
//       // Reset audio to start
//       await _audioPlayer.seek(Duration.zero);
//
//       // 🔄 Full reset waveform
//       await _waveformController.stopPlayer();
//       await _waveformController.seekTo(0);
//       await _waveformController.preparePlayer(path: _audioFilePath!, shouldExtractWaveform: false);
//
//       // Restart waveform animation
//       WidgetsBinding.instance.addPostFrameCallback((_) async {
//         await _waveformController.startPlayer();
//       });
//
//       await _audioPlayer.play();
//     } else if (playing) {
//       await _audioPlayer.pause();
//       await _waveformController.pausePlayer();
//     } else {
//       await _audioPlayer.play();
//       await _waveformController.startPlayer();
//     }
//
//     setState(() => isPlaying = !playing || completed);
//   }
//
//   /// Skip forward 5 seconds
//   Future<void> _skipForward() async {
//     final position = await _audioPlayer.position;
//     final newPos = position + const Duration(seconds: 5);
//     await _audioPlayer.seek(newPos);
//     await _waveformController.seekTo(newPos.inMilliseconds);
//   }
//
//   /// Skip backward 5 seconds
//   Future<void> _skipBackward() async {
//     final position = await _audioPlayer.position;
//     final newPos = position - const Duration(seconds: 5);
//     final validPos = newPos < Duration.zero ? Duration.zero : newPos;
//     await _audioPlayer.seek(validPos);
//     await _waveformController.seekTo(validPos.inMilliseconds);
//   }
//
//   /// Mute / Unmute
//   Future<void> _toggleMute() async {
//     isMuted = !isMuted;
//     await _audioPlayer.setVolume(isMuted ? 0.0 : 1.0);
//     setState(() {});
//   }
//
//   /// Repeat (restart audio & refresh waveform instantly)
//   Future<void> _toggleRepeat() async {
//     if (_audioFilePath == null) return;
//
//     await _audioPlayer.seek(Duration.zero);
//     await _audioPlayer.play();
//
//     // Fully refresh waveform
//     await _waveformController.stopPlayer();
//     await _waveformController.seekTo(0);
//     await _waveformController.preparePlayer(path: _audioFilePath!, shouldExtractWaveform: false);
//
//     WidgetsBinding.instance.addPostFrameCallback((_) async {
//       await _waveformController.startPlayer();
//       setState(() {
//         isPlaying = true;
//       });
//     });
//   }
//
//   @override
//   void dispose() {
//     _audioPlayer.dispose();
//     _waveformController.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text("Waveform Audio Player")),
//       body: Center(
//         child: isReady
//             ? Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             Container(
//               height: 80,
//               width: 350,
//               padding: const EdgeInsets.all(8),
//               color: Colors.black12,
//               child: Align(
//                 alignment: Alignment.centerLeft,
//                 child: AudioFileWaveforms(
//                   // padding: EdgeInsets.only(right: 250),
//                   continuousWaveform: true,
//                   animationDuration: Duration(seconds: 1),
//                   playerController: _waveformController,
//                   enableSeekGesture: false,
//                   size: const Size(350, 80),
//                   waveformType: WaveformType.long,
//                   playerWaveStyle: PlayerWaveStyle(
//                     fixedWaveColor: Colors.grey,
//                     liveWaveColor: Colors.green,
//                     showTop: true,
//                     spacing: 3.0,
//                     waveThickness: 2.0,
//                     waveCap: StrokeCap.round,
//                     showSeekLine: false,
//                   ),
//                 ),
//               ),
//             ),
//             const SizedBox(height: 24),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 IconButton(icon: const Icon(Icons.replay_5), onPressed: _skipBackward),
//                 StreamBuilder<ja.PlayerState>(
//                   stream: _audioPlayer.playerStateStream,
//                   builder: (context, snapshot) {
//                     final state = snapshot.data;
//                     final playing = state?.playing ?? false;
//                     final completed = state?.processingState == ja.ProcessingState.completed;
//
//                     return IconButton(
//                       icon: Icon((!playing || completed) ? Icons.play_arrow : Icons.pause),
//                       iconSize: 40,
//                       onPressed: _togglePlayPause,
//                     );
//                   },
//                 ),
//                 IconButton(icon: const Icon(Icons.forward_5), onPressed: _skipForward),
//                 IconButton(
//                   icon: Icon(isMuted ? Icons.volume_off : Icons.volume_up),
//                   onPressed: _toggleMute,
//                 ),
//                 IconButton(icon: const Icon(Icons.repeat_one), onPressed: _toggleRepeat),
//               ],
//             ),
//           ],
//         )
//             : const CircularProgressIndicator(),
//       ),
//     );
//   }
// }
