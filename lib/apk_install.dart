import 'dart:io';

import 'package:flutter/services.dart';

/// APK installation utility class
/// Provides methods to check installation permissions and install APK files
class ApkInstall {
  static final ApkInstall _action = ApkInstall._();

  factory ApkInstall() => _action;

  ApkInstall._();

  /// Action name for checking installation permission
  static const actionInstallCheck = "actionInstallCheck";

  /// Action name for installing APK
  static const actionInstallApk = "actionInstallApk";

  /// Method channel for communicating with native platform (Android)
  final methodChannel = const MethodChannel('apk_install');

  /// Checks if the app has permission to install APK files
  ///
  /// [openSetting]: If true, opens system settings when permission is not granted
  /// Returns: true if permission is granted, false otherwise
  /// Note: Only works on Android platform
  Future<bool> onCheckInstallApkPermission({bool openSetting = true}) async {
    if (Platform.isAndroid) {
      return await methodChannel
          .invokeMethod(actionInstallCheck, {'open': openSetting});
    } else {
      return false;
    }
  }

  /// Installs an APK file from the given path
  ///
  /// [path]: The file path of the APK to install
  /// Returns: true if installation initiated successfully, false otherwise
  /// Note: Only works on Android platform
  Future<bool> onInstallApk(String path) async {
    if (Platform.isAndroid) {
      return await methodChannel.invokeMethod(actionInstallApk, {'path': path});
    } else {
      return false;
    }
  }
}
