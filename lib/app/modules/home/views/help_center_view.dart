import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:moo_logue/app/core/constants/app_assets.dart';
import 'package:moo_logue/app/core/constants/app_strings.dart';
import 'package:moo_logue/app/widgets/custom_appbar.dart';
import 'package:url_launcher/url_launcher.dart';

class HelpCenterView extends StatefulWidget {
  const HelpCenterView({super.key});

  @override
  State<HelpCenterView> createState() => _HelpCenterViewState();
}

class _HelpCenterViewState extends State<HelpCenterView> {
  Future<void> launchEmail() async {
    final Uri emailUri = Uri(
      scheme: 'mailto',
      path: 'mooanalytica@gmail.com',
      query: Uri.encodeFull('subject=Hello&body=Hi, I want to contact you'),
    );

    if (await canLaunchUrl(emailUri)) {
      await launchUrl(emailUri);
    } else {
      throw Exception('No email app available on this device');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppbar(text: AppString.helpCenter),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SvgPicture.asset(AppAssets.appLogo, width: 100.w, height: 100.h),
            SizedBox(height: 10.h),
            Text(AppString.appName, style: TextStyle(fontSize: 24)),
            SizedBox(height: 20.h),
            Text("Please email us-", style: TextStyle(fontSize: 15)),
            SizedBox(height: 5.h),
            GestureDetector(
              onTap: () async {
                await launchEmail();
              },
              child: Text(
                "mooanalytica@gmail.com",
                style: TextStyle(fontSize: 12, decoration: TextDecoration.underline, color: Colors.blue, decorationColor: Colors.blue),
              ),
            ),
            SizedBox(height: 80.h),
          ],
        ),
      ),
    );
  }
}
