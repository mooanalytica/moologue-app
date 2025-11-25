import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:go_router/go_router.dart';
import 'package:moo_logue/app/core/constants/app_assets.dart';
import 'package:moo_logue/app/core/constants/app_colors.dart';
import 'package:moo_logue/app/core/constants/app_sizes.dart';
import 'package:moo_logue/app/core/constants/app_strings.dart';
import 'package:moo_logue/app/core/storage/get_storage.dart';
import 'package:moo_logue/app/modules/authentication/controllers/settings_view_controller.dart';
import 'package:moo_logue/app/routes/app_routes.dart';
import 'package:moo_logue/app/routes/index.js.dart';
import 'package:moo_logue/app/widgets/custom_appbar.dart';

class SettingsView extends StatelessWidget {
  final storage = GetStorage();
  final controller = Get.put(SettingsViewController());
  SettingsView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppbar(text: AppString.settings),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: AppSize.horizontalPadding),
        child: Theme(
          data: ThemeData(splashFactory: NoSplash.splashFactory, splashColor: Colors.transparent, highlightColor: Colors.transparent),
          child: Column(
            children: List.generate(
              controller.settingsList.length,
              (index) => Column(
                children: [
                  ListTile(
                    leading: SvgPicture.asset(
                      "${controller.settingsList[index]['SettingsIcon']}",
                      height: 20.h,
                      width: 20.w,
                      colorFilter: ColorFilter.mode(
                        context.isDarkMode ? AppColors.whiteColor : AppColors.primaryTextColor,
                        BlendMode.srcIn,
                      ),
                    ),
                    title: Text(
                      "${controller.settingsList[index]['SettingsName']}",
                      style: context.textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.w600),
                    ),
                    trailing: index == 3
                        ? null
                        : SvgPicture.asset(
                            AppAssets.arrowRight_icon,
                            height: 16.h,
                            width: 10.w,
                            colorFilter: ColorFilter.mode(
                              context.isDarkMode ? AppColors.whiteColor : AppColors.primaryTextColor,
                              BlendMode.srcIn,
                            ),
                          ),

                    onTap: () {
                      index == 0
                          ? ctx!.push(Routes.updateAccountView)
                          : index == 1
                          ? ctx!.push(Routes.displayView) :index == 2 ?ctx!.push(Routes.helpCenterView)
                          : index == 3
                          ? showDialog<void>(
                              context: context,
                              barrierDismissible: false, // User must tap button
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                                  title: const Text('Delete Account', style: TextStyle(fontWeight: FontWeight.bold)),
                                  content: const Text('Are you sure you want to delete your account? This action cannot be undone.'),
                                  actions: <Widget>[
                                    TextButton(
                                      child: Text('Cancel', style: TextStyle()),
                                      onPressed: () {
                                        Navigator.of(context).pop(false); // return false
                                      },
                                    ),
                                    ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.red,
                                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                      ),
                                      child: Text('Delete', style: TextStyle(color: AppColors.whiteColor)),
                                      onPressed: () async {
                                        Navigator.of(context).pop(true); // return false
                                        await controller.deleteUserAccount(context);
                                      },
                                    ),
                                  ],
                                );
                              },
                            )
                          : index == 4
                          ? AppStorage.logout()
                          : null;
                    },
                  ),
                  Divider(color: context.isDarkMode ? AppColors.whiteColor : AppColors.primaryTextColor.withValues(alpha: 0.1)),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
