package com.sprint.countdown

import android.appwidget.AppWidgetManager
import android.content.Context
import android.content.SharedPreferences
import android.widget.RemoteViews
import es.antonborri.home_widget.HomeWidgetProvider
import java.util.concurrent.TimeUnit

/**
 * Renders the launch countdown on the Android home screen. Reads the
 * `target_epoch_ms` value the Flutter app writes via [HomeWidgetBridge]
 * and computes the remaining time itself, so the widget keeps ticking
 * on its own refresh schedule even when the app isn't running.
 */
class CountdownWidgetProvider : HomeWidgetProvider() {

    override fun onUpdate(
        context: Context,
        appWidgetManager: AppWidgetManager,
        appWidgetIds: IntArray,
        widgetData: SharedPreferences
    ) {
        val targetEpochMs = widgetData.getLong("target_epoch_ms", 0L)
        val remainingMs = targetEpochMs - System.currentTimeMillis()

        val label = if (targetEpochMs == 0L || remainingMs <= 0) {
            "WE ARE LIVE"
        } else {
            val days = TimeUnit.MILLISECONDS.toDays(remainingMs)
            val hours = TimeUnit.MILLISECONDS.toHours(remainingMs) % 24
            val minutes = TimeUnit.MILLISECONDS.toMinutes(remainingMs) % 60
            "${days}d ${hours}h ${minutes}m"
        }

        for (widgetId in appWidgetIds) {
            val views = RemoteViews(context.packageName, R.layout.countdown_widget)
            views.setTextViewText(R.id.widget_countdown_text, label)
            appWidgetManager.updateAppWidget(widgetId, views)
        }
    }
}
