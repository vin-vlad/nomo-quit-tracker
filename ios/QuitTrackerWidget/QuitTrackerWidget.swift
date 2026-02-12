import WidgetKit
import SwiftUI

// MARK: - App Group (must match Flutter WidgetConstants.appGroupId)
private let appGroupId = "group.com.nomo.nomo"

// MARK: - Timeline Entry
struct QuitTrackerEntry: TimelineEntry {
    let date: Date
    let trackerId: String?
    let trackerName: String
    let elapsed: String
    let includeCravingButton: Bool
}

// MARK: - Provider
struct QuitTrackerProvider: TimelineProvider {
    func placeholder(in context: Context) -> QuitTrackerEntry {
        QuitTrackerEntry(
            date: Date(),
            trackerId: nil,
            trackerName: "Tracker",
            elapsed: "—",
            includeCravingButton: false
        )
    }

    func getSnapshot(in context: Context, completion: @escaping (QuitTrackerEntry) -> Void) {
        let entry = loadEntry()
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<QuitTrackerEntry>) -> Void) {
        let entry = loadEntry()
        let timeline = Timeline(entries: [entry], policy: .atEnd)
        completion(timeline)
    }

    private func loadEntry() -> QuitTrackerEntry {
        let prefs = UserDefaults(suiteName: appGroupId)
        let trackerId = prefs?.string(forKey: "widget_tracker_id")
        let trackerName = prefs?.string(forKey: "widget_tracker_name") ?? "Open app to set up"
        let elapsed = prefs?.string(forKey: "widget_elapsed") ?? "—"
        let includeCraving = prefs?.object(forKey: "widget_include_craving") as? Bool ?? true
        return QuitTrackerEntry(
            date: Date(),
            trackerId: trackerId,
            trackerName: trackerName,
            elapsed: elapsed,
            includeCravingButton: includeCraving
        )
    }
}

// MARK: - View
struct QuitTrackerWidgetEntryView: View {
    var entry: QuitTrackerEntry

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(entry.trackerName)
                .font(.caption)
                .foregroundStyle(.secondary)
            Text(entry.elapsed)
                .font(.title2)
                .fontWeight(.bold)
            if entry.includeCravingButton, let trackerId = entry.trackerId {
                Spacer(minLength: 0)
                HStack {
                    Spacer()
                    Text("Log craving")
                        .font(.caption)
                        .foregroundStyle(.red)
                }
            }
        }
        .padding()
        .widgetURL(widgetURL)
        .modifier(ContainerBackgroundModifier())
    }

    private var widgetURL: URL? {
        guard let trackerId = entry.trackerId else {
            return URL(string: "nomo://")
        }
        return URL(string: "nomo://widget/log-craving?trackerId=\(trackerId)")
    }
}

struct ContainerBackgroundModifier: ViewModifier {
    func body(content: Content) -> some View {
        if #available(iOS 17.0, *) {
            content.containerBackground(Color.white, for: .widget)
        } else {
            content.background(Color.white)
        }
    }
}

// MARK: - Widget
struct QuitTrackerWidget: Widget {
    let kind: String = "QuitTrackerWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: QuitTrackerProvider()) { entry in
            QuitTrackerWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("Quit Tracker")
        .description("Track your time smoke-free and log cravings.")
        .supportedFamilies([.systemSmall, .systemMedium])
    }
}

// MARK: - Preview
#Preview(as: .systemSmall) {
    QuitTrackerWidget()
} timeline: {
    QuitTrackerEntry(
        date: Date(),
        trackerId: "1",
        trackerName: "Smoking",
        elapsed: "5d 3h 2m",
        includeCravingButton: true
    )
}
