package com.yyl.apk_install

import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import android.content.Context
import android.content.Intent
import android.net.Uri
import android.os.Build
import android.util.Log
import androidx.core.content.FileProvider
import java.io.File
import androidx.core.net.toUri

class ApkInstallPlugin :
    FlutterPlugin,
    MethodCallHandler {
    private val actionInstallCheck = "actionInstallCheck"
    private val actionInstallApk = "actionInstallApk"
    private lateinit var channel: MethodChannel

    private lateinit var contextV: Context
    override fun onAttachedToEngine(flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        contextV = flutterPluginBinding.applicationContext
        channel = MethodChannel(flutterPluginBinding.binaryMessenger, "apk_install")
        channel.setMethodCallHandler(this)
    }

    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        channel.setMethodCallHandler(null)
    }

    override fun onMethodCall(
        call: MethodCall,
        result: Result
    ) {
        if (call.method == actionInstallCheck) {
            checkInstallPermission(contextV, call.argument<Boolean>("open")!!)
            result.success(true)
        } else if (call.method == actionInstallApk) {
            installApp(contextV, call.argument<String>("path")!!)
            result.success(true)
        } else {
            result.notImplemented()
        }
    }


    private fun checkInstallPermission(context: Context, open: Boolean): Boolean {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            val hasInstallPermission = context.packageManager.canRequestPackageInstalls()
            if (!hasInstallPermission) {
                // 跳转到设置页面开启权限
                if (open) {
                    val intent = Intent(android.provider.Settings.ACTION_MANAGE_UNKNOWN_APP_SOURCES)
                    intent.data = "package:${context.packageName}".toUri()
                    intent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
                    context.startActivity(intent)
                }
            }
            return hasInstallPermission
        }
        return true
    }

    private fun installApp(context: Context, apkPath: String) {
        val file = File(apkPath)
        if (!file.exists()) {
            // 这里可以添加日志或 Toast 提示文件不存在
            Log.e("ApkInstallPlugin", "error: $apkPath exists()")
            return
        }
        val intent = Intent(Intent.ACTION_VIEW)
        // 如果是从非 Activity 环境（如 Service 或 Broadcast）启动，需要这个 Flag
        intent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)

        val uri: Uri
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.N) {
            // Android 7.0+ 需要使用 FileProvider
            intent.addFlags(Intent.FLAG_GRANT_READ_URI_PERMISSION)
            val authority = "${context.packageName}.apk.fileprovider" // 必须与 Manifest 中配置的一致
            uri = FileProvider.getUriForFile(context, authority, file)
        } else {
//            // Android 7.0 以下直接使用文件路径
            uri = Uri.fromFile(file)
        }
        intent.setDataAndType(uri, "application/vnd.android.package-archive")
        try {
            context.startActivity(intent)
        } catch (e: Exception) {
            e.printStackTrace()
            checkInstallPermission(context,true)
        }
    }

}
