package com.nomo.nomo

import android.appwidget.AppWidgetManager
import android.content.Context
import android.content.Intent
import android.content.SharedPreferences
import android.net.Uri
import android.os.Build
import android.os.Bundle
import android.util.SizeF
import android.view.View
import android.widget.RemoteViews
import es.antonborri.home_widget.HomeWidgetProvider
import org.json.JSONArray

class QuitTrackerWidgetProvider : HomeWidgetProvider() {

    override fun onUpdate(
        context: Context,
        appWidgetManager: AppWidgetManager,
        appWidgetIds: IntArray,
        widgetData: SharedPreferences,
    ) {
        appWidgetIds.forEach { widgetId ->
            updateWidget(context, appWidgetManager, widgetId, widgetData)
        }
    }

    override fun onAppWidgetOptionsChanged(
        context: Context,
        appWidgetManager: AppWidgetManager,
        appWidgetId: Int,
        newOptions: Bundle?,
    ) {
        super.onAppWidgetOptionsChanged(context, appWidgetManager, appWidgetId, newOptions)
        val widgetData = es.antonborri.home_widget.HomeWidgetPlugin.getData(context)
        updateWidget(context, appWidgetManager, appWidgetId, widgetData)
    }

    private fun updateWidget(
        context: Context,
        appWidgetManager: AppWidgetManager,
        widgetId: Int,
        widgetData: SharedPreferences,
    ) {
        val configPrefs = context.getSharedPreferences(PREFS_CONFIG, Context.MODE_PRIVATE)
        val trackersJson = widgetData.getString(KEY_TRACKERS_LIST, null)

        val trackerId = configPrefs.getString("${PREF_TRACKER_ID}_$widgetId", null)
        val includeCraving = configPrefs.getBoolean("${PREF_INCLUDE_CRAVING}_$widgetId", true)

        val trackerName: String
        val elapsed: String

        if (trackerId != null && trackersJson != null) {
            val tracker = findTrackerInJson(trackersJson, trackerId)
            if (tracker != null) {
                trackerName = tracker.name
                elapsed = tracker.elapsed
            } else {
                trackerName = context.getString(R.string.widget_default_tracker_name)
                elapsed = "—"
            }
        } else {
            trackerName = context.getString(R.string.widget_default_tracker_name)
            elapsed = "—"
        }

        val applyToViews: (RemoteViews) -> Unit = { views ->
            views.apply {
                setTextViewText(R.id.widget_tracker_name, trackerName)
                setTextViewText(R.id.widget_elapsed, elapsed)

                val openTrackerUri = if (trackerId != null) {
                    Uri.parse("nomo://widget/open-tracker?trackerId=$trackerId")
                } else {
                    Uri.parse("nomo://")
                }
                val openIntent = Intent(Intent.ACTION_VIEW, openTrackerUri)
                    .setPackage(context.packageName)
                val openPending = android.app.PendingIntent.getActivity(
                    context, widgetId, openIntent,
                    android.app.PendingIntent.FLAG_UPDATE_CURRENT or android.app.PendingIntent.FLAG_IMMUTABLE
                )
                setOnClickPendingIntent(R.id.widget_tracker_name, openPending)
                setOnClickPendingIntent(R.id.widget_elapsed, openPending)

                if (includeCraving && trackerId != null) {
                    setViewVisibility(R.id.widget_right_column, View.VISIBLE)
                    setViewVisibility(R.id.widget_log_craving_btn, View.VISIBLE)
                    val logCravingUri = Uri.parse("nomo://widget/log-craving?trackerId=$trackerId")
                    val logCravingIntent = Intent(Intent.ACTION_VIEW, logCravingUri)
                        .setPackage(context.packageName)
                    val logCravingPending = android.app.PendingIntent.getActivity(
                        context, widgetId + 1000, logCravingIntent,
                        android.app.PendingIntent.FLAG_UPDATE_CURRENT or android.app.PendingIntent.FLAG_IMMUTABLE
                    )
                    setOnClickPendingIntent(R.id.widget_log_craving_btn, logCravingPending)
                } else {
                    setViewVisibility(R.id.widget_right_column, View.GONE)
                    setViewVisibility(R.id.widget_log_craving_btn, View.GONE)
                }
            }
        }

        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.S) {
            val compactViews = RemoteViews(context.packageName, R.layout.quit_tracker_widget_compact)
            val expandedViews = RemoteViews(context.packageName, R.layout.quit_tracker_widget_expanded)
            applyToViews(compactViews)
            applyToViews(expandedViews)

            val viewMapping = mapOf(
                SizeF(250f, 110f) to compactViews,
                SizeF(250f, 250f) to expandedViews,
            )
            val remoteViews = RemoteViews(viewMapping)
            appWidgetManager.updateAppWidget(widgetId, remoteViews)
        } else {
            val options = appWidgetManager.getAppWidgetOptions(widgetId)
            val maxHeight = options.getInt(AppWidgetManager.OPTION_APPWIDGET_MAX_HEIGHT, 300)
            val layoutRes = if (maxHeight <= 180) R.layout.quit_tracker_widget_compact else R.layout.quit_tracker_widget_expanded
            val views = RemoteViews(context.packageName, layoutRes)
            applyToViews(views)
            appWidgetManager.updateAppWidget(widgetId, views)
        }
    }

    private fun findTrackerInJson(json: String, trackerId: String): TrackerInfo? {
        return try {
            val arr = JSONArray(json)
            for (i in 0 until arr.length()) {
                val obj = arr.getJSONObject(i)
                if (obj.optString("id") == trackerId) {
                    return TrackerInfo(
                        name = obj.optString("name", "Tracker"),
                        elapsed = obj.optString("elapsed", "—"),
                    )
                }
            }
            null
        } catch (e: Exception) {
            null
        }
    }

    private data class TrackerInfo(val name: String, val elapsed: String)

    companion object {
        private const val PREFS_CONFIG = "quit_tracker_widget_config"
        private const val PREF_TRACKER_ID = "tracker_id"
        private const val PREF_INCLUDE_CRAVING = "include_craving"
        private const val KEY_TRACKERS_LIST = "widget_trackers_list"
    }
}
