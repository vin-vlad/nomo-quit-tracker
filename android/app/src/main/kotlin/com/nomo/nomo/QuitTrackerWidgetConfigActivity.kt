package com.nomo.nomo

import android.app.Activity
import android.appwidget.AppWidgetManager
import android.content.Context
import android.content.Intent
import android.os.Bundle
import android.widget.ArrayAdapter
import android.widget.CheckBox
import android.widget.Spinner
import es.antonborri.home_widget.HomeWidgetPlugin
import org.json.JSONArray

class QuitTrackerWidgetConfigActivity : Activity() {

    private var appWidgetId = AppWidgetManager.INVALID_APPWIDGET_ID

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)

        val config = intent?.extras
        appWidgetId = config?.getInt(
            AppWidgetManager.EXTRA_APPWIDGET_ID,
            AppWidgetManager.INVALID_APPWIDGET_ID,
        ) ?: AppWidgetManager.INVALID_APPWIDGET_ID

        if (appWidgetId == AppWidgetManager.INVALID_APPWIDGET_ID) {
            finish()
            return
        }

        setContentView(R.layout.activity_quit_tracker_widget_config)

        val trackersJson = HomeWidgetPlugin.getData(this).getString(KEY_TRACKERS_LIST, null)
        val trackers = parseTrackers(trackersJson)

        val spinner = findViewById<Spinner>(R.id.config_tracker_spinner)
        val includeCravingCheck = findViewById<CheckBox>(R.id.config_include_craving)
        includeCravingCheck.isChecked = true

        if (trackers.isEmpty()) {
            val adapter = ArrayAdapter(
                this,
                android.R.layout.simple_spinner_item,
                listOf(getString(R.string.widget_default_tracker_name)),
            )
            adapter.setDropDownViewResource(android.R.layout.simple_spinner_dropdown_item)
            spinner.adapter = adapter
        } else {
            val names = trackers.map { it.name }
            val adapter = ArrayAdapter(
                this,
                android.R.layout.simple_spinner_item,
                names,
            )
            adapter.setDropDownViewResource(android.R.layout.simple_spinner_dropdown_item)
            spinner.adapter = adapter
        }

        findViewById<android.widget.Button>(R.id.config_done).setOnClickListener {
            val selectedIndex = spinner.selectedItemPosition
            val trackerId = if (trackers.isNotEmpty() && selectedIndex in trackers.indices) {
                trackers[selectedIndex].id
            } else {
                null
            }
            val includeCraving = includeCravingCheck.isChecked

            val prefs = getSharedPreferences(PREFS_CONFIG, Context.MODE_PRIVATE)
            prefs.edit()
                .putString("${PREF_TRACKER_ID}_$appWidgetId", trackerId)
                .putBoolean("${PREF_INCLUDE_CRAVING}_$appWidgetId", includeCraving)
                .apply()

            val resultValue = Intent().putExtra(AppWidgetManager.EXTRA_APPWIDGET_ID, appWidgetId)
            setResult(RESULT_OK, resultValue)
            finish()
        }
    }

    private fun parseTrackers(json: String?): List<TrackerItem> {
        if (json.isNullOrBlank()) return emptyList()
        return try {
            val arr = JSONArray(json)
            (0 until arr.length()).map { i ->
                val obj = arr.getJSONObject(i)
                TrackerItem(
                    id = obj.optString("id", ""),
                    name = obj.optString("name", "Tracker"),
                )
            }
        } catch (e: Exception) {
            emptyList()
        }
    }

    private data class TrackerItem(val id: String, val name: String)

    companion object {
        private const val PREFS_CONFIG = "quit_tracker_widget_config"
        private const val PREF_TRACKER_ID = "tracker_id"
        private const val PREF_INCLUDE_CRAVING = "include_craving"
        private const val KEY_TRACKERS_LIST = "widget_trackers_list"
    }
}
