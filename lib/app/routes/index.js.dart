import 'package:flutter/material.dart';
import 'package:moo_logue/app/routes/app_pages.dart';

BuildContext? get ctx =>
    AppPages.routes.routerDelegate.navigatorKey.currentContext;
