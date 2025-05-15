package com.example.digitalsignange

import android.app.Activity
import android.content.ContentValues
import android.content.Context
import android.content.Intent
import android.graphics.Bitmap
import android.graphics.Canvas
import android.graphics.Rect
import android.net.Uri
import android.os.Build
import android.os.Bundle
import android.os.Environment
import android.os.Handler
import android.os.Looper
import android.provider.MediaStore
import android.util.Log
import android.view.PixelCopy
import android.view.View
import androidx.annotation.RequiresApi
import androidx.core.content.FileProvider
import androidx.lifecycle.lifecycleScope
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import kotlinx.coroutines.launch
import kotlinx.coroutines.suspendCancellableCoroutine
import java.io.File
import java.io.FileOutputStream
import kotlin.coroutines.resumeWithException
import androidx.core.graphics.createBitmap
import java.io.IOException
import java.io.OutputStream
import java.text.SimpleDateFormat
import java.util.Date
import java.util.Locale

class MainActivity: FlutterActivity() {
    private val CHANNEL = "com.example.channel"
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        // Any additional setup can go here
    }

    @RequiresApi(Build.VERSION_CODES.O)
    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            CHANNEL
        ).setMethodCallHandler { call, result ->
            when (call.method) {
                "take_screen_shot" -> {
                    val message = "Hello from Android Native Code!"
                    println("TAKE SCREEN SHOT CALLED")
//                 val filePath=   takeFullScreenshot(
//                        this@MainActivity,
//                        onSuccess = {
//                            println("screen shot success")
//                        },
//                        onError = {}
//                    )


                    lifecycleScope.launch {
                        try {
//                            val path = takeFullScreenshotSuspend(activity)
//                            openScreenshotWithFileManager(this@MainActivity,path)
                            val rootView: View = window.decorView.rootView
                            takeScreenshot(view = rootView)
                            result.success("path")

                        } catch (e: Exception) {
                            result.success("")
                        }
                    }

                    println("FILE PATH SENT ON SUCCESSS")
//                    println(filePath)

                }




                else -> {
                    result.notImplemented()
                }
            }
        }
    }




//    fun openScreenshotWithFileManager(context: Context, filePath: String) {
//        val inputFile = File(filePath)
//
//        if (!inputFile.exists()) {
//            Log.e("OpenFile", "File doesn't exist")
//            return
//        }
//
//        // Copy to public Downloads folder
//        val externalDir = Environment.getExternalStoragePublicDirectory(Environment.DIRECTORY_DOWNLOADS)
//        val destFile = File(externalDir, inputFile.name)
//
//        try {
//            inputFile.copyTo(destFile, overwrite = true)
//
//            val uri = FileProvider.getUriForFile(
//                context,
//                "${context.packageName}.provider",
//                destFile
//            )
//
//            val intent = Intent(Intent.ACTION_VIEW).apply {
//                setDataAndType(uri, "image/png")
//                addFlags(Intent.FLAG_GRANT_READ_URI_PERMISSION)
//            }
//
//            context.startActivity(Intent.createChooser(intent, "Open screenshot with"))
//        } catch (e: Exception) {
//            e.printStackTrace()
//        }
//    }
//
//
//
//    @RequiresApi(Build.VERSION_CODES.O)
//    suspend fun takeFullScreenshotSuspend(activity: Activity): String = suspendCancellableCoroutine { cont ->
//        val window = activity.window
//        val view = window.decorView
//
//        val bitmap = createBitmap(100, 100)
//        val locationInWindow = IntArray(2)
//        view.getLocationInWindow(locationInWindow)
//
//        val handler = Handler(Looper.getMainLooper())
//
//        try {
//            PixelCopy.request(
//                window,
//                Rect(
//                    locationInWindow[0],
//                    locationInWindow[1],
//                    locationInWindow[0] + 100,
//                    locationInWindow[1] + 100
//                ),
//                bitmap,
//                { result ->
//                    if (result == PixelCopy.SUCCESS) {
//                        try {
//                            val file = File(activity.cacheDir, "screenshot_${System.currentTimeMillis()}.png")
//                            FileOutputStream(file).use { outputStream ->
//                                bitmap.compress(Bitmap.CompressFormat.PNG, 100, outputStream)
//                            }
//                            cont.resume(file.absolutePath, null)
//                        } catch (e: Exception) {
//                            cont.resumeWithException(e)
//                        }
//                    } else {
//                        cont.resumeWithException(RuntimeException("PixelCopy failed with code $result"))
//                    }
//                },
//                handler
//            )
//        } catch (e: Exception) {
//            cont.resumeWithException(e)
//        }
//    }





    // Method to Take Screenshot of the View
    private fun takeScreenshot(view: View): Boolean {
        val now = Date()
        val dateFormat = SimpleDateFormat("yyyy-MM-dd_HH-mm-ss", Locale.US)
        val fileName = "Screenshot_" + dateFormat.format(now)

        // Enable drawing cache
        view.isDrawingCacheEnabled = true
        val bitmap = Bitmap.createBitmap(view.drawingCache)
        view.isDrawingCacheEnabled = false




        val flutterView = activity.findViewById<View>(android.R.id.home)
        if (flutterView != null) {
            val bitmap2 = Bitmap.createBitmap(
                300,
               300,
                Bitmap.Config.ARGB_8888
            )
            val canvas = Canvas(bitmap2)
            flutterView.draw(canvas)
            return saveBitmap(bitmap2, fileName)
        }


        return saveBitmap(bitmap, fileName)
    }

    // Method to Save the Image in the Gallery
    private fun saveBitmap(bitmap: Bitmap, fileName: String): Boolean {
        var outputStream: OutputStream? = null

        try {
            // Handle saving based on Android version
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.Q) {
                // For Android 10 and above: Use MediaStore

                val values = ContentValues()
                values.put(MediaStore.Images.Media.DISPLAY_NAME, "$fileName.jpeg")
                values.put(MediaStore.Images.Media.MIME_TYPE, "image/jpeg")
                values.put(MediaStore.Images.Media.RELATIVE_PATH, Environment.DIRECTORY_PICTURES)

                val uri: Uri? = getContentResolver().insert(
                    MediaStore.Images.Media.EXTERNAL_CONTENT_URI,
                    values
                )
                if (uri != null) {
                    outputStream = getContentResolver().openOutputStream(uri)
                    if (outputStream != null) {
                        bitmap.compress(Bitmap.CompressFormat.JPEG, 90, outputStream)
                    }
                    return true
                }
            } else {
                // For older Android versions: Use file system directly

                val imagesDir =
                    Environment.getExternalStoragePublicDirectory(Environment.DIRECTORY_PICTURES)
                if (!imagesDir.exists()) {
                    imagesDir.mkdirs()
                }

                val imageFile = File(imagesDir, "$fileName.jpeg")
                outputStream = FileOutputStream(imageFile)
                bitmap.compress(Bitmap.CompressFormat.JPEG, 90, outputStream)
                return true
            }
        } catch (e: Exception) {
            e.printStackTrace()
        } finally {
            if (outputStream != null) {
                try {
                    outputStream.close()
                } catch (e: IOException) {
                    e.printStackTrace()
                }
            }
        }

        return false
    }




}
