import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:moo_logue/app/core/constants/app_assets.dart';
import 'package:moo_logue/app/core/constants/app_colors.dart';
import 'package:moo_logue/app/core/constants/app_const.dart';
import 'package:moo_logue/app/core/constants/app_sizes.dart';
import 'package:moo_logue/app/core/constants/app_strings.dart';
import 'package:moo_logue/app/core/extention/sized_box_extention.dart';
import 'package:moo_logue/app/model/category/response/get_audio_response_model.dart';
import 'package:moo_logue/app/modules/home/widgets/glass_effect_view.dart';
import 'package:moo_logue/app/modules/home/controllers/home_controller.dart';
import 'package:moo_logue/app/modules/home/widgets/normal_conatiner.dart';
import 'package:moo_logue/app/routes/index.js.dart';
import 'package:moo_logue/app/utils/common_function.dart';
import 'package:moo_logue/app/widgets/common_home_app_bar.dart';
import 'package:moo_logue/app/widgets/rounded_asset_image.dart';

class FenceInteractionDetailsView extends StatefulWidget {
  const FenceInteractionDetailsView({super.key, this.audioData});
  final AudioDataResponseModel? audioData;
  @override
  State<FenceInteractionDetailsView> createState() => _FenceInteractionDetailsViewState();
}

class _FenceInteractionDetailsViewState extends State<FenceInteractionDetailsView> {
  final homeController = Get.find<HomeController>();
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      homeController.markStreakForToday();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    debugPrint('widget.audioData?.audioTitle==========>>>>>${widget.audioData?.audioTitle}');
    return Scaffold(
      appBar: CustomHomeAppBar(),

      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: AppSize.horizontalPadding),
        child: Column(
          children: [
            25.heightBox,
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () => ctx!.pop(),
                  child: SvgPicture.asset(
                    AppAssets.arrowleftIcon,
                    colorFilter: ColorFilter.mode(context.isDarkMode ? AppColors.whiteColor : AppColors.primaryTextColor, BlendMode.srcIn),
                  ),
                ),
                Text(AppString.callDetails, style: context.textTheme.displayMedium?.copyWith()),
                SizedBox(),
              ],
            ),
            25.heightBox,

            // Top bar
            RoundedNetworkImage(
              imageUrl: "$awsFilesUrl${widget.audioData?.audioImage}",
              width: double.infinity,
              height: 220.h,
              fit: BoxFit.cover,
              borderRadius: 20,
            ),
            30.heightBox,
            context.isDarkMode
                ? GlassEffectScreen(
                    width: 389.w,
                    height: 270.h,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        10.heightBox,
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20),
                          child: Text(
                            "🐮 ${formatString(widget.audioData?.audioTitle ?? "", capitalizeWords: false)}",
                            textAlign: TextAlign.center,

                            style: context.textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.w600),
                          ),
                        ),
                        10.heightBox,
                        Divider(color: AppColors.primary),
                        10.heightBox,
                        buildInfoRow("🌸 ${AppString.emotion}", "${widget.audioData?.emotion}"),

                        buildInfoRow("📊 ${AppString.confidenceLvl}", "${widget.audioData?.confident} %"),
                        buildInfoRow("🕒 ${AppString.callDuration}", "${widget.audioData?.callDuration}"),
                        buildInfoRow("🔍 ${AppString.description}", "${widget.audioData?.audioDesc}"),

                        5.heightBox,
                      ],
                    ),
                  )
                : CourseCard(
                    width: 389.w,

                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        10.heightBox,
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20),
                          child: Text(
                            "🐮 ${formatString(widget.audioData?.audioTitle ?? "", capitalizeWords: false)}",
                            textAlign: TextAlign.center,

                            style: context.textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.w600),
                          ),
                        ),
                        10.heightBox,
                        Divider(color: AppColors.primary),
                        10.heightBox,
                        buildInfoRow("🌸 ${AppString.emotion}", "${widget.audioData?.emotion}"),

                        buildInfoRow("📊 ${AppString.confidenceLvl}", "${widget.audioData?.confident} %"),
                        buildInfoRow("🕒 ${AppString.callDuration}", "${widget.audioData?.callDuration}"),
                        buildInfoRow("🔍 ${AppString.description}", "${widget.audioData?.audioDesc}"),

                        5.heightBox,
                      ],
                    ),
                  ),

            Spacer(),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text(
                  "Continue",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Widget for info row
  Widget buildInfoRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("$title: ", style: context.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w400)),
          SizedBox(width: 4),
          Text(value, style: context.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w400)),
        ],
      ),
    );
  }
}
