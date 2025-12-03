import 'dart:io';

import 'package:flutter/services.dart';

class ApkInstall {
  static final ApkInstall _action = ApkInstall._();

  factory ApkInstall() => _action;

  ApkInstall._();

  static const actionInstallCheck = "actionInstallCheck";
  static const actionInstallApk = "actionInstallApk";

  final methodChannel = const MethodChannel('apk_install');

  Future<bool> onCheckInstallApkPermission({bool openSetting = true}) async {
    if (Platform.isAndroid) {
      return await methodChannel
          .invokeMethod(actionInstallCheck, {'open': openSetting});
    } else {
      return false;
    }
  }

  Future<bool> onInstallApk(String path) async {
    if (Platform.isAndroid) {
      return await methodChannel.invokeMethod(actionInstallApk, {'path': path});
    } else {
      return false;
    }
  }
}
