package github.com.chabo

import android.content.Context
import android.graphics.Rect
import android.media.AudioAttributes
import android.media.AudioManager
import android.media.MediaPlayer
import android.media.RingtoneManager
import android.net.Uri
import android.os.Build
import android.view.View
import androidx.annotation.RequiresApi
import io.flutter.Log
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        EventChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            "chabo/keyboard"
        ).setStreamHandler(
            object : EventChannel.StreamHandler {

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

        MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            "chabo/alarm"
        ).setMethodCallHandler { call, result ->
            when (call.method) {
                "listSystemAlarms" -> {
                    result.success(listSystemAlarms(this))
                }

                "playSystemAlarm" -> {
                    when {
                        call.arguments !is String -> {
                            result.error("ILLEGAL_TYPE", "arguments must be string", null)
                        }

                        call.arguments == "" -> {
                            result.error("EMPTY_URI", "empty uri", null)
                        }

                        else -> {
                            playSystemAlarm(this, Uri.parse(call.arguments as String))
                            result.success(call.arguments)
                        }
                    }
                }

                "stopSystemAlarm" -> {
                    stopSystemAlarm()
                    result.success(call.arguments)
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

    private lateinit var player: MediaPlayer

    private fun playSystemAlarm(context: Context, uri: Uri) {
        player = MediaPlayer()
        player.setAudioAttributes(
            AudioAttributes.Builder()
                .setUsage(AudioAttributes.USAGE_ALARM)
                .setContentType(AudioAttributes.CONTENT_TYPE_SONIFICATION)
                .build()
        )
        player.setDataSource(context, uri)
        player.prepare()
        player.start()
    }

    private fun stopSystemAlarm() {
        if (player.isPlaying) {
            player.stop()
        }
        player.release()
    }
}
