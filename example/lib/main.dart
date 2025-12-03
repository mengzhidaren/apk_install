import 'dart:io';

import 'package:flutter/material.dart';

import 'package:apk_install/apk_install.dart';
import 'package:path_provider/path_provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final apkInstall = ApkInstall();

  @override
  void initState() {
    super.initState();
    test();
  }

  test() async {
    final cache = (await getExternalCacheDirectories())?.first;
    if (cache != null) {
      final testApk = File("${cache.path}/demo1.apk");
      testApk.create(recursive: true);
    }
  }

  installApk() async {
    final cache = (await getExternalCacheDirectories())?.first;
    if (cache == null) {
      return;
    }
    // final path = "${cache.path}/demo1.apk";
    final path = "${cache.path}/app-release.apk";
    final check = await apkInstall.onCheckInstallApkPermission();
    final state = await apkInstall.onInstallApk(path);
    setState(() {
      info = "check=$check state=$state";
    });
  }

  var info = "";

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text('Plugin Test Install Apk app')),
        body: Center(
          child: Column(
            children: [
              ElevatedButton(
                onPressed: () {
                  installApk();
                },
                child: Text("InstallApk"),
              ),
              Text(info),
            ],
          ),
        ),
      ),
    );
  }
}
