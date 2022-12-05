package com.example.hourglass

//import android.Manifest
//import android.content.Intent
//import android.net.Uri
//import android.os.Build
//import androidx.core.content.FileProvider
import io.flutter.embedding.android.FlutterActivity
//import io.flutter.embedding.engine.FlutterEngine
//import io.flutter.plugin.common.MethodCall
//import io.flutter.plugin.common.MethodChannel
//import java.io.File
//import java.io.FileNotFoundException

class MainActivity : FlutterActivity() {
//    private val INSTALL = "com.mitsuha.util/installAPK"
//    private val MIME = "application/vnd.android.package-archive"
//
//    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
//        super.configureFlutterEngine(flutterEngine)
//
//        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, INSTALL).setMethodCallHandler { call, result ->
//            if (call.method == "installAPK") {
//                result.success(installAPK(call));
//            } else {
//                result.notImplemented()
//            }
//
//        }
//    }

//    private fun installAPK(call: MethodCall): String {
//        val path = call.argument<String>("file").toString()
//
//        val file = File(path)
//
//        if (!file.exists()) {
//            throw FileNotFoundException("$path is not exist or check permission")
//        }
//
//        requestPermissions(listOf(Manifest.permission.INSTALL_PACKAGES).toTypedArray(), 101);
//
//        // open install activity
//        val intent = Intent(Intent.ACTION_VIEW)
//        intent.flags = Intent.FLAG_ACTIVITY_NEW_TASK
//        //兼容7.0
//        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.N) {
//            intent.flags = Intent.FLAG_GRANT_READ_URI_PERMISSION
//            //这里牵涉到7.0系统中URI读取的变更
//            val contentUri = FileProvider.getUriForFile(activity, "${packageName}.FileProvider", file)
//            intent.setDataAndType(contentUri, MIME)
//            //兼容8.0
//            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
//                if (!packageManager.canRequestPackageInstalls()) {
//                    throw IllegalAccessException("User canceled authorization")
//                }
//            }
//        } else {
//            intent.setDataAndType(Uri.fromFile(file), MIME)
//        }
//
//        applicationContext.startActivity(intent)
//
//        return call.argument<String>("file").toString()
//    }
}
