# apk_install

apk install tools

## Getting Started
# install_plugin

[![Build Status](https://travis-ci.org/hui-z/flutter_install_plugin.svg?branch=master)](https://travis-ci.org/hui-z/flutter_install_plugin#)
[![pub package](https://img.shields.io/pub/v/install_plugin.svg)](https://pub.dartlang.org/packages/install_plugin)
[![license](https://img.shields.io/github/license/mashape/apistatus.svg)](https://github.com/hui-z/flutter_install_plugin/blob/master/LICENSE)

We use the `apk_install` plugin to install apk for android;

## Usage

To use this plugin, add `apk_install` as a dependency in your pubspec.yaml file. For example:
```yaml
dependencies:
  apk_install: '^1.0.0'
```
##  Android
You need to request permission for READ_EXTERNAL_STORAGE to read the apk file. You can handle the storage permission using [flutter_permission_handler](https://github.com/BaseflowIT/flutter-permission-handler).
```
 <!-- read permissions for external storage -->
 <uses-permission android:name="android.permission.READ_EXTERNAL_STORAGE" />
```
In Android version >= 8.0 , You need to request permission for REQUEST_INSTALL_PACKAGES to install the apk file
 ```
 <!-- installation package permissions -->
 <uses-permission android:name="android.permission.REQUEST_INSTALL_PACKAGES" />
 ```
In Android version <= 6.0 , You need to request permission for WRITE_EXTERNAL_STORAGE to copy the apk from the app private location to the download directory
 ```
 <!-- write permissions for external storage -->
 <uses-permission android:name="android.permission.WRITE_EXTERNAL_STORAGE" />
 ```

## Example
install apk from the internet
``` dart
 installApk() async {
  final check = await ApkInstall().onCheckInstallApkPermission();
  final state = await ApkInstall().onInstallApk(apkPath);
 }
```