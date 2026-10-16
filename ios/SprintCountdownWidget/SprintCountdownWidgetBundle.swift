import WidgetKit
import SwiftUI

@main
struct SprintCountdownWidgetBundle: WidgetBundle {
    var body: some Widget {
        SprintCountdownWidget()
        SprintCountdownLiveActivity()
    }
}
