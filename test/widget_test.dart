import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:sprint_countdown/src/app.dart';
import 'package:sprint_countdown/src/countdown/countdown_controller.dart';
import 'package:sprint_countdown/src/countdown/countdown_target.dart';
import 'package:sprint_countdown/src/settings/settings_store.dart';

void main() {
  testWidgets('renders the countdown units', (WidgetTester tester) async {
    SharedPreferences.setMockInitialValues({});
    final settings = await SettingsStore.load();
    final controller = CountdownController(
      CountdownTarget.fromEpochMs(
        DateTime.now().toUtc().add(const Duration(days: 10)).millisecondsSinceEpoch,
      ),
    );

    await tester.pumpWidget(SprintCountdownApp(controller: controller, settings: settings));
    await tester.pump();

    expect(find.text('DAYS'), findsOneWidget);
    expect(find.text('HOURS'), findsOneWidget);
    expect(find.text('MIN'), findsOneWidget);
    expect(find.text('SEC'), findsOneWidget);

    controller.dispose();
  });
}
