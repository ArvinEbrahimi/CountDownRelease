# iOS Widget / Live Activity — finish setup in Xcode (macOS required)

This folder has the Swift source ready to go, but Xcode's project file
(`Runner.xcodeproj/project.pbxproj`) has to be edited by Xcode itself to add
a new target — hand-editing it blind on a non-Mac machine risks corrupting
the project, so that one step is left for you on a Mac.

## 1. Add the Widget Extension target
In Xcode: **File > New > Target… > Widget Extension**, name it
`SprintCountdownWidget`, uncheck "Include Live Activity" (it's already
written), uncheck "Include Configuration App Intent". When Xcode asks to
replace files, point it at the files already in this folder instead of
letting it generate new ones (or just delete the generated ones and add
these via "Add Files to Runner…").

## 2. Enable App Groups on both targets
Select the **Runner** target → *Signing & Capabilities* → **+ Capability**
→ **App Groups** → add `group.com.sprint.countdown`.
Repeat for the **SprintCountdownWidget** target.
(The entitlements files in this repo already declare the group — Xcode
just needs the capability turned on so it signs with it.)

## 3. Confirm the bundle ID
The widget extension's bundle id should be
`com.sprint.countdown.SprintCountdownWidget` (Runner's id + suffix).

## 4. Wire Dart → Live Activity (optional, for Lock Screen/Dynamic Island)
`ActivityKit` can't be driven directly from Dart. Add the
[`live_activities`](https://pub.dev/packages/live_activities) package and
start/update/end the activity with the same `SprintCountdownAttributes`
shape defined in `SprintCountdownLiveActivity.swift` whenever the user
turns on "Lock Screen countdown" in the app's settings.

## 5. Build
`flutter build ios` (or run from Xcode) once the above is done. The home
widget already works without step 4 — it reads `target_epoch_ms` from the
shared `UserDefaults` written by `HomeWidgetBridge.pushTarget`.
