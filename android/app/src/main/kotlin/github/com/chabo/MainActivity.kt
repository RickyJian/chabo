package github.com.chabo

import android.content.Context
import android.graphics.Rect
import android.media.RingtoneManager
import android.view.View
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        EventChannel(flutterEngine.dartExecutor.binaryMessenger, "chabo/keyboard").setStreamHandler(object : EventChannel.StreamHandler {

            // refer to: https://medium.com/@munnsthoughts/detecting-if-the-android-keyboard-is-open-using-kotlin-rxjava-2-8aee9fae262c
            override fun onListen(arguments: Any?, events: EventChannel.EventSink?) {
                val rootView = activity.findViewById<View>(android.R.id.content)
                window.decorView.rootView.viewTreeObserver.addOnGlobalLayoutListener {
                    val rect = Rect().apply { rootView.getWindowVisibleDisplayFrame(this) }
                    val screenHeight = rootView.height
                    val keyboardHeight = screenHeight - rect.bottom
                    events?.success(keyboardHeight)
                }
            }

            override fun onCancel(arguments: Any?) {}
        })

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, "chabo/alarm").setMethodCallHandler { call, result ->
            when (call.method) {
                "listSystemAlarms" -> {
                    result.success(listSystemAlarms(this))
                }

                else -> {
                    result.notImplemented()
                }
            }
        }

    }

    private fun listSystemAlarms(context: Context): List<String> {
        val manager = RingtoneManager(context)
        manager.setType(RingtoneManager.TYPE_ALARM)
        val cursor = manager.cursor
        val ringtones = mutableListOf<String>()
        while (cursor.moveToNext()) {
            val name = manager.getRingtone(cursor.position).getTitle(this)
            val uri = manager.getRingtoneUri(cursor.position).toString()
            // TODO: use `kotlin-serialization` instead
            ringtones.add("{\"name\": \"$name\", \"uri\": \"$uri\"}")
        }
        return ringtones
    }
}
