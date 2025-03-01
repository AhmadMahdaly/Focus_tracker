package com.example.focus_tracker

import android.app.PendingIntent
import android.appwidget.AppWidgetManager
import android.appwidget.AppWidgetProvider
import android.content.Context
import android.content.Intent
import android.content.SharedPreferences
import android.os.Handler
import android.os.Looper
import android.widget.RemoteViews

class FocusWidgetReceiver : AppWidgetProvider() {
    private val CHANNEL = "update_widget_channel"
    companion object {
        private const val PREFS_NAME = "focus_prefs"
        private const val TIMER_KEY = "remaining_time"
        private const val DEFAULT_TIME = 25 * 60 // 5 دقائق
        private var isTimerRunning = false
        private val handler = Handler(Looper.getMainLooper())
        private lateinit var runnable: Runnable

        fun updateAppWidget(context: Context, appWidgetManager: AppWidgetManager, appWidgetId: Int) {
            val sharedPreferences = context.getSharedPreferences(PREFS_NAME, Context.MODE_PRIVATE)
            val remainingTime = sharedPreferences.getInt(TIMER_KEY, DEFAULT_TIME)

            val views = RemoteViews(context.packageName, R.layout.widget_focus)
            val formattedTime = String.format("%02d:%02d", remainingTime / 60, remainingTime % 60)
            views.setTextViewText(R.id.timer_text, formattedTime)

            // إعداد زر البدء
            val intent = Intent(context, FocusWidgetReceiver::class.java).apply {
                action = "START_TIMER"
            }
            val pendingIntent = PendingIntent.getBroadcast(
                context, 0, intent, PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE
            )
            views.setOnClickPendingIntent(R.id.widget_button, pendingIntent)

            // تحديث الويدجت
            appWidgetManager.updateAppWidget(appWidgetId, views)
        }

        private fun startTimer(context: Context, appWidgetManager: AppWidgetManager, appWidgetId: Int) {
            if (isTimerRunning) return

            isTimerRunning = true
            handler.removeCallbacksAndMessages(null)

            val sharedPreferences = context.getSharedPreferences(PREFS_NAME, Context.MODE_PRIVATE)
            val editor = sharedPreferences.edit()
            var remainingTime = DEFAULT_TIME

            runnable = object : Runnable {
                override fun run() {
                    if (remainingTime > 0) {
                        remainingTime--
                        editor.putInt(TIMER_KEY, remainingTime)
                        editor.apply()
                        updateAppWidget(context, appWidgetManager, appWidgetId)
                        handler.postDelayed(this, 1000)
                    } else {
                        isTimerRunning = false
                    }
                }
            }
            handler.postDelayed(runnable, 1000)

            // إرسال التحديث للتطبيق أيضًا
            val appIntent = Intent("TIMER_UPDATED")
            appIntent.putExtra("remaining_time", remainingTime)
            context.sendBroadcast(appIntent)
        }
    }

    override fun onUpdate(context: Context, appWidgetManager: AppWidgetManager, appWidgetIds: IntArray) {
        for (appWidgetId in appWidgetIds) {
            updateAppWidget(context, appWidgetManager, appWidgetId)
        }
    }

    override fun onReceive(context: Context, intent: Intent) {
        super.onReceive(context, intent)
        if (intent.action == "START_TIMER") {
            val sharedPreferences = context.getSharedPreferences(PREFS_NAME, Context.MODE_PRIVATE)
            val editor = sharedPreferences.edit()
            editor.putInt(TIMER_KEY, DEFAULT_TIME)
            editor.apply()

            for (appWidgetId in AppWidgetManager.getInstance(context).getAppWidgetIds(intent.component)) {
                startTimer(context, AppWidgetManager.getInstance(context), appWidgetId)
            }
        } else if (intent.action == "TIMER_UPDATED") {
            val newTime = intent.getIntExtra("remaining_time", DEFAULT_TIME)
            val sharedPreferences = context.getSharedPreferences(PREFS_NAME, Context.MODE_PRIVATE)
            val editor = sharedPreferences.edit()
            editor.putInt(TIMER_KEY, newTime)
            editor.apply()
        }
    }
}
