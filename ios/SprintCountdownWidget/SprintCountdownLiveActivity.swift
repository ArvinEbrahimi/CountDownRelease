import ActivityKit
import SwiftUI
import WidgetKit

/// Shared attributes describing a running Sprint launch countdown Live
/// Activity. The main app starts/updates/ends this activity (typically via
/// a Flutter plugin bridge such as `live_activities`) whenever the user
/// enables "Lock Screen / Dynamic Island countdown" in Settings.
struct SprintCountdownAttributes: ActivityAttributes {
    public struct ContentState: Codable, Hashable {
        /// Milliseconds since epoch (UTC) for the launch moment.
        var targetEpochMs: Double
    }

    var eventTitle: String
}

struct SprintCountdownLiveActivity: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: SprintCountdownAttributes.self) { context in
            let target = Date(timeIntervalSince1970: context.state.targetEpochMs / 1000)

            HStack {
                VStack(alignment: .leading, spacing: 2) {
                    Text(context.attributes.eventTitle)
                        .font(.caption.weight(.semibold))
                        .foregroundColor(Color(red: 0.2, green: 0.9, blue: 0.9))
                    Text(target, style: .relative)
                        .font(.title2.weight(.bold))
                        .foregroundColor(.white)
                }
                Spacer()
            }
            .padding()
            .activityBackgroundTint(Color(red: 0.02, green: 0.03, blue: 0.05))
            .activitySystemActionForegroundColor(.white)
        } dynamicIsland: { context in
            let target = Date(timeIntervalSince1970: context.state.targetEpochMs / 1000)

            return DynamicIsland {
                DynamicIslandExpandedRegion(.leading) {
                    Text(context.attributes.eventTitle)
                        .foregroundColor(Color(red: 0.2, green: 0.9, blue: 0.9))
                }
                DynamicIslandExpandedRegion(.trailing) {
                    Text(target, style: .relative)
                        .foregroundColor(.white)
                }
            } compactLeading: {
                Text("🚀")
            } compactTrailing: {
                Text(target, style: .timer)
                    .foregroundColor(.white)
            } minimal: {
                Text("🚀")
            }
        }
    }
}
