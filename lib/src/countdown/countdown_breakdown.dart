/// A snapshot of remaining time, broken into display units.
class CountdownBreakdown {
  const CountdownBreakdown({
    required this.days,
    required this.hours,
    required this.minutes,
    required this.seconds,
    required this.isComplete,
  });

  final int days;
  final int hours;
  final int minutes;
  final int seconds;
  final bool isComplete;

  factory CountdownBreakdown.fromDuration(Duration remaining) {
    if (remaining.isNegative) {
      return const CountdownBreakdown(
        days: 0,
        hours: 0,
        minutes: 0,
        seconds: 0,
        isComplete: true,
      );
    }
    return CountdownBreakdown(
      days: remaining.inDays,
      hours: remaining.inHours % 24,
      minutes: remaining.inMinutes % 60,
      seconds: remaining.inSeconds % 60,
      isComplete: false,
    );
  }
}
